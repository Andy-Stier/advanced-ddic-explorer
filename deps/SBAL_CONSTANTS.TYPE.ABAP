***INCLUDE SBAL_CONSTANTS .


* user commands
CONSTANTS:
  const_ucomm_%ext_push1     LIKE sy-ucomm VALUE '%EXT_PUSH1',
  const_ucomm_%ext_push2     LIKE sy-ucomm VALUE '%EXT_PUSH2',
  const_ucomm_%ext_push3     LIKE sy-ucomm VALUE '%EXT_PUSH3',
  const_ucomm_%ext_push4     LIKE sy-ucomm VALUE '%EXT_PUSH4',
  const_ucomm_%help_bal      LIKE sy-ucomm VALUE '%HELP_BAL',
  const_ucomm_%longtext      LIKE sy-ucomm VALUE '%LONGTEXT',
  const_ucomm_%techdet       LIKE sy-ucomm VALUE '%TECHDET',
  const_ucomm_%detail        LIKE sy-ucomm VALUE '%DETAIL',
  const_ucomm_%dock_left     LIKE sy-ucomm VALUE '%DOCK_LEFT',
  const_ucomm_%dock_top      LIKE sy-ucomm VALUE '%DOCK_TOP',
  const_ucomm_cont           LIKE sy-ucomm VALUE '&ONT',
  const_ucomm_f03            LIKE sy-ucomm VALUE '&F03',
  const_ucomm_f15            LIKE sy-ucomm VALUE '&F15',
  const_ucomm_f12            LIKE sy-ucomm VALUE '&F12',
  const_ucomm_list_click     LIKE sy-ucomm VALUE '&IC1',
  const_ucomm_sel_msgty_a    LIKE sy-ucomm VALUE '%SEL_A',
  const_ucomm_sel_msgty_e    LIKE sy-ucomm VALUE '%SEL_E',
  const_ucomm_sel_msgty_w    LIKE sy-ucomm VALUE '%SEL_W',
  const_ucomm_sel_msgty_othr LIKE sy-ucomm VALUE '%SEL_OTHR',
  const_ucomm_external       LIKE sy-ucomm VALUE 'EXTERNAL',
  const_ucomm_%debug         LIKE sy-ucomm VALUE '%DEBUG'.

* problem class
CONSTANTS:
  probclass_very_high TYPE bal_s_msg-probclass VALUE '1',
  probclass_high      TYPE bal_s_msg-probclass VALUE '2',
  probclass_medium    TYPE bal_s_msg-probclass VALUE '3',
  probclass_low       TYPE bal_s_msg-probclass VALUE '4',
  probclass_none      TYPE bal_s_msg-probclass VALUE ' '.

* message types
CONSTANTS:
  msgty_x             TYPE sy-msgty            VALUE 'X',
  msgty_a             TYPE sy-msgty            VALUE 'A',
  msgty_e             TYPE sy-msgty            VALUE 'E',
  msgty_w             TYPE sy-msgty            VALUE 'W',
  msgty_i             TYPE sy-msgty            VALUE 'I',
  msgty_s             TYPE sy-msgty            VALUE 'S',
  msgty_none          TYPE sy-msgty            VALUE ' '.

* colors
CONSTANTS:
  const_color_code_1  TYPE balcolcode      VALUE '1',
  const_color_code_2  TYPE balcolcode      VALUE '2',
  const_color_code_3  TYPE balcolcode      VALUE '3',
  const_color_code_4  TYPE balcolcode      VALUE '4',
  const_color_code_5  TYPE balcolcode      VALUE '5',
  const_color_code_6  TYPE balcolcode      VALUE '6',
  const_color_code_7  TYPE balcolcode      VALUE '7'.

CONSTANTS:
  const_color_c11     TYPE balcolor        VALUE 'C11',
  const_color_c21     TYPE balcolor        VALUE 'C21',
  const_color_c31     TYPE balcolor        VALUE 'C31',
  const_color_c40     TYPE balcolor        VALUE 'C40',
  const_color_c50     TYPE balcolor        VALUE 'C50',
  const_color_c60     TYPE balcolor        VALUE 'C60',
  const_color_c71     TYPE balcolor        VALUE 'C71'.

