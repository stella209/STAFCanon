unit _EDSDKErrors;

interface

{$MINENUMSIZE 4}

const
  {-----------------------------------------------------------------------
     ED-SDK Error Code Masks
  ------------------------------------------------------------------------}
  EDS_ISSPECIFIC_MASK                                 = Cardinal($80000000);
  EDS_COMPONENTID_MASK                                = Cardinal($7F000000);
  EDS_RESERVED_MASK                                   = Cardinal($00FF0000);
  EDS_ERRORID_MASK                                    = Cardinal($0000FFFF);

  {-----------------------------------------------------------------------
     ED-SDK Base Component IDs
  ------------------------------------------------------------------------}
  EDS_CMP_ID_CLIENT_COMPONENTID                       = Cardinal($01000000);
  EDS_CMP_ID_LLSDK_COMPONENTID                        = Cardinal($02000000);
  EDS_CMP_ID_HLSDK_COMPONENTID                        = Cardinal($03000000);

  {-----------------------------------------------------------------------
     ED-SDK Function Success Code
  ------------------------------------------------------------------------}
  EDS_ERR_OK                                          = Cardinal($00000000);

  {-----------------------------------------------------------------------
     ED-SDK Generic Error IDs
  ------------------------------------------------------------------------}
  { Miscellaneous errors }
  EDS_ERR_UNIMPLEMENTED                               = Cardinal($00000001);
  EDS_ERR_INTERNAL_ERROR                              = Cardinal($00000002);
  EDS_ERR_MEM_ALLOC_FAILED                            = Cardinal($00000003);
  EDS_ERR_MEM_FREE_FAILED                             = Cardinal($00000004);
  EDS_ERR_OPERATION_CANCELLED                         = Cardinal($00000005);
  EDS_ERR_INCOMPATIBLE_VERSION                        = Cardinal($00000006);
  EDS_ERR_NOT_SUPPORTED                               = Cardinal($00000007);
  EDS_ERR_UNEXPECTED_EXCEPTION                        = Cardinal($00000008);
  EDS_ERR_PROTECTION_VIOLATION                        = Cardinal($00000009);
  EDS_ERR_MISSING_SUBCOMPONENT                        = Cardinal($0000000A);
  EDS_ERR_SELECTION_UNAVAILABLE                       = Cardinal($0000000B);

  { File errors }
  EDS_ERR_FILE_IO_ERROR                               = Cardinal($00000020);
  EDS_ERR_FILE_TOO_MANY_OPEN                          = Cardinal($00000021);
  EDS_ERR_FILE_NOT_FOUND                              = Cardinal($00000022);
  EDS_ERR_FILE_OPEN_ERROR                             = Cardinal($00000023);
  EDS_ERR_FILE_CLOSE_ERROR                            = Cardinal($00000024);
  EDS_ERR_FILE_SEEK_ERROR                             = Cardinal($00000025);
  EDS_ERR_FILE_TELL_ERROR                             = Cardinal($00000026);
  EDS_ERR_FILE_READ_ERROR                             = Cardinal($00000027);
  EDS_ERR_FILE_WRITE_ERROR                            = Cardinal($00000028);
  EDS_ERR_FILE_PERMISSION_ERROR                       = Cardinal($00000029);
  EDS_ERR_FILE_DISK_FULL_ERROR                        = Cardinal($0000002A);
  EDS_ERR_FILE_ALREADY_EXISTS                         = Cardinal($0000002B);
  EDS_ERR_FILE_FORMAT_UNRECOGNIZED                    = Cardinal($0000002C);
  EDS_ERR_FILE_DATA_CORRUPT                           = Cardinal($0000002D);
  EDS_ERR_FILE_NAMING_NA                              = Cardinal($0000002E);

  { Directory errors }
  EDS_ERR_DIR_NOT_FOUND                               = Cardinal($00000040);
  EDS_ERR_DIR_IO_ERROR                                = Cardinal($00000041);
  EDS_ERR_DIR_ENTRY_NOT_FOUND                         = Cardinal($00000042);
  EDS_ERR_DIR_ENTRY_EXISTS                            = Cardinal($00000043);
  EDS_ERR_DIR_NOT_EMPTY                               = Cardinal($00000044);

  { Property errors }
  EDS_ERR_PROPERTIES_UNAVAILABLE                      = Cardinal($00000050);
  EDS_ERR_PROPERTIES_MISMATCH                         = Cardinal($00000051);
  EDS_ERR_PROPERTIES_NOT_LOADED                       = Cardinal($00000053);

  { Function Parameter errors }
  EDS_ERR_INVALID_PARAMETER                           = Cardinal($00000060);
  EDS_ERR_INVALID_HANDLE                              = Cardinal($00000061);
  EDS_ERR_INVALID_POINTER                             = Cardinal($00000062);
  EDS_ERR_INVALID_INDEX                               = Cardinal($00000063);
  EDS_ERR_INVALID_LENGTH                              = Cardinal($00000064);
  EDS_ERR_INVALID_FN_POINTER                          = Cardinal($00000065);
  EDS_ERR_INVALID_SORT_FN                             = Cardinal($00000066);

  { Device errors }
  EDS_ERR_DEVICE_NOT_FOUND                            = Cardinal($00000080);
  EDS_ERR_DEVICE_BUSY                                 = Cardinal($00000081);
  EDS_ERR_DEVICE_INVALID                              = Cardinal($00000082);
  EDS_ERR_DEVICE_EMERGENCY                            = Cardinal($00000083);
  EDS_ERR_DEVICE_MEMORY_FULL                          = Cardinal($00000084);
  EDS_ERR_DEVICE_INTERNAL_ERROR                       = Cardinal($00000085);
  EDS_ERR_DEVICE_INVALID_PARAMETER                    = Cardinal($00000086);
  EDS_ERR_DEVICE_NO_DISK                              = Cardinal($00000087);
  EDS_ERR_DEVICE_DISK_ERROR                           = Cardinal($00000088);
  EDS_ERR_DEVICE_CF_GATE_CHANGED                      = Cardinal($00000089);
  EDS_ERR_DEVICE_DIAL_CHANGED                         = Cardinal($0000008A);
  EDS_ERR_DEVICE_NOT_INSTALLED                        = Cardinal($0000008B);
  EDS_ERR_DEVICE_STAY_AWAKE                           = Cardinal($0000008C);
  EDS_ERR_DEVICE_NOT_RELEASED                         = Cardinal($0000008D);

  { Stream errors }
  EDS_ERR_STREAM_IO_ERROR                             = Cardinal($000000A0);
  EDS_ERR_STREAM_NOT_OPEN                             = Cardinal($000000A1);
  EDS_ERR_STREAM_ALREADY_OPEN                         = Cardinal($000000A2);
  EDS_ERR_STREAM_OPEN_ERROR                           = Cardinal($000000A3);
  EDS_ERR_STREAM_CLOSE_ERROR                          = Cardinal($000000A4);
  EDS_ERR_STREAM_SEEK_ERROR                           = Cardinal($000000A5);
  EDS_ERR_STREAM_TELL_ERROR                           = Cardinal($000000A6);
  EDS_ERR_STREAM_READ_ERROR                           = Cardinal($000000A7);
  EDS_ERR_STREAM_WRITE_ERROR                          = Cardinal($000000A8);
  EDS_ERR_STREAM_PERMISSION_ERROR                     = Cardinal($000000A9);
  EDS_ERR_STREAM_COULDNT_BEGIN_THREAD                 = Cardinal($000000AA);
  EDS_ERR_STREAM_BAD_OPTIONS                          = Cardinal($000000AB);
  EDS_ERR_STREAM_END_OF_STREAM                        = Cardinal($000000AC);

  { Communications errors }
  EDS_ERR_COMM_PORT_IS_IN_USE                         = Cardinal($000000C0);
  EDS_ERR_COMM_DISCONNECTED                           = Cardinal($000000C1);
  EDS_ERR_COMM_DEVICE_INCOMPATIBLE                    = Cardinal($000000C2);
  EDS_ERR_COMM_BUFFER_FULL                            = Cardinal($000000C3);
  EDS_ERR_COMM_USB_BUS_ERR                            = Cardinal($000000C4);

  { Lock/Unlock }
  EDS_ERR_USB_DEVICE_LOCK_ERROR                       = Cardinal($000000D0);
  EDS_ERR_USB_DEVICE_UNLOCK_ERROR                     = Cardinal($000000D1);

  { STI/WIA }
  EDS_ERR_STI_UNKNOWN_ERROR                           = Cardinal($000000E0);
  EDS_ERR_STI_INTERNAL_ERROR                          = Cardinal($000000E1);
  EDS_ERR_STI_DEVICE_CREATE_ERROR                     = Cardinal($000000E2);
  EDS_ERR_STI_DEVICE_RELEASE_ERROR                    = Cardinal($000000E3);
  EDS_ERR_DEVICE_NOT_LAUNCHED                         = Cardinal($000000E4);

  EDS_ERR_ENUM_NA                                     = Cardinal($000000F0);
  EDS_ERR_INVALID_FN_CALL                             = Cardinal($000000F1);
  EDS_ERR_HANDLE_NOT_FOUND                            = Cardinal($000000F2);
  EDS_ERR_INVALID_ID                                  = Cardinal($000000F3);
  EDS_ERR_WAIT_TIMEOUT_ERROR                          = Cardinal($000000F4);

  { PTP }
  EDS_ERR_SESSION_NOT_OPEN                            = Cardinal($00002003);
  EDS_ERR_INVALID_TRANSACTIONID                       = Cardinal($00002004);
  EDS_ERR_INCOMPLETE_TRANSFER                         = Cardinal($00002007);
  EDS_ERR_INVALID_STRAGEID                            = Cardinal($00002008);
  EDS_ERR_DEVICEPROP_NOT_SUPPORTED                    = Cardinal($0000200A);
  EDS_ERR_INVALID_OBJECTFORMATCODE                    = Cardinal($0000200B);
  EDS_ERR_SELF_TEST_FAILED                            = Cardinal($00002011);
  EDS_ERR_PARTIAL_DELETION                            = Cardinal($00002012);
  EDS_ERR_SPECIFICATION_BY_FORMAT_UNSUPPORTED         = Cardinal($00002014);
  EDS_ERR_NO_VALID_OBJECTINFO                         = Cardinal($00002015);
  EDS_ERR_INVALID_CODE_FORMAT                         = Cardinal($00002016);
  EDS_ERR_UNKNOWN_VENDOR_CODE                         = Cardinal($00002017);
  EDS_ERR_CAPTURE_ALREADY_TERMINATED                  = Cardinal($00002018);
  EDS_ERR_PTP_DEVICE_BUSY                             = Cardinal($00002019);
  EDS_ERR_INVALID_PARENTOBJECT                        = Cardinal($0000201A);
  EDS_ERR_INVALID_DEVICEPROP_FORMAT                   = Cardinal($0000201B);
  EDS_ERR_INVALID_DEVICEPROP_VALUE                    = Cardinal($0000201C);
  EDS_ERR_SESSION_ALREADY_OPEN                        = Cardinal($0000201E);
  EDS_ERR_TRANSACTION_CANCELLED                       = Cardinal($0000201F);
  EDS_ERR_SPECIFICATION_OF_DESTINATION_UNSUPPORTED    = Cardinal($00002020);
  EDS_ERR_NOT_CAMERA_SUPPORT_SDK_VERSION              = Cardinal($00002021);

  { PTP Vendor }
  EDS_ERR_UNKNOWN_COMMAND                             = Cardinal($0000A001);
  EDS_ERR_OPERATION_REFUSED                           = Cardinal($0000A005);
  EDS_ERR_LENS_COVER_CLOSE                            = Cardinal($0000A006);
  EDS_ERR_LOW_BATTERY                                 = Cardinal($0000A101);
  EDS_ERR_OBJECT_NOTREADY                             = Cardinal($0000A102);
  EDS_ERR_CANNOT_MAKE_OBJECT                          = Cardinal($0000A104);
  EDS_ERR_MEMORYSTATUS_NOTREADY                       = Cardinal($0000A106);

  { Take Picture errors }
  EDS_ERR_TAKE_PICTURE_AF_NG                          = Cardinal($00008D01);
  EDS_ERR_TAKE_PICTURE_RESERVED                       = Cardinal($00008D02);
  EDS_ERR_TAKE_PICTURE_MIRROR_UP_NG                   = Cardinal($00008D03);
  EDS_ERR_TAKE_PICTURE_SENSOR_CLEANING_NG             = Cardinal($00008D04);
  EDS_ERR_TAKE_PICTURE_SILENCE_NG                     = Cardinal($00008D05);
  EDS_ERR_TAKE_PICTURE_NO_CARD_NG                     = Cardinal($00008D06);
  EDS_ERR_TAKE_PICTURE_CARD_NG                        = Cardinal($00008D07);
  EDS_ERR_TAKE_PICTURE_CARD_PROTECT_NG                = Cardinal($00008D08);
  EDS_ERR_TAKE_PICTURE_MOVIE_CROP_NG                  = Cardinal($00008D09);
  EDS_ERR_TAKE_PICTURE_STROBO_CHARGE_NG               = Cardinal($00008D0A);
  EDS_ERR_TAKE_PICTURE_NO_LENS_NG                     = Cardinal($00008D0B);
  EDS_ERR_TAKE_PICTURE_SPECIAL_MOVIE_MODE_NG          = Cardinal($00008D0C);
  EDS_ERR_TAKE_PICTURE_LV_REL_PROHIBIT_MODE_NG        = Cardinal($00008D0D);
  EDS_ERR_TAKE_PICTURE_MOVIE_MODE_NG                  = Cardinal($00008D0E);
  EDS_ERR_TAKE_PICTURE_RETRUCTED_LENS_NG              = Cardinal($00008D0F);

  EDS_ERR_LAST_GENERIC_ERROR_PLUS_ONE                 = Cardinal($000000F5);

implementation

end.