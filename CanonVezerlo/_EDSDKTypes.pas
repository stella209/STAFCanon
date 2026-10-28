unit _EDSDKTypes;

interface

uses
  Winapi.Windows;

type
  { Alaptípusok leképezése a gyári C fájl alapján }
  EdsBaseRef = pointer;

  EdsVoid  = Variant;
  PEdsVoid = ^Variant;
type
  EdsBool  = Integer;
  PEdsBool = ^Integer;

type
  EdsChar  = AnsiChar;
  PEdsChar = ^AnsiChar;
type
  EdsInt8 = AnsiChar;
type
  EdsUInt8 = Byte;
type
  EdsInt16 = SmallInt;
type
  EdsUInt16 = Word;
type
  EdsInt32 = LongInt;
type
  EdsUInt32  = LongWord;
  PEdsUInt32 = ^LongWord;
type
  EdsInt64 = Int64;
type
  EdsUInt64 = Int64;
type
  EdsFloat = Single;
type
  EdsDouble = Double;

  EdsError = EdsUInt32;


  EdsSeekOrigin = Cardinal;
  EdsProgressOption = Cardinal;
  EdsImageSource = Cardinal;
  EdsTargetImageType = Cardinal;
  EdsAccess = Cardinal;                   // <-- Ide került az új típus
  EdsFileCreateDisposition = Cardinal;

  { Alapvető struktúra és típus mutatók }
  PEdsInt32 = ^EdsInt32;
  PEdsDataType = ^EdsUInt32;
  PEdsBaseRef = ^Pointer;
  EdsCameraListRef = EdsBaseRef;
  PEdsCameraListRef = ^Pointer;
  PEdsImageRef = ^Pointer;
  PEdsEvfImageRef = ^Pointer;
  PEdsStreamRef = ^Pointer;
  PEdsUInt64 = ^EdsUInt64;
  EdsFileAttributes = Cardinal;
  PEdsFileAttributes = ^EdsFileAttributes;

  { C-s típusok és Enumok azonosítói }
  EdsPropertyID = EdsUInt32;
  EdsCameraCommand = EdsUInt32;
  EdsCameraStatusCommand = EdsUInt32;
  EdsPropertyEvent = EdsUInt32;
  EdsObjectEvent = EdsUInt32;
  EdsStateEvent = EdsUInt32;

