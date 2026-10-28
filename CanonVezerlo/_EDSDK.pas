unit _EDSDK;

interface

uses
  Winapi.Windows, _EDSDKTypes;

const
  {$IFDEF MSWINDOWS}
    EDSDKDLL = 'EDSDK.dll';
  {$ELSE}
    EDSDKDLL = 'EDSDK.framework/EDSDK';
  {$ENDIF}

type
  { Alapvető referencia és típusleképezések a gyári fejléc szerint }
  EdsBaseRef          = Pointer;
  EdsCameraListRef    = Pointer;
  EdsCameraRef        = Pointer;
  EdsVolumeRef        = Pointer;
  EdsDirectoryItemRef = Pointer;
  EdsStreamRef        = Pointer;
  EdsImageRef         = Pointer;
  PEdsImageRef        = ^EdsImageRef;
  EdsEvfImageRef      = Pointer;
  PEdsEvfImageRef     = ^EdsEvfImageRef;

  { Callback függvények definíciói szabványos, tiszta Pointer kontextussal }
  EdsProgressCallback = function(inPercent: EdsUInt32; inContext: Pointer; var outCancel: EdsBool): EdsError; stdcall;
  EdsCameraAddedHandler = function(inContext: Pointer): EdsError; stdcall;
  EdsPropertyEventHandler = function(inEvent: EdsPropertyEvent; inPropertyID: EdsPropertyID; inParam: EdsUInt32; inContext: Pointer): EdsError; stdcall;
  EdsObjectEventHandler = function(inEvent: EdsObjectEvent; inRef: EdsBaseRef; inContext: Pointer): EdsError; stdcall;
  EdsStateEventHandler = function(inEvent: EdsStateEvent; inEventData: EdsUInt32; inContext: Pointer): EdsError; stdcall;

{ Basic functions }
function EdsInitializeSDK: EdsError; stdcall; external EDSDKDLL;
function EdsTerminateSDK: EdsError; stdcall; external EDSDKDLL;

{ Reference-counter operating functions }
function EdsRetain(inRef: EdsBaseRef): EdsUInt32; stdcall; external EDSDKDLL;
function EdsRelease(inRef: EdsBaseRef): EdsUInt32; stdcall; external EDSDKDLL;

{ Item-tree operating functions }
function EdsGetChildCount(inRef: EdsBaseRef; outCount: PEdsUInt32): EdsError; stdcall; external EDSDKDLL;
function EdsGetChildAtIndex(inRef: EdsBaseRef; inIndex: EdsInt32; outRef: PEdsBaseRef): EdsError; stdcall; external EDSDKDLL;
function EdsGetParent(inRef: EdsBaseRef; outParentRef: PEdsBaseRef): EdsError; stdcall; external EDSDKDLL;

{ Property operating functions }
function EdsGetPropertySize(inRef: EdsBaseRef; inPropertyID: EdsPropertyID; inParam: EdsInt32; outDataType: PEdsDataType; outSize: PEdsUInt32): EdsError; stdcall; external EDSDKDLL;
function EdsGetPropertyData(inRef: EdsBaseRef; inPropertyID: EdsPropertyID; inParam: EdsInt32; inPropertySize: EdsUInt32; outPropertyData: Pointer): EdsError; stdcall; external EDSDKDLL;
function EdsSetPropertyData(inRef: EdsBaseRef; inPropertyID: EdsPropertyID; inParam: EdsInt32; inPropertySize: EdsUInt32; const inPropertyData: Pointer): EdsError; stdcall; external EDSDKDLL;
function EdsGetPropertyDesc(inRef: EdsBaseRef; inPropertyID: EdsPropertyID; outPropertyDesc: PEdsPropertyDesc): EdsError; stdcall; external EDSDKDLL;

{ Device-list and device operating functions }
function EdsGetCameraList(outCameraListRef: PEdsCameraListRef): EdsError; stdcall; external EDSDKDLL;

{ Camera operating functions }
function EdsGetDeviceInfo(inCameraRef: EdsCameraRef; outDeviceInfo: PEdsDeviceInfo): EdsError; stdcall; external EDSDKDLL;
function EdsOpenSession(inCameraRef: EdsCameraRef): EdsError; stdcall; external EDSDKDLL;
function EdsCloseSession(inCameraRef: EdsCameraRef): EdsError; stdcall; external EDSDKDLL;
function EdsSendCommand(inCameraRef: EdsCameraRef; inCommand: EdsCameraCommand; inParam: EdsInt32): EdsError; stdcall; external EDSDKDLL;
function EdsSendStatusCommand(inCameraRef: EdsCameraRef; inStatusCommand: EdsCameraStatusCommand; inParam: EdsInt32): EdsError; stdcall; external EDSDKDLL;
function EdsSetCapacity(inCameraRef: EdsCameraRef; inCapacity: EdsCapacity): EdsError; stdcall; external EDSDKDLL;
{ Volume operating functions }
function EdsGetVolumeInfo(inVolumeRef: EdsVolumeRef; outVolumeInfo: PEdsVolumeInfo): EdsError; stdcall; external EDSDKDLL;
function EdsFormatVolume(inVolumeRef: EdsVolumeRef): EdsError; stdcall; external EDSDKDLL;

