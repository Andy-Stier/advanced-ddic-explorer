REPORT zasc_ddic_explorer_free.

*-----------------------------------------------------------------------*
* PRODUCT:     Advanced DDIC Explorer Community Edition
* VERSION:     Community Version, Release V1.0.5
* COPYRIGHT:   ©2026. All rights reserved.
* AUTHOR:      Advanced DDIC Explorer Core Team
* LAST UPDATE: 2026/07/20
*-----------------------------------------------------------------------*

* Contact
* - GitHub: https://github.com/Andy-Stier/advanced-ddic-explorer
* - E-Mail: advanced.abap.software@gmail.com

********************************************************************************
* MIT License
*
* Copyright (c) 2026 Advanced DDIC Explorer
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

TABLES: sscrfields, dd02l.
TYPE-POOLS swbm.
INCLUDE: <icon>, sbal_constants.

CLASS lcl_app         DEFINITION DEFERRED.
CLASS lcl_view_base   DEFINITION DEFERRED.
CLASS lcl_gui_handler DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-EVENTS:
      close_application,
      at_output,
      at_input EXPORTING VALUE(ucomm) TYPE sscrfields-ucomm,
      at_exit  EXPORTING VALUE(ucomm) TYPE sscrfields-ucomm.

    TYPES type_appid TYPE n LENGTH 4.

    CONSTANTS:
      BEGIN OF enum_appid,
        start         TYPE type_appid VALUE '1001',
        ddic_explorer TYPE type_appid VALUE '1002',
      END OF enum_appid.

    CLASS-METHODS:
      on_initialization,
      on_at_output,
      on_at_input,
      on_at_exit,
      on_start,
      create_message_log,
      get_program_variant RETURNING VALUE(r_variant) TYPE sy-slset,
      reload_start_screen,
      start_app IMPORTING i_appid TYPE type_appid RETURNING VALUE(r_app) TYPE REF TO lcl_app.

  PRIVATE SECTION.
    CLASS-METHODS:
      check_system,
      set_labels,
      set_input_data.

    CLASS-DATA:
      initialized     TYPE abap_bool,
      program_variant TYPE sy-slset,
      app             TYPE REF TO lcl_app.
ENDCLASS.

CLASS lcl_language_convert DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-METHODS:
      get_language_input  IMPORTING i_lang_iso TYPE t002-laiso RETURNING VALUE(rv_langu)    TYPE sy-langu,
      get_language_output IMPORTING i_langu    TYPE sy-langu   RETURNING VALUE(rv_lang_iso) TYPE t002-laiso.
ENDCLASS.

CLASS lcl_language_convert IMPLEMENTATION.
  METHOD get_language_input.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_INPUT'
      EXPORTING
        input  = i_lang_iso
      IMPORTING
        output = rv_langu.
  ENDMETHOD.

  METHOD get_language_output.
    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = i_langu
      IMPORTING
        output = rv_lang_iso.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_control_metric DEFINITION DEFERRED.
CLASS lcl_input_fields DEFINITION FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA:
      tabname_range      TYPE RANGE OF dd02l-tabname,
      language           TYPE REF TO sy-langu,
      max_hits           TYPE REF TO sy-dbcnt,
      line_height        TYPE REF TO int1,
      delete_history     TYPE REF TO abap_bool,
      check_tables       TYPE REF TO abap_bool,
      bal_object         TYPE REF TO balsub-object,
      bal_sub_object     TYPE REF TO balsub-subobject,
      bal_ext_text       TYPE REF TO balnrext,
      access_se11        TYPE REF TO abap_bool,
      access_se16        TYPE REF TO abap_bool,
      access_se16n       TYPE REF TO abap_bool,
      access_se16h       TYPE REF TO abap_bool,
      object_cat_dbtable TYPE REF TO abap_bool,
      object_cat_view    TYPE REF TO abap_bool,
      object_cat_pool    TYPE REF TO abap_bool,
      object_cat_cluster TYPE REF TO abap_bool,
      object_cat_struct  TYPE REF TO abap_bool,
      object_cat_append  TYPE REF TO abap_bool,
      table_deliv_appl   TYPE REF TO abap_bool,
      table_deliv_cust   TYPE REF TO abap_bool,
      table_deliv_ctrl   TYPE REF TO abap_bool,
      table_deliv_syst   TYPE REF TO abap_bool,
      view_type_db       TYPE REF TO abap_bool,
      view_type_proj     TYPE REF TO abap_bool,
      view_type_maint    TYPE REF TO abap_bool,
      view_type_help     TYPE REF TO abap_bool.
ENDCLASS.

CLASS lcl_control_metric DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES:
      type_line_height TYPE n LENGTH 2,
      type_factor      TYPE p LENGTH 3 DECIMALS 2.

    CONSTANTS:
      BEGIN OF enum_screen_width,
        small       TYPE i VALUE 1200,
        middle      TYPE i VALUE 1500,
        large       TYPE i VALUE 1800,
        super_large TYPE i VALUE 2400,
      END OF enum_screen_width.

    CLASS-METHODS:
      get_screen_x    RETURNING VALUE(rv_x) TYPE i,
      get_screen_y    RETURNING VALUE(rv_y) TYPE i,
      get_line_height RETURNING VALUE(rv_height) TYPE i.
ENDCLASS.

CLASS lcl_control_metric IMPLEMENTATION.
  METHOD get_screen_x.
    rv_x = cl_gui_props_consumer=>create_consumer( )->get_metric_factors( )-screen-x.
  ENDMETHOD.

  METHOD get_screen_y.
    rv_y = cl_gui_props_consumer=>create_consumer( )->get_metric_factors( )-screen-y.
  ENDMETHOD.

  METHOD get_line_height.
    rv_height = lcl_input_fields=>line_height->*.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_message_log DEFINITION FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_message,
        syst_msg TYPE bal_s_msg,
        method   TYPE string,
        object   TYPE string,
      END OF type_message,
      type_messages TYPE STANDARD TABLE OF type_message WITH EMPTY KEY,
      BEGIN OF type_msgvar,
        msgv1 TYPE bal_s_msg-msgv1,
        msgv2 TYPE bal_s_msg-msgv2,
        msgv3 TYPE bal_s_msg-msgv3,
        msgv4 TYPE bal_s_msg-msgv4,
      END OF type_msgvar,
      type_swastrtab TYPE STANDARD TABLE OF swastrtab WITH EMPTY KEY.

    CLASS-METHODS:
      create           IMPORTING i_object          TYPE balobj_d  OPTIONAL
                                 i_subobject       TYPE balsubobj OPTIONAL
                                 i_extnumber       TYPE balnrext  OPTIONAL
                       RETURNING VALUE(r_instance) TYPE REF TO lcl_message_log.
    METHODS:
      constructor      IMPORTING i_object    TYPE balobj_d  OPTIONAL
                                 i_subobject TYPE balsubobj OPTIONAL
                                 i_extnumber TYPE balnrext  OPTIONAL
                                 i_repid     TYPE sy-repid  DEFAULT sy-repid
                                 i_uname     TYPE sy-uname  DEFAULT sy-uname,
      get_messages     RETURNING VALUE(r_messages) TYPE type_messages,
      check_type       IMPORTING i_msgtyp        TYPE symsgty
                       RETURNING VALUE(r_exists) TYPE abap_bool,
      add_message      IMPORTING i_msg     TYPE symsg OPTIONAL
                                 i_read_sy TYPE abap_bool DEFAULT abap_false
                                 i_method  TYPE csequence OPTIONAL
                                 i_object  TYPE csequence OPTIONAL,
      add_message_text IMPORTING i_text   TYPE csequence
                                 i_msgtyp TYPE symsgty DEFAULT 'E'
                                 i_method TYPE csequence OPTIONAL
                                 i_object TYPE csequence OPTIONAL,
      add_exception    IMPORTING i_error  TYPE REF TO cx_root
                                 i_method TYPE csequence OPTIONAL
                                 i_object TYPE csequence OPTIONAL,
      save,
      display,
      delete_messages.

  PRIVATE SECTION.
    CLASS-METHODS:
      split_text_into_msgvar IMPORTING i_text          TYPE csequence
                             RETURNING VALUE(r_msgvar) TYPE type_msgvar.

    CLASS-DATA:
      singleton TYPE REF TO lcl_message_log.

    DATA:
      mv_handle   TYPE balloghndl,
      ms_log      TYPE bal_s_log,
      mt_messages TYPE type_messages.
ENDCLASS.

DATA message_log TYPE REF TO lcl_message_log.

SELECTION-SCREEN BEGIN OF BLOCK func.
SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.
SELECTION-SCREEN FUNCTION KEY 4.
SELECTION-SCREEN FUNCTION KEY 5.
SELECTION-SCREEN END OF BLOCK func.

SELECTION-SCREEN BEGIN OF SCREEN 1001 TITLE tsstart. " Selection Screen (Start)
SELECTION-SCREEN INCLUDE BLOCKS func.

SELECTION-SCREEN BEGIN OF BLOCK block_appl_data WITH FRAME TITLE lappdata.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) llangu FOR FIELD p_langu.
PARAMETERS p_langu TYPE spras DEFAULT sy-langu OBLIGATORY VALUE CHECK.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (23) ltable FOR FIELD so_table.
SELECT-OPTIONS so_table FOR dd02l-tabname NO INTERVALS.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) lmaxhit FOR FIELD p_maxhit.
PARAMETERS p_maxhit TYPE sy-dbcnt OBLIGATORY DEFAULT 500.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) llineh FOR FIELD p_lineh.
PARAMETERS p_lineh TYPE int1 OBLIGATORY DEFAULT 30.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) ltcode.
PARAMETERS p_se11 TYPE abap_bool AS CHECKBOX DEFAULT 'X'    USER-COMMAND accesstcode.
SELECTION-SCREEN COMMENT (10) lse11 FOR FIELD p_se11.
PARAMETERS p_se16 TYPE abap_bool AS CHECKBOX DEFAULT space  USER-COMMAND accesstcode.
SELECTION-SCREEN COMMENT (10) lse16 FOR FIELD p_se16.
PARAMETERS p_se16n TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND accesstcode.
SELECTION-SCREEN COMMENT (10) lse16n FOR FIELD p_se16n.
PARAMETERS p_se16h TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND accesstcode.
SELECTION-SCREEN COMMENT (10) lse16h FOR FIELD p_se16h.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) lcheck FOR FIELD p_check.
PARAMETERS p_check TYPE abap_bool AS CHECKBOX DEFAULT space.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) ldelmem FOR FIELD p_delmem.
PARAMETERS p_delmem TYPE abap_bool AS CHECKBOX DEFAULT space.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 28(10) lbalobj.
SELECTION-SCREEN COMMENT 49(10) lbalsub.
SELECTION-SCREEN COMMENT 70(10) lbalext.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (26) lbal.
PARAMETERS:
  p_balobj TYPE balsub-object    DEFAULT 'APPL_LOG' OBLIGATORY VALUE CHECK,
  p_balsub TYPE balsub-subobject DEFAULT 'OTHERS'   OBLIGATORY VALUE CHECK,
  p_balext TYPE balnrext         DEFAULT 'DDIC_EXPLORER'.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK block_appl_data.

SELECTION-SCREEN BEGIN OF BLOCK block_filter WITH FRAME TITLE lfdef.
SELECTION-SCREEN BEGIN OF BLOCK block_table_cat WITH FRAME TITLE ltcat.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_db TYPE abap_bool AS CHECKBOX DEFAULT 'X'       USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (17) ltdb FOR FIELD p_db.
PARAMETERS p_view  TYPE abap_bool AS CHECKBOX DEFAULT 'X'    USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (17) ltview FOR FIELD p_view.
PARAMETERS p_pool TYPE abap_bool AS CHECKBOX DEFAULT space   USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (17) ltpool FOR FIELD p_pool.
PARAMETERS p_clust  TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (16) ltclust FOR FIELD p_clust.
PARAMETERS p_struct TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (14) ltstruct FOR FIELD p_struct.
PARAMETERS p_append  TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND objcategory.
SELECTION-SCREEN COMMENT (16) ltappend FOR FIELD p_append.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK block_table_cat.

SELECTION-SCREEN BEGIN OF BLOCK block_delivery WITH FRAME TITLE ltdel.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_appl TYPE abap_bool AS CHECKBOX DEFAULT 'X'    USER-COMMAND delivery.
SELECTION-SCREEN COMMENT (17) ldappl FOR FIELD p_appl.
PARAMETERS p_cust  TYPE abap_bool AS CHECKBOX DEFAULT 'X'   USER-COMMAND delivery.
SELECTION-SCREEN COMMENT (17) ldcust FOR FIELD p_cust.
PARAMETERS p_ctrl TYPE abap_bool AS CHECKBOX DEFAULT space  USER-COMMAND delivery.
SELECTION-SCREEN COMMENT (17) ldctrl FOR FIELD p_ctrl.
PARAMETERS p_syst  TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND delivery.
SELECTION-SCREEN COMMENT (17) ldsyst FOR FIELD p_syst.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK block_delivery.

SELECTION-SCREEN BEGIN OF BLOCK block_view_type WITH FRAME TITLE lvtyp.
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_dbv TYPE abap_bool AS CHECKBOX DEFAULT 'X'     USER-COMMAND viewtype.
SELECTION-SCREEN COMMENT (17) lvtdbv FOR FIELD p_dbv.
PARAMETERS p_prv  TYPE abap_bool AS CHECKBOX DEFAULT space  USER-COMMAND viewtype.
SELECTION-SCREEN COMMENT (17) lvtprv FOR FIELD p_prv.
PARAMETERS p_mntv TYPE abap_bool AS CHECKBOX DEFAULT space  USER-COMMAND viewtype.
SELECTION-SCREEN COMMENT (17) lvtmntv FOR FIELD p_mntv.
PARAMETERS p_hlpv  TYPE abap_bool AS CHECKBOX DEFAULT space USER-COMMAND viewtype.
SELECTION-SCREEN COMMENT (17) lvthlpv FOR FIELD p_hlpv.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK block_view_type.
SELECTION-SCREEN END OF BLOCK block_filter.
SELECTION-SCREEN END OF SCREEN 1001.

SELECTION-SCREEN BEGIN OF SCREEN 1002 TITLE tsddic. " Screen DDIC Dashboard
SELECTION-SCREEN INCLUDE BLOCKS func.
SELECTION-SCREEN END OF SCREEN 1002.

INITIALIZATION.
  lcl_gui_handler=>on_initialization( ).

AT SELECTION-SCREEN OUTPUT.
  lcl_gui_handler=>on_at_output( ).

AT SELECTION-SCREEN ON p_maxhit.
  IF ( p_maxhit < 1 ).
    MESSAGE 'Check the value of "Maximal Number of Hits": Value < 1!'(m01) TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN ON p_lineh.
  IF ( p_lineh > 42 ).
    MESSAGE 'Maximal value of "Display Line Height" is 42!'(m14) TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN.
  lcl_gui_handler=>on_at_input( ).

AT SELECTION-SCREEN ON EXIT-COMMAND.
  lcl_gui_handler=>on_at_exit( ).

START-OF-SELECTION.
  lcl_gui_handler=>on_start( ).

**********************************************************************
* Local Classes
**********************************************************************

CLASS lcl_message_log IMPLEMENTATION.
  METHOD create.
    IF ( singleton IS INITIAL ).
      singleton = NEW #(
        i_object    = lcl_input_fields=>bal_object->*
        i_subobject = lcl_input_fields=>bal_sub_object->*
        i_extnumber = lcl_input_fields=>bal_ext_text->* ).
    ELSE.
      IF ( singleton->mv_handle IS NOT INITIAL ).
        IF ( singleton->ms_log-extnumber <> i_extnumber
          OR singleton->ms_log-object    <> i_object
          OR singleton->ms_log-subobject <> i_subobject ).

          singleton = NEW #(
            i_object    = lcl_input_fields=>bal_object->*
            i_subobject = lcl_input_fields=>bal_sub_object->*
            i_extnumber = lcl_input_fields=>bal_ext_text->* ).
        ENDIF.
      ENDIF.
    ENDIF.

    r_instance = singleton.
  ENDMETHOD.

  METHOD constructor.
    DATA message_defaults TYPE bal_s_mdef.

    IF ( i_object IS NOT INITIAL ).
      ms_log-extnumber = i_extnumber.
      ms_log-object    = i_object.
      ms_log-subobject = i_subobject.
      ms_log-aluser    = i_uname.
      ms_log-alprog    = i_repid.
      ms_log-aldate    = sy-datlo.
      ms_log-altime    = sy-timlo.

      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log                 = ms_log
        IMPORTING
          e_log_handle            = mv_handle
        EXCEPTIONS
          log_header_inconsistent = 1
          OTHERS                  = 2.
      IF ( sy-subrc <> 0 ).
        MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        RETURN.
      ENDIF.

      message_defaults-log_handle = mv_handle.
      CALL FUNCTION 'BAL_GLB_MSG_DEFAULTS_SET'
        EXPORTING
          i_s_msg_defaults      = message_defaults
        EXCEPTIONS
          not_authorized        = 1
          defaults_inconsistent = 2
          OTHERS                = 3.
      IF ( sy-subrc <> 0 ).
        MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_messages.
    r_messages = mt_messages.
  ENDMETHOD.

  METHOD check_type.
    LOOP AT mt_messages TRANSPORTING NO FIELDS WHERE syst_msg-msgty = i_msgtyp.
      r_exists = abap_true. EXIT.
    ENDLOOP.
  ENDMETHOD.

  METHOD add_message.
    DATA msg TYPE bal_s_msg.
    IF ( i_read_sy = abap_true ).
      MOVE-CORRESPONDING sy TO msg.
    ELSEIF ( i_msg IS SUPPLIED AND i_msg IS NOT INITIAL ).
      MOVE-CORRESPONDING i_msg TO msg.
    ELSE.
      RETURN.
    ENDIF.

    READ TABLE mt_messages TRANSPORTING NO FIELDS WITH KEY syst_msg = msg.
    IF ( sy-subrc = 0 ).
      RETURN.
    ENDIF.

    APPEND VALUE #( syst_msg = msg method = i_method object = i_object ) TO mt_messages.

    IF ( mv_handle IS NOT INITIAL ).
      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = mv_handle
          i_s_msg          = msg
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF ( sy-subrc <> 0 ).
        MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ). " triggers PAI
  ENDMETHOD.

  METHOD add_message_text.
    DATA msg TYPE symsg.
    msg-msgid = const_freetext_msgid.
    msg-msgno = const_freetext_msgno.
    msg-msgty = i_msgtyp.
    MOVE-CORRESPONDING split_text_into_msgvar( i_text ) TO msg.

    add_message( i_msg = msg i_method = i_method i_object = i_object ).
  ENDMETHOD.

  METHOD add_exception.
    DATA msg TYPE symsg.
    msg-msgid = const_freetext_msgid.
    msg-msgno = const_freetext_msgno.
    msg-msgty = 'E'.
    MOVE-CORRESPONDING split_text_into_msgvar( i_error->get_text( ) ) TO msg.

    add_message( i_msg = msg i_method = i_method i_object = i_object ).
  ENDMETHOD.

  METHOD split_text_into_msgvar.
    DATA(lv_text) = CONV string( i_text ).
    r_msgvar-msgv1 = lv_text.
    IF strlen( lv_text ) > 50.
      r_msgvar-msgv2 = lv_text+50.
    ENDIF.
    IF strlen( lv_text ) > 100.
      r_msgvar-msgv3 = lv_text+100.
    ENDIF.
    IF strlen( lv_text ) > 150.
      r_msgvar-msgv4 = lv_text+150.
    ENDIF.
  ENDMETHOD.

  METHOD save.
    IF ( mv_handle IS INITIAL ).
      RETURN.
    ENDIF.

    DATA handles TYPE bal_t_logh.
    APPEND mv_handle TO handles.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = handles
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.
    IF ( sy-subrc <> 0 ).
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR mv_handle.
  ENDMETHOD.

  METHOD display.
    IF ( mv_handle IS INITIAL ).
      TYPES:
        BEGIN OF ty_output,
          icon TYPE balimsgty,
          text TYPE baltmsg,
        END OF ty_output,
        ty_outputs TYPE STANDARD TABLE OF ty_output WITH EMPTY KEY.

      DATA output_tab TYPE ty_outputs.
      LOOP AT mt_messages INTO DATA(message).
        APPEND INITIAL LINE TO output_tab ASSIGNING FIELD-SYMBOL(<output>).
        <output>-icon = COND #( WHEN message-syst_msg-msgty = 'E' THEN icon_led_red
                                WHEN message-syst_msg-msgty = 'W' THEN icon_led_yellow
                                ELSE icon_led_green ).
        <output>-text = message-syst_msg-msgv1 && message-syst_msg-msgv2 && message-syst_msg-msgv3 && message-syst_msg-msgv4.
      ENDLOOP.

      TRY.
          cl_salv_table=>factory(
            IMPORTING r_salv_table = DATA(salv_messages)
            CHANGING  t_table      = output_tab ).

          salv_messages->set_screen_popup(
            start_column = 1
            end_column   = 80
            start_line   = 1
            end_line     = 5 ).

          salv_messages->get_columns( )->set_optimize( ).
          salv_messages->display( ).
        CATCH cx_salv_msg INTO DATA(error).
          message_log->add_exception( i_error = error i_method = 'LCL_MESSAGE_LOG->DISPLAY' ).
      ENDTRY.
    ELSE.
      DATA display_profile TYPE bal_s_prof.
      CALL FUNCTION 'BAL_DSP_PROFILE_POPUP_GET'
        IMPORTING
          e_s_display_profile = display_profile.

      display_profile-use_grid          = abap_true.
      display_profile-disvariant-report = ms_log-alprog.
      display_profile-disvariant-handle = 'LOG'.

      CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
        EXPORTING
          i_s_display_profile  = display_profile
        EXCEPTIONS
          profile_inconsistent = 1
          internal_error       = 2
          no_data_available    = 3
          no_authority         = 4
          OTHERS               = 5.
      IF ( sy-subrc <> 0 AND sy-subrc <> 3 ).
        MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD delete_messages.
    CLEAR mt_messages.

    IF ( mv_handle IS NOT INITIAL ).
      CALL FUNCTION 'BAL_LOG_MSG_DELETE_ALL'
        EXPORTING
          i_log_handle  = mv_handle
        EXCEPTIONS
          log_not_found = 1
          OTHERS        = 2.
      IF ( sy-subrc <> 0 ).
        MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno DISPLAY LIKE sy-msgty
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_base DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES:
      type_object_name TYPE c LENGTH 30,
      type_object_type TYPE trobjtype,
      type_language    TYPE syst-langu,
      BEGIN OF type_instance_ident,
        objname TYPE type_object_name,
        objtype TYPE type_object_type,   " 'TABL', 'DOMA', 'DTEL' etc.
        langu   TYPE type_language,
        ref     TYPE REF TO lcl_ddic_base,
      END OF type_instance_ident,
      type_instance_ident_tab TYPE STANDARD TABLE OF type_instance_ident
                              WITH UNIQUE SORTED KEY key COMPONENTS objname objtype langu,
      type_objname_range      TYPE RANGE OF type_object_name,
      type_objname_tab        TYPE STANDARD TABLE OF type_object_name WITH DEFAULT KEY,
      type_text_language      TYPE t002t,
      BEGIN OF type_objclass_def,
        objclass TYPE rsobj_cls,
        text     TYPE c LENGTH 72,
      END OF type_objclass_def,
      BEGIN OF ty_transport_info,
        obj_name TYPE e071-obj_name, " Name der Tabelle / View
        object   TYPE e071-object,   " TABL oder VIEW
        trkorr   TYPE e070-trkorr,   " Transportauftragsnummer
        as4user  TYPE e070-as4user,  " Inhaber des Auftrags
        trstatus TYPE e070-trstatus, " Status (R = Freigegeben, D = Änderbar)
        as4date  TYPE e070-as4date,  " Letztes Änderungsdatum
        as4time  TYPE e070-as4time,  " Letzte Änderungszeit
        strkorr  TYPE e070-strkorr,  " Übergeordneter Auftrag (falls Aufgabe)
      END OF ty_transport_info,
      type_transport_infos TYPE STANDARD TABLE OF ty_transport_info WITH EMPTY KEY.

    CONSTANTS:
      con_active_state TYPE ddobjstate VALUE 'A'.

    CLASS-METHODS:
      get_instance       IMPORTING i_objname       TYPE type_object_name
                                   i_objtype       TYPE type_object_type
                                   i_langu         TYPE type_language
                                   i_load_metadata TYPE abap_bool DEFAULT abap_false
                         RETURNING VALUE(r_result) TYPE type_instance_ident
                         RAISING   cx_sy_ref_is_initial,
      read_language_text IMPORTING i_language      TYPE type_language
                                   i_spras         TYPE type_language
                         RETURNING VALUE(r_result) TYPE type_text_language.

    METHODS:
      constructor        IMPORTING i_langu   TYPE type_language
                                   i_objtype TYPE type_object_type.                                   .

  PROTECTED SECTION.
    CLASS-METHODS:
      add_instance IMPORTING i_instance_ident TYPE type_instance_ident.

    CLASS-DATA:
      instances TYPE type_instance_ident_tab.

    METHODS:
      load_metadata ABSTRACT.

    DATA:
      mv_objtype TYPE type_object_type,
      mv_langu   TYPE type_language,
      mv_loaded  TYPE abap_bool.
ENDCLASS.

CLASS lcl_ddic_base IMPLEMENTATION.
  METHOD add_instance.
    READ TABLE instances TRANSPORTING NO FIELDS
      WITH TABLE KEY objname = i_instance_ident-objname objtype = i_instance_ident-objtype langu = i_instance_ident-langu.
    IF ( sy-subrc <> 0 ).
      INSERT i_instance_ident INTO TABLE instances.
    ENDIF.
  ENDMETHOD.

  METHOD constructor.
    mv_objtype = i_objtype.
    mv_langu   = COND #( WHEN i_langu IS INITIAL THEN sy-langu ELSE i_langu ).
  ENDMETHOD.

  METHOD get_instance.
    READ TABLE instances INTO r_result
      WITH TABLE KEY objname = i_objname objtype = i_objtype langu = i_langu.
    IF ( sy-subrc <> 0 OR r_result-ref IS INITIAL  ).
      RAISE EXCEPTION TYPE cx_sy_ref_is_initial
        EXPORTING
          textid = cx_sy_ref_is_initial=>cx_sy_ref_is_initial.
    ENDIF.

    IF ( i_load_metadata = abap_true ).
      r_result-ref->load_metadata( ).
    ENDIF.
  ENDMETHOD.

  METHOD read_language_text.
    SELECT SINGLE a~spras, b~sprsl, b~sptxt
      FROM t002 AS a LEFT OUTER JOIN t002t AS b
        ON a~spras = b~spras
    WHERE b~sprsl = @i_language
      AND b~spras = @i_spras
    INTO @r_result.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_table DEFINITION INHERITING FROM lcl_ddic_base CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_texttable_ref,
        tabname   TYPE dd08v-tabname,
        fieldname TYPE dd08v-fieldname,
        ref       TYPE REF TO lcl_ddic_table,
      END OF type_texttable_ref,
      BEGIN OF type_checktable_ref,
        tabname    TYPE dd08v-tabname,
        fieldname  TYPE dd08v-fieldname,
        checktable TYPE dd08v-checktable,
        ref        TYPE REF TO lcl_ddic_table,
      END OF type_checktable_ref,
      type_checktable_ref_tab   TYPE HASHED TABLE OF type_checktable_ref WITH UNIQUE KEY tabname fieldname,
      type_header               TYPE dd02v,
      type_devclass             TYPE tdevct,
      type_settings             TYPE dd09v,
      type_field                TYPE dd03p,
      type_field_tab            TYPE STANDARD TABLE OF type_field WITH DEFAULT KEY,
      type_checktable           TYPE dd08v,
      type_checktable_tab       TYPE STANDARD TABLE OF type_checktable WITH DEFAULT KEY,
      type_checktable_key       TYPE dd05m,
      type_checktable_key_tab   TYPE STANDARD TABLE OF type_checktable_key WITH DEFAULT KEY,
      type_index                TYPE dd12v,
      type_index_tab            TYPE STANDARD TABLE OF type_index WITH DEFAULT KEY,
      type_index_field          TYPE dd17v,
      type_index_field_tab      TYPE STANDARD TABLE OF type_index_field WITH DEFAULT KEY,
      type_searchhelp           TYPE dd35v,
      type_searchhelp_tab       TYPE STANDARD TABLE OF type_searchhelp WITH DEFAULT KEY,
      type_searchhelp_field     TYPE dd36m,
      type_searchhelp_field_tab TYPE STANDARD TABLE OF type_searchhelp_field WITH DEFAULT KEY,
      type_text_dataclass       TYPE dartt,
      type_tadir                TYPE tadir.

    CONSTANTS:
      con_objtype TYPE type_object_type VALUE 'TABL',
      BEGIN OF enum_tabclass,
        transparent TYPE type_header-tabclass VALUE 'TRANSP',
        pool        TYPE type_header-tabclass VALUE 'POOL',
        cluster     TYPE type_header-tabclass VALUE 'CLUSTER',
        view        TYPE type_header-tabclass VALUE 'VIEW',
        structure   TYPE type_header-tabclass VALUE 'INTTAB',
        append      TYPE type_header-tabclass VALUE 'APPEND',
      END OF enum_tabclass.

    CLASS-METHODS:
      create_instance        IMPORTING i_tabname          TYPE dd02l-tabname
                                       i_langu            TYPE sy-langu
                                       i_load_metadata    TYPE abap_bool DEFAULT abap_false
                             RETURNING VALUE(ro_instance) TYPE REF TO lcl_ddic_table
                             RAISING   cx_sy_ref_is_initial
                                       cx_sy_create_data_error,
      read_tabclass          IMPORTING i_tabname         TYPE dd02l-tabname
                             RETURNING VALUE(r_tabclass) TYPE type_header-tabclass.
    METHODS:
      constructor            IMPORTING i_tabname TYPE dd02l-tabname
                                       i_objtype TYPE type_object_type DEFAULT con_objtype
                                       i_langu   TYPE sy-langu,
      get_tabclass           RETURNING VALUE(r_tabclass) TYPE type_header-tabclass,
      get_header             RETURNING VALUE(r_result)   TYPE type_header,
      get_language_text      RETURNING VALUE(r_result)   TYPE type_text_language,
      get_devclass           RETURNING VALUE(r_result)   TYPE type_devclass,
      get_tadir              RETURNING VALUE(r_result)   TYPE type_tadir,
      get_data_class_text    RETURNING VALUE(r_result)   TYPE type_text_dataclass,
      get_transport_infos    RETURNING VALUE(r_results)  TYPE type_transport_infos,
      get_settings           RETURNING VALUE(r_result)   TYPE type_settings,
      get_fields             IMPORTING i_with_includes  TYPE abap_bool DEFAULT abap_true
                             RETURNING VALUE(r_results) TYPE type_field_tab,
      get_checktables        RETURNING VALUE(r_results)  TYPE type_checktable_tab,
      get_indexes            RETURNING VALUE(r_results)  TYPE type_index_tab,
      get_index_fields       IMPORTING i_indexname      TYPE type_index-indexname OPTIONAL
                             RETURNING VALUE(r_results) TYPE type_index_field_tab,
      get_search_helps       RETURNING VALUE(r_results)  TYPE type_searchhelp_tab,
      get_search_help_fields IMPORTING i_search_help    TYPE type_searchhelp-shlpname OPTIONAL
                             RETURNING VALUE(r_results) TYPE type_searchhelp_field_tab,
      get_checktable_keys    IMPORTING i_checktable     TYPE dd08v-checktable OPTIONAL
                             RETURNING VALUE(r_results) TYPE type_checktable_key_tab,
      get_checktable_ref     IMPORTING i_fieldname     TYPE dd08v-fieldname
                             RETURNING VALUE(r_result) TYPE REF TO lcl_ddic_table,
      get_texttable_ref      RETURNING VALUE(r_result)   TYPE REF TO lcl_ddic_table.

  PROTECTED SECTION.
    METHODS:
      load_metadata REDEFINITION,
      read_header,
      read_devclass,
      read_tadir,
      read_transport_info,
      read_data_class,
      read_language.

    DATA:
      m_tabname      TYPE dd02l-tabname,
      m_texttable    TYPE type_texttable_ref,
      mt_checktables TYPE type_checktable_ref_tab,

      BEGIN OF m_table_data,
        header             TYPE type_header,
        devclass           TYPE type_devclass,
        tadir              TYPE type_tadir,
        transport_infos    TYPE type_transport_infos,
        techn_settings     TYPE type_settings,
        object_state       TYPE ddgotstate,
        fields             TYPE type_field_tab,
        checktables        TYPE type_checktable_tab,
        checktable_keys    TYPE type_checktable_key_tab,
        indexes            TYPE type_index_tab,
        index_fields       TYPE type_index_field_tab,
        search_helps       TYPE type_searchhelp_tab,
        search_help_fields TYPE type_searchhelp_field_tab,
      END OF m_table_data,
      BEGIN OF m_text_data,
        language   TYPE type_text_language,
        data_class TYPE type_text_dataclass,
      END OF m_text_data.
ENDCLASS.

CLASS lcl_ddic_dbtable DEFINITION FINAL CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    METHODS:
      get_tabclass REDEFINITION.
ENDCLASS.

CLASS lcl_ddic_dbtable IMPLEMENTATION.
  METHOD get_tabclass.
    r_tabclass = enum_tabclass-transparent.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_view DEFINITION CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    TYPES:
      type_view_header     TYPE dd25v,
      type_base_tables     TYPE STANDARD TABLE OF dd26v WITH EMPTY KEY,
      type_view_fields     TYPE STANDARD TABLE OF dd27p  WITH EMPTY KEY,
      type_view_joins      TYPE STANDARD TABLE OF dd28j  WITH EMPTY KEY,
      type_view_conditions TYPE STANDARD TABLE OF dd28v  WITH EMPTY KEY.

    METHODS:
      get_tabclass    REDEFINITION,
      get_view_header RETURNING VALUE(r_result)  TYPE type_view_header,
      get_view_fields RETURNING VALUE(r_results) TYPE type_view_fields,
      get_base_tables RETURNING VALUE(r_results) TYPE type_base_tables,
      get_view_joins  RETURNING VALUE(r_results) TYPE type_view_joins,
      get_conditions  RETURNING VALUE(r_results) TYPE type_view_conditions.

  PROTECTED SECTION.
    METHODS:
      load_metadata REDEFINITION.

    DATA:
      BEGIN OF m_view_data,
        header          TYPE type_view_header,
        base_tables     TYPE type_base_tables,
        view_fields     TYPE type_view_fields,
        view_joins      TYPE type_view_joins,
        view_conditions TYPE type_view_conditions,
      END OF m_view_data.
ENDCLASS.

CLASS lcl_ddic_view IMPLEMENTATION.
  METHOD load_metadata.
    super->load_metadata( ).
    CALL FUNCTION 'DDIF_VIEW_GET'
      EXPORTING
        name          = m_tabname
        state         = con_active_state
        langu         = mv_langu
      IMPORTING
        dd25v_wa      = m_view_data-header
      TABLES
        dd26v_tab     = m_view_data-base_tables
        dd27p_tab     = m_view_data-view_fields
        dd28j_tab     = m_view_data-view_joins
        dd28v_tab     = m_view_data-view_conditions
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF ( sy-subrc <> 0 ).
      message_log->add_message( i_read_sy = abap_true ).
    ENDIF.
  ENDMETHOD.

  METHOD get_tabclass.
    r_tabclass = enum_tabclass-view.
  ENDMETHOD.

  METHOD get_view_header.
    r_result = m_view_data-header.
  ENDMETHOD.

  METHOD get_view_fields.
    r_results = m_view_data-view_fields.
  ENDMETHOD.

  METHOD get_base_tables.
    r_results = m_view_data-base_tables.
  ENDMETHOD.

  METHOD get_view_joins.
    r_results = m_view_data-view_joins.
  ENDMETHOD.

  METHOD get_conditions.
    r_results = m_view_data-view_conditions.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_pool_table DEFINITION FINAL CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    METHODS:
      get_tabclass REDEFINITION.
ENDCLASS.

CLASS lcl_ddic_pool_table IMPLEMENTATION.
  METHOD get_tabclass.
    r_tabclass = enum_tabclass-pool.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_cluster_table DEFINITION FINAL CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    METHODS:
      get_tabclass REDEFINITION.
ENDCLASS.

CLASS lcl_ddic_cluster_table IMPLEMENTATION.
  METHOD get_tabclass.
    r_tabclass = enum_tabclass-cluster.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_structure DEFINITION FINAL CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    METHODS:
      get_tabclass REDEFINITION.
ENDCLASS.

CLASS lcl_ddic_structure IMPLEMENTATION.
  METHOD get_tabclass.
    r_tabclass = enum_tabclass-structure.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_append DEFINITION FINAL CREATE PUBLIC INHERITING FROM lcl_ddic_table.
  PUBLIC SECTION.
    METHODS:
      get_tabclass REDEFINITION.
ENDCLASS.

CLASS lcl_ddic_append IMPLEMENTATION.
  METHOD get_tabclass.
    r_tabclass = enum_tabclass-append.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_domain DEFINITION FINAL CREATE PRIVATE INHERITING FROM lcl_ddic_base.
  PUBLIC SECTION.
    TYPES:
      type_header    TYPE dd01v,
      type_value     TYPE dd07v,
      type_value_tab TYPE STANDARD TABLE OF type_value WITH DEFAULT KEY.

    CONSTANTS:
      con_objtype TYPE type_object_type VALUE 'DOMA'.

    CLASS-METHODS:
      create_instance IMPORTING i_domname          TYPE type_object_name
                                i_langu            TYPE type_language
                                i_load_metadata    TYPE abap_bool DEFAULT abap_true
                      RETURNING VALUE(ro_instance) TYPE REF TO lcl_ddic_domain
                      RAISING   cx_sy_ref_is_initial.

    METHODS:
      constructor     IMPORTING i_domname TYPE dd01l-domname
                                i_objtype TYPE type_object_type DEFAULT con_objtype
                                i_langu   TYPE type_language,
      get_header      RETURNING VALUE(r_result)  TYPE type_header,
      get_value       IMPORTING i_domvalue     TYPE type_value-domvalue_l
                      RETURNING VALUE(r_value) TYPE type_value,
      get_values      RETURNING VALUE(r_results) TYPE type_value_tab.

  PROTECTED SECTION.
    METHODS:
      load_metadata   REDEFINITION.

  PRIVATE SECTION.
    DATA:
      m_domname TYPE dd01l-domname,

      BEGIN OF m_data,
        header TYPE type_header,
        values TYPE type_value_tab,
      END OF m_data.
ENDCLASS.

CLASS lcl_ddic_data_element DEFINITION FINAL CREATE PRIVATE INHERITING FROM lcl_ddic_base.
  PUBLIC SECTION.
    TYPES:
      type_header            TYPE dd04v,
      type_memory_para       TYPE tpara,
      type_searchhelp        TYPE dd30v,
      type_searchhelp_fields TYPE STANDARD TABLE OF dd36m WITH DEFAULT KEY.

    CONSTANTS:
      con_objtype TYPE type_object_type VALUE 'DTEL'.

    CLASS-METHODS:
      create_instance IMPORTING i_rollname         TYPE type_object_name
                                i_langu            TYPE type_language
                                i_load_metadata    TYPE abap_bool DEFAULT abap_true
                      RETURNING VALUE(ro_instance) TYPE REF TO lcl_ddic_data_element
                      RAISING   cx_sy_ref_is_initial.

    METHODS:
      constructor     IMPORTING i_rollname TYPE dd04l-rollname
                                i_objtype  TYPE type_object_type DEFAULT con_objtype
                                i_langu    TYPE type_language,
      get_header      RETURNING VALUE(r_result) TYPE type_header,
      get_memory_para RETURNING VALUE(r_result) TYPE type_memory_para,
      get_domain_ref  RETURNING VALUE(r_result) TYPE REF TO lcl_ddic_domain,
      get_searchhelp  RETURNING VALUE(r_result) TYPE type_searchhelp.

  PROTECTED SECTION.
    METHODS:
      load_metadata   REDEFINITION.

  PRIVATE SECTION.
    DATA:
      m_rollname   TYPE dd04l-rollname,
      m_domain_ref TYPE REF TO lcl_ddic_domain,

      BEGIN OF m_data,
        header      TYPE type_header,
        memory_para TYPE type_memory_para,
        searchhelp  TYPE type_searchhelp,
      END OF m_data.
ENDCLASS.

