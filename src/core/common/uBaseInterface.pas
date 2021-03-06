{ ********************************************************
  *                                     IntelligeN CORE  *
  *  Global base interface                               *
  *  Version 2.5.0.0                                     *
  *  Copyright (c) 2015 Sebastian Klatte                 *
  *                                                      *
  ******************************************************** }
unit uBaseInterface;

interface

uses
  // Common
  uBaseConst;

type
  IValueItem = interface
    ['{E1096EE1-D38F-4BCB-9341-417550DDAD38}']
    function GetValue: WideString; safecall;

    property Value: WideString read GetValue;
  end;

  INameValueItem = interface(IValueItem)
    ['{F7EDF630-5CE4-4250-9193-D2759E13D6A1}']
    function GetName: WideString; safecall;

    property Name: WideString read GetName;
  end;

  IControlData = interface(IValueItem)
    ['{CE74BD5F-80B2-4D4F-AB2D-F29AA0773F58}']
    function GetControlID: TControlID; safecall;

    property ControlID: TControlID read GetControlID;
  end;

  IControlBase = interface(IControlData)
    ['{06C360E4-BBFB-462E-A2AD-54BE875635AE}']
    procedure AddProposedValue(const ASender: WideString; const AValue: WideString; const ATitle: WideString = ''); safecall;
    function GetProposedValue(const AIndex: Integer): WideString; safecall;
    function GetProposedValueSender(const AIndex: Integer): WideString; safecall;
    function GetProposedValueTitle(const AIndex: Integer): WideString; safecall;
    function GetProposedValuesCount: Integer; safecall;
    procedure UpdateValueFromProposedValue; safecall;

    property ProposedValuesCount: Integer read GetProposedValuesCount;
  end;

  IMirrorData = interface(IValueItem)
    ['{BD6E30EB-EC6F-476C-8C57-51ADEBB75156}']
    function GetStatus: TContentStatus; safecall;
    function GetSize: Double; safecall;
    function GetPartSize: Double; safecall;
    function GetHoster: WideString; safecall;
    function GetHosterShort: WideString; safecall;
    function GetParts: Integer; safecall;

    property Status: TContentStatus read GetStatus;
    property Size: Double read GetSize;
    property PartSize: Double read GetPartSize;
    property Hoster: WideString read GetHoster;
    property HosterShort: WideString read GetHosterShort;
    property Parts: Integer read GetParts;
  end;

  IDirectlink = interface(IMirrorData)
    ['{F8592097-8D2E-4EC6-AE2F-B74092641096}']
    function GetFileName: WideString; safecall;

    property FileName: WideString read GetFileName;
  end;

  ICrypter = interface(IMirrorData)
    ['{10541298-AE56-42F5-ACE2-7EA93E93AF26}']
    function GetName: WideString; safecall;
    function GetStatusImage: WideString; safecall;
    function GetStatusImageText: WideString; safecall;

    property Name: WideString read GetName;
    property StatusImage: WideString read GetStatusImage;
    property StatusImageText: WideString read GetStatusImageText;
  end;

  IDirectlinkContainer = interface(IDirectlink)
    ['{8D4E5551-1DC6-4AE3-BC6E-C16045277C52}']
    function GetDirectlink(const Index: Integer): IDirectlink; safecall;
    function GetDirectlinkCount: Integer; safecall;

    property Directlink[const Index: Integer]: IDirectlink read GetDirectlink;
    property DirectlinkCount: Integer read GetDirectlinkCount;
  end;

  IMirrorContainer = interface(IDirectlinkContainer)
    ['{0FC2EC0F-D5E8-42A7-8C75-0F4BBDD48089}']
    function GetCrypter(const IndexOrName: OleVariant): ICrypter; safecall;
    function GetCrypterCount: Integer; safecall;

    function FindCrypter(const AName: WideString): ICrypter; safecall;

    property Crypter[const IndexOrName: OleVariant]: ICrypter read GetCrypter;
    property CrypterCount: Integer read GetCrypterCount;
  end;

  IControlControllerBase = interface
    ['{CC51899A-01B3-43A0-ABEB-C90350956977}']
    function GetControl(const IndexOrName: OleVariant): IControlBase; safecall;
    function GetControlCount: Integer; safecall;

    function FindControl(const AControlID: TControlID): IControlBase; safecall;

    property Control[const IndexOrName: OleVariant]: IControlBase read GetControl;
    property ControlCount: Integer read GetControlCount;
  end;

  IMirrorControllerBase = interface
    ['{723BD89D-867F-49DF-8E89-98EA81C6B3EA}']
    function GetMirror(const IndexOrName: OleVariant): IMirrorContainer; safecall;
    function GetMirrorCount: Integer; safecall;

    function FindMirror(const AHoster: WideString): IMirrorContainer; safecall;

    property Mirror[const IndexOrName: OleVariant]: IMirrorContainer read GetMirror;
    property MirrorCount: Integer read GetMirrorCount;
  end;

  ITabSheetData = interface
    ['{68C4F907-A032-408E-9A68-2C4ADA0262D5}']
    function GetTypeID: TTypeID; safecall;

    function GetControl(const IndexOrName: OleVariant): IControlData; safecall;
    function GetControlCount: Integer; safecall;
    function GetMirror(const IndexOrName: OleVariant): IMirrorContainer; safecall;
    function GetMirrorCount: Integer; safecall;

    function GetCustomField(const IndexOrName: OleVariant): INameValueItem; safecall;
    function GetCustomFieldCount: Integer; safecall;

    property TypeID: TTypeID read GetTypeID;

    function FindControl(const AControlID: TControlID): IControlData; safecall;
    function FindMirror(const AHoster: WideString): IMirrorContainer; safecall;
    function FindCustomField(const AName: WideString): INameValueItem; safecall;

    property Control[const IndexOrName: OleVariant]: IControlData read GetControl;
    property ControlCount: Integer read GetControlCount;
    property Mirror[const IndexOrName: OleVariant]: IMirrorContainer read GetMirror;
    property MirrorCount: Integer read GetMirrorCount;

    property CustomField[const IndexOrName: OleVariant]: INameValueItem read GetCustomField;
    property CustomFieldCount: Integer read GetCustomFieldCount;
  end;

  IWebsiteEditor = interface
    ['{75F63C46-C88E-48C5-BDC1-C7D81BEFEC1A}']
    function GetCustomFields: WordBool; safecall;
    procedure SetCustomFields(const ACustomFields: WordBool); safecall;

    procedure AddEdit(const AName: WideString; const ADefaultValue: WideString = ''); safecall;
    procedure AddCheckbox(const AName: WideString; const ADefaultValue: WordBool = False); safecall;
    procedure AddCategoryTab(const AName: WideString); safecall;

    property CustomFields: WordBool read GetCustomFields write SetCustomFields;

    function ShowModal: Integer; safecall;
  end;

implementation

end.