const
  EDS_MAX_NAME            = 256;
  EDS_TRANSFER_BLOCK_SIZE = 512;

  {-----------------------------------------------------------------------------
   Property IDs (Tulajdonság Azonosítók)
  -----------------------------------------------------------------------------}
  { Camera Setting Properties }
  kEdsPropID_Unknown                = $0000ffff;
  kEdsPropID_ProductName            = $00000002;
  kEdsPropID_OwnerName              = $00000004;
  kEdsPropID_MakerName              = $00000005;
  kEdsPropID_DateTime               = $00000006;
  kEdsPropID_FirmwareVersion        = $00000007;
  kEdsPropID_BatteryLevel           = $00000008;
  kEdsPropID_SaveTo                 = $0000000b;
  kEdsPropID_CurrentStorage         = $0000000c;
  kEdsPropID_CurrentFolder          = $0000000d;
  kEdsPropID_BatteryQuality         = $00000010;
  kEdsPropID_BodyIDEx				        = $00000015;
  kEdsPropID_HDDirectoryStructure   = $00000020;
  kEdsPropID_TempStatus             = $01000415;

  { Image Properties }
  kEdsPropID_ImageQuality           = $00000100;
  kEdsPropID_Orientation            = $00000102;
  kEdsPropID_ICCProfile             = $00000103;
  kEdsPropID_FocusInfo              = $00000104;
  kEdsPropID_WhiteBalance           = $00000106;
  kEdsPropID_ColorTemperature       = $00000107;
  kEdsPropID_WhiteBalanceShift      = $00000108;
  kEdsPropID_ColorSpace             = $0000010d;
  kEdsPropID_PictureStyle           = $00000114;
  kEdsPropID_PictureStyleDesc       = $00000115;
  kEdsPropID_PictureStyleCaption    = $00000200;

  { Image GPS Properties }
  kEdsPropID_GPSVersionID			      = $00000800;
  kEdsPropID_GPSLatitudeRef		      = $00000801;
  kEdsPropID_GPSLatitude			      = $00000802;
  kEdsPropID_GPSLongitudeRef		    = $00000803;
  kEdsPropID_GPSLongitude			      = $00000804;
  kEdsPropID_GPSAltitudeRef		      = $00000805;
  kEdsPropID_GPSAltitude			      = $00000806;
  kEdsPropID_GPSTimeStamp			      = $00000807;
  kEdsPropID_GPSSatellites		      = $00000808;
  kEdsPropID_GPSStatus			        = $00000809;
  kEdsPropID_GPSMapDatum			      = $00000812;
  kEdsPropID_GPSDateStamp			      = $0000081D;

  { Capture Properties (Ez kell neked a paraméterezéshez!) }
  kEdsPropID_AEMode                 = $00000400;
  kEdsPropID_DriveMode              = $00000401;
  kEdsPropID_ISOSpeed               = $00000402;
  kEdsPropID_MeteringMode           = $00000403;
  kEdsPropID_AFMode                 = $00000404;
  kEdsPropID_Av                     = $00000405;
  kEdsPropID_Tv                     = $00000406;
  kEdsPropID_ExposureCompensation   = $00000407;
  kEdsPropID_FocalLength            = $00000409;
  kEdsPropID_AvailableShots         = $0000040a;
  kEdsPropID_Bracket                = $0000040b;
  kEdsPropID_WhiteBalanceBracket    = $0000040c;
  kEdsPropID_LensName               = $0000040d;
  kEdsPropID_AEBracket              = $0000040e;
  kEdsPropID_FEBracket              = $0000040f;
  kEdsPropID_ISOBracket             = $00000410;
  kEdsPropID_NoiseReduction         = $00000411;
  kEdsPropID_FlashOn                = $00000412;
  kEdsPropID_RedEye                 = $00000413;
  kEdsPropID_FlashMode              = $00000414;
  kEdsPropID_LensStatus             = $00000416;
  kEdsPropID_Artist	              = $00000418;
  kEdsPropID_Copyright	          = $00000419;
  kEdsPropID_AEModeSelect           = $00000436;
  kEdsPropID_PowerZoom_Speed		    = $00000444;
 { EVF Properties (Élőkép Beállítások) }
  kEdsPropID_Evf_OutputDevice        = $00000500;
  kEdsPropID_Evf_Mode                = $00000501;
  kEdsPropID_Evf_WhiteBalance        = $00000502;
  kEdsPropID_Evf_ColorTemperature    = $00000503;
  kEdsPropID_Evf_DepthOfFieldPreview = $00000504;
  kEdsPropID_Evf_Zoom                = $00000507;
  kEdsPropID_Evf_ZoomPosition        = $00000508;
  kEdsPropID_Evf_Histogram           = $0000050A;
  kEdsPropID_Evf_ImagePosition       = $0000050B;
  kEdsPropID_Evf_HistogramStatus     = $0000050C;
  kEdsPropID_Evf_AFMode              = $0000050E;
  kEdsPropID_Record                  = $00000510;
  kEdsPropID_Evf_HistogramY          = $00000515;
  kEdsPropID_Evf_HistogramR          = $00000516;
  kEdsPropID_Evf_HistogramG          = $00000517;
  kEdsPropID_Evf_HistogramB          = $00000518;
  kEdsPropID_Evf_CoordinateSystem    = $00000540;
  kEdsPropID_Evf_ZoomRect            = $00000541;
  kEdsPropID_Evf_ImageClipRect       = $00000545;
  kEdsPropID_Evf_PowerZoom_CurPosition = $00000550;
  kEdsPropID_Evf_PowerZoom_MaxPosition = $00000551;
  kEdsPropID_Evf_PowerZoom_MinPosition = $00000552;

  { Limited Properties }
  kEdsPropID_UTCTime                 = $01000016;
  kEdsPropID_TimeZone                = $01000017;
  kEdsPropID_SummerTimeSetting       = $01000018;
  kEdsPropID_ManualWhiteBalanceData  = $01000204;
  kEdsPropID_MirrorLockUpState       = $01000421;
  kEdsPropID_FixedMovie              = $01000422;
  kEdsPropID_MovieParam              = $01000423;
  kEdsPropID_Aspect                  = $01000431;
  kEdsPropID_MirrorUpSetting         = $01000438;
  kEdsPropID_MovieServoAf            = $0100043e;
  kEdsPropID_AutoPowerOffSetting     = $0100045e;
  kEdsPropID_AFEyeDetect             = $01000455;
  kEdsPropID_Evf_ClickWBCoeffs       = $01000506;
  kEdsPropID_EVF_RollingPitching     = $01000544;
  kEdsPropID_Evf_VisibleRect         = $01000546;
  kEdsPropID_StillMovieDivideSetting = $01000470;
  kEdsPropID_CardExtension           = $01000471;
  kEdsPropID_MovieCardExtension      = $01000472;
  kEdsPropID_StillCurrentMedia       = $01000473;
  kEdsPropID_MovieCurrentMedia       = $01000474;
  kEdsPropID_FocusShiftSetting       = $01000457;
  kEdsPropID_MovieHFRSetting         = $0100045d;

  { DC Properties }
  kEdsPropID_DC_Zoom                 = $00000600;
  kEdsPropID_DC_Strobe               = $00000601;
  kEdsPropID_LensBarrelStatus        = $00000605;

  { Camera Commands (Kamera parancsok - BULB és Exponálás) }
  kEdsCameraCommand_TakePicture         = $00000000;
  kEdsCameraCommand_ExtendShutDownTimer = $00000001;
  kEdsCameraCommand_BulbStart           = $00000002;
  kEdsCameraCommand_BulbEnd             = $00000003;
  kEdsCameraCommand_PressShutterButton  = $00000004;
  kEdsCameraCommand_DoEvfAf             = $00000102;
  kEdsCameraCommand_DriveLensEvf        = $00000103;
  kEdsCameraCommand_DoClickWBEvf        = $00000104;
  kEdsCameraCommand_MovieSelectSwON     = $00000107;
  kEdsCameraCommand_MovieSelectSwOFF    = $00000108;
  kEdsCameraCommand_RequestRollPitchLevel = $00000109;
  kEdsCameraCommand_DrivePowerZoom      = $0000010d;
  kEdsCameraCommand_SetRemoteShootingMode = $0000010f;
  kEdsCameraCommand_RequestSensorCleaning = $00000112;
  kEdsCameraCommand_SetModeDialDisable  = $00000113;

  { Camera Status Commands }
  kEdsCameraStatusCommand_UILock              = $00000000;
  kEdsCameraStatusCommand_UIUnLock            = $00000001;
  kEdsCameraStatusCommand_EnterDirectTransfer = $00000002;
  kEdsCameraStatusCommand_ExitDirectTransfer  = $00000003;

  { Property Events }
  kEdsPropertyEvent_All                 = $00000100;
  kEdsPropertyEvent_PropertyChanged     = $00000101;
  kEdsPropertyEvent_PropertyDescChanged = $00000102;

  { Object Events (Letöltési események kódjai) }
  kEdsObjectEvent_All                   = $00000200;
  kEdsObjectEvent_VolumeInfoChanged     = $00000201;
  kEdsObjectEvent_VolumeUpdateItems     = $00000202;
  kEdsObjectEvent_FolderUpdateItems     = $00000203;
  kEdsObjectEvent_DirItemCreated        = $00000204;
  kEdsObjectEvent_DirItemRemoved        = $00000205;
  kEdsObjectEvent_DirItemInfoChanged    = $00000206;
  kEdsObjectEvent_DirItemContentChanged = $00000207;
  kEdsObjectEvent_DirItemRequestTransfer   = $00000208;
  kEdsObjectEvent_DirItemRequestTransferDT = $00000209;
  kEdsObjectEvent_DirItemCancelTransferDT  = $0000020a;
  kEdsObjectEvent_VolumeAdded           = $0000020c;
  kEdsObjectEvent_VolumeRemoved         = $0000020d;

  { State Events }
  kEdsStateEvent_All                    = $00000300;
  kEdsStateEvent_Shutdown               = $00000301;
  kEdsStateEvent_JobStatusChanged       = $00000302;
  kEdsStateEvent_WillSoonShutDown       = $00000303;
  kEdsStateEvent_ShutDownTimerUpdate    = $00000304;
  kEdsStateEvent_CaptureError           = $00000305;
  kEdsStateEvent_InternalError          = $00000306;
  kEdsStateEvent_AfResult               = $00000309;
  kEdsStateEvent_BulbExposureTime       = $00000310;
  kEdsStateEvent_PowerZoomInfoChanged   = $00000311;

  {-----------------------------------------------------------------------------
   File Attributes Constants (Fájl attribútumok szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsFileAttribute_Normal    = Cardinal($00000000);
  kEdsFileAttribute_ReadOnly  = Cardinal($00000001);
  kEdsFileAttribute_Hidden    = Cardinal($00000002);
  kEdsFileAttribute_System    = Cardinal($00000004);
  kEdsFileAttribute_Archive   = Cardinal($00000020);

  {-----------------------------------------------------------------------------
   File Create Disposition Constants (Fájl létrehozási módok szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsFileCreateDisposition_CreateNew        = Cardinal(0);
  kEdsFileCreateDisposition_CreateAlways     = Cardinal(1);
  kEdsFileCreateDisposition_OpenExisting     = Cardinal(2);
  kEdsFileCreateDisposition_OpenAlways       = Cardinal(3);
  kEdsFileCreateDisposition_TruncateExisting = Cardinal(4);

  {-----------------------------------------------------------------------------
   Stream Access Constants (Adatfolyam hozzáférések szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsAccess_Read      = Cardinal(0);
  kEdsAccess_Write     = Cardinal(1);
  kEdsAccess_ReadWrite = Cardinal(2);
  kEdsAccess_Error     = Cardinal($FFFFFFFF);

  {-----------------------------------------------------------------------------
   AE Modes Constants (Expozíciós módok szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsAEMode_Program                                                            = Cardinal($00);
  kEdsAEMode_Tv                               = Cardinal($01);
  kEdsAEMode_Av                               = Cardinal($02);
  kEdsAEMode_Manual                           = Cardinal($03);
  kEdsAEMode_Bulb                             = Cardinal($04);
  kEdsAEMode_A_DEP                            = Cardinal($05);
  kEdsAEMode_DEP                              = Cardinal($06);
  kEdsAEMode_Custom                           = Cardinal($07);
  kEdsAEMode_Lock                             = Cardinal($08);
  kEdsAEMode_Green                            = Cardinal($09);
  kEdsAEMode_NightPortrait                    = Cardinal($0A);
  kEdsAEMode_Sports                           = Cardinal($0B);
  kEdsAEMode_Portrait                         = Cardinal($0C);
  kEdsAEMode_Landscape                        = Cardinal($0D);
  kEdsAEMode_Closeup                          = Cardinal($0E);
  kEdsAEMode_FlashOff                         = Cardinal($0F);
  kEdsAEMode_CreativeAuto                     = Cardinal($13);
  kEdsAEMode_Movie                            = Cardinal($14);
  kEdsAEMode_PhotoInMovie                     = Cardinal($15);
  kEdsAEMode_SceneIntelligentAuto             = Cardinal($16);
  kEdsAEMode_Unknown                          = Cardinal($FFFFFFFF);

  {-----------------------------------------------------------------------------
   White Balance Constants (Fehéregyensúly szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsWhiteBalance_Auto        = Cardinal(0);
  kEdsWhiteBalance_Daylight    = Cardinal(1);
  kEdsWhiteBalance_Cloudy      = Cardinal(2);
  kEdsWhiteBalance_Tungsten    = Cardinal(3);
  kEdsWhiteBalance_Fluorescent = Cardinal(4);
  kEdsWhiteBalance_Strobe      = Cardinal(5);
  kEdsWhiteBalance_WhitePaper  = Cardinal(6);
  kEdsWhiteBalance_Shade       = Cardinal(8);
  kEdsWhiteBalance_ColorTemp   = Cardinal(9);

  {-----------------------------------------------------------------------------
   Image Size Constants (Képméretek szokásos nevei)
  -----------------------------------------------------------------------------}
  kEdsImageSize_Large   = Cardinal(0);
  kEdsImageSize_Middle  = Cardinal(1);
  kEdsImageSize_Small   = Cardinal(2);
  kEdsImageSize_Middle1 = Cardinal(5);
  kEdsImageSize_Middle2 = Cardinal(6);
  kEdsImageSize_Unknown = Cardinal($FFFFFFFF);

const
  // Tulajdonság (Property) azonosító az élő kép kimenetéhez
  kEdsPropertyID_Evf_Mode         = Cardinal($00000501);
  kEdsPropertyID_Evf_OutputDevice = Cardinal($00000500);

  // Kimeneti eszközök (Output Device) értékei
  kEdsOutputDevice_TFT            = Cardinal($00000001); // Kamera saját LCD kijelzője
  kEdsOutputDevice_PC             = Cardinal($00000002); // Számítógép (USB folyam)

type
  {-----------------------------------------------------------------------------
   Gyári rekordstruktúrák (Structures) leképezése
  -----------------------------------------------------------------------------}
  PEdsPoint = ^EdsPoint;
  EdsPoint = record
    x: EdsInt32;
    y: EdsInt32;
  end;

  PEdsSize = ^EdsSize;
  EdsSize = record
    width: EdsInt32;
    height: EdsInt32;
  end;

  PEdsRect = ^EdsRect;
  EdsRect = record
    point: EdsPoint;
    size: EdsSize;
  end;

  PEdsRational = ^EdsRational;
  EdsRational = record
    numerator: EdsInt32;
    denominator: EdsUInt32;
  end;

  PEdsTime = ^EdsTime;
  EdsTime = record
    year: EdsUInt32;
    month: EdsUInt32;
    day: EdsUInt32;
    hour: EdsUInt32;
    minute: EdsUInt32;
    second: EdsUInt32;
    milliseconds: EdsUInt32;
  end;

  PEdsDeviceInfo = ^EdsDeviceInfo;
  EdsDeviceInfo = record
    szPortName: array[0..EDS_MAX_NAME - 1] of EdsChar;
    szDeviceDescription: array[0..EDS_MAX_NAME - 1] of EdsChar;
    deviceSubType: EdsUInt32;
    reserved: EdsUInt32;
  end;

  PEdsVolumeInfo = ^EdsVolumeInfo;
  EdsVolumeInfo = record
    storageType: EdsUInt32;
    access: EdsUInt32; // EdsAccess
    maxCapacity: EdsUInt64;
    freeSpaceInBytes: EdsUInt64;
    szVolumeLabel: array[0..EDS_MAX_NAME - 1] of EdsChar;
  end;

  PEdsDirectoryItemInfo = ^EdsDirectoryItemInfo;
  EdsDirectoryItemInfo = record
    size: EdsUInt64;
    isFolder: EdsBool;
    groupID: EdsUInt32;
    option: EdsUInt32;
    szFileName: array[0..EDS_MAX_NAME - 1] of EdsChar;
    format: EdsUInt32;
    dateTime: EdsUInt32;
  end;

  PEdsImageInfo = ^EdsImageInfo;
  EdsImageInfo = record
    width: EdsUInt32;
    height: EdsUInt32;
    numOfComponents: EdsUInt32;
    componentDepth: EdsUInt32;
    effectiveRect: EdsRect;
    reserved1: EdsUInt32;
    reserved2: EdsUInt32;
  end;

  PEdsSaveImageSetting = ^EdsSaveImageSetting;
  EdsSaveImageSetting = record
    JPEGQuality: EdsUInt32;
    iccProfileStream: Pointer; // EdsStreamRef
    reserved: EdsUInt32;
  end;

  PEdsPropertyDesc = ^EdsPropertyDesc;
  EdsPropertyDesc = record
    form: EdsInt32;   
    access: EdsInt32; 
    numElements: EdsInt32;
    propDesc: array[0..127] of EdsInt32;
  end;

  PEdsPictureStyleDesc = ^EdsPictureStyleDesc;
  EdsPictureStyleDesc = record
    contrast: EdsInt32;
    sharpness: EdsUInt32;
    saturation: EdsInt32;
    colorTone: EdsInt32;
    filterEffect: EdsUInt32;
    toningEffect: EdsUInt32;
    sharpFineness: EdsUInt32;
    sharpThreshold: EdsUInt32;
  end;

  PEdsFocusPoint = ^EdsFocusPoint;
  EdsFocusPoint = record
    valid: EdsUInt32;
    selected: EdsUInt32;
    justFocus: EdsUInt32;
    rect: EdsRect;
    reserved: EdsUInt32;
  end;

  PEdsFocusInfo = ^EdsFocusInfo;
  EdsFocusInfo = record
    imageRect: EdsRect;
    pointNumber: EdsUInt32;
    focusPoint: array[0..1052] of EdsFocusPoint;
    executeMode: EdsUInt32;
  end;

  PEdsUsersetData = ^EdsUsersetData;
  EdsUsersetData = record
    valid: EdsUInt32;
    dataSize: EdsUInt32;
    szCaption: array[0..31] of EdsChar;
    data: array[0..0] of EdsUInt8; // C-s flexibilis tömb leképezése
  end;

  PEdsCapacity = ^EdsCapacity;
  EdsCapacity = record
    numberOfFreeClusters: EdsInt32;
    bytesPerSector: EdsInt32;
    reset: EdsBool;
  end;

  PEdsFramePoint = ^EdsFramePoint;
  EdsFramePoint = record
    x: EdsInt32;
    y: EdsInt32;
  end;

  PEdsCameraPos = ^EdsCameraPos;
  EdsCameraPos = record
    status: EdsInt32;
    position: EdsInt32;
    rolling: EdsInt32;
    pitching: EdsInt32;
  end;

  PEdsFocusShiftSet = ^EdsFocusShiftSet;
  EdsFocusShiftSet = record
    version: EdsInt32;
    focusShiftFunction: EdsInt32;
    shootingNumber: EdsInt32;
    stepWidth: EdsInt32;
    exposureSmoothing: EdsInt32;
  end;

  PEdsManualWBData = ^EdsManualWBData;
  EdsManualWBData = record
    valid: EdsInt32;
    dataSize: EdsInt32;
    szCaption: array[0..31] of EdsChar;
    data: array[0..7] of EdsInt8;
  end;

  { Custom Stream Callbacks & Interfész }
  EdsReadStream = function(inContext: Pointer; inReadSize: EdsUInt32; outBuffer: Pointer; outReadSize: PEdsUInt32): EdsError; stdcall;   
  EdsWriteStream = function(inContext: Pointer; inWriteSize: EdsUInt32; const inBuffer: Pointer; outWrittenSize: PEdsUInt32): EdsError; stdcall;
  EdsSeekStream = function(inContext: Pointer; inSeekOffset: EdsInt32; inSeekOrigin: EdsUInt32): EdsError; stdcall;
  EdsTellStream = function(inContext: Pointer; outPosition: PEdsInt32): EdsError; stdcall;
  EdsGetStreamLength = function(inContext: Pointer; outLength: PEdsUInt32): EdsError; stdcall;

  PEdsIStream = ^EdsIStream;
  EdsIStream = record
    context: Pointer;
    read: EdsReadStream;
    write: EdsWriteStream;
    seek: EdsSeekStream;
    tell: EdsTellStream;
    getLength: EdsGetStreamLength;
  end;

implementation

end.