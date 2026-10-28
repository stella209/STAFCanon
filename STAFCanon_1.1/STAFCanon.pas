unit STAFCanon;
(**********************************************************
*  TCanon                                                 *
*                                                         *
*  Delphy XE5 component for controll remote Canon Cameras *
*  by USB cable. It is use Canon SDK 3.12.                *
*   This component under development. Use it your risk.   *
*  Exemple program: STAFCanonTest                         *
*                                                         *
*  by Agócs László Hungary 2026                           *
*  email: lagocsstella@gmail.com                          *
*                                                         *
**********************************************************)

interface

uses
  WinApi.Windows, System.SysUtils, System.Classes, System.Variants, Vcl.Graphics,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.Forms, System.DateUtils,
  _EDSDK, _EDSDKErrors, _EDSDKTypes;

type
  TPropRec = record
    PropStr : string;
    PropID  : EdsUInt32;
  end;
  PPropList = ^TPropRec;

  TTransferMode = (toFile,toMemory);

  TFileNameType = (fntCounter,fntDateTime,fntUT,fntJD);

  TLiveViewFrameEvent = procedure(Sender: TObject; ABitmap: TBitmap) of object;
  TPhotoCapturedEvent = procedure(Sender: TObject; outBMP: Tbitmap; AMemStream: TMemoryStream; const ASavedPath: string) of object;
  TCanonErrorEvent    = procedure(Sender: TObject; const AMsg: string) of object;
  TCanonPropertyEvent = procedure(Sender: TObject; APropertyID: EdsPropertyID; AParam: EdsUInt32) of object;
  TCanonStateEvent    = procedure(Sender: TObject; AStateEventID: EdsStateEvent; AParam: EdsUInt32) of object;
  TCanonProgressEvent = procedure(Sender: TObject; APercent: EdsUInt32; var ABreak: Boolean) of object;

  TCanon = class(TComponent)
  private
    FSDKInitialized: Boolean;
    FSessionOpened: Boolean;
    FLiveViewActive: Boolean;
    FCameraRef: EdsCameraRef;
    FCameraListRef: EdsCameraListRef;
    FEvfTimer: TTimer;
    FSaveToFile: Boolean;

    { available range list of capture paramter }
    FAeModeDesc       : EdsPropertyDesc;
    FAvDesc           : EdsPropertyDesc;
    FTvDesc           : EdsPropertyDesc;
    FIsoDesc          : EdsPropertyDesc;
    FBatteryLevelDesc : EdsPropertyDesc;
    FJpegQualityDesc  : EdsPropertyDesc;
    FWBDesc           : EdsPropertyDesc;

    // BULB Expozícióhoz szükséges belsõ változók
    FBulbTimer: TTimer;
    FBulbRemainingMs: Integer;

    FOnConnect: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnLiveViewFrame: TLiveViewFrameEvent;
    FOnPhotoCaptured: TPhotoCapturedEvent;
    FOnError: TCanonErrorEvent;
    FOnPropertyChange: TCanonPropertyEvent;
    FOnStateChange: TCanonStateEvent;
    FOnProgress: TCanonProgressEvent;
    FFilePath: string;
    FFileName: string;
    FTransferMode: TTransferMode;
    FBatteryLevel: EdsUInt32;
    FWB: EdsUInt32;
    FAv: EdsUInt32;
    FJpegQuality: EdsUInt32;
    FTv: EdsUInt32;
    FAeMode: EdsUInt32;
    FIso: EdsUInt32;
    FFileNameType: TFileNameType;
    procedure SetSaveToFile(const Value: Boolean);
    procedure OnTimerTick(Sender: TObject);
    procedure OnBulbTimerTick(Sender: TObject); // BULB idõzítõ leütés
    procedure DoError(const AMsg: string; AErrCode: EdsError);

//    procedure SetFileName(const Value: string);
//    procedure SetSavePath(const Value: string);protected
    procedure Loaded; override;
    procedure SetFileName(const Value: string);
    procedure SetFilePath(const Value: string);  public

  protected
    // ÚJ METÓDUS A BIZTONSÁGOS SZINKRONIZÁLÁSHOZ:
    procedure DoPropertyChange(APropertyID: EdsPropertyID; AParam: EdsUInt32);

  public
    cameraList    : TStringList;       // List of existing EOS cameras
    CameraString  : string;            // Name of active camera
    cameraCount   : EdsUInt32;         // Count of Cameras

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    procedure ScanCameras( CamList : TStrings );
    procedure StartLiveView;
    procedure StopLiveView;
    procedure Capture;

    procedure BulbCapture(ADurationMs: Integer); // Új BULB exponáló eljárás
    procedure EndBulbCapture;                    // Manuális kényszerített leállítás