{ Directory-item operating functions }
function EdsGetDirectoryItemInfo(inDirItemRef: EdsDirectoryItemRef; outDirItemInfo: PEdsDirectoryItemInfo): EdsError; stdcall; external EDSDKDLL;
function EdsDeleteDirectoryItem(inDirItemRef: EdsDirectoryItemRef): EdsError; stdcall; external EDSDKDLL;
function EdsDownload(inDirItemRef: EdsDirectoryItemRef; inReadSize: EdsUInt64; outStream: EdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsDownloadCancel(inDirItemRef: EdsDirectoryItemRef): EdsError; stdcall; external EDSDKDLL;
function EdsDownloadComplete(inDirItemRef: EdsDirectoryItemRef): EdsError; stdcall; external EDSDKDLL;
function EdsDownloadThumbnail(inDirItemRef: EdsDirectoryItemRef; outStream: EdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsGetAttribute(inDirItemRef: EdsDirectoryItemRef; outFileAttribute: PEdsFileAttributes): EdsError; stdcall; external EDSDKDLL;
function EdsSetAttribute(inDirItemRef: EdsDirectoryItemRef; inFileAttribute: EdsFileAttributes): EdsError; stdcall; external EDSDKDLL;

{ Stream operating functions }
function EdsCreateFileStream(const inFileName: PAnsiChar; inCreateDisposition: EdsUInt32; inDesiredAccess: EdsUInt32; outStream: EdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsCreateMemoryStream(inBufferSize: EdsUInt64; outStream: PEdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsCreateMemoryStreamFromPointer(inUserBuffer: Pointer; inBufferSize: EdsUInt64; outStream: PEdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsGetPointer(inStream: EdsStreamRef; outPointer: PPointer): EdsError; stdcall; external EDSDKDLL;
function EdsRead(inStreamRef: EdsStreamRef; inReadSize: EdsUInt64; outBuffer: Pointer; outReadSize: PEdsUInt64): EdsError; stdcall; external EDSDKDLL;
function EdsWrite(inStreamRef: EdsStreamRef; inWriteSize: EdsUInt64; const inBuffer: Pointer; outWrittenSize: PEdsUInt64): EdsError; stdcall; external EDSDKDLL;
function EdsSeek(inStreamRef: EdsStreamRef; inSeekOffset: EdsInt64; inSeekOrigin: EdsSeekOrigin): EdsError; stdcall; external EDSDKDLL;
function EdsGetPosition(inStreamRef: EdsStreamRef; outPosition: PEdsUInt64): EdsError; stdcall; external EDSDKDLL;
function EdsGetLength(inStreamRef: EdsStreamRef; outLength: PEdsUInt64): EdsError; stdcall; external EDSDKDLL;
function EdsCopyData(inStreamRef: EdsStreamRef; inWriteSize: EdsUInt64; outStreamRef: EdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsSetProgressCallback(inRef: EdsBaseRef; inProgressCallback: EdsProgressCallback; inProgressOption: EdsProgressOption; inContext: Pointer): EdsError; stdcall; external EDSDKDLL;

{ Image operating functions }
function EdsCreateImageRef(inStreamRef: EdsStreamRef; outImageRef: PEdsImageRef): EdsError; stdcall; external EDSDKDLL;
function EdsGetImageInfo(inImageRef: EdsImageRef; inImageSource: EdsImageSource; outImageInfo: PEdsImageInfo): EdsError; stdcall; external EDSDKDLL;
function EdsGetImage(inImageRef: EdsImageRef; inImageSource: EdsImageSource; inImageType: EdsTargetImageType; inSrcRect: EdsRect; inDstSize: EdsSize; outStreamRef: EdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsCreateEvfImageRef(inStreamRef: EdsStreamRef; outEvfImageRef: PEdsEvfImageRef): EdsError; stdcall; external EDSDKDLL;
function EdsDownloadEvfImage(inCameraRef: EdsCameraRef; inEvfImageRef: EdsEvfImageRef): EdsError; stdcall; external EDSDKDLL;

{ Event handler registering functions }
function EdsSetCameraAddedHandler(inCameraAddedHandler: EdsCameraAddedHandler; inContext: Pointer): EdsError; stdcall; external EDSDKDLL;
function EdsSetPropertyEventHandler(inCameraRef: EdsCameraRef; inEvent: EdsPropertyEvent; inPropertyEventHandler: EdsPropertyEventHandler; inContext: Pointer): EdsError; stdcall; external EDSDKDLL;
function EdsSetObjectEventHandler(inCameraRef: EdsCameraRef; inEvent: EdsObjectEvent; inObjectEventHandler: EdsObjectEventHandler; inContext: Pointer): EdsError; stdcall; external EDSDKDLL;
function EdsSetCameraStateEventHandler(inCameraRef: EdsCameraRef; inEvent: EdsStateEvent; inStateEventHandler: EdsStateEventHandler; inContext: Pointer): EdsError; stdcall; external EDSDKDLL;

function EdsCreateStream(inStream: PEdsIStream; outStreamRef: PEdsStreamRef): EdsError; stdcall; external EDSDKDLL;
function EdsGetEvent: EdsError; stdcall; external EDSDKDLL;
function EdsSetFramePoint(inCameraRef: EdsCameraRef; inFramepoint: EdsPoint; inLockAfFrame: EdsBool): EdsError; stdcall; external EDSDKDLL;

implementation

end.