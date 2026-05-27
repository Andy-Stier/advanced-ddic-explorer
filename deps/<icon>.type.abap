* Icon length 2
DEFINE ICON_2.
CONSTANTS:   &1 TYPE ICON_L2 VALUE  &2.
END-OF-DEFINITION.

* Icon length 4
DEFINE ICON_4.
CONSTANTS:   &1 TYPE ICON_L4 VALUE  &2.
END-OF-DEFINITION.


DEFINE ICON_PREPARE_FOR_MODIFY.
* trunkate ICON_ID, e.g.  '@3M@' --> '3M'
  TRANSLATE &1 USING '@ '.
  CONDENSE  &1 NO-GAPS.
END-OF-DEFINITION.

*
*                     DEFINITION OF ICONS
*
*Icon_Length                           ID
*      Name                                     Quickinfo
ICON_2 ICON_DUMMY                     '@00@'."  Placeholder icon
ICON_2 ICON_CHECKED                   '@01@'."  Checked; Okay
ICON_2 ICON_INCOMPLETE                '@02@'."  Incomplete; Critical
ICON_2 ICON_FAILURE                   '@03@'."  Failure
ICON_2 ICON_POSITIVE                  '@04@'."  Positive; Good
ICON_2 ICON_NEGATIVE                  '@05@'."  Negative; Bad
ICON_2 ICON_LOCKED                    '@06@'."  Locked
ICON_2 ICON_UNLOCKED                  '@07@'."  Unlocked
ICON_4 ICON_GREEN_LIGHT               '@08@'."  Green light; Go; OK
ICON_4 ICON_YELLOW_LIGHT              '@09@'."  Yellow light; Caution
ICON_4 ICON_RED_LIGHT                 '@0A@'."  Red light; Negative
ICON_2 ICON_TOTAL_LEFT                '@0B@'."  Move to far left; First...
ICON_2 ICON_TOTAL_RIGHT               '@0C@'."  Move to far right; Last...
ICON_2 ICON_COLUMN_LEFT               '@0D@'."  One column to left; Previous...
ICON_2 ICON_COLUMN_RIGHT              '@0E@'."  One column to right; Next...
ICON_2 ICON_PAGE_RIGHT                '@0F@'."  Page right
ICON_2 ICON_PAGE_LEFT                 '@0G@'."  Page left
ICON_2 ICON_PREVIOUS_VALUE            '@0H@'."  Previous value; Next entry
ICON_2 ICON_NEXT_VALUE                '@0I@'."  Next value; Previous entry
ICON_2 ICON_ANNOTATION                '@0J@'."  Note; Change note
ICON_2 ICON_CREATE_NOTE               '@0K@'."  Create note
ICON_2 ICON_DISPLAY_NOTE              '@0L@'."  Display note
ICON_2 ICON_CALCULATION               '@0M@'."  Calculate
ICON_2 ICON_GRAPHICS                  '@0N@'."  Graphic
ICON_2 ICON_CREATE_TEXT               '@0O@'."  Create text
ICON_2 ICON_DISPLAY_TEXT              '@0P@'."  Display text
ICON_2 ICON_CHANGE_TEXT               '@0Q@'."  Change text; Long text
ICON_2 ICON_VARIANTS                  '@0R@'."  Variants
ICON_2 ICON_INFORMATION               '@0S@'."  Information
ICON_2 ICON_ADDRESS                   '@0T@'."  Address
ICON_2 ICON_VIEWER_OPTICAL_ARCHIVE    '@0U@'."  Optical archive viewer
ICON_2 ICON_OKAY                      '@0V@'."  OK; Continue; Choose Value
ICON_2 ICON_CANCEL                    '@0W@'."  Cancel
ICON_2 ICON_PRINT                     '@0X@'."  Print
ICON_2 ICON_CREATE                    '@0Y@'."  Create
ICON_2 ICON_CHANGE                    '@0Z@'."  Change
ICON_2 ICON_DISPLAY                   '@10@'."  Display
ICON_2 ICON_DELETE                    '@11@'."  Delete
ICON_2 ICON_TEST                      '@12@'."  Test
ICON_2 ICON_SEARCH                    '@13@'."  Find
ICON_2 ICON_COPY_OBJECT               '@14@'."  Copy Object
ICON_2 ICON_EXECUTE_OBJECT            '@15@'."  Execute Object
ICON_2 ICON_SELECT_DETAIL             '@16@'."  Choose Object's Details
ICON_2 ICON_INSERT_ROW                '@17@'."  Insert row
ICON_2 ICON_DELETE_ROW                '@18@'."  Delete row
ICON_4 ICON_MESSAGE_INFORMATION       '@19@'."  Information message
ICON_4 ICON_MESSAGE_WARNING           '@1A@'."  Warning
ICON_4 ICON_MESSAGE_ERROR             '@1B@'."  Error message
ICON_4 ICON_MESSAGE_QUESTION          '@1C@'."  Question
ICON_4 ICON_MESSAGE_CRITICAL          '@1D@'."  Critical message
ICON_2 ICON_DISPLAY_MORE              '@1E@'."  Multiple selection (active)
ICON_2 ICON_ENTER_MORE                '@1F@'."  Multiple selection
ICON_2 ICON_EQUAL                     '@1G@'."  Equal to
ICON_2 ICON_NOT_EQUAL                 '@1H@'."  Not equal to
ICON_2 ICON_GREATER                   '@1I@'."  Greater than
ICON_2 ICON_LESS                      '@1J@'."  Less than
ICON_2 ICON_GREATER_EQUAL             '@1K@'."  Greater than or equal to
ICON_2 ICON_LESS_EQUAL                '@1L@'."  Less than or equal to
ICON_2 ICON_INTERVAL_INCLUDE          '@1M@'."  Include interval
ICON_2 ICON_INTERVAL_EXCLUDE          '@1N@'."  Exclude interval
ICON_2 ICON_PATTERN_INCLUDE           '@1O@'."  Include pattern
ICON_2 ICON_PATTERN_EXCLUDE           '@1P@'."  Exclude pattern
ICON_2 ICON_PHONE                     '@1Q@'."  Telephone number
ICON_2 ICON_FAX                       '@1R@'."  Fax number
ICON_2 ICON_MAIL                      '@1S@'."  Send message; Mail
ICON_2 ICON_TIME                      '@1T@'."  Time of day
ICON_2 ICON_DATE                      '@1U@'."  Date
ICON_2 ICON_ALARM                     '@1V@'."  Alarm
ICON_2 ICON_PROSHARE                  '@1W@'."  Activate ProShare
ICON_2 ICON_VIDEO                     '@1X@'."  Video
ICON_2 ICON_VOICE_INPUT               '@1Y@'."  Voice input
ICON_2 ICON_VOICE_OUTPUT              '@1Z@'."  Voice output
ICON_2 ICON_EQUAL_GREEN               '@20@'."  Select: Equal to
ICON_2 ICON_NOT_EQUAL_GREEN           '@21@'."  Select: Not equal to
ICON_2 ICON_GREATER_GREEN             '@22@'."  Select: Greater than
ICON_2 ICON_LESS_GREEN                '@23@'."  Select: Less than
ICON_2 ICON_GREATER_EQUAL_GREEN       '@24@'."  Select: Greater than or equal t
ICON_2 ICON_LESS_EQUAL_GREEN          '@25@'."  Select: Less than or equal to
ICON_2 ICON_INTERVAL_INCLUDE_GREEN    '@26@'."  Select: Include interval
ICON_2 ICON_INTERVAL_EXCLUDE_GREEN    '@27@'."  Select: Exclude interval
ICON_2 ICON_PATTERN_INCLUDE_GREEN     '@28@'."  Select: Include pattern
ICON_2 ICON_PATTERN_EXCLUDE_GREEN     '@29@'."  Select: Exclude pattern
ICON_2 ICON_EQUAL_RED                 '@2A@'."  Do not select: Equal to
ICON_2 ICON_NOT_EQUAL_RED             '@2B@'."  Do not select: Not equal to
ICON_2 ICON_GREATER_RED               '@2C@'."  Do not select: Greater than
ICON_2 ICON_LESS_RED                  '@2D@'."  Do not select: Less than
ICON_2 ICON_GREATER_EQUAL_RED         '@2E@'."  Do not select: Greater than/equ
ICON_2 ICON_LESS_EQUAL_RED            '@2F@'."  Do not select: Less than/equal
ICON_2 ICON_INTERVAL_INCLUDE_RED      '@2G@'."  Do not select: Include interval
ICON_2 ICON_INTERVAL_EXCLUDE_RED      '@2H@'."  Do not select: Exclude interval
ICON_2 ICON_PATTERN_INCLUDE_RED       '@2I@'."  Do not select: Include sample
ICON_2 ICON_PATTERN_EXCLUDE_RED       '@2J@'."  Do not select: Exclude sample
ICON_2 ICON_SYSTEM_OKAY               '@2K@'."  OK
ICON_2 ICON_SYSTEM_SAVE               '@2L@'."  Save
ICON_2 ICON_SYSTEM_BACK               '@2M@'."  Back
ICON_2 ICON_SYSTEM_END                '@2N@'."  Exit
ICON_2 ICON_SYSTEM_CANCEL             '@2O@'."  Cancel
ICON_2 ICON_SYSTEM_PRINT              '@2P@'."  Print
ICON_2 ICON_OTHER_OBJECT              '@2Q@'."  Other Object
ICON_2 ICON_PREVIOUS_OBJECT           '@2R@'."  Previous screen
ICON_2 ICON_NEXT_OBJECT               '@2S@'."  Next screen
ICON_2 ICON_SYSTEM_CUT                '@2T@'."  Cut
ICON_2 ICON_SYSTEM_COPY               '@2U@'."  Copy
ICON_2 ICON_SYSTEM_PASTE              '@2V@'."  Paste
ICON_2 ICON_SYSTEM_UNDO               '@2W@'."  Undo
ICON_2 ICON_SYSTEM_MARK               '@2X@'."  Selection mode; Select
ICON_2 ICON_FIRST_PAGE                '@2Y@'."  First page
ICON_2 ICON_PREVIOUS_PAGE             '@2Z@'."  Previous page
ICON_2 ICON_NEXT_PAGE                 '@30@'."  Next page
ICON_2 ICON_LAST_PAGE                 '@31@'."  Last page
ICON_2 ICON_SYSTEM_MODUS_CREATE       '@32@'."  Create session
ICON_2 ICON_SYSTEM_MODUS_DELETE       '@33@'."  Delete session
ICON_2 ICON_SYSTEM_USERMENU           '@34@'."  Session Manager
ICON_2 ICON_SYSTEM_HELP               '@35@'."  Help
ICON_2 ICON_TABLE_SETTINGS            '@36@'."  Call report from report
ICON_2 ICON_REPLACE                   '@37@'."  Replace
ICON_2 ICON_CHECK                     '@38@'."  Check
ICON_2 ICON_GENERATE                  '@39@'."  Generate
ICON_2 ICON_REFERENCE_LIST            '@3A@'."  Where-used list
ICON_2 ICON_STACK                     '@3B@'."  Stack
ICON_2 ICON_ACTIVATE                  '@3C@'."  Activate
ICON_2 ICON_ICON_LIST                 '@3D@'."  Icon list; Legend
ICON_2 ICON_SORT_UP                   '@3E@'."  Sort in ascending order
ICON_2 ICON_SORT_DOWN                 '@3F@'."  Sort in descending order
ICON_2 ICON_LAYOUT_CONTROL            '@3G@'."  Print preview
ICON_2 ICON_CONVERT                   '@3H@'."  Convert
ICON_2 ICON_TOGGLE_DISPLAY_CHANGE     '@3I@'."  Display or Change
ICON_2 ICON_SET_STATE                 '@3J@'."  Set status
ICON_2 ICON_PREVIOUS_NODE             '@3K@'."  Previous node
ICON_2 ICON_NEXT_NODE                 '@3L@'."  Next node
ICON_2 ICON_TREE                      '@3M@'."  Hierarchy
ICON_2 ICON_INSERT_RELATION           '@3N@'."  Insert relationship
ICON_2 ICON_FINAL_DATE                '@3O@'."  Finish date; Date
ICON_2 ICON_HEADER                    '@3P@'."  Header; Basic data
ICON_2 ICON_OVERVIEW                  '@3Q@'."  Overview; List screen
ICON_2 ICON_DETAIL                    '@3R@'."  Detail view
ICON_2 ICON_EXPAND                    '@3S@'."  Expand
ICON_2 ICON_COLLAPSE                  '@3T@'."  Collapse
ICON_2 ICON_BREAKPOINT                '@3U@'."  Breakpoint
ICON_2 ICON_FOREIGN_KEY               '@3V@'."  Foreign key
ICON_2 ICON_LIST                      '@3W@'."  List
ICON_2 ICON_CLOSE                     '@3X@'."  Close
ICON_2 ICON_POSITION                  '@3Y@'."  Position; Other entry
ICON_2 ICON_SUM                       '@3Z@'."  Display sum
ICON_2 ICON_MOVE                      '@40@'."  Move
ICON_2 ICON_RETRIEVE                  '@41@'."  Retrieve
ICON_2 ICON_REFRESH                   '@42@'."  Refresh
ICON_2 ICON_SKIP                      '@43@'."  Skip
ICON_2 ICON_SYSTEM_SETTINGS           '@44@'."  User settings
ICON_2 ICON_TOOLS                     '@45@'."  Tools
ICON_2 ICON_COMPARE                   '@46@'."  Compare
ICON_2 ICON_SHORT_MESSAGE             '@47@'."  Short message
ICON_2 ICON_IMPORT                    '@48@'."  Import
ICON_2 ICON_EXPORT                    '@49@'."  Export
ICON_2 ICON_TRANSPORT                 '@4A@'."  Transport
ICON_2 ICON_SELECT_ALL                '@4B@'."  Select all
ICON_2 ICON_SELECT_BLOCK              '@4C@'."  Select block
ICON_2 ICON_DESELECT_ALL              '@4D@'."  Deselect all
ICON_2 ICON_SEARCH_NEXT               '@4E@'."  Find next
ICON_2 ICON_RENAME                    '@4F@'."  Rename
ICON_2 ICON_FILTER                    '@4G@'."  Filter
ICON_2 ICON_NEXT_HIERARCHY_LEVEL      '@4H@'."  Subordinate level
ICON_2 ICON_PREVIOUS_HIERARCHY_LEVEL  '@4I@'."  Superior level
ICON_2 ICON_SYSTEM_POSSIBLE_ENTRIES   '@4J@'."  Possible entries
ICON_2 ICON_INTENSIFY                 '@4K@'."  Highlight
ICON_2 ICON_PERSONAL_HELP             '@4L@'."  Individual help
ICON_2 ICON_VARIABLE                  '@4M@'."  Variable
ICON_2 ICON_SYSTEM_LOCAL_CUT          '@4N@'."  Local cut
ICON_2 ICON_SYSTEM_LOCAL_COPY         '@4O@'."  Local copy
ICON_2 ICON_SYSTEM_LOCAL_PASTE        '@4P@'."  Local paste
ICON_2 ICON_SYSTEM_LOCAL_MARK         '@4Q@'."  Local select mode
ICON_2 ICON_SYSTEM_REDO               '@4R@'."  Redo
ICON_2 ICON_BUSINAV_PROCESS           '@4S@'."  Process
ICON_2 ICON_BUSINAV_PROCESSMATRIX     '@4T@'."  Process selection matrix
ICON_2 ICON_BUSINAV_SYSORGI           '@4U@'."  System organization diagram
ICON_2 ICON_BUSINAV_SZENARIO          '@4V@'."  Scenario
ICON_2 ICON_BUSINAV_OBJECTS           '@4W@'."  Business object
ICON_2 ICON_BUSINAV_INFODIAG          '@4X@'."  Information flow diagram
ICON_2 ICON_BUSINAV_ENTITY            '@4Y@'."  Entity type
ICON_2 ICON_BUSINAV_PROC_EXIST        '@4Z@'."  Process exists
ICON_2 ICON_BUSINAV_COMMDIAG          '@50@'."  Communication diagram
ICON_2 ICON_BUSINAV_DATAMODEL         '@51@'."  Data model
ICON_2 ICON_ALIGN                     '@52@'."  Align
ICON_2 ICON_CUT_RELATION              '@53@'."  Cut relationship
ICON_2 ICON_FIX_COLUMN                '@54@'."  Freeze column
ICON_2 ICON_RELEASE_COLUMN            '@55@'."  Unfreeze columns
ICON_2 ICON_NET_GRAPHIC               '@56@'."  Network graphic
ICON_2 ICON_PLANNING_TABLE            '@57@'."  Bar chart; Planning board
ICON_2 ICON_PERIOD                    '@58@'."  Period screen; Breakdown over t
ICON_2 ICON_ZOOM_IN                   '@59@'."  Zoom in
ICON_2 ICON_ZOOM_OUT                  '@5A@'."  Zoom out
ICON_2 ICON_LED_GREEN                 '@5B@'."  Green LED; go; OK
ICON_2 ICON_LED_RED                   '@5C@'."  Red LED; stop; error
ICON_2 ICON_LED_YELLOW                '@5D@'."  Yellow LED; caution
ICON_2 ICON_SYSTEM_EXTENDED_HELP      '@5E@'."  Application help
ICON_2 ICON_SPACE                     '@5F@'."  Space
ICON_2 ICON_BUSINAV_VALUE_CHAIN       '@5G@'."  Value chain
ICON_2 ICON_WORKFLOW_ACTIVITY         '@5H@'."  Activity
ICON_2 ICON_WORKFLOW_CONDITION        '@5I@'."  Condition
ICON_2 ICON_WORKFLOW_DECISION         '@5J@'."  User decision
ICON_2 ICON_WORKFLOW_CONT_OPERATION   '@5K@'."  Container operation
ICON_2 ICON_WORKFLOW_EXTERNAL_EVENT   '@5L@'."  External event
ICON_2 ICON_WORKFLOW_INTERNAL_EVENT   '@5M@'."  Internal event
ICON_2 ICON_WORKFLOW_MULT_CONDITION   '@5N@'."  Multiple condition
ICON_2 ICON_WORKFLOW_FORK             '@5O@'."  Go to Workflow
ICON_2 ICON_WORKFLOW_EVENT_PRODUCER   '@5P@'."  Event creator
ICON_2 ICON_WORKFLOW_FLOW_OF_CONTROL  '@5Q@'."  Process control
ICON_2 ICON_WORKFLOW_INDEFINITE_STEP  '@5R@'."  Undefined step
ICON_2 ICON_WORKFLOW_UNTIL            '@5S@'."  UNTIL loop
ICON_2 ICON_WORKFLOW_WAIT_FOR_EVENTS  '@5T@'."  Wait for events
ICON_2 ICON_WORKFLOW_WHILE            '@5U@'."  WHILE loop
ICON_2 ICON_INTERMEDIATE_SUM          '@5V@'."  Subtotal
ICON_2 ICON_EMPLOYEE                  '@5W@'."  Employee
ICON_2 ICON_TIME_ZONE                 '@5X@'."  Time zone
ICON_2 ICON_RELEASE                   '@5Y@'."  Enter
ICON_2 ICON_QUALIFY                   '@5Z@'."  Auszeichnen
ICON_2 ICON_ISO_CODE                  '@60@'."  ISO code
ICON_2 ICON_MODIFY                    '@61@'."  Modify; Enhance
ICON_2 ICON_GET_AREA                  '@62@'."  Environment analysis
ICON_2 ICON_INTERFACE                 '@63@'."  Interface
ICON_2 ICON_ROUTING_OPERATION         '@64@'."  Operation
ICON_2 ICON_ROUTING_REF_OPERATION     '@65@'."  Reference operation
ICON_2 ICON_ROUTING_TASK              '@66@'."  Work center operation step
ICON_2 ICON_ROUTING_TODO              '@67@'."  To-do list
ICON_2 ICON_EXPAND_ALL                '@68@'."  Expand all
ICON_2 ICON_COLLAPSE_ALL              '@69@'."  Collapse all
ICON_2 ICON_SYSTEM_SAP_MENU           '@6A@'."  SAP menu
ICON_2 ICON_SYSTEM_COMP_MENU          '@6B@'."  Enterprise menu
ICON_2 ICON_SYSTEM_USER_MENU          '@6C@'."  User menu
ICON_2 ICON_SYSTEM_FAVORITES          '@6D@'."  User favorites
ICON_2 ICON_BIW_INFO_SOURCE           '@6E@'."  InfoSource
ICON_2 ICON_BIW_APPLICATION           '@6F@'."  Application
ICON_2 ICON_BIW_INFO_AREA             '@6G@'."  InfoArea
ICON_2 ICON_BIW_INFO_CUBE             '@6H@'."  InfoCube
ICON_2 ICON_BIW_RULES_INA             '@6I@'."  Update rules (inactive)
ICON_2 ICON_BIW_SOURCE_SYS_GEN        '@6J@'."  Source system (general)
ICON_2 ICON_BIW_SOURCE_SYS_R3         '@6K@'."  Source system (R/3 System)
ICON_2 ICON_BIW_SOURCE_SYS_EXT        '@6L@'."  Source system (external)
ICON_2 ICON_BIW_SOURCE_SYS_FILE       '@6M@'."  Source system file
ICON_2 ICON_BIW_INFO_CATALOG          '@6N@'."  InfoCatalog
ICON_2 ICON_BIW_INFO_OBJECT           '@6O@'."  InfoObject
ICON_2 ICON_BIW_MONITOR               '@6P@'."  Monitor
ICON_2 ICON_BIW_SCHEDULER             '@6Q@'."  Scheduler
ICON_2 ICON_BIW_FORMULA               '@6R@'."  Formula
ICON_2 ICON_BIW_REF_STRUCTURE         '@6S@'."  Template structure
ICON_2 ICON_BIW_REPORT                '@6T@'."  Report
ICON_2 ICON_BIW_REPORT_VIEW           '@6U@'."  Report view (=workbook)
ICON_2 ICON_MASTER_DATA_ACT           '@6V@'."  Master data (active)
ICON_2 ICON_MASTER_DATA_INA           '@6W@'."  Master data (inactive)
ICON_2 ICON_TEXT_ACT                  '@6X@'."  Texts (active)
ICON_2 ICON_TEXT_INA                  '@6Y@'."  Texts (inactive)
ICON_2 ICON_HIERARCHY_ACT             '@6Z@'."  Hierarchies (active)
ICON_2 ICON_HIERARCHY_INA             '@70@'."  Hierarchies (inactive)
ICON_2 ICON_MOVING_DATA_ACT           '@71@'."  Transaction data (active)
ICON_2 ICON_MOVING_DATA_INA           '@72@'."  Transaction data (inactive)
ICON_2 ICON_DEBUGGER_STEP_INTO        '@73@'."  Debugger: Single step
ICON_2 ICON_DEBUGGER_STEP_OVER        '@74@'."  Debugger: Perform
ICON_2 ICON_DEBUGGER_STEP_OUT         '@75@'."  Debugger: Back
ICON_2 ICON_DEBUGGER_CONTINUE         '@76@'."  Debugger: Continue
ICON_2 ICON_PARAMETER                 '@77@'."  Parameters
ICON_2 ICON_PARAMETER_IMPORT          '@78@'."  Parameters (import)
ICON_2 ICON_PARAMETER_EXPORT          '@79@'."  Parameters (export)
ICON_2 ICON_PARAMETER_CHANGING        '@7A@'."  Change parameters
ICON_2 ICON_PARAMETER_RESULT          '@7B@'."  Parameters (result)
ICON_2 ICON_OO_CLASS                  '@7C@'."  Class
ICON_2 ICON_OO_INTERFACE              '@7D@'."  Interface
ICON_2 ICON_OO_ATTRIBUTE              '@7E@'."  Attribute
ICON_2 ICON_OO_CLASS_ATTRIBUTE        '@7F@'."  Class attribute
ICON_2 ICON_OO_INST_ATTRIBUTE         '@7G@'."  Instance attribute
ICON_2 ICON_OO_METHOD                 '@7H@'."  Method
ICON_2 ICON_OO_CLASS_METHOD           '@7I@'."  Class method
ICON_2 ICON_OO_INST_METHOD            '@7J@'."  Instance method
ICON_2 ICON_OO_EVENT                  '@7K@'."  Event
ICON_2 ICON_OO_CONSTANT               '@7L@'."  Constant
ICON_2 ICON_OO_OVERWRITE              '@7M@'."  Redefine
ICON_2 ICON_OO_CONNECTION             '@7N@'."  Relationships
ICON_2 ICON_OO_INHERITANCE            '@7O@'."  Inheritance/specialization
ICON_2 ICON_OO_INTERFACE_IC           '@7P@'."  Interface implementation/compos
ICON_2 ICON_WS_TRUCK                  '@7Q@'."  Transport of goods (truck)
ICON_2 ICON_WS_RAIL                   '@7R@'."  Transport of goods (rail)
ICON_2 ICON_WS_SHIP                   '@7S@'."  Transport of goods (ship)
ICON_2 ICON_WS_PLANE                  '@7T@'."  Transport of goods (plane)
ICON_2 ICON_WS_POST                   '@7U@'."  Transport of goods (mail)
ICON_2 ICON_WS_TRANSFER               '@7V@'."  Stock turnover
ICON_2 ICON_WS_DOUANE                 '@7W@'."  Border; Customs
ICON_2 ICON_SELECTION                 '@7X@'."  Selection; Selection criteria
ICON_2 ICON_SYSTEM_STOP_RECORDING     '@7Y@'."  Stop recording
ICON_2 ICON_FENCING                   '@7Z@'."  Dynamic selections
ICON_2 ICON_BIW_RULES_ACT             '@80@'."  Update rules (active)
ICON_2 ICON_CHARACTERISTICS_ACT       '@81@'."  Characteristic (active)
ICON_2 ICON_CHARACTERISTICS_INA       '@82@'."  Characteristic (inactive)
ICON_2 ICON_KEYFIGURE_ACT             '@83@'."  Key figure (active)
ICON_2 ICON_KEYFIGURE_INA             '@84@'."  Key figure (inactive)
ICON_2 ICON_BIW_INFO_OBJECT_UNITS_ACT '@85@'."  InfoObject units (active)
ICON_2 ICON_BIW_INFO_OBJECT_UNITS_INA '@86@'."  InfoObject units (inactive)
ICON_2 ICON_WORKFLOW_INT_EVENT_DATE   '@87@'."  Internal event with date
ICON_2 ICON_BIW_INFO_OBJECT_CATALOGUE '@88@'."  InfoObject Catalog
ICON_2 ICON_SET_A                     '@89@'."  Set A
ICON_2 ICON_SET_B                     '@8A@'."  Set B
ICON_2 ICON_SET_SUM                   '@8B@'."  A plus B
ICON_2 ICON_SET_INTERSECTION          '@8C@'."  Intersection set AB
ICON_2 ICON_SET_A_MINUS_B             '@8D@'."  A minus B
ICON_2 ICON_SET_B_MINUS_A             '@8E@'."  B minus A
ICON_2 ICON_SET_COPY_IN_A             '@8F@'."  Copy to set A
ICON_2 ICON_SET_COPY_IN_B             '@8G@'."  Copy to set B
ICON_2 ICON_DANGEROUS_GOODS           '@8H@'."  Dangerous goods
ICON_2 ICON_DEACTIVATE                '@8I@'."  Deactivate
ICON_2 ICON_DESELECT_BLOCK            '@8J@'."  Deselect block
ICON_2 ICON_INVERT_COLUMN             '@8K@'."  Invert column selection
ICON_2 ICON_INVERT_LINE               '@8L@'."  Invert row selection
ICON_2 ICON_FOREIGN_TRADE             '@8M@'."  Foreign trade
ICON_2 ICON_MESSAGE_CRITICAL_SMALL    '@8N@'."  Critical message
ICON_2 ICON_MESSAGE_ERROR_SMALL       '@8O@'."  Error message
ICON_2 ICON_MESSAGE_INFORMATION_SMALL '@8P@'."  Information message
ICON_2 ICON_MESSAGE_QUESTION_SMALL    '@8Q@'."  Question
ICON_2 ICON_MESSAGE_WARNING_SMALL     '@8R@'."  Warning
ICON_2 ICON_URL                       '@8S@'."  URL
ICON_2 ICON_SYSTEM_SHORTCUT           '@8T@'."  Create shortcut
ICON_2 ICON_PLANNING_IN               '@8U@'."  Dispatch operation
ICON_2 ICON_PLANNING_OUT              '@8V@'."  Deallocate operation
ICON_2 ICON_SUBMIT                    '@8W@'."  Submit for processing
ICON_2 ICON_ALLOW                     '@8X@'."  Allow
ICON_2 ICON_REJECT                    '@8Y@'."  Reject
ICON_2 ICON_SIMULATE                  '@8Z@'."  Simulate
ICON_2 ICON_TE_RECEIPTS               '@90@'."  Receipts
ICON_2 ICON_TE_STOPOVER               '@91@'."  Stopovers
ICON_2 ICON_TE_KM_DIVISION            '@92@'."  Miles/kms distribution
ICON_2 ICON_TE_ADVANCE_PAYMENT        '@93@'."  Advance payment
ICON_2 ICON_TE_DEDUCTION              '@94@'."  Deductions
ICON_2 ICON_TE_COSTS_ASSIGN           '@95@'."  Cost assignment
ICON_2 ICON_HISTORY                   '@96@'."  History
ICON_2 ICON_MODIFICATION_CREATE       '@97@'."  Modification: Create, change
ICON_2 ICON_MODIFICATION_OVERVIEW     '@98@'."  Modification: Overview
ICON_2 ICON_MODIFICATION_ORIGINAL     '@99@'."  Modification: Display original
ICON_2 ICON_MODIFICATION_RESET        '@9A@'."  Undo modification
ICON_2 ICON_ACTIVE_INACTIVE           '@9B@'."  Display mode active/not active
ICON_2 ICON_BEN_OFFER                 '@9C@'."  Automatic offer
ICON_2 ICON_BEN_OFFER_DEFAULT         '@9D@'."  Options
ICON_2 ICON_BEN_OFFER_EVENT           '@9E@'."  Event offer
ICON_2 ICON_BEN_OFFER_OPEN            '@9F@'."  Open offer
ICON_2 ICON_BEN_WAIVE_COVERAGE        '@9G@'."  Offers waived
ICON_2 ICON_DEPENDENTS                '@9H@'."  Dependents
ICON_2 ICON_BEN_CURRENT_BENEFITS      '@9I@'."  Current benefits
ICON_2 ICON_BEN_TERMINATION           '@9J@'."  Terminate benefits
ICON_2 ICON_WS_TRANSPORT              '@9K@'."  Transport of goods
ICON_2 ICON_ODS_ACT                   '@9L@'."  ODS (active)
ICON_2 ICON_ODS_INA                   '@9M@'."  ODS (inactive)
ICON_2 ICON_BIW_INFO_PACKAGE          '@9N@'."  InfoPackage
ICON_2 ICON_ACTION_FAULT              '@9O@'."  Incorrect request
ICON_2 ICON_ACTION_SUCCESS            '@9P@'."  Request successful
ICON_2 ICON_DIMENSION                 '@9Q@'."  Dimension
ICON_2 ICON_TIME_INA                  '@9R@'."  Time inactive
ICON_2 ICON_ARROW_LEFT                '@9S@'."  Arrow left
ICON_2 ICON_ARROW_RIGHT               '@9T@'."  Arrow right
ICON_2 ICON_ABAP                      '@9U@'."  ABAP routine
ICON_2 ICON_ABAP_LOCAL                '@9V@'."  Local ABAP
ICON_2 ICON_TRANSFER_STRUCTURE        '@9W@'."  Transfer structure
ICON_2 ICON_OPERATION                 '@9X@'."  Operation; Edit object
ICON_2 ICON_ACTIVITY                  '@9Y@'."  Activity
ICON_2 ICON_ORDER                     '@9Z@'."  Request; Order
ICON_2 ICON_CUSTOMER                  '@A0@'."  Customer
ICON_2 ICON_WAREHOUSE                 '@A1@'."  Central warehouse
ICON_2 ICON_DISPO_LEVEL               '@A2@'."  Planning level
ICON_2 ICON_DISTRIBUTION              '@A3@'."  Distribution center
ICON_2 ICON_CUSTOMER_WAREHOUSE        '@A4@'."  Customer warehouse
ICON_2 ICON_TRANSPORT_POINT           '@A5@'."  Stock transfer point
ICON_2 ICON_MATERIAL                  '@A6@'."  Material
ICON_2 ICON_MODEL                     '@A7@'."  Model
ICON_2 ICON_PLANT                     '@A8@'."  Plant
ICON_2 ICON_PRODUCT_GROUP             '@A9@'."  Product group
ICON_2 ICON_RELATIONSHIP              '@AA@'."  Relationship
ICON_2 ICON_RESOURCE                  '@AB@'."  Resource
ICON_2 ICON_STORE_LOCATION            '@AC@'."  Storage location
ICON_2 ICON_SUPPLIER                  '@AD@'."  Vendor
ICON_2 ICON_TRANSPORTATION_MODE       '@AE@'."  Transport type
ICON_2 ICON_LOCATION                  '@AF@'."  Location
ICON_2 ICON_ALERT                     '@AG@'."  Alarm
ICON_2 ICON_WARNING                   '@AH@'."  Warning
ICON_2 ICON_HINT                      '@AI@'."  Note
ICON_2 ICON_WORKING_PLAN              '@AJ@'."  Task list
ICON_2 ICON_MAINTENANCE_PLAN          '@AK@'."  Maintenance plan
ICON_2 ICON_REPORT                    '@AL@'."  Message
ICON_2 ICON_WORKPLACE                 '@AM@'."  Work center
ICON_2 ICON_EQUIPMENT                 '@AN@'."  Equipment
ICON_2 ICON_TECHNICAL_PLACE           '@AO@'."  Technical location
ICON_2 ICON_BOM                       '@AP@'."  Bill of material (BOM)
ICON_2 ICON_BOM_ITEM                  '@AQ@'."  Bill of material (BOM) item
ICON_2 ICON_DOCUMENT                  '@AR@'."  Document
ICON_2 ICON_DOCUMENT_REVISION         '@AS@'."  Document revision
ICON_2 ICON_MATERIAL_REVISION         '@AT@'."  Material revision
ICON_2 ICON_CHANGE_NUMBER             '@AU@'."  Change number
ICON_2 ICON_FLIGHT                    '@AV@'."  Book flight
ICON_2 ICON_CAR                       '@AW@'."  Book rental car
ICON_2 ICON_HOTEL                     '@AX@'."  Book hotel
ICON_2 ICON_RAILWAY                   '@AY@'."  Book train
ICON_2 ICON_MONEY                     '@AZ@'."  Price enquiry
ICON_2 ICON_QUESTION                  '@B0@'."  Query
ICON_2 ICON_BOOKING_OK                '@B1@'."  Book
ICON_2 ICON_BOOKING_STOP              '@B2@'."  Cancel
ICON_2 ICON_STATUS_OPEN               '@B3@'."  Booking status: open
ICON_2 ICON_STATUS_BOOKED             '@B4@'."  Booking status: booked
ICON_2 ICON_STATUS_PARTLY_BOOKED      '@B5@'."  Booking status: partially booke
ICON_2 ICON_STATUS_REVERSE            '@B6@'."  Booking status: canceled
ICON_2 ICON_PREFERENCE                '@B7@'."  Preferences
ICON_2 ICON_NEXT_STEP                 '@B8@'."  Next step
ICON_2 ICON_PREVIOUS_STEP             '@B9@'."  Previous step
ICON_2 ICON_STORNO                    '@BA@'."  Reverse payment items
ICON_2 ICON_INTERCHANGE               '@BB@'."  Swap
ICON_2 ICON_CASHING_UP                '@BC@'."  Factoring
ICON_2 ICON_WORKLOAD                  '@BD@'."  Workload
ICON_2 ICON_PROPOSITION               '@BE@'."  Suggestion
ICON_2 ICON_PRESENCE                  '@BF@'."  On; Presence
ICON_2 ICON_ABSENCE                   '@BG@'."  Off; Absence
ICON_2 ICON_TIME_CONTROL              '@BH@'."  Time evaluation
ICON_2 ICON_POSITION_HR               '@BI@'."  Position (job)
ICON_2 ICON_PARAMETER_TABLE           '@BJ@'."  Parameters (table)
ICON_2 ICON_TASK                      '@BK@'."  Task
ICON_2 ICON_COST_CENTER               '@BL@'."  Cost center
ICON_2 ICON_MANAGER                   '@BM@'."  Manager
ICON_2 ICON_ORG_UNIT                  '@BN@'."  Organizational unit
ICON_2 ICON_QUERY                     '@BO@'."  Query tool
ICON_2 ICON_WORKFLOW_INBOX            '@BP@'."  Workflow inbox
ICON_2 ICON_FAST_ENTRY                '@BQ@'."  Fast entry
ICON_2 ICON_LIFE_EVENTS               '@BR@'."  Actions
ICON_2 ICON_WORK_CENTER               '@BS@'."  Work center
ICON_2 ICON_GRADUATE                  '@BT@'."  Graduated scale
ICON_2 ICON_EXTRA                     '@BU@'."  Bonus; Gift
ICON_2 ICON_CONVERT_ALL               '@BV@'."  Conversion amount factor
ICON_2 ICON_RELATION                  '@BW@'."  Object dependencies
ICON_2 ICON_CONFIGURATION             '@BX@'."  Configuration
ICON_2 ICON_WIZARD                    '@BY@'."  Wizard
ICON_2 ICON_LED_INACTIVE              '@BZ@'."  Inactive LED; Undefined
ICON_2 ICON_STORE                     '@C0@'."  Store
ICON_2 ICON_LINK                      '@C1@'."  Assign
ICON_2 ICON_LATE_STORE                '@C2@'."  Record later
ICON_2 ICON_LATE_LINK                 '@C3@'."  Assign later
ICON_2 ICON_EARLY_STORE               '@C4@'."  Record immediately
ICON_2 ICON_EARLY_LINK                '@C5@'."  Assign immediately
ICON_2 ICON_OO_CLASS_EVENT            '@C6@'."  Class event
ICON_2 ICON_OO_INST_EVENT             '@C7@'."  Instance event
ICON_2 ICON_OO_ALIAS                  '@C8@'."  Alias
ICON_2 ICON_OO_OBJECT                 '@C9@'."  Object
ICON_2 ICON_JOB                       '@CA@'."  Job
ICON_2 ICON_DELIVERY_DATE             '@CB@'."  One-time delivery on date requi
ICON_2 ICON_DELIVERY_COMPLETE         '@CC@'."  Complete delivery
ICON_2 ICON_DELIVERY_PROPOSAL         '@CD@'."  Delivery proposal
ICON_2 ICON_PDIR_BACK_SWITCH          '@CE@'."  Backward plan direction (switch
ICON_2 ICON_PDIR_BACK                 '@CF@'."  Backward plan direction
ICON_2 ICON_PDIR_FOREWARD             '@CG@'."  Forward plan direction
ICON_2 ICON_PDIR_FOREWARD_SWITCH      '@CH@'."  Forward plan direction (switch)
ICON_2 ICON_FINITE                    '@CI@'."  Finite capacity
ICON_2 ICON_NONWORK                   '@CJ@'."  Variations of non-working time
ICON_2 ICON_PM_FREE                   '@CK@'."  Planning session: Free capacity
ICON_2 ICON_PM_INSERT                 '@CL@'."  Planning session: Insert busine
ICON_2 ICON_PM_PRESS                  '@CM@'."  Planning session: Press busines
ICON_2 ICON_PM_ORDER                  '@CN@'."  Planning session: Keep the same
ICON_2 ICON_DANGEROUS_GOOD_CHECK      '@CO@'."  Dangerous goods check
ICON_2 ICON_WORKFLOW_DOC_CREATE       '@CP@'."  Create document from template
ICON_2 ICON_WF_LINK                   '@CQ@'."  Set dataflow
ICON_2 ICON_WF_UNLINK                 '@CR@'."  Trigger dataflow
ICON_2 ICON_WF_WORKITEM_READY         '@CS@'."  Work item ready
ICON_2 ICON_WF_WORKITEM_RESERVED      '@CT@'."  Work item reserved
ICON_2 ICON_WF_WORKITEM_STARTED       '@CU@'."  Work item in progress
ICON_2 ICON_WF_WORKITEM_COMMITTED     '@CV@'."  Work item carried out
ICON_2 ICON_WF_WORKITEM_WAITING       '@CW@'."  Work item waiting
ICON_2 ICON_WF_WORKITEM_COMPLETED     '@CX@'."  Work item completed
ICON_2 ICON_WF_WORKITEM_ERROR         '@CY@'."  Work item has errors
ICON_2 ICON_WF_WORKITEM_CANCEL        '@CZ@'."  Work item logically deleted
ICON_2 ICON_WF_RESERVE_WORKITEM       '@D0@'."  Reserve work item
ICON_2 ICON_WF_REPLACE_WORKITEM       '@D1@'."  Return work item
ICON_2 ICON_PROFIT_CENTER             '@D2@'."  Profit center
ICON_2 ICON_WF_RULE_SYSTEM            '@D3@'."  Set of rules
ICON_2 ICON_WF_PARAMETER              '@D4@'."  Rule parameters
ICON_2 ICON_JAPAN                     '@D5@'."  Japan
ICON_2 ICON_SLS                       '@D6@'."  Sanctioned party list
ICON_2 ICON_CUSTOMS                   '@D7@'."  Customs-related technical area
ICON_2 ICON_LEGAL_REG                 '@D8@'."  Legal regulation
ICON_2 ICON_COMPANY_CODE              '@D9@'."  Company code
ICON_2 ICON_UNIT_COSTING              '@DA@'."  Unit costing
ICON_2 ICON_BASE_PLANNING_OBJECT      '@DB@'."  Base costing object (costing bl
ICON_2 ICON_ACTIVITY_TYPE             '@DC@'."  Activity type
ICON_2 ICON_RENTAL_AGREEMENT          '@DD@'."  Rental agreement
ICON_2 ICON_REAL_ESTATE_OBJECT        '@DE@'."  Real estate object
ICON_2 ICON_COMPLETE                  '@DF@'."  Complete;No problems occurred
ICON_2 ICON_PARTNER                   '@DG@'."  Partner
ICON_2 ICON_PROTOCOL                  '@DH@'."  Display log
ICON_2 ICON_MAINTENANCE_OBJECT_LIST   '@DI@'."  Call up object list
ICON_2 ICON_XXL                       '@DJ@'."  Call up Excel List Viewer
ICON_2 ICON_WORD_PROCESSING           '@DK@'."  Call up word processing
ICON_2 ICON_ABC                       '@DL@'."  ABC analysis
ICON_2 ICON_ALV_VARIANT_CHOOSE        '@DM@'."  Select display variant
ICON_2 ICON_ALV_VARIANT_SAVE          '@DN@'."  Save display variant
ICON_2 ICON_EXCLUDED_CORRESPONDENCE   '@DO@'."  Excluded correspondence class
ICON_2 ICON_INCREASE_DECIMAL          '@DP@'."  More decimal places
ICON_2 ICON_DECREASE_DECIMAL          '@DQ@'."  Fewer decimal places
ICON_2 ICON_ERROR_PROTOCOL            '@DR@'."  Message log
ICON_2 ICON_PARTNER_SALES_ACTIVITY    '@DS@'."  Partner sales activity
ICON_2 ICON_PHONE_CALL_IN             '@DT@'."  Incoming telephone call
ICON_2 ICON_NAFTA                     '@DU@'."  North American Free Trade Assoc
ICON_2 ICON_EU                        '@DV@'."  European Union
ICON_2 ICON_PHONE_CALL_OUT            '@DW@'."  Outgoing telephone call
ICON_2 ICON_CONTROLLING_AREA          '@DX@'."  Controlling area
ICON_2 ICON_DISTRIBUTION_LIST         '@DY@'."  Distribution list
ICON_2 ICON_MAIL_SAP_UNREAD           '@DZ@'."  SAP mails unread
ICON_2 ICON_MAIL_SAP_READ             '@E0@'."  SAP mails read
ICON_2 ICON_ENVELOPE_OPEN             '@E1@'."  Message has been read
ICON_2 ICON_ENVELOPE_CLOSED           '@E2@'."  Message has not been read
ICON_2 ICON_OFFICE_DOCUMENT           '@E3@'."  SAPoffice document
ICON_4 ICON_INCLUDE_IN_SELECTION      '@E4@'."  Go; OK
ICON_2 ICON_WF_WORKITEM_OL            '@E5@'."
ICON_2 ICON_NEW_HANDLING_UNIT         '@E6@'."
ICON_2 ICON_NEW_HANDLING_IF_FULL      '@E7@'."
ICON_2 ICON_PACKING                   '@E8@'."  Pack
ICON_2 ICON_UNPACK                    '@E9@'."  Unpack
ICON_2 ICON_EMPTY_HANDLING_UNIT       '@EA@'."  Empty
ICON_4 ICON_LIGHT_OUT                 '@EB@'."  Light out; Undefined
ICON_2 ICON_PS_PROJECT_DEFINITION     '@EC@'."  Project definition
ICON_2 ICON_PS_WBS_ELEMENT            '@ED@'."  WBS element
ICON_2 ICON_PS_NETWORK_HEADER         '@EE@'."  Network header
ICON_2 ICON_PS_NETWORK_ACTIVITY       '@EF@'."  Network activity
ICON_2 ICON_PS_ACTIVITY_ELEMENT       '@EG@'."  Activity element
ICON_2 ICON_PS_RELATIONSHIP           '@EH@'."  Relationship
ICON_2 ICON_STATUS                    '@EI@'."  System Status
ICON_2 ICON_BATCH                     '@EJ@'."  Batch
ICON_2 ICON_ADMINISTRATIVE_DATA       '@EK@'."  Display administrative data
ICON_2 ICON_STOCK                     '@EL@'."  Stock
ICON_2 ICON_ACCOUNT_ASSIGNMENT        '@EM@'."  Account assignment
ICON_2 ICON_LOT_ORIGIN                '@EN@'."  Origin
ICON_2 ICON_INSPECTION_LOT            '@EO@'."  Inspection lot
ICON_2 ICON_SHOW_EXTERNAL_JOBS        '@EP@'."  Display external jobs
ICON_2 ICON_SPOOL_REQUEST             '@EQ@'."  Spool request
ICON_2 ICON_OUTPUT_REQUEST            '@ER@'."  Display output request
ICON_2 ICON_DELETE_FAVORITES          '@ES@'."  Delete from favorites
ICON_2 ICON_SHOW_EVENTS               '@ET@'."  Show event
ICON_2 ICON_SPOOL_STATUS              '@EU@'."  Display spool status
ICON_2 ICON_INSERT_FAVORITES          '@EV@'."  Add to favorites
ICON_2 ICON_PRINT_WITH_PARAMETERS     '@EW@'."  Print with parameters
ICON_2 ICON_USED_RELATION             '@EX@'."  Display use relationships
ICON_2 ICON_MAPPED_RELATION           '@EY@'."  Display mapped relationships
ICON_2 ICON_CREATE_COPY               '@EZ@'."  Create with template
ICON_2 ICON_FLUSH                     '@F0@'."  Undo cache entry
ICON_2 ICON_DEFECT                    '@F1@'."  Not completed; Error
ICON_2 ICON_BW_GIS                    '@F2@'."  GIS icon for Microsoft Excel
ICON_2 ICON_BW_INFO_CUBE_SAP          '@F3@'."  InfoCube (SAP version)
ICON_2 ICON_BW_INFO_CUBE_INA          '@F4@'."  InfoCube (inactive)
ICON_2 ICON_BW_INFO_OBJECT_CATALOGUE  '@F5@'."  InfoObject Catalog (SAP version
ICON_2 ICON_BW_SUGGEST_VALUE          '@F6@'."  Default values
ICON_2 ICON_DOC_POSITION_PROPOSAL     '@F7@'."  Propose position
ICON_2 ICON_CUSTOMER_MASTER_DATA_LIST '@F8@'."  Display customer master data
ICON_2 ICON_STATUS_OVERVIEW           '@F9@'."  Display status overview
ICON_2 ICON_DOC_HEADER_DETAIL         '@FA@'."  Document header details
ICON_2 ICON_DOC_ITEM_DETAIL           '@FB@'."  Display item details
ICON_2 ICON_AVAILABILITY_CHECK        '@FC@'."  Check availability
ICON_2 ICON_PRICE                     '@FD@'."  Price conditions
ICON_2 ICON_SCHEDULE_LINE             '@FE@'."  Schedule lines
ICON_2 ICON_AVAILABILITY_DISPLAY      '@FF@'."  Display availability
ICON_2 ICON_STATISTICS                '@FG@'."  Call warehouse statistics
ICON_2 ICON_CLAIM                     '@FH@'."  Call up/define a claim file
ICON_2 ICON_PLANNING_SITUATION        '@FI@'."
ICON_2 ICON_CHANGE_ORDER              '@FJ@'."
ICON_2 ICON_PRODUCT_REQUIREMENTS      '@FK@'."
ICON_2 ICON_PRODUCT_RECEIPTS          '@FL@'."
ICON_2 ICON_ATTACHMENT                '@FM@'."  Display attachment
ICON_2 ICON_CLOSED_FOLDER             '@FN@'."  Display folder content
ICON_2 ICON_OPEN_FOLDER               '@FO@'."  Open folder
ICON_2 ICON_OBJECT_FOLDER             '@FP@'."  Open object folder
ICON_2 ICON_OUTBOX                    '@FQ@'."  Display outbox
ICON_2 ICON_RESUBMISSION              '@FR@'."  Resubmit
ICON_2 ICON_PRIVATE_FILES             '@FS@'."  Private folders
ICON_2 ICON_PUBLIC_FILES              '@FT@'."  Public folders
ICON_2 ICON_SUBSCRIPTION              '@FU@'."  Subcribed folders
ICON_2 ICON_AVERAGE                   '@FV@'."  Calculate average
ICON_2 ICON_BOLD                      '@FW@'."  Bold
ICON_2 ICON_ITALIC                    '@FX@'."  Italics
ICON_2 ICON_UNDERLINE                 '@FY@'."  Underline
ICON_2 ICON_ALIGN_LEFT                '@FZ@'."  Align left
ICON_2 ICON_ALIGN_RIGHT               '@G0@'."  Align right
ICON_2 ICON_ALIGN_CENTER              '@G1@'."  Center
ICON_2 ICON_JUSTIFIED                 '@G2@'."  Justify
ICON_2 ICON_COLOR                     '@G3@'."  Color
ICON_2 ICON_DELETE_ALL_ATTRIBUTES     '@G4@'."  Delete all attributes
ICON_2 ICON_IDOC                      '@G5@'."  Display Idocs
ICON_2 ICON_HOST                      '@G6@'."  Computer/host
ICON_2 ICON_SYM_SPOOL_SERVER          '@G7@'."  Application server with spool
ICON_2 ICON_SYM_REAL_SERVER           '@G8@'."  Real application server
ICON_2 ICON_SYM_LOG_SERVER            '@G9@'."  Logical application server
ICON_2 ICON_SYM_ALT_SERVER            '@GA@'."  Alternative server
ICON_2 ICON_CONNECT                   '@GB@'."  Connect
ICON_2 ICON_DISCONNECT                '@GC@'."  Disconnect
ICON_2 ICON_FILTER_UNDO               '@GD@'."  Undo filter
ICON_2 ICON_SET_SUM_UNDO              '@GE@'."  Undo grouping
ICON_2 ICON_INTENSIFY_UNDO            '@GF@'."  Undo highlighting
ICON_2 ICON_SORT_UNDO                 '@GG@'."  Undo sorting
ICON_2 ICON_BW_DATA_MARTS             '@GH@'."  Datamarts
ICON_4 ICON_REMOVE_FROM_SELECTION     '@GI@'."  Stop; error
ICON_2 ICON_BW_CHARACTERISTICS_SAP    '@GJ@'."  Characteristic (SAP version)
ICON_2 ICON_BW_KEYFIGURE_SAP          '@GK@'."  Key figure (SAP version)
ICON_2 ICON_BW_INFO_OBJECT_UNITS_SAP  '@GL@'."  Unit (SAP version)
ICON_2 ICON_BW_TIME_SAP               '@GM@'."  Time characteristic (SAP versio
ICON_2 ICON_BW_RULES_SAP              '@GN@'."  Update rules (SAP version)
ICON_2 ICON_BW_REPORT_SAP             '@GO@'."  Query (SAP version)
ICON_2 ICON_BW_VARIABLE_SAP           '@GP@'."  Variable (SAP version)
ICON_2 ICON_BW_REF_STRUCTURE_SAP      '@GQ@'."  Template (SAP version)
ICON_2 ICON_BW_SELECTION_SAP          '@GR@'."  Restricted key figure (SAP vers
ICON_2 ICON_INSPECTION_METHOD         '@GS@'."  Inspection method
ICON_2 ICON_CATALOG                   '@GT@'."  Catalog
ICON_2 ICON_INSERT_MULTIPLE_LINES     '@GU@'."  Insert rows
ICON_2 ICON_INSPECTION_CHARACTERISTIC '@GV@'."  Inspection characteristic
ICON_2 ICON_PHYSICAL_SAMPLE           '@GW@'."  Physical sample
ICON_2 ICON_BW_FORMULA_SAP            '@GX@'."  Calculated key figure (SAP vers
ICON_2 ICON_BW_INFO_CATALOGUE_SAP     '@GY@'."  InfoCatalog (SAP version)
ICON_2 ICON_BUDGET_STRUCTURE_ELEMENT  '@GZ@'."  Budget structure element
ICON_2 ICON_FINANCING                 '@H0@'."  Financing
ICON_2 ICON_RECLASSIFICATION_RULE     '@H1@'."  Reclassification rule
ICON_2 ICON_RECLASSIFICATION          '@H2@'."  Reclassification
ICON_2 ICON_REMOVE                    '@H3@'."  Mark for elimination
ICON_2 ICON_SPECIAL_PURPOSE           '@H4@'."  Earmark
ICON_2 ICON_DEPUTY                    '@H5@'."  Substitute
ICON_2 ICON_BUDGET_UPDATE             '@H6@'."  Budget update
ICON_2 ICON_BUDGET_TRANSFER           '@H7@'."  Transfer
ICON_2 ICON_BW_SEGMENT_ACT            '@H8@'."  Segment (active)
ICON_2 ICON_BW_SEGMENT_INA            '@H9@'."  Segment (inactive)
ICON_2 ICON_BW_SEGMENT_SAP            '@HA@'."  Segment (SAP version)
ICON_2 ICON_MASS_CHANGE               '@HB@'."  Make mass change
ICON_2 ICON_INTENSIFY_CRITICAL        '@HC@'."  Highlighting critical
ICON_2 ICON_INTENSIFY_UNCRITICAL      '@HD@'."  Highlighting noncritical
ICON_2 ICON_CHOOSE_COLUMNS            '@HE@'."  Select columns
ICON_2 ICON_TOTAL_UP                  '@HF@'."  Move to top of list
ICON_2 ICON_TOTAL_DOWN                '@HG@'."  Move to bottom of list
ICON_2 ICON_PAGE_UP                   '@HH@'."  Page up
ICON_2 ICON_PAGE_DOWN                 '@HI@'."  Page down
ICON_2 ICON_READ_FILE                 '@HJ@'."  Read file
ICON_2 ICON_WRITE_FILE                '@HK@'."  Write file
ICON_2 ICON_EDIT_FILE                 '@HL@'."  Edit file
ICON_2 ICON_PS_MILESTONE              '@HM@'."  Milestone
ICON_2 ICON_PS_PROJECT_TEXT           '@HN@'."  PS text
ICON_2 ICON_ELEMENT                   '@HO@'."  Elementary data type
ICON_2 ICON_STRUCTURE                 '@HP@'."  Stuctured data type
ICON_2 ICON_WS_WHSE_STOCK             '@HQ@'."  Warehouse stock
ICON_2 ICON_ROUTING                   '@HR@'."  Header
ICON_2 ICON_MATERIAL_ROUTING_ALLOC    '@HS@'."  Material routing assignment
ICON_2 ICON_ROUTING_SUB_OPERATION     '@HT@'."  Suboperation
ICON_2 ICON_ROUTING_REF_SUB_OPERATION '@HU@'."  Referenced suboperation
ICON_2 ICON_ROUTING_SEQUENCE          '@HV@'."  Sequence
ICON_2 ICON_BOM_SUB_ITEM              '@HW@'."  Bill of material (BOM) subitem
ICON_2 ICON_EFFECTIVITY_PERIOD        '@HX@'."  Change status
ICON_2 ICON_KEY_DATE                  '@HY@'."  Key date
ICON_2 ICON_SELECTION_PERIOD          '@HZ@'."  Selection period
ICON_2 ICON_EFF                       '@I0@'."  Parameter validity
ICON_2 ICON_SUPPLY_AREA               '@I1@'."  Production supply area
ICON_2 ICON_REPORT_CALL               '@I2@'."  Call report from report
ICON_2 ICON_ASSIGN                    '@I3@'."  Assign table entry
ICON_2 ICON_UNASSIGN                  '@I4@'."  Undo table entry assignment
ICON_2 ICON_SYSTEM_START_RECORDING    '@I5@'."  Start recording
ICON_2 ICON_SYSTEM_PLAY               '@I6@'."  Run CATT
ICON_2 ICON_TRANSLATION               '@I7@'."  Translate
ICON_2 ICON_TRANSLATION_SHOW          '@I8@'."  Display translation
ICON_2 ICON_CHANGE_PASSWORD           '@I9@'."  Change password
ICON_2 ICON_DISTRIBUTE                '@IA@'."  Distribute entries
ICON_2 ICON_SYSTEMS                   '@IB@'."  Call systems
ICON_2 ICON_ACTIVITY_GROUP            '@IC@'."  Authorizations activity group
ICON_2 ICON_USERGROUP                 '@ID@'."  Authorizations user group
ICON_2 ICON_UNLINK                    '@IE@'."  Undo assignment
ICON_2 ICON_CONTENT_OBJECT            '@IF@'."  Document
ICON_2 ICON_OBJECT_LIST               '@IG@'."  List
ICON_2 ICON_FOLDER                    '@IH@'."  Folder
ICON_2 ICON_DIFFERENCE                '@II@'."  Determine difference
ICON_2 ICON_DIFFERENCE_BACK           '@IJ@'."  Undo "Determine difference"
ICON_2 ICON_SYSTEM_DESELECT           '@IK@'."  Deselect
ICON_2 ICON_ADOPT                     '@IL@'."  Copy object
ICON_2 ICON_TERMINOLOGY               '@IM@'."  Terminology
ICON_2 ICON_TRIANGULAR_RELATIONSHIP   '@IN@'."  Triangular relationship
ICON_2 ICON_AEW_PROJECT               '@IO@'."  Display a project
ICON_2 ICON_SICKNESS                  '@IP@'."  Illness
ICON_2 ICON_HOLIDAY                   '@IQ@'."  Leave (Vacation)
ICON_2 ICON_ROLE                      '@IR@'."  Standard administrator role
ICON_2 ICON_PERSONNEL_ADMINISTRATION  '@IS@'."  Personnel administration
ICON_2 ICON_PDF                       '@IT@'."  Adobe Acrobat document
ICON_2 ICON_BMP                       '@IU@'."  Bitmap image
ICON_2 ICON_FAX_DOC                   '@IV@'."  Fax document
ICON_2 ICON_GIF                       '@IW@'."  GIF image
ICON_2 ICON_HLP                       '@IX@'."  Help file
ICON_2 ICON_HTT                       '@IY@'."  Hypertext template
ICON_2 ICON_ITS                       '@IZ@'."  Internet document set
ICON_2 ICON_JPG                       '@J0@'."  JPEG Image
ICON_2 ICON_MSG                       '@J1@'."  E-mail message
ICON_2 ICON_XLS                       '@J2@'."  MS Excel worksheet
ICON_2 ICON_XLV                       '@J3@'."  MS Excel VBA module
ICON_2 ICON_HTM                       '@J4@'."  HTML document
ICON_2 ICON_PPT                       '@J5@'."  MS PowerPoint presentation
ICON_2 ICON_DOT                       '@J6@'."  MS Word template
ICON_2 ICON_DOC                       '@J7@'."  MS Word document
ICON_2 ICON_EML                       '@J8@'."  MS Outlook express e-mail messa
ICON_2 ICON_RTF                       '@J9@'."  Rich text format document
ICON_2 ICON_TIF                       '@JA@'."  TIF image document
ICON_2 ICON_WRI                       '@JB@'."  Notepad document
ICON_2 ICON_LWP                       '@JC@'."  Lotus WordPro 97 document
ICON_2 ICON_LOTUS                     '@JD@'."  Lotus 1-2-3 workbook
ICON_2 ICON_VSD                       '@JE@'."  Visio document
ICON_2 ICON_DEFAULT_WINDOWS           '@JF@'."  Default Windows icon
ICON_2 ICON_DISPLAY_TREE              '@JG@'."  Display tree
ICON_2 ICON_EXTENDED_SEARCH           '@JH@'."  Extended search
ICON_2 ICON_CLOSE_OBJECT              '@JI@'."  Close object
ICON_2 ICON_OPEN                      '@JJ@'."  Open object
ICON_2 ICON_POLICY                    '@JK@'."  Display/define policy data
ICON_2 ICON_PAYMENT                   '@JL@'."  Display/define payment
ICON_2 ICON_CATASTROPHE               '@JM@'."  Display/define catastrophe
ICON_2 ICON_AGGREGATE                 '@JN@'."  Bundle of claims
ICON_2 ICON_SUBCLAIM_PERSONAL_INJURY  '@JO@'."  Invasion of personal privacy
ICON_2 ICON_SUB_INTELLECTUAL_PROPERTY '@JP@'."  Subclaim "Intellectual property
ICON_2 ICON_SUBCLAIM_VEHICLE          '@JQ@'."  Subclaim "Vehicle"
ICON_2 ICON_SUB_PERSONAL_PROPERTY     '@JR@'."  Subclaim "Personal property"
ICON_2 ICON_SUBCLAIM_BUILDING         '@JS@'."  Subclaim "Building"
ICON_2 ICON_SUB_BODILY_INJURY_TREAT   '@JT@'."  Treatment of injuries
ICON_2 ICON_SUBCLAIM_BODILY_INJURY    '@JU@'."  Personal injury
ICON_2 ICON_SUB_ENVRONMENTAL_SITE     '@JV@'."  Environmental damage
ICON_2 ICON_SUB_FINANCIAL_IMPAIRMENT  '@JW@'."  Economic loss
ICON_2 ICON_BW_PROCESS                '@JX@'."
ICON_2 ICON_BW_SIMULATE               '@JY@'."
ICON_2 ICON_BW_PROCESS_CANCEL         '@JZ@'."
ICON_2 ICON_BW_SIMULATE_CANCEL        '@K0@'."
ICON_2 ICON_DATA_AREA_EXPAND          '@K1@'."  Expand data areas
ICON_2 ICON_DATA_AREA_COLLAPSE        '@K2@'."  Collapse data areas
ICON_2 ICON_SCRAP                     '@K3@'."  Production scrap
ICON_2 ICON_IMPORT_ALL_REQUESTS       '@K4@'."  Import all
ICON_2 ICON_IMPORT_TRANSPORT_REQUEST  '@K5@'."  Import request
ICON_2 ICON_TOGGLE_DISPLAY            '@K6@'."  Toggle overview / detail view
ICON_2 ICON_TOGGLE_FUNCTION           '@K7@'."  Toggle standard mode / expert m
ICON_2 ICON_PERSONAL_SETTINGS         '@K8@'."  Settings
ICON_2 ICON_PROJECT                   '@K9@'."  Project
ICON_2 ICON_INCLUDE_OBJECTS           '@KA@'."  Include objects
ICON_2 ICON_TRANSFER                  '@KB@'."  Transfer
ICON_2 ICON_DISTRIBUTE_CONFIGURATION  '@KC@'."  Distribute configuration
ICON_2 ICON_ADJUST_CONFIGURATION      '@KD@'."  Synchronize configuration
ICON_2 ICON_STANDARD_CONFIGURATION    '@KE@'."  Standard configuration
ICON_2 ICON_MODIFIED_OBJECT           '@KF@'."  Revised
ICON_2 ICON_SELECT_WITH_CONDITION     '@KG@'."  Select with filter
ICON_2 ICON_ADDRESS_LIST              '@KH@'."  Address element
ICON_2 ICON_APPOINTMENT_COMPARISON    '@KI@'."  Compare appointment
ICON_2 ICON_BUSINESS_PARTNER_MASTER_D '@KJ@'."  Business partner master data
ICON_2 ICON_INCOMPLETION_LOG          '@KK@'."  Incompleteness log
ICON_2 ICON_MESSAGE                   '@KL@'."  Message
ICON_2 ICON_TELEPHONE_CALL            '@KM@'."  Telephone call
ICON_2 ICON_VISIT                     '@KN@'."  Visit
ICON_2 ICON_LETTER                    '@KO@'."  Letter
ICON_2 ICON_OPERATOR                  '@KP@'."  Operator
ICON_2 ICON_SYSTEM_ADMINISTRATOR      '@KQ@'."  System administrator
ICON_2 ICON_SAP                       '@KR@'."  SAP
ICON_2 ICON_PUBLIC                    '@KS@'."  Public
ICON_2 ICON_SUMMARIZE                 '@KT@'."  Summarize key fields
ICON_2 ICON_SUMMARIZE_UNDO            '@KU@'."  Undo summarization
ICON_2 ICON_SUM_RED                   '@KV@'."  Number of units with errors
ICON_2 ICON_UNSPECIFIED_ONE           '@KW@'."  Not specifed (1)
ICON_2 ICON_UNSPECIFIED_TWO           '@KX@'."  Not specifed (2)
ICON_2 ICON_UNSPECIFIED_THREE         '@KY@'."  Not specified (3)
ICON_2 ICON_UNSPECIFIED_FOUR          '@KZ@'."  Not specified (4)
ICON_2 ICON_UNSPECIFIED_FIVE          '@L0@'."  Not specified (5)
ICON_2 ICON_HR_MANAGER                '@L1@'."  Manager
ICON_2 ICON_TBH                       '@L2@'."  Position to be filled
ICON_2 ICON_TBH_HOLD                  '@L3@'."  Position on hold
ICON_2 ICON_NEW_EMPLOYEE              '@L4@'."  New employee
ICON_2 ICON_INCOMING_EMPLOYEE         '@L5@'."  Incoming employee
ICON_2 ICON_OUTGOING_EMPLOYEE         '@L6@'."  Outgoing employee
ICON_2 ICON_OBSOLETE_POSITION         '@L7@'."  Obsolete position
ICON_2 ICON_TERMINATED_POSITION       '@L8@'."  Delimited position
ICON_2 ICON_SHARED_POSITION           '@L9@'."  Shared position
ICON_2 ICON_OBSOLETE_SHARED_POSITION  '@LA@'."  Obsolete shared position
ICON_2 ICON_TERMINATED_SHARED_POSITIO '@LB@'."  Delimited shared position
ICON_2 ICON_HR_POSITION               '@LC@'."  Position
ICON_2 ICON_CREATE_POSITION           '@LD@'."  Create position
ICON_2 ICON_HR_ORG_UNIT               '@LE@'."  Organizational Unit
ICON_2 ICON_TERMINATED_ORG_UNIT       '@LF@'."  Delimited organizational unit
ICON_2 ICON_NEW_ORG_UNIT              '@LG@'."  Create organizational unit
ICON_2 ICON_OUTGOING_ORG_UNIT         '@LH@'."  Limited assignment
ICON_2 ICON_INCOMING_ORG_UNIT         '@LI@'."  New organizational unit
ICON_2 ICON_NEW_TASK                  '@LJ@'."  New task
ICON_2 ICON_TERMINATED_TASK           '@LK@'."  Delimited task
ICON_2 ICON_OUTGOING_TASK             '@LL@'."  Delimited task assignment
ICON_2 ICON_INCOMING_TASK             '@LM@'."  Reassign task
ICON_2 ICON_OUTGOING_JOB              '@LN@'."  Delimited job assignment
ICON_2 ICON_INCOMING_JOB              '@LO@'."  Job reassigned
ICON_2 ICON_NEW_JOB                   '@LP@'."  Create job
ICON_2 ICON_TERMINATED_JOB            '@LQ@'."  Delimited job
ICON_2 ICON_INCOMING_OBJECT           '@LR@'."  Object reassigned
ICON_2 ICON_OUTGOING_OBJECT           '@LS@'."  Delimited object assignment
ICON_2 ICON_WS_START_WHSE_PROC_BACKGR '@LT@'."  Start warehouse process in the
ICON_2 ICON_WS_START_WHSE_PROC_FOREGR '@LU@'."  Start warehouse process in the
ICON_2 ICON_WS_CONFIRM_WHSE_PROC_BACK '@LV@'."  Confirm warehouse process in th
ICON_2 ICON_WS_CONFIRM_WHSE_PROC_FORE '@LW@'."  Confirm warehouse process in th
ICON_2 ICON_HOLD                      '@LX@'."  Hold dialog box
ICON_2 ICON_HOLD_UNDO                 '@LY@'."  Release hold
ICON_2 ICON_ALV_VARIANTS              '@LZ@'."  Display variants
ICON_2 ICON_TE_FLAT_RATE              '@M0@'."  Per diem rates
ICON_2 ICON_BIW_SOURCE_SYS_OWN        '@M1@'."  Source system (own system)
ICON_2 ICON_WORKFLOW_JOIN             '@M2@'."  Join Workflow
ICON_2 ICON_WORKFLOW_PROCESS          '@M3@'."  Workflow process
ICON_2 ICON_BACKGROUND_JOB            '@M4@'."  Background job
ICON_2 ICON_JOB_DETAIL                '@M5@'."  Background job, details
ICON_2 ICON_SYSTEMTYPE                '@M6@'."  System type
ICON_2 ICON_COMPOSITE_ACTIVITYGROUP   '@M7@'."  Composite activity group
ICON_2 ICON_TREND_DOWN                '@M8@'."  Downward trend
ICON_2 ICON_TREND_DECREASING          '@M9@'."  Slight downward trend
ICON_2 ICON_TREND_UNCHANGED           '@MA@'."  Stagnant trend
ICON_2 ICON_TREND_RISING              '@MB@'."  Slight upward trend
ICON_2 ICON_TREND_UP                  '@MC@'."  Upward trend
ICON_2 ICON_STATUS_ALERT              '@MD@'."  Status critical
ICON_2 ICON_STATUS_OK                 '@ME@'."  Status good
ICON_2 ICON_STATUS_BEST               '@MF@'."  Status very good
ICON_2 ICON_NO_STATUS                 '@MG@'."  No status
ICON_2 ICON_DRAW_SELECT               '@MH@'."  Select redlining object
ICON_2 ICON_DRAW_FREEHAND             '@MI@'."  Draw line freehand
ICON_2 ICON_DRAW_ARROW                '@MJ@'."  Draw pointer
ICON_2 ICON_DRAW_LINE                 '@MK@'."  Draw line
ICON_2 ICON_DRAW_POLYLINE             '@ML@'."  Draw polyline
ICON_2 ICON_DRAW_ELLIPSE              '@MM@'."  Draw ellipse
ICON_2 ICON_DRAW_POLYGON              '@MN@'."  Draw polygon
ICON_2 ICON_DRAW_RECTANGLE            '@MO@'."  Draw rectangle
ICON_2 ICON_DRAW_ANGULAR              '@MP@'."  Angle measure
ICON_2 ICON_DRAW_LINEAR               '@MQ@'."  Linear measure
ICON_2 ICON_DRAW_RADIAL               '@MR@'."  radius measure
ICON_2 ICON_BW_EXCEPTION_MONITOR      '@MS@'."  Exception monitor
ICON_2 ICON_BOOKMARK                  '@MT@'."  ation status of a query
ICON_2 ICON_TRANSFER_STRUCTURE_INA    '@MU@'."  Transfer structure (inactive)
ICON_2 ICON_EXCEPTION                 '@MV@'."  Exception in reporting
ICON_2 ICON_RANKING                   '@MW@'."  Ranking list
ICON_2 ICON_PPE_BHNODE                '@MX@'."  Assembly header node
ICON_2 ICON_PPE_AENODE                '@MY@'."  Assembly change status
ICON_2 ICON_PPE_ANODE                 '@MZ@'."  Structure node alternative
ICON_2 ICON_PPE_CVNODE                '@N0@'."  Variant change status
ICON_2 ICON_PPE_SNODE                 '@N1@'."  Structure node with variants
ICON_2 ICON_PPE_ENODE                 '@N2@'."  Access node
ICON_2 ICON_PPE_APNODE                '@N3@'."  Activity plan
ICON_2 ICON_PPE_VNODE                 '@N4@'."  Grouping node
ICON_2 ICON_PPE_MODNODE               '@N5@'."  Mode
ICON_2 ICON_PPE_AANODE                '@N6@'."  Alternative relationship
ICON_2 ICON_PPE_AAEXPNODE             '@N7@'."  Alternative decomposition
ICON_2 ICON_PPE_OPNODE                '@N8@'."  Operation
ICON_2 ICON_PPE_ACTNODE               '@N9@'."  Activity
ICON_2 ICON_PPE_VACTNODE              '@NA@'."  Grouping activity
ICON_2 ICON_PPE_VANODE                '@NB@'."  Buffer
ICON_2 ICON_PPE_LSEG                  '@NC@'."  Line segment
ICON_2 ICON_PPE_PLINE                 '@ND@'."  Production line
ICON_2 ICON_PPE_BPNODE                '@NE@'."  Assembly Item node
ICON_2 ICON_GIS_BAR                   '@NF@'."  GANTT chart
ICON_2 ICON_GIS_COLOR_SHADING         '@NG@'."  Line graph
ICON_2 ICON_GIS_DEMOTE                '@NH@'."  Layer down
ICON_2 ICON_GIS_DOT_DENSITY           '@NI@'."  Dot density graph
ICON_2 ICON_GIS_LAYER_PROPERTIES      '@NJ@'."  Map settings
ICON_2 ICON_GIS_PAN                   '@NK@'."  Pan
ICON_2 ICON_GIS_PIE                   '@NL@'."  Pie chart
ICON_2 ICON_GIS_PROMOTE               '@NM@'."  Layer up
ICON_2 ICON_GIS_SPATIAL_SELECT        '@NN@'."  Select map objects
ICON_2 ICON_GIS_SYMBOL                '@NO@'."  Symbol chart
ICON_2 ICON_CALL_ANSWER               '@NP@'."  Answer telephone call
ICON_2 ICON_CALL_ALTERNATE            '@NQ@'."  Alternate active/hold
ICON_2 ICON_CALL_HOLD                 '@NR@'."  Put active call on hold
ICON_2 ICON_CALL_DEFLECT              '@NS@'."  Deflect an incoming call
ICON_2 ICON_CALL_CONSULT              '@NT@'."  Issue a consultation call
ICON_2 ICON_CALL_CONFERENCE           '@NU@'."  Establish a conference call
ICON_2 ICON_CALL_BLIND_TRANSFER       '@NV@'."  Perform blind transfer
ICON_2 ICON_CALL_RECONNECT            '@NW@'."  Reconnect after consultation
ICON_2 ICON_CALL_RETRIEVE             '@NX@'."  Retrieve call from hold
ICON_2 ICON_CALL_WARM_TRANSFER        '@NY@'."  Warm transfer
ICON_2 ICON_CREATE_CALLBACK           '@NZ@'."  Create callback
ICON_2 ICON_PROCESS_CALLBACK          '@O0@'."  Process callback
ICON_2 ICON_BW_RA_SETTING_ACTIVE      '@O1@'."  Reporting agent: active
ICON_2 ICON_BW_RA_SETTING_INACTIVE    '@O2@'."  Reporting agent: inactive
ICON_2 ICON_SNC_INFO                  '@O3@'."  SNC information
ICON_2 ICON_DELIVERY                  '@O4@'."  Delivery
ICON_2 ICON_PPE_ASSY_POS              '@O5@'."  Single-level BOM item
ICON_2 ICON_PPE_ASSY_HEAD             '@O6@'."  Single-level BOM header
ICON_2 ICON_PPE_PARTOF_ALT_ACT        '@O7@'."  Alternative decomposition of ac
ICON_2 ICON_BINARY_DOCUMENT           '@O8@'."  Binary document
ICON_2 ICON_ANY_DOCUMENT              '@O9@'."  Unknown document type
ICON_2 ICON_OTF_DOCUMENT              '@OA@'."  Document with OTF data
ICON_2 ICON_TEXT_FIELD                '@OB@'."  Text field
ICON_2 ICON_FIELD_WITH_TEXT           '@OC@'."  Field with text
ICON_2 ICON_SIMPLE_FIELD              '@OD@'."  Simple field
ICON_2 ICON_TRANSPORT_PROPOSAL        '@OE@'."  Create transport proposal
ICON_2 ICON_HELPASSISTENT_ON          '@OF@'."  Activate Help Assistant
ICON_2 ICON_HELPASSISTENT_OFF         '@OG@'."  Deactivate Help Assistant
ICON_2 ICON_DIALGHELP                 '@OH@'."  Context help
ICON_2 ICON_DIALOGHELPACTIV           '@OI@'."  Current context help
ICON_2 ICON_STATUS_CRITICAL           '@OJ@'."  Status very critical
ICON_2 ICON_SYSTEM_SERVICE_FILLED     '@OK@'."  Service entries exist
ICON_2 ICON_SYSTEM_SERVICE_OFF        '@OL@'."  Service not available
ICON_2 ICON_SYSTEM_SERVICE_EMPTY      '@OM@'."  Service available
ICON_2 ICON_CONSUMPTION_ALTERNATIVE   '@ON@'."  Consumption alternative
ICON_2 ICON_PROCUREMENT_ALTERNATIVE   '@OO@'."  Procurement alternative
ICON_2 ICON_PROCUREMENT_PROCESS       '@OP@'."  Procurement process
ICON_2 ICON_WORKFLOW                  '@OQ@'."  Workflow
ICON_2 ICON_DOCUMENT_MODEL_SPACE      '@OR@'."  Document modeling space
ICON_2 ICON_RELATION_CLASS            '@OS@'."  Relation class
ICON_2 ICON_IO_ATTRIBUTE              '@OT@'."  Attribute definition
ICON_2 ICON_VIRTUAL_RELATION_CLASS    '@OU@'."  Virtual relation class
ICON_2 ICON_CLASS_CONNECTION_SPACE    '@OV@'."  Class connection space
ICON_2 ICON_IO_PREDEFINED_VALUE       '@OW@'."  Attribute definition constant
ICON_2 ICON_CONTEXT_CLASS             '@OX@'."  Context class
ICON_2 ICON_LOIO_CLASS                '@OY@'."  Logical info object class
ICON_2 ICON_VIRTUAL_LOIO_CLASS        '@OZ@'."  Virtual logical info object cla
ICON_2 ICON_PHIO_CLASS                '@P0@'."  Physical info object class
ICON_2 ICON_VIRTUAL_PHIO_CLASS        '@P1@'."  Virtual physical info object cl
ICON_2 ICON_PARAGRAPH                 '@P2@'."  Show/Hide paragraph marks
ICON_2 ICON_MC_CONTENTINDICATOR       '@P3@'."  Show management cockpit
ICON_2 ICON_BSC_CONTENTINDICATOR      '@P4@'."  Show balanced scorecard
ICON_2 ICON_RATING_MINUSMINUS         '@P5@'."  --
ICON_2 ICON_RATING_MINUS              '@P6@'."  -
ICON_2 ICON_RATING_NEUTRAL            '@P7@'."  0
ICON_2 ICON_RATING_POSITIVE           '@P8@'."  +
ICON_2 ICON_RATING_POSITIVEPOSITIVE   '@P9@'."  ++
ICON_2 ICON_WORKFLOW_WEB_ACTIVITY     '@PA@'."  Web activity step type
ICON_2 ICON_DELIVERY_NO_CONFIRMATION  '@PB@'."  Continue without confirming
ICON_2 ICON_SNAP_TO_GRID              '@PC@'."  Snap to grid+F912
ICON_2 ICON_GRID                      '@PD@'."  Grid
ICON_2 ICON_MAIN_GRID                 '@PE@'."  Main grid
ICON_2 ICON_TARGET_GROUP              '@PF@'."  Target group
ICON_2 ICON_DELIVERY_INBOUND          '@PG@'."  Delivery
ICON_2 ICON_PPE_LBAL                  '@PH@'."  Line balancing
ICON_2 ICON_PPE_ENTOBJ                '@PI@'."  Initial object for integrated P
ICON_2 ICON_PAW_TEST                  '@PJ@'."  Test for Performance Assessment
ICON_2 ICON_PAW_SUBTEST               '@PK@'."  Subtest for a Performance Asses
ICON_2 ICON_PAW_PU                    '@PL@'."  Performance unit
ICON_2 ICON_PAW_ITEM                  '@PM@'."  Test item for a Performance Ass
ICON_2 ICON_BUSINESS_AREA             '@PN@'."  Business area
ICON_2 ICON_DATABASE_TABLE            '@PO@'."  Database table
ICON_2 ICON_DATABASE_TABLE_INA        '@PP@'."  Inactive database table
ICON_2 ICON_CONNECTION_OBJECT         '@PQ@'."  Connection object
ICON_2 ICON_CONTRACT_ACCOUNT          '@PR@'."  Contract account
ICON_2 ICON_REGISTER                  '@PS@'."  Register
ICON_2 ICON_INSTALLATION              '@PT@'."  Installation
ICON_2 ICON_BORDER_TOP                '@PU@'."  Top border
ICON_2 ICON_BORDER_RIGHT              '@PV@'."  Right border
ICON_2 ICON_BORDER_OUTSIDE            '@PW@'."  Outside border
ICON_2 ICON_BORDER_LEFT               '@PX@'."  Left border
ICON_2 ICON_BORDER_BOTTOM             '@PY@'."  Bottom border
ICON_2 ICON_BORDER_INSIDE             '@PZ@'."  Inside border
ICON_2 ICON_DELETE_TEMPLATE           '@Q0@'."  Reset template
ICON_2 ICON_SAVE_AS_TEMPLATE          '@Q1@'."  Store entries as a template
ICON_2 ICON_PATIENT_SMARTCARD         '@Q2@'."  Transfer healthcare smartcard
ICON_2 ICON_INITIAL                   '@Q3@'."  Blank, new, open
ICON_2 ICON_GENERAL_RECIPE            '@Q4@'."  General recipe
ICON_2 ICON_WORKFLOW_ADHOC_ANCHOR     '@Q5@'."  Placeholder
ICON_2 ICON_PRICE_ANALYSIS            '@Q6@'."  Material price analysis
ICON_2 ICON_COST_COMPONENTS           '@Q7@'."  Cost components
ICON_2 ICON_VAL_QUANTITY_STRUCTURE    '@Q8@'."  Valued quantity structure
ICON_2 ICON_REVALUATED_CONS_ALTERNAT  '@Q9@'."  Revaluable consumption alternat
ICON_2 ICON_PACKAGE_QUERY             '@QA@'."  Query package
ICON_2 ICON_PACKAGE_DYNAMIC           '@QB@'."  Dynamic package
ICON_2 ICON_PACKAGE_STANDARD          '@QC@'."  Standard package
ICON_2 ICON_PACKAGE_APPLICATION       '@QD@'."  Application package
ICON_2 ICON_LINKED_DOCUMENT           '@QE@'."  Linked document
ICON_2 ICON_CLOSED_LINKED_FOLDER      '@QF@'."  Linked folder
ICON_2 ICON_OPEN_LINKED_FOLDER        '@QG@'."  Linked folder (open)
ICON_2 ICON_REPORT_TEMPLATE           '@QH@'."  Formatted report
ICON_2 ICON_INFOSET_ACT               '@QI@'."  Active InfoSet
ICON_2 ICON_INFOSET_INA               '@QJ@'."  Inactive InfoSet
ICON_2 ICON_CHARACTERISTICS_FML       '@QK@'."  Formula performed on a structur
ICON_2 ICON_CHARACTERISTICS_HIER      '@QL@'."  Characteristic with hierarchy
ICON_2 ICON_HIERARCHY_RED             '@QM@'."  Excluded node
ICON_2 ICON_HIERARCHY_VAR_GREEN       '@QN@'."  Included variable node
ICON_2 ICON_HIERARCHY_VAR_RED         '@QO@'."  Excluded variable node
ICON_2 ICON_KEYFIGURE_FML             '@QP@'."  Formula performed on a key figu
ICON_2 ICON_VAR_EQUAL_GREEN           '@QQ@'."  Included variable value
ICON_2 ICON_VAR_EQUAL_RED             '@QR@'."  Excluded variable value
ICON_2 ICON_VAR_GR_EQUAL_GREEN        '@QS@'."  Include values greater than or
ICON_2 ICON_VAR_GREATER_GREEN         '@QT@'."  Include values greater than var
ICON_2 ICON_VAR_LESS_EQUAL_GREEN      '@QU@'."  Include values less than or equ
ICON_2 ICON_VAR_LESS_GREEN            '@QV@'."  Include values less than variab
ICON_2 ICON_VAR_INT_INCLUDE_GREEN     '@QW@'."  Include variable range
ICON_2 ICON_VAR_INT_INCLUDE_RED       '@QX@'."  Exclude variable range
ICON_2 ICON_MULTI_DATA_PROVIDER       '@QY@'."  Multi Data Provider
ICON_2 ICON_MULTI_DATA_PROVIDER_INA   '@QZ@'."  Inactive Multi Data Provider
ICON_2 ICON_BW_SOURCE_SYS_DB          '@R0@'."  Source system: Database
ICON_2 ICON_BW_SOURCE_SYS_WEB         '@R1@'."  Source system: Internet
ICON_2 ICON_BW_DATASOURCE             '@R2@'."  DataSource
ICON_2 ICON_BW_WEB_REPORT             '@R3@'."  BW Web report
ICON_2 ICON_XML_DOC                   '@R4@'."  XML document
ICON_2 ICON_DROPDOWNLIST              '@R5@'."  Dropdown box
ICON_2 ICON_RADIOBUTTON               '@R6@'."  Radio button
ICON_2 ICON_CHECKBOX                  '@R7@'."  Checkbox
ICON_2 ICON_GEO_CHARACTERISTIC        '@R8@'."  Geo-characteristic
ICON_2 ICON_GEO_CHARACTERISTIC_INA    '@R9@'."  Inactive geo-characteristic
ICON_2 ICON_MANIKIN_FEMALE            '@RA@'."  Female
ICON_2 ICON_MANIKIN_MALE              '@RB@'."  Male
ICON_2 ICON_MANIKIN_UNKNOWN_GENDER    '@RC@'."  Unknown gender
ICON_2 ICON_SYMBOL_FEMALE             '@RD@'."  Female
ICON_2 ICON_SYMBOL_MALE               '@RE@'."  Male
ICON_2 ICON_DECEASED_PATIENT          '@RF@'."  Deceased
ICON_2 ICON_WD_APPL_COMPONENT         '@RG@'."  Application Component
ICON_2 ICON_WD_TAG_LIBRARY            '@RH@'."  Tag Library
ICON_2 ICON_WD_TAB_LIBRARY_REF        '@RI@'."
ICON_2 ICON_WD_WEB_PROJECT            '@RJ@'."  Web Project
ICON_2 ICON_WD_WEB_APPL_PROJECT       '@RK@'."  Web Application Project
ICON_2 ICON_WD_INBOUND_PLUG           '@RL@'."  Inbound Plug
ICON_2 ICON_WD_OUTBOUND_PLUG          '@RM@'."  Outbound Plug
ICON_2 ICON_WD_VIEW                   '@RN@'."  View
ICON_2 ICON_WD_VIEWS                  '@RO@'."  Views
ICON_2 ICON_WD_INTERFACE_VIEW         '@RP@'."  Interface View
ICON_2 ICON_WD_INTERFACE_VIEWS        '@RQ@'."  Interface Views
ICON_2 ICON_WD_VIEW_AREA              '@RR@'."  View Area
ICON_2 ICON_WD_VIEW_SET_T_LAYOUT      '@RS@'."  T Layout ViewSet
ICON_2 ICON_WD_VIEW_SET_T_LAYOUT_REV  '@RT@'."  Reverse T Layout ViewSet
ICON_2 ICON_WD_VIEW_SET_T_LAYOUT_270  '@RU@'."  T Layout 270° ViewSet
ICON_2 ICON_WD_VIEW_SET_T_LAYOUT_90   '@RV@'."  T Layout 90° ViewSet
ICON_2 ICON_WD_VIEW_SET_TAB_LAYOUT    '@RW@'."  Tab Layout ViewSet
ICON_2 ICON_WD_VIEW_SET_GRID          '@RX@'."  Grid ViewSet
ICON_2 ICON_WD_VIEW_CONTAINER         '@RY@'."  View Container
ICON_2 ICON_WD_WINDOWS_COLLECTION     '@RZ@'."  Windows Collection
ICON_2 ICON_WD_WINDOW                 '@S0@'."  Window
ICON_2 ICON_WD_BUILD_ALL              '@S1@'."  Build all
ICON_2 ICON_WD_BUILD_INCREMENTAL      '@S2@'."  Build Incremental
ICON_2 ICON_WD_COMPONENTS             '@S3@'."  Components
ICON_2 ICON_WD_COMPONENT              '@S4@'."  Component
ICON_2 ICON_WD_COMPONENT_INTERFACE    '@S5@'."  Component Interface
ICON_2 ICON_WD_APPLICATION            '@S6@'."  Application
ICON_2 ICON_WD_APPLICATIONS           '@S7@'."  Applications
ICON_2 ICON_WD_CONTEXT                '@S8@'."  Context
ICON_2 ICON_WD_VALUE_NODE             '@S9@'."  Value Node
ICON_2 ICON_WD_VALUE_ATTR             '@SA@'."
ICON_2 ICON_WD_MAPPED_VALUE_NODE      '@SB@'."  Mapped Value Node
ICON_2 ICON_WD_MAPPED_VALUE_ATTR      '@SC@'."  Mapped Value Attribute
ICON_2 ICON_WD_MODEL_NODE             '@SD@'."  Model Node
ICON_2 ICON_WD_MODEL_ATTRIBUTE        '@SE@'."  Model Attribute
ICON_2 ICON_WD_MAPPED_MODEL_NODE      '@SF@'."  Mapped Model Node
ICON_2 ICON_WD_MAPPED_MODEL_ATTR      '@SG@'."  Mapped Model Attribute
ICON_2 ICON_WD_RECURSION_NODE         '@SH@'."  Recursion Node
ICON_2 ICON_WD_IMAGE                  '@SI@'."  Image
ICON_2 ICON_WD_CAPTION                '@SJ@'."  Caption
ICON_2 ICON_WD_BUSINESS_GRAPHICS      '@SK@'."  Business Graphics
ICON_2 ICON_WD_LABEL                  '@SL@'."  Label
ICON_2 ICON_WD_INPUT_FIELD            '@SM@'."  Input Field
ICON_2 ICON_WD_NUMERIC_VALUE          '@SN@'."  Numeric Value
ICON_2 ICON_WD_TIME_VALUE             '@SO@'."  Time Value
ICON_2 ICON_WD_CHECK_BOX_INDEXED      '@SP@'."  Checkbox (indexed)
ICON_2 ICON_WD_CHECK_BOX_GROUP        '@SQ@'."  Checkbox Group
ICON_2 ICON_WD_RADIO_BUTTON_EMPTY     '@SR@'."  Radio Button (empty)
ICON_2 ICON_WD_RADIO_BUTTON_INDEX     '@SS@'."  Radio Button Group by Index
ICON_2 ICON_WD_RADIO_BUTTON_KEY       '@ST@'."  Radio Button Group by Key
ICON_2 ICON_WD_DROPDOWN_INDEX         '@SU@'."  Dropdown by Index
ICON_2 ICON_WD_DROPDOWN_KEY           '@SV@'."  Dropdown by Key
ICON_2 ICON_WD_LINK_TO_ACTION         '@SW@'."  Link To Action
ICON_2 ICON_WD_LINK_TO_URL            '@SX@'."  Link To URL
ICON_2 ICON_WD_TOOLBAR_BUTTON         '@SY@'."  Toolbar Button
ICON_2 ICON_WD_TOOLBAR_DROPDOWN_IDX   '@SZ@'."  Toolbar Dropdown by Index
ICON_2 ICON_WD_TOOLBAR_DROPDOWN_KEY   '@T0@'."  Toolbar Dropdown by Key
ICON_2 ICON_WD_TOOLBAR_INPUT_FIELD    '@T1@'."  Toolbar Inputfield
ICON_2 ICON_WD_TOOLBAR_SEPARATOR      '@T2@'."  Toolbar Separator
ICON_2 ICON_WD_TOOLBAR_CAPTION        '@T3@'."  Toolbar Caption
ICON_2 ICON_WD_TABLE                  '@T4@'."  Table
ICON_2 ICON_WD_TABLE_COLUMN           '@T5@'."  Table Column
ICON_2 ICON_WD_TREE                   '@T6@'."  Tree
ICON_2 ICON_WD_TREE_NODE              '@T7@'."  Tree Node
ICON_2 ICON_WD_TREE_ITEM              '@T8@'."  Tree Item
ICON_2 ICON_WD_IFRAME                 '@T9@'."  IFrame
ICON_2 ICON_WD_CHECK_BOX              '@TA@'."  Checkbox
ICON_2 ICON_WD_RADIO_BUTTON           '@TB@'."  Radio Button
ICON_2 ICON_WD_BUTTON                 '@TC@'."  Button
ICON_2 ICON_WD_TEXT_VIEW              '@TD@'."  Text View
ICON_2 ICON_WD_TEXT_EDIT              '@TE@'."  Text Edit
ICON_2 ICON_WD_TOOLBAR                '@TF@'."  Toolbar
ICON_2 ICON_WD_TABSTRIP               '@TG@'."  Tabstrip
ICON_2 ICON_WD_TAB                    '@TH@'."  Tab
ICON_2 ICON_WD_GROUP                  '@TI@'."  Group
ICON_2 ICON_WD_TRAY                   '@TJ@'."  Tray
ICON_2 ICON_WD_TRANSPARENT_CONTAINER  '@TK@'."  Transparent Container
ICON_2 ICON_WD_SCROLL_CONTAINER       '@TL@'."  Scroll Container
ICON_2 ICON_WD_NAVIGATION_LINK        '@TM@'."  Navigation Link
ICON_2 ICON_WD_NAVLINK_BIDIRECTIONAL  '@TN@'."  Navigation Link Bidirectional
ICON_2 ICON_WD_NAVLINK_OUT            '@TO@'."  Navigation Link Out
ICON_2 ICON_WD_NAVLINK_IN             '@TP@'."  Navigation Link In
ICON_2 ICON_WD_CONTROLLER             '@TQ@'."  Controller
ICON_2 ICON_CONTEXT_MENU              '@TR@'."  Context Menu
ICON_2 ICON_ERASE                     '@TS@'."  Eraser
ICON_2 ICON_RETAIL_PRODUCT            '@TT@'."  Retail Product
ICON_2 ICON_RETAIL_STORE              '@TU@'."  Retail Store
ICON_2 ICON_HANDLING_UNIT             '@TV@'."  Handling Unit
ICON_2 ICON_BW_DM                     '@TW@'."  SAP Data Mining
ICON_2 ICON_BW_APD_VISUALIZATION      '@TX@'."  Visualization
ICON_2 ICON_BW_APD_TARGET             '@TY@'."  Target
ICON_2 ICON_BW_APD_TRANSFORMATION     '@TZ@'."  Transformation
ICON_2 ICON_BW_APD_SOURCE             '@U0@'."  Source
ICON_2 ICON_BW_APD_COLUMN_TO_ROW      '@U1@'."  Column to row
ICON_2 ICON_BW_APD_ROW_TO_COLUMN      '@U2@'."  Row to column
ICON_2 ICON_BW_APD_DB                 '@U3@'."  Database table
ICON_2 ICON_BW_APD                    '@U4@'."  Analysis Process
ICON_2 ICON_BW_DM_3RD                 '@U5@'."  3rd Party Data Mining
ICON_2 ICON_BW_DM_WST                 '@U6@'."  Weighted Score Tables
ICON_2 ICON_BW_APD_REGRESSION         '@U7@'."  Regression
ICON_2 ICON_BW_DM_CLUS                '@U8@'."  Clustering
ICON_2 ICON_BW_DM_AA                  '@U9@'."  Association Analysis
ICON_2 ICON_BW_DM_DT                  '@UA@'."  Decision Tree
ICON_2 ICON_BW_CONVERT_UNIT           '@UB@'."  Unit Conversion
ICON_2 ICON_BW_PLANNING_LAYER         '@UC@'."  Planning Layer
ICON_2 ICON_BW_PLANNING_LAYER_INA     '@UD@'."  Planning Layer, inactive
ICON_2 ICON_BW_OPEN_HUB_DESTINATION   '@UE@'."  Open Hub Destination
ICON_2 ICON_BW_ROTATE_RIGHT           '@UF@'."  Rotate Right
ICON_2 ICON_BW_ROTATE_LEFT            '@UG@'."  Rotate Left
ICON_2 ICON_VIEW_FORM                 '@UH@'."  Form View
ICON_2 ICON_VIEW_LIST                 '@UI@'."  List View
ICON_2 ICON_MEDIUM                    '@UJ@'."  Medium View Size
ICON_2 ICON_VIEW_MAXIMIZE             '@UK@'."  Maximize View
ICON_2 ICON_VIEW_EXPAND_VERTICAL      '@UL@'."  Expand View Vertical
ICON_2 ICON_VIEW_EXPAND_HORIZONTAL    '@UM@'."  Expand View Horizontal
ICON_2 ICON_VIEW_REFRESH              '@UN@'."  Refresh View
ICON_2 ICON_VIEW_CREATE               '@UO@'."  Create a view
ICON_2 ICON_VIEW_CLOSE                '@UP@'."  Close a view
ICON_2 ICON_VIEW_SWITCH               '@UQ@'."  Switch Views
ICON_2 ICON_BREAKPOINT_DISABLE        '@UR@'."  Disable Breakpoint
ICON_2 ICON_WD_CUSTOM_CONTROLLER      '@US@'."  Custom Controller
ICON_2 ICON_WD_CUSTOM_CONTROLLERS     '@UT@'."  Custom Controllers
ICON_2 ICON_WD_INPUT_MODEL_ATT        '@UU@'."  InputModelAttribute
ICON_2 ICON_WD_INPUT_MODEL_NODE       '@UV@'."  InputModelNode
ICON_2 ICON_WD_INPUT_VAL_ATT          '@UW@'."  InputValueAttribute
ICON_2 ICON_WD_INPUT_VAL_NODE         '@UX@'."  InputValueNode
ICON_2 ICON_WD_MAPPED_INPUT_MODEL_ATT '@UY@'."  MappedInputModelAttribute
ICON_2 ICON_WD_MAPPED_INPUT_MODEL_NOD '@UZ@'."  MappedInputModelNode
ICON_2 ICON_WD_MAPPED_INPUT_VAL_ATT   '@V0@'."  MappedInputValueAttribute
ICON_2 ICON_WD_MAPPED_INPUT_VAL_NODE  '@V1@'."  MappedInputValueNode
ICON_2 ICON_WD_COMPONENT_CTRL         '@V2@'."  ComponentController
ICON_2 ICON_WD_COMPONENT_CTRL_USAGE   '@V3@'."  ComponentControllerUsage
ICON_2 ICON_WD_COMPONENT_IF_CTRL      '@V4@'."  Component Interface Controller
ICON_2 ICON_COMPONENT_IF_DEF          '@V5@'."  Component Interface Definition
ICON_2 ICON_COMPONENT_IF_DEFS         '@V6@'."  Component Interface Definitions
ICON_2 ICON_WD_COMPONENT_USAGE        '@V7@'."  Component Usage
ICON_2 ICON_WD_COMPONENT_USAGES       '@V8@'."  Component Usages
ICON_2 ICON_WEBBREAKPOINT             '@V9@'."  Web Breakpoint
ICON_2 ICON_WEBBREAKPOINT_DISABLED    '@VA@'."  Disabled Web Breakpoint
ICON_2 ICON_USER_BREAKPOINT           '@VB@'."  Benutzerspezifischer Haltepunkt
ICON_2 ICON_USER_BREAKPOINT_DISABLED  '@VC@'."  Deaktivierter Benutzerhaltepunk
ICON_2 ICON_CLIENT_BREAKPOINT         '@VD@'."  Modushaltepunkt
ICON_2 ICON_CLIENT_BREAKPOINT_DIS     '@VE@'."  Deaktivierter Modushaltepunkt
ICON_2 ICON_ES_REPOSITORY             '@VF@'."  Enterprise Service Repository
ICON_2 ICON_RED_DASH                  '@VG@'."  Red Dash
ICON_2 ICON_RED_SLASH                 '@VH@'."  Red Slash
ICON_2 ICON_RED_XCIRCLE               '@VI@'."  Red Cross in Circle
ICON_2 ICON_VALUE_HELP                '@VJ@'."  Value Help
ICON_2 ICON_BW_DTP_ACTIVE             '@VK@'."  Data Transfer Process
ICON_2 ICON_BW_DTP_INACTIVE           '@VL@'."  Data Transfer Process (inactive
ICON_2 ICON_BW_OPEN_HUB_INACTIVE      '@VM@'."  Open Hub Destination (inactive)
ICON_2 ICON_OO_INTERFACE_MSGTP        '@VN@'."  Interface Nachrichtentyp
ICON_2 ICON_OO_INTERFACE_FAULT_MSGTP  '@VO@'."  Faulty messagetype
ICON_2 ICON_SEGMENTED_DATA_ACT        '@VP@'."  Segmented data
ICON_2 ICON_SEGMENTED_DATA_INA        '@VQ@'."  Segmented data (inactive)
ICON_2 ICON_BIW_VIRTUAL_INFO_PROVIDER '@VR@'."  Virtual InfoProvider
ICON_2 ICON_BIW_VIRTUAL_INFO_PROV_INA '@VS@'."  Virtual InfoProvider inactive
ICON_2 ICON_ALL_GREEN                 '@VT@'."  Select: All
ICON_2 ICON_BW_SOURCE_SYS_UDC         '@VU@'."  Source system (Universal Data C
ICON_2 ICON_AGENT                     '@VV@'."  Agent
ICON_2 ICON_BIW_INFO_SOURCE_INA       '@VW@'."  BW Info Source inactive
ICON_2 ICON_CHECKED_OUT               '@VX@'."  Checked Out
ICON_2 ICON_CHECKIN_REQUESTED         '@VY@'."  Check In Requested
ICON_2 ICON_CHECKOUT_REQUESTED        '@VZ@'."  Check Out Requested
ICON_2 ICON_MESSAGE_TYPE              '@W0@'."  Message Type
ICON_2 ICON_MESSAGE_FAULTY            '@W1@'."  Faulty Message Type
ICON_2 ICON_BUSINAV_OBJECTS_UPTODATE  '@W2@'."  Business Object (up to date)
ICON_2 ICON_BUSINAV_OBJECTS_OUTDATE   '@W3@'."  Business Object Out of Date
ICON_2 ICON_BUSINAV_OBJECTS_ORPHAN    '@W4@'."  Business Object (Orphaned)
ICON_2 ICON_CLOSED_FOLDER_UPTODATE    '@W5@'."  Closed Folder (Up to Date)
ICON_2 ICON_CLOSED_FOLDER_OUTDATE     '@W6@'."  Closed Folder (Out of Date)
ICON_2 ICON_CLOSED_FOLDER_ORPHANED    '@W7@'."  Closed Folder (Orphaned)
ICON_2 ICON_MESSAGE_UPTODATE          '@W8@'."  Message (Up To Date)
ICON_2 ICON_MESSAGE_OUTOFDATE         '@W9@'."  Message (out of date)
ICON_2 ICON_MESSAGE_ORPHANED          '@WA@'."  Message (orphaned)
ICON_2 ICON_MESSAGE_FAULTY_UPTODATE   '@WB@'."  Faulty Message (up to date)
ICON_2 ICON_MESSAGE_FAULTY_OUTDATE    '@WC@'."  Faulty Message (out of date)
ICON_2 ICON_MESSAGE_FAULTY_ORPHAN     '@WD@'."  Faulty Message (orphaned)
ICON_2 ICON_OO_INTERFACE_UPTODATE     '@WE@'."  Object Interface (up to date)
ICON_2 ICON_OO_INTERFACE_OUTDATE      '@WF@'."  Object Interface (out of date)
ICON_2 ICON_OO_INTERFACE_ORPHAN       '@WG@'."  Object Interface (orphaned)
ICON_2 ICON_DATATYPES_UPTODATE        '@WH@'."  Data Types (up to date)
ICON_2 ICON_DATATYPES_OUTDATE         '@WI@'."  Data Types (out of date)
ICON_2 ICON_DATATYPES_ORPHAN          '@WJ@'."  Data Types (orphaned)
ICON_2 ICON_DATATYPES_ENH_UPTODATE    '@WK@'."  Data Type Enh.  (up to date)
ICON_2 ICON_DATATYPES_ENH_OUTDATE     '@WL@'."  Data Type Enh. (out of date)
ICON_2 ICON_DATATYPES_ENH_ORPHAN      '@WM@'."  Data Type Enh. (orphaned)
ICON_2 ICON_AGENT_UPTODATE            '@WN@'."  Agent  (up to date)
ICON_2 ICON_AGENT_OUTDATE             '@WO@'."  Agent (out of date)
ICON_2 ICON_AGENT_ORPHAN              '@WP@'."  Agent (orphaned)
ICON_2 ICON_ENHANCED_BO               '@WQ@'."  Enhanced Business Object
ICON_2 ICON_ENHANCED_BO_UPTODATE      '@WR@'."  Enh. Business Object (up to dat
ICON_2 ICON_ENHANCED_BO_OUTDATE       '@WS@'."  Enh. Business Object (out of da
ICON_2 ICON_ENHANCED_BO_ORPHAN        '@WT@'."  Enh. Business Object (orphaned)
ICON_2 ICON_STORES                    '@WU@'."  Stores
ICON_2 ICON_WAREHOUSES                '@WV@'."  Central Warehouses
ICON_2 ICON_CONDITION_BREAKPOINT      '@WW@'."  Condition Breakpoint
ICON_2 ICON_CONDITION_BREAKPOINT_DIS  '@WX@'."  Disabled Condition Breakpoint
ICON_2 ICON_JOB_FAMILY                '@WY@'."  Job Family
ICON_2 ICON_INTELLECTUAL_PROPERTY     '@WZ@'."  Intellectual Property
ICON_2 ICON_PROPRIETARY               '@X0@'."  Proprietary
ICON_2 ICON_INSTALL_PACKAGE           '@X1@'."  Installation Package
ICON_2 ICON_SAP_LOGON                 '@X2@'."  SAP Logon
ICON_2 ICON_SAP_SHORTCUT              '@X3@'."  SAP Gui Shortcut
ICON_2 ICON_SAP_GUI_SESSION           '@X4@'."  SAP Gui Window
ICON_2 ICON_SAP_SERVER                '@X5@'."  SAP Server
ICON_2 ICON_SAP_LOGON_SERVER_SSO      '@X6@'."  SAP Server with SSO
ICON_2 ICON_SAP_LOGON_USERDEFINED     '@X7@'."  SAP Logon Server Userdefined
ICON_2 ICON_SAP_LOGON_USERDEFINED_SSO '@X8@'."  SAP Logon Server Userdef SSO
ICON_2 ICON_SAP_LOGON_GROUP           '@X9@'."  SAP Server Group
ICON_2 ICON_SAP_LOGON_GROUP_SSO       '@XA@'."  SAP Server Group SSO
ICON_2 ICON_SAP_LOGON_GROUP_USER      '@XB@'."  Userdefined SAP Server Group
ICON_2 ICON_SETTINGS                  '@XC@'."  Settings
ICON_2 ICON_VIEW_TABLE                '@XD@'."  Table View
ICON_2 ICON_VIEW_HIER_LIST            '@XE@'."  Hierarchical List View
ICON_2 ICON_VIEW_TREE                 '@XF@'."  Tree View
ICON_2 ICON_VIEW_THUMBNAILS           '@XG@'."  Thumbnails View
ICON_2 ICON_SAP_LOGON_GROUP_CERT      '@XH@'."  Secure Logon Group
ICON_2 ICON_SAP_LOGON_GROUP_CERT_SSO  '@XI@'."  Secure Sign On Group
ICON_2 ICON_SAP_LOGON_GROUP_CERT_USER '@XJ@'."  User def. Secure Sign On Group
ICON_2 ICON_LOGON_GROUP_CERT_SSO_USR  '@XK@'."  User def. Secure Login Group
ICON_2 ICON_SAP_LOGON_SRV_CERT        '@XL@'."  Secure Connection to SAP Server
ICON_2 ICON_SAP_LOGON_SRV_CERT_SSO    '@XM@'."  Secure Sign On to Server
ICON_2 ICON_SAP_LOGON_SRV_CERT_USER   '@XN@'."  Userdefined secure connection
ICON_2 ICON_LOGON_SRV_CERT_SSO_USER   '@XO@'."  Userdef. Secure sign on
ICON_2 ICON_MASS_CHANGE_DONE          '@XP@'."  Mass change completed
ICON_2 ICON_REMOVE_ROW                '@XQ@'."  Remove Row
ICON_2 ICON_ADD_ROW                   '@XR@'."  Add Row
ICON_2 ICON_SAP_LOGON_GROUP_SSO_USR   '@XS@'."  Userdef. Secure Logon Group
ICON_2 ICON_APPLE_KEYNOTE             '@XT@'."  Apple Keynote Document
ICON_2 ICON_APPLE_NUMBERS             '@XU@'."  Apple Numbers Document
ICON_2 ICON_APPLE_PAGES               '@XV@'."  Apple Pages Document
ICON_2 ICON_GOS_SERVICES              '@XW@'."  Services for Object
ICON_2 ICON_GOS_SERVICES_ATTACHMENT   '@XX@'."  Services: Attachments Exist
ICON_2 ICON_GOS_SERVICES_RELATIONS    '@XY@'."  Services: Relationships Exist
ICON_2 ICON_GOS_SERVICES_ATT_REL      '@XZ@'."  Services: Relations./Attachm.
ICON_2 ICON_REBATE                    '@Y0@'."  Discount
ICON_2 ICON_CHARGE                    '@Y1@'."  Charge
ICON_2 ICON_START_VIEWER              '@Y2@'."  Start Viewer

* bugfix for wrong usage of ICON_BW_SUGGEST_VALUE
ICON_2 ICON_SUGGEST_VALUE             '@F6@'."  Stop
