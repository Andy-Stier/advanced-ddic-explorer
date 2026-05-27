*&---------------------------------------------------------------------*
*& Report ZASC_DDIC_EXPLORER_FREE
*&---------------------------------------------------------------------*
*& Advanced DDIC Explorer (Free)
*&---------------------------------------------------------------------*
REPORT zasc_ddic_explorer_free.

* See https://github.com/Andy-Stier/advanced-ddic-explorer

********************************************************************************
* MIT License
*
* Copyright (c) 2026 Andy-Stier
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
********************************************************************************

TABLES sscrfields.
INCLUDE <icon>.

CLASS lcl_app         DEFINITION DEFERRED.
CLASS lcl_view_base   DEFINITION DEFERRED.
CLASS lcl_gui_handler DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-EVENTS:
      at_output,
      at_input EXPORTING VALUE(ucomm) TYPE sscrfields-ucomm,
      at_exit  EXPORTING VALUE(ucomm) TYPE sscrfields-ucomm.

    TYPES type_appid TYPE sy-dynnr.

    CONSTANTS:
      BEGIN OF enum_appid,
        start TYPE type_appid VALUE 1001,
      END OF enum_appid.

    CLASS-METHODS:
      on_initialization,
      on_at_output,
      on_at_input,
      on_at_exit,
      on_start.

  PRIVATE SECTION.
    CLASS-METHODS:
      start_app IMPORTING i_appid TYPE type_appid RETURNING VALUE(r_app) TYPE REF TO lcl_app.

    CLASS-DATA:
      app TYPE REF TO lcl_app.
ENDCLASS.

PARAMETERS:
  p_table TYPE tabname  NO-DISPLAY,
  p_langu TYPE sy-langu NO-DISPLAY DEFAULT sy-langu.

SELECTION-SCREEN BEGIN OF SCREEN 1001 TITLE title1.
SELECTION-SCREEN END OF SCREEN 1001.

INITIALIZATION.
  lcl_gui_handler=>on_initialization( ).

AT SELECTION-SCREEN OUTPUT.
  lcl_gui_handler=>on_at_output( ).

AT SELECTION-SCREEN.
  lcl_gui_handler=>on_at_input( ).

AT SELECTION-SCREEN ON EXIT-COMMAND.
  lcl_gui_handler=>on_at_exit( ).

START-OF-SELECTION.
  lcl_gui_handler=>on_start( ).


CLASS lcl_ddic_table      DEFINITION DEFERRED.
CLASS lcl_ddic_table_base DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_instance_ident,
        tabname TYPE tabname,
        langu   TYPE sy-langu,
        ref     TYPE REF TO lcl_ddic_table,
      END OF type_instance_ident,
      type_instance_ident_tab TYPE STANDARD TABLE OF type_instance_ident WITH UNIQUE SORTED KEY key COMPONENTS tabname langu,
      type_tabname_range      TYPE RANGE OF dd02l-tabname,
      type_tabname_tab        TYPE STANDARD TABLE OF dd02l-tabname WITH DEFAULT KEY.

    CLASS-METHODS:
      get_instance      IMPORTING i_tabname TYPE tabname i_langu TYPE sy-langu RETURNING VALUE(r_result) TYPE type_instance_ident.

    METHODS constructor
      IMPORTING
        i_langu TYPE sy-langu.

  PROTECTED SECTION.
    CLASS-DATA:
      instances TYPE type_instance_ident_tab.

    CLASS-METHODS:
      add_instance IMPORTING i_instance_ident TYPE type_instance_ident.

    DATA:
      mv_langu  TYPE sy-langu,
      mv_loaded TYPE abap_bool.
ENDCLASS.

CLASS lcl_ddic_table_base IMPLEMENTATION.
  METHOD add_instance.
    READ TABLE instances TRANSPORTING NO FIELDS WITH TABLE KEY tabname = i_instance_ident-tabname langu = i_instance_ident-langu.
    IF ( sy-subrc <> 0 ).
      INSERT i_instance_ident INTO TABLE instances.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    mv_langu = COND #( WHEN i_langu IS INITIAL THEN sy-langu ELSE i_langu ).
  ENDMETHOD.

  METHOD get_instance.
    READ TABLE instances INTO r_result WITH TABLE KEY tabname = i_tabname langu = i_langu.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_table DEFINITION INHERITING FROM lcl_ddic_table_base CREATE PRIVATE .
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_texttable_ref,
        tabname   TYPE dd08v-tabname,
        fieldname TYPE dd08v-fieldname,
        ref       TYPE REF TO lcl_ddic_table,
      END OF type_texttable_ref,

      type_header    TYPE dd02v,
      type_devclass  TYPE tdevct,
      type_settings  TYPE dd09v,
      type_field     TYPE dd03p,
      type_field_tab TYPE STANDARD TABLE OF type_field WITH DEFAULT KEY.

    CLASS-METHODS:
      create_instance   IMPORTING i_tabname TYPE dd02l-tabname i_langu TYPE sy-langu
                        RETURNING VALUE(ro_instance) TYPE REF TO lcl_ddic_table.
    METHODS:
      constructor       IMPORTING i_tabname TYPE dd02l-tabname i_langu TYPE sy-langu,
      load_metadata,
      get_header        RETURNING VALUE(r_result)  TYPE type_header,
      get_devclass      RETURNING VALUE(r_result)  TYPE type_devclass,
      get_settings      RETURNING VALUE(r_result)  TYPE type_settings,
      get_fields        IMPORTING i_with_includes  TYPE abap_bool DEFAULT abap_true
                        RETURNING VALUE(r_results) TYPE type_field_tab,
      get_texttable_ref RETURNING VALUE(r_result)  TYPE REF TO lcl_ddic_table.

  PRIVATE SECTION.
    METHODS:
      read_header,
      read_devclass.

    DATA:
      m_tabname   TYPE dd02l-tabname,
      m_texttable TYPE type_texttable_ref,

      BEGIN OF m_table_data,
        header         TYPE type_header,
        devclass       TYPE type_devclass,
        techn_settings TYPE type_settings,
        object_state   TYPE ddgotstate,
        fields         TYPE type_field_tab,
      END OF m_table_data.
ENDCLASS.

CLASS lcl_ddic_table IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_langu ).
    m_tabname = i_tabname.
    read_header( ).
  ENDMETHOD.

  METHOD create_instance.
    DATA(ls_instance) = get_instance( i_tabname = i_tabname i_langu = i_langu ).
    IF ( ls_instance IS INITIAL ).
      ls_instance-tabname = i_tabname.
      ls_instance-langu   = i_langu.
      ls_instance-ref     = NEW lcl_ddic_table( i_tabname = i_tabname i_langu = i_langu ).

      add_instance( ls_instance ).
    ENDIF.

    ro_instance = ls_instance-ref.
  ENDMETHOD.

  METHOD get_header.
    r_result = m_table_data-header.
  ENDMETHOD.

  METHOD get_devclass.
    r_result = m_table_data-devclass.
  ENDMETHOD.

  METHOD get_settings.
    r_result = m_table_data-techn_settings.
  ENDMETHOD.

  METHOD get_fields.
    r_results = m_table_data-fields.
    IF ( i_with_includes = abap_false ).
      DELETE r_results WHERE fieldname CP '.INCLU*'.
    ENDIF.
  ENDMETHOD.

  METHOD get_texttable_ref.
    r_result = m_texttable-ref.
  ENDMETHOD.

  METHOD load_metadata.
    DATA ls_checktable_header LIKE m_table_data-header.
    IF ( mv_loaded = abap_false ).
      CALL FUNCTION 'DDIF_TABL_GET'
        EXPORTING
          name          = m_tabname
          state         = 'A'
          langu         = mv_langu
        IMPORTING
          gotstate      = m_table_data-object_state
          dd02v_wa      = m_table_data-header
          dd09l_wa      = m_table_data-techn_settings
        TABLES
          dd03p_tab     = m_table_data-fields
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF ( sy-subrc = 0 ).
        mv_loaded = abap_true.

        " Re-read devclass since load_metadata overwrites the header
        read_devclass( ).

        " Search texttable
        CALL FUNCTION 'DDUT_TEXTTABLE_GET'
          EXPORTING
            tabname    = m_table_data-header-tabname
          IMPORTING
            texttable  = m_texttable-tabname
            checkfield = m_texttable-fieldname.

        IF ( m_texttable-tabname IS NOT INITIAL ).
          m_texttable-ref = NEW #( i_tabname = m_texttable-tabname i_langu = mv_langu ).
          m_texttable-ref->load_metadata( ).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read_header.
    CALL FUNCTION 'DDIF_TABL_GET'
      EXPORTING
        name          = m_tabname
        state         = 'A'
        langu         = mv_langu
      IMPORTING
        dd02v_wa      = m_table_data-header
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF ( sy-subrc = 0 ).
      read_devclass( ).
    ENDIF.
  ENDMETHOD.

  METHOD read_devclass.
    DATA(lv_object)   = COND tadir-object( WHEN m_table_data-header-tabclass = 'VIEW' THEN 'VIEW' ELSE 'TABL' ).
    DATA(lv_obj_name) = CONV tadir-obj_name( m_table_data-header-tabname ).
    SELECT SINGLE a~devclass, c~spras, c~ctext
        FROM tadir AS a LEFT OUTER JOIN tdevct AS c ON a~devclass = c~devclass AND c~spras = @mv_langu
      INTO @m_table_data-devclass
      WHERE a~pgmid = 'R3TR' AND a~object = @lv_object AND a~obj_name = @lv_obj_name.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_filter_toolbar DEFINITION DEFERRED.
CLASS lcl_filter_button DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    EVENTS:
      function_added EXPORTING VALUE(fcode) TYPE ui_func VALUE(checked) TYPE abap_bool.

    CLASS-METHODS:
      reverse_checked      IMPORTING checked            TYPE abap_bool
                           RETURNING VALUE(rv_reversed) TYPE abap_bool,
      get_icon_by_checked  IMPORTING checked        TYPE abap_bool
                           RETURNING VALUE(rv_icon) TYPE iconname.
    METHODS:
      constructor     IMPORTING parent      TYPE REF TO cl_gui_toolbar
                                fcode       TYPE ui_func
                                icon        TYPE c
                                butn_type   TYPE tb_btype
                                text        TYPE text40
                                quickinfo   TYPE iconquick
                                is_disabled TYPE abap_bool
                                is_checked  TYPE abap_bool,
      get_button_type FINAL RETURNING VALUE(rv_button_type) TYPE i,
      get_fcode       RETURNING VALUE(rv_fcode)   TYPE ui_func,
      get_checked     RETURNING VALUE(rv_checked) TYPE abap_bool,
      set_checked     IMPORTING i_checked         TYPE abap_bool,
      get_icon        RETURNING VALUE(rv_icon)    TYPE iconname,
      set_icon        IMPORTING i_icon            TYPE iconname.

  PROTECTED SECTION.
    CONSTANTS:
      BEGIN OF con_button_icon,
        checked   TYPE iconname VALUE icon_okay,
        unchecked TYPE iconname VALUE icon_incomplete,
      END OF con_button_icon.

    DATA:
      mo_parent    TYPE REF TO cl_gui_toolbar,
      mv_fcode     TYPE ui_func,
      mv_icon      TYPE iconname,
      mv_butn_type TYPE tb_btype,
      mv_text      TYPE text40,
      mv_quickinfo TYPE iconquick,
      mv_disabled  TYPE abap_bool,
      mv_checked   TYPE abap_bool.