//    function HandleObjectEvent(inEvent: EdsObjectEvent; inRef: EdsBaseRef): EdsError;
    function getImageData(inEvent: EdsObjectEvent; inRef: EdsBaseRef): EdsError;
    function HandlePropertyEvent(inEvent: EdsPropertyEvent; inPropertyID: EdsPropertyID; inParam: EdsUInt32): EdsError;
    function HandleStateEvent(inEvent: EdsStateEvent; inParam: EdsUInt32): EdsError;
    function HandleProgressEvent(inPercent: EdsUInt32; inContext: PEdsVoid; var outCancel: EdsBool): EdsError;

    { interface procedure and function }
    function getProperty( id : EdsPropertyID ): Variant;
    function setProperty(id: EdsPropertyID; value: Variant): EdsError;

    function  GetCamaraPropertyDesc(id: EdsPropertyID): EdsPropertyDesc;
    procedure SetCameraPropertyDesc(id: EdsPropertyID; desc: EdsPropertyDesc);
    function  getPropertyDesc( id: EdsPropertyID ) : EdsError;

    function findAeModePropIndex(value: EdsUInt32): integer;
    function findAvPropIndex(value: EdsUInt32): integer;
    function findIsoPropIndex(value: EdsUInt32): integer;
    function findTvPropIndex(value: EdsUInt32): integer;
    function findWBPropIndex(value: EdsUInt32): integer;
    function findQualityPropIndex(value: EdsUInt32): integer;

    function  FindAeModeID(sAeMode: string; var data: EdsUInt32): boolean;
    function  FindAeModeStr(ID: EdsUInt32; var sAEMode : string): boolean;
    function  FindISOID(sISO: string; var data: EdsUInt32): boolean;
    function  FindISOStr(ID: EdsUInt32; var sISO: string): boolean;
    function  FindTvID(sTv: string; var data: EdsUInt32): boolean;
    function  FindTvStr(ID: EdsUInt32; var sTv: string): boolean;
    function  FindWBID(sWB: string; var data: EdsUInt32): boolean;
    function  FindWBStr(ID: EdsUInt32; var sWB: string): boolean;
    function  FindQualityID(sQ: string; var data: EdsUInt32): boolean;
    function  FindQualityStr(ID: EdsUInt32; var sQ: string): boolean;

    function  GetPropertyList(const VArray: array of TPropRec;
                               PropertyID: EdsUInt32): TStrings;
    function  FindPropID(const VArray: array of TPropRec; s: string;
                               var data: EdsUInt32): boolean;
    function  FindPropStr(const VArray: array of TPropRec; ID: EdsUInt32;
                                var data: string): boolean;
    function  FindPropRec(const VArray: array of TPropRec; V: Variant;
                                var data: TPropRec): boolean;
    function  FindPropIndex(const VArray: array of TPropRec; Value: integer;
                                var data: integer): boolean;

    function  GetAEModeList: TStrings;
    function  GetTvList: TStrings;
    function  GetAvList: TStrings;
    function  GetISOList: TStrings;
    function  GetQualityList: TStrings;
    function  GetWBList: TStrings;

    function  GetOwnerName: string;
    function  GetTime: TDateTime;
    function  SetTime( sTime: TDateTime ): EdsError;
    function  GetAEMode: string;
    function  SetAEMode( sAEMode: string ): EdsError;
    function  GetISO: string;
    function  SetISO( sISO: string ): EdsError;
    function  GetTv: string;
    function  SetTv( sTv: string ): EdsError;
    function  GetWB: string;
    function  SetWB( sWB: string ): EdsError;
    function  GetQuality: string;
    function  SetQuality( sQ: string ): EdsError;

    property  IsConnected     : Boolean read FSessionOpened;
    property  IsLiveViewActive: Boolean read FLiveViewActive;
    property  AEMode         :EdsUInt32 read FAeMode write FAeMode;
    property  Av             :EdsUInt32 read FAv write FAv;
    property  Tv             :EdsUInt32 read FTv write FTv;
    property  Iso            :EdsUInt32 read FIso write FIso;
    property  WB             :EdsUInt32 read FWB write FWB;
    property  BatteryLevel   :EdsUInt32 read FBatteryLevel write FBatteryLevel;
    property  JpegQuality    :EdsUInt32 read FJpegQuality write FJpegQuality;

    function  FileNameGenerate(fn: String): string;

  published
    property FilePath    : string  read FFilePath write SetFilePath;
    property FileName    : string  read FFileName write SetFileName;
    property FileNameType: TFileNameType read FFileNameType write FFileNameType;
    property TransferMode: TTransferMode read FTransferMode write FTransferMode;
    property SaveToFile: Boolean read FSaveToFile write SetSaveToFile default True;

    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnLiveViewFrame: TLiveViewFrameEvent read FOnLiveViewFrame write FOnLiveViewFrame;
    property OnPhotoCaptured: TPhotoCapturedEvent read FOnPhotoCaptured write FOnPhotoCaptured;
    property OnError: TCanonErrorEvent read FOnError write FOnError;
    property OnPropertyChange: TCanonPropertyEvent read FOnPropertyChange write FOnPropertyChange;
    property OnStateChange: TCanonStateEvent read FOnStateChange write FOnStateChange;
    property OnProgress: TCanonProgressEvent read FOnProgress write FOnProgress;
  end;

  {      all available camera setting       }
  { ----------------------------------------}
  { This sampel uses the following property }
  const AeModeProp : array[ 0..16 ] of TPropRec = (
    ( PropStr: 'P' ;          PropID: 0 ),
    ( PropStr: 'Tv' ;         PropID: 1 ),
    ( PropStr: 'Av' ;         PropID: 2 ),
    ( PropStr: 'M' ;          PropID: 3 ),
    ( PropStr: 'Bulb' ;       PropID: 4 ),
    ( PropStr: 'A-DEP' ;      PropID: 5 ),
    ( PropStr: 'DEP' ;        PropID: 6 ),
    ( PropStr: 'C' ;          PropID: 7 ),
    ( PropStr: 'Lock' ;       PropID: 8 ),
    ( PropStr: 'Green Mode' ; PropID: 9 ),
    ( PropStr: 'Night Portrait' ; PropID: 10 ),
    ( PropStr: 'Sports' ;      PropID: 11 ),
    ( PropStr: 'Portrait' ;    PropID: 12 ),
    ( PropStr: 'Landscape' ;   PropID: 13 ),
    ( PropStr: 'Close Up' ;    PropID: 14 ),
    ( PropStr: 'Disable Strobe' ; PropID: 15 ),
    ( PropStr: 'Unknown' ;     PropID: $FFFFFFFF )
  );

  const AvProp : array[ 0..53] of TPropRec = (
    ( PropStr: '1.0'; PropID: $08 ), ( PropStr: '1.1'; PropID: $0B ), ( PropStr: '1.2'; PropID: $0C ),
    ( PropStr: '1.2'; PropID: $0D ), ( PropStr: '1.4'; PropID: $10 ), ( PropStr: '1.6'; PropID: $13 ),
    ( PropStr: '1.8'; PropID: $14 ), ( PropStr: '1.8'; PropID: $15 ), ( PropStr: '2.0'; PropID: $18 ),
    ( PropStr: '2.2'; PropID: $1B ), ( PropStr: '2.5'; PropID: $1C ), ( PropStr: '2.5'; PropID: $1D ),
    ( PropStr: '2.8'; PropID: $20 ), ( PropStr: '3.2'; PropID: $23 ), ( PropStr: '3.5'; PropID: $24 ),
    ( PropStr: '3.5'; PropID: $25 ), ( PropStr: '4'  ; PropID: $28 ), ( PropStr: '4';   PropID: $2B ),
    ( PropStr: '4.5'; PropID: $2C ), ( PropStr: '5'  ; PropID: $2D ), ( PropStr: '5.6'; PropID: $30 ),
    ( PropStr: '6.3'; PropID: $33 ), ( PropStr: '6.7'; PropID: $34 ), ( PropStr: '7.1'; PropID: $35 ),
    ( PropStr: '8'  ; PropID: $38 ), ( PropStr: '9'  ; PropID: $3B ), ( PropStr: '9.5'; PropID: $3C ),
    ( PropStr: '10';  PropID: $3D ), ( PropStr: '11';  PropID: $40 ), ( PropStr: '13';  PropID: $43 ),
    ( PropStr: '13';  PropID: $44 ), ( PropStr: '14';  PropID: $45 ), ( PropStr: '16';  PropID: $48 ),
    ( PropStr: '18';  PropID: $4B ), ( PropStr: '19';  PropID: $4C ), ( PropStr: '20';  PropID: $4D ),
    ( PropStr: '22';  PropID: $50 ), ( PropStr: '25';  PropID: $53 ), ( PropStr: '27';  PropID: $54 ),
    ( PropStr: '29';  PropID: $55 ), ( PropStr: '32';  PropID: $58 ), ( PropStr: '36';  PropID: $5B ),
    ( PropStr: '38';  PropID: $5C ), ( PropStr: '40';  PropID: $5D ), ( PropStr: '45';  PropID: $60 ),
    ( PropStr: '51';  PropID: $63 ), ( PropStr: '54';  PropID: $64 ), ( PropStr: '57';  PropID: $65 ),
    ( PropStr: '64';  PropID: $68 ), ( PropStr: '72';  PropID: $6B ), ( PropStr: '76';  PropID: $6C ),
    ( PropStr: '80';  PropID: $6D ), ( PropStr: '91';  PropID: $70 ), ( PropStr: 'Unknown'; PropID: $FFFFFFFF )
  );

  const TvProp : array[ 0.. 74] of TPropRec = (
    ( PropStr:'Bulb'; PropID: $0C ), ( PropStr:'30"'; PropID: $10 ), ( PropStr:'25"'; PropID: $13 ),
    ( PropStr:'20"';  PropID: $14 ), ( PropStr:'20"'; PropID: $15 ), ( PropStr:'15"'; PropID: $18 ),
    ( PropStr:'13"';  PropID: $1B ), ( PropStr:'10"'; PropID: $1C ), ( PropStr:'10"'; PropID: $1D ),
    ( PropStr:' 8"';  PropID: $20 ), ( PropStr:'6"' ; PropID: $23 ), ( PropStr:'6"' ; PropID: $24 ),
    ( PropStr:'5"';   PropID: $25 ), ( PropStr:'4"' ; PropID: $28 ), ( PropStr:'3"2'; PropID: $2B ),
    ( PropStr:'3"';   PropID: $2C ), ( PropStr:'2"5'; PropID: $2D ), ( PropStr:'2"' ; PropID: $30 ),
    ( PropStr:'1"6';  PropID: $33 ), ( PropStr:'1"5'; PropID: $34 ), ( PropStr:'1"3'; PropID: $35 ),
    ( PropStr:'1"';   PropID: $38 ), ( PropStr:'0"8'; PropID: $3B ), ( PropStr:'0"7'; PropID: $3C ),
    ( PropStr:'0"6';  PropID: $3D ), ( PropStr:'0"5'; PropID: $40 ), ( PropStr:'0"4'; PropID: $43 ),
    ( PropStr:'0"3';  PropID: $44 ), ( PropStr:'0"3'; PropID: $45 ), ( PropStr:'4';   PropID: $48 ),
    ( PropStr:'5';    PropID: $4B ), ( PropStr:'6';   PropID: $4C ), ( PropStr:'6';   PropID: $4D ),
    ( PropStr:'8';    PropID: $50 ), ( PropStr:'10';  PropID: $53 ), ( PropStr:'10';  PropID: $54 ),
    ( PropStr:'13';   PropID: $55 ), ( PropStr:'15';  PropID: $58 ), ( PropStr:'20';  PropID: $5B ),
    ( PropStr:'20';   PropID: $5C ), ( PropStr:'25';  PropID: $5D ), ( PropStr:'30';  PropID: $60 ),
    ( PropStr:'40';   PropID: $63 ), ( PropStr:'45';  PropID: $64 ), ( PropStr:'50';  PropID: $65 ),
    ( PropStr:'60';   PropID: $68 ), ( PropStr:'80';  PropID: $6B ), ( PropStr:'90';  PropID: $6C ),
    ( PropStr:'100';  PropID: $6D ), ( PropStr:'125'; PropID: $70 ), ( PropStr:'160'; PropID: $73 ),
    ( PropStr:'180';  PropID: $74 ), ( PropStr:'200'; PropID: $75 ), ( PropStr:'250'; PropID: $78 ),
    ( PropStr:'320';  PropID: $7B ), ( PropStr:'350'; PropID: $7C ), ( PropStr:'400'; PropID: $7D ),
    ( PropStr:'500';  PropID: $80 ), ( PropStr:'640'; PropID: $83 ), ( PropStr:'750'; PropID: $84 ),
    ( PropStr:'800';  PropID: $85 ), ( PropStr:'1000';PropID: $88 ), ( PropStr:'1250';PropID: $8B ),
    ( PropStr:'1500'; PropID: $8C ), ( PropStr:'1600';PropID: $8D ), ( PropStr:'2000';PropID: $90 ),
    ( PropStr:'2500'; PropID: $93 ), ( PropStr:'3000';PropID: $94 ), ( PropStr:'3200';PropID: $95 ),
    ( PropStr:'4000'; PropID: $98 ), ( PropStr:'5000';PropID: $9B ), ( PropStr:'6000';PropID: $9C ),
    ( PropStr:'6400'; PropID: $9D ), ( PropStr:'8000';PropID: $A0 ), ( PropStr:'Unknown'; PropID: $FFFFFFFF )
  );

  const IsoProp : array[0..19 ] of TPropRec = (
    ( PropStr: '6'   ; PropID: $28 ),
    ( PropStr: '12'  ; PropID: $30 ),
    ( PropStr: '25'  ; PropID: $38 ),
    ( PropStr: '50'  ; PropID: $40 ),
    ( PropStr: '100' ; PropID: $48 ),
    ( PropStr: '125' ; PropID: $4B ),
    ( PropStr: '160' ; PropID: $4D ),
    ( PropStr: '200' ; PropID: $50 ),
    ( PropStr: '250' ; PropID: $53 ),
    ( PropStr: '320' ; PropID: $55 ),
    ( PropStr: '400' ; PropID: $58 ),
    ( PropStr: '500' ; PropID: $5B ),
    ( PropStr: '640' ; PropID: $5D ),
    ( PropStr: '800' ; PropID: $60 ),
    ( PropStr: '1000' ; PropID: $63 ),
    ( PropStr: '1250' ; PropID: $65 ),
    ( PropStr: '1600' ; PropID: $68 ),
    ( PropStr: '3200' ; PropID: $70 ),
    ( PropStr: '6400' ; PropID: $78 ),
    ( PropStr: 'Unknown' ; PropID: $FFFFFFFF )
  );

  const ImageTypeProp : array[0..4 ] of TPropRec = (
    ( PropStr: 'UnKnown'    ; PropID: 0 ),
    ( PropStr: 'Jpeg'       ; PropID: 1 ),
    ( PropStr: 'CRW'        ; PropID: 2 ),
    ( PropStr: 'RAW'        ; PropID: 4 ),
    ( PropStr: 'CR2'        ; PropID: 6 )
  );

  const ImageSizeProp : array[0..5 ] of TPropRec = (
    ( PropStr: 'Large'    ; PropID: 0 ),
    ( PropStr: 'Middle'   ; PropID: 1 ),
    ( PropStr: 'Small'    ; PropID: 2 ),
    ( PropStr: 'Middle1'  ; PropID: 5 ),
    ( PropStr: 'Middle2'  ; PropID: 6 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  const ImageQualityProp : array[0..4 ] of TPropRec = (
    ( PropStr: 'Normal'   ; PropID: 2 ),
    ( PropStr: 'Fine'     ; PropID: 3 ),
    ( PropStr: 'Lossless' ; PropID: 4 ),
    ( PropStr: 'SuperFine'; PropID: 5 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  // White ballance
  const WBProp : array[0..12 ] of TPropRec = (
    ( PropStr: 'Auto'       ; PropID: 0 ),
    ( PropStr: 'Daylight'   ; PropID: 1 ),
    ( PropStr: 'Cloudy'     ; PropID: 2 ),
    ( PropStr: 'Tangsten'   ; PropID: 3 ),
    ( PropStr: 'Fluorescent'; PropID: 4 ),
    ( PropStr: 'Strobe'     ; PropID: 5 ),
    ( PropStr: 'WhitePaper' ; PropID: 6 ),
    ( PropStr: 'Shade'      ; PropID: 7 ),
    ( PropStr: 'ColorTemp'  ; PropID: 8 ),
    ( PropStr: 'PCSet1'     ; PropID: 9 ),
    ( PropStr: 'PCSet2'     ; PropID: 10 ),
    ( PropStr: 'PCSet3'     ; PropID: 11 ),
    ( PropStr: 'Pasted'     ; PropID: 12 )
  );

  // Image quality in the menu Quality
(*
      /* Jpeg Only */
    EdsImageQuality_LJ        =    0x0010ff0f,    /* Jpeg Large */
    EdsImageQuality_MJ        =    0x0110ff0f,    /* Jpeg Middle */
    EdsImageQuality_M1J        =    0x0510ff0f,    /* Jpeg Middle1 */
    EdsImageQuality_M2J        =    0x0610ff0f,    /* Jpeg Middle2 */
    EdsImageQuality_SJ        =    0x0210ff0f,    /* Jpeg Small */
    EdsImageQuality_S1J        =    0x0e10ff0f,    /* Jpeg Small1 */
    EdsImageQuality_S2J        =    0x0f10ff0f,    /* Jpeg Small2 */
    EdsImageQuality_LJF        =    0x0013ff0f,    /* Jpeg Large Fine */
    EdsImageQuality_LJN        =    0x0012ff0f,    /* Jpeg Large Normal */
    EdsImageQuality_MJF        =    0x0113ff0f,    /* Jpeg Middle Fine */
    EdsImageQuality_MJN        =    0x0112ff0f,    /* Jpeg Middle Normal */
    EdsImageQuality_SJF        =    0x0213ff0f,    /* Jpeg Small Fine */
    EdsImageQuality_SJN        =    0x0212ff0f,    /* Jpeg Small Normal */
    EdsImageQuality_S1JF    =    0x0E13ff0f,    /* Jpeg Small1 Fine */
    EdsImageQuality_S1JN    =    0x0E12ff0f,    /* Jpeg Small1 Normal */
    EdsImageQuality_S2JF    =    0x0F13ff0f,    /* Jpeg Small2 */
    EdsImageQuality_S3JF    =    0x1013ff0f,    /* Jpeg Small3 */

    /* RAW + Jpeg */
    EdsImageQuality_LR        =    0x0064ff0f,    /* RAW */
    EdsImageQuality_LRLJF    =    0x00640013,    /* RAW + Jpeg Large Fine */
    EdsImageQuality_LRLJN    =    0x00640012,    /* RAW + Jpeg Large Normal */
    EdsImageQuality_LRMJF    =    0x00640113,    /* RAW + Jpeg Middle Fine */
    EdsImageQuality_LRMJN    =    0x00640112,    /* RAW + Jpeg Middle Normal */
    EdsImageQuality_LRSJF    =    0x00640213,    /* RAW + Jpeg Small Fine */
    EdsImageQuality_LRSJN    =    0x00640212,    /* RAW + Jpeg Small Normal */
    EdsImageQuality_LRS1JF    =    0x00640E13,    /* RAW + Jpeg Small1 Fine */
    EdsImageQuality_LRS1JN    =    0x00640E12,    /* RAW + Jpeg Small1 Normal */
    EdsImageQuality_LRS2JF    =    0x00640F13,    /* RAW + Jpeg Small2 */
    EdsImageQuality_LRS3JF    =    0x00641013,    /* RAW + Jpeg Small3 */

    EdsImageQuality_LRLJ    =    0x00640010,    /* RAW + Jpeg Large */
    EdsImageQuality_LRMJ    =    0x00640110,    /* RAW + Jpeg Middle */
    EdsImageQuality_LRM1J    =    0x00640510,    /* RAW + Jpeg Middle1 */
    EdsImageQuality_LRM2J    =    0x00640610,    /* RAW + Jpeg Middle2 */
    EdsImageQuality_LRSJ    =    0x00640210,    /* RAW + Jpeg Small */
    EdsImageQuality_LRS1J    =    0x00640e10,    /* RAW + Jpeg Small1 */
    EdsImageQuality_LRS2J    =    0x00640f10,    /* RAW + Jpeg Small2 */

    /* MRAW(SRAW1) + Jpeg */
    EdsImageQuality_MR        =    0x0164ff0f,    /* MRAW(SRAW1) */
    EdsImageQuality_MRLJF    =    0x01640013,    /* MRAW(SRAW1) + Jpeg Large Fine */
    EdsImageQuality_MRLJN    =    0x01640012,    /* MRAW(SRAW1) + Jpeg Large Normal */
    EdsImageQuality_MRMJF    =    0x01640113,    /* MRAW(SRAW1) + Jpeg Middle Fine */
    EdsImageQuality_MRMJN    =    0x01640112,    /* MRAW(SRAW1) + Jpeg Middle Normal */
    EdsImageQuality_MRSJF    =    0x01640213,    /* MRAW(SRAW1) + Jpeg Small Fine */
    EdsImageQuality_MRSJN    =    0x01640212,    /* MRAW(SRAW1) + Jpeg Small Normal */
    EdsImageQuality_MRS1JF    =    0x01640E13,    /* MRAW(SRAW1) + Jpeg Small1 Fine */
    EdsImageQuality_MRS1JN    =    0x01640E12,    /* MRAW(SRAW1) + Jpeg Small1 Normal */
    EdsImageQuality_MRS2JF    =    0x01640F13,    /* MRAW(SRAW1) + Jpeg Small2 */
    EdsImageQuality_MRS3JF    =    0x01641013,    /* MRAW(SRAW1) + Jpeg Small3 */

    EdsImageQuality_MRLJ    =    0x01640010,    /* MRAW(SRAW1) + Jpeg Large */
    EdsImageQuality_MRM1J    =    0x01640510,    /* MRAW(SRAW1) + Jpeg Middle1 */
    EdsImageQuality_MRM2J    =    0x01640610,    /* MRAW(SRAW1) + Jpeg Middle2 */
    EdsImageQuality_MRSJ    =    0x01640210,    /* MRAW(SRAW1) + Jpeg Small */

    /* SRAW(SRAW2) + Jpeg */
    EdsImageQuality_SR        =    0x0264ff0f,    /* SRAW(SRAW2) */
    EdsImageQuality_SRLJF    =    0x02640013,    /* SRAW(SRAW2) + Jpeg Large Fine */
    EdsImageQuality_SRLJN    =    0x02640012,    /* SRAW(SRAW2) + Jpeg Large Normal */
    EdsImageQuality_SRMJF    =    0x02640113,    /* SRAW(SRAW2) + Jpeg Middle Fine */
    EdsImageQuality_SRMJN    =    0x02640112,    /* SRAW(SRAW2) + Jpeg Middle Normal */
    EdsImageQuality_SRSJF    =    0x02640213,    /* SRAW(SRAW2) + Jpeg Small Fine */
    EdsImageQuality_SRSJN    =    0x02640212,    /* SRAW(SRAW2) + Jpeg Small Normal */
    EdsImageQuality_SRS1JF    =    0x02640E13,    /* SRAW(SRAW2) + Jpeg Small1 Fine */
    EdsImageQuality_SRS1JN    =    0x02640E12,    /* SRAW(SRAW2) + Jpeg Small1 Normal */
    EdsImageQuality_SRS2JF    =    0x02640F13,    /* SRAW(SRAW2) + Jpeg Small2 */
    EdsImageQuality_SRS3JF    =    0x02641013,    /* SRAW(SRAW2) + Jpeg Small3 */

    EdsImageQuality_SRLJ    =    0x02640010,    /* SRAW(SRAW2) + Jpeg Large */
    EdsImageQuality_SRM1J    =    0x02640510,    /* SRAW(SRAW2) + Jpeg Middle1 */
    EdsImageQuality_SRM2J    =    0x02640610,    /* SRAW(SRAW2) + Jpeg Middle2 */
    EdsImageQuality_SRSJ    =    0x02640210,    /* SRAW(SRAW2) + Jpeg Small */

    /* CRAW + Jpeg */
    EdsImageQuality_CR        =    0x0063ff0f,    /* CRAW */
    EdsImageQuality_CRLJF    =    0x00630013,    /* CRAW + Jpeg Large Fine */
    EdsImageQuality_CRMJF    =    0x00630113,    /* CRAW + Jpeg Middle Fine  */
    EdsImageQuality_CRM1JF    =    0x00630513,    /* CRAW + Jpeg Middle1 Fine  */
    EdsImageQuality_CRM2JF    =    0x00630613,    /* CRAW + Jpeg Middle2 Fine  */
    EdsImageQuality_CRSJF    =    0x00630213,    /* CRAW + Jpeg Small Fine  */
    EdsImageQuality_CRS1JF    =    0x00630E13,    /* CRAW + Jpeg Small1 Fine  */
    EdsImageQuality_CRS2JF    =    0x00630F13,    /* CRAW + Jpeg Small2 Fine  */
    EdsImageQuality_CRS3JF    =    0x00631013,    /* CRAW + Jpeg Small3 Fine  */
    EdsImageQuality_CRLJN    =    0x00630012,    /* CRAW + Jpeg Large Normal */
    EdsImageQuality_CRMJN    =    0x00630112,    /* CRAW + Jpeg Middle Normal */
    EdsImageQuality_CRM1JN    =    0x00630512,    /* CRAW + Jpeg Middle1 Normal */
    EdsImageQuality_CRM2JN    =    0x00630612,    /* CRAW + Jpeg Middle2 Normal */
    EdsImageQuality_CRSJN    =    0x00630212,    /* CRAW + Jpeg Small Normal */
    EdsImageQuality_CRS1JN    =    0x00630E12,    /* CRAW + Jpeg Small1 Normal */

    EdsImageQuality_CRLJ    =    0x00630010,    /* CRAW + Jpeg Large */
    EdsImageQuality_CRMJ    =    0x00630110,    /* CRAW + Jpeg Middle */
    EdsImageQuality_CRM1J    =    0x00630510,    /* CRAW + Jpeg Middle1 */
    EdsImageQuality_CRM2J    =    0x00630610,    /* CRAW + Jpeg Middle2 */
    EdsImageQuality_CRSJ    =    0x00630210,    /* CRAW + Jpeg Small */
    EdsImageQuality_CRS1J    =    0x00630e10,    /* CRAW + Jpeg Small1 */
    EdsImageQuality_CRS2J    =    0x00630f10,    /* CRAW + Jpeg Small2 */

    /* HEIF */
    EdsImageQuality_HEIFL   =   0x0080ff0f,  /* HEIF Large */
    EdsImageQuality_RHEIFL  =   0x00640080,  /* RAW  + HEIF Large */
    EdsImageQuality_CRHEIFL =   0x00630080,  /* CRAW + HEIF Large */

    EdsImageQuality_HEIFLF    =  0x0083ff0f, /* HEIF Large Fine */
    EdsImageQuality_HEIFLN    =  0x0082ff0f, /* HEIF Large Normal */
    EdsImageQuality_HEIFMF    =  0x0183ff0f, /* HEIF Middle Fine */
    EdsImageQuality_HEIFMN    =  0x0182ff0f, /* HEIF Middle Normal */
    EdsImageQuality_HEIFS1F   =  0x0e83ff0f, /* HEIF Small1 Fine */
    EdsImageQuality_HEIFS1N   =  0x0e82ff0f, /* HEIF Small1 Normal */
    EdsImageQuality_HEIFS2F   =  0x0f83ff0f, /* HEIF Small2 Fine */
    EdsImageQuality_RHEIFLF   =  0x00640083, /* RAW + HEIF Large Fine */
    EdsImageQuality_RHEIFLN   =  0x00640082, /* RAW + HEIF Large Normal */
    EdsImageQuality_RHEIFMF   =  0x00640183, /* RAW + HEIF Middle Fine */
    EdsImageQuality_RHEIFMN   =  0x00640182, /* RAW + HEIF Middle Normal */
    EdsImageQuality_RHEIFS1F  =  0x00640e83, /* RAW + HEIF Small1 Fine */
    EdsImageQuality_RHEIFS1N  =  0x00640e82, /* RAW + HEIF Small1 Normal */
    EdsImageQuality_RHEIFS2F  =  0x00640f83, /* RAW + HEIF Small2 Fine */
    EdsImageQuality_CRHEIFLF  =  0x00630083, /* CRAW + HEIF Large Fine */
    EdsImageQuality_CRHEIFLN  =  0x00630082, /* CRAW + HEIF Large Normal */
    EdsImageQuality_CRHEIFMF  =  0x00630183, /* CRAW + HEIF Middle Fine */
    EdsImageQuality_CRHEIFMN  =  0x00630182, /* CRAW + HEIF Middle Normal */
    EdsImageQuality_CRHEIFS1F =  0x00630e83, /* CRAW + HEIF Small1 Fine */
    EdsImageQuality_CRHEIFS1N =  0x00630e82, /* CRAW + HEIF Small1 Normal */
    EdsImageQuality_CRHEIFS2F =  0x00630f83, /* CRAW + HEIF Small2 Fine */

    EdsImageQuality_Unknown = 0xffffffff,
*)
(*
  const QualityProp : array[0..7 ] of TPropRec = (
    ( PropStr: 'hL'         ; PropID: $00130F0F ),
    ( PropStr: 'lL'         ; PropID: $00120F0F ),
    ( PropStr: 'hM'         ; PropID: $01130F0F ),
    ( PropStr: 'lM'         ; PropID: $01120F0F ),
    ( PropStr: 'hS'         ; PropID: $02130F0F ),
    ( PropStr: 'lS'         ; PropID: $02120F0F ),
    ( PropStr: 'RAW+L'      ; PropID: $00640013 ),
    ( PropStr: 'RAW'        ; PropID: $00640F0F )
  );
*)

  const QualityProp : array[0..2 ] of TPropRec = (
    ( PropStr: 'L'          ; PropID: $0013ff0f ),
    ( PropStr: 'RAW+L'      ; PropID: $00640013 ),
    ( PropStr: 'RAW'        ; PropID: $0064ff0f )
  );


procedure Register;

implementation

function GlobalObjectEventHandler(inEvent: EdsObjectEvent; inRef: EdsBaseRef; inContext: Pointer): EdsError; stdcall;
var
  LCamera: TCanon;
begin
  Result := EDS_ERR_OK;
  // 1. Visszakapjuk a konkrét Delphi TCanon objektumot
  LCamera := TCanon(inContext);

  case inEvent of
  // 1. FIGYELJÜK AZ ÚJ KÉP ÁTVITELI KÉRELMET A KAMERÁTÓL
  kEdsObjectEvent_DirItemRequestTransfer:
  begin
    if inRef = nil then Exit;
      Result := LCamera.getImageData(inEvent, inRef);
  end;
  end;
end;

function GlobalPropertyEventHandler(inEvent: EdsPropertyEvent; inPropertyID:
         EdsPropertyID; inParam: EdsUInt32; inContext: PEdsVoid): EdsError; stdcall;
var
  LCamera: TCanon;
begin
  Result := EDS_ERR_OK;
  // BIZTONSÁGI ÖV: Ha a kontextus üres, azonnal lépjünk ki, különben Access Violation lesz!
  if inContext = nil then Exit;
  // 1. Visszakapjuk a konkrét Delphi TCanon objektumot
  LCamera := TCanon(inContext);
  case inEvent of
    kEdsPropertyEvent_PropertyChanged :
      begin
        case inPropertyID of
          kEdsPropID_AEMode   : LCamera.AEMode := inParam;
          kEdsPropID_ISOSpeed : LCamera.ISO    := inParam;
          kEdsPropID_Av       : LCamera.Av     := inParam;
          kEdsPropID_Tv       : LCamera.Tv     := inParam;
          kEdsPropID_WhiteBalance : LCamera.WB := inParam;
         end;
        // MEGHÍVÁS: Átadjuk a munkát a szálbiztos osztálymetódusnak
        LCamera.DoPropertyChange(inPropertyID, inParam);
      end;

    kEdsPropertyEvent_PropertyDescChanged :
      begin
        case inPropertyID of
          kEdsPropID_AEMode,
          kEdsPropID_ISOSpeed,
          kEdsPropID_Av,
          kEdsPropID_Tv,
          kEdsPropID_WhiteBalance,
          kEdsPropID_ImageQuality:
        end;
      end;
  end;
  Result := EDS_ERR_OK;
end;

function GlobalStateEventHandler(inEvent: EdsStateEvent;
         inParam: EdsUInt32; inContext: PEdsVoid): EdsError; stdcall;
var
  s: string;
begin
  Result:=EDS_ERR_OK;
  s:='';
  case inEvent of
   kEdsStateEvent_Shutdown:
     begin
       s:='Camera disconnected.';
     end;
   kEdsStateEvent_WillSoonShutDown:
     begin
       s:='The camera will shutdown!';
     end;
  end;
end;

function GlobalProgressEventHandler(inPercent: EdsUInt32; inContext: PEdsVoid; var outCancel: EdsBool): EdsError; stdcall;
var LBreak: Boolean;
var
  LCamera: TCanon;
begin
  Result := EDS_ERR_OK;
  // 1. Visszakapjuk a konkrét Delphi TCanon objektumot
  LCamera := TCanon(inContext);
  outCancel := False;
  if inContext <> nil then begin
    LBreak := False; Result := LCamera.HandleProgressEvent(inPercent, inContext, LBreak);
    if LBreak then outCancel := True;
  end;
end;

constructor TCanon.Create(AOwner: TComponent);
Var err : EdsError;
begin
  inherited Create(AOwner);
  err := EdsInitializeSDK;
  if err = EDS_ERR_OK then
  begin
    FSDKInitialized := true;
    SetTime(now);
  end else
    FSDKInitialized := False;

  FSDKInitialized := False; FSessionOpened := False; FLiveViewActive := False; FSaveToFile := True;
  FCameraRef := nil; FCameraListRef := nil;

  FEvfTimer := TTimer.Create(Self);
  FEvfTimer.Enabled := False; FEvfTimer.Interval := 40; FEvfTimer.OnTimer := OnTimerTick;

  // BULB Idõzítõ inicializálása (100ms-os mintavételezés a pontosságért)
  FBulbTimer := TTimer.Create(Self);
  FBulbTimer.Enabled := False; FBulbTimer.Interval := 100; FBulbTimer.OnTimer := OnBulbTimerTick;
  FBulbRemainingMs := 0;
  FSaveToFile      := False;
  FFilePath     := ExtractFilePath(Application.ExeName);
  FFileName     := 'CANON';
  FFileNameType    := fntJD;
end;

destructor TCanon.Destroy;
begin
  Disconnect;
  EdsTerminateSDK;
  inherited Destroy;
end;

procedure TCanon.Loaded;
begin inherited Loaded; end;

procedure TCanon.ScanCameras(CamList: TStrings);
var err : EdsError;
    count : EdsUInt32;
    i: integer;
    cam: EdsCameraRef;
    camera_list: EdsCameraListRef;
    device_info: EdsDeviceInfo;
    CamName: string;
begin
Try
  { get list of camera }
  err := EdsGetCameraList(@FCameraListRef);
  if err = EDS_ERR_OK then err := EdsGetChildCount(FCameraListRef, @cameraCount);
  camlist.Clear;
  if err = EDS_ERR_OK then begin
     for I := 0 to Pred(Cameracount) do
     begin
         EdsGetChildAtIndex(FcameraListRef, i, @FCameraRef);
         EdsGetDeviceInfo(FCameraRef, @device_info);
         CamName := string(device_info.szDeviceDescription);
         camlist.Add(CamName);
     end;
  end;
except
end;
end;

function TCanon.SetAEMode(sAEMode: string): EdsError;
begin

end;

procedure TCanon.SetCameraPropertyDesc(id: EdsPropertyID;
  desc: EdsPropertyDesc);
begin
  Case id of
    kEdsPropID_AEMode        : FAeModeDesc := desc;
    kEdsPropID_Tv            : FtvDesc := desc;
    kEdsPropID_Av            : FAvDesc := desc;
    kEdsPropID_ISOSpeed      : FIsoDesc := desc;
    kEdsPropID_BatteryLevel  : FBatteryLevelDesc := desc;
    kEdsPropID_ImageQuality  : FJpegQualityDesc := desc;
    kEdsPropID_WhiteBalance  : FWBDesc := desc;
  end;
end;

procedure TCanon.SetFileName(const Value: string);
begin
  FFileName := Value;
end;

procedure TCanon.SetFilePath(const Value: string);
begin
  FFilePath := Value;
end;

function TCanon.SetISO(sISO: string): EdsError;
var
  data: EdsUInt32;
begin
  Result := EDS_ERR_INVALID_PARAMETER;
  if not FSessionOpened then Exit;

  if FindISOID(sISO, data) then
  begin
    // A 'camera' helyett az osztályod belsõ 'FCameraRef' változóját használjuk
    Result := EdsSetPropertyData(FCameraRef, kEdsPropID_ISOSpeed, 0, sizeof(data), @data);
    if Result = EDS_ERR_OK then
    begin
      FIso := data;  // Frissítjük a belsõ változót
      EdsGetEvent(); // Azonnal feldolgoztatjuk az SDK-val a változást
    end;
  end;
end;

function TCanon.SetQuality(sQ: string): EdsError;
var
  data: EdsUInt32;
begin
  Result := EDS_ERR_INVALID_PARAMETER;
  if not FSessionOpened then Exit;

  if FindQualityID(sQ, data) then
  begin
    // A 'camera' helyett az osztályod belsõ 'FCameraRef' változóját használjuk
    Result := EdsSetPropertyData(FCameraRef, kEdsPropID_ImageQuality, 0, sizeof(data), @data);
    if Result = EDS_ERR_OK then
    begin
      FJpegQuality := data;  // Frissítjük a belsõ változót
      EdsGetEvent(); // Azonnal feldolgoztatjuk az SDK-val a változást
    end;
  end;
end;

procedure TCanon.SetSaveToFile(const Value: Boolean);
begin
  FSaveToFile := Value;
end;

function TCanon.SetTime(sTime: TDateTime): EdsError;
begin

end;

function TCanon.SetTv(sTv: string): EdsError;
var
  data: EdsUInt32;
begin
  Result := EDS_ERR_INVALID_PARAMETER;
  if not FSessionOpened then Exit;

  if FindTvID(sTv, data) then
  begin
    // A 'camera' helyett az osztályod belsõ 'FCameraRef' változóját használjuk
    Result := EdsSetPropertyData(FCameraRef, kEdsPropID_Tv, 0, sizeof(data), @data);
    if Result = EDS_ERR_OK then
    begin
      FTv := data;  // Frissítjük a belsõ változót
      EdsGetEvent(); // Azonnal feldolgoztatjuk az SDK-val a változást
    end;
  end;
end;

function TCanon.SetWB(sWB: string): EdsError;
var
  data: EdsUInt32;
begin
  Result := EDS_ERR_INVALID_PARAMETER;
  if not FSessionOpened then Exit;

  if FindWBID(sWB, data) then
  begin
    // A 'camera' helyett az osztályod belsõ 'FCameraRef' változóját használjuk
    Result := EdsSetPropertyData(FCameraRef, kEdsPropID_WhiteBalance, 0, sizeof(data), @data);
    if Result = EDS_ERR_OK then
    begin
      FWB := data;  // Frissítjük a belsõ változót
      EdsGetEvent(); // Azonnal feldolgoztatjuk az SDK-val a változást
    end;
  end;
end;

procedure TCanon.DoError(const AMsg: string; AErrCode: EdsError);
begin
  if Assigned(FOnError) then FOnError(Self, AMsg + ' (Kód: $' + IntToHex(AErrCode, 8) + ')');
end;

procedure TCanon.Connect;
var err: EdsError;
    saveToTarget: integer;
    capacity: EdsCapacity;
begin
  if FSessionOpened then Exit;

  err := EdsGetCameraList(@FCameraListRef);
  if err = EDS_ERR_OK then err := EdsGetChildCount(FCameraListRef, @cameraCount);
  if (err <> EDS_ERR_OK) or (cameraCount = 0) then begin
    DoError('Nem található csatlakoztatott Canon kamera!', err); Disconnect; Exit;
  end;

  err := EdsGetChildAtIndex(FCameraListRef, 0, @FCameraRef);
  if err <> EDS_ERR_OK then begin Disconnect; Exit; end;

  err := EdsOpenSession(FCameraRef);
  if err <> EDS_ERR_OK then begin DoError('Session megnyitása sikertelen!', err); Disconnect; Exit; end;
  FSessionOpened := True;

  // 1. HOST-RA IRÁNYÍTÁS: Megmondjuk a kamerának, hogy a képeket a PC-nek küldje
  // (Ha azt szeretnéd, hogy a kamera kártyáján is megmaradjon, használd a kEdsSaveTo_Both értéket)
  saveToTarget := kEdsSaveTo_Host;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_SaveTo, 0, SizeOf(EdsUInt32), @saveToTarget);
  if err <> EDS_ERR_OK then
  begin
    DoError('Mentési célpont (Host) beállítása sikertelen!', err);
  end;

  // 2. KAPACITÁS BEÁLLÍTÁSA: Közöljük a kamerával, hogy van elég hely a PC-n a fogadáshoz
  // Ha ez elmarad, a gép azt hiszi, megtelt a tárhely, és lezárja az átvitelt
  FillChar(capacity, SizeOf(EdsCapacity), 0);
  capacity.numberOfFreeClusters := $7FFFFFFF; // Nagyon sok szabad hely szimulálása
  capacity.bytesPerSector       := 512;
  capacity.reset                := True;

  err := EdsSetCapacity(FCameraRef, capacity);
  if err <> EDS_ERR_OK then
  begin
    DoError('PC tárhely kapacitás regisztrációja sikertelen!', err);
  end;

  // 3. Globális aktív komponens mutató beállítása a callback függvényeknek
//  GActiveCanon := Self;

  // 4. Eseménykezelõk regisztrációja NIL paraméterrel
  EdsSetObjectEventHandler(FCameraRef, kEdsObjectEvent_All, @GlobalObjectEventHandler, Self);
  EdsSetPropertyEventHandler(FCameraRef, kEdsPropertyEvent_All, @GlobalPropertyEventHandler, Self);
  EdsSetCameraStateEventHandler(FCameraRef, kEdsStateEvent_All, @GlobalStateEventHandler, Self);

  // 5. Inicializációs üzenetek feldolgozása a mûködõ mintád alapján
  EdsGetEvent();
  Sleep(200);
  EdsGetEvent();

  if Assigned(FOnConnect) then
    FOnConnect(Self);
end;

procedure TCanon.Disconnect;
begin
  if FBulbTimer.Enabled then EndBulbCapture;
  if FLiveViewActive then StopLiveView;
  if FSessionOpened then begin EdsCloseSession(FCameraRef); FSessionOpened := False; end;
  if FCameraRef <> nil then begin EdsRelease(FCameraRef); FCameraRef := nil; end;
  if FCameraListRef <> nil then begin EdsRelease(FCameraListRef); FCameraListRef := nil; end;

  if Assigned(FOnDisconnect) then FOnDisconnect(Self);
end;

procedure TCanon.BulbCapture(ADurationMs: Integer);
var
  err: EdsError;
begin
  if not FSessionOpened or FBulbTimer.Enabled then Exit;
  if ADurationMs <= 0 then Exit;

  // 1. Lépés: UI Lezárása (Az EDSDK megköveteli a BULB módhoz)
  err := EdsSendStatusCommand(FCameraRef, kEdsCameraState_UILock, 0);
  if err <> EDS_ERR_OK then begin
    DoError('Kamera UI lezárása sikertelen, a BULB nem indítható.', err);
    Exit;
  end;

  // 2. Lépés: Redõny teljes lenyomása (Expozíció indítása)
  err := EdsSendCommand(FCameraRef, kEdsCameraCommand_PressShutterButton, kEdsCameraCommand_ShutterButton_Completely);
  if err <> EDS_ERR_OK then begin
    DoError('BULB Exponálás parancs elutasítva!', err);
    EdsSendStatusCommand(FCameraRef, kEdsCameraState_UIUnlock, 0); // Hiba esetén feloldjuk
    Exit;
  end;

  // 3. Lépés: Nem-blokkoló idõzítõ indítása
  FBulbRemainingMs := ADurationMs;
  FBulbTimer.Enabled := True;

  EdsGetEvent();
end;

procedure TCanon.OnBulbTimerTick(Sender: TObject);
begin
  Dec(FBulbRemainingMs, FBulbTimer.Interval);

  // Amikor az idõ lejárt, leállítjuk az expozíciót
  if FBulbRemainingMs <= 0 then
    EndBulbCapture
  else
    EdsGetEvent(); // Folyamatosan hajtjuk végre az SDK eseményeket
end;

procedure TCanon.EndBulbCapture;
begin
  if not FBulbTimer.Enabled then Exit;
  FBulbTimer.Enabled := False;

  // 1. Lépés: Shutter gomb felengedése (Zár zárása)
  EdsSendCommand(FCameraRef, kEdsCameraCommand_PressShutterButton, kEdsCameraCommand_ShutterButton_OFF);

  // 2. Lépés: UI Feloldása
  EdsSendStatusCommand(FCameraRef, kEdsCameraState_UIUnlock, 0);

  EdsGetEvent();
end;

function TCanon.FindAeModeID(sAeMode: string; var data: EdsUInt32): boolean;
begin
  Result := FindPropID(IsoProp, sAeMode, data );
end;

function TCanon.findAeModePropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(AEModeProp, value, Result);
end;

function TCanon.FindAeModeStr(ID: EdsUInt32; var sAEMode: string): boolean;
begin
  Result := FindPropStr(AEModeProp, ID, sAEMode );
end;

function TCanon.findAvPropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(AvProp, value, Result);
end;

function TCanon.FindISOID(sISO: string; var data: EdsUInt32): boolean;
begin
  Result := FindPropID(IsoProp, sISO, data );
end;

function TCanon.findIsoPropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(IsoProp, value, Result);
end;

function TCanon.FindISOStr(ID: EdsUInt32; var sISO: string): boolean;
begin
  Result := FindPropStr(IsoProp, ID, sISO );
end;

function TCanon.FindPropID(const VArray: array of TPropRec; s: string;
         var data: EdsUInt32): boolean;
var i: integer;
begin
  Result := False;
  data := 0;
  for i:=0 to High(VArray) do
      if VArray[i].PropStr = s then begin
         data := VArray[i].PropID;
         Result := True;
         Break;
      end;
end;

function TCanon.FindPropIndex(const VArray: array of TPropRec; Value: integer;
         var data: integer): boolean;
var i: integer;
begin
  Result := False;
  data := -1;
  for i:=0 to High(VArray) do
      if VArray[i].PropID = Value then begin
         data := i;
         Result := True;
         Break;
      end;
end;

function TCanon.FindPropRec(const VArray: array of TPropRec; V: Variant;
         var data: TPropRec): boolean;
var i: integer;
begin
  Result := False;
  for i:=0 to High(VArray) do
  begin
      if VarType(V)=varInteger then
        if VArray[i].PropID = V then begin
           data := VArray[i];
           Result := True;
           Break;
        end;
      if VarType(V)=varString then
        if VArray[i].PropStr = V then begin
           data := VArray[i];
           Result := True;
           Break;
        end;
  End;
end;

function TCanon.FindPropStr(const VArray: array of TPropRec; ID: EdsUInt32;
  var data: string): boolean;
var
  i: integer;
begin
  Result := False;
  data := '';
  for i := 0 to High(VArray) do
  begin
    if VArray[i].PropID = ID then
    begin
       data := VArray[i].PropStr;
       Result := True;
       Break;
    end;
  end;
end;

function TCanon.FindQualityStr(ID: EdsUInt32; var sQ: string): boolean;
begin
  Result := FindPropStr(QualityProp, ID, sQ );
end;

function TCanon.FindQualityID(sQ: string; var data: EdsUInt32): boolean;
begin
  Result := FindPropID(QualityProp, sQ, data );
end;

function TCanon.findQualityPropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(QualityProp, value, Result);
end;

function TCanon.FindTvID(sTv: string; var data: EdsUInt32): boolean;
begin
  Result := FindPropID(TVProp, sTV, data );
end;

function TCanon.findTvPropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(TvProp, value, Result);
end;

function TCanon.FindTvStr(ID: EdsUInt32; var sTv: string): boolean;
begin
  Result := FindPropStr(TVProp, ID, sTV );
end;

function TCanon.FindWBID(sWB: string; var data: EdsUInt32): boolean;
begin
  Result := FindPropID(WBProp, sWB, data );
end;

function TCanon.findWBPropIndex(value: EdsUInt32): integer;
begin
  FindPropIndex(WBProp, value, Result);
end;

function TCanon.FindWBStr(ID: EdsUInt32; var sWB: string): boolean;
begin
  Result := FindPropStr(WBProp, ID, sWB );
end;

function TCanon.GetAEMode: string;
Var
  LValue: EdsUInt32;
begin
  Result := ''; // Alapértelmezett biztonsági érték
  LValue := getProperty(kEdsPropID_AEMode);
  if (LValue>-1) then begin
     FAEMode := LValue;
     FindISOStr(LValue,Result);
  end;
end;

function TCanon.GetAEModeList: TStrings;
begin
   Result := GetPropertyList(AEModeProp,kEdsPropID_AEMode);
end;


function TCanon.GetAvList: TStrings;
begin
   Result := GetPropertyList(AvProp,kEdsPropID_AV);
end;

function TCanon.GetCamaraPropertyDesc(id: EdsPropertyID): EdsPropertyDesc;
var desc : EdsPropertyDesc;
begin
  getPropertyDesc(id);
  desc.form := 0;
  desc.access := 0;
  desc.numElements := 0;

  Case id of
    kEdsPropID_AEMode      : desc := FAeModeDesc;
    kEdsPropID_Tv          : desc := FTvDesc;
    kEdsPropID_Av          : desc := FAvDesc;
    kEdsPropID_ISOSpeed    : desc := FIsoDesc;
    kEdsPropID_BatteryLevel: desc := FBatteryLevelDesc;
    kEdsPropID_ImageQuality: desc := FJpegQualityDesc;
    kEdsPropID_WhiteBalance: desc := FWBDesc;
  end;
  Result := desc;
end;

procedure TCanon.StartLiveView;
Var err: EdsError; evfMode, deviceValue: EdsUInt32;
begin
  if not FSessionOpened or FLiveViewActive then Exit;
  evfMode := 1;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, 4, @evfMode);
  if err <> EDS_ERR_OK then begin DoError('EVF Mód nem aktiválható!', err); Exit; end;
  EdsGetEvent();
  deviceValue := kEdsOutputDevice_PC;
  err := EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, 4, @deviceValue);
  if err = EDS_ERR_OK then begin FLiveViewActive := True; FEvfTimer.Enabled := True; end
  else DoError('LiveView kimenet átváltása sikertelen (BUSY?).', err);
end;

procedure TCanon.StopLiveView;
var deviceValue, evfMode: EdsUInt32;
const kEdsPropertyID_Evf_Mode = Cardinal($00000501); kEdsPropertyID_Evf_OutputDevice = Cardinal($00000500);
begin
  if not FLiveViewActive then Exit;
  FEvfTimer.Enabled := False; FLiveViewActive := False; EdsGetEvent(); Sleep(50);
  deviceValue := kEdsOutputDevice_TFT; EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_OutputDevice, 0, 4, @deviceValue);
  EdsGetEvent(); Sleep(50); evfMode := 0; EdsSetPropertyData(FCameraRef, kEdsPropertyID_Evf_Mode, 0, 4, @evfMode);
  EdsGetEvent();
end;

procedure TCanon.Capture;
var err: EdsError;
begin
  if not FSessionOpened then Exit;
  err := EdsSendCommand(FCameraRef, kEdsCameraCommand_TakePicture, 0);
  if err <> EDS_ERR_OK then DoError('Exponálás parancs elutasítva!', err);
  EdsGetEvent();
end;

procedure TCanon.OnTimerTick(Sender: TObject);
var err: EdsError; evfImageRef: EdsEvfImageRef; streamRef: EdsStreamRef; jpgPointer: Pointer; jpgSize: EdsUInt64; memStream: TMemoryStream; jpg: TJPEGImage; bmp: TBitmap;
begin
  if not FSessionOpened or not FLiveViewActive then Exit;
  evfImageRef := nil; streamRef := nil;
  err := EdsCreateMemoryStream(0, @streamRef); if err <> EDS_ERR_OK then Exit;
  try
    err := EdsCreateEvfImageRef(streamRef, @evfImageRef); if err <> EDS_ERR_OK then Exit;
    err := EdsDownloadEvfImage(FCameraRef, evfImageRef);
    if err = EDS_ERR_OK then begin
      err := EdsGetPointer(streamRef, @jpgPointer); if err = EDS_ERR_OK then err := EdsGetLength(streamRef, @jpgSize);
      if (err = EDS_ERR_OK) and (jpgSize > 0) then begin
        memStream := TMemoryStream.Create;
        try
          memStream.WriteBuffer(jpgPointer^, jpgSize); memStream.Position := 0;
          jpg := TJPEGImage.Create; bmp := TBitmap.Create;
          try jpg.LoadFromStream(memStream); bmp.Assign(jpg); if Assigned(FOnLiveViewFrame) then FOnLiveViewFrame(Self, bmp);
          finally jpg.Free; bmp.Free; end;
        finally memStream.Free; end;
      end;
    end; EdsGetEvent();
  finally
    if evfImageRef <> nil then EdsRelease(evfImageRef); if streamRef <> nil then EdsRelease(streamRef);
  end;
end;


//function TCanon.HandleObjectEvent(inEvent: EdsObjectEvent; inRef: EdsBaseRef ): EdsError;
function TCanon.getImageData(inEvent: EdsObjectEvent; inRef: EdsBaseRef ): EdsError;
var
  err: EdsError;
  dirItemInfo: EdsDirectoryItemInfo;
  streamRef: EdsStreamRef;
  savedPath: Ansistring;
  ffName,ext: Ansistring;

  // Változók a letöltési ághoz
  RAWPointer: Pointer;
  RAWSize: EdsUInt64;
  jpgPointer: Pointer;
  jpgSize: EdsUInt64;
  memStream: TMemoryStream;
  outBMP: TBitmap;

function JPGFromRAW(RAWFileName: string; memStream: TMemoryStream ): TBitmap;
var
  delphiFileStream: TMemoryStream; // Lokálisan deklarálva, így nem maradhat ki!
  delphiMemStream: TMemoryStream;
  jpg: TJPEGImage;
  pSrc, pEnd: PByte;
  FoundJPG: Boolean;
begin
  if UpperCase(ExtractFileExt(RAWFileName)) = '.CR2' then
  begin
  Try
    delphiFileStream := TMemoryStream.Create;
    try
      Result := TBitmap.Create;
      if memStream.Size>0 then
         delphiFileStream := memStream
      else
         if RAWFileName<>'' then
            delphiFileStream.LoadFromFile(RAWFileName);

      if delphiFileStream.Size > 20000 then
      begin
        // Beállítjuk a pointereket a memóriában történõ kereséshez
        pSrc := PByte(delphiFileStream.Memory);
        Inc(pSrc, 20000); // Átugorjuk az elsõ 20 KB metaadatot

        pEnd := PByte(delphiFileStream.Memory);
        Inc(pEnd, delphiFileStream.Size - 1);

        FoundJPG := False;

        // Megkeressük a JPEG kezdetét ($FF $D8) szélsebesen a RAM-ban
        while pSrc < pEnd do
        begin
          if (pSrc^ = $FF) and ((pSrc + 1)^ = $D8) then
          begin
            FoundJPG := True;
            Break;
          end;
          Inc(pSrc); // 1 bájtot lépünk elõre (Mivel pointer, így a (pSrc+1)^ a következõ bájt, nincs elcsúszás!)
        end;

        if FoundJPG then
        begin
          delphiMemStream := TMemoryStream.Create;
          jpg := TJPEGImage.Create;
          try
            // Kimásoljuk a talált JPEG kezdetétõl a fájl legvégéig tartó adatot
            delphiMemStream.WriteBuffer(pSrc^, pEnd - pSrc + 1);
            delphiMemStream.Position := 0;

            jpg.LoadFromStream(delphiMemStream);
            Result.Assign(jpg);

          finally
            jpg.Free;
            delphiMemStream.Free;
          end;
        end;

      end;
    finally
    end;
  except
    Result.Free;
    raise;
  end;
  end;