CLASS lcl_ddic_table IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_objtype = con_objtype i_langu = i_langu ).
    m_tabname = i_tabname.

    read_header( ).
  ENDMETHOD.

  METHOD get_tabclass.
  ENDMETHOD.

  METHOD read_tabclass.
    SELECT SINGLE tabclass FROM dd02l
      WHERE tabname  = @i_tabname
        AND as4local = @con_active_state
      INTO @r_tabclass.
  ENDMETHOD.

  METHOD create_instance.
    DATA instance TYPE REF TO lcl_ddic_table.
    TRY.
        DATA(ls_instance) = get_instance( i_objname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
      CATCH cx_sy_ref_is_initial.
        CASE lcl_ddic_table=>read_tabclass( i_tabname ).
          WHEN enum_tabclass-transparent.
            instance = NEW lcl_ddic_dbtable( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN enum_tabclass-pool.
            instance = NEW lcl_ddic_pool_table( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN enum_tabclass-cluster.
            instance = NEW lcl_ddic_cluster_table( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN enum_tabclass-view.
            instance = NEW lcl_ddic_view( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN enum_tabclass-structure.
            instance = NEW lcl_ddic_structure( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN enum_tabclass-append.
            instance = NEW lcl_ddic_append( i_tabname = i_tabname i_objtype = con_objtype i_langu = i_langu ).
          WHEN OTHERS.
            RAISE EXCEPTION TYPE cx_sy_create_data_error
              EXPORTING
                textid   = cx_sy_create_data_error=>cx_sy_create_data_error
                typename = CONV #( i_tabname ).
        ENDCASE.

        ls_instance-objname = i_tabname.
        ls_instance-objtype = instance->mv_objtype.
        ls_instance-langu   = i_langu.
        ls_instance-ref     = instance.
        add_instance( ls_instance ).
    ENDTRY.

    ro_instance ?= ls_instance-ref.

    IF ( i_load_metadata = abap_true ).
      ro_instance->load_metadata( ).
    ENDIF.
  ENDMETHOD.

  METHOD get_header.
    r_result = m_table_data-header.
  ENDMETHOD.

  METHOD get_devclass.
    r_result = m_table_data-devclass.
  ENDMETHOD.

  METHOD get_tadir.
    r_result = m_table_data-tadir.
  ENDMETHOD.

  METHOD get_data_class_text.
    r_result = m_text_data-data_class.
  ENDMETHOD.

  METHOD get_transport_infos.
    r_results = m_table_data-transport_infos.
  ENDMETHOD.

  METHOD get_language_text.
    r_result = m_text_data-language.
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

  METHOD get_checktables.
    r_results = m_table_data-checktables.
  ENDMETHOD.

  METHOD get_checktable_keys.
    IF ( i_checktable IS INITIAL ).
      r_results = m_table_data-checktable_keys.
    ELSE.
      LOOP AT m_table_data-checktable_keys ASSIGNING FIELD-SYMBOL(<key>) WHERE checktable = i_checktable.
        APPEND <key> TO r_results.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_indexes.
    r_results = m_table_data-indexes.
  ENDMETHOD.

  METHOD get_index_fields.
    IF ( i_indexname IS INITIAL ).
      r_results = m_table_data-index_fields.
    ELSE.
      LOOP AT m_table_data-index_fields ASSIGNING FIELD-SYMBOL(<field>) WHERE indexname = i_indexname.
        APPEND <field> TO r_results.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_search_helps.
    r_results = m_table_data-search_helps.
  ENDMETHOD.

  METHOD get_search_help_fields.
    IF ( i_search_help IS INITIAL ).
      r_results = m_table_data-search_help_fields.
    ELSE.
      LOOP AT m_table_data-search_help_fields ASSIGNING FIELD-SYMBOL(<key>) WHERE shlpname = i_search_help.
        APPEND <key> TO r_results.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_texttable_ref.
    r_result = m_texttable-ref.
  ENDMETHOD.

  METHOD get_checktable_ref.
    READ TABLE mt_checktables ASSIGNING FIELD-SYMBOL(<fs_checktable>)
      WITH TABLE KEY tabname = m_tabname fieldname = i_fieldname.
    IF ( sy-subrc = 0 ).
      IF ( <fs_checktable>-ref IS INITIAL ).
        TRY.
            <fs_checktable>-ref = create_instance( i_tabname = <fs_checktable>-checktable i_langu = mv_langu ).
            <fs_checktable>-ref->load_metadata( ).
            r_result = <fs_checktable>-ref.
          CATCH cx_dynamic_check INTO DATA(error).
            message_log->add_exception(
                i_error  = error
                i_method = 'LCL_DDIC_TABLE->GET_CHECKTABLE_REF'
                i_object = <fs_checktable>-checktable
            ).
        ENDTRY.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD load_metadata.
    DATA:
      ls_checktable_header LIKE m_table_data-header,
      lt_checktables       LIKE m_table_data-checktables.

    IF ( mv_loaded = abap_false ).
      CALL FUNCTION 'DDIF_TABL_GET'
        EXPORTING
          name          = m_tabname
          state         = con_active_state
          langu         = mv_langu
        IMPORTING
          gotstate      = m_table_data-object_state
          dd02v_wa      = m_table_data-header
          dd09l_wa      = m_table_data-techn_settings
        TABLES
          dd03p_tab     = m_table_data-fields
          dd05m_tab     = m_table_data-checktable_keys
          dd08v_tab     = lt_checktables
          dd12v_tab     = m_table_data-indexes
          dd17v_tab     = m_table_data-index_fields
          dd35v_tab     = m_table_data-search_helps
          dd36m_tab     = m_table_data-search_help_fields
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF ( sy-subrc <> 0 ).
        message_log->add_message( i_read_sy = abap_true ). RETURN.
      ELSE.
        mv_loaded = abap_true.

        " Re-read devclass since LOAD_METADATA overwrites the header
        read_devclass( ).
        read_data_class( ).
        read_tadir( ).
        read_transport_info( ).
        read_language( ).

        " Search texttable
        CALL FUNCTION 'DDUT_TEXTTABLE_GET'
          EXPORTING
            tabname    = m_table_data-header-tabname
          IMPORTING
            texttable  = m_texttable-tabname
            checkfield = m_texttable-fieldname.

        IF ( m_texttable-tabname IS NOT INITIAL ).
          m_texttable-ref = NEW #( i_tabname = m_texttable-tabname i_objtype = con_objtype i_langu = mv_langu ).
          m_texttable-ref->load_metadata( ).
        ENDIF.

        " Check tables

        " korrect sorting of checktables
        LOOP AT m_table_data-fields ASSIGNING FIELD-SYMBOL(<field>) WHERE checktable IS NOT INITIAL.
          READ TABLE lt_checktables INTO DATA(checktable)
            WITH KEY tabname   = <field>-tabname
                     fieldname = <field>-fieldname.
          IF ( sy-subrc = 0 ).
            APPEND checktable TO m_table_data-checktables.
          ENDIF.
        ENDLOOP.

        DATA(lv_lines) = lines( m_table_data-checktables ).
        DO lv_lines TIMES.
          DATA(lv_idx) = lv_lines - sy-index + 1.
          READ TABLE m_table_data-checktables ASSIGNING FIELD-SYMBOL(<fs_checktable>) INDEX lv_idx.

          READ TABLE m_table_data-checktable_keys TRANSPORTING NO FIELDS WITH KEY checktable = <fs_checktable>-checktable.
          IF sy-subrc <> 0.
            DELETE m_table_data-checktables INDEX lv_idx. CONTINUE.
          ENDIF.

          CALL FUNCTION 'DDIF_TABL_GET'
            EXPORTING
              name          = <fs_checktable>-checktable
              state         = con_active_state
              langu         = mv_langu
            IMPORTING
              dd02v_wa      = ls_checktable_header
            EXCEPTIONS
              illegal_input = 1
              OTHERS        = 2.
          IF ( sy-subrc <> 0 ).
            message_log->add_message( i_read_sy = abap_true ). RETURN.
          ELSE.
            <fs_checktable>-ddtext = ls_checktable_header-ddtext.
          ENDIF.
        ENDDO.

        LOOP AT m_table_data-checktables ASSIGNING <fs_checktable>.
          INSERT VALUE #(
            tabname    = <fs_checktable>-tabname
            fieldname  = <fs_checktable>-fieldname
            checktable = <fs_checktable>-checktable
          ) INTO TABLE mt_checktables.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read_header.
    CALL FUNCTION 'DDIF_TABL_GET'
      EXPORTING
        name          = m_tabname
        state         = con_active_state
        langu         = mv_langu
      IMPORTING
        dd02v_wa      = m_table_data-header
      EXCEPTIONS
        illegal_input = 1
        OTHERS        = 2.
    IF ( sy-subrc <> 0 ).
      message_log->add_message( i_read_sy = abap_true ). RETURN.
    ELSEIF ( m_table_data-header IS NOT INITIAL ).
      read_devclass( ).
    ENDIF.

    IF ( m_table_data-header-ddlanguage IS INITIAL ).
      message_log->add_message_text(
        EXPORTING
          i_text   = |Table { m_tabname }: Description in { read_language_text( i_language = mv_langu i_spras = sy-langu )-sptxt } is not available|
          i_msgtyp = 'W'
          i_method = 'DDIF_TABL_GET'
          i_object = m_tabname
      ).
    ENDIF.
  ENDMETHOD.

  METHOD read_devclass.
    DATA(lv_object)   = COND tadir-object( WHEN m_table_data-header-tabclass = enum_tabclass-view THEN 'VIEW' ELSE 'TABL' ).
    DATA(lv_obj_name) = CONV tadir-obj_name( m_table_data-header-tabname ).
    SELECT SINGLE a~devclass, c~spras, c~ctext
      FROM tadir AS a LEFT OUTER JOIN tdevct AS c ON a~devclass = c~devclass AND c~spras = @mv_langu
      INTO @m_table_data-devclass
      WHERE a~pgmid = 'R3TR' AND a~object = @lv_object AND a~obj_name = @lv_obj_name.
  ENDMETHOD.

  METHOD read_data_class.
    SELECT SINGLE a~tabart, b~ddlangu, b~darttext
      FROM ddart AS a LEFT OUTER JOIN dartt AS b ON a~tabart = b~tabart AND b~ddlangu = @mv_langu
      INTO @m_text_data-data_class
      WHERE a~tabart = @m_table_data-techn_settings-tabart.
  ENDMETHOD.

  METHOD read_tadir.
    DATA(lv_object) = COND tadir-object( WHEN m_table_data-header-tabclass = enum_tabclass-view THEN 'VIEW' ELSE 'TABL' ).

    SELECT SINGLE * FROM tadir
      WHERE pgmid = 'R3TR'
        AND object   = @lv_object
        AND obj_name = @m_table_data-header-tabname
      INTO @m_table_data-tadir.
    IF ( sy-subrc = 0 AND lcl_input_fields=>check_tables->* = abap_true ).
      DATA checktab TYPE STANDARD TABLE OF dcinspchk WITH EMPTY KEY.
      CALL FUNCTION 'DDIF_DD_CHECK'
        EXPORTING
          objname  = CONV ddobjname( m_table_data-tadir-obj_name )
          objtype  = m_table_data-tadir-object
        TABLES
          checktab = checktab.
      LOOP AT checktab INTO DATA(checkdata) WHERE text IS NOT INITIAL.
        message_log->add_message_text(
          i_text   = checkdata-text
          i_msgtyp = checkdata-msgty
          i_method = 'DDIF_DD_CHECK'
          i_object = |{ m_table_data-tadir-object } { m_table_data-tadir-obj_name }| ).
      ENDLOOP.

      DATA objtype TYPE ddeutype.
      CASE m_table_data-header-tabclass.
        WHEN enum_tabclass-transparent.
          objtype = 'T'.
        WHEN enum_tabclass-view.
          objtype = 'V'.
        WHEN enum_tabclass-structure OR enum_tabclass-append.
          objtype = 'U'.
        WHEN enum_tabclass-pool.
          objtype = 'X'.
        WHEN enum_tabclass-cluster.
          objtype = 'Y'.
      ENDCASE.

      DATA messages TYPE ddmessages.
      CALL FUNCTION 'RS_DD_CHECK'
        EXPORTING
          objname       = m_table_data-header-tabname
          objtype       = objtype
          i_no_dialog   = 'X'
          i_no_ui       = 'X'
          with_messages = 'X'
        IMPORTING
*         E_CHECK_RESULT       =
          messages      = messages.

      LOOP AT messages ASSIGNING FIELD-SYMBOL(<message>) WHERE sever <> 'N' AND sever <> 'I'.
        message_log->add_message(
            i_msg     = VALUE #(
              msgid = <message>-arbgb
              msgno = <message>-msgnr
              msgty = <message>-sever
              msgv1 = <message>-var1
              msgv2 = <message>-var2
              msgv3 = <message>-var3
              msgv4 = <message>-var4 )
            i_method  = 'RS_DD_CHECK'
            i_object  = m_table_data-header-tabname ).
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD read_transport_info.
    IF ( m_table_data-tadir IS INITIAL ).
      RETURN.
    ENDIF.

    SELECT e071~obj_name,
           e071~object,
           e070~trkorr,
           e070~as4user,
           e070~trstatus,
           e070~as4date,
           e070~as4time,
           e070~strkorr
      FROM e071
      INNER JOIN e070 ON e070~trkorr = e071~trkorr
      INTO TABLE @m_table_data-transport_infos
      UP TO 100 ROWS
      WHERE e071~pgmid    = 'R3TR'
        AND e071~object   = @m_table_data-tadir-object
        AND e071~obj_name = @m_table_data-header-tabname.
  ENDMETHOD.

  METHOD read_language.
    m_text_data-language = read_language_text( i_language = mv_langu i_spras = mv_langu ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_domain IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_objtype = i_objtype i_langu = i_langu ).
    m_domname = i_domname.
  ENDMETHOD.

  METHOD create_instance.
    TRY.
        DATA(ls_instance) = get_instance( i_objname = i_domname i_objtype = con_objtype i_langu = i_langu ).
      CATCH cx_sy_ref_is_initial.
        DATA(instance) = NEW lcl_ddic_domain( i_domname = i_domname i_langu = i_langu ).
        ls_instance-objname = i_domname.
        ls_instance-objtype = instance->mv_objtype.
        ls_instance-langu   = i_langu.
        ls_instance-ref     = instance.

        add_instance( ls_instance ).
    ENDTRY.

    ro_instance ?= ls_instance-ref.

    IF ( i_load_metadata = abap_true ).
      ro_instance->load_metadata( ).
    ENDIF.
  ENDMETHOD.

  METHOD load_metadata.
    IF ( mv_loaded = abap_false ).
      CALL FUNCTION 'DDIF_DOMA_GET'
        EXPORTING
          name          = m_domname
          state         = con_active_state
          langu         = mv_langu
        IMPORTING
          dd01v_wa      = m_data-header
        TABLES
          dd07v_tab     = m_data-values
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF ( sy-subrc <> 0 ).
        message_log->add_message( i_read_sy = abap_true ).
      ELSE.
        mv_loaded = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_header.
    r_result = m_data-header.
  ENDMETHOD.

  METHOD get_value.
    READ TABLE m_data-values INTO r_value WITH KEY domvalue_l = i_domvalue ddlanguage = mv_langu.
  ENDMETHOD.

  METHOD get_values.
    r_results = m_data-values.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_data_element IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_objtype = con_objtype i_langu = i_langu ).
    m_rollname = i_rollname.
  ENDMETHOD.

  METHOD create_instance.
    TRY.
        DATA(ls_instance) = get_instance( i_objname = i_rollname i_objtype = con_objtype i_langu = i_langu ).
      CATCH cx_sy_ref_is_initial.
        DATA(instance) = NEW lcl_ddic_data_element( i_rollname = i_rollname i_langu = i_langu ).
        ls_instance-objname = i_rollname.
        ls_instance-objtype = instance->mv_objtype.
        ls_instance-langu   = i_langu.
        ls_instance-ref     = instance.

        add_instance( ls_instance ).
    ENDTRY.

    ro_instance ?= ls_instance-ref.

    IF ( i_load_metadata = abap_true ).
      ro_instance->load_metadata( ).
    ENDIF.
  ENDMETHOD.

  METHOD load_metadata.
    IF ( mv_loaded = abap_false ).
      CALL FUNCTION 'DDIF_DTEL_GET'
        EXPORTING
          name          = m_rollname
          state         = con_active_state
          langu         = mv_langu
        IMPORTING
          dd04v_wa      = m_data-header
          tpara_wa      = m_data-memory_para
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF ( sy-subrc <> 0 ).
        message_log->add_message( i_read_sy = abap_true ).
      ELSE.
        mv_loaded = abap_true.

        IF ( m_data-header-shlpname IS NOT INITIAL ).
          CALL FUNCTION 'DDIF_SHLP_GET'
            EXPORTING
              name          = m_data-header-shlpname
              state         = con_active_state
              langu         = mv_langu
            IMPORTING
              dd30v_wa      = m_data-searchhelp
            EXCEPTIONS
              illegal_input = 1
              OTHERS        = 2.
          IF ( sy-subrc <> 0 ).
            message_log->add_message( i_read_sy = abap_true ).
          ENDIF.
        ENDIF.

        IF ( m_data-header-domname IS NOT INITIAL ).
          TRY.
              m_domain_ref = lcl_ddic_domain=>create_instance(
                i_domname = m_data-header-domname
                i_langu   = mv_langu ).
            CATCH cx_dynamic_check INTO DATA(error).
              message_log->add_exception(
                i_error  = error
                i_method = 'LCL_DDIC_DOMAIN=>CREATE_INSTANCE'
                i_object = m_data-header-domname ).
          ENDTRY.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_header.
    r_result = m_data-header.
  ENDMETHOD.

  METHOD get_memory_para.
    r_result = m_data-memory_para.
  ENDMETHOD.

  METHOD get_domain_ref.
    r_result = m_domain_ref.
  ENDMETHOD.

  METHOD get_searchhelp.
    r_result = m_data-searchhelp.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_alv_dynamic_tools DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_output_simple,
        index     TYPE i,
        fieldname TYPE fieldname,
        fieldtext TYPE scrtext_m,
        value     TYPE scrtext_l,
        descr     TYPE val_text,
      END OF type_output_simple,
      type_output_simple_tab TYPE STANDARD TABLE OF type_output_simple WITH DEFAULT KEY.

    CLASS-METHODS:
      set_salv_defaults         IMPORTING i_salv_table        TYPE REF TO cl_salv_table,
      get_structure_fields_for  IMPORTING i_structure      TYPE data
                                          i_language       TYPE sy-langu
                                          i_check_empty    TYPE abap_bool DEFAULT abap_true
                                RETURNING VALUE(rt_fields) TYPE type_output_simple_tab,
      set_output_simple_columns IMPORTING i_columns_table TYPE REF TO cl_salv_columns_table
                                          i_optimize      TYPE abap_bool DEFAULT abap_false,
      check_table_field_empty   IMPORTING i_column_name       TYPE lvc_fname
                                          i_table             TYPE STANDARD TABLE
                                RETURNING VALUE(rv_not_empty) TYPE abap_bool.
  PRIVATE SECTION.
    CLASS-METHODS:
      get_structure_fields      IMPORTING i_structure         TYPE data
                                          i_language          TYPE sy-langu
                                          i_check_empty       TYPE abap_bool  DEFAULT abap_true
                                          i_struct_components TYPE cl_abap_structdescr=>component_table
                                RETURNING VALUE(rt_fields)    TYPE type_output_simple_tab.

    CLASS-DATA:
      field_index TYPE i.
ENDCLASS.

CLASS lcl_alv_dynamic_tools IMPLEMENTATION.
  METHOD set_salv_defaults.
    i_salv_table->get_functions( )->set_find( ).
    i_salv_table->get_functions( )->set_export_html( ).
    i_salv_table->get_functions( )->set_filter( ).
    i_salv_table->get_functions( )->set_filter_delete( ).
    i_salv_table->get_functions( )->set_export_spreadsheet( ).
    i_salv_table->get_functions( )->set_export_localfile( ).
    i_salv_table->get_functions( )->set_print( ).
    i_salv_table->get_functions( )->set_sort_asc( ).
    i_salv_table->get_functions( )->set_sort_desc( ).
    i_salv_table->get_functions( )->set_layout_change( ).
    i_salv_table->get_functions( )->set_layout_load( ).
    i_salv_table->get_functions( )->set_layout_save( ).
    i_salv_table->get_display_settings( )->set_striped_pattern( if_salv_c_bool_sap=>true ).
    i_salv_table->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>single ).
    i_salv_table->display( ).
  ENDMETHOD.

  METHOD get_structure_fields_for.
    IF ( i_structure IS INITIAL ).
      RETURN.
    ENDIF.

    CLEAR field_index.

    TRY.
        DATA(structdescr) = CAST cl_abap_structdescr( cl_abap_typedescr=>describe_by_data( i_structure ) ).
        rt_fields = get_structure_fields(
          i_structure         = i_structure
          i_language          = i_language
          i_check_empty       = i_check_empty
          i_struct_components = structdescr->get_components( ) ).
      CATCH cx_sy_move_cast_error INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_ALV_DYNAMIC_TOOLS=>GET_STRUCTURE_FIELDS_FOR' ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_structure_fields.
    DATA:
      value     TYPE type_output_simple-value,
      fieldtext TYPE string,
      descr     TYPE string.

    FIELD-SYMBOLS <value> TYPE data.

    LOOP AT i_struct_components INTO DATA(component).
      IF ( component-as_include = abap_true ).
        APPEND LINES OF get_structure_fields(
          i_structure         = i_structure
          i_language          = i_language
          i_struct_components = CAST cl_abap_structdescr( component-type )->get_components( ) ) TO rt_fields.
      ELSE.
        ASSIGN COMPONENT component-name OF STRUCTURE i_structure TO <value>.
        IF ( sy-subrc = 0 AND ( <value> IS NOT INITIAL OR i_check_empty = abap_false ) ).
          DATA(ddic_field) = CAST cl_abap_elemdescr( component-type )->get_ddic_field( ).
          fieldtext = COND #( WHEN ddic_field-scrtext_m IS NOT INITIAL THEN ddic_field-scrtext_m
                              WHEN ddic_field-scrtext_l IS NOT INITIAL THEN ddic_field-scrtext_l
                              WHEN ddic_field-scrtext_s IS NOT INITIAL THEN ddic_field-scrtext_s
                              WHEN ddic_field-fieldtext IS NOT INITIAL THEN ddic_field-fieldtext
                            ).

          field_index = field_index + 1.

          IF ( <value> IS NOT INITIAL ).
            value = <value>.

            IF ( ddic_field-domname IS NOT INITIAL ).
              TRY.
                  DATA(domain_value) = lcl_ddic_domain=>create_instance(
                    i_domname = ddic_field-domname
                    i_langu   = i_language )->get_value( i_domvalue = CONV #( <value> ) ).

                  descr = domain_value-ddtext.
                CATCH cx_sy_ref_is_initial INTO DATA(error).
                  message_log->add_exception(
                    i_error  = error
                    i_method = 'LCL_DDIC_DOMAIN=>CREATE_INSTANCE'
                    i_object = ddic_field-domname ).
              ENDTRY.
            ENDIF.

            IF ( ddic_field-datatype = 'DATS' ).
              DATA(date) = CONV dats( value ).
              value = |{ date DATE = USER }|.
            ENDIF.

            IF ( ddic_field-datatype = 'TIMS' ).
              DATA(time) = CONV tims( value ).
              value = |{ time TIME = USER }|.
            ENDIF.
          ENDIF.

          APPEND VALUE #(
            index     = field_index
            fieldname = component-name
            fieldtext = fieldtext
            value     = value
            descr     = descr ) TO rt_fields.
        ENDIF.
      ENDIF.

      CLEAR: value, fieldtext, descr.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_output_simple_columns.
    IF ( i_optimize IS SUPPLIED ).
      DATA(column_optimize) = i_optimize.
    ELSE.
      column_optimize = COND #( WHEN lcl_control_metric=>get_screen_x( ) <= 1500 THEN abap_true ELSE abap_false ).
    ENDIF.

    DATA column_table TYPE REF TO cl_salv_column_table.
    DATA(columns) = i_columns_table->get( ).
    LOOP AT columns INTO DATA(column).
      column_table ?= column-r_column.

      IF ( column-columnname = 'INDEX' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).
        column_table->set_visible( if_salv_c_bool_sap=>false ).

        column-r_column->set_short_text( 'Index'(c01) ).
        column-r_column->set_medium_text( 'Index'(c02) ).
        column-r_column->set_long_text( 'Index'(c03) ).
      ELSEIF ( column-columnname = 'FIELDNAME' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).
        column_table->set_visible( if_salv_c_bool_sap=>false ).

        column-r_column->set_short_text( 'Field'(c04) ).
        column-r_column->set_medium_text( 'Field'(c05) ).
        column-r_column->set_long_text( 'Field'(c06) ).
      ELSEIF ( column-columnname = 'FIELDTEXT' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).

        column-r_column->set_short_text( 'Name'(c07) ).
        column-r_column->set_medium_text( 'Name'(c08) ).
        column-r_column->set_long_text( 'Name'(c09) ).

        IF ( column_optimize = abap_true ).
          column-r_column->set_optimized( ).
        ELSE.
          column-r_column->set_fixed_header_text( 'M' ).
        ENDIF.
      ELSEIF ( column-columnname = 'VALUE' ).
        column_table->set_key( if_salv_c_bool_sap=>false ).

        column-r_column->set_short_text( 'Value'(c10) ).
        column-r_column->set_medium_text( 'Value'(c11) ).
        column-r_column->set_long_text( 'Value'(c12) ).

        IF ( column_optimize = abap_true ).
          column-r_column->set_optimized( ).
        ELSE.
          column-r_column->set_output_length( '30' ).
        ENDIF.
      ELSE.
        column_table->set_key( if_salv_c_bool_sap=>false ).

        column-r_column->set_short_text( 'Descr.'(c13) ).
        column-r_column->set_medium_text( 'Description'(c14) ).
        column-r_column->set_long_text( 'Description'(c15) ).

        column-r_column->set_fixed_header_text( 'M' ).  " Last column fix (visual effect - view width ist filled)
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD check_table_field_empty.
    rv_not_empty = if_salv_c_bool_sap=>false.
    LOOP AT i_table ASSIGNING FIELD-SYMBOL(<data_line>).
      ASSIGN COMPONENT i_column_name OF STRUCTURE <data_line> TO FIELD-SYMBOL(<value>).
      IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
        rv_not_empty = if_salv_c_bool_sap=>true. EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_toolbar DEFINITION DEFERRED.
CLASS lcl_toolbar_button DEFINITION CREATE PUBLIC.
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
      get_fcode       RETURNING VALUE(rv_fcode)     TYPE ui_func,
      get_checked     RETURNING VALUE(rv_checked)   TYPE abap_bool,
      set_checked     IMPORTING i_checked           TYPE abap_bool,
      get_icon        RETURNING VALUE(rv_icon)      TYPE iconname,
      set_icon        IMPORTING i_icon              TYPE iconname,
      set_text        IMPORTING i_text              TYPE text40,
      get_text        RETURNING VALUE(rv_text)      TYPE text40,
      set_quickinfo   IMPORTING i_quickinfo         TYPE iconquick,
      get_quickinfo   RETURNING VALUE(rv_quickinfo) TYPE iconquick.

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

CLASS lcl_toolbar_button IMPLEMENTATION.
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

  METHOD set_text.
    mv_text = i_text.
  ENDMETHOD.

  METHOD get_text.
    rv_text = mv_text.
  ENDMETHOD.

  METHOD set_quickinfo.
    mv_quickinfo = i_quickinfo.
  ENDMETHOD.

  METHOD get_quickinfo.
    rv_quickinfo = mv_quickinfo.
  ENDMETHOD.

  METHOD reverse_checked.
    rv_reversed = COND #( WHEN checked = abap_true THEN abap_false ELSE abap_true ).
  ENDMETHOD.

  METHOD get_icon_by_checked.
    rv_icon = COND iconname( WHEN checked = abap_true THEN con_button_icon-checked ELSE con_button_icon-unchecked ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_toolbar_checkbutton DEFINITION CREATE PUBLIC INHERITING FROM lcl_toolbar_button.
  PUBLIC SECTION.
    METHODS:
      constructor    IMPORTING parent      TYPE REF TO cl_gui_toolbar
                               fcode       TYPE ui_func
                               text        TYPE text40
                               quickinfo   TYPE iconquick
                               is_disabled TYPE abap_bool OPTIONAL
                               is_checked  TYPE abap_bool.
ENDCLASS.

CLASS lcl_toolbar_checkbutton IMPLEMENTATION.
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

CLASS lcl_toolbar_dropdown_button DEFINITION CREATE PUBLIC INHERITING FROM lcl_toolbar_button.
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

CLASS lcl_toolbar_dropdown_button IMPLEMENTATION.
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

CLASS lcl_toolbar DEFINITION CREATE PUBLIC.
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
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_button,
      add_check_button    IMPORTING fcode            TYPE ui_func
                                    text             TYPE text40 OPTIONAL
                                    quickinfo        TYPE iconquick OPTIONAL
                                    is_disabled      TYPE abap_bool OPTIONAL
                                    is_checked       TYPE abap_bool
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_checkbutton,
      add_dropdown_button IMPORTING fcode            TYPE ui_func
                                    icon             TYPE c
                                    text             TYPE text40 OPTIONAL
                                    quickinfo        TYPE iconquick OPTIONAL
                                    is_disabled      TYPE abap_bool OPTIONAL
                                    is_checked       TYPE abap_bool
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_dropdown_button,
      add_separator       IMPORTING fcode            TYPE ui_func
                          RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_button,
      set_button_text     IMPORTING fcode     TYPE ui_func
                                    text      TYPE text40
                                    quickinfo TYPE iconquick OPTIONAL,
      set_button_attr     IMPORTING fcode      TYPE ui_func
                                    checked    TYPE abap_bool
                                    enabled    TYPE abap_bool DEFAULT abap_true
                                    menu_items TYPE lcl_toolbar_dropdown_button=>type_menu_items OPTIONAL.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF type_button,
        fcode  TYPE ui_func,
        active TYPE abap_bool,
        button TYPE REF TO lcl_toolbar_button,
      END OF type_button,
      type_buttons TYPE SORTED TABLE OF type_button WITH UNIQUE KEY fcode.

    METHODS:
      get_active_button    RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_button,
      get_button           IMPORTING fcode            TYPE ui_func
                           RETURNING VALUE(ro_button) TYPE REF TO lcl_toolbar_button,
      set_button_active    IMPORTING fcode  TYPE ui_func
                                     active TYPE abap_bool DEFAULT abap_true,
      on_function_selected FOR EVENT function_selected OF cl_gui_toolbar IMPORTING fcode sender,
      on_dropdown_clicked  FOR EVENT dropdown_clicked  OF cl_gui_toolbar IMPORTING fcode posx posy sender.

    DATA:
      mo_toolbar TYPE REF TO cl_gui_toolbar,
      mt_buttons TYPE type_buttons.
ENDCLASS.

CLASS lcl_toolbar IMPLEMENTATION.
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

  METHOD set_button_text.
    DATA(button) = get_button( fcode ).
    IF ( text IS NOT INITIAL ).
      button->set_text( text ).
    ENDIF.

    IF ( quickinfo IS NOT INITIAL ).
      button->set_quickinfo( quickinfo ).
    ENDIF.

    mo_toolbar->set_button_info(
      fcode     = fcode
      icon      = button->get_icon( )
      text      = button->get_text( )
      quickinfo = button->get_quickinfo( ) ).
  ENDMETHOD.

  METHOD set_button_attr.
    DATA:
      button          TYPE REF TO lcl_toolbar_button,
      check_button    TYPE REF TO lcl_toolbar_checkbutton,
      dropdown_button TYPE REF TO lcl_toolbar_dropdown_button.

    button = get_button( fcode ).
    IF ( button IS NOT INITIAL ).
      CASE button->get_button_type( ).
        WHEN cntb_btype_check.
          check_button ?= button.
          check_button->set_checked( checked ).
          check_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( check_button->get_checked( ) ) ).
          mo_toolbar->set_button_info(
            fcode     = fcode
            icon      = check_button->get_icon( )
            text      = check_button->get_text( )
            quickinfo = check_button->get_quickinfo( ) ).

          mo_toolbar->set_button_state(
            fcode   = fcode
            enabled = enabled
            checked = check_button->get_checked( ) ).

          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
        WHEN cntb_btype_dropdown.
          dropdown_button ?= button.

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

          LOOP AT dropdown_button->get_menu_items( ) TRANSPORTING NO FIELDS WHERE checked = abap_true.
            EXIT.
          ENDLOOP.
          IF ( sy-subrc = 0 ).
            dropdown_button->set_checked( abap_true ).
            dropdown_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( abap_true ) ).
          ELSE.
            dropdown_button->set_checked( abap_false ).
            dropdown_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( abap_false ) ).
          ENDIF.

          mo_toolbar->set_button_info(
            fcode     = dropdown_button->get_fcode( )
            icon      = dropdown_button->get_icon( )
            text      = dropdown_button->get_text( )
            quickinfo = dropdown_button->get_quickinfo( ) ).

          mo_toolbar->set_button_state(
            fcode   = fcode
            enabled = abap_true
            checked = dropdown_button->get_checked( ) ).
        WHEN OTHERS.
          " Standard button – forward directly the event
          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD add_check_button.
    ro_button = NEW lcl_toolbar_checkbutton(
      parent      = mo_toolbar
      fcode       = fcode
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    INSERT VALUE #( fcode = fcode button = ro_button ) INTO TABLE mt_buttons.
  ENDMETHOD.

  METHOD add_button.
    ro_button = NEW lcl_toolbar_button(
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
    ro_button = NEW lcl_toolbar_dropdown_button(
      parent      = mo_toolbar
      icon        = icon
      fcode       = fcode
      text        = text
      quickinfo   = quickinfo
      is_disabled = is_disabled
      is_checked  = is_checked ).

    INSERT VALUE #( fcode = fcode button = ro_button ) INTO TABLE mt_buttons.
  ENDMETHOD.

  METHOD add_separator.
    add_button(
      fcode     = fcode
      icon      = icon_dummy
      butn_type = cntb_btype_sep ).
  ENDMETHOD.

  METHOD on_function_selected.
    DATA:
      button          TYPE REF TO lcl_toolbar_button,
      check_button    TYPE REF TO lcl_toolbar_checkbutton,
      dropdown_button TYPE REF TO lcl_toolbar_dropdown_button,
      checked         TYPE abap_bool.

    button = get_button( fcode ).
    IF ( button IS NOT INITIAL ).
      CASE button->get_button_type( ).
        WHEN cntb_btype_check.
          check_button ?= button.
          check_button->set_checked( lcl_toolbar_button=>reverse_checked( check_button->get_checked( ) ) ).
          checked = check_button->get_checked( ).
          check_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( check_button->get_checked( ) ) ).
          sender->set_button_info(
            fcode = fcode
            icon  = check_button->get_icon( ) ).

          sender->set_button_state(
            fcode   = fcode
            enabled = abap_true
            checked = check_button->get_checked( ) ).

          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
        WHEN cntb_btype_dropdown.
          dropdown_button ?= button.
          dropdown_button->set_checked( lcl_toolbar_button=>reverse_checked( dropdown_button->get_checked( ) ) ).
          dropdown_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( dropdown_button->get_checked( ) ) ).
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
        WHEN OTHERS.
          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
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
              i_checked = lcl_toolbar_button=>reverse_checked( menu_item-checked ) ).

            checked = lcl_toolbar_button=>reverse_checked( menu_item-checked ).
          ENDIF.

          dropdown_button->build_menu( ).

          LOOP AT dropdown_button->get_menu_items( ) TRANSPORTING NO FIELDS WHERE checked = abap_true.
            EXIT.
          ENDLOOP.
          IF ( sy-subrc = 0 ).
            dropdown_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( abap_true ) ).
          ELSE.
            dropdown_button->set_icon( lcl_toolbar_button=>get_icon_by_checked( abap_false ) ).
          ENDIF.

          sender->set_button_info(
            fcode = dropdown_button->get_fcode( )
            icon  = dropdown_button->get_icon( ) ).

          sender->dispatch( cargo = 'mo_toolbar' eventid = cl_gui_toolbar=>m_id_dropdown_clicked is_shellevent = abap_false ).
          sender->track_context_menu(
            context_menu = dropdown_button->mo_menu
            posx         = dropdown_button->mv_pos_x
            posy         = dropdown_button->mv_pos_y ).

          RAISE EVENT function_selected EXPORTING fcode = fcode checked = checked.
        CATCH cx_sy_move_cast_error INTO DATA(error).
          message_log->add_exception( i_error = error i_method = 'LCL_TOOLBAR->ON_FUNCTION_SELECTED' ).
          RETURN.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD on_dropdown_clicked.
    DATA button TYPE REF TO lcl_toolbar_dropdown_button.
    TRY.
        button ?= get_button( fcode ).
        IF ( button IS BOUND ).
          set_button_active( fcode ).
          button->set_position( i_posx = posx i_posy = posy ).
        ELSE.
          button ?= get_active_button( ).
        ENDIF.

        IF ( button IS BOUND ).
          sender->track_context_menu(
            context_menu = button->mo_menu
            posx         = posx
            posy         = posy ).
        ENDIF.

      CATCH cx_sy_move_cast_error INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_TOOLBAR->ON_DROPDOWN_CLICKED' ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

INTERFACE lif_sql_select_values.
  DATA:
    mv_search_by_package TYPE abap_bool,
    mv_search_by_descr   TYPE abap_bool,
    mv_max_hits          TYPE sy-dbcnt,
    mv_package           TYPE devclass,
    mt_tabname_range     TYPE RANGE OF dd02v-tabname,
    mt_contflag_range    TYPE RANGE OF dd02v-contflag,
    mt_clidep_range      TYPE RANGE OF dd02v-clidep,
    mt_tabclass_range    TYPE RANGE OF dd02v-tabclass,
    mt_viewclass_range   TYPE RANGE OF dd02v-viewclass.
ENDINTERFACE.

CLASS lcl_ddic_model DEFINITION ABSTRACT.
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
      type_search_tabname_range TYPE RANGE OF dd02t-ddtext,
      type_bdcdata              TYPE STANDARD TABLE OF bdcdata,
      type_rfc_spagparams       TYPE STANDARD TABLE OF rfc_spagpa WITH EMPTY KEY,
      type_tabname_range        TYPE RANGE OF dd02l-tabname.

    CLASS-EVENTS found_tables EXPORTING VALUE(results) TYPE type_search_results VALUE(with_popup) TYPE abap_bool DEFAULT abap_true.

    CLASS-METHODS:
      check_tcode_exists    IMPORTING i_tcode TYPE sy-tcode RETURNING VALUE(r_exists) TYPE abap_bool,
      check_tcode_authority IMPORTING i_tcode TYPE sy-tcode RETURNING VALUE(r_ok) TYPE abap_bool,
      call_transaction      IMPORTING i_tcode       TYPE sy-tcode
                                      i_skip_screen TYPE sy-ftype DEFAULT space
                                      i_spagtapams  TYPE type_rfc_spagparams OPTIONAL
                                      i_bdcdata     TYPE type_bdcdata OPTIONAL,
      check_selection_input IMPORTING i_control        TYPE REF TO lif_sql_select_values
                            RETURNING VALUE(r_success) TYPE abap_bool,
      search_tables         IMPORTING i_input   TYPE csequence
                                      i_control TYPE REF TO lif_sql_select_values
                                      i_langu   TYPE sy-langu,
      select_by_tabname     IMPORTING i_tabname_range TYPE type_tabname_range
                                      i_langu         TYPE sy-langu.

  PRIVATE SECTION.
    CLASS-METHODS:
      build_search_range IMPORTING i_search         TYPE csequence
                         EXPORTING et_text_range    TYPE type_search_text_range
                                   et_tabname_range TYPE type_search_text_range.
ENDCLASS.

CLASS lcl_control DEFINITION ABSTRACT.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF type_table_key,
        tabname    TYPE lcl_ddic_table=>type_header-tabname,
        tabclass   TYPE lcl_ddic_table=>type_header-tabclass,
        ddlanguage TYPE lcl_ddic_table=>type_header-ddlanguage,
      END OF type_table_key,
      type_table_keys TYPE STANDARD TABLE OF type_table_key WITH DEFAULT KEY.

    CLASS-EVENTS:
      refresh_content EXPORTING VALUE(tabname) TYPE tabname VALUE(language) TYPE sy-langu,
      delete_content  EXPORTING VALUE(table_keys) TYPE type_table_keys OPTIONAL.

    CLASS-METHODS:
      update_content IMPORTING i_tabname TYPE tabname i_langu TYPE sy-langu,
      clear_content  IMPORTING i_table_keys TYPE type_table_keys OPTIONAL.
ENDCLASS.