ENDCLASS.

CLASS lcl_filter_button IMPLEMENTATION.
  METHOD constructor.
    mo_parent    = parent.
    mv_fcode     = fcode.
    mv_icon      = icon.
    mv_butn_type = butn_type.
    mv_text      = text.
    mv_quickinfo = quickinfo.
    mv_disabled  = is_disabled.
    mv_checked   = is_checked.

    mo_parent->add_button(
      icon        = mv_icon
      fcode       = mv_fcode
      butn_type   = mv_butn_type
      is_disabled = mv_disabled
      is_checked  = mv_checked
      text        = mv_text
      quickinfo   = mv_quickinfo ).

    RAISE EVENT function_added EXPORTING fcode = mv_fcode checked = mv_checked.
  ENDMETHOD.

  METHOD get_button_type.
    rv_button_type = mv_butn_type.
  ENDMETHOD.

  METHOD get_fcode.
    rv_fcode = mv_fcode.
  ENDMETHOD.

  METHOD get_checked.
    rv_checked = mv_checked.
  ENDMETHOD.

  METHOD set_checked.
    mv_checked = i_checked.
  ENDMETHOD.

  METHOD get_icon.
    rv_icon = mv_icon.
  ENDMETHOD.

  METHOD set_icon.
    mv_icon = i_icon.
  ENDMETHOD.

  METHOD reverse_checked.
    rv_reversed = COND #( WHEN checked = abap_true THEN abap_false ELSE abap_true ).
  ENDMETHOD.

  METHOD get_icon_by_checked.
    rv_icon = COND iconname( WHEN checked = abap_true THEN con_button_icon-checked ELSE con_button_icon-unchecked ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_filter_check_button DEFINITION CREATE PUBLIC INHERITING FROM lcl_filter_button.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING parent      TYPE REF TO cl_gui_toolbar
                            fcode       TYPE ui_func
                            text        TYPE text40
                            quickinfo   TYPE iconquick
                            is_disabled TYPE abap_bool OPTIONAL
                            is_checked  TYPE abap_bool.
ENDCLASS.

CLASS lcl_filter_check_button IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      parent      = parent
      fcode       = fcode
      icon        = get_icon_by_checked( is_checked )
      butn_type   = cntb_btype_check
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_filter_dropdown_button DEFINITION CREATE PUBLIC INHERITING FROM lcl_filter_button.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_menu_item,
        fcode   TYPE ui_func,
        checked TYPE abap_bool,
        text    TYPE text40,
      END OF type_menu_item,
      type_menu_items TYPE STANDARD TABLE OF type_menu_item WITH DEFAULT KEY.

    METHODS:
      constructor     IMPORTING parent      TYPE REF TO cl_gui_toolbar
                                fcode       TYPE ui_func
                                icon        TYPE c
                                text        TYPE text40 OPTIONAL
                                quickinfo   TYPE iconquick OPTIONAL
                                is_disabled TYPE abap_bool OPTIONAL
                                is_checked  TYPE abap_bool,
      add_menu_item    IMPORTING fcode   TYPE type_menu_item-fcode
                                 text    TYPE type_menu_item-text
                                 checked TYPE type_menu_item-checked,
      get_menu_items   RETURNING VALUE(rt_items) TYPE type_menu_items,
      update_menu_item IMPORTING i_fcode   TYPE ui_func
                                 i_checked TYPE abap_bool,
      set_position     IMPORTING i_posx TYPE i
                                 i_posy TYPE i,
      build_menu.

    DATA:
      mo_menu  TYPE REF TO cl_ctmenu READ-ONLY,
      mv_pos_x TYPE i                READ-ONLY,
      mv_pos_y TYPE i                READ-ONLY.

  PRIVATE SECTION.
    DATA:
      mt_menu_items TYPE STANDARD TABLE OF type_menu_item.
ENDCLASS.

CLASS lcl_filter_dropdown_button IMPLEMENTATION.
  METHOD constructor.
    super->constructor(
      parent      = parent
      fcode       = fcode
      icon        = icon
      butn_type   = cntb_btype_dropdown
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    mo_menu = NEW #( ).
  ENDMETHOD.

  METHOD add_menu_item.
    APPEND VALUE #( fcode = fcode text = text checked = checked ) TO mt_menu_items.
    build_menu( ).

    RAISE EVENT function_added EXPORTING fcode = fcode checked = checked.
  ENDMETHOD.

  METHOD get_menu_items.
    rt_items = mt_menu_items.
  ENDMETHOD.

  METHOD update_menu_item.
    READ TABLE mt_menu_items ASSIGNING FIELD-SYMBOL(<menu_item>) WITH KEY fcode = i_fcode.
    IF ( sy-subrc = 0 ).
      <menu_item>-checked = i_checked.
    ENDIF.
  ENDMETHOD.

  METHOD set_position.
    mv_pos_x = i_posx.
    mv_pos_y = i_posy.
  ENDMETHOD.

  METHOD build_menu.
    mo_menu->clear( ).

    LOOP AT mt_menu_items ASSIGNING FIELD-SYMBOL(<menu_item>).
      mo_menu->add_function(
        fcode   = <menu_item>-fcode
        text    = <menu_item>-text
        checked = <menu_item>-checked ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_filter_toolbar DEFINITION CREATE PUBLIC.
  PUBLIC SECTION.
    EVENTS:
      function_selected EXPORTING VALUE(fcode) TYPE ui_func VALUE(checked) TYPE abap_bool.

    METHODS:
      constructor         IMPORTING parent       TYPE REF TO cl_gui_container
                                    name         TYPE string OPTIONAL
                                    shellstyle   TYPE i OPTIONAL
                                    display_mode TYPE i DEFAULT cl_gui_toolbar=>m_mode_vertical
                                    align_right  TYPE i DEFAULT 0,
      add_button          IMPORTING fcode            TYPE ui_func
                                    icon             TYPE c
                                    butn_type        TYPE tb_btype DEFAULT cntb_btype_button
                                    text             TYPE text40 OPTIONAL
                                    quickinfo        TYPE iconquick OPTIONAL
                                    is_disabled      TYPE abap_bool OPTIONAL
                                    is_checked       TYPE abap_bool OPTIONAL
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_filter_button,
      add_check_button    IMPORTING fcode            TYPE ui_func
                                    text             TYPE text40 OPTIONAL
                                    quickinfo        TYPE iconquick OPTIONAL
                                    is_disabled      TYPE abap_bool OPTIONAL
                                    is_checked       TYPE abap_bool
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_filter_check_button,
      add_dropdown_button IMPORTING fcode            TYPE ui_func
                                    icon             TYPE c
                                    text             TYPE text40 OPTIONAL
                                    quickinfo        TYPE iconquick OPTIONAL
                                    is_disabled      TYPE abap_bool OPTIONAL
                                    is_checked       TYPE abap_bool
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_filter_dropdown_button,
      set_button_attr     IMPORTING fcode      TYPE ui_func
                                    checked    TYPE abap_bool
                                    enabled    TYPE abap_bool DEFAULT abap_true
                                    menu_items TYPE lcl_filter_dropdown_button=>type_menu_items OPTIONAL.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF type_button,
        fcode  TYPE ui_func,
        active TYPE abap_bool,
        button TYPE REF TO lcl_filter_button,
      END OF type_button,
      type_buttons TYPE SORTED TABLE OF type_button WITH UNIQUE KEY fcode.

    METHODS:
      get_active_button    RETURNING VALUE(ro_button) TYPE REF TO lcl_filter_button,
      get_button           IMPORTING fcode            TYPE ui_func
                           RETURNING VALUE(ro_button) TYPE REF TO lcl_filter_button,
      set_button_active    IMPORTING fcode  TYPE ui_func
                                     active TYPE abap_bool DEFAULT abap_true,
      on_function_selected FOR EVENT function_selected OF cl_gui_toolbar IMPORTING fcode sender,
      on_dropdown_clicked  FOR EVENT dropdown_clicked  OF cl_gui_toolbar IMPORTING fcode posx posy sender.

    DATA:
      mo_toolbar TYPE REF TO cl_gui_toolbar,
      mt_buttons TYPE type_buttons.
ENDCLASS.

CLASS lcl_filter_toolbar IMPLEMENTATION.
  METHOD constructor.
    mo_toolbar = NEW cl_gui_toolbar(
      parent       = parent
      shellstyle   = shellstyle
      display_mode = display_mode
      name         = name
      align_right  = align_right ).

    mo_toolbar->set_registered_events(
      VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected )
               ( eventid = cl_gui_toolbar=>m_id_dropdown_clicked ) ) ).

    SET HANDLER on_function_selected FOR mo_toolbar.
    SET HANDLER on_dropdown_clicked  FOR mo_toolbar.
  ENDMETHOD.

  METHOD get_button.
    READ TABLE mt_buttons WITH KEY fcode = fcode INTO DATA(button).
    ro_button = button-button.
  ENDMETHOD.

  METHOD get_active_button.
    READ TABLE mt_buttons WITH KEY active = abap_true INTO DATA(button).
    ro_button = button-button.
  ENDMETHOD.

  METHOD set_button_active.
    LOOP AT mt_buttons ASSIGNING FIELD-SYMBOL(<button>).
      IF ( <button>-fcode = fcode ).
        <button>-active = abap_true.
      ELSE.
        <button>-active = abap_false.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_button_attr.
    DATA:
      button          TYPE REF TO lcl_filter_button,
      check_button    TYPE REF TO lcl_filter_check_button,
      dropdown_button TYPE REF TO lcl_filter_dropdown_button.

    button = get_button( fcode ).
    IF ( button IS NOT INITIAL ).
      CASE button->get_button_type( ).
        WHEN cntb_btype_check.
          check_button ?= button.
          check_button->set_checked( checked ).
          check_button->set_icon( lcl_filter_button=>get_icon_by_checked( check_button->get_checked( ) ) ).
          mo_toolbar->set_button_info(
            fcode = fcode
            icon  = check_button->get_icon( ) ).

          mo_toolbar->set_button_state(
            fcode   = fcode
            enabled = enabled
            checked = check_button->get_checked( ) ).

          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
        WHEN cntb_btype_dropdown.
          dropdown_button ?= button.
          dropdown_button->set_checked( checked ).
          dropdown_button->set_icon( lcl_filter_button=>get_icon_by_checked( dropdown_button->get_checked( ) ) ).
          mo_toolbar->set_button_info(
            fcode = dropdown_button->get_fcode( )
            icon  = dropdown_button->get_icon( ) ).

          mo_toolbar->set_button_state(
            fcode   = fcode
            enabled = abap_true
            checked = dropdown_button->get_checked( ) ).

          DATA item_checked TYPE abap_bool.
          LOOP AT dropdown_button->get_menu_items( ) INTO DATA(button_menu_item).
            READ TABLE menu_items INTO DATA(menu_item) WITH KEY fcode = button_menu_item-fcode.
            IF ( sy-subrc = 0 ).
              item_checked = menu_item-checked.
            ELSE.
              item_checked = abap_false.
            ENDIF.

            dropdown_button->update_menu_item( i_fcode = button_menu_item-fcode i_checked = item_checked ).

            RAISE EVENT function_selected EXPORTING fcode = button_menu_item-fcode checked = item_checked.
          ENDLOOP.

          dropdown_button->build_menu( ).
        WHEN OTHERS.
          " Standard button – forward directly the event
          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD add_check_button.
    ro_button = NEW lcl_filter_check_button(
      parent      = mo_toolbar
      fcode       = fcode
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    INSERT VALUE #( fcode = fcode button = ro_button ) INTO TABLE mt_buttons.
  ENDMETHOD.

  METHOD add_button.
    ro_button = NEW lcl_filter_button(
      parent      = mo_toolbar
      fcode       = fcode
      icon        = icon
      butn_type   = butn_type
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    INSERT VALUE #( fcode = fcode button = ro_button ) INTO TABLE mt_buttons.
  ENDMETHOD.

  METHOD add_dropdown_button.
    ro_button = NEW lcl_filter_dropdown_button(
      parent      = mo_toolbar
      icon        = icon
      fcode       = fcode
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    INSERT VALUE #( fcode = fcode button = ro_button ) INTO TABLE mt_buttons.
  ENDMETHOD.

  METHOD on_function_selected.
    DATA:
      button          TYPE REF TO lcl_filter_button,
      check_button    TYPE REF TO lcl_filter_check_button,
      dropdown_button TYPE REF TO lcl_filter_dropdown_button,
      checked         TYPE abap_bool.

    button = get_button( fcode ).
    IF ( button IS NOT INITIAL ).
      CASE button->get_button_type( ).
        WHEN cntb_btype_check.
          check_button ?= button.
          check_button->set_checked( lcl_filter_button=>reverse_checked( check_button->get_checked( ) ) ).
          checked = check_button->get_checked( ).
          check_button->set_icon( lcl_filter_button=>get_icon_by_checked( check_button->get_checked( ) ) ).
          sender->set_button_info(
            fcode = fcode
            icon  = check_button->get_icon( ) ).

          sender->set_button_state(
            fcode   = fcode
            enabled = abap_true
            checked = check_button->get_checked( ) ).
        WHEN cntb_btype_dropdown.
          dropdown_button ?= button.
          dropdown_button->set_checked( lcl_filter_button=>reverse_checked( dropdown_button->get_checked( ) ) ).
          dropdown_button->set_icon( lcl_filter_button=>get_icon_by_checked( dropdown_button->get_checked( ) ) ).
          sender->set_button_info(
            fcode = dropdown_button->get_fcode( )
            icon  = dropdown_button->get_icon( ) ).

          sender->set_button_state(
            fcode   = fcode
            enabled = abap_true
            checked = dropdown_button->get_checked( ) ).

          LOOP AT dropdown_button->get_menu_items( ) INTO DATA(menu_item).
            dropdown_button->update_menu_item(
              i_fcode   = menu_item-fcode
              i_checked = dropdown_button->get_checked( ) ).

            RAISE EVENT function_selected EXPORTING fcode = menu_item-fcode checked = dropdown_button->get_checked( ).
          ENDLOOP.

          dropdown_button->build_menu( ).

          RETURN. " events already raised for each menu item - no global event!
        WHEN OTHERS.
          " nothing to do - continue the fcode further
      ENDCASE.
    ELSE.
      button = get_active_button( ).
      IF ( button IS INITIAL ).
        RETURN.
      ENDIF.

      TRY.
          dropdown_button ?= button.
          READ TABLE dropdown_button->get_menu_items( ) INTO menu_item WITH KEY fcode = fcode.
          IF ( sy-subrc = 0 ).
            dropdown_button->update_menu_item(
              i_fcode   = menu_item-fcode
              i_checked = lcl_filter_button=>reverse_checked( menu_item-checked ) ).

            checked = lcl_filter_button=>reverse_checked( menu_item-checked ).
          ENDIF.

          dropdown_button->build_menu( ).

          LOOP AT dropdown_button->get_menu_items( ) TRANSPORTING NO FIELDS WHERE checked = abap_true.
            EXIT.
          ENDLOOP.
          IF ( sy-subrc = 0 ).
            dropdown_button->set_icon( lcl_filter_button=>get_icon_by_checked( abap_true ) ).
          ELSE.
            dropdown_button->set_icon( lcl_filter_button=>get_icon_by_checked( abap_false ) ).
          ENDIF.

          sender->set_button_info(
            fcode = dropdown_button->get_fcode( )
            icon  = dropdown_button->get_icon( ) ).

          sender->dispatch( cargo = 'mo_toolbar' eventid = cl_gui_toolbar=>m_id_dropdown_clicked is_shellevent = abap_false ).
          sender->track_context_menu(
            context_menu = dropdown_button->mo_menu
            posx         = dropdown_button->mv_pos_x
            posy         = dropdown_button->mv_pos_y ).
        CATCH cx_sy_move_cast_error.
          RETURN.
      ENDTRY.
    ENDIF.

    RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
  ENDMETHOD.

  METHOD on_dropdown_clicked.
    DATA button TYPE REF TO lcl_filter_dropdown_button.
    TRY.
        button ?= get_button( fcode ).
        IF ( button IS BOUND ).
          set_button_active( fcode ).
          button->set_position( i_posx = posx i_posy = posy ).
        ELSE.
          button ?= get_active_button( ).
        ENDIF.

        IF ( button IS BOUND ).
          mo_toolbar->track_context_menu(
            context_menu = button->mo_menu
            posx         = posx
            posy         = posy ).
        ENDIF.
      CATCH cx_sy_move_cast_error.
        DATA(msg) = |Error in the method ON_DROPDOWN_CLICKED|.
        MESSAGE msg TYPE 'S' DISPLAY LIKE 'E'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

INTERFACE lif_table_tree_control.
  DATA:
    mv_search_by_descr TYPE abap_bool,
    mt_tabname_range   TYPE RANGE OF dd02v-tabname,
    mt_contflag_range  TYPE RANGE OF dd02v-contflag,
    mt_clidep_range    TYPE RANGE OF dd02v-clidep,
    mt_tabclass_range  TYPE RANGE OF dd02v-tabclass.
ENDINTERFACE.

CLASS lcl_ddic_model DEFINITION.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_search_result,
        tabname    TYPE dd02v-tabname,
        ddlanguage TYPE dd02v-ddlanguage,
        tabclass   TYPE dd02v-tabclass,
        ddtext     TYPE dd02v-ddtext,
        devclass   TYPE tadir-devclass,
      END OF type_search_result,
      type_search_results       TYPE STANDARD TABLE OF type_search_result,
      type_search_text_range    TYPE RANGE OF dd02t-ddtext,
      type_search_tabname_range TYPE RANGE OF dd02t-ddtext.

    EVENTS found_tables EXPORTING VALUE(results) TYPE type_search_results.

    CLASS-METHODS:
      build_search_range IMPORTING i_search         TYPE csequence
                         EXPORTING et_text_range    TYPE type_search_text_range
                                   et_tabname_range TYPE type_search_text_range,
      check_tcode_exists      IMPORTING i_tcode TYPE sy-tcode RETURNING VALUE(r_exists) TYPE abap_bool.

    METHODS:
      search_tables IMPORTING i_input   TYPE csequence
                              i_control TYPE REF TO lif_table_tree_control
                              i_langu   TYPE sy-langu.
ENDCLASS.

CLASS lcl_control DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_table_key,
        tabname  TYPE lcl_ddic_table=>type_header-tabname,
        language TYPE lcl_ddic_table=>type_header-ddlanguage,
      END OF type_table_key,
      type_table_keys TYPE STANDARD TABLE OF type_table_key WITH DEFAULT KEY.

    CLASS-EVENTS:
      refresh_content EXPORTING VALUE(tabname) TYPE tabname VALUE(language) TYPE sy-langu,
      delete_content  EXPORTING VALUE(table_keys) TYPE type_table_keys OPTIONAL.

    CLASS-METHODS:
      update_content IMPORTING i_tabname TYPE tabname i_langu TYPE sy-langu,
      clear_content  IMPORTING i_table_keys TYPE type_table_keys OPTIONAL.

  PROTECTED SECTION.
    METHODS:
      get_language_iso FINAL IMPORTING i_langu TYPE sy-langu RETURNING VALUE(rv_lang_iso) TYPE t002-laiso,
      set_child_info   FINAL IMPORTING i_parent TYPE REF TO cl_gui_container.

    DATA:
      mv_child_row TYPE i,
      mv_child_col TYPE i.
ENDCLASS.

CLASS lcl_control IMPLEMENTATION.
  METHOD update_content.
    RAISE EVENT refresh_content EXPORTING tabname = i_tabname language = i_langu.
  ENDMETHOD.

  METHOD clear_content.
    RAISE EVENT delete_content EXPORTING table_keys = i_table_keys.
  ENDMETHOD.

  METHOD get_language_iso.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = i_langu
      IMPORTING
        output = rv_lang_iso.
  ENDMETHOD.

  METHOD set_child_info.
    DATA(parent) = i_parent.
    WHILE parent IS BOUND.
      TRY.
          DATA(parent_splitter) = CAST cl_gui_splitter_container( parent ).
          parent_splitter->get_rows(    IMPORTING result = DATA(row_count) ).
          parent_splitter->get_columns( IMPORTING result = DATA(col_count) ).

          DO row_count TIMES.
            mv_child_row = sy-index.
            DO col_count TIMES.
              mv_child_col = sy-index.
              DATA(container) = parent_splitter->get_container( row = mv_child_row column = mv_child_col ).
              IF ( container = i_parent ).
                EXIT.
              ELSE.
                CLEAR container.
              ENDIF.
            ENDDO.
            IF ( container = i_parent ).
              EXIT.
            ENDIF.
          ENDDO.
        CATCH cx_sy_move_cast_error .
      ENDTRY.

      IF ( container = i_parent ).
        EXIT.
      ENDIF.

      parent = parent->parent.
    ENDWHILE.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_table_control DEFINITION INHERITING FROM lcl_control.
  PUBLIC SECTION.
    INTERFACES:
      lif_table_tree_control.

    CONSTANTS:
      BEGIN OF con_container_name,
        root_container TYPE string VALUE 'ROOT',
      END OF con_container_name,

      BEGIN OF con_control_name,
        toolbar_filter    TYPE string VALUE 'TABLE_FILTER',
        input_search      TYPE string VALUE 'TABLE_SEARCH',
        input_filter_name TYPE string VALUE 'TABLE_FILTER_NAME',
      END OF con_control_name,

      BEGIN OF con_fcode,
        select_language    TYPE ui_func VALUE 'LANGUAGE',
        filter_defaults    TYPE ui_func VALUE 'DEFAULTS',
        button_category    TYPE ui_func VALUE 'TABLE_CATEGORY',
        tabclass_transp    TYPE ui_func VALUE 'TRANSP',
        tabclass_view      TYPE ui_func VALUE 'VIEW',
        tabclass_cluster   TYPE ui_func VALUE 'CLUSTER',
        tabclass_pool      TYPE ui_func VALUE 'POOL',
        tabclass_struct    TYPE ui_func VALUE 'INTTAB',
        tabclass_append    TYPE ui_func VALUE 'APPEND',
        button_delivery    TYPE ui_func VALUE 'TABLE_DELIVERY',
        delivery_appl      TYPE ui_func VALUE 'A',
        delivery_cust      TYPE ui_func VALUE 'C',
        delivery_contr     TYPE ui_func VALUE 'E',
        delivery_syst      TYPE ui_func VALUE 'W',
        button_customer    TYPE ui_func VALUE 'FILTER_BY_CUSTOMER_TABLE',
        button_client      TYPE ui_func VALUE 'FILTER_BY_CLIENT_SPECIFIC',
        button_search_desc TYPE ui_func VALUE 'SEARCH_TABLE_BY_TEXT',
      END OF con_fcode,

      BEGIN OF con_salv_function,
        delete_item TYPE salv_de_function VALUE 'DELETE_ITEM',
        se11        TYPE salv_de_function VALUE 'SE11',
        se16        TYPE salv_de_function VALUE 'SE16',
        se16n       TYPE salv_de_function VALUE 'SE16N',
        export_html TYPE salv_de_function VALUE 'EXPORT_HTML',  " for future
      END OF con_salv_function.

    EVENTS:
      table_selected EXPORTING VALUE(tabname) TYPE tabname VALUE(language) TYPE sy-langu,
      items_deleted  EXPORTING VALUE(selected_items) TYPE type_table_keys,
      all_items_deleted.

    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu,
      create      IMPORTING i_parent TYPE REF TO cl_gui_container.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF type_table_data,
        class      TYPE iconname,
        stat       TYPE iconname,
        tabname    TYPE lcl_ddic_table=>type_header-tabname,
        ddlanguage TYPE lcl_ddic_table=>type_header-ddlanguage,
        ddtext     TYPE lcl_ddic_table=>type_header-ddtext,
        tabclass   TYPE lcl_ddic_table=>type_header-tabclass,
        current    TYPE abap_bool,
      END OF type_table_data.

    CONSTANTS:
      BEGIN OF enum_view_pos_x,
        center TYPE i VALUE 1,
        left   TYPE i VALUE 2,
      END OF enum_view_pos_x.

    METHODS:
      on_search
        FOR EVENT submit OF cl_gui_input_field IMPORTING input sender,
      on_found_tables
        FOR EVENT found_tables OF lcl_ddic_model IMPORTING results sender,
      on_filter_selected
        FOR EVENT function_selected OF lcl_filter_toolbar IMPORTING fcode checked sender,
      on_filter_fcode_added
        FOR EVENT function_added OF lcl_filter_button IMPORTING fcode checked sender,
      on_salv_double_click
        FOR EVENT double_click OF cl_salv_events_table IMPORTING row column sender,
      on_salv_toolbar_click
        FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function sender,
      on_select_setup_toolbar
        FOR EVENT function_selected OF cl_gui_toolbar IMPORTING fcode sender,

      get_current_line  RETURNING VALUE(current_line) TYPE type_table_data,
      set_filter_defaults,
      set_filter_ranges IMPORTING i_function TYPE csequence
                                  i_checked  TYPE abap_bool.

    DATA:
      mo_toolbar_filter TYPE REF TO lcl_filter_toolbar,
      mo_salv           TYPE REF TO cl_salv_table,
      mt_salv_output    TYPE STANDARD TABLE OF type_table_data,
      mv_language       TYPE sy-langu,
      mv_view_position  TYPE i.
ENDCLASS.

CLASS lcl_table_bar_control DEFINITION INHERITING FROM lcl_control.
  PUBLIC SECTION.
    METHODS:
      create IMPORTING i_parent TYPE REF TO cl_gui_container.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF type_output_simple,
        fieldtext TYPE scrtext_l,
        value     TYPE as4text,
      END OF type_output_simple,
      type_output_simple_tab TYPE STANDARD TABLE OF type_output_simple WITH DEFAULT KEY.

    METHODS:
      get_structure_fields_for    IMPORTING i_structure      TYPE data
                                  RETURNING VALUE(rt_fields) TYPE type_output_simple_tab,
      get_structure_fields        IMPORTING i_structure         TYPE data
                                            i_struct_components TYPE cl_abap_structdescr=>component_table
                                  RETURNING VALUE(rt_fields)    TYPE type_output_simple_tab,
      on_refresh_content          FOR EVENT refresh_content OF lcl_control IMPORTING tabname language,
      on_delete_content           FOR EVENT delete_content  OF lcl_control IMPORTING table_keys.

    DATA:
      mv_tabname          TYPE tabname,
      mv_language         TYPE sy-langu,
      mo_parent           TYPE REF TO cl_gui_container,
      mo_tabstrip         TYPE REF TO cl_gui_container_bar_2,
      mo_salv_header      TYPE REF TO cl_salv_table,
      mo_salv_settings    TYPE REF TO cl_salv_table,
      mo_salv_fields      TYPE REF TO cl_salv_table,
      mo_salv_texttable_h TYPE REF TO cl_salv_table,
      mt_header           TYPE type_output_simple_tab,
      mt_settings         TYPE type_output_simple_tab,
      mt_fields           TYPE lcl_ddic_table=>type_field_tab,
      mt_texttable_h      TYPE type_output_simple_tab.
ENDCLASS.

CLASS lcl_table_bar_control IMPLEMENTATION.
  METHOD create.
    DEFINE set_salv.
      &1->get_functions( )->set_find( ).
      &1->get_functions( )->set_export_html( ).
      &1->get_functions( )->set_filter( ).
      &1->get_functions( )->set_filter_delete( ).
      &1->get_functions( )->set_export_spreadsheet( ).
      &1->get_functions( )->set_export_localfile( ).
      &1->get_functions( )->set_print( ).
      &1->get_functions( )->set_sort_asc( ).
      &1->get_functions( )->set_sort_desc( ).
      &1->get_functions( )->set_layout_change( ).
      &1->get_functions( )->set_layout_load( ).
      &1->get_functions( )->set_layout_save( ).
      &1->get_display_settings( )->set_striped_pattern( if_salv_c_bool_sap=>true ).
      &1->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).
      &1->display( ).
    END-OF-DEFINITION.

    DATA captions TYPE sbptcaptns.

    mo_parent = i_parent.

    SET HANDLER on_refresh_content.
    SET HANDLER on_delete_content.

    APPEND VALUE #( caption = 'Table Header'     icon = icon_header )         TO captions.
    APPEND VALUE #( caption = 'Table Attributes' icon = icon_table_settings ) TO captions.
    APPEND VALUE #( caption = 'Table Fields'     icon = icon_icon_list )      TO captions.
    APPEND VALUE #( caption = 'Text Table'       icon = icon_wd_text_view )   TO captions.

    mo_tabstrip = NEW cl_gui_container_bar_2(
      active_id = 1
      style     = cl_gui_container_bar_2=>c_style_outlook
      captions  = captions
      parent    = i_parent ).
**********************************************************************

    DATA(container) = mo_tabstrip->get_container( id = 1 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_header
          CHANGING  t_table      = mt_header ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    set_salv mo_salv_header.
**********************************************************************

    container = mo_tabstrip->get_container( id = 2 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_settings
          CHANGING  t_table      = mt_settings ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    set_salv mo_salv_settings.
**********************************************************************

    container = mo_tabstrip->get_container( id = 3 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_fields
          CHANGING  t_table      = mt_fields ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    set_salv mo_salv_fields.
**********************************************************************

    container = mo_tabstrip->get_container( id = 4 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_texttable_h
          CHANGING  t_table      = mt_texttable_h ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    set_salv mo_salv_texttable_h.
**********************************************************************
  ENDMETHOD.

  METHOD get_structure_fields_for.
    TRY.
        DATA(structdescr) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( i_structure ) ).
        rt_fields = get_structure_fields(
          i_structure         = i_structure
          i_struct_components = structdescr->get_components( ) ).
      CATCH cx_sy_move_cast_error.
        " no valide structure type
    ENDTRY.
  ENDMETHOD.

  METHOD get_structure_fields.
    FIELD-SYMBOLS <value> TYPE data.
    LOOP AT i_struct_components INTO DATA(component).
      IF ( component-as_include = abap_true ).
        APPEND LINES OF get_structure_fields(
          i_structure         = i_structure
          i_struct_components = CAST cl_abap_structdescr( component-type )->get_components( ) ) TO rt_fields.
      ELSE.
        ASSIGN COMPONENT component-name OF STRUCTURE i_structure TO <value>.
        IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
          APPEND VALUE #(
            fieldtext = CAST cl_abap_elemdescr( component-type )->get_ddic_field( )-fieldtext
            value     = <value> ) TO rt_fields.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD on_refresh_content.
    DATA:
      visible_ids  TYPE STANDARD TABLE OF i,
      tabledescr   TYPE REF TO cl_abap_tabledescr,
      column_table TYPE REF TO cl_salv_column_table,
      data         TYPE REF TO data,
      is_not_empty TYPE abap_bool.

    FIELD-SYMBOLS:
      <table>     TYPE STANDARD TABLE,
      <value>     TYPE data,
      <data_line> TYPE data.

    DEFINE check_value_empty.
      is_not_empty = if_salv_c_bool_sap=>false.
      LOOP AT <table> ASSIGNING <data_line>.
        ASSIGN COMPONENT &1 OF STRUCTURE <data_line> TO <value>.
        IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
          is_not_empty = if_salv_c_bool_sap=>true. EXIT.
        ENDIF.
      ENDLOOP.
    END-OF-DEFINITION.

    mv_tabname  = tabname.
    mv_language = language.

    IF ( tabname IS NOT INITIAL ).
      mo_tabstrip->get_container( )->parent->set_visible( abap_true ).
    ELSE.
      mo_tabstrip->get_container( )->parent->set_visible( abap_false ).
    ENDIF.

    mo_tabstrip->get_active( IMPORTING id = DATA(active_id) ).
**********************************************************************

    CLEAR mt_header.
    IF ( tabname IS NOT INITIAL ).
      DATA(lo_ddic_table) = lcl_ddic_table_base=>get_instance( i_tabname = tabname i_langu = language )-ref.
      lo_ddic_table->load_metadata( ).

      DATA(table_header)  = lo_ddic_table->get_header( ).
      IF ( table_header-ddtext IS INITIAL ).
        table_header-ddtext = |Description in { get_language_iso( language ) } not available|.
      ENDIF.

      mt_header = get_structure_fields_for( table_header ).

      DATA(table_devclass)  = lo_ddic_table->get_devclass( ).
      IF ( table_devclass-ctext IS INITIAL ).
        table_devclass-ctext = |Description in { get_language_iso( language ) } not available|.
      ENDIF.

      APPEND VALUE #(
        fieldtext = 'Package'
        value     = table_devclass-devclass ) TO mt_header.

      APPEND VALUE #(
        fieldtext = 'Package Description'
        value     = table_devclass-ctext ) TO mt_header.

      IF ( mt_header IS NOT INITIAL ).
        APPEND 1 TO visible_ids.
      ENDIF.
    ENDIF.

    mo_salv_header->refresh( ).

    IF ( mt_header IS NOT INITIAL ).
      mo_tabstrip->set_cell_visible( id = 1 visible = abap_true ).
    ELSE.
      mo_tabstrip->set_cell_visible( id = 1 visible = abap_false ).
    ENDIF.
**********************************************************************

    CLEAR mt_settings.
    IF ( tabname IS NOT INITIAL ).
      DATA(table_settings) = lo_ddic_table->get_settings( ).
      mt_settings = get_structure_fields_for( table_settings ).

      IF ( mt_settings IS NOT INITIAL ).
        APPEND 2 TO visible_ids.
      ENDIF.
    ENDIF.

    mo_salv_settings->refresh( ).

    IF ( mt_settings IS NOT INITIAL ).
      mo_tabstrip->set_cell_visible( id = 2 visible = abap_true ).
    ELSE.
      mo_tabstrip->set_cell_visible( id = 2 visible = abap_false ).
    ENDIF.
**********************************************************************

    CLEAR mt_fields.
    IF ( tabname IS NOT INITIAL ).
      mt_fields = lo_ddic_table->get_fields( ).
      LOOP AT mt_fields ASSIGNING FIELD-SYMBOL(<field>).
        IF ( <field>-ddtext IS INITIAL ).
          <field>-ddtext = |Description in { get_language_iso( language ) } not available|.
        ENDIF.
      ENDLOOP.

      tabledescr = CAST cl_abap_tabledescr( cl_abap_tabledescr=>describe_by_data( mt_fields ) ).
      CREATE DATA data TYPE HANDLE tabledescr.
      ASSIGN data->* TO <table>.
      <table> = mt_fields.

      DATA(columns_table) = mo_salv_fields->get_columns( ).
      DATA(columns) = columns_table->get( ).
      LOOP AT columns INTO DATA(column).
        column_table ?= column-r_column.
        column_table->set_key( if_salv_c_bool_sap=>false ).

        check_value_empty column-columnname.
        column-r_column->set_visible( is_not_empty ).

        IF ( column-columnname = 'DDTEXT' ).
          columns_table->set_column_position( columnname = column-columnname position = 3 ).
        ENDIF.
      ENDLOOP.

      IF ( mt_fields IS NOT INITIAL ).
        APPEND 3 TO visible_ids.
      ENDIF.
    ENDIF.

    mo_salv_fields->get_columns( )->set_optimize( ).
    mo_salv_fields->refresh( ).

    IF ( mt_fields IS NOT INITIAL ).
      DATA(lt_fields) = mt_fields.
      DELETE lt_fields WHERE fieldname CP '.INCLU*'.
      mo_tabstrip->set_cell_caption( id = 3 caption = CONV #( |Table Fields ({ lines( lt_fields ) })| ) ).
      mo_tabstrip->set_cell_visible( id = 3 visible = abap_true ).
    ELSE.
      mo_tabstrip->set_cell_visible( id = 3 visible = abap_false ).
    ENDIF.
**********************************************************************

    CLEAR mt_texttable_h.
    IF ( tabname IS NOT INITIAL ).
      DATA(lo_texttable) = lo_ddic_table->get_texttable_ref( ).
      IF ( lo_texttable IS BOUND ).
        table_header = lo_texttable->get_header( ).
        IF ( table_header-ddtext IS INITIAL ).
          table_header-ddtext = |Description in { get_language_iso( language ) } not available|.
        ENDIF.

        mt_texttable_h = get_structure_fields_for( table_header ).

        table_devclass  = lo_texttable->get_devclass( ).
        IF ( table_devclass-ctext IS INITIAL ).
          table_devclass-ctext = |Description in { get_language_iso( language ) } not available|.
        ENDIF.

        APPEND VALUE #(
          fieldtext = 'Package'
          value     = table_devclass-devclass ) TO mt_texttable_h.

        APPEND VALUE #(
          fieldtext = 'Package Description'
          value     = table_devclass-ctext ) TO mt_texttable_h.
      ENDIF.

      IF ( mt_texttable_h IS NOT INITIAL ).
        APPEND 4 TO visible_ids.
      ENDIF.
    ENDIF.

    mo_salv_texttable_h->refresh( ).

    IF ( mt_texttable_h IS NOT INITIAL ).
      mo_tabstrip->set_cell_visible( id = 4 visible = abap_true ).
    ELSE.
      mo_tabstrip->set_cell_visible( id = 4 visible = abap_false ).
    ENDIF.
**********************************************************************

    IF ( line_exists( visible_ids[ table_line = active_id ] ) ).
      mo_tabstrip->set_active( id = active_id ).
    ELSEIF ( visible_ids IS NOT INITIAL ).
      mo_tabstrip->set_active( id = visible_ids[ 1 ] ).
    ENDIF.
  ENDMETHOD.

  METHOD on_delete_content.
    READ TABLE table_keys WITH KEY tabname = mv_tabname language = mv_language TRANSPORTING NO FIELDS.
    IF ( sy-subrc = 0 OR table_keys IS INITIAL ).
      CLEAR:
        mt_header,
        mt_settings,
        mt_fields,
        mt_texttable_h.

      mo_salv_header->refresh( ).
      mo_salv_settings->refresh( ).
      mo_salv_fields->refresh( ).
      mo_salv_texttable_h->refresh( ).

      mo_tabstrip->get_container( )->parent->set_visible( abap_false ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_model IMPLEMENTATION.
  METHOD build_search_range.
    DATA:
      lv_search       TYPE string,
      lt_tokens       TYPE TABLE OF string,
      lt_combinations TYPE TABLE OF string,
      lt_new_combs    TYPE TABLE OF string.

    lv_search = i_search.
    lv_search = condense( lv_search ).

    REPLACE ALL OCCURRENCES OF REGEX ' +'
      IN lv_search
      WITH '*'.

    REPLACE ALL OCCURRENCES OF REGEX '\*{2,}'
      IN lv_search
      WITH '*'.

    FIND ALL OCCURRENCES OF REGEX '[^*+]+|[*+]+'
      IN lv_search
      RESULTS DATA(lt_matches).

    IF ( sy-subrc <> 0 ).
      RETURN.
    ENDIF.

    LOOP AT lt_matches INTO DATA(ls_match).
      APPEND lv_search+ls_match-offset(ls_match-length) TO lt_tokens.
    ENDLOOP.

    APPEND '' TO lt_combinations.

    LOOP AT lt_tokens INTO DATA(lv_tok).
      IF matches( val   = lv_tok
                  regex = '^[*+]+$' ).
        LOOP AT lt_combinations ASSIGNING FIELD-SYMBOL(<combo>).
          <combo> = <combo> && lv_tok.
        ENDLOOP.
      ELSE.
        DATA(lv_lower)       = to_lower( lv_tok ).
        DATA(lv_capitalized) = to_upper( lv_lower(1) ) && lv_lower+1.

        CLEAR lt_new_combs.
        LOOP AT lt_combinations INTO DATA(lv_combo).
          APPEND lv_combo && lv_lower       TO lt_new_combs.
          IF lv_capitalized <> lv_lower.
            APPEND lv_combo && lv_capitalized TO lt_new_combs.
          ENDIF.
        ENDLOOP.

        lt_combinations = lt_new_combs.
      ENDIF.
    ENDLOOP.

    READ TABLE lt_combinations INTO lv_combo INDEX 1.
    IF ( sy-subrc = 0 ).
      APPEND to_upper( lv_combo ) TO lt_combinations.
      APPEND to_lower( lv_combo ) TO lt_combinations.
    ENDIF.

    LOOP AT lt_combinations INTO DATA(lv_final).
      " tabname is always UPPER
      APPEND VALUE #( sign = 'I' option = 'CP' low = to_upper( lv_final ) ) TO et_tabname_range.
      " table decription case sensitiv - the defines search text
      APPEND VALUE #( sign = 'I' option = 'CP' low = lv_final )             TO et_text_range.
    ENDLOOP.

    SORT et_tabname_range BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_tabname_range.

    SORT et_text_range BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_text_range.
  ENDMETHOD.

  METHOD check_tcode_exists.
    SELECT SINGLE tcode FROM tstc WHERE tcode = @i_tcode INTO @DATA(tcode).
    IF ( sy-subrc = 0 ).
      r_exists = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD search_tables.
    DATA:
      lt_search_text_range    TYPE type_search_text_range,
      lt_search_tabname_range TYPE type_search_text_range,
      range_contflag          LIKE i_control->mt_contflag_range,
      up_to_rows              TYPE i VALUE 0,
      results                 TYPE type_search_results,
      msg                     TYPE string.

    IF ( i_control->mt_tabclass_range IS INITIAL ).
      msg = 'No DDIC object category selected, check the filter values'.
      MESSAGE msg TYPE 'S' DISPLAY LIKE 'W'. RETURN.
    ENDIF.

    DATA(search_text) = CONV string( i_input ).
    range_contflag    = i_control->mt_contflag_range.

    IF ( search_text IS INITIAL ).
      search_text = '*'.
    ENDIF.

    IF ( search_text = '*' ).
      up_to_rows  = 100.
    ELSE.
      up_to_rows  = 500.
    ENDIF.

    IF ( i_control->mt_tabname_range IS NOT INITIAL AND 'ZY' NS search_text+0(1) ).
      " Case 1: Build the tabname range for customer tables
      " Select only customer tables ( Z or Y) AND the search text don't constrain Z or Y in the first sign

      LOOP AT i_control->mt_tabname_range INTO DATA(ls_tabname_range).
        IF ( search_text = '*' ).
          DATA(lv_search) = ls_tabname_range-low.
        ELSE.
          lv_search = ls_tabname_range-low && search_text.
        ENDIF.

        build_search_range(
          EXPORTING
            i_search         = lv_search
          IMPORTING
            et_tabname_range = lt_search_tabname_range
        ).
      ENDLOOP.
    ELSEIF ( i_control->mv_search_by_descr = abap_false ).
      " Case 1: Build the tabname range on base of the input

      build_search_range(
        EXPORTING
          i_search         = search_text
        IMPORTING
          et_tabname_range = lt_search_tabname_range
      ).
    ENDIF.

    LOOP AT i_control->mt_tabclass_range TRANSPORTING NO FIELDS WHERE low = 'VIEW' OR low = 'INTTAB' OR low = 'APPEND'.
      CLEAR range_contflag. EXIT.
    ENDLOOP.

    IF ( i_control->mv_search_by_descr = abap_false ).
      " Search By Table Name

      SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
        FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                        INNER JOIN tadir      AS c ON a~tabname = c~obj_name AND c~pgmid = 'R3TR'
        WHERE a~tabname  IN @lt_search_tabname_range
          AND a~tabclass IN @i_control->mt_tabclass_range
          AND a~contflag IN @range_contflag
          AND a~clidep   IN @i_control->mt_clidep_range
          AND a~as4local = 'A'
          AND ( object   = 'TABL' OR object = 'VIEW' )
        INTO TABLE @results
        UP TO @up_to_rows ROWS.
    ELSE.
      " Search By Table Description

      build_search_range(
        EXPORTING
          i_search      = search_text
        IMPORTING
          et_text_range = lt_search_text_range
      ).

      SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
        FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                        INNER JOIN tadir      AS c ON a~tabname = c~obj_name AND c~pgmid = 'R3TR'
          WHERE a~tabname  IN @lt_search_tabname_range
            AND b~ddtext   IN @lt_search_text_range
            AND a~tabclass IN @i_control->mt_tabclass_range
            AND a~contflag IN @range_contflag
            AND a~clidep   IN @i_control->mt_clidep_range
            AND a~as4local = 'A'
            AND ( object   = 'TABL' OR object = 'VIEW' )
            APPENDING TABLE @results
            UP TO @up_to_rows ROWS.
    ENDIF.

    SORT results BY tabname tabclass ddtext DESCENDING.
    DELETE ADJACENT DUPLICATES FROM results COMPARING tabname tabclass.

    RAISE EVENT found_tables EXPORTING results = results .
  ENDMETHOD.
ENDCLASS.

CLASS lcl_table_control IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_language = i_langu.
  ENDMETHOD.

  METHOD create.
    DATA(splitter) = NEW cl_gui_splitter_container(
      parent     = i_parent
      rows       = 4
      columns    = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).
    splitter->set_row_height( id = 1 height = 60 ).
    splitter->set_row_height( id = 2 height = 153 ).
    splitter->set_row_height( id = 3 height = 40 ).

    DO 3 TIMES.
      splitter->set_row_sash(
        id    = sy-index
        type  = cl_gui_splitter_container=>type_movable
        value = cl_gui_splitter_container=>false ).

      splitter->set_row_sash(
        id    = sy-index
        type  = cl_gui_splitter_container=>type_sashvisible
        value = cl_gui_splitter_container=>false ).
    ENDDO.

    mv_view_position = enum_view_pos_x-center.
**********************************************************************
    DATA(toolbar) = NEW cl_gui_toolbar(
      parent      = splitter->get_container( row = 1 column = 1 )
      display_mode = cl_gui_toolbar=>m_mode_vertical
      align_right = 0 ).

    toolbar->set_registered_events(
      VALUE #( ( eventid = cl_gui_toolbar=>m_id_function_selected ) ) ).

    toolbar->add_button(
      fcode     = con_fcode-select_language
      icon      = CONV tv_image( icon_previous_value )
      butn_type = cntb_btype_button
      text      = CONV #( |DDIC Object Language { get_language_iso( mv_language ) }| )
      quickinfo = 'Language for search objects' ).

    toolbar->add_button(
      fcode     = con_fcode-filter_defaults
      icon      = CONV tv_image( icon_filter )
      butn_type = cntb_btype_button
      text      = 'Set Filter Defaults'
      quickinfo = 'Set filter default values' ).

    SET HANDLER on_select_setup_toolbar FOR toolbar.
**********************************************************************

    mo_toolbar_filter = NEW lcl_filter_toolbar(
      parent      = splitter->get_container( row = 2 column = 1 )
      display_mode = cl_gui_toolbar=>m_mode_vertical ).

    SET HANDLER on_filter_selected    FOR mo_toolbar_filter.
    SET HANDLER on_filter_fcode_added FOR ALL INSTANCES.

    DATA(dropdown_button) = mo_toolbar_filter->add_dropdown_button(
      fcode       = con_fcode-button_category
      icon        = icon_okay
      text        = 'Select Object Category (mandatory)'
      quickinfo   = 'Select object category'
      is_checked  = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_transp
      text    = 'Transparent Table'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_view
      text    = 'Database View'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_cluster
      text    = 'Cluster Table'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_pool
      text    = 'Pooled Table'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_struct
      text    = 'Structure'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_append
      text    = 'Append-Structure'
      checked = abap_false ).
**********************************************************************

    dropdown_button = mo_toolbar_filter->add_dropdown_button(
      fcode       = con_fcode-button_delivery
      icon        = icon_incomplete
      text        = 'Select Table Delivery Class'
      quickinfo   = 'Delivery class for tables'
      is_checked  = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_appl
      text    = 'Application Table (A)'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_cust
      text    = 'Custom Table (C)'
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_contr
      text    = 'Control Table (E)'
      checked = abap_false ).

    dropdown_button->add_menu_item(
       fcode   = con_fcode-delivery_syst
       text    = 'System Table (W)'
       checked = abap_false ).
**********************************************************************

    DATA(check_button) = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_customer
      text        = 'Search only Customer Objects'
      quickinfo   = 'Search only Z or Y-objects'
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    check_button = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_client
      text        = 'Client-specific Objects'
      quickinfo   = 'Client-specific Objects'
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    check_button = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_search_desc
      text        = 'Search in Object Description'
      quickinfo   = 'Search only in description'
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    set_filter_defaults( ).
**********************************************************************

    DATA(input) = NEW cl_gui_input_field(
        parent               = splitter->get_container( row = 3 column = 1 )
        input_prompt_text    = 'Enter a full name of the objet or a search text with any number of  ''*'''
        label_text           = 'Search'
        label_width          = 10
        activate_find_button = abap_true
        button_icon_info     = icon_search
        button_tooltip_info  = 'Search table objects'
        default_text         = '' ).

    cl_gui_container=>set_focus( input ).
    SET HANDLER on_search FOR input.
**********************************************************************

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 4 column = 1 )
          IMPORTING r_salv_table = mo_salv
          CHANGING  t_table      = mt_salv_output ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    DATA column_table TYPE REF TO cl_salv_column_table.
    DATA(columns_table) = mo_salv->get_columns( ).
    DATA(columns) = columns_table->get( ).
    LOOP AT columns INTO DATA(column).
      column_table ?= column-r_column.
      column_table->set_key( if_salv_c_bool_sap=>true ).

      column-r_column->set_fixed_header_text( 'S' ).

      IF ( column-columnname = 'TABCLASS' OR column-columnname = 'CURRENT' ).
        column-r_column->set_visible( if_salv_c_bool_sap=>false ).
      ENDIF.

      IF ( column-columnname = 'STAT' ).
        column-r_column->set_long_text( 'Table Status (OK = already read)' ).
        column-r_column->set_medium_text( 'Status' ).
        column-r_column->set_short_text( 'Status' ).
        column-r_column->set_optimized( ).
        column-r_column->set_alignment( if_salv_c_alignment=>centered ).
      ENDIF.

      IF ( column-columnname = 'CLASS' ).
        column-r_column->set_long_text( 'Table Class' ).
        column-r_column->set_medium_text( 'Type' ).
        column-r_column->set_short_text( 'Type' ).
        column-r_column->set_optimized( ).
        column-r_column->set_alignment( if_salv_c_alignment=>centered ).
      ENDIF.
    ENDLOOP.

    mo_salv->get_display_settings( )->set_striped_pattern( abap_true ).
    mo_salv->get_display_settings( )->set_no_merging( abap_true ).
    mo_salv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>multiple ).
    mo_salv->get_columns( )->set_optimize( ).

    mo_salv->get_functions( )->set_export_html( ).
    mo_salv->get_functions( )->set_filter( ).
    mo_salv->get_functions( )->set_filter_delete( ).
    mo_salv->get_functions( )->set_export_spreadsheet( ).
    mo_salv->get_functions( )->set_export_localfile( ).
    mo_salv->get_functions( )->set_sort_asc( ).
    mo_salv->get_functions( )->set_sort_desc( ).

    mo_salv->get_functions( )->add_function(
      name     = con_salv_function-delete_item
      icon     = |{ icon_delete }|
      tooltip  = 'Delete All Items'
      position = if_salv_c_function_position=>right_of_salv_functions ).

    mo_salv->get_functions( )->add_function(
      name     = con_salv_function-se11
      icon     = |{ icon_tools }|
      text     = 'se11'
      tooltip  = 'Open selected with SE11'
      position = if_salv_c_function_position=>left_of_salv_functions ).

    mo_salv->get_functions( )->add_function(
      name     = con_salv_function-se16
      icon     = |{ icon_list }|
      text     = 'se16'
      tooltip  = 'Open selected with SE16'
      position = if_salv_c_function_position=>left_of_salv_functions ).

    IF ( lcl_ddic_model=>check_tcode_exists( CONV #( con_salv_function-se16n ) ) ).
      mo_salv->get_functions( )->add_function(
        name     = con_salv_function-se16n
        icon     = |{ icon_list }|
        text     = 'se16n'
        tooltip  = 'Open selected with SE16N'
        position = if_salv_c_function_position=>left_of_salv_functions ).
    ENDIF.

    SET HANDLER on_salv_double_click  FOR mo_salv->get_event( ).
    SET HANDLER on_salv_toolbar_click FOR mo_salv->get_event( ).

    mo_salv->display( ).
  ENDMETHOD.

  METHOD on_filter_selected.
    set_filter_ranges( i_function = fcode i_checked = checked ).
  ENDMETHOD.

  METHOD on_filter_fcode_added.
    set_filter_ranges( i_function = fcode i_checked = checked ).
  ENDMETHOD.

  METHOD on_search.
    SET HANDLER on_found_tables FOR ALL INSTANCES.
    NEW lcl_ddic_model( )->search_tables( i_input = input i_control = me i_langu = mv_language ).
  ENDMETHOD.

  METHOD on_select_setup_toolbar.
    IF ( fcode = con_fcode-select_language ).
      DATA return TYPE STANDARD TABLE OF ddshretval.
      CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
        EXPORTING
          tabname    = 'T002'
          fieldname  = 'SPRAS'
        TABLES
          return_tab = return.

      IF ( return IS NOT INITIAL ).
        DATA(langu_iso) = CONV t002-laiso( return[ 1 ]-fieldval ).
        CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
          EXPORTING
            input  = langu_iso
          IMPORTING
            output = mv_language.
      ELSE.
        CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
          EXPORTING
            input  = mv_language
          IMPORTING
            output = langu_iso.
      ENDIF.

      sender->set_button_info( fcode = fcode text = CONV #( |DDIC Object Language { langu_iso }| ) ).
    ELSEIF ( fcode = con_fcode-filter_defaults ).
      set_filter_defaults( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_found_tables.
    DATA:
      selected_objects TYPE STANDARD TABLE OF tabname,
      tabname          TYPE tabname,
      f4_returns       TYPE STANDARD TABLE OF ddshretval,
      msg              TYPE string.

    IF ( lines( results  ) = 0 ).
      msg = 'No data found, check the filter values'.
      MESSAGE msg TYPE 'S' DISPLAY LIKE 'W'. RETURN.
    ELSEIF ( lines( results  ) = 1 ).
      INSERT results[ 1 ]-tabname INTO TABLE selected_objects.
    ELSE.
      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
        EXPORTING
          retfield        = 'TABNAME'
          window_title    = 'Search Table/View'
          value_org       = 'S'
          multiple_choice = 'X'
        TABLES
          value_tab       = results
          return_tab      = f4_returns
        EXCEPTIONS
          parameter_error = 1
          no_values_found = 2
          OTHERS          = 3.
      IF ( sy-subrc <> 0 ).
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      IF ( f4_returns IS INITIAL ).
        RETURN.
      ENDIF.

      LOOP AT f4_returns ASSIGNING FIELD-SYMBOL(<f4_result>).
        tabname = <f4_result>-fieldval.
        APPEND tabname TO selected_objects.
      ENDLOOP.
    ENDIF.

    LOOP AT selected_objects ASSIGNING FIELD-SYMBOL(<tabname>).
      READ TABLE mt_salv_output WITH KEY tabname = <tabname> ddlanguage = mv_language TRANSPORTING NO FIELDS.
      IF ( sy-subrc <> 0 ).
        APPEND INITIAL LINE TO mt_salv_output ASSIGNING FIELD-SYMBOL(<table_data>).
        DATA(ddic_table) = lcl_ddic_table=>create_instance( i_tabname = <tabname> i_langu = mv_language ).
        MOVE-CORRESPONDING ddic_table->get_header( ) TO <table_data>.

        <table_data>-stat  = icon_led_inactive.
        IF ( <table_data>-ddlanguage IS INITIAL ).
          <table_data>-ddtext     = |Description in { get_language_iso( mv_language ) } not available|.
        ENDIF.

        CASE <table_data>-tabclass.
          WHEN 'VIEW'.
            <table_data>-class = icon_view_table.
          WHEN 'APPEND'.
            <table_data>-class = icon_wf_workitem_ready.
          WHEN 'INTTAB'.
            <table_data>-class = icon_structure.
          WHEN OTHERS.
            <table_data>-class = icon_list.
        ENDCASE.
      ENDIF.
    ENDLOOP.

    mo_salv->get_columns( )->set_optimize( ).
    mo_salv->refresh( ).
  ENDMETHOD.

  METHOD on_salv_double_click.
    TRY.
        DATA(tabline) = mt_salv_output[ row ].
        LOOP AT mt_salv_output ASSIGNING FIELD-SYMBOL(<line>).
          CLEAR <line>-current.

          IF ( <line> = tabline ).
            <line>-stat    = icon_checked.
            <line>-current = abap_true.
          ENDIF.
        ENDLOOP.

        mo_salv->get_columns( )->set_optimize( ).
        mo_salv->get_selections( )->set_selected_rows( VALUE #( ( row ) ) ).
        mo_salv->refresh( ).

        mv_view_position = enum_view_pos_x-left.

        RAISE EVENT table_selected EXPORTING tabname = tabline-tabname language = tabline-ddlanguage.
      CATCH cx_sy_itab_line_not_found .
    ENDTRY.
  ENDMETHOD.

  METHOD on_salv_toolbar_click.
    DATA selected_tables TYPE type_table_keys.

    IF ( e_salv_function = con_salv_function-delete_item ).
      IF ( lines( mo_salv->get_selections( )->get_selected_columns( ) ) > 0 ).
        " delete all items by column selections

        CLEAR mt_salv_output.

        RAISE EVENT all_items_deleted.
      ELSEIF ( lines( mo_salv->get_selections( )->get_selected_rows( ) ) > 0 ).
        " delete the selected items

        LOOP AT mo_salv->get_selections( )->get_selected_rows( ) INTO DATA(row).
          APPEND VALUE #(
            tabname = mt_salv_output[ row ]-tabname language = mt_salv_output[ row ]-ddlanguage ) TO selected_tables.

          mt_salv_output[ row ]-stat = icon_delete.
        ENDLOOP.

        DELETE mt_salv_output WHERE stat = icon_delete.

        RAISE EVENT items_deleted EXPORTING selected_items = selected_tables.
      ENDIF.

      " select the next line if the control on the left site and no line is currently active
      IF ( mv_view_position = enum_view_pos_x-left AND get_current_line( ) IS INITIAL ).
        mo_salv->refresh( ).  " is it needed?

        LOOP AT mo_salv->get_selections( )->get_selected_rows( ) INTO row.
          mt_salv_output[ row ]-stat    = icon_checked.
          mt_salv_output[ row ]-current = abap_true.
          DATA(ls_first_selected) = mt_salv_output[ row ].

          EXIT.
        ENDLOOP.

        IF ( ls_first_selected IS NOT INITIAL ).
          RAISE EVENT table_selected EXPORTING tabname = ls_first_selected-tabname language = ls_first_selected-ddlanguage.
        ENDIF.
      ENDIF.

      mo_salv->refresh( ).
    ELSEIF ( e_salv_function = con_salv_function-se11
          OR e_salv_function = con_salv_function-se16
          OR e_salv_function = con_salv_function-se16n ).

      DATA(selected_rows) = mo_salv->get_selections( )->get_selected_rows( ).
      IF ( selected_rows IS INITIAL ).
        RETURN.
      ENDIF.

      READ TABLE selected_rows INTO row INDEX 1.
      ls_first_selected = mt_salv_output[ row ].

      DATA(tcode) = CONV sy-tcode( e_salv_function ).
      IF ( tcode <> 'SE11' AND ( ls_first_selected-tabclass = 'INTTAB' OR ls_first_selected-tabclass = 'APPEND' ) ).
        RETURN.
      ENDIF.

      CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
        EXPORTING
          tcode  = tcode
        EXCEPTIONS
          ok     = 1
          not_ok = 2
          OTHERS = 3.
      IF ( sy-subrc <> 1 ).
        DATA(msg) = |No Authority for the TCode { tcode }|.
        MESSAGE msg TYPE 'S' DISPLAY LIKE 'E'. RETURN.
      ENDIF.

      CASE ls_first_selected-tabclass.
        WHEN 'INTTAB' OR 'APPEND'.
          SET PARAMETER ID 'DTB'  FIELD space.
          SET PARAMETER ID 'DVI'  FIELD space.
          SET PARAMETER ID 'DTYP' FIELD ls_first_selected-tabname.
        WHEN 'VIEW'.
          SET PARAMETER ID 'DTYP' FIELD space.

          IF ( tcode = 'SE11' ).
            SET PARAMETER ID 'DTB'  FIELD space.
            SET PARAMETER ID 'DVI'  FIELD ls_first_selected-tabname.
          ELSE.
            SET PARAMETER ID 'DVI'  FIELD space.
            SET PARAMETER ID 'DTB'  FIELD ls_first_selected-tabname.
          ENDIF.
        WHEN OTHERS.
          SET PARAMETER ID 'DVI'  FIELD space.
          SET PARAMETER ID 'DTYP' FIELD space.
          SET PARAMETER ID 'DTB'  FIELD ls_first_selected-tabname.
      ENDCASE.

      WAIT UP TO 1 SECONDS. " Workaround to "flush" the parameter settings before calling the function module TH_CREATE_MODE

      CALL FUNCTION 'TH_CREATE_MODE'
        EXPORTING
          transaktion    = tcode
        EXCEPTIONS
          max_sessions   = 1
          internal_error = 2
          no_authority   = 3
          OTHERS         = 4.
      CASE sy-subrc.
        WHEN 0.
          msg = |TCode { tcode } is opened in the new window|.
          MESSAGE msg TYPE 'S'.
        WHEN 1.
          TRY.
              CALL TRANSACTION tcode WITH AUTHORITY-CHECK AND SKIP FIRST SCREEN.
              msg = |TCode { tcode } is opened in the same window|.
              MESSAGE msg TYPE 'S'.
            CATCH cx_sy_authorization_error.
              msg = |No Authority for the TCode { tcode }|.
              MESSAGE msg TYPE 'S' DISPLAY LIKE 'E'.
          ENDTRY.
        WHEN 3.
          msg = |No Authority for the TCode { tcode }|.
          MESSAGE msg TYPE 'S' DISPLAY LIKE 'E'. RETURN.
        WHEN OTHERS.
          msg = |Unknown error in the function ''TH_CREATE_MODE'' for the TCode { tcode }|.
          MESSAGE msg TYPE 'S' DISPLAY LIKE 'E'. RETURN.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD get_current_line.
    READ TABLE mt_salv_output INTO current_line WITH KEY current = abap_true.
  ENDMETHOD.

  METHOD set_filter_defaults.
    mo_toolbar_filter->set_button_attr(
      fcode   = con_fcode-button_category
      checked = abap_true
      menu_items = VALUE #(
        ( fcode = con_fcode-tabclass_transp checked = abap_true )
        ( fcode = con_fcode-tabclass_view   checked = abap_true )
      ) ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_delivery checked    = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_customer checked    = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_client checked      = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_search_desc checked = abap_false ).
  ENDMETHOD.

  METHOD set_filter_ranges.
    CASE i_function.
      WHEN con_fcode-button_search_desc.
        lif_table_tree_control~mv_search_by_descr = i_checked.
      WHEN con_fcode-delivery_appl
        OR con_fcode-delivery_cust
        OR con_fcode-delivery_contr
        OR con_fcode-delivery_syst.

        DATA(contflag) = CONV dd02v-contflag( i_function ).
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = contflag ) TO lif_table_tree_control~mt_contflag_range.
        ELSE.
          DELETE lif_table_tree_control~mt_contflag_range WHERE low = contflag.
        ENDIF.
      WHEN con_fcode-tabclass_transp
        OR con_fcode-tabclass_view
        OR con_fcode-tabclass_cluster
        OR con_fcode-tabclass_pool
        OR con_fcode-tabclass_struct
        OR con_fcode-tabclass_append.

        DATA(tabclass) = CONV dd02v-tabclass( i_function ).
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = tabclass ) TO lif_table_tree_control~mt_tabclass_range.
        ELSE.
          DELETE lif_table_tree_control~mt_tabclass_range WHERE low = tabclass.
        ENDIF.
      WHEN con_fcode-button_client.
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'X' ) TO lif_table_tree_control~mt_clidep_range.
        ELSE.
          CLEAR lif_table_tree_control~mt_clidep_range.
        ENDIF.
      WHEN con_fcode-button_customer.
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'Z*' ) TO lif_table_tree_control~mt_tabname_range.
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'Y*' ) TO lif_table_tree_control~mt_tabname_range.
        ELSE.
          CLEAR lif_table_tree_control~mt_tabname_range.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_controller_base DEFINITION ABSTRACT CREATE PROTECTED.
  PUBLIC SECTION.
    METHODS:
      on_init ABSTRACT.

  PROTECTED SECTION.
    TYPES type_simple_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

    METHODS:
      constructor IMPORTING i_view TYPE REF TO lcl_view_base,
      get_view     RETURNING VALUE(r_view) TYPE REF TO lcl_view_base,
      on_at_output ABSTRACT FOR EVENT at_output OF lcl_gui_handler,
      on_at_input  ABSTRACT FOR EVENT at_input  OF lcl_gui_handler IMPORTING ucomm,
      on_at_exit   ABSTRACT FOR EVENT at_exit   OF lcl_gui_handler IMPORTING ucomm.

  PRIVATE SECTION.
    DATA:
      mo_view TYPE REF TO lcl_view_base.