end;

function JPEGStreamToBitmap(AJPEGStream: TMemoryStream): TBitmap;
var
  JPEGImage: TJPEGImage;
begin
  Result := TBitmap.Create;
  try
    // 1. Pozícionáljuk a stream elejére a biztonság kedvéért
    AJPEGStream.Position := 0;

    // 2. Létrehozzuk a JPEG kezelõt és betöltjük a nyers streambõl
    JPEGImage := TJPEGImage.Create;
    try
      JPEGImage.LoadFromStream(AJPEGStream);

      // 3. Átmásoljuk (Assign) a JPEG-et a visszatérési Bitmapbe
      // Ez a háttérben automatikusan elvégzi a kitömörítést és pixelkonverziót
      Result.Assign(JPEGImage);

      // 4. Kikényszerítjük a 24 bites RGB formátumot a stakelõ algoritmus számára
      Result.PixelFormat := pf24bit;

    finally
      JPEGImage.Free;
    end;

  except
    // Ha a stream sérült vagy nem érvényes JPEG, felszabadítjuk a memóriát
    Result.Free;
    raise;
  end;
end;


begin
    Result := EDS_ERR_OK;

    // Lekérjük a kép alapadatait (fájlnév, méret) az SDK-ból
    err := EdsGetDirectoryItemInfo(inRef, @dirItemInfo);
    if err <> EDS_ERR_OK then Exit;

    streamRef := nil;
    // Meghatározzuk a mentési útvonalat a futtatható állomány mappájába
    ext := ExtractFileExt(dirItemInfo.szFileName); // pl. '.JPG' vagy '.CR2'
    savedPath := IncludeTrailingPathDelimiter(FFilePath) + FFileName + ext;
    savedPath := FileNameGenerate(savedPath);

    ext := UpperCase(ext);

    // A: LOGIKA A CR2 / CR3 (RAW) FÁJLOKHOZ
    if (ext = '.CR2') or (ext = '.CR3') then
    begin
      memStream := TMemoryStream.Create;
      // SDK Fájl-stream létrehozása közvetlenül a lemezre (HDD/SSD) a RAM kímélése érdekében
      if FSaveToFile then
         err := EdsCreateFileStream(PAnsiChar(AnsiString(savedPath)),
                                 kEdsFileCreateDisposition_CreateAlways,
                                 kEdsAccess_Write, @streamRef)
      else
         err := EdsCreateMemoryStream(0, @streamRef);

      if err = EDS_ERR_OK then
      begin
        try
          // Közvetlen letöltés a fájlba
          err := EdsDownload(inRef, dirItemInfo.size, streamRef);
          if err = EDS_ERR_OK then
          begin
            // Jelzés a kamerának, hogy az átvitel kész, a puffer üríthetõ
            EdsDownloadComplete(inRef);
          end;

         if not FSaveToFile then
         begin
            // Pointerek és méret kinyerése az SDK pufferbõl
            err := EdsGetPointer(streamRef, @RAWPointer);
            if err = EDS_ERR_OK then
              err := EdsGetLength(streamRef, @RAWSize);

            if (err = EDS_ERR_OK) and (RAWSize > 0) then
            begin
              // Bemásoljuk a Delphi TMemoryStream-be a nyers JPEG adatokat
              memStream.WriteBuffer(RAWPointer^, RAWSize);
              memStream.Position := 0;
            end;
         end;

          // KIVÁLTJUK A DELPHI ESEMÉNYT: A stream NIL, de a fizikai elérési út átadásra kerül!
          if Assigned(FOnPhotoCaptured) then
          begin
             outBMP := JPGFromRAW(savedPath,memStream);
             FOnPhotoCaptured(Self, outBMP, nil, savedPath);
          end;

        finally
          if streamRef <> nil then EdsRelease(streamRef);
          // Kritikus: Az inRef-et az SDK-nak fel kell szabadítania, miután végeztünk
          EdsRelease(inRef);
          memStream.Free;
        end;
    end;
    end

    // B: LOGIKA A TRADICIONÁLIS JPEG FÁJLOKHOZ
    else
    begin
      memStream := TMemoryStream.Create;
      try
        // SDK Memória-stream létrehozása a gyors RAM-alapú feldolgozáshoz
        err := EdsCreateMemoryStream(0, @streamRef);
        if err = EDS_ERR_OK then
        begin
          err := EdsDownload(inRef, dirItemInfo.size, streamRef);
          if err = EDS_ERR_OK then
          begin
            EdsDownloadComplete(inRef);

            // Pointerek és méret kinyerése az SDK pufferbõl
            err := EdsGetPointer(streamRef, @jpgPointer);
            if err = EDS_ERR_OK then
              err := EdsGetLength(streamRef, @jpgSize);

            if (err = EDS_ERR_OK) and (jpgSize > 0) then
            begin
              // Bemásoljuk a Delphi TMemoryStream-be a nyers JPEG adatokat
              memStream.WriteBuffer(jpgPointer^, jpgSize);
              memStream.Position := 0;

              // Ha a komponens beállítása szerint fájlba is menteni kell a JPEG-et
              if FSaveToFile then
              begin
                memStream.SaveToFile(savedPath);
                memStream.Position := 0; // Visszaállítjuk a pozíciót az eseménynek
              end;


              // KIVÁLTJUK A DELPHI ESEMÉNYT: Átadjuk a memóriastreamet és az utat is
              if Assigned(FOnPhotoCaptured) then
              begin
                 outBMP := JPEGStreamToBitmap(memStream);
                 FOnPhotoCaptured(Self, outBMP, memStream, savedPath);
              end;
            end;
          end;
        end;
      finally
        if streamRef <> nil then EdsRelease(streamRef);
        memStream.Free;
        EdsRelease(inRef);
      end;
    end;