* position of external pushbuttons
CONSTANTS:
  const_push_pos_menu       TYPE balpushpos   VALUE ' ',
  const_push_pos_tree_left  TYPE balpushpos   VALUE '1',
  const_push_pos_tree_right TYPE balpushpos   VALUE '2',
  const_push_pos_list_left  TYPE balpushpos   VALUE '3',
  const_push_pos_list_right TYPE balpushpos   VALUE '4'.

* types of callback routines
CONSTANTS:
  const_callback_form     TYPE baluet          VALUE ' ',
  const_callback_function TYPE baluet          VALUE 'F'.

* parameters for CALLBACK_DETAIL_MSG and CALLBACK_DETAIL_LOG
CONSTANTS:
  bal_param_msgv1         TYPE spar-param   VALUE 'V1',
  bal_param_msgv2         TYPE spar-param   VALUE 'V2',
  bal_param_msgv3         TYPE spar-param   VALUE 'V3',
  bal_param_msgv4         TYPE spar-param   VALUE 'V4',
  bal_param_lognumber     TYPE spar-param   VALUE '%LOGNUMBER'.

* some internal technical constants
CONSTANTS:
  const_bal_msgs_on_db_arc TYPE c                 VALUE 'A',
  const_bal_memory_id      TYPE indx-srtfd        VALUE 'SAPLSBAL',
  const_bal_2TH_CONNECTION(30) TYPE C             VALUE 'R/3*SAP_2TH_CONNECT_APPL_LOG',
  const_bal_msgnumber_max  TYPE BALMNR            value '999999',
  const_bal_max_convert    TYPE i                 VALUE 50,
  const_bal_db_ver_current TYPE balhdr-db_version VALUE '0001',
  const_bal_db_ver_balm    TYPE balhdr-db_version VALUE '    ',
  const_bal_header_block   TYPE balmnr            VALUE '000000',
  const_bal_block_size     TYPE i                 VALUE 150,
  const_bal_deletion_size  TYPE i                 VALUE 100,
  const_bal_name_root(30)  TYPE c                 VALUE 'ROOT',
  const_context_len1       TYPE i                 VALUE 64,
  const_context_len2       TYPE i                 VALUE 128,
  const_context_len_max    TYPE i                 VALUE 256,
  const_params_len1        TYPE i                 value 20,
  const_msgv_len1          TYPE i                 value 20,
  const_statistics_len     TYPE i                 VALUE 60,
  const_batch              TYPE balmode           VALUE 'B',
  const_batch_input        TYPE balmode           VALUE 'I',
  const_dialog             TYPE balmode           VALUE 'D',
  const_hex02              TYPE x                 VALUE '02',
  const_never              TYPE sydatum           VALUE '99991231',
  const_end_of_day         TYPE syuzeit           VALUE '235959',
  const_freetext_msgid     TYPE symsgid           VALUE 'BL',
  const_freetext_msgno     TYPE symsgno           VALUE '001',
  const_exception_msgno    TYPE symsgno           VALUE '003',
  const_exc_indicator(3)   TYPE c                 VALUE '%_E',
  const_temp_indicator     TYPE c                 VALUE '$',
  const_funcname_modify    TYPE tfdir-funcname    VALUE 'ECATT_MODIFY_BALMSG',
  const_funcname_save      TYPE tfdir-funcname    VALUE 'ECATT_SAVE_BALMSG',
  const_size_category_no   TYPE n                 VALUE '0',
  const_size_category_1    TYPE n                 VALUE '1',
  const_size_category_2    TYPE n                 VALUE '2',
  const_size_category_3    TYPE n                 VALUE '3',
  const_size_category_err  TYPE n                 VALUE '9',
  const_number_range_obj   TYPE inri-object       VALUE 'APPL_LOG',
  const_number_range_int   TYPE inri-nrrangenr    VALUE '01',
  const_callback_delete    TYPE rs38l_fnam        VALUE 'BAL_DBDEL_',
  const_docu_id_msg        TYPE dokhl-id          VALUE 'NA',
  const_docu_id_dialog     TYPE dokhl-id          VALUE 'DT',
  const_msgnumber_0        TYPE balmnr            VALUE '000000',
  const_alv_selmode_multi  TYPE c                 VALUE 'A',
  const_alv_selmode_sngle  TYPE c                 VALUE ' ',
  const_tree_max_nodes     TYPE i                 VALUE 500,
  const_slash(1)           type c                 value '/'.