ENDCLASS.

CLASS lcl_controller_base IMPLEMENTATION.
  METHOD constructor.
    mo_view = i_view.
  ENDMETHOD.

  METHOD get_view.
    r_view = mo_view.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_start_view DEFINITION DEFERRED.
CLASS lcl_start_ctrl DEFINITION INHERITING FROM lcl_controller_base FRIENDS lcl_start_view.
  PUBLIC SECTION.
    METHODS:
      on_init REDEFINITION.

  PROTECTED SECTION.
    METHODS:
      on_at_output REDEFINITION,
      on_at_input  REDEFINITION,
      on_at_exit   REDEFINITION.
ENDCLASS.

CLASS lcl_start_ctrl IMPLEMENTATION.
  METHOD on_init.
    " to implement if necessary...
  ENDMETHOD.

  METHOD on_at_output.
    " to implement if necessary...
  ENDMETHOD.

  METHOD on_at_input.
    " to implement if necessary...
  ENDMETHOD.

  METHOD on_at_exit.
    " to implement if necessary...
  ENDMETHOD.
ENDCLASS.

CLASS lcl_view_base DEFINITION ABSTRACT FRIENDS lcl_controller_base.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF type_gui_control,
        name    TYPE string,
        text    TYPE string,
        control TYPE REF TO object,
        parent  TYPE REF TO object,
        enabled TYPE abap_bool,
        checked TYPE abap_bool,
        visible TYPE abap_bool,
        data    TYPE REF TO data,
      END OF type_gui_control,
      type_gui_controls TYPE SORTED TABLE OF type_gui_control WITH UNIQUE KEY name.

    CLASS-METHODS:
      free_root_container.

    CLASS-DATA:
      root_container TYPE REF TO cl_gui_container.

    METHODS:
      destroy        ABSTRACT,
      create_gos     FINAL IMPORTING i_name       TYPE string
                                     i_parent     TYPE REF TO cl_gui_container
                           RETURNING VALUE(r_gos) TYPE REF TO cl_gui_gos_container,
      create_splitter FINAL IMPORTING i_name            TYPE string OPTIONAL
                                      i_parent          TYPE REF TO cl_gui_container
                                      i_rows            TYPE i
                                      i_columns         TYPE i
                            RETURNING VALUE(r_splitter) TYPE REF TO cl_gui_splitter_container,
      create_content  ABSTRACT.

    DATA:
      mo_controller TYPE REF TO lcl_controller_base,
      mv_language   TYPE sy-langu.
ENDCLASS.

CLASS lcl_view_base IMPLEMENTATION.
  METHOD constructor.
    mv_language = i_langu.
  ENDMETHOD.

  METHOD free_root_container.
    IF ( root_container IS BOUND ).
      root_container->free( ).
      cl_gui_cfw=>flush( ).
    ENDIF.
  ENDMETHOD.

  METHOD create_gos.
    RAISE EXCEPTION TYPE cx_sy_create_object_error.
  ENDMETHOD.

  METHOD create_splitter.
    DATA:
      column_index      TYPE i,
      row_index         TYPE i,
      subcontainer_name TYPE string.

    r_splitter = NEW #(
      parent     = i_parent
      rows       = i_rows
      columns    = i_columns
      no_autodef_progid_dynnr = abap_true ).

    IF ( i_name IS NOT INITIAL ).
      r_splitter->set_name( i_name ).
      DO i_columns TIMES.
        column_index = sy-index.
        DO i_rows TIMES.
          row_index = sy-index.

          subcontainer_name = |{ i_name }_COL_{ column_index }_ROW_{ row_index }|.
          r_splitter->get_container( column = column_index row = row_index )->set_name( subcontainer_name ).
        ENDDO.
      ENDDO.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_start_view DEFINITION INHERITING FROM lcl_view_base.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    METHODS:
      create_content REDEFINITION,
      destroy        REDEFINITION.

  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF con_view_container_name,
        root_view TYPE string VALUE 'VIEW_CONTAINER_ROOT',
        data_view TYPE string VALUE 'VIEW_CONTAINER_DATA',
      END OF con_view_container_name,

      BEGIN OF enum_pos_at,
        central TYPE i VALUE 0,
        left    TYPE i VALUE 1,
      END OF enum_pos_at.

    METHODS:
      on_table_selected    FOR EVENT table_selected    OF lcl_table_control IMPORTING tabname language sender,
      on_items_deleted     FOR EVENT items_deleted     OF lcl_table_control IMPORTING selected_items sender,
      on_all_items_deleted FOR EVENT all_items_deleted OF lcl_table_control IMPORTING sender.

    DATA:
      mv_pos_at TYPE i.
ENDCLASS.

CLASS lcl_start_view IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_langu ).
    DATA pf_excludes TYPE STANDARD TABLE OF rsexfcode WITH DEFAULT KEY.
    APPEND VALUE #( fcode = 'ONLI' ) TO pf_excludes.
    APPEND VALUE #( fcode = 'SPOS' ) TO pf_excludes.
    APPEND VALUE #( fcode = 'NONE' ) TO pf_excludes.
    APPEND VALUE #( fcode = 'CRET' ) TO pf_excludes.

    CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
      EXPORTING
        p_status  = sy-pfkey
      TABLES
        p_exclude = pf_excludes.

    mv_pos_at = enum_pos_at-central.
    mo_controller  = NEW lcl_start_ctrl( me ).
    create_content( ).

    mo_controller->on_init( ).
  ENDMETHOD.

  METHOD create_content.
    free_root_container( ).

    " Build root container
    DATA(splitter) = create_splitter(
      i_parent  = cl_gui_container=>screen0 " top screen
      i_rows    = 1
      i_columns = 3 ).

    splitter->set_column_mode( mode = cl_gui_splitter_container=>mode_relative ).
    splitter->set_column_width( id = 1 width = 20 ).
    splitter->set_column_width( id = 2 width = 60 ).
    splitter->set_column_width( id = 3 width = 20 ).

    NEW lcl_table_control( mv_language )->create( i_parent = splitter->get_container( row = 1 column = 2 ) ).
    SET HANDLER on_table_selected    FOR ALL INSTANCES.
    SET HANDLER on_items_deleted     FOR ALL INSTANCES.
    SET HANDLER on_all_items_deleted FOR ALL INSTANCES.

    root_container = splitter.

    cl_gui_cfw=>flush( ).
  ENDMETHOD.

  METHOD destroy.

  ENDMETHOD.

  METHOD on_table_selected.
    IF ( mv_pos_at = enum_pos_at-central ).
      mv_pos_at   = enum_pos_at-left.

      DATA(splitter) = CAST cl_gui_splitter_container( root_container ).
      splitter->set_visible( abap_false ).
      splitter->set_column_width( id = 1 width = 0 ).
      splitter->set_column_width( id = 2 width = 22 ).
      splitter->set_column_width( id = 3 width = 78 ).

      NEW lcl_table_bar_control( )->create( i_parent = splitter->get_container( row = 1 column = 3 ) ).

      splitter->set_visible( abap_true ).
      cl_gui_cfw=>flush( ).
    ENDIF.

    DATA(lv_langu) = COND sy-langu( WHEN language IS NOT INITIAL THEN language ELSE mv_language ).

    lcl_control=>update_content( i_tabname = tabname i_langu = lv_langu ).
  ENDMETHOD.

  METHOD on_items_deleted.
    lcl_control=>clear_content( selected_items ).
  ENDMETHOD.

  METHOD on_all_items_deleted.
    lcl_control=>clear_content(  ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_app DEFINITION ABSTRACT FRIENDS lcl_gui_handler.
  PROTECTED SECTION.
    DATA:
      mo_view       TYPE REF TO lcl_view_base,
      mo_controller TYPE REF TO lcl_controller_base.
ENDCLASS.

CLASS lcl_start_app DEFINITION INHERITING FROM lcl_app.
  PUBLIC SECTION.
    METHODS:
      constructor.
ENDCLASS.

CLASS lcl_start_app IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    title1 = 'Advanced DDIC Explorer Free'.
    mo_view = NEW lcl_start_view( p_langu ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_gui_handler IMPLEMENTATION.
  METHOD on_initialization.
    " to implement if necessary...
  ENDMETHOD.

  METHOD on_at_output.
    IF ( app IS INITIAL ).
      app = start_app( sy-dynnr ).
    ENDIF.

    RAISE EVENT at_output.
  ENDMETHOD.

  METHOD on_at_input.
    RAISE EVENT at_input EXPORTING ucomm = sscrfields-ucomm.
  ENDMETHOD.

  METHOD on_at_exit.
    RAISE EVENT at_exit EXPORTING ucomm = sscrfields-ucomm.
  ENDMETHOD.

  METHOD on_start.
    CALL SELECTION-SCREEN 1001.
  ENDMETHOD.

  METHOD start_app.
    CASE i_appid.
      WHEN enum_appid-start.
        r_app = NEW lcl_start_app( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