end;

function TCanon.getProperty(id: EdsPropertyID): Variant;
var
  err: EdsError;
  dataSize : EdsUInt32;
  dataType : EDSDATATYPE;
  data : EdsUInt32;
  str : array [0..EDS_MAX_NAME-1] of EdsChar;
  LValue: EdsUInt32;
begin
  Result := 0;
  if not FSessionOpened then exit;
  err := EdsGetPropertySize( FcameraRef, id, 0, @dataType, @dataSize );

  // Lekérjük a nyers hexadecimális értéket az SDK-ból
  if dataType = EdsUInt32(kEdsDataType_String) then begin
     err := EdsGetPropertyData( FcameraRef, id, 0, dataSize, @str );
     Result := StrPas(str);
  end
  else begin
     err := EdsGetPropertyData( FcameraRef, id, 0, dataSize, @data );
     Result := data;
  end;

end;

function TCanon.setProperty(id: EdsPropertyID; value: Variant): EdsError;
var
  dataSize: EdsUInt32;
  intData: EdsUInt32;
  ansiStr: AnsiString; // Fixen Ansi/UTF8 string a C-kompatibilitáshoz
begin
  Result := EDS_ERR_INVALID_PARAMETER;
  if not FSessionOpened then exit;

  // 1. Ellenõrizzük, hogy kaptunk-e érvényes adatot
  if VarIsNull(value) or VarIsEmpty(value) then exit;

  // 2. Típus szerinti elágazás a Variant belsõ típusa alapján
  case VarType(value) of

    // HA SZÖVEG (Bármilyen Delphi string típus)
    varOleStr, varString, varUString:
    begin
      // Átalakítjuk a Variant-ot Ansi/UTF8 szöveggé (az EDSDK ezt várja)
      ansiStr := AnsiString(VarToStr(value));

      // A méret a karakterek száma + 1 a lezáró #0 (null) karakter miatt
      dataSize := Length(ansiStr) + 1;

      // Átadjuk a szöveg elsõ karakterének a mutatóját PAnsiChar-ként
      Result := EdsSetPropertyData(FcameraRef, id, 0, dataSize, PAnsiChar(ansiStr));
    end;

    // HA EGÉSZ SZÁM (Bármilyen méretû integer)
    varInteger, varLongWord, varShortInt, varByte, varWord, varSmallInt:
    begin
      intData := value; // Automatikus konverzió EdsUInt32-re
      dataSize := SizeOf(EdsUInt32);

      Result := EdsSetPropertyData(FcameraRef, id, 0, dataSize, @intData);
    end;

    // HA LOGIKAI ÉRTÉK (Néhány Canon tulajdonság boolean-t vár 0 vagy 1 értékként)
    varBoolean:
    begin
      if value = True then intData := 1 else intData := 0;
      dataSize := SizeOf(EdsUInt32);

      Result := EdsSetPropertyData(FcameraRef, id, 0, dataSize, @intData);
    end;

  else
    // Ha olyan típust kapott, amit nem kezelünk (pl. tömb vagy objektum)
    Result := EDS_ERR_NOT_SUPPORTED;
  end;
end;

function TCanon.GetISO: string;
Var
  LValue: EdsUInt32;
begin
  Result := ''; // Alapértelmezett biztonsági érték
  LValue := getProperty(kEdsPropID_ISOSpeed);
  if (LValue>-1) then begin
     FIso := LValue;
     FindISOStr(LValue,Result);
  end;
end;

function TCanon.GetISOList: TStrings;
(*
var desc : EdsPropertyDesc;
    i, j : integer;
    current, val  : EdsUInt32;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( kEdsPropID_ISOSpeed );
     Result.Clear;
        { refill available ISO value }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          j := findIsoPropIndex( val );
          Result.AddObject( IsoProp[j].PropStr, @IsoProp[j] );
        end;
end;
*)
begin
   Result := GetPropertyList(IsoProp,kEdsPropID_ISOSpeed);
end;

function TCanon.GetOwnerName: string;
begin
  Result := GetProperty(kEdsPropID_OwnerName);
end;

(*
function TCanon.getProperty(id: EdsPropertyID): EdsUInt32;
var err : EdsError;
  dataSize : EdsUInt32;
  dataType : EDSDATATYPE;
  data : EdsUInt32;
  str : array [0..EDS_MAX_NAME-1] of EdsChar;
  P : Pointer;
begin
  { if property id is invalid value (kEdsPropID_Unknown),
    EDSDK cannot identify the changed property.
    So, we must retrieve the required property again.  }
  if id = kEdsPropID_Unknown then begin
    err := getProperty( kEdsPropID_AEMode );
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_Tv);
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_Av);
    if err = EDS_ERR_OK then err := getProperty(kEdsPropID_ISOSpeed );
    Result := err;
    Exit;
  end;

  err := EdsGetPropertySize( FcameraRef, id, 0, @dataType, @dataSize );
  if err <> EDS_ERR_OK then begin
    Result := err;
    Exit;
  end;

  if (dataType in [3..11])
  then begin
    P := @data;
    err := EdsGetPropertyData( FcameraRef, id, 0, dataSize, Pointer(P^) );

    { set property data into TCamera }
    if err = EDS_ERR_OK then begin
      setPropertyUInt32( id, data );
      CameraInt := data;
    end;
  end;

  if dataType = EdsUInt32(EdsDataTypek_String) then begin
    P := @str;
    err := EdsGetPropertyData( camera, id, 0, dataSize, Pointer(P^) );

    { set property string into TCamera }
    if err = EDS_ERR_OK then begin
      setPropertyString( id, str );
      CameraString := StrPas(str);
    end;

  end;
  Result := err;
end;
*)

function TCanon.getPropertyDesc(id: EdsPropertyID): EdsError;
var err : EdsError;
    desc : EdsPropertyDesc;
begin
  { if property id is invalid value (kEdsPropID_Unknown),
    EDSDK cannot identify the changed property.
    So, we must retrieve the required property again.  }
  if id = kEdsPropID_Unknown then begin
    err := getPropertyDesc( kEdsPropID_AEMode );
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_Tv);
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_Av);
    if err = EDS_ERR_OK then err := getPropertyDesc(kEdsPropID_ISOSpeed );
    Result := err;
    Exit;
  end;

  err := EdsGetPropertyDesc( FCameraRef, id, @desc );
  if err = EDS_ERR_OK then
    { set available list into TCamera object }
    SetCameraPropertyDesc( id, desc );

  Result := err;
end;

{ Call: GetPropertyList(IsoProp,kEdsPropID_ISOSpeed) }
function TCanon.GetPropertyList(const VArray: array of TPropRec;
                                PropertyID: EdsUInt32): TStrings;
var desc : EdsPropertyDesc;
    i, j : integer;
    val  : EdsUInt32;
    found: boolean;
begin
  Result := TStringList.Create;
  desc := GetCamaraPropertyDesc( PropertyID );
     Result.Clear;
        { refill available values }
        for i := 0  to desc.numElements -1 do begin
          val := desc.propDesc[i];
          found := False;
          for j := Low(VArray) to High(VArray) do begin
              if VArray[j].PropID = val then
              begin
                 found := True;
                 Result.AddObject( VArray[j].PropStr, @VArray[j] );
                 Break;
              end;
          end;
        end;
end;

function TCanon.GetQuality: string;
Var
  LValue: EdsUInt32;
begin
  Result := ''; // Alapértelmezett biztonsági érték
  LValue := getProperty(kEdsPropID_ImageQuality);
  if (LValue>-1) then begin
     FJPegQuality := LValue;
     FindQualityStr(LValue,Result);
  end;
end;

function TCanon.GetQualityList: TStrings;
begin
   Result := GetPropertyList(QualityProp,kEdsPropID_ImageQuality);
end;

function TCanon.GetTime: TDateTime;
begin

end;

function TCanon.GetTv: string;
Var
  LValue: EdsUInt32;
begin
  Result := ''; // Alapértelmezett biztonsági érték
  LValue := getProperty(kEdsPropID_Tv);
  if (LValue>0) then begin
     FTv := LValue;
     FindTvStr(LValue,Result);
  end;
end;
(*
var
  err: EdsError;
  LIsoValue: EdsUInt32;
begin
  Result := 'Auto'; // Alapértelmezett érték, ha nem sikerül a lekérés
  if not FSessionOpened then Exit;

  // Lekérjük a nyers hexadecimális értéket az SDK-ból
  err := EdsGetPropertyData(FCameraRef, kEdsPropID_ISOSpeed, 0, SizeOf(EdsUInt32), @LIsoValue);

  if err = EDS_ERR_OK then
  begin
    FIso := LIsoValue; // Elmentjük a belsõ változóba
    // Átváltjuk a hexadecimális ID-t olvasható szöveggé a meglévõ függvényeddel
    if not FindISOStr(LIsoValue, Result) then
      Result := 'Unknown';
  end
  else
    DoError('ISO érték lekérése sikertelen!', err);
end;
*)

function TCanon.GetTvList: TStrings;
begin
   Result := GetPropertyList(TvProp,kEdsPropID_TV);
end;

function TCanon.GetWB: string;
Var
  LValue: EdsUInt32;
begin
  Result := ''; // Alapértelmezett biztonsági érték
  LValue := getProperty(kEdsPropID_WhiteBalance);
  if (LValue>-1) then begin
     FWB := LValue;
     FindWBStr(LValue,Result);
  end;
end;

function TCanon.GetWBList: TStrings;
begin
   Result := GetPropertyList(WBProp,kEdsPropID_WhiteBalance);
end;

function TCanon.HandleStateEvent(inEvent: EdsStateEvent; inParam: EdsUInt32): EdsError;
begin
  Result := EDS_ERR_OK;

  // Intelligens belsõ állapot-figyelés
  case inEvent of
    kEdsStateEvent_Shutdown:
    begin
      // Ha a kamera kikapcsol vagy lemerül, belsõleg azonnal lezárjuk a kapcsolatot
      Disconnect;
    end;

    kEdsStateEvent_JobStatusChanged:
    begin
      // Jelzi, ha a kamera belsõ puffere (pl. sorozatlövés vagy képfeldolgozás) foglalt vagy felszabadult
    end;

    kEdsStateEvent_BatteryLevelChanged:
    begin
      // Ide jöhet egy belsõ védelem: ha inParam eléri a kritikus szintet, letiltható a LiveView/BULB
      if inParam = 0 then
        DoError('Figyelem: A kamera akkumulátora kritikusan alacsony!', EDS_ERR_OK);
    end;
  end;

  // Továbbküldés a külsõ ablak felé
  if Assigned(FOnStateChange) then
    FOnStateChange(Self, inEvent, inParam);
end;

function TCanon.HandleProgressEvent(inPercent: EdsUInt32; inContext: PEdsVoid; var outCancel: EdsBool): EdsError;
var
  LBreak: Boolean;
begin
  Result := EDS_ERR_OK;
  LBreak := False;

  // Belsõ biztonsági ellenõrzés: ha folyamat közben megszakadt a kapcsolat a váz és a PC között
  if not FSessionOpened then
    LBreak := True;

  // Továbbítjuk a százalékos értéket a felület felé (pl. egy Progress Barnak)
  if Assigned(FOnProgress) then
  begin
    FOnProgress(Self, inPercent, LBreak);
    outCancel := LBreak; // Ha a felhasználó a UI-on a Mégse gombra kattintott, jelezzük az SDK-nak
  end
  else
    outCancel := LBreak;
end;

function TCanon.HandlePropertyEvent(inEvent: EdsPropertyEvent;
  inPropertyID: EdsPropertyID; inParam: EdsUInt32): EdsError;
begin

end;

procedure TCanon.DoPropertyChange(APropertyID: EdsPropertyID; AParam: EdsUInt32);
begin
  // Mivel ez már osztálymetódus, a TThread.Synchronize tökéletesen mûködik!
  TThread.Synchronize(nil, procedure
  begin
    if Assigned(FOnPropertyChange) then
      FOnPropertyChange(Self, APropertyID, AParam);
  end);
end;

(*
  FileName:
    Prefix : Canon
    Blank  : _

    Examples:
    Canon_001.JPG
    CANON_KEI=2022.02.24.JPG
    CANON_2022-02-24.JPG
    CANON_2022-02-24_RA+23-12-34.5_DE-12-35-54.6.JPG
    CANON_2022-02-24_UT21-45.JPG
    CANON_JD123213.231.JPG

  fn : Teljes filenév : path + filename + ext
*)

function  TCanon.FileNameGenerate(fn: String): String;
var f,fPath,fFname,ext: string;
    StartCounter: integer;

    { Zeronum	= Egy num. értéket bevezetõ '0'-kal stringgé alakit }
    Function ZeroNum( sz,hosz : Word ):String;
    Var	s	: String;
    begin
	       Str( sz,s );
	       ZeroNum := StringOfChar( '0',hosz-Length(s)) + s;
    end;

    function GetUTString: string;
    var
      VilagIdo: TDateTime;
    begin
      // A helyi idõ átalakítása UTC-re
      VilagIdo := TTimeZone.Local.ToUniversalTime(Now);
      // Vagy egyedi formátumban:
      Result := FormatDateTime('YYYYMMDD-HHNNSS', VilagIdo);
    end;

    function NowUTCString: String;
    Var UTC: TSystemTime;
        DT: TDateTime;
    begin
         GetSystemTime(UTC);
         DT := SystemTimeToDateTime(UTC);
         Result := FormatDateTime('YYYYMMDD-HHNNSS', DT);
    end;



begin
  fPath := ExtractFilePath(fn);
  if fPath='' then fPath := FilePath;
  ext := ExtractFileExt(fn);
  fFname := ExtractFileName(fn);
  fFname := Copy(fFname,1,AnsiPos(ext,fFname)-1);

  case FFileNameType of
  fntCounter:
  begin
    f := '';
    StartCounter := 1;
    repeat
       f:=FPath+fFname+'_'+ZeroNum(StartCounter,3)+ext;
       if NOT FileExists(f) then
       begin
            f:=FPath+fFname+'_'+ZeroNum(StartCounter,3);
            Break;
       end;
       Inc(StartCounter);
    until false;
    Result := f+ext;
    exit;
  end;
  fntDateTime:
  begin
       Result := FPath+fFname+'_DT='+FormatDateTime('yyyymmdd-hhnnss',now)+ext;
  end;
  fntUT:
  begin
       Result := FPath+fFname+'_UT='+NowUTCString+ext;
//       Result := GetUTString;
  end;
  fntJD:
  begin
      Result := FPath+fFname+'_JD='+Format('%6.6f',[DateTimeToJulianDate(Now)])+ext;
  end;
  end;
end;


procedure Register;
begin
     RegisterComponents('STAF', [TCanon]);
end;

end.