CLASS lcl_control IMPLEMENTATION.
  METHOD update_content.
    RAISE EVENT refresh_content EXPORTING tabname = i_tabname language = i_langu.
  ENDMETHOD.

  METHOD clear_content.
    RAISE EVENT delete_content EXPORTING table_keys = i_table_keys.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_search_control DEFINITION INHERITING FROM lcl_control.
  PUBLIC SECTION.
    INTERFACES:
      lif_sql_select_values.

    CONSTANTS:
      BEGIN OF con_fcode,
        select_language       TYPE ui_func VALUE 'LANGUAGE',
        filter_defaults       TYPE ui_func VALUE 'DEFAULTS',
        button_category       TYPE ui_func VALUE 'TABLE_CATEGORY',
        tabclass_transp       TYPE ui_func VALUE 'TRANSP',
        tabclass_view         TYPE ui_func VALUE 'VIEW',
        tabclass_cluster      TYPE ui_func VALUE 'CLUSTER',
        tabclass_pool         TYPE ui_func VALUE 'POOL',
        tabclass_struct       TYPE ui_func VALUE 'INTTAB',
        tabclass_append       TYPE ui_func VALUE 'APPEND',
        button_delivery       TYPE ui_func VALUE 'TABLE_DELIVERY',
        delivery_appl         TYPE ui_func VALUE 'TA',
        delivery_cust         TYPE ui_func VALUE 'TC',
        delivery_contr        TYPE ui_func VALUE 'TE',
        delivery_syst         TYPE ui_func VALUE 'TW',
        button_viewclass      TYPE ui_func VALUE 'VIEW_CLASS',
        viewclass_database    TYPE ui_func VALUE 'VD',
        viewclass_projection  TYPE ui_func VALUE 'VP',
        viewclass_maintenance TYPE ui_func VALUE 'VC',
        viewclass_help        TYPE ui_func VALUE 'VH',
        button_customer       TYPE ui_func VALUE 'FILTER_BY_CUSTOMER_TABLE',
        button_client         TYPE ui_func VALUE 'FILTER_BY_CLIENT_SPECIFIC',
        button_search_package TYPE ui_func VALUE 'SEARCH_TABLES_BY_PACKAGE',
        button_search_desc    TYPE ui_func VALUE 'SEARCH_TABLE_BY_TEXT',
        button_max_hits       TYPE ui_func VALUE 'MAX_NO_OF_HITS',
      END OF con_fcode,

      BEGIN OF con_salv_function,
        add_to_var      TYPE salv_de_function VALUE 'ADD_TO_VARIANT',
        remove_from_var TYPE salv_de_function VALUE 'REMOVE_FROM_VARIANT',
        delete_item     TYPE salv_de_function VALUE 'DELETE_ITEM',
        se11            TYPE salv_de_function VALUE 'SE11',
        se16            TYPE salv_de_function VALUE 'SE16',
        se16n           TYPE salv_de_function VALUE 'SE16N',
        se16h           TYPE salv_de_function VALUE 'SE16H',
      END OF con_salv_function.

    EVENTS:
      table_selected EXPORTING VALUE(tabname)  TYPE lcl_ddic_base=>type_object_name
                               VALUE(tabclass) TYPE lcl_ddic_table=>type_header-tabclass
                               VALUE(language) TYPE lcl_ddic_base=>type_language,
      items_deleted  EXPORTING VALUE(selected_items) TYPE type_table_keys,
      all_items_deleted.

    METHODS:
      constructor      IMPORTING i_langu         TYPE sy-langu,
      create           IMPORTING i_parent        TYPE REF TO cl_gui_container,
      add_items_to_alv IMPORTING i_table_keys    TYPE type_table_keys,
      call_history_popup,
      get_history_lines RETURNING VALUE(rv_lines) TYPE i,
      get_result_lines  RETURNING VALUE(rv_lines) TYPE i.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF type_table_data,
        favorite   TYPE iconname,
        class      TYPE iconname,
        stat       TYPE iconname,
        tabname    TYPE lcl_ddic_table=>type_header-tabname,
        ddlanguage TYPE lcl_ddic_table=>type_header-ddlanguage,
        ddtext     TYPE lcl_ddic_table=>type_header-ddtext,
        tabclass   TYPE lcl_ddic_table=>type_header-tabclass,
        current    TYPE abap_bool,
      END OF type_table_data,
      BEGIN OF ty_history,
        opened_at TYPE sy-timlo,
        tabname   TYPE dd02l-tabname,
        tabclass  TYPE dd02l-tabclass,
        langu     TYPE sy-langu,
        ddtext    TYPE dd02t-ddtext,
      END OF ty_history,
      ty_history_tab TYPE STANDARD TABLE OF ty_history WITH EMPTY KEY.

    METHODS:
      on_search
        FOR EVENT submit OF cl_gui_input_field IMPORTING input sender,
      on_found_tables
        FOR EVENT found_tables OF lcl_ddic_model IMPORTING results with_popup,
      on_filter_selected
        FOR EVENT function_selected OF lcl_toolbar IMPORTING fcode checked sender,
      on_filter_fcode_added
        FOR EVENT function_added OF lcl_toolbar_button IMPORTING fcode checked sender,
      on_salv_double_click
        FOR EVENT double_click OF cl_salv_events_table IMPORTING row column sender,
      on_salv_toolbar_click
        FOR EVENT added_function OF cl_salv_events_table IMPORTING e_salv_function sender,
      on_select_setup_toolbar
        FOR EVENT function_selected OF cl_gui_toolbar IMPORTING fcode sender,
      on_history_double_click
        FOR EVENT double_click OF cl_salv_events_table IMPORTING row column sender,
      on_popup_close
        FOR EVENT close OF cl_gui_dialogbox_container IMPORTING sender,

      add_history_entry IMPORTING i_tabline TYPE type_table_data,

      set_filter_defaults,
      set_filter_values IMPORTING i_function TYPE csequence
                                  i_checked  TYPE abap_bool,
      set_package       IMPORTING i_package  TYPE devclass,
      set_max_hits      IMPORTING i_number   TYPE sy-dbcnt.

    DATA:
      mo_toolbar_filter TYPE REF TO lcl_toolbar,
      mo_salv_output    TYPE REF TO cl_salv_table,
      mt_salv_output    TYPE STANDARD TABLE OF type_table_data,
      mo_salv_history   TYPE REF TO cl_salv_table,
      mt_history        TYPE ty_history_tab,
      mv_language       TYPE sy-langu.
ENDCLASS.

CLASS lcl_show_table_control DEFINITION INHERITING FROM lcl_control.
  PUBLIC SECTION.
    EVENTS:
      domain_selected       EXPORTING VALUE(domname)  TYPE lcl_ddic_base=>type_object_name
                                      VALUE(language) TYPE lcl_ddic_base=>type_language,
      data_element_selected EXPORTING VALUE(rollname) TYPE lcl_ddic_base=>type_object_name
                                      VALUE(language) TYPE lcl_ddic_base=>type_language,
      tabname_selected      EXPORTING VALUE(tabname)  TYPE lcl_ddic_base=>type_object_name
                                      VALUE(language) TYPE lcl_ddic_base=>type_language.

    METHODS:
      create           IMPORTING i_parent TYPE REF TO cl_gui_container,
      is_content_empty RETURNING VALUE(rv_empty) TYPE abap_bool.

  PROTECTED SECTION.
    TYPES type_visible_caption_id TYPE STANDARD TABLE OF i WITH EMPTY KEY.

    METHODS:
      create_container             IMPORTING i_parent TYPE REF TO cl_gui_container,
      create_toolbar,
      create_tabstrip,
      get_tabstrip_captions        RETURNING VALUE(r_captions) TYPE sbptcaptns,
      clear_data,
      build_header                 IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 1,
      build_table_fields           IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 2,
      build_texttable              IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 3,
      build_checktables            IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 4,
      build_indices                IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 5,
      build_search_helps           IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 6,
      build_view_header            IMPORTING i_ddic_view  TYPE REF TO lcl_ddic_view
                                             i_caption_id TYPE i DEFAULT 7,
      build_view_fields            IMPORTING i_ddic_view  TYPE REF TO lcl_ddic_view
                                             i_caption_id TYPE i DEFAULT 8,
      build_view_base_tables       IMPORTING i_ddic_view  TYPE REF TO lcl_ddic_view
                                             i_caption_id TYPE i DEFAULT 9,
      build_view_joins             IMPORTING i_ddic_view  TYPE REF TO lcl_ddic_view
                                             i_caption_id TYPE i DEFAULT 10,
      build_view_conditions        IMPORTING i_ddic_view  TYPE REF TO lcl_ddic_view
                                             i_caption_id TYPE i DEFAULT 11,
      build_transport_infos        IMPORTING i_ddic_table TYPE REF TO lcl_ddic_table
                                             i_caption_id TYPE i DEFAULT 12,
      build_table_data             IMPORTING i_ddic_table         TYPE REF TO lcl_ddic_table
                                   RETURNING VALUE(r_visible_ids) TYPE type_visible_caption_id,
      build_view_data              IMPORTING i_ddic_view          TYPE REF TO lcl_ddic_view
                                   RETURNING VALUE(r_visible_ids) TYPE type_visible_caption_id,
      on_refresh_content           FOR EVENT refresh_content OF lcl_control
        IMPORTING tabname language,
      on_delete_content            FOR EVENT delete_content  OF lcl_control
        IMPORTING table_keys,
      on_fields_click              FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_checktable_click          FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_checktable_double_click   FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_checktable_fields_click   FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_index_double_click        FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_searchhelp_double_click   FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_searchhelp_fields_click   FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_view_tables_click         FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_view_joins_click         FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_transport_infos_click    FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column sender,
      on_raise_after_salv_function FOR EVENT after_salv_function OF cl_salv_events_table
        IMPORTING e_salv_function sender.

    DATA:
      mo_container              TYPE REF TO cl_gui_splitter_container,
      mv_tabname                TYPE tabname,
      mv_language               TYPE sy-langu,
      mo_tabstrip               TYPE REF TO cl_gui_container_bar_2,
      mo_salv_header            TYPE REF TO cl_salv_table,
      mo_salv_fields            TYPE REF TO cl_salv_table,
      mo_salv_texttable_h       TYPE REF TO cl_salv_table,
      mo_salv_checktables       TYPE REF TO cl_salv_table,
      mo_salv_checktable_keys   TYPE REF TO cl_salv_table,
      mo_salv_indices           TYPE REF TO cl_salv_table,
      mo_salv_index_fields      TYPE REF TO cl_salv_table,
      mo_salv_searchhelps       TYPE REF TO cl_salv_table,
      mo_salv_searchhelp_fields TYPE REF TO cl_salv_table,
      mo_salv_view_header       TYPE REF TO cl_salv_table,
      mo_salv_view_fields       TYPE REF TO cl_salv_table,
      mo_salv_view_base_tables  TYPE REF TO cl_salv_table,
      mo_salv_view_joins        TYPE REF TO cl_salv_table,
      mo_salv_view_conditions   TYPE REF TO cl_salv_table,
      mo_salv_transport_infos   TYPE REF TO cl_salv_table,
      mt_header                 TYPE lcl_alv_dynamic_tools=>type_output_simple_tab,
      mt_table_fields           TYPE lcl_ddic_table=>type_field_tab,
      mt_texttable_h            TYPE lcl_alv_dynamic_tools=>type_output_simple_tab,
      mt_checktables            TYPE lcl_ddic_table=>type_checktable_tab,
      mt_checktable_keys        TYPE lcl_ddic_table=>type_checktable_key_tab,
      mt_indices                TYPE lcl_ddic_table=>type_index_tab,
      mt_index_fields           TYPE lcl_ddic_table=>type_index_field_tab,
      mt_searchhelps            TYPE lcl_ddic_table=>type_searchhelp_tab,
      mt_searchhelp_fields      TYPE lcl_ddic_table=>type_searchhelp_field_tab,
      mt_view_header            TYPE lcl_alv_dynamic_tools=>type_output_simple_tab,
      mt_view_fields            TYPE lcl_ddic_view=>type_view_fields,
      mt_view_base_tables       TYPE lcl_ddic_view=>type_base_tables,
      mt_view_joins             TYPE lcl_ddic_view=>type_view_joins,
      mt_view_conditions        TYPE lcl_ddic_view=>type_view_conditions,
      mt_transport_infos        TYPE lcl_ddic_table=>type_transport_infos.
ENDCLASS.

CLASS lcl_show_table_control IMPLEMENTATION.
  METHOD create.
    create_container( i_parent ).
    mo_container->set_visible( abap_false ).

    create_toolbar( ).
    create_tabstrip( ).

    SET HANDLER on_refresh_content.
    SET HANDLER on_delete_content.
  ENDMETHOD.

  METHOD create_container.
    mo_container = NEW #(
      parent  = i_parent
      rows    = 2
      columns = 1 ).

    mo_container->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).
    DO 2 TIMES.
      mo_container->set_row_sash(
        id    = sy-index
        type  = cl_gui_splitter_container=>type_movable
        value = cl_gui_splitter_container=>false ).

      mo_container->set_row_sash(
        id    = sy-index
        type  = cl_gui_splitter_container=>type_sashvisible
        value = cl_gui_splitter_container=>false ).
    ENDDO.
  ENDMETHOD.

  METHOD create_toolbar.
    mo_container->set_row_height( id = 1 height = 0 ).
  ENDMETHOD.

  METHOD get_tabstrip_captions.
    " Table
    APPEND VALUE #( caption = 'Header & Attributes'(t01)   icon = icon_table_settings )        TO r_captions.
    APPEND VALUE #( caption = 'Table Fields'(t02)          icon = icon_icon_list )             TO r_captions.
    APPEND VALUE #( caption = 'Text Table'(t03)            icon = icon_wd_text_view )          TO r_captions.
    APPEND VALUE #( caption = 'Check Tables'(t04)          icon = icon_relationship )          TO r_captions.
    APPEND VALUE #( caption = 'Indices'(t05)               icon = icon_foreign_key )           TO r_captions.
    APPEND VALUE #( caption = 'Search Helps'(t06)          icon = icon_value_help )            TO r_captions.
    " View
    APPEND VALUE #( caption = 'Header & Attributes'(t01)   icon = icon_table_settings )        TO r_captions.
    APPEND VALUE #( caption = 'View Fields'(t07)           icon = icon_icon_list )             TO r_captions.
    APPEND VALUE #( caption = 'View Base Tables'(t08)      icon = icon_database_table )        TO r_captions.
    APPEND VALUE #( caption = 'View Joins'(t09)            icon = icon_workflow_join )         TO r_captions.
    APPEND VALUE #( caption = 'View Joins Conditions'(t10) icon = icon_select_with_condition ) TO r_captions.
    APPEND VALUE #( caption = 'Transport Requests'(t73)    icon = icon_select_with_condition ) TO r_captions.
  ENDMETHOD.

  METHOD create_tabstrip.
    DATA column_table TYPE REF TO cl_salv_column_table.

    mo_tabstrip = NEW cl_gui_container_bar_2(
      active_id = 1
      style     = cl_gui_container_bar_2=>c_style_outlook
      captions  = get_tabstrip_captions( )
      parent    = mo_container->get_container( row = 2 column = 1 ) ).

**********************************************************************

    DATA(container) = mo_tabstrip->get_container( id = 1 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_header
          CHANGING  t_table      = mt_header ).
      CATCH cx_salv_msg INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_header->get_display_settings( )->set_list_header( 'Header and Attributes'(t01) ).
    mo_salv_header->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_header->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_header->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_header->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'HEAD' ) ).

    lcl_alv_dynamic_tools=>set_output_simple_columns(
      i_columns_table = mo_salv_header->get_columns( )
      i_optimize      = abap_false ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_header ).

    SET HANDLER on_raise_after_salv_function FOR mo_salv_header->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 2 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_fields
          CHANGING  t_table      = mt_table_fields ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_fields->get_display_settings( )->set_list_header( 'Table Fields'(t02) ).
    mo_salv_fields->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_fields->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_fields->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_fields->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'FLDS' ) ).

    DATA(columns_table) = mo_salv_fields->get_columns( ).
    DATA(columns)       = columns_table->get( ).
    LOOP AT columns INTO DATA(column).
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'TABNAME' OR 'FIELDNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'ROLLNAME' OR 'DOMNAME'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_positive int = 0 inv = 0 ) ).
        WHEN 'CHECKTABLE' OR 'ENTITYTAB' OR 'PRECFIELD'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
      ENDCASE.
    ENDLOOP.

    mo_salv_fields->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_fields ).

    SET HANDLER on_fields_click              FOR mo_salv_fields->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_fields->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 3 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_texttable_h
          CHANGING  t_table      = mt_texttable_h ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_texttable_h->get_display_settings( )->set_list_header( 'Text Table'(t03) ).
    mo_salv_texttable_h->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_texttable_h->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_texttable_h->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_texttable_h->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'TXTT' ) ).

    lcl_alv_dynamic_tools=>set_output_simple_columns( i_columns_table = mo_salv_texttable_h->get_columns( ) i_optimize = abap_false ).
    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_texttable_h ).

    SET HANDLER on_raise_after_salv_function FOR mo_salv_texttable_h->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 4 ).
    DATA(splitter) = NEW cl_gui_splitter_container(
      parent                  = container
      rows                    = 2
      columns                 = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_height( id = 1 height = 70 ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 1 column = 1 )
          IMPORTING r_salv_table = mo_salv_checktables
          CHANGING  t_table      = mt_checktables ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_checktables->get_display_settings( )->set_list_header( 'Check Tables'(t04) ).
    mo_salv_checktables->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_checktables->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_checktables->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_checktables->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'CHK' ) ).

    columns_table = mo_salv_checktables->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'TABNAME' OR 'FIELDNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'CHECKTABLE'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
      ENDCASE.
    ENDLOOP.

    mo_salv_checktables->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_checktables ).

    SET HANDLER on_checktable_click          FOR mo_salv_checktables->get_event( ).
    SET HANDLER on_checktable_double_click   FOR mo_salv_checktables->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_checktables->get_event( ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 2 column = 1 )
          IMPORTING r_salv_table = mo_salv_checktable_keys
          CHANGING  t_table      = mt_checktable_keys ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_checktable_keys->get_display_settings( )->set_list_header( 'Check Table Keys'(t67) ).
    mo_salv_checktable_keys->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_checktable_keys->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_checktable_keys->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_checktable_keys->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'CHKF' ) ).

    columns_table = mo_salv_checktable_keys->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'TABNAME' OR 'FIELDNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'DOMNAME'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_positive int = 0 inv = 0 ) ).
      ENDCASE.
    ENDLOOP.

    mo_salv_checktable_keys->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_checktable_keys ).

    SET HANDLER on_checktable_fields_click FOR mo_salv_checktable_keys->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 5 ).
    splitter = NEW cl_gui_splitter_container(
      parent                  = container
      rows                    = 2
      columns                 = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_height( id = 1 height = 70 ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 1 column = 1 )
          IMPORTING r_salv_table = mo_salv_indices
          CHANGING  t_table      = mt_indices ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_indices->get_display_settings( )->set_list_header( 'Indices'(t05) ).
    mo_salv_indices->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_indices->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_indices->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_indices->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'INDX' ) ).

    columns_table = mo_salv_indices->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'SQLTAB' OR 'INDEXNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
      ENDCASE.
    ENDLOOP.

    mo_salv_indices->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_indices ).

    SET HANDLER on_index_double_click FOR mo_salv_indices->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_indices->get_event( ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 2 column = 1 )
          IMPORTING r_salv_table = mo_salv_index_fields
          CHANGING  t_table      = mt_index_fields ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_index_fields->get_display_settings( )->set_list_header( 'Index Fields'(t11) ).
    mo_salv_index_fields->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_index_fields->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_index_fields->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_index_fields->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'INDF' ) ).

    columns_table = mo_salv_index_fields->get_columns( ).
    columns = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'SQLTAB' OR 'INDEXNAME' OR 'FIELDNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
      ENDCASE.
    ENDLOOP.

    mo_salv_index_fields->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_index_fields ).

    SET HANDLER on_raise_after_salv_function FOR mo_salv_index_fields->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 6 ).
    splitter = NEW cl_gui_splitter_container(
      parent                  = container
      rows                    = 2
      columns                 = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_height( id = 1 height = 70 ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 1 column = 1 )
          IMPORTING r_salv_table = mo_salv_searchhelps
          CHANGING  t_table      = mt_searchhelps ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_searchhelps->get_display_settings( )->set_list_header( 'Search Helps'(t06) ).
    mo_salv_searchhelps->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_searchhelps->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_searchhelps->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_searchhelps->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'SHL' ) ).

    columns_table = mo_salv_searchhelps->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'TABNAME' OR 'FIELDNAME' OR 'SHLPNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
      ENDCASE.
    ENDLOOP.

    mo_salv_searchhelps->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_searchhelps ).

    SET HANDLER on_searchhelp_double_click FOR mo_salv_searchhelps->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_searchhelps->get_event( ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 2 column = 1 )
          IMPORTING r_salv_table = mo_salv_searchhelp_fields
          CHANGING  t_table      = mt_searchhelp_fields ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_searchhelp_fields->get_display_settings( )->set_list_header( 'Search Helps Fields'(t12) ).
    mo_salv_searchhelp_fields->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_searchhelp_fields->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_searchhelp_fields->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_searchhelp_fields->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'SHLF' ) ).

    columns_table = mo_salv_searchhelp_fields->get_columns( ).
    columns = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'TABNAME' OR 'FIELDNAME' OR 'SHLPNAME' OR 'SHLPFIELD'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'ROLLNAME' OR 'DOMNAME'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_positive int = 0 inv = 0 ) ).
        WHEN 'FLPOSITION'.
          column_table->set_short_text( 'Pos.' ).
          column_table->set_medium_text( 'Position' ).
          column_table->set_long_text( 'Position' ).
      ENDCASE.
    ENDLOOP.

    mo_salv_searchhelp_fields->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_searchhelp_fields ).

    SET HANDLER on_searchhelp_fields_click FOR mo_salv_searchhelp_fields->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_searchhelp_fields->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 7 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_view_header
          CHANGING  t_table      = mt_view_header ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_view_header->get_display_settings( )->set_list_header( 'Header and Attributes'(t01) ).
    mo_salv_view_header->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_view_header->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_view_header->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_view_header->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'HEAD' ) ).

    lcl_alv_dynamic_tools=>set_output_simple_columns(
      i_columns_table = mo_salv_view_header->get_columns( )
      i_optimize      = abap_false ).

    lcl_alv_dynamic_tools=>set_salv_defaults(  mo_salv_view_header ).

    SET HANDLER on_raise_after_salv_function FOR mo_salv_view_header->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 8 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_view_fields
          CHANGING  t_table      = mt_view_fields ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_view_fields->get_display_settings( )->set_list_header( 'View Fields'(t07) ).
    mo_salv_view_fields->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_view_fields->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_view_fields->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_view_fields->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'VFLD' ) ).

    columns_table = mo_salv_view_fields->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'VIEWNAME' OR 'VIEWFIELD'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'TABNAME'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
        WHEN 'ROLLNAME' OR 'DOMNAME'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_positive int = 0 inv = 0 ) ).
        WHEN 'CHECKTABLE' OR 'ENTITYTAB'.
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
      ENDCASE.
    ENDLOOP.

    mo_salv_view_fields->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_view_fields ).

    SET HANDLER on_fields_click              FOR mo_salv_view_fields->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_view_fields->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 9 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_view_base_tables
          CHANGING  t_table      = mt_view_base_tables ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_view_base_tables->get_display_settings( )->set_list_header( 'View Base Tables'(t08) ).
    mo_salv_view_base_tables->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_view_base_tables->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_view_base_tables->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_view_base_tables->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'VTBL' ) ).

    columns_table = mo_salv_view_base_tables->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'VIEWNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'TABNAME' OR 'FORTABNAME'.
          column_table->set_key( if_salv_c_bool_sap=>false ).
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
        WHEN OTHERS.
          column_table->set_key( if_salv_c_bool_sap=>false ).
      ENDCASE.
    ENDLOOP.

    mo_salv_view_base_tables->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_view_base_tables ).

    SET HANDLER on_view_tables_click FOR mo_salv_view_base_tables->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_view_base_tables->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 10 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_view_joins
          CHANGING  t_table      = mt_view_joins ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_view_joins->get_display_settings( )->set_list_header( 'View Joins'(t09) ).
    mo_salv_view_joins->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_view_joins->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_view_joins->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_view_joins->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'VJNS' ) ).

    columns_table = mo_salv_view_joins->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      CASE column-columnname.
        WHEN 'VIEWNAME'.
          column_table->set_key( if_salv_c_bool_sap=>true ).
        WHEN 'LTAB' OR 'RTAB' OR 'FRKTAB'.
          column_table->set_key( if_salv_c_bool_sap=>false ).
          column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
          column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
      ENDCASE.
    ENDLOOP.

    mo_salv_view_joins->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_view_joins ).

    SET HANDLER on_view_joins_click FOR mo_salv_view_joins->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_view_joins->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 11 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_view_conditions
          CHANGING  t_table      = mt_view_conditions ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_view_conditions->get_display_settings( )->set_list_header( 'View Conditions'(t10) ).
    mo_salv_view_conditions->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_view_conditions->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_view_conditions->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_view_conditions->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'VCND' ) ).

    columns_table = mo_salv_view_conditions->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      IF ( column-columnname = 'TABNAME' OR column-columnname = 'FIELDNAME' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).
      ENDIF.

      IF ( column-columnname = 'CHECKTABLE' ).
        column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
        column_table->set_color( VALUE lvc_s_colo( col = col_total int = 0 inv = 0 ) ).
      ENDIF.
    ENDLOOP.

    mo_salv_view_conditions->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_view_conditions ).

    SET HANDLER on_raise_after_salv_function FOR mo_salv_view_conditions->get_event( ).

**********************************************************************

    container = mo_tabstrip->get_container( id = 12 ).
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_transport_infos
          CHANGING  t_table      = mt_transport_infos ).
      CATCH cx_salv_msg INTO error.
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    mo_salv_transport_infos->get_display_settings( )->set_list_header( 'Transport Requests'(t73) ).
    mo_salv_transport_infos->get_columns( )->set_key_fixation( if_salv_c_bool_sap=>true ).
    mo_salv_transport_infos->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    mo_salv_transport_infos->get_layout( )->set_default( if_salv_c_bool_sap=>true ).
    mo_salv_transport_infos->get_layout( )->set_key( VALUE #( report = sy-repid logical_group = 'TR' ) ).

    columns_table = mo_salv_transport_infos->get_columns( ).
    columns       = columns_table->get( ).
    LOOP AT columns INTO column.
      column_table ?= column-r_column.

      IF ( column-columnname = 'OBJ_NAME' OR column-columnname = 'OBJECT' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).
      ENDIF.

      IF ( column-columnname = 'TRKORR' ).
        column_table->set_key( if_salv_c_bool_sap=>true ).
        column_table->set_cell_type( if_salv_c_cell_type=>hotspot ).
      ENDIF.
    ENDLOOP.

    mo_salv_transport_infos->get_columns( )->set_optimize( ).

    lcl_alv_dynamic_tools=>set_salv_defaults( mo_salv_transport_infos ).

    SET HANDLER on_transport_infos_click     FOR mo_salv_transport_infos->get_event( ).
    SET HANDLER on_raise_after_salv_function FOR mo_salv_transport_infos->get_event( ).
  ENDMETHOD.

  METHOD build_header.
    CLEAR mt_header.

    DATA(table_header) = i_ddic_table->get_header( ).
    IF ( table_header-ddtext IS INITIAL ).
      table_header-ddtext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
    ENDIF.

    mt_header = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = mv_language
      i_structure = table_header ).

    READ TABLE mt_header ASSIGNING FIELD-SYMBOL(<header>) WITH KEY fieldname = 'TABNAME'.
    IF ( sy-subrc = 0 ).
      READ TABLE mt_header INTO DATA(header) WITH KEY fieldname = 'DDTEXT'.
      IF ( sy-subrc = 0 ).
        <header>-descr = header-value.
        DELETE mt_header INDEX sy-tabix.
      ENDIF.
    ENDIF.

    READ TABLE mt_header ASSIGNING <header> WITH KEY fieldname = 'DDLANGUAGE'.
    IF ( sy-subrc = 0 ).
      DATA(language_text)  = lcl_ddic_base=>read_language_text(
        i_language = CONV #( <header>-value )
        i_spras    = mv_language ).

      <header>-descr = language_text-sptxt.
    ENDIF.

    DATA(table_setting) = i_ddic_table->get_settings( ).
    DATA(settings) = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = mv_language
      i_structure = table_setting ).

    READ TABLE settings ASSIGNING FIELD-SYMBOL(<setting>) WITH KEY fieldname = 'TABART'.
    IF ( sy-subrc = 0 ).
      <setting>-descr = i_ddic_table->get_data_class_text( )-darttext.
    ENDIF.

    READ TABLE mt_header ASSIGNING <header> WITH KEY fieldname = 'MASTERLANG'.
    IF ( sy-subrc = 0 ).
      language_text = lcl_ddic_base=>read_language_text(
        i_language = CONV #( <header>-value )
        i_spras    = mv_language ).

      <header>-descr = language_text-sptxt.
    ENDIF.

    LOOP AT settings INTO DATA(setting).
      READ TABLE mt_header TRANSPORTING NO FIELDS WITH KEY fieldtext = setting-fieldtext.
      IF ( sy-subrc <> 0 ).
        APPEND setting TO mt_header.
      ENDIF.
    ENDLOOP.

    DATA(table_devclass) = i_ddic_table->get_devclass( ).
    IF ( table_devclass IS NOT INITIAL AND table_devclass-ctext IS INITIAL ).
      table_devclass-ctext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
    ENDIF.

    APPEND VALUE #(
      fieldname = 'DEVCLASS'
      fieldtext = 'Package'
      value     = table_devclass-devclass
      descr     = table_devclass-ctext ) TO mt_header.
  ENDMETHOD.

  METHOD build_table_fields.
    mt_table_fields = i_ddic_table->get_fields( ).
    LOOP AT mt_table_fields ASSIGNING FIELD-SYMBOL(<field>).
      ASSIGN COMPONENT 'DDTEXT' OF STRUCTURE <field> TO FIELD-SYMBOL(<value>).
      IF ( sy-subrc = 0 AND <value> IS INITIAL ).
        <value> = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD build_texttable.
    CLEAR mt_texttable_h.

    DATA(lo_texttable) = i_ddic_table->get_texttable_ref( ).
    IF ( lo_texttable IS BOUND ).
      DATA(table_header) = lo_texttable->get_header( ).
      IF ( table_header-ddtext IS INITIAL ).
        table_header-ddtext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
      ENDIF.

      mt_texttable_h = lcl_alv_dynamic_tools=>get_structure_fields_for(
        i_language  = mv_language
        i_structure = table_header ).

      READ TABLE mt_texttable_h ASSIGNING FIELD-SYMBOL(<header>) WITH KEY fieldname = 'TABNAME'.
      IF ( sy-subrc = 0 ).
        READ TABLE mt_texttable_h INTO DATA(header) WITH KEY fieldname = 'DDTEXT'.
        IF ( sy-subrc = 0 ).
          <header>-descr = header-value.
          DELETE mt_texttable_h INDEX sy-tabix.
        ENDIF.
      ENDIF.

      READ TABLE mt_texttable_h ASSIGNING <header> WITH KEY fieldname = 'DDLANGUAGE'.
      IF ( sy-subrc = 0 ).
        DATA(language_text)  = i_ddic_table->read_language_text(
          i_language = CONV #( <header>-value ) i_spras = mv_language ).
        <header>-descr = language_text-sptxt.
      ENDIF.

      READ TABLE mt_texttable_h ASSIGNING <header> WITH KEY fieldname = 'TABART'.
      IF ( sy-subrc = 0 ).
        <header>-descr = i_ddic_table->get_data_class_text( )-darttext.
      ENDIF.

      DATA(table_devclass) = lo_texttable->get_devclass( ).
      IF ( table_devclass IS NOT INITIAL AND table_devclass-ctext IS INITIAL ).
        table_devclass-ctext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
      ENDIF.

      APPEND VALUE #(
        fieldname = 'DEVCLASS'
        fieldtext = 'Package'
        value     = table_devclass-devclass
        descr     = table_devclass-ctext ) TO mt_texttable_h.
    ENDIF.
  ENDMETHOD.

  METHOD build_checktables.
    mt_checktables = i_ddic_table->get_checktables( ).
    IF ( mt_checktables IS NOT INITIAL ).
      LOOP AT mt_checktables ASSIGNING FIELD-SYMBOL(<checktable>).
        IF ( <checktable>-ddtext IS INITIAL ).
          <checktable>-ddtext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD build_indices.
    mt_indices = i_ddic_table->get_indexes( ).
    IF ( mt_indices IS NOT INITIAL ).
      LOOP AT mt_indices ASSIGNING FIELD-SYMBOL(<index>).
        IF ( <index>-ddtext IS INITIAL ).
          <index>-ddtext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD build_search_helps.
    mt_searchhelps = i_ddic_table->get_search_helps( ).
  ENDMETHOD.

  METHOD build_view_header.
    CLEAR mt_view_header.

    DATA(view_header) = i_ddic_view->get_view_header( ).
    IF ( view_header-ddtext IS INITIAL ).
      view_header-ddtext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
    ENDIF.

    mt_view_header = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = mv_language
      i_structure = view_header ).

    READ TABLE mt_view_header ASSIGNING FIELD-SYMBOL(<header>) WITH KEY fieldname = 'TABNAME'.
    IF ( sy-subrc = 0 ).
      READ TABLE mt_view_header INTO DATA(header) WITH KEY fieldname = 'DDTEXT'.
      IF ( sy-subrc = 0 ).
        <header>-descr = header-value.
        DELETE mt_view_header INDEX sy-tabix.
      ENDIF.
    ENDIF.

    READ TABLE mt_view_header ASSIGNING <header> WITH KEY fieldname = 'DDLANGUAGE'.
    IF ( sy-subrc = 0 ).
      DATA(language_text)  = lcl_ddic_base=>read_language_text(
        i_language = CONV #( <header>-value )
        i_spras    = mv_language ).

      <header>-descr = language_text-sptxt.
    ENDIF.

**********************************************************************

    DATA(view_setting) = i_ddic_view->get_settings( ).
    DATA(settings) = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = mv_language
      i_structure = view_setting ).

    READ TABLE settings ASSIGNING FIELD-SYMBOL(<setting>) WITH KEY fieldname = 'TABART'.
    IF ( sy-subrc = 0 ).
      <setting>-descr = i_ddic_view->get_data_class_text( )-darttext.
    ENDIF.

    READ TABLE mt_view_header ASSIGNING <header> WITH KEY fieldname = 'MASTERLANG'.
    IF ( sy-subrc = 0 ).
      language_text = lcl_ddic_base=>read_language_text(
        i_language = CONV #( <header>-value )
        i_spras    = mv_language ).

      <header>-descr = language_text-sptxt.
    ENDIF.

    LOOP AT settings INTO DATA(setting).
      READ TABLE mt_view_header TRANSPORTING NO FIELDS WITH KEY fieldtext = setting-fieldtext.
      IF ( sy-subrc <> 0 ).
        APPEND setting TO mt_view_header.
      ENDIF.
    ENDLOOP.

**********************************************************************

    DATA(view_devclass)  = i_ddic_view->get_devclass( ).
    IF ( view_devclass-ctext IS INITIAL ).
      view_devclass-ctext = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
    ENDIF.

    APPEND VALUE #(
      fieldname = 'DEVCLASS'
      fieldtext = 'Package'
      value     = view_devclass-devclass
      descr     = view_devclass-ctext ) TO mt_view_header.
  ENDMETHOD.

  METHOD build_view_fields.
    mt_view_fields = i_ddic_view->get_view_fields( ).
    IF ( mt_view_fields IS NOT INITIAL ).
      LOOP AT mt_view_fields ASSIGNING FIELD-SYMBOL(<field>).
        ASSIGN COMPONENT 'DDTEXT' OF STRUCTURE <field> TO FIELD-SYMBOL(<value>).
        IF ( sy-subrc = 0 AND <value> IS INITIAL ).
          <value> = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD build_view_base_tables.
    mt_view_base_tables = i_ddic_view->get_base_tables( ).
  ENDMETHOD.

  METHOD build_view_joins.
    mt_view_joins = i_ddic_view->get_view_joins( ).
  ENDMETHOD.

  METHOD build_view_conditions.
    mt_view_conditions = i_ddic_view->get_conditions( ).
  ENDMETHOD.

  METHOD build_transport_infos.
    mt_transport_infos = i_ddic_table->get_transport_infos( ).
  ENDMETHOD.

  METHOD build_table_data.
    DATA(header_text) = ||.

    build_header( i_ddic_table ).
    IF ( mt_header IS NOT INITIAL ).
      APPEND 1 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 1 visible = abap_true ).
    ENDIF.

    mo_salv_header->refresh( ).

**********************************************************************

    build_table_fields( i_ddic_table ).
    IF ( mt_table_fields IS NOT INITIAL ).
      DATA(lt_fields) = mt_table_fields.
      DELETE lt_fields WHERE fieldname CP '.INCLU*'.

      header_text = 'Table Fields'(t02) && | ({ lines( lt_fields ) })|.
      mo_salv_fields->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 2 caption = CONV #( header_text ) ).

      APPEND 2 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 2 visible = abap_true ).
    ENDIF.

    mo_salv_fields->get_columns( )->set_optimize( ).
    mo_salv_fields->refresh( ).

**********************************************************************

    build_texttable( i_ddic_table ).
    IF ( mt_texttable_h IS NOT INITIAL ).
      mo_tabstrip->set_cell_caption( id = 3 caption = COND #( WHEN mt_texttable_h IS NOT INITIAL THEN 'Text Table' ELSE 'Text Table not found' ) ).

      APPEND 3 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 3 visible = abap_true ).
    ENDIF.

    mo_salv_texttable_h->refresh( ).

**********************************************************************

    build_checktables( i_ddic_table = i_ddic_table ).
    IF ( mt_checktables IS NOT INITIAL ).
      header_text = 'Check Tables'(t04) && | ({ lines( mt_checktables ) })|.
      mo_salv_checktables->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 4 caption = CONV #( header_text ) ).

      APPEND 4 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 4 visible = abap_true ).
    ENDIF.

    mo_salv_checktables->get_columns( )->set_optimize( ).
    mo_salv_checktables->refresh( ).

**********************************************************************

    build_indices( i_ddic_table = i_ddic_table ).
    IF ( mt_indices IS NOT INITIAL ).
      header_text = 'Indices'(t05) && | ({ lines( mt_indices ) })|.
      mo_salv_indices->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 5 caption = CONV #( header_text ) ).

      APPEND 5 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 5 visible = abap_true ).
    ENDIF.

    mo_salv_indices->get_columns( )->set_optimize( ).
    mo_salv_indices->refresh( ).

    mo_salv_index_fields->get_columns( )->set_optimize( ).
    mo_salv_index_fields->refresh( ).

**********************************************************************

    build_search_helps( i_ddic_table = i_ddic_table ).
    IF ( mt_searchhelps IS NOT INITIAL ).
      header_text = 'Search Helps'(t06) && | ({ lines( mt_searchhelps ) })|.
      mo_salv_searchhelps->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 6 caption = CONV #( header_text ) ).

      APPEND 6 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 6 visible = abap_true ).
    ENDIF.

    mo_salv_searchhelps->get_columns( )->set_optimize( ).
    mo_salv_searchhelps->refresh( ).

    mo_salv_searchhelp_fields->get_columns( )->set_optimize( ).
    mo_salv_searchhelp_fields->refresh( ).

**********************************************************************

    build_transport_infos( i_ddic_table = i_ddic_table ).
    IF ( mt_transport_infos IS NOT INITIAL ).
      header_text = 'Transport Requests'(t73) && | ({ lines( mt_transport_infos ) })|.
      mo_salv_transport_infos->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 12 caption = CONV #( header_text ) ).

      APPEND 12 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 12 visible = abap_true ).
    ENDIF.

    mo_salv_transport_infos->get_columns( )->set_optimize( ).
    mo_salv_transport_infos->refresh( ).
  ENDMETHOD.

  METHOD build_view_data.
    DATA(header_text) = ||.

    build_view_header( i_ddic_view ).
    IF ( mt_view_header IS NOT INITIAL ).
      APPEND 7 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 7 visible = abap_true ).
    ENDIF.

    mo_salv_view_header->refresh( ).

**********************************************************************

    build_view_fields( i_ddic_view ).
    IF ( mt_view_fields IS NOT INITIAL ).
      DATA(lt_fields) = mt_view_fields.
      DELETE lt_fields WHERE fieldname CP '.INCLU*'.

      header_text = 'View Fields'(t07) && | ({ lines( mt_view_fields ) })|.
      mo_salv_view_fields->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 8 caption = CONV #( header_text ) ).

      APPEND 8 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 8 visible = abap_true ).
    ENDIF.

    mo_salv_view_fields->get_columns( )->set_optimize( ).
    mo_salv_view_fields->refresh( ).

**********************************************************************

    build_view_base_tables( i_ddic_view ).
    IF ( mt_view_base_tables IS NOT INITIAL ).
      header_text = 'View Base Tables'(t08) && | ({ lines( mt_view_base_tables ) })|.
      mo_salv_view_base_tables->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 9 caption = CONV #( header_text ) ).

      APPEND 9 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 9 visible = abap_true ).
    ENDIF.

    mo_salv_view_base_tables->get_columns( )->set_optimize( ).
    mo_salv_view_base_tables->refresh( ).

**********************************************************************

    build_view_joins( i_ddic_view ).
    IF ( mt_view_joins IS NOT INITIAL ).
      header_text = 'View Joins'(t09) && | ({ lines( mt_view_joins ) })|.
      mo_salv_view_joins->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 10 caption = CONV #( header_text ) ).

      APPEND 10 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 10 visible = abap_true ).
    ENDIF.

    mo_salv_view_joins->get_columns( )->set_optimize( ).
    mo_salv_view_joins->refresh( ).

**********************************************************************

    build_view_conditions( i_ddic_view ).
    IF ( mt_view_conditions IS NOT INITIAL ).
      header_text = 'View Join Conditions'(t10) && | ({ lines( mt_view_conditions ) })|.
      mo_salv_view_conditions->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 11 caption = CONV #( header_text ) ).

      APPEND 11 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 11 visible = abap_true ).
    ENDIF.

    mo_salv_view_conditions->get_columns( )->set_optimize( ).
    mo_salv_view_conditions->refresh( ).

**********************************************************************

    build_transport_infos( i_ddic_table = i_ddic_view ).
    IF ( mt_transport_infos IS NOT INITIAL ).
      header_text = 'Transport Requests'(t73) && | ({ lines( mt_transport_infos ) })|.
      mo_salv_transport_infos->get_display_settings( )->set_list_header( CONV #( header_text ) ).
      mo_tabstrip->set_cell_caption( id = 12 caption = CONV #( header_text ) ).

      APPEND 12 TO r_visible_ids.
      mo_tabstrip->set_cell_visible( id = 12 visible = abap_true ).
    ENDIF.

    mo_salv_transport_infos->get_columns( )->set_optimize( ).
    mo_salv_transport_infos->refresh( ).
  ENDMETHOD.

  METHOD clear_data.
    mo_container->set_visible( abap_false ).

    CLEAR:
      mv_tabname,     mv_language,
      mt_header,      mt_table_fields, mt_texttable_h,      mt_checktables,
      mt_indices,     mt_index_fields, mt_searchhelps,      mt_searchhelp_fields,
      mt_view_header, mt_view_fields,  mt_view_base_tables, mt_view_joins, mt_view_conditions.

    mo_salv_header->refresh( ).
    mo_salv_fields->refresh( ).
    mo_salv_texttable_h->refresh( ).
    mo_salv_checktables->refresh( ).
    mo_salv_indices->refresh( ).
    mo_salv_index_fields->refresh( ).
    mo_salv_searchhelps->refresh( ).
    mo_salv_searchhelp_fields->refresh( ).
    mo_salv_view_header->refresh( ).
    mo_salv_view_fields->refresh( ).
    mo_salv_view_base_tables->refresh( ).
    mo_salv_view_joins->refresh( ).
    mo_salv_view_conditions->refresh( ).

    DO lines( get_tabstrip_captions( ) ) TIMES.
      mo_tabstrip->set_cell_visible( id = sy-index visible = abap_false ).
    ENDDO.
  ENDMETHOD.

  METHOD is_content_empty.
    rv_empty = COND #( WHEN lines( mt_header ) > 0 THEN abap_false ELSE abap_true ).
  ENDMETHOD.

  METHOD on_refresh_content.
    DATA:
      ddic_table  TYPE REF TO lcl_ddic_table,
      visible_ids TYPE type_visible_caption_id.

    mo_tabstrip->get_active( IMPORTING id = DATA(active_id) ).

    clear_data( ).

    IF ( tabname IS INITIAL ).
      message_log->add_message_text(
        i_text   = 'Technical ERROR: Tabname is initial'(m02)
        i_method = 'LCL_SHOW_TABLE_CONTROL->ON_REFRESH_CONTENT' ).

      RETURN.
    ENDIF.

    IF ( language IS INITIAL ).
      message_log->add_message_text(
        i_text   = 'Technical ERROR: Language is initial'(m03)
        i_method = 'LCL_SHOW_TABLE_CONTROL->ON_REFRESH_CONTENT' ).

      RETURN.
    ENDIF.

    mv_tabname  = tabname.
    mv_language = language.

**********************************************************************

    TRY.
        ddic_table = lcl_ddic_table=>create_instance(
          i_tabname       = mv_tabname
          i_langu         = mv_language
          i_load_metadata = abap_true ).
      CATCH cx_dynamic_check INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_REFRESH_CONTENT' ).
        RETURN.
    ENDTRY.

    TRY.
        CASE ddic_table->get_tabclass( ).
          WHEN ddic_table->enum_tabclass-view.
            visible_ids = build_view_data( CAST #( ddic_table ) ).
          WHEN OTHERS.
            visible_ids = build_table_data( CAST #( ddic_table ) ).
        ENDCASE.
      CATCH cx_sy_move_cast_error INTO DATA(cast_error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_REFRESH_CONTENT' ).
        RETURN.
    ENDTRY.

    IF ( line_exists( visible_ids[ table_line = active_id ] ) ).
      mo_tabstrip->set_active( id = active_id ).
    ELSE.
      READ TABLE visible_ids TRANSPORTING NO FIELDS INDEX 1.
      IF ( sy-subrc = 0 ).
        mo_tabstrip->set_active( id = visible_ids[ sy-tabix ] ).
      ENDIF.
    ENDIF.

    mo_container->set_visible( abap_true ).
  ENDMETHOD.

  METHOD on_delete_content.
    READ TABLE table_keys WITH KEY tabname = mv_tabname ddlanguage = mv_language TRANSPORTING NO FIELDS.
    IF ( sy-subrc = 0 OR table_keys IS INITIAL ).
      clear_data( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_fields_click.
    FIELD-SYMBOLS:
      <row_line> TYPE data,
      <value>    TYPE data.

    TRY.
        IF ( mt_table_fields IS NOT INITIAL ).
          ASSIGN mt_table_fields[ row ] TO <row_line>.
        ELSEIF ( mt_view_fields IS NOT INITIAL ).
          ASSIGN mt_view_fields[ row ] TO <row_line>.
        ELSE.
          RETURN.
        ENDIF.

        CASE column.
          WHEN 'ROLLNAME'.
            ASSIGN COMPONENT column OF STRUCTURE <row_line> TO <value>.
            IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
              RAISE EVENT data_element_selected
                EXPORTING rollname = CONV #( <value> ) language = mv_language.
            ENDIF.
          WHEN 'DOMNAME'.
            ASSIGN COMPONENT column OF STRUCTURE <row_line> TO <value>.
            IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
              RAISE EVENT domain_selected
                EXPORTING domname = CONV #( <value> ) language = mv_language.
            ENDIF.
          WHEN 'CHECKTABLE'.
            ASSIGN COMPONENT column OF STRUCTURE <row_line> TO <value>.
            IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = CONV #( <value> ) language = mv_language.
            ENDIF.
          WHEN 'ENTITYTAB' OR 'TABNAME'.
            ASSIGN COMPONENT column OF STRUCTURE <row_line> TO <value>.
            IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = CONV #( <value> ) language = mv_language.
            ENDIF.
          WHEN 'PRECFIELD'.
            ASSIGN COMPONENT column OF STRUCTURE <row_line> TO <value>.
            IF ( sy-subrc = 0 AND <value> IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = CONV #( <value> ) language = mv_language.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_FIELDS_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_checktable_click.
    TRY.
        DATA(tabline) = mt_checktables[ row ].
        CASE column.
          WHEN 'CHECKTABLE'.
            IF ( tabline-checktable IS NOT INITIAL ).
              RAISE EVENT tabname_selected EXPORTING tabname = tabline-checktable language = mv_language.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_CHECKTABLE_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_checktable_double_click.
    CLEAR mt_checktable_keys.

    DATA(tabline) = mt_checktables[ row ].
    IF ( tabline-fieldname IS NOT INITIAL ).
      TRY.
          DATA(ddic_table) = lcl_ddic_table=>create_instance(
            i_tabname = tabline-tabname
            i_langu   = mv_language
          ).

          mt_checktable_keys = ddic_table->get_checktable_keys( tabline-checktable ).
        CATCH cx_dynamic_check INTO DATA(error).
          message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_CHECKTABLE_DOUBLE_CLICK' ).
      ENDTRY.
    ENDIF.

    mo_salv_checktable_keys->get_columns( )->set_optimize( ).
    mo_salv_checktable_keys->refresh( ).
  ENDMETHOD.

  METHOD on_checktable_fields_click.
    TRY.
        DATA(tableline) = mt_checktable_keys[ row ].
        CASE column.
          WHEN 'DOMNAME'.
            IF ( tableline-domname IS NOT INITIAL ).
              RAISE EVENT domain_selected
                EXPORTING domname = tableline-domname language = mv_language.
            ENDIF.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_CHECKTABLE_FIELDS_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_index_double_click.
    CLEAR mt_index_fields.

    DATA(tabline) = mt_indices[ row ].
    IF ( tabline-indexname IS NOT INITIAL ).
      TRY.
          DATA(ddic_table) = lcl_ddic_table=>create_instance(
            i_tabname = tabline-sqltab
            i_langu   = mv_language
          ).

          mt_index_fields = ddic_table->get_index_fields( tabline-indexname ).
        CATCH cx_dynamic_check INTO DATA(error).
          message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_INDEX_DOUBLE_CLICK' ).
      ENDTRY.
    ENDIF.

    mo_salv_index_fields->get_columns( )->set_optimize( ).
    mo_salv_index_fields->refresh( ).
  ENDMETHOD.

  METHOD on_searchhelp_double_click.
    CLEAR mt_searchhelp_fields.

    DATA(tabline) = mt_searchhelps[ row ].
    IF ( tabline-shlpname IS NOT INITIAL ).
      TRY.
          DATA(ddic_table) = lcl_ddic_table=>create_instance(
            i_tabname = tabline-tabname
            i_langu   = mv_language
          ).

          mt_searchhelp_fields = ddic_table->get_search_help_fields( tabline-shlpname ).
        CATCH cx_dynamic_check INTO DATA(error).
          message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_SEARCHHELP_DOUBLE_CLICK' ).
      ENDTRY.
    ENDIF.

    mo_salv_searchhelp_fields->get_columns( )->set_optimize( ).
    mo_salv_searchhelp_fields->refresh( ).
  ENDMETHOD.

  METHOD on_searchhelp_fields_click.
    TRY.
        DATA(tableline) = mt_searchhelp_fields[ row ].
        CASE column.
          WHEN 'ROLLNAME'.
            IF ( tableline-rollname IS NOT INITIAL ).
              RAISE EVENT data_element_selected
                EXPORTING rollname = tableline-rollname language = mv_language.
            ENDIF.
          WHEN 'DOMNAME'.
            IF ( tableline-domname IS NOT INITIAL ).
              RAISE EVENT domain_selected
                EXPORTING domname = tableline-domname language = mv_language.
            ENDIF.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_SEARCHHELP_FIELDS_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_view_tables_click.
    TRY.
        DATA(tableline) = mt_view_base_tables[ row ].
        CASE column.
          WHEN 'TABNAME'.
            IF ( tableline-tabname IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = tableline-tabname language = mv_language.
            ENDIF.
          WHEN 'FORTABNAME'.
            IF ( tableline-fortabname IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = tableline-fortabname language = mv_language.
            ENDIF.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_VIEW_TABLES_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_view_joins_click.
    TRY.
        DATA(tableline) = mt_view_joins[ row ].
        CASE column.
          WHEN 'LTAB'.
            IF ( tableline-ltab IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = tableline-ltab language = mv_language.
            ENDIF.
          WHEN 'RTAB'.
            IF ( tableline-rtab IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = tableline-rtab language = mv_language.
            ENDIF.
          WHEN 'FRKTAB'.
            IF ( tableline-frktab IS NOT INITIAL ).
              RAISE EVENT tabname_selected
                EXPORTING tabname = tableline-frktab language = mv_language.
            ENDIF.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_VIEW_JOINS_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_transport_infos_click.
    TRY.
        DATA(tableline) = mt_transport_infos[ row ].
        CASE column.
          WHEN 'TRKORR'.
            IF ( tableline-trkorr IS NOT INITIAL ).
              CALL FUNCTION 'TR_DISPLAY_REQUEST'
                EXPORTING
                  i_trkorr = tableline-trkorr.
            ENDIF.
        ENDCASE.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SHOW_TABLE_CONTROL->ON_TRANSPORT_INFOS_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_raise_after_salv_function.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_ddic_model IMPLEMENTATION.
  METHOD build_search_range.
    DATA lv_search       TYPE string.
    DATA lt_tokens       TYPE TABLE OF string.
    DATA lt_combinations TYPE TABLE OF string.
    DATA lt_new_combs    TYPE TABLE OF string.

    lv_search = i_search.
    lv_search = condense( lv_search ).

    REPLACE ALL OCCURRENCES OF REGEX ' +'
      IN lv_search
      WITH '*'.

    REPLACE ALL OCCURRENCES OF REGEX '\*{2,}'
      IN lv_search
      WITH '*'.

    FIND ALL OCCURRENCES OF REGEX '[^*+]+|[*+]+'
      IN lv_search RESULTS DATA(lt_matches).
    IF ( sy-subrc <> 0 ).
      RETURN.
    ENDIF.

    LOOP AT lt_matches INTO DATA(ls_match).
      APPEND lv_search+ls_match-offset(ls_match-length) TO lt_tokens.
    ENDLOOP.

    APPEND space TO lt_combinations.

    LOOP AT lt_tokens INTO DATA(lv_tok).
      IF matches( val   = lv_tok
                  regex = '^[*+]+$' ).
        LOOP AT lt_combinations ASSIGNING FIELD-SYMBOL(<combo>).
          <combo> = <combo> && lv_tok.
        ENDLOOP.

      ELSE.
        DATA(lv_lower) = to_lower( lv_tok ).
        IF ( lv_lower IS NOT INITIAL ).
          DATA(lv_capitalized) = to_upper( lv_lower(1) ) && lv_lower+1.
        ENDIF.

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
      " table description case sensitiv - the defines search text
      APPEND VALUE #( sign = 'I' option = 'CP' low = lv_final )             TO et_text_range.
    ENDLOOP.

    SORT et_tabname_range BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_tabname_range.

    SORT et_text_range BY table_line.
    DELETE ADJACENT DUPLICATES FROM et_text_range.
  ENDMETHOD.

  METHOD check_tcode_exists.
    SELECT SINGLE tcode FROM tstc WHERE tcode = @i_tcode INTO @DATA(tcode).
    IF ( sy-subrc <> 0 ).
      message_log->add_message_text(
        i_msgtyp = 'I'
        i_text   = 'Transaction is not available:'(m05) && | { i_tcode }|
        i_method = 'LCL_DDIC_MODEL=>CHECK_TCODE_EXISTS' ).
    ELSE.
      r_exists = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD check_tcode_authority.
    CALL FUNCTION 'AUTHORITY_CHECK_TCODE'
      EXPORTING
        tcode  = i_tcode
      EXCEPTIONS
        ok     = 1
        not_ok = 2
        OTHERS = 3.
    IF ( sy-subrc = 1 ).
      r_ok = abap_true.
    ELSE.
      message_log->add_message_text(
        i_msgtyp = 'W'
        i_text   = 'No authorization for transaction'(m06) && | { i_tcode }| ).
    ENDIF.
  ENDMETHOD.

  METHOD call_transaction.
    IF ( check_tcode_exists( i_tcode ) AND check_tcode_authority( i_tcode ) ).
      TRY.
          DATA(task) = cl_system_uuid=>create_uuid_c22_static( ).
        CATCH cx_uuid_error INTO DATA(error).
          message_log->add_exception(
            i_error  = error
            i_method = 'CL_SYSTEM_UUID=>CREATE_UUID_C22_STATIC' ).

          RETURN.
      ENDTRY.

      CALL FUNCTION 'ABAP4_CALL_TRANSACTION' STARTING NEW TASK task DESTINATION 'NONE'
        EXPORTING
          tcode                   = i_tcode
          skip_screen             = i_skip_screen
        TABLES
          using_tab               = i_bdcdata
          spagpa_tab              = i_spagtapams
        EXCEPTIONS
          call_transaction_denied = 1
          tcode_invalid           = 2
          OTHERS                  = 3.
      IF sy-subrc <> 0.
        message_log->add_message( i_read_sy = abap_true i_method = 'LCL_DDIC_MODEL=>CALL_TRANSACTION' ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD check_selection_input.
    DATA msg TYPE string.

    IF ( i_control->mt_tabclass_range IS INITIAL ).
      msg = 'No DDIC object category selected, check the filter values'(m07).
      MESSAGE msg TYPE 'S' DISPLAY LIKE 'W'. RETURN.
    ENDIF.

    IF ( i_control->mt_contflag_range IS INITIAL ).
      READ TABLE i_control->mt_tabclass_range TRANSPORTING NO FIELDS WITH KEY low = 'TRANSP'.
      IF ( sy-subrc = 0 ).
        msg = 'No table delivery class selected, check the filter values'(m08).
        MESSAGE msg TYPE 'S' DISPLAY LIKE 'W'. RETURN.
      ENDIF.
    ENDIF.

    IF ( i_control->mt_viewclass_range IS INITIAL ).
      READ TABLE i_control->mt_tabclass_range TRANSPORTING NO FIELDS WITH KEY low = 'VIEW'.
      IF ( sy-subrc = 0 ).
        msg = 'No view type selected, check the filter values'(m09).
        MESSAGE msg TYPE 'S' DISPLAY LIKE 'W'. RETURN.
      ENDIF.
    ENDIF.

    r_success = abap_true.
  ENDMETHOD.

  METHOD select_by_tabname.
    DATA results TYPE type_search_results.
    IF ( i_tabname_range IS INITIAL ).
      RETURN.
    ENDIF.

    SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
      FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                      LEFT OUTER JOIN tadir AS c ON a~tabname = c~obj_name
                        AND c~pgmid = 'R3TR'
                        AND ( c~object = 'TABL' OR c~object = 'VIEW' )
      WHERE a~tabname IN @i_tabname_range
        AND a~as4local = @lcl_ddic_base=>con_active_state
      INTO TABLE @results.

    SORT results BY tabname tabclass ddtext DESCENDING.
    DELETE ADJACENT DUPLICATES FROM results COMPARING tabname tabclass.

    RAISE EVENT found_tables EXPORTING results = results with_popup = abap_false.
  ENDMETHOD.

  METHOD search_tables.
    DATA:
      lt_devclass_range       TYPE RANGE OF devclass,
      lt_search_text_range    TYPE type_search_text_range,
      lt_search_tabname_range TYPE type_search_text_range,
      range_contflag          LIKE i_control->mt_contflag_range,
      results                 TYPE type_search_results.

    IF ( NOT check_selection_input( i_control ) ).
      RETURN.
    ENDIF.

    DATA(search_text) = CONV string( i_input ).
    range_contflag    = i_control->mt_contflag_range.

    IF ( search_text IS INITIAL ).
      search_text = '*'.
    ENDIF.

    IF ( i_control->mv_max_hits > 0 ).
      DATA(up_to_rows) = i_control->mv_max_hits.
    ELSE.
      up_to_rows = 0.
    ENDIF.

    IF ( i_control->mv_search_by_package = abap_true
     AND i_control->mv_package IS NOT INITIAL ).

      APPEND VALUE #( sign = 'I' option = 'EQ' low = i_control->mv_package ) TO lt_devclass_range.
    ENDIF.

    IF ( i_control->mv_search_by_descr = abap_true ).
      " Search By Table Description
      build_search_range(
        EXPORTING
          i_search      = search_text
        IMPORTING
          et_text_range = lt_search_text_range
      ).
    ELSE.
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
      ELSE.
        " Case 1: Build the tabname range on base of the input
        build_search_range(
          EXPORTING
            i_search         = search_text
          IMPORTING
            et_tabname_range = lt_search_tabname_range
        ).
      ENDIF.
    ENDIF.

    LOOP AT i_control->mt_tabclass_range TRANSPORTING NO FIELDS
      WHERE low = lcl_ddic_table=>enum_tabclass-structure
         OR low = lcl_ddic_table=>enum_tabclass-append.

      CLEAR range_contflag. EXIT.
    ENDLOOP.

    LOOP AT i_control->mt_tabclass_range TRANSPORTING NO FIELDS
      WHERE low = lcl_ddic_table=>enum_tabclass-transparent
         OR low = lcl_ddic_table=>enum_tabclass-pool
         OR low = lcl_ddic_table=>enum_tabclass-cluster
         OR low = lcl_ddic_table=>enum_tabclass-structure
         OR low = lcl_ddic_table=>enum_tabclass-append.

      EXIT.
    ENDLOOP.
    IF ( sy-subrc = 0 ).
      IF ( i_control->mv_search_by_descr = abap_true ).
        " Search By Table Description
        SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
          FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                          LEFT OUTER JOIN tadir AS c ON a~tabname = c~obj_name
                            AND c~pgmid  = 'R3TR'
                            AND c~object = 'TABL'
          WHERE a~tabname   IN @i_control->mt_tabname_range
            AND b~ddtext    IN @lt_search_text_range
            AND a~tabclass  IN @i_control->mt_tabclass_range
            AND a~contflag  IN @range_contflag
            AND a~clidep    IN @i_control->mt_clidep_range
            AND a~as4local   = @lcl_ddic_base=>con_active_state
            AND c~devclass  IN @lt_devclass_range
          INTO TABLE @results
          UP TO @up_to_rows ROWS.
      ELSE.
        SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
          FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                          LEFT OUTER JOIN tadir AS c ON a~tabname = c~obj_name
                            AND c~pgmid  = 'R3TR'
                            AND c~object = 'TABL'
          WHERE a~tabname   IN @lt_search_tabname_range
            AND a~tabclass  IN @i_control->mt_tabclass_range
            AND a~contflag  IN @range_contflag
            AND a~clidep    IN @i_control->mt_clidep_range
            AND a~as4local   = @lcl_ddic_base=>con_active_state
            AND c~devclass  IN @lt_devclass_range
          INTO TABLE @results
          UP TO @up_to_rows ROWS.
      ENDIF.
    ENDIF.

    IF ( i_control->mt_viewclass_range IS NOT INITIAL ).
      LOOP AT i_control->mt_tabclass_range TRANSPORTING NO FIELDS
        WHERE low = lcl_ddic_table=>enum_tabclass-view.

        EXIT.
      ENDLOOP.
      IF ( sy-subrc = 0 ).
        IF ( i_control->mv_search_by_descr = abap_true ).
          " Search By Table Description
          SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
            FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                            LEFT OUTER JOIN tadir AS c ON a~tabname = c~obj_name
                              AND c~pgmid  = 'R3TR'
                              AND c~object = 'VIEW'
            WHERE a~tabname   IN @i_control->mt_tabname_range
              AND b~ddtext    IN @lt_search_text_range
              AND a~viewclass IN @i_control->mt_viewclass_range
              AND a~clidep    IN @i_control->mt_clidep_range
              AND a~as4local   = @lcl_ddic_base=>con_active_state
              AND c~devclass  IN @lt_devclass_range
            APPENDING TABLE @results
            UP TO @up_to_rows ROWS.
        ELSE.
          SELECT a~tabname, b~ddlanguage, a~tabclass, b~ddtext, c~devclass
            FROM dd02l AS a LEFT OUTER JOIN dd02t AS b ON a~tabname = b~tabname AND b~ddlanguage = @i_langu
                            LEFT OUTER JOIN tadir AS c ON a~tabname = c~obj_name
                              AND c~pgmid  = 'R3TR'
                              AND c~object = 'VIEW'
            WHERE a~tabname   IN @lt_search_tabname_range
              AND a~viewclass IN @i_control->mt_viewclass_range
              AND a~clidep    IN @i_control->mt_clidep_range
              AND a~as4local   = @lcl_ddic_base=>con_active_state
              AND c~devclass  IN @lt_devclass_range
            APPENDING TABLE @results
            UP TO @up_to_rows ROWS.
        ENDIF.
      ENDIF.
    ENDIF.

    SORT results BY tabname tabclass ddtext DESCENDING.
    DELETE ADJACENT DUPLICATES FROM results COMPARING tabname tabclass.
    IF ( up_to_rows > 0 ).
      DELETE results FROM up_to_rows + 1.
    ENDIF.

    RAISE EVENT found_tables EXPORTING results = results .
  ENDMETHOD.
ENDCLASS.

CLASS lcl_search_control IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_language = i_langu.
  ENDMETHOD.

  METHOD create.
    set_max_hits( lcl_input_fields=>max_hits->* ).

    DATA(splitter) = NEW cl_gui_splitter_container(
      parent     = i_parent
      rows       = 4
      columns    = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).
    splitter->set_row_height(
      id     = 1
      height = lcl_control_metric=>get_line_height( ) * 3 ).
    splitter->set_row_height(
      id     = 2
      height = lcl_control_metric=>get_line_height( ) * 7 ).
    splitter->set_row_height(
      id     = 3
      height = lcl_control_metric=>get_line_height( ) * 1 ).

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
      text      = CONV #( 'DDIC Object Language'(t14) && | { lcl_language_convert=>get_language_output( mv_language ) }| )
      quickinfo = 'Language for search objects'(t15) ).

    toolbar->add_button(
      fcode       = con_fcode-button_max_hits
      icon        = icon_change_number
      butn_type   = cntb_btype_button
      text        = CONV #( 'Max. No. of Hits:'(t16) && | { lcl_input_fields=>max_hits->* }| )
      quickinfo   = 'Maximal Number of Hits'(t17) ).

    toolbar->add_button(
      fcode     = con_fcode-filter_defaults
      icon      = CONV tv_image( icon_filter )
      butn_type = cntb_btype_button
      text      = 'Reset Filter'(t18)
      quickinfo = 'Reset filter to defaults'(t19) ).

    SET HANDLER on_select_setup_toolbar FOR toolbar.
**********************************************************************

    mo_toolbar_filter = NEW lcl_toolbar(
      parent      = splitter->get_container( row = 2 column = 1 )
      display_mode = cl_gui_toolbar=>m_mode_vertical ).

    SET HANDLER on_filter_selected    FOR mo_toolbar_filter.
    SET HANDLER on_filter_fcode_added FOR ALL INSTANCES.

    DATA(dropdown_button) = mo_toolbar_filter->add_dropdown_button(
      fcode       = con_fcode-button_category
      icon        = icon_okay
      text        = 'Object Categories (mandatory)'(t20)
      quickinfo   = 'Select object categories'(t21)
      is_checked  = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_transp
      text    = 'Database Table'(t22)
      checked = abap_true ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_view
      text    = 'View'(t23)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_cluster
      text    = 'Cluster Table'(t24)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_pool
      text    = 'Pooled Table'(t25)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_struct
      text    = 'Structure'(t26)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-tabclass_append
      text    = 'Append-Structure'(t27)
      checked = abap_false ).
**********************************************************************

    dropdown_button = mo_toolbar_filter->add_dropdown_button(
      fcode       = con_fcode-button_delivery
      icon        = icon_incomplete
      text        = 'Table Delivery Class'(t28)
      quickinfo   = 'Select delivery classes'(t29)
      is_checked  = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_appl
      text    = 'Application Table (A)'(t30)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_cust
      text    = 'Custom Table (C)'(t31)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-delivery_contr
      text    = 'Control Table (E)'(t32)
      checked = abap_false ).

    dropdown_button->add_menu_item(
       fcode   = con_fcode-delivery_syst
       text    = 'System Table (W)'(t33)
       checked = abap_false ).

**********************************************************************

    dropdown_button = mo_toolbar_filter->add_dropdown_button(
      fcode       = con_fcode-button_viewclass
      icon        = icon_incomplete
      text        = 'View Types'(t13)
      quickinfo   = 'Select view types'(t34)
      is_checked  = abap_true ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-viewclass_database
      text    = 'Database View (D)'(t35)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-viewclass_projection
      text    = 'Projection View (P)'(t36)
      checked = abap_false ).

    dropdown_button->add_menu_item(
      fcode   = con_fcode-viewclass_maintenance
      text    = 'Maintenance View (C)'(t37)
      checked = abap_false ).

    dropdown_button->add_menu_item(
       fcode   = con_fcode-viewclass_help
       text    = 'Help View (H)'(t38)
       checked = abap_false ).
**********************************************************************

    DATA(check_button) = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_customer
      text        = 'Only Customer Objects'(t39)
      quickinfo   = 'Selects only Z or Y-objects'(t40)
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    check_button = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_client
      text        = 'Client-specific Objects'(t41)
      quickinfo   = 'Client-specific objects'(t42)
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    check_button = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_search_package
      text        = 'Package'(t43)
      quickinfo   = 'Select objects in a package'(t44)
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************

    check_button = mo_toolbar_filter->add_check_button(
      fcode       = con_fcode-button_search_desc
      text        = 'Search Text in Description'(t45)
      quickinfo   = 'Search Text in the description'(t46)
      is_checked  = abap_false
      is_disabled = abap_false ).
**********************************************************************
    set_filter_defaults( ).
**********************************************************************

    DATA(input) = NEW cl_gui_input_field(
        parent               = splitter->get_container( row = 3 column = 1 )
        input_prompt_text    = 'Enter a full name of object or a search text with wildcard ''*'''(t47)
        label_text           = 'Search'(t48)
        label_width          = 10
        activate_history     = abap_true
        activate_find_button = abap_true
        button_icon_info     = icon_search
        button_tooltip_info  = 'Search DDIC objects'(t49)
        default_text         = '' ).

    SET HANDLER on_search FOR input.
**********************************************************************
    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 4 column = 1 )
          IMPORTING r_salv_table = mo_salv_output
          CHANGING  t_table      = mt_salv_output ).
      CATCH cx_salv_msg INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SEARCH_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    DATA column_table TYPE REF TO cl_salv_column_table.
    DATA(columns_table) = mo_salv_output->get_columns( ).
    DATA(columns) = columns_table->get( ).
    LOOP AT columns INTO DATA(column).
      column_table ?= column-r_column.
      column_table->set_key( if_salv_c_bool_sap=>true ).

      column-r_column->set_fixed_header_text( 'S' ).

      CASE column-columnname.
        WHEN 'TABCLASS' OR 'CURRENT'.
          column-r_column->set_visible( if_salv_c_bool_sap=>false ).
        WHEN 'FAVORITE'.
          IF ( lcl_gui_handler=>get_program_variant( ) IS NOT INITIAL ).
            column-r_column->set_long_text( 'Favorite'(c16) ).
            column-r_column->set_medium_text( 'Favorite'(c17) ).
            column-r_column->set_short_text( 'Fav.'(c18) ).
            column-r_column->set_optimized( ).
            column-r_column->set_alignment( if_salv_c_alignment=>centered ).
          ELSE.
            column-r_column->set_visible( if_salv_c_bool_sap=>false ).
          ENDIF.
        WHEN 'STAT'.
          column-r_column->set_long_text( 'Table Status (OK = already read)'(c22) ).
          column-r_column->set_medium_text( 'Status'(c23) ).
          column-r_column->set_short_text( 'Status'(c24) ).
          column-r_column->set_optimized( ).
          column-r_column->set_alignment( if_salv_c_alignment=>centered ).
        WHEN 'CLASS'.
          column-r_column->set_long_text( 'Table Class'(c19) ).
          column-r_column->set_medium_text( 'Type'(c20) ).
          column-r_column->set_short_text( 'Type'(c21) ).
          column-r_column->set_optimized( ).
          column-r_column->set_alignment( if_salv_c_alignment=>centered ).
      ENDCASE.
    ENDLOOP.

    mo_salv_output->get_display_settings( )->set_striped_pattern( abap_true ).
    mo_salv_output->get_display_settings( )->set_no_merging( abap_true ).
    mo_salv_output->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>multiple ).
    mo_salv_output->get_columns( )->set_optimize( ).

    mo_salv_output->get_functions( )->set_filter( ).
    mo_salv_output->get_functions( )->set_filter_delete( ).
    mo_salv_output->get_functions( )->set_sort_asc( ).
    mo_salv_output->get_functions( )->set_sort_desc( ).

    TRY.
        IF ( lcl_gui_handler=>get_program_variant( ) IS NOT INITIAL ).
          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-add_to_var
            icon     = |{ icon_insert_favorites }|
            tooltip  = CONV #( 'Add to program variant'(t68) )
            position = if_salv_c_function_position=>left_of_salv_functions ).

          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-remove_from_var
            icon     = |{ icon_delete_favorites }|
            tooltip  = CONV #( 'Remove from program variant'(t69) )
            position = if_salv_c_function_position=>left_of_salv_functions ).
        ENDIF.

        IF ( lcl_input_fields=>access_se11->* = abap_true ).
          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-se11
            icon     = |{ icon_tools }|
            text     = 'se11'
            tooltip  = CONV #( 'Open selected with SE11'(t51) )
            position = if_salv_c_function_position=>right_of_salv_functions ).
        ENDIF.

        IF ( lcl_input_fields=>access_se16->* = abap_true ).
          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-se16
            icon     = |{ icon_list }|
            text     = 'se16'
            tooltip  = CONV #( 'Open selected with SE16'(t52) )
            position = if_salv_c_function_position=>right_of_salv_functions ).
        ENDIF.

        IF ( lcl_input_fields=>access_se16n->* = abap_true
         AND lcl_ddic_model=>check_tcode_exists( CONV #( con_salv_function-se16n ) ) ).

          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-se16n
            icon     = |{ icon_list }|
            text     = 'se16n'
            tooltip  = CONV #( 'Open selected with SE16N'(t53) )
            position = if_salv_c_function_position=>right_of_salv_functions ).
        ENDIF.

        IF ( lcl_input_fields=>access_se16h->* = abap_true
         AND lcl_ddic_model=>check_tcode_exists( CONV #( con_salv_function-se16h ) ) ).

          mo_salv_output->get_functions( )->add_function(
            name     = con_salv_function-se16h
            icon     = |{ icon_list }|
            text     = 'se16h'
            tooltip  = CONV #( 'Open selected with SE16H'(t54) )
            position = if_salv_c_function_position=>right_of_salv_functions ).
        ENDIF.

        mo_salv_output->get_functions( )->add_function(
          name     = con_salv_function-delete_item
          icon     = |{ icon_delete }|
          tooltip  = CONV #( 'Delete selected items'(t50) )
          position = if_salv_c_function_position=>right_of_salv_functions ).
      CATCH cx_salv_access_error INTO DATA(access_error).
        message_log->add_exception( i_error = access_error i_method = 'LCL_SEARCH_CONTROL->CREATE' ).
        RETURN.
    ENDTRY.

    SET HANDLER on_salv_double_click  FOR mo_salv_output->get_event( ).
    SET HANDLER on_salv_toolbar_click FOR mo_salv_output->get_event( ).

    mo_salv_output->display( ).

    SET HANDLER on_found_tables.

    IF ( lcl_input_fields=>delete_history->* = abap_true ).
      FREE MEMORY ID 'HISTORY'.
    ELSE.
      IMPORT history = mt_history FROM MEMORY ID 'HISTORY'.
    ENDIF.

    cl_gui_container=>set_focus( input ).
  ENDMETHOD.

  METHOD add_items_to_alv.
    DATA selected_rows TYPE salv_t_row.

    LOOP AT i_table_keys ASSIGNING FIELD-SYMBOL(<table_key>).
      READ TABLE mt_salv_output
        TRANSPORTING NO FIELDS
        WITH KEY tabname = <table_key>-tabname ddlanguage = <table_key>-ddlanguage.
      IF ( sy-subrc = 0 ).
        APPEND sy-tabix TO selected_rows.
      ELSE.
        TRY.
            DATA(ddic_table) = lcl_ddic_table=>create_instance( i_tabname = <table_key>-tabname i_langu = <table_key>-ddlanguage ).
          CATCH cx_dynamic_check INTO DATA(error).
            message_log->add_exception( i_error = error i_method = 'LCL_SEARCH_CONTROL->ADD_ITEMS_TO_ALV' ).
            CONTINUE.
        ENDTRY.

        APPEND INITIAL LINE TO mt_salv_output ASSIGNING FIELD-SYMBOL(<table_data>).
        APPEND sy-tabix TO selected_rows.

        MOVE-CORRESPONDING ddic_table->get_header( ) TO <table_data>.

        <table_data>-stat = icon_led_inactive.
        IF ( <table_data>-ddlanguage IS INITIAL ).
          <table_data>-ddlanguage = mv_language.
          <table_data>-ddtext     = |{ lcl_language_convert=>get_language_output( mv_language ) }: | && 'Description is not available'(t13).
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

        IF ( lcl_gui_handler=>get_program_variant( ) IS NOT INITIAL AND lcl_input_fields=>language->* = <table_key>-ddlanguage ).
          READ TABLE lcl_input_fields=>tabname_range
            TRANSPORTING NO FIELDS
            WITH KEY low = <table_key>-tabname.
          IF ( sy-subrc = 0 ).
            <table_data>-favorite = icon_system_favorites.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    mo_salv_output->get_columns( )->set_optimize( ).
    mo_salv_output->get_selections( )->set_selected_rows( selected_rows ).
    mo_salv_output->refresh( ).
  ENDMETHOD.

  METHOD call_history_popup.
    IF ( mt_history IS INITIAL OR mo_salv_history IS BOUND ).
      RETURN.
    ENDIF.

    DATA(style)    = cl_gui_control=>ws_minimizebox + cl_gui_control=>ws_maximizebox + cl_gui_control=>ws_sysmenu.
    DATA(screen_x) = lcl_control_metric=>get_screen_x( ).
    DATA(top)      = 178.
    DATA(width)    = CONV i( screen_x / '3.5' ).
    DATA(left)     = screen_x - width - 17.
    DATA(row_height) = lines( mt_history ) * 30.

    DATA(container) = NEW cl_gui_dialogbox_container(
      parent  = cl_gui_container=>default_screen
      caption = 'Objects History across ABAP Sessions'(t72)
      top     = top
      left    = left
      width   = width
      height  = lcl_control_metric=>get_screen_y( ) - top
      style   = style
      metric  = cl_gui_dialogbox_container=>metric_pixel
      no_autodef_progid_dynnr = abap_true
    ).

    SET HANDLER on_popup_close FOR container.

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = container
          IMPORTING r_salv_table = mo_salv_history
          CHANGING  t_table      = mt_history ).
      CATCH cx_salv_msg INTO DATA(salv_error).
        message_log->add_exception( i_error = salv_error i_method = 'LCL_SEARCH_CONTROL->CALL_HISTORY_POPUP' ).
        RETURN.
    ENDTRY.

    mo_salv_history->get_functions( )->set_all( abap_false ).
    mo_salv_history->get_display_settings( )->set_striped_pattern( abap_true ).
    mo_salv_history->get_columns( )->set_optimize( ).
    mo_salv_history->display( ).

    SET HANDLER on_history_double_click FOR mo_salv_history->get_event( ).

    cl_gui_container=>set_focus( container ).
  ENDMETHOD.

  METHOD get_history_lines.
    rv_lines = lines( mt_history ).
  ENDMETHOD.

  METHOD get_result_lines.
    rv_lines = lines( mt_salv_output ).
  ENDMETHOD.

  METHOD on_filter_selected.
    DATA:
      return   TYPE STANDARD TABLE OF ddshretval,
      devclass TYPE tadir-devclass.

    set_filter_values( i_function = fcode i_checked = checked ).

    IF ( fcode = con_fcode-button_search_package ).
      IF ( checked = abap_true ).
        CALL FUNCTION 'F4IF_FIELD_VALUE_REQUEST'
          EXPORTING
            tabname           = 'TADIR'
            fieldname         = 'DEVCLASS'
            searchhelp        = 'DEVCLASS'
          TABLES
            return_tab        = return
          EXCEPTIONS
            field_not_found   = 1
            no_help_for_field = 2
            inconsistent_help = 3
            no_values_found   = 4
            OTHERS            = 5.
        IF sy-subrc = 0 AND return IS NOT INITIAL.
          devclass = return[ 1 ]-fieldval.

          set_package( devclass ).
          sender->set_button_text(
            fcode = fcode
            text  = CONV #( 'Package'(t43) && | { devclass }| )
          ).
        ELSE.
          set_package( space ).
          sender->set_button_attr(
            fcode   = fcode
            checked = abap_false ).

          sender->set_button_text(
            fcode = fcode
            text  = 'Package'(t43) ).
        ENDIF.
      ELSE.
        set_package( space ).
        sender->set_button_text(
          fcode = fcode
          text  = 'Package'(t43) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD on_filter_fcode_added.
    set_filter_values( i_function = fcode i_checked = checked ).
  ENDMETHOD.

  METHOD on_search.
    lcl_ddic_model=>search_tables( i_input = input i_control = me i_langu = mv_language ).
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
        DATA(langu)     = lcl_language_convert=>get_language_input( langu_iso ).
        IF ( langu = mv_language ).
          RETURN.
        ENDIF.

        mv_language = langu.

        sender->set_button_info(
          fcode     = fcode
          text      = CONV #( 'DDIC Object Language'(t14) && | { langu_iso }| )
          quickinfo = 'Language for search objects'(t15) ).

        IF ( mt_salv_output IS NOT INITIAL ).
          DATA:
            ret              TYPE c LENGTH 1,
            selected_objects TYPE type_table_keys.

          CALL FUNCTION 'POPUP_TO_CONFIRM'
            EXPORTING
              titlebar              = 'Read the selected tables in this language?'(t01)
              text_question         = 'Schould the selected tables be read in this language?'(t02)
              default_button        = '1'
              display_cancel_button = abap_false
            IMPORTING
              answer                = ret.
          IF ( ret = '1' ).
            LOOP AT mt_salv_output ASSIGNING FIELD-SYMBOL(<output>).
              INSERT VALUE #( tabname = <output>-tabname ddlanguage = mv_language ) INTO TABLE selected_objects.
            ENDLOOP.

            add_items_to_alv( selected_objects ).
          ENDIF.
        ENDIF.
      ENDIF.
    ELSEIF ( fcode = con_fcode-button_max_hits ).
      DATA:
        fields          TYPE STANDARD TABLE OF sval,
        returncode(1)   TYPE c,
        popup_title(30) TYPE c.

      popup_title = 'Maximal No. of Hits'(t17).

      APPEND VALUE #( tabname = 'SYST' fieldname = 'DBCNT' value = lif_sql_select_values~mv_max_hits field_attr = '00' ) TO fields.

      CALL FUNCTION 'POPUP_GET_VALUES'
        EXPORTING
          popup_title = popup_title
        IMPORTING
          returncode  = returncode
        TABLES
          fields      = fields.
      IF ( returncode <> 'A' ).
        DATA:
          number   TYPE sy-dbcnt,
          add_text TYPE text40.

        number = fields[ 1 ]-value.

        IF ( number < 1 ).
          number   = 0.
          add_text = '(select all)'(t55).
        ENDIF.

        set_max_hits( number ).

        sender->set_button_info(
          fcode     = fcode
          text      = CONV #( 'Max. No. of Hits:'(t16) &&  | { number } { add_text }| )
          quickinfo = 'Maximal Number of Hits'(t17) ).
      ENDIF.
    ELSEIF ( fcode = con_fcode-filter_defaults ).
      set_filter_defaults( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_history_double_click.
    TRY.
        DATA(history_line) = mt_history[ row ].
        add_items_to_alv( VALUE #( ( tabname = history_line-tabname ddlanguage = history_line-langu ) ) ).

        READ TABLE mt_salv_output INTO DATA(tabline)
          WITH KEY tabname    = history_line-tabname
                   ddlanguage = history_line-langu.
        IF ( sy-subrc = 0 ).
          DATA(tabix) = sy-tabix.

          IF ( tabline-current = abap_true ).
            RETURN.
          ENDIF.

          LOOP AT mt_salv_output ASSIGNING FIELD-SYMBOL(<line>).
            CLEAR <line>-current.

            IF ( <line> = tabline ).
              <line>-stat    = icon_checked.
              <line>-current = abap_true.
            ENDIF.
          ENDLOOP.

          add_history_entry( tabline ).

          RAISE EVENT table_selected EXPORTING tabname = tabline-tabname tabclass = tabline-tabclass language = tabline-ddlanguage.

          mo_salv_output->get_selections( )->set_selected_rows( VALUE #( ( tabix ) ) ).
          mo_salv_output->refresh( ).
        ENDIF.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SEARCH_CONTROL->ON_HISTORY_DOUBLE_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_popup_close.
    IF sender IS NOT INITIAL.
      SET HANDLER on_history_double_click FOR mo_salv_history->get_event( ) ACTIVATION abap_false.
      CLEAR mo_salv_history.
      sender->free( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_found_tables.
    DATA:
      selected_objects TYPE type_table_keys,
      tabname          TYPE tabname,
      f4_returns       TYPE STANDARD TABLE OF ddshretval.

    IF ( lines( results  ) = 0 ).
      MESSAGE 'No data found, check the filter values'(m10) TYPE 'S' DISPLAY LIKE 'W'. RETURN.
    ELSEIF ( lines( results  ) = 1 OR with_popup = abap_false ).
      LOOP AT results ASSIGNING FIELD-SYMBOL(<result>).
        INSERT VALUE #(
            tabname    = <result>-tabname
            ddlanguage = COND #( WHEN <result>-ddlanguage IS NOT INITIAL THEN <result>-ddlanguage
                                 ELSE mv_language )
          ) INTO TABLE selected_objects.
      ENDLOOP.
    ELSE.
      CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
        EXPORTING
          retfield        = 'TABNAME'
          window_title    = 'Search Table/View'(t56)
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
        message_log->add_message( i_read_sy = abap_true ). RETURN.
      ENDIF.

      IF ( f4_returns IS INITIAL ).
        RETURN.
      ENDIF.

      LOOP AT f4_returns ASSIGNING FIELD-SYMBOL(<f4_result>).
        tabname = <f4_result>-fieldval.
        INSERT VALUE #( tabname = tabname ddlanguage = mv_language ) INTO TABLE selected_objects.
      ENDLOOP.
    ENDIF.

    add_items_to_alv( selected_objects ).
  ENDMETHOD.

  METHOD on_salv_double_click.
    TRY.
        DATA(tabline) = mt_salv_output[ row ].
        IF ( tabline-current = abap_true ).
          RETURN.
        ENDIF.

        LOOP AT mt_salv_output ASSIGNING FIELD-SYMBOL(<line>).
          CLEAR <line>-current.

          IF ( <line> = tabline ).
            <line>-stat    = icon_checked.
            <line>-current = abap_true.
          ENDIF.
        ENDLOOP.

        mo_salv_output->get_columns( )->set_optimize( ).
        mo_salv_output->get_selections( )->set_selected_rows( VALUE #( ( row ) ) ).
        mo_salv_output->refresh( ).

        add_history_entry( tabline ).

        RAISE EVENT table_selected EXPORTING tabname = tabline-tabname tabclass = tabline-tabclass language = tabline-ddlanguage.
      CATCH cx_sy_itab_line_not_found INTO DATA(error).
        message_log->add_exception( i_error = error i_method = 'LCL_SEARCH_CONTROL->ON_SALV_DOUBLE_CLICK' ).
    ENDTRY.
  ENDMETHOD.

  METHOD on_salv_toolbar_click.
    DATA:
      selected_tables TYPE type_table_keys,
      selected_table  LIKE LINE OF selected_tables,
      rsparams_tab    TYPE STANDARD TABLE OF rsparams,
      variant_descr   TYPE varid.

    IF ( e_salv_function = con_salv_function-add_to_var
      OR e_salv_function = con_salv_function-remove_from_var ).

      DATA(variant) = lcl_gui_handler=>get_program_variant( ).
      IF ( variant IS NOT INITIAL ).
        CALL FUNCTION 'RS_VARIANT_EXISTS'
          EXPORTING
            report              = sy-repid
            variant             = variant
          EXCEPTIONS
            not_authorized      = 1
            no_report           = 2
            report_not_existent = 3
            report_not_supplied = 4
            OTHERS              = 5.
        IF ( sy-subrc <> 0 ).
          message_log->add_message(
            i_read_sy = abap_true
            i_method  = 'RS_VARIANT_EXISTS'
            i_object  = variant ).

          RETURN.
        ENDIF.
      ENDIF.

      CALL FUNCTION 'RS_VARIANT_CONTENTS'
        EXPORTING
          report               = sy-repid
          variant              = variant
        TABLES
          valutab              = rsparams_tab
        EXCEPTIONS
          variant_non_existent = 1
          variant_obsolete     = 2
          OTHERS               = 3.
      IF ( sy-subrc <> 0 ).
        message_log->add_message(
          i_read_sy = abap_true
          i_method  = 'RS_VARIANT_CONTENTS'
          i_object  = variant ).

        RETURN.
      ENDIF.

      DATA(changed) = abap_false.
      LOOP AT mo_salv_output->get_selections( )->get_selected_rows( ) INTO DATA(row).
        IF ( e_salv_function = con_salv_function-add_to_var ).
          LOOP AT rsparams_tab ASSIGNING FIELD-SYMBOL(<rsparam>)
            WHERE selname = 'SO_TABLE' AND low = mt_salv_output[ row ]-tabname.

            EXIT.
          ENDLOOP.
          IF ( sy-subrc <> 0 ).
            changed = abap_true.

            APPEND INITIAL LINE TO rsparams_tab ASSIGNING <rsparam>.
            <rsparam>-selname = 'SO_TABLE'.
            <rsparam>-kind    = 'S'.
            <rsparam>-sign    = 'I'.
            <rsparam>-option  = 'EQ'.
            <rsparam>-low     = mt_salv_output[ row ]-tabname.

            mt_salv_output[ row ]-favorite = icon_system_favorites.
          ENDIF.
        ELSE.
          changed = abap_true.
          DELETE rsparams_tab WHERE selname = 'SO_TABLE' AND low = mt_salv_output[ row ]-tabname.
          CLEAR mt_salv_output[ row ]-favorite.
        ENDIF.
      ENDLOOP.

      IF ( changed = abap_true ).
        CALL FUNCTION 'RS_CHANGE_CREATED_VARIANT'
          EXPORTING
            curr_report               = sy-repid
            curr_variant              = variant
            vari_desc                 = variant_descr
            only_contents             = abap_true
          TABLES
            vari_contents             = rsparams_tab
          EXCEPTIONS
            illegal_report_or_variant = 1
            illegal_variantname       = 2
            not_authorized            = 3
            not_executed              = 4
            report_not_existent       = 5
            report_not_supplied       = 6
            variant_doesnt_exist      = 7
            variant_locked            = 8
            selections_no_match       = 9
            OTHERS                    = 10.
        IF ( sy-subrc <> 0 ).
          message_log->add_message(
            i_read_sy = abap_true
            i_method  = 'RS_CHANGE_CREATED_VARIANT'
            i_object  = variant ).
        ENDIF.

        mo_salv_output->refresh( ).
      ENDIF.
    ELSEIF ( e_salv_function = con_salv_function-delete_item ).
      IF ( lines( mo_salv_output->get_selections( )->get_selected_columns( ) ) > 0 ).
        " delete all items by column selections
        CLEAR mt_salv_output.

        RAISE EVENT all_items_deleted.
      ELSEIF ( lines( mo_salv_output->get_selections( )->get_selected_rows( ) ) > 0 ).
        " delete the selected items
        LOOP AT mo_salv_output->get_selections( )->get_selected_rows( ) INTO row.
          APPEND VALUE #(
            tabname = mt_salv_output[ row ]-tabname ddlanguage = mt_salv_output[ row ]-ddlanguage ) TO selected_tables.

          mt_salv_output[ row ]-stat = icon_delete.
        ENDLOOP.

        DELETE mt_salv_output WHERE stat = icon_delete.

        RAISE EVENT items_deleted EXPORTING selected_items = selected_tables.
      ENDIF.

      mo_salv_output->refresh( ).
    ELSEIF ( e_salv_function = con_salv_function-se11
          OR e_salv_function = con_salv_function-se16 ).

      LOOP AT mo_salv_output->get_selections( )->get_selected_rows( ) INTO row.
        DATA(ls_first_selected) = mt_salv_output[ row ]. EXIT.
      ENDLOOP.

      IF ( ls_first_selected IS INITIAL ).
        RETURN.
      ENDIF.

      DATA(tcode) = CONV sy-tcode( e_salv_function ).
      IF ( tcode <> con_salv_function-se11
        AND ( ls_first_selected-tabclass = 'INTTAB' OR ls_first_selected-tabclass = 'APPEND' ) ).

        RETURN.
      ENDIF.

      DATA lt_params TYPE STANDARD TABLE OF rfc_spagpa WITH EMPTY KEY.
      CASE ls_first_selected-tabclass.
        WHEN 'INTTAB' OR 'APPEND'.
          APPEND VALUE #( parid = 'DTYP' parval = ls_first_selected-tabname ) TO lt_params.
        WHEN 'VIEW'.
          APPEND VALUE #( parid = 'DTYP' parval = space ) TO lt_params.
          IF ( tcode = con_salv_function-se11 ).
            APPEND VALUE #( parid = 'DVI' parval = ls_first_selected-tabname ) TO lt_params.
          ELSE.
            APPEND VALUE #( parid = 'DTB' parval = ls_first_selected-tabname ) TO lt_params.
          ENDIF.
        WHEN OTHERS.
          APPEND VALUE #( parid = 'DTB' parval = ls_first_selected-tabname ) TO lt_params.
      ENDCASE.

      lcl_ddic_model=>call_transaction(
        i_tcode      = tcode
        i_spagtapams = lt_params ).

    ELSEIF ( e_salv_function = con_salv_function-se16n
          OR e_salv_function = con_salv_function-se16h ).

      LOOP AT mo_salv_output->get_selections( )->get_selected_rows( ) INTO row.
        ls_first_selected = mt_salv_output[ row ]. EXIT.
      ENDLOOP.

      IF ( ls_first_selected IS INITIAL ).
        RETURN.
      ENDIF.

      IF ( ls_first_selected-tabclass = 'INTTAB' OR ls_first_selected-tabclass = 'APPEND' ).
        RETURN.
      ENDIF.

      tcode = CONV sy-tcode( e_salv_function ).

      DATA lt_bdcdata TYPE lcl_ddic_model=>type_bdcdata.
      APPEND VALUE #( program = 'SAPLSE16N'  dynpro = '0100' dynbegin = 'X' )      TO lt_bdcdata.
      APPEND VALUE #( fnam    = 'BDC_CURSOR' fval   = 'GD-TAB' )                   TO lt_bdcdata.
      APPEND VALUE #( fnam    = 'GD-TAB'     fval    = ls_first_selected-tabname ) TO lt_bdcdata.

      lcl_ddic_model=>call_transaction(
        i_tcode   = tcode
        i_bdcdata = lt_bdcdata ).
    ENDIF.
  ENDMETHOD.

  METHOD add_history_entry.
    DELETE mt_history
      WHERE tabname = i_tabline-tabname
        AND langu   = i_tabline-ddlanguage.

    APPEND VALUE #(
      tabname   = i_tabline-tabname
      tabclass  = i_tabline-tabclass
      ddtext    = i_tabline-ddtext
      langu     = i_tabline-ddlanguage
      opened_at = sy-timlo
    ) TO mt_history.

    EXPORT history = mt_history TO MEMORY ID 'HISTORY'.

    IF ( mo_salv_history IS BOUND ).
      mo_salv_history->get_columns( )->set_optimize( ).
      mo_salv_history->get_selections( )->set_selected_rows( VALUE #( ( lines( mt_history ) ) ) ).
      mo_salv_history->refresh( ).
    ENDIF.
  ENDMETHOD.

  METHOD set_filter_defaults.
    mo_toolbar_filter->set_button_attr(
      fcode   = con_fcode-button_category
      checked = abap_true
      menu_items = VALUE #(
        ( fcode = con_fcode-tabclass_transp  checked = lcl_input_fields=>object_cat_dbtable->* )
        ( fcode = con_fcode-tabclass_view    checked = lcl_input_fields=>object_cat_view->* )
        ( fcode = con_fcode-tabclass_pool    checked = lcl_input_fields=>object_cat_pool->* )
        ( fcode = con_fcode-tabclass_cluster checked = lcl_input_fields=>object_cat_cluster->* )
        ( fcode = con_fcode-tabclass_struct  checked = lcl_input_fields=>object_cat_struct->* )
        ( fcode = con_fcode-tabclass_append  checked = lcl_input_fields=>object_cat_append->* )
    ) ).

    mo_toolbar_filter->set_button_attr(
      fcode   = con_fcode-button_delivery
      checked = abap_true
      menu_items = VALUE #(
        ( fcode = con_fcode-delivery_appl  checked = lcl_input_fields=>table_deliv_appl->* )
        ( fcode = con_fcode-delivery_cust  checked = lcl_input_fields=>table_deliv_cust->* )
        ( fcode = con_fcode-delivery_contr checked = lcl_input_fields=>table_deliv_ctrl->* )
        ( fcode = con_fcode-delivery_syst  checked = lcl_input_fields=>table_deliv_syst->* )
    ) ).

    mo_toolbar_filter->set_button_attr(
      fcode   = con_fcode-button_viewclass
      checked = abap_true
      menu_items = VALUE #(
        ( fcode = con_fcode-viewclass_database    checked = lcl_input_fields=>view_type_db->* )
        ( fcode = con_fcode-viewclass_projection  checked = lcl_input_fields=>view_type_proj->* )
        ( fcode = con_fcode-viewclass_maintenance checked = lcl_input_fields=>view_type_maint->* )
        ( fcode = con_fcode-viewclass_help        checked = lcl_input_fields=>view_type_help->* )
    ) ).

    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_customer       checked = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_client         checked = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_search_package checked = abap_false ).
    mo_toolbar_filter->set_button_attr( fcode = con_fcode-button_search_desc    checked = abap_false ).
  ENDMETHOD.

  METHOD set_filter_values.
    CASE i_function.
      WHEN con_fcode-button_search_package.
        lif_sql_select_values~mv_search_by_package = i_checked.
      WHEN con_fcode-button_search_desc.
        lif_sql_select_values~mv_search_by_descr = i_checked.
      WHEN con_fcode-delivery_appl
        OR con_fcode-delivery_cust
        OR con_fcode-delivery_contr
        OR con_fcode-delivery_syst.

        DATA(contflag) = CONV dd02v-contflag( i_function+1(1) ).
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = contflag ) TO lif_sql_select_values~mt_contflag_range.
        ELSE.
          DELETE lif_sql_select_values~mt_contflag_range WHERE low = contflag.
        ENDIF.
      WHEN con_fcode-viewclass_database
        OR con_fcode-viewclass_projection
        OR con_fcode-viewclass_maintenance
        OR con_fcode-viewclass_help.

        DATA(viewclass) = CONV dd02v-viewclass( i_function+1(1) ).
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = viewclass ) TO lif_sql_select_values~mt_viewclass_range.
        ELSE.
          DELETE lif_sql_select_values~mt_viewclass_range WHERE low = viewclass.
        ENDIF.
      WHEN con_fcode-tabclass_transp
        OR con_fcode-tabclass_view
        OR con_fcode-tabclass_cluster
        OR con_fcode-tabclass_pool
        OR con_fcode-tabclass_struct
        OR con_fcode-tabclass_append.

        DATA(tabclass) = CONV dd02v-tabclass( i_function ).
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = tabclass ) TO lif_sql_select_values~mt_tabclass_range.
        ELSE.
          DELETE lif_sql_select_values~mt_tabclass_range WHERE low = tabclass.
        ENDIF.
      WHEN con_fcode-button_client.
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'X' ) TO lif_sql_select_values~mt_clidep_range.
        ELSE.
          CLEAR lif_sql_select_values~mt_clidep_range.
        ENDIF.
      WHEN con_fcode-button_customer.
        IF ( i_checked = abap_true ).
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'Z*' ) TO lif_sql_select_values~mt_tabname_range.
          APPEND VALUE #( sign = 'I' option = 'CP' low = 'Y*' ) TO lif_sql_select_values~mt_tabname_range.
        ELSE.
          CLEAR lif_sql_select_values~mt_tabname_range.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD set_package.
    lif_sql_select_values~mv_package = i_package.
  ENDMETHOD.

  METHOD set_max_hits.
    lif_sql_select_values~mv_max_hits = i_number.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_controller_base DEFINITION ABSTRACT CREATE PROTECTED.
  PUBLIC SECTION.
    METHODS:
      on_init ABSTRACT.

  PROTECTED SECTION.
    TYPES type_simple_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

    METHODS:
      constructor          IMPORTING i_view TYPE REF TO lcl_view_base,
      get_view             RETURNING VALUE(r_view) TYPE REF TO lcl_view_base,
      on_close_application FOR EVENT close_application OF lcl_gui_handler,
      on_at_output         ABSTRACT FOR EVENT at_output OF lcl_gui_handler,
      on_at_input          ABSTRACT FOR EVENT at_input  OF lcl_gui_handler IMPORTING ucomm,
      on_at_exit           ABSTRACT FOR EVENT at_exit   OF lcl_gui_handler IMPORTING ucomm.

  PRIVATE SECTION.
    DATA:
      mo_view TYPE REF TO lcl_view_base.
ENDCLASS.

CLASS lcl_controller_base IMPLEMENTATION.
  METHOD constructor.
    mo_view = i_view.

    SET HANDLER on_close_application.
  ENDMETHOD.

  METHOD get_view.
    r_view = mo_view.
  ENDMETHOD.

  METHOD on_close_application.
    SET HANDLER on_at_output ACTIVATION abap_false.
    SET HANDLER on_at_input  ACTIVATION abap_false.
    SET HANDLER on_at_exit   ACTIVATION abap_false.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_table_view DEFINITION DEFERRED.
CLASS lcl_table_view_ctrl DEFINITION INHERITING FROM lcl_controller_base FRIENDS lcl_table_view.
  PUBLIC SECTION.
    EVENTS:
      go_back,
      call_history,
      output_screen.

    METHODS:
      on_init REDEFINITION.

  PROTECTED SECTION.
    METHODS:
      on_at_output  REDEFINITION,
      on_at_input   REDEFINITION,
      on_at_exit    REDEFINITION.
ENDCLASS.

CLASS lcl_table_view_ctrl IMPLEMENTATION.
  METHOD on_init.
    SET HANDLER on_at_output.
    SET HANDLER on_at_input.
    SET HANDLER on_at_exit.
  ENDMETHOD.

  METHOD on_at_output.
    RAISE EVENT output_screen.
  ENDMETHOD.

  METHOD on_at_input.
    CASE ucomm.
      WHEN 'FC04'.  " History
        RAISE EVENT call_history.
    ENDCASE.
  ENDMETHOD.

  METHOD on_at_exit.
    RAISE EVENT go_back.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_view_base DEFINITION ABSTRACT FRIENDS lcl_controller_base.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    TYPES:
      type_screen_title TYPE c LENGTH 70,
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
      create_root_container IMPORTING i_dynnr TYPE sy-dynnr i_rows TYPE i i_columns TYPE i,
      free_root_container.

    CLASS-DATA:
      root_container TYPE REF TO cl_gui_splitter_container,
      search_control TYPE REF TO lcl_search_control.

    METHODS:
      create_content ABSTRACT,
      destroy        ABSTRACT,
      get_titel      ABSTRACT IMPORTING i_additional   TYPE csequence OPTIONAL
                              RETURNING VALUE(r_title) TYPE type_screen_title.

    DATA:
      mo_controller    TYPE REF TO lcl_controller_base,
      mv_default_langu TYPE sy-langu.
ENDCLASS.

CLASS lcl_view_base IMPLEMENTATION.
  METHOD create_root_container.
    free_root_container( ).

    root_container = NEW #(
      parent     = cl_gui_container=>screen0
      link_repid = sy-repid
      link_dynnr = i_dynnr
      rows       = i_rows
      columns    = i_columns ).
  ENDMETHOD.

  METHOD constructor.
    mv_default_langu = i_langu.
  ENDMETHOD.

  METHOD free_root_container.
    IF ( root_container IS BOUND ).
      root_container->free( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_start_view DEFINITION DEFERRED.
CLASS lcl_start_view_ctrl DEFINITION INHERITING FROM lcl_controller_base FRIENDS lcl_start_view.
  PUBLIC SECTION.
    EVENTS:
      show_navigation,
      go_back,
      output_screen.

    METHODS:
      on_init REDEFINITION.

  PROTECTED SECTION.
    METHODS:
      on_at_output  REDEFINITION,
      on_at_input   REDEFINITION,
      on_at_exit    REDEFINITION.
ENDCLASS.

CLASS lcl_start_view_ctrl IMPLEMENTATION.
  METHOD on_init.
    SET HANDLER on_at_output.
    SET HANDLER on_at_input.
    SET HANDLER on_at_exit.
  ENDMETHOD.

  METHOD on_at_output.
    RAISE EVENT output_screen.
  ENDMETHOD.

  METHOD on_at_input.
  ENDMETHOD.

  METHOD on_at_exit.
    IF ( ucomm = 'CBAC' ).
      RAISE EVENT go_back.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_start_view DEFINITION INHERITING FROM lcl_view_base.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    METHODS:
      create_content   REDEFINITION,
      destroy          REDEFINITION,
      get_titel        REDEFINITION,
      on_output_screen FOR EVENT output_screen OF lcl_start_view_ctrl,
      on_go_back       FOR EVENT go_back       OF lcl_start_view_ctrl.
ENDCLASS.

CLASS lcl_start_view IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_langu ).

    mo_controller = NEW lcl_start_view_ctrl( me ).

    SET HANDLER on_output_screen FOR ALL INSTANCES.
    SET HANDLER on_go_back       FOR ALL INSTANCES.

    create_content( ).

    mo_controller->on_init( ).
  ENDMETHOD.

  METHOD create_content.
  ENDMETHOD.

  METHOD destroy.
    SET HANDLER on_output_screen FOR ALL INSTANCES ACTIVATION abap_false.
    SET HANDLER on_go_back       FOR ALL INSTANCES ACTIVATION abap_false.
  ENDMETHOD.

  METHOD get_titel.
    r_title = 'Advanced DDIC Explorer Community - Start Screen'.
  ENDMETHOD.

  METHOD on_output_screen.
    tsstart = get_titel( ).
  ENDMETHOD.

  METHOD on_go_back.
    DATA ret TYPE c LENGTH 1.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Leave Program?'(t57)
        text_question         = 'Do you want to leave program?'(t58)
        default_button        = '1'
        display_cancel_button = abap_false
      IMPORTING
        answer                = ret.
    IF ( ret = '2' ).
      lcl_gui_handler=>reload_start_screen( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_table_view DEFINITION INHERITING FROM lcl_view_base.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF type_popup_pos,
        container TYPE REF TO cl_gui_dialogbox_container,
        posx      TYPE i,
        posy      TYPE i,
      END OF type_popup_pos.

    METHODS:
      create_content           REDEFINITION,
      destroy                  REDEFINITION,
      get_titel                REDEFINITION,
      on_output_screen         FOR EVENT output_screen         OF lcl_table_view_ctrl,
      on_go_back               FOR EVENT go_back               OF lcl_table_view_ctrl,
      on_call_history          FOR EVENT call_history          OF lcl_table_view_ctrl,
      on_table_selected        FOR EVENT table_selected        OF lcl_search_control IMPORTING tabname tabclass language sender,
      on_items_deleted         FOR EVENT items_deleted         OF lcl_search_control IMPORTING selected_items sender,
      on_all_items_deleted     FOR EVENT all_items_deleted     OF lcl_search_control IMPORTING sender,
      on_popup_close           FOR EVENT close                 OF cl_gui_dialogbox_container IMPORTING sender,
      on_data_element_selected FOR EVENT data_element_selected OF lcl_show_table_control IMPORTING rollname language sender,
      on_domain_selected       FOR EVENT domain_selected       OF lcl_show_table_control IMPORTING domname language sender,
      on_tabname_selected      FOR EVENT tabname_selected      OF lcl_show_table_control IMPORTING tabname language sender.

    DATA:
      mv_title_additions   TYPE c LENGTH 60,
      mo_table_bar_control TYPE REF TO lcl_show_table_control,
      mt_popup_pos         TYPE STANDARD TABLE OF type_popup_pos.
ENDCLASS.

CLASS lcl_table_view IMPLEMENTATION.
  METHOD constructor.
    super->constructor( i_langu ).

    mo_controller  = NEW lcl_table_view_ctrl( me ).

    SET HANDLER on_output_screen FOR ALL INSTANCES.
    SET HANDLER on_go_back       FOR ALL INSTANCES.
    SET HANDLER on_call_history       FOR ALL INSTANCES.

    create_content( ).

    mo_controller->on_init( ).
  ENDMETHOD.

  METHOD create_content.
    create_root_container( i_dynnr = '1002' i_rows = 1 i_columns = 2 ).
    root_container->set_visible( abap_false ).

    search_control = NEW lcl_search_control( mv_default_langu ).
    search_control->create( i_parent = root_container->get_container( row = 1 column = 1 ) ).

    DATA(width) = lcl_control_metric=>get_screen_x( ).
    IF ( width <= lcl_control_metric=>enum_screen_width-middle ).
      DATA(nav)  = 25.
      DATA(main) = 75.
    ELSEIF ( width <= lcl_control_metric=>enum_screen_width-super_large ).
      nav  = 22.
      main = 78.
    ELSE.
      nav  = 20.
      main = 80.
    ENDIF.

    root_container->set_column_width( id = 1 width = nav ).
    root_container->set_column_width( id = 2 width = main ).

    mo_table_bar_control = NEW lcl_show_table_control( ).
    mo_table_bar_control->create( i_parent = root_container->get_container( row = 1 column = 2 ) ).

    SET HANDLER on_table_selected        FOR search_control.
    SET HANDLER on_items_deleted         FOR search_control.
    SET HANDLER on_all_items_deleted     FOR search_control.
    SET HANDLER on_data_element_selected FOR ALL INSTANCES.
    SET HANDLER on_domain_selected       FOR ALL INSTANCES.
    SET HANDLER on_tabname_selected      FOR ALL INSTANCES.

    IF ( lcl_input_fields=>tabname_range IS NOT INITIAL ).
      lcl_ddic_model=>select_by_tabname( i_tabname_range = lcl_input_fields=>tabname_range i_langu = mv_default_langu ).
    ENDIF.

    root_container->set_visible( abap_true ).
  ENDMETHOD.

  METHOD destroy.
    SET HANDLER on_output_screen         FOR ALL INSTANCES ACTIVATION abap_false.
    SET HANDLER on_go_back               FOR ALL INSTANCES ACTIVATION abap_false.
    SET HANDLER on_table_selected        FOR search_control ACTIVATION abap_false.
    SET HANDLER on_items_deleted         FOR search_control ACTIVATION abap_false.
    SET HANDLER on_all_items_deleted     FOR search_control ACTIVATION abap_false.
    SET HANDLER on_data_element_selected FOR ALL INSTANCES ACTIVATION abap_false.
    SET HANDLER on_domain_selected       FOR ALL INSTANCES ACTIVATION abap_false.
    SET HANDLER on_tabname_selected      FOR ALL INSTANCES ACTIVATION abap_false.

    CLEAR:
      mt_popup_pos, search_control, mo_table_bar_control.

    DO 2 TIMES.
      root_container->get_container( row = 1 column = sy-index )->free( ).
    ENDDO.
  ENDMETHOD.

  METHOD get_titel.
    IF ( i_additional IS NOT INITIAL ).
      r_title = |Advanced DDIC Workbench - { i_additional }|.
    ELSE.
      r_title = 'Advanced DDIC Workbench - Initial Screen'.
    ENDIF.
  ENDMETHOD.

  METHOD on_output_screen.
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

    IF ( mv_title_additions IS INITIAL ).
      tsddic = get_titel( ).
    ELSE.
      tsddic = get_titel( mv_title_additions ).
    ENDIF.

    sscrfields-functxt_04 = VALUE smp_dyntxt(
      icon_id   = icon_history
      icon_text = COND #( WHEN search_control->get_history_lines( ) > 0 THEN 'History'(t70) && | ({ search_control->get_history_lines( ) })|
                          ELSE 'History'(t70) )
      quickinfo = 'Show Objects History'(t71) ).

    sscrfields-functxt_05 = VALUE smp_dyntxt(
      icon_id   = COND #( WHEN message_log->check_type( 'E' ) THEN icon_message_error_small
                          WHEN message_log->check_type( 'W' ) THEN icon_message_warning_small
                          ELSE icon_message_information_small )
      icon_text = COND #( WHEN lines( message_log->get_messages( ) ) > 0 THEN 'Message Log'(t63) && | ({ lines( message_log->get_messages( ) ) })|
                          ELSE 'Message Log'(t63) )
      quickinfo = 'Show Message Log'(t64) ).
  ENDMETHOD.

  METHOD on_go_back.
    lcl_gui_handler=>reload_start_screen( ).
  ENDMETHOD.

  METHOD on_call_history.
    search_control->call_history_popup( ).
  ENDMETHOD.

  METHOD on_table_selected.
    lcl_control=>update_content( i_tabname = tabname i_langu = language ).

    CASE tabclass.
      WHEN lcl_ddic_table=>enum_tabclass-transparent.
        mv_title_additions = 'DB Table'.
      WHEN lcl_ddic_table=>enum_tabclass-pool.
        mv_title_additions = 'Pool Table'.
      WHEN lcl_ddic_table=>enum_tabclass-cluster.
        mv_title_additions = 'Cluster Table'.
      WHEN lcl_ddic_table=>enum_tabclass-view.
        mv_title_additions = 'View'.
      WHEN lcl_ddic_table=>enum_tabclass-structure.
        mv_title_additions = 'Structure'.
      WHEN lcl_ddic_table=>enum_tabclass-append.
        mv_title_additions = 'Append'.
    ENDCASE.

    mv_title_additions = mv_title_additions && | { tabname } ({ lcl_language_convert=>get_language_output( language ) })|.

    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ). " triggers PAI
  ENDMETHOD.

  METHOD on_items_deleted.
    CLEAR mv_title_additions.

    lcl_control=>clear_content( selected_items ).
    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ). " triggers PAI
  ENDMETHOD.

  METHOD on_all_items_deleted.
    CLEAR mv_title_additions.

    lcl_control=>clear_content(  ).
    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ). " triggers PAI
  ENDMETHOD.

  METHOD on_popup_close.
    IF sender IS NOT INITIAL.
      READ TABLE mt_popup_pos ASSIGNING FIELD-SYMBOL(<popup_pos>) WITH KEY container = sender.
      IF ( sy-subrc = 0 ).
        CLEAR <popup_pos>-container.
      ENDIF.

      sender->free( ).
    ENDIF.
  ENDMETHOD.

  METHOD on_data_element_selected.
    DATA:
      splitter          TYPE REF TO cl_gui_splitter_container,
      header_table      TYPE lcl_alv_dynamic_tools=>type_output_simple_tab,
      column_table      TYPE REF TO cl_salv_column_table,
      ddic_data_element TYPE REF TO lcl_ddic_data_element,
      visible           TYPE abap_bool.

    TRY.
        ddic_data_element = lcl_ddic_data_element=>create_instance(
          i_rollname = rollname
          i_langu    = language ).
      CATCH cx_sy_ref_is_initial INTO DATA(error).
        message_log->add_exception(
          i_error  = error
          i_method = 'LCL_DDIC_DATA_ELEMENT=>CREATE_INSTANCE'
          i_object = rollname ).

        RETURN.
    ENDTRY.

    DATA(data_element_header)  = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = language
      i_structure = ddic_data_element->get_header( ) ).

    SORT mt_popup_pos BY posx posy.
    LOOP AT mt_popup_pos ASSIGNING FIELD-SYMBOL(<popup_pos>).
      IF ( <popup_pos>-container IS INITIAL ).  " Position is applied from the first found deleted popup
        EXIT.
      ENDIF.
    ENDLOOP.

    IF ( <popup_pos> IS NOT ASSIGNED ).
      APPEND INITIAL LINE TO mt_popup_pos ASSIGNING <popup_pos>.
      <popup_pos>-posx = 120.
      <popup_pos>-posy = 120.
    ELSEIF ( <popup_pos>-container IS NOT INITIAL ).  " Last popup
      DATA(posx) = <popup_pos>-posx.
      DATA(posy) = <popup_pos>-posy.

      APPEND INITIAL LINE TO mt_popup_pos ASSIGNING <popup_pos>.
      <popup_pos>-posx = posx + 30.
      <popup_pos>-posy = posy + 30.
    ENDIF.

    DATA(style) = cl_gui_control=>ws_minimizebox + cl_gui_control=>ws_maximizebox + cl_gui_control=>ws_sysmenu.
    DATA(row_height) = lines( data_element_header ) * 30.

    <popup_pos>-container = NEW #( parent = cl_gui_container=>default_screen
      caption = 'Data Element'(t65) && | { rollname }|
      top    = <popup_pos>-posy
      left   = <popup_pos>-posx
      width  = lcl_control_metric=>get_screen_x( ) / '3.5'
      height = lcl_control_metric=>get_screen_y( ) / '1.5'
      style  = style
      metric = cl_gui_dialogbox_container=>metric_pixel
      no_autodef_progid_dynnr = abap_true
    ).

    SET HANDLER on_popup_close FOR <popup_pos>-container.

    splitter = NEW #(
      parent  = <popup_pos>-container
      rows    = 1
      columns = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).
    splitter->set_row_height( id = 1 height = row_height ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 1 column = 1 )
          IMPORTING r_salv_table = DATA(salv_header)
          CHANGING  t_table      = data_element_header ).
      CATCH cx_salv_msg INTO DATA(salv_error).
        message_log->add_exception( i_error = salv_error i_method = 'LCL_TABLE_VIEW->ON_DATA_ELEMENT_SELECTED' ).
        RETURN.
    ENDTRY.

    lcl_alv_dynamic_tools=>set_output_simple_columns(
      i_columns_table = salv_header->get_columns( )
      i_optimize      = abap_true ).

    salv_header->get_functions( )->set_all( abap_false ).
    salv_header->get_display_settings( )->set_striped_pattern( abap_true ).
    salv_header->display( ).

    cl_gui_container=>set_focus( <popup_pos>-container ).
  ENDMETHOD.

  METHOD on_domain_selected.
    DATA:
      splitter     TYPE REF TO cl_gui_splitter_container,
      header_table TYPE lcl_alv_dynamic_tools=>type_output_simple_tab,
      column_table TYPE REF TO cl_salv_column_table,
      ddic_domain  TYPE REF TO lcl_ddic_domain,
      visible      TYPE abap_bool.

    TRY.
        ddic_domain = lcl_ddic_domain=>create_instance(
          i_domname = domname
          i_langu   = language ).
      CATCH cx_sy_ref_is_initial INTO DATA(error).
        message_log->add_exception(
          i_error  = error
          i_method = 'LCL_DDIC_DOMAIN=>CREATE_INSTANCE'
          i_object = domname ).

        RETURN.
    ENDTRY.

    DATA(domain_header)  = lcl_alv_dynamic_tools=>get_structure_fields_for(
      i_language  = language
      i_structure = ddic_domain->get_header( ) ).

    DATA(domain_values)  = ddic_domain->get_values( ).

    SORT mt_popup_pos BY posx posy.
    LOOP AT mt_popup_pos ASSIGNING FIELD-SYMBOL(<popup_pos>).
      IF ( <popup_pos>-container IS INITIAL ).  " Position is applied from the first found deleted popup
        EXIT.
      ENDIF.
    ENDLOOP.

    IF ( <popup_pos> IS NOT ASSIGNED ).
      " Start position
      APPEND INITIAL LINE TO mt_popup_pos ASSIGNING <popup_pos>.
      <popup_pos>-posx = 120.
      <popup_pos>-posy = 120.
    ELSEIF ( <popup_pos>-container IS NOT INITIAL ).
      " Shift position
      DATA(posx) = <popup_pos>-posx.
      DATA(posy) = <popup_pos>-posy.

      APPEND INITIAL LINE TO mt_popup_pos ASSIGNING <popup_pos>.
      <popup_pos>-posx = posx + 30.
      <popup_pos>-posy = posy + 30.
    ENDIF.

    DATA(style)      = cl_gui_control=>ws_minimizebox + cl_gui_control=>ws_maximizebox + cl_gui_control=>ws_sysmenu.
    DATA(row_height) = lines( domain_header ) * lcl_control_metric=>get_line_height( ).

    <popup_pos>-container = NEW #( parent = cl_gui_container=>default_screen
      caption = 'Domain'(t66) && | { domname }|
      top    = <popup_pos>-posy
      left   = <popup_pos>-posx
      width  = lcl_control_metric=>get_screen_x( ) / '3.5'
      height = lcl_control_metric=>get_screen_y( ) / '1.5'
      style  = style
      metric = cl_gui_dialogbox_container=>metric_pixel
      no_autodef_progid_dynnr = abap_true
    ).

    SET HANDLER on_popup_close FOR <popup_pos>-container.

    DATA(splitter_rows) = COND i( WHEN domain_values IS NOT INITIAL THEN 2 ELSE 1 ).
    splitter = NEW #(
      parent  = <popup_pos>-container
      rows    = splitter_rows
      columns = 1
      no_autodef_progid_dynnr = abap_true ).

    splitter->set_row_mode( mode = cl_gui_splitter_container=>mode_absolute ).
    splitter->set_row_height( id = 1 height = row_height ).

    TRY.
        cl_salv_table=>factory(
          EXPORTING r_container  = splitter->get_container( row = 1 column = 1 )
          IMPORTING r_salv_table = DATA(salv_header)
          CHANGING  t_table      = domain_header ).
      CATCH cx_salv_msg INTO DATA(salv_error).
        message_log->add_exception( i_error = salv_error i_method = 'LCL_TABLE_VIEW->ON_DOMAIN_SELECTED' ).
        RETURN.
    ENDTRY.

    lcl_alv_dynamic_tools=>set_output_simple_columns(
      i_columns_table = salv_header->get_columns( )
      i_optimize      = abap_true ).

    salv_header->get_functions( )->set_all( abap_false ).
    salv_header->get_display_settings( )->set_striped_pattern( abap_true ).
    salv_header->display( ).

    IF ( domain_values IS NOT INITIAL ).
      TRY.
          cl_salv_table=>factory(
            EXPORTING r_container  = splitter->get_container( row = 2 column = 1 )
            IMPORTING r_salv_table = DATA(salv_values)
            CHANGING  t_table      = domain_values ).
        CATCH cx_salv_msg INTO salv_error.
          message_log->add_exception( i_error = salv_error i_method = 'LCL_TABLE_VIEW->ON_DOMAIN_SELECTED' ).
          RETURN.
      ENDTRY.

      DATA(columns_table) = salv_values->get_columns( ).
      DATA(columns)       = columns_table->get( ).
      LOOP AT columns INTO DATA(column).
        column_table ?= column-r_column.
        column_table->set_key( if_salv_c_bool_sap=>false ).
        column-r_column->set_fixed_header_text( 'S' ).

        visible = lcl_alv_dynamic_tools=>check_table_field_empty(
          i_column_name = column-columnname
          i_table       = domain_values ).

        column-r_column->set_visible( visible ).
      ENDLOOP.

      salv_values->get_functions( )->set_all( abap_false ).
      salv_values->get_display_settings( )->set_striped_pattern( abap_true ).
      salv_values->get_columns( )->set_optimize( ).
      salv_values->display( ).
    ENDIF.

    cl_gui_container=>set_focus( <popup_pos>-container ).
  ENDMETHOD.

  METHOD on_tabname_selected.
    search_control->add_items_to_alv( VALUE #( ( tabname = tabname ddlanguage = language ) ) ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_app DEFINITION ABSTRACT FRIENDS lcl_gui_handler.
  PROTECTED SECTION.
    METHODS:
      get_appid ABSTRACT RETURNING VALUE(r_appid) TYPE lcl_gui_handler=>type_appid.

    DATA:
      mo_view TYPE REF TO lcl_view_base.
ENDCLASS.

CLASS lcl_start_app DEFINITION INHERITING FROM lcl_app.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    METHODS:
      get_appid REDEFINITION.
ENDCLASS.

CLASS lcl_start_app IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mo_view = NEW lcl_start_view( i_langu ).
  ENDMETHOD.

  METHOD get_appid.
    r_appid = lcl_gui_handler=>enum_appid-start.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_table_app DEFINITION INHERITING FROM lcl_app.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING i_langu TYPE sy-langu.

  PROTECTED SECTION.
    METHODS:
      get_appid REDEFINITION.
ENDCLASS.

CLASS lcl_table_app IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mo_view = NEW lcl_table_view( i_langu ).
  ENDMETHOD.

  METHOD get_appid.
    r_appid = lcl_gui_handler=>enum_appid-ddic_explorer.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_gui_handler IMPLEMENTATION.
  METHOD on_initialization.
    IF ( initialized = abap_true ).
      RETURN.
    ENDIF.

    set_labels( ).
    set_input_data( ).
    create_message_log( ).
    check_system( ).

    initialized = abap_true.
  ENDMETHOD.

  METHOD check_system.
    DATA system_category TYPE t000-cccategory.
    CALL FUNCTION 'TR_SYS_PARAMS'
      IMPORTING
        system_client_role = system_category
      EXCEPTIONS
        OTHERS             = 1.
    IF ( sy-subrc = 0 ).
      IF ( system_category = 'P' ).
        message_log->add_message_text(
          i_msgtyp  = 'E'
          i_text    = 'CRITICAL SECURITY: Advanced DDIC Explorer PRO is restricted to DEV and Sandbox environments only.'(m11) ).

        message_log->display( ).
        LEAVE PROGRAM.
      ENDIF.
    ENDIF.

    IF ( sy-subrc <> 0 OR system_category IS INITIAL ).
      DATA ret TYPE c LENGTH 1.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Unknown system detected'(t01)
          text_question         = 'Do you want to continue anyway?'(t02)
          default_button        = '2'
          display_cancel_button = abap_true
        IMPORTING
          answer                = ret.
      CASE ret.
        WHEN '1'.
          message_log->add_message_text(
            i_msgtyp  = 'W'
            i_text    = 'CRITICAL SECURITY: Unknown system. User continues the program execution'(m12) ).
        WHEN '2' OR 'A'.
          message_log->add_message_text(
            i_msgtyp  = 'E'
            i_text    = 'CRITICAL SECURITY: Unknown system. Programm execution aborted.'(m13) ).

          message_log->display( ). LEAVE PROGRAM.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

  METHOD on_at_output.
    CLEAR:
      sscrfields-functxt_01, sscrfields-functxt_02, sscrfields-functxt_03, sscrfields-functxt_04, sscrfields-functxt_05.

    IF ( sy-slset IS NOT INITIAL ).
      program_variant = sy-slset.
    ENDIF.

    LOOP AT SCREEN INTO DATA(ls_screen).
      IF ( ls_screen-group1 = 'COM' ).
        ls_screen-input = '0'.
        MODIFY SCREEN FROM ls_screen.
      ENDIF.
    ENDLOOP.

    RAISE EVENT at_output.
  ENDMETHOD.

  METHOD on_at_input.
    CASE sscrfields-ucomm.
      WHEN 'CRET'.
        lcl_input_fields=>tabname_range = so_table[].

        create_message_log( ).
        start_app( lcl_gui_handler=>enum_appid-ddic_explorer ).
        CALL SELECTION-SCREEN '1002'.
      WHEN 'FC05'.
        message_log->display( ).
      WHEN OTHERS.
        RAISE EVENT at_input EXPORTING ucomm = sscrfields-ucomm.
    ENDCASE.
  ENDMETHOD.

  METHOD on_at_exit.
    IF ( sscrfields-ucomm = 'CBAC' OR sscrfields-ucomm = 'CEND' OR sscrfields-ucomm = 'CCAN' ).
      RAISE EVENT at_exit EXPORTING ucomm = sscrfields-ucomm.
    ENDIF.
  ENDMETHOD.

  METHOD on_start.
    IF ( sy-batch = abap_true ).
      RETURN.
    ENDIF.

    start_app( enum_appid-start ).

    cl_abap_list_layout=>suppress_toolbar( ).
    CALL SELECTION-SCREEN '1001'.
  ENDMETHOD.

  METHOD set_labels.
    lappdata = 'Application Data'(l02).
    llangu   = 'Default Language'(l09).
    lmaxhit  = 'Maximal No. of Hits'(l10).
    llineh   = 'Display Line Height'(l38).
    lcheck   = 'Check Tables automatically'(l41).
    ldelmem  = 'Delete History List'(l40).
    ltcode   = 'Access to Standard TCodes'(l11).
    lse11    = 'SE11'(l12).
    lse16    = 'SE16'(l13).
    lse16n   = 'SE16N'(l14).
    lse16h   = 'SE16H'(l15).
    lbal     = 'Application Log (SLG0)'(l16).
    lbalobj  = 'Object'(l17).
    lbalsub  = 'Subobject'(l18).
    lbalext  = 'Ext. Text'(l19).
    ltable   = 'Table Name (optional)'(l39).
    lfdef    = 'Filter Defaults'(l20).
    ltcat    = 'Dropdown Object Categories'(l21).
    ltdb     = 'Database Table'(l22).
    ltview   = 'View'(l23).
    ltpool   = 'Pool Table'(l24).
    ltclust  = 'Cluster Table'(l25).
    ltstruct = 'Structure'(l26).
    ltappend = 'Append-Structure'(l27).
    ltdel    = 'Dropdown Table Delivery Class'(l28).
    ldappl   = 'Application Table'(l29).
    ldcust   = 'Custom Table'(l30).
    ldctrl   = 'Control Table'(l31).
    ldsyst   = 'System Table'(l32).
    lvtyp    = 'Dropdown View Types'(l33).
    lvtdbv   = 'Database View'(l34).
    lvtprv   = 'Projection View'(l35).
    lvtmntv  = 'Maintenance View'(l36).
    lvthlpv  = 'Help View'(l37).
  ENDMETHOD.

  METHOD set_input_data.
    GET REFERENCE OF p_langu  INTO lcl_input_fields=>language.
    GET REFERENCE OF p_maxhit INTO lcl_input_fields=>max_hits.
    GET REFERENCE OF p_lineh  INTO lcl_input_fields=>line_height.
    GET REFERENCE OF p_delmem INTO lcl_input_fields=>delete_history.
    GET REFERENCE OF p_check  INTO lcl_input_fields=>check_tables.
    GET REFERENCE OF p_balobj INTO lcl_input_fields=>bal_object.
    GET REFERENCE OF p_balsub INTO lcl_input_fields=>bal_sub_object.
    GET REFERENCE OF p_balext INTO lcl_input_fields=>bal_ext_text.
    GET REFERENCE OF p_se11   INTO lcl_input_fields=>access_se11.
    GET REFERENCE OF p_se16   INTO lcl_input_fields=>access_se16.
    GET REFERENCE OF p_se16n  INTO lcl_input_fields=>access_se16n.
    GET REFERENCE OF p_se16h  INTO lcl_input_fields=>access_se16h.
    GET REFERENCE OF p_db     INTO lcl_input_fields=>object_cat_dbtable.
    GET REFERENCE OF p_view   INTO lcl_input_fields=>object_cat_view.
    GET REFERENCE OF p_pool   INTO lcl_input_fields=>object_cat_pool.
    GET REFERENCE OF p_clust  INTO lcl_input_fields=>object_cat_cluster.
    GET REFERENCE OF p_struct INTO lcl_input_fields=>object_cat_struct.
    GET REFERENCE OF p_append INTO lcl_input_fields=>object_cat_append.
    GET REFERENCE OF p_appl   INTO lcl_input_fields=>table_deliv_appl.
    GET REFERENCE OF p_cust   INTO lcl_input_fields=>table_deliv_cust.
    GET REFERENCE OF p_ctrl   INTO lcl_input_fields=>table_deliv_ctrl.
    GET REFERENCE OF p_syst   INTO lcl_input_fields=>table_deliv_syst.
    GET REFERENCE OF p_dbv    INTO lcl_input_fields=>view_type_db.
    GET REFERENCE OF p_prv    INTO lcl_input_fields=>view_type_proj.
    GET REFERENCE OF p_mntv   INTO lcl_input_fields=>view_type_maint.
    GET REFERENCE OF p_hlpv   INTO lcl_input_fields=>view_type_help.
  ENDMETHOD.

  METHOD create_message_log.
    IF ( lcl_input_fields=>bal_object->* IS INITIAL ).
      message_log = lcl_message_log=>create( ).
    ELSE.
      message_log = lcl_message_log=>create(
        i_object    = lcl_input_fields=>bal_object->*
        i_subobject = lcl_input_fields=>bal_sub_object->*
        i_extnumber = lcl_input_fields=>bal_ext_text->* ).
    ENDIF.
  ENDMETHOD.

  METHOD get_program_variant.
    r_variant = program_variant.
  ENDMETHOD.

  METHOD reload_start_screen.
    IF ( program_variant IS NOT INITIAL ).
      SUBMIT (sy-repid)
        USING SELECTION-SET program_variant.
    ELSE.
      SUBMIT (sy-repid)
        WITH p_langu   = lcl_input_fields=>language->*
        WITH so_table IN lcl_input_fields=>tabname_range
        WITH p_maxhit  = lcl_input_fields=>max_hits->*
        WITH p_lineh   = lcl_input_fields=>line_height->*
        WITH p_check   = lcl_input_fields=>check_tables->*
        WITH p_delmem  = lcl_input_fields=>delete_history->*
        WITH p_balobj  = lcl_input_fields=>bal_object->*
        WITH p_balsub  = lcl_input_fields=>bal_sub_object->*
        WITH p_balext  = lcl_input_fields=>bal_ext_text->*
        WITH p_se11    = lcl_input_fields=>access_se11->*
        WITH p_se16    = lcl_input_fields=>access_se16->*
        WITH p_se16n   = lcl_input_fields=>access_se16n->*
        WITH p_se16h   = lcl_input_fields=>access_se16h->*
        WITH p_db      = lcl_input_fields=>object_cat_dbtable->*
        WITH p_view    = lcl_input_fields=>object_cat_view->*
        WITH p_pool    = lcl_input_fields=>object_cat_pool->*
        WITH p_clust   = lcl_input_fields=>object_cat_cluster->*
        WITH p_struct  = lcl_input_fields=>object_cat_struct->*
        WITH p_append  = lcl_input_fields=>object_cat_append->*
        WITH p_appl    = lcl_input_fields=>table_deliv_appl->*
        WITH p_cust    = lcl_input_fields=>table_deliv_cust->*
        WITH p_ctrl    = lcl_input_fields=>table_deliv_ctrl->*
        WITH p_syst    = lcl_input_fields=>table_deliv_syst->*
        WITH p_dbv     = lcl_input_fields=>view_type_db->*
        WITH p_prv     = lcl_input_fields=>view_type_proj->*
        WITH p_mntv    = lcl_input_fields=>view_type_maint->*
        WITH p_hlpv    = lcl_input_fields=>view_type_help->*.
    ENDIF.
  ENDMETHOD.

  METHOD start_app.
    RAISE EVENT close_application.

    CASE i_appid.
      WHEN enum_appid-start.
        app = NEW lcl_start_app( lcl_input_fields=>language->* ).
      WHEN enum_appid-ddic_explorer.
        app = NEW lcl_table_app( lcl_input_fields=>language->* ).
      WHEN OTHERS.
        RETURN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
