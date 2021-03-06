unit uApiFile;

interface

uses
  // Delphi
  SysUtils, Classes, Generics.Collections, StrUtils,
  // Common
  uBaseConst, uBaseInterface, uAppConst, uAppInterface, uFileInterface,
  // Utils
  uStringUtils;

type
  // TODO: Re-write
  TChangeableObject = class(TInterfacedObject, IChangeable)
  private
    FChanged: Boolean;
    class function GetListChanged(AList: TList<IChangeable>): Boolean;
    class procedure SetListChanged(AList: TList<IChangeable>; AChanged: Boolean);
  protected
    function GetChanged: WordBool; virtual;
    procedure SetChanged(AChanged: WordBool); virtual;

    procedure Change;
  public
    constructor Create; reintroduce; virtual;
    property Changed: WordBool read GetChanged write SetChanged;

    property ListChanged[AList: TList<IChangeable>]: Boolean read GetListChanged write SetListChanged;
  end;

  TSubType = class(TChangeableObject, ISubType)
  private
    FControlName, FControlValue, FID: string;
    FSubTypes: TList<ISubType>;
    procedure SubTypesNotify(Sender: TObject; const Item: ISubType; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetControlName: WideString;
    procedure SetGetControlName(const AGetControlName: WideString); overload;
    procedure SetGetControlName(AControlID: TControlID); overload;

    function GetControlValue: WideString;
    procedure SetGetControlValue(const AGetControlValue: WideString);
    function GetID: WideString;
    procedure SetID(const AID: WideString);
    function GetSubTypes: TList<ISubType>;
  public
    constructor Create; overload; override;
    constructor Create(AControlID: TControlID; const AControlValue: WideString = ''; const AID: WideString = ''); reintroduce; overload;
    property ControlName: WideString read GetControlName write SetGetControlName;
    property ControlValue: WideString read GetControlValue write SetGetControlValue;
    property ID: WideString read GetID write SetID;
    property SubTypes: TList<ISubType>read GetSubTypes;
    destructor Destroy; override;
  end;

  TType = class(TChangeableObject, IType)
  private
    FName, FID: string;
    FSubTypes: TList<ISubType>;
    procedure SubTypesNotify(Sender: TObject; const Item: ISubType; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetName: WideString;
    procedure SetName(const AName: WideString); overload;
    procedure SetName(ATypeID: TTypeID); overload;
    function GetID: WideString;
    procedure SetID(const AID: WideString);
    function GetSubTypes: TList<ISubType>;
  public
    constructor Create; overload; override;
    constructor Create(ATypeID: TTypeID; const AID: WideString = ''); reintroduce; overload;
    property Name: WideString read GetName write SetName;
    property ID: WideString read GetID write SetID;
    property SubTypes: TList<ISubType>read GetSubTypes;
    destructor Destroy; override;
  end;

  TID = class(TChangeableObject, IID)
  private
    FName: string;
    FTypes: TList<IType>;
    procedure TypesNotify(Sender: TObject; const Item: IType; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetName: WideString;
    procedure SetName(const AName: WideString);
    function GetTypes: TList<IType>;
  public
    constructor Create; override;
    property Name: WideString read GetName write SetName;
    property Types: TList<IType>read GetTypes;
    destructor Destroy; override;
  end;

  TWebsiteConfigurationFile = class(TChangeableObject, IWebsiteConfigurationFile)
  private
    FWebsiteURL, FWebsiteType, FWebsiteCharset: string;
    FIDs: TList<IID>;
    procedure IDsNotify(Sender: TObject; const Item: IID; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetWebsiteURL: WideString;
    procedure SetWebsiteURL(const AWebsiteURL: WideString);
    function GetWebsiteType: WideString;
    procedure SetWebsiteType(const AWebsiteType: WideString);
    function GetWebsiteCharset: WideString;
    procedure SetWebsiteCharset(const AWebsiteCharset: WideString);
    function GetIDs: TList<IID>;
  public
    constructor Create; override;
    property WebsiteURL: WideString read GetWebsiteURL write SetWebsiteURL;
    property WebsiteType: WideString read GetWebsiteType write SetWebsiteType;
    property WebsiteCharset: WideString read GetWebsiteCharset write SetWebsiteCharset;
    property IDs: TList<IID>read GetIDs;
    destructor Destroy; override;
  end;

  TControl = class(TChangeableObject, IControl)
  private
    FCategory, FName, FRelation, FValue: string;
  protected
    function GetCategory: WideString;
    procedure SetCategory(const ACategory: WideString);
    function GetName: WideString;
    procedure SetName(const AName: WideString);
    function GetRelation: WideString;
    procedure SetRelation(const ARelation: WideString);
    function GetValue: WideString;
    procedure SetValue(const AValue: WideString);
  public
    property Category: WideString read GetCategory write SetCategory;
    property Name: WideString read GetName write SetName;
    property Relation: WideString read GetRelation write SetRelation;
    property Value: WideString read GetValue write SetValue;
  end;

  THosterType = (htFile, htImage);

  THoster = class(TChangeableObject, IHoster)
  private
    FName: string;
    FRanked: Boolean;
    FBlacklist, FWhitelist: TStringList;

    procedure StringListChange(Sender: TObject);
  protected
    function GetName: WideString;
    procedure SetName(const AName: WideString);
    function GetRanked: WordBool;
    procedure SetRanked(ARanked: WordBool);
    function GetBlacklist: TStringList;
    function GetWhitelist: TStringList;
  public
    constructor Create; override;
    property Name: WideString read GetName write SetName;
    property Ranked: WordBool read GetRanked write SetRanked;
    property Blacklist: TStringList read GetBlacklist;
    property Whitelist: TStringList read GetWhitelist;
    destructor Destroy; override;
  end;

  TFilter = class(TChangeableObject, IFilter)
  private
    FActive: Boolean;
    FCategories: string;
    FControls: TList<IControl>;
    FHosters: TList<IHoster>;
    procedure ControlsNotify(Sender: TObject; const Item: IControl; Action: TCollectionNotification);
    procedure HostersNotify(Sender: TObject; const Item: IHoster; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetActive: WordBool;
    procedure SetActive(AActive: WordBool);
    function GetCategories: WideString;
    function GetCategoriesAsTTypeIDs: TTypeIDs;
    procedure SetCategories(const ACategories: WideString);
    function GetControls: TList<IControl>;
    function GetHoster: TList<IHoster>;
  public
    constructor Create; override;
    property Active: WordBool read GetActive write SetActive;
    property Categories: WideString read GetCategories write SetCategories;
    property Controls: TList<IControl>read GetControls;
    property Hosters: TList<IHoster>read GetHoster;
    destructor Destroy; override;
  end;

  TCustomField = class(TChangeableObject, ICustomField)
  private
    FName, FValue: string;
  protected
    function GetName: WideString;
    procedure SetName(const AName: WideString);
    function GetValue: WideString;
    procedure SetValue(const AValue: WideString);
  public
    constructor Create(const AName, AValue: WideString); reintroduce;
    property Name: WideString read GetName write SetName;
    property Value: WideString read GetValue write SetValue;
  end;

  TCustomFields = class(TChangeableObject, ICustomFields)
  private
    FCustomFields: TList<ICustomField>;
    procedure CustomFieldsNotify(Sender: TObject; const Item: ICustomField; Action: TCollectionNotification);
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetCustomFields: TList<ICustomField>;
  public
    constructor Create; override;
    property CustomFields: TList<ICustomField>read GetCustomFields;
    destructor Destroy; override;
  end;

  TIntelligeNConfigurationFile = class(TWebsiteConfigurationFile, IIntelligeNConfigurationFile)
  private
    FFilter: IFilter;
    FCustomFields: ICustomFields;
  protected
    function GetChanged: WordBool; override;
    procedure SetChanged(AChanged: WordBool); override;

    function GetWebsiteFilter: IFilter;
    function GetWebsiteCustomFields: ICustomFields;
  public
    constructor Create; override;
    property WebsiteURL;
    property WebsiteType;
    property WebsiteCharset;
    property WebsiteFilter: IFilter read GetWebsiteFilter;
    property WebsiteCustomFields: ICustomFields read GetWebsiteCustomFields;
    destructor Destroy; override;
  end;

function GetHosterTypeName(const AHosterType: THosterType): string;
function GetHosterNameType(const AHosterName: string): THosterType;

implementation

{$REGION 'TChangeableObject'}
{ TChangeableObject }

class function TChangeableObject.GetListChanged(AList: TList<IChangeable>): Boolean;
var
  Changeable: IChangeable;
begin
  Result := False;
  for Changeable in AList do
    if Changeable.Changed then
      Exit(True);
end;

class procedure TChangeableObject.SetListChanged(AList: TList<IChangeable>; AChanged: Boolean);
var
  Changeable: IChangeable;
begin
  for Changeable in AList do
    Changeable.Changed := AChanged;
end;

function TChangeableObject.GetChanged: WordBool;
begin
  Result := FChanged;
end;

procedure TChangeableObject.SetChanged(AChanged: WordBool);
begin
  FChanged := AChanged;
end;

procedure TChangeableObject.Change;
begin
  Changed := True;
end;

constructor TChangeableObject.Create;
begin
  FChanged := False;
end;
{$ENDREGION}
{$REGION 'TSubType'}
{ TSubType }

procedure TSubType.SubTypesNotify(Sender: TObject; const Item: ISubType; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TSubType.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FSubTypes)];
end;

procedure TSubType.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FSubTypes)] := AChanged;
end;

function TSubType.GetControlName: WideString;
begin
  Result := FControlName;
end;

procedure TSubType.SetGetControlName(const AGetControlName: WideString);
begin
  FControlName := AGetControlName;
  Change;
end;

function TSubType.GetControlValue: WideString;
begin
  Result := FControlValue;
end;

procedure TSubType.SetGetControlValue(const AGetControlValue: WideString);
begin
  FControlValue := AGetControlValue;
  Change;
end;

procedure TSubType.SetGetControlName(AControlID: TControlID);
begin
  FControlValue := ControlIDToString(AControlID);
  Change;
end;

function TSubType.GetID: WideString;
begin
  Result := FID;
end;

procedure TSubType.SetID(const AID: WideString);
begin
  FID := AID;
  Change;
end;

function TSubType.GetSubTypes: TList<ISubType>;
begin
  Result := FSubTypes;
end;

constructor TSubType.Create;
begin
  inherited Create;
  FSubTypes := TList<ISubType>.Create;
  FSubTypes.OnNotify := SubTypesNotify;
end;

constructor TSubType.Create(AControlID: TControlID; const AControlValue: WideString = ''; const AID: WideString = '');
begin
  Create;
  SetGetControlName(AControlID);
  ControlValue := AControlValue;
  ID := AID;
end;

destructor TSubType.Destroy;
begin
  FSubTypes.OnNotify := nil;
  FSubTypes.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TType'}
{ TType }

procedure TType.SubTypesNotify(Sender: TObject; const Item: ISubType; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TType.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FSubTypes)];
end;

procedure TType.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FSubTypes)] := AChanged;
end;

function TType.GetName: WideString;
begin
  Result := FName;
end;

procedure TType.SetName(const AName: WideString);
begin
  FName := AName;
  Change;
end;

procedure TType.SetName(ATypeID: TTypeID);
begin
  FName := TypeIDToString(ATypeID);
  Change;
end;

function TType.GetID: WideString;
begin
  Result := FID;
end;

procedure TType.SetID(const AID: WideString);
begin
  FID := AID;
  Change;
end;

function TType.GetSubTypes: TList<ISubType>;
begin
  Result := FSubTypes;
end;

constructor TType.Create;
begin
  inherited Create;
  FSubTypes := TList<ISubType>.Create;
  FSubTypes.OnNotify := SubTypesNotify;
end;

constructor TType.Create(ATypeID: TTypeID; const AID: WideString = '');
begin
  Create;
  SetName(ATypeID);
  ID := AID;
end;

destructor TType.Destroy;
begin
  FSubTypes.OnNotify := nil;
  FSubTypes.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TID'}
{ TID }

procedure TID.TypesNotify(Sender: TObject; const Item: IType; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TID.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FTypes)];
end;

procedure TID.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FTypes)] := AChanged;
end;

function TID.GetName: WideString;
begin
  Result := FName;
end;

procedure TID.SetName(const AName: WideString);
begin
  FName := AName;
  Change;
end;

function TID.GetTypes: TList<IType>;
begin
  Result := FTypes;
end;

constructor TID.Create;
begin
  inherited Create;
  FTypes := TList<IType>.Create;
  FTypes.OnNotify := TypesNotify;
end;

destructor TID.Destroy;
begin
  FTypes.OnNotify := nil;
  FTypes.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TWebsiteConfigurationFile'}
{ TWebsiteConfigurationFile }

procedure TWebsiteConfigurationFile.IDsNotify(Sender: TObject; const Item: IID; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TWebsiteConfigurationFile.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FIDs)];
end;

procedure TWebsiteConfigurationFile.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FIDs)] := AChanged;
end;

function TWebsiteConfigurationFile.GetWebsiteURL: WideString;
begin
  Result := FWebsiteURL;
end;

procedure TWebsiteConfigurationFile.SetWebsiteURL(const AWebsiteURL: WideString);
begin
  FWebsiteURL := AWebsiteURL;
  Change;
end;

function TWebsiteConfigurationFile.GetWebsiteType: WideString;
begin
  Result := FWebsiteType;
end;

procedure TWebsiteConfigurationFile.SetWebsiteType(const AWebsiteType: WideString);
begin
  FWebsiteType := AWebsiteType;
  Change;
end;

function TWebsiteConfigurationFile.GetWebsiteCharset: WideString;
begin
  Result := FWebsiteCharset;
end;

procedure TWebsiteConfigurationFile.SetWebsiteCharset(const AWebsiteCharset: WideString);
begin
  FWebsiteCharset := AWebsiteCharset;
  Change;
end;

function TWebsiteConfigurationFile.GetIDs: TList<IID>;
begin
  Result := FIDs;
end;

constructor TWebsiteConfigurationFile.Create;
begin
  inherited Create;
  FIDs := TList<IID>.Create;
  FIDs.OnNotify := IDsNotify;
end;

destructor TWebsiteConfigurationFile.Destroy;
begin
  FIDs.OnNotify := nil;
  FIDs.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TControl'}
{ TControl }

function TControl.GetCategory: WideString;
begin
  Result := FCategory;
end;

procedure TControl.SetCategory(const ACategory: WideString);
begin
  FCategory := ACategory;
  Change;
end;

function TControl.GetName: WideString;
begin
  Result := FName;
end;

procedure TControl.SetName(const AName: WideString);
begin
  FName := AName;
  Change;
end;

function TControl.GetRelation: WideString;
begin
  Result := FRelation;
end;

procedure TControl.SetRelation(const ARelation: WideString);
begin
  FRelation := ARelation;
  Change;
end;

function TControl.GetValue: WideString;
begin
  Result := FValue;
end;

procedure TControl.SetValue(const AValue: WideString);
begin
  FValue := AValue;
  Change;
end;
{$ENDREGION}
{$REGION 'THoster'}
{ THoster }

procedure THoster.StringListChange(Sender: TObject);
begin
  Change;
end;

function THoster.GetName: WideString;
begin
  Result := FName;
end;

procedure THoster.SetName(const AName: WideString);
begin
  FName := AName;
  Change;
end;

function THoster.GetRanked: WordBool;
begin
  Result := FRanked;
end;

procedure THoster.SetRanked(ARanked: WordBool);
begin
  FRanked := ARanked;
  Change;
end;

function THoster.GetBlacklist: TStringList;
begin
  Result := FBlacklist;
end;

function THoster.GetWhitelist: TStringList;
begin
  Result := FWhitelist;
end;

constructor THoster.Create;
begin
  inherited Create;
  FBlacklist := TStringList.Create;
  FWhitelist := TStringList.Create;

  FBlacklist.OnChange := StringListChange;
  FWhitelist.OnChange := StringListChange;
end;

destructor THoster.Destroy;
begin
  FWhitelist.OnChange := nil;
  FBlacklist.OnChange := nil;

  FWhitelist.Free;
  FBlacklist.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TFilter'}
{ TFilter }

procedure TFilter.ControlsNotify(Sender: TObject; const Item: IControl; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

procedure TFilter.HostersNotify(Sender: TObject; const Item: IHoster; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TFilter.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FControls)] and ListChanged[TList<IChangeable>(FHosters)];
end;

procedure TFilter.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FControls)] := AChanged;
  ListChanged[TList<IChangeable>(FHosters)] := AChanged;
end;

function TFilter.GetActive: WordBool;
begin
  Result := FActive;
end;

procedure TFilter.SetActive(AActive: WordBool);
begin
  FActive := AActive;
  Change;
end;

function TFilter.GetCategories: WideString;
begin
  Result := FCategories;
end;

function TFilter.GetCategoriesAsTTypeIDs: TTypeIDs;
var
  I: Integer;
begin
  Result := [];
  with SplittString(';', FCategories) do
    try
      for I := 0 to Count - 1 do
        try
          Result := Result + [StringToTypeID(Strings[I])];
        except

        end;
    finally
      Free;
    end;
end;

procedure TFilter.SetCategories(const ACategories: WideString);
begin
  FCategories := ACategories;
  Change;
end;

function TFilter.GetControls: TList<IControl>;
begin
  Result := FControls;
end;

function TFilter.GetHoster: TList<IHoster>;
begin
  Result := FHosters;
end;

constructor TFilter.Create;
begin
  inherited Create;
  FControls := TList<IControl>.Create;
  FHosters := TList<IHoster>.Create;

  FControls.OnNotify := ControlsNotify;
  FHosters.OnNotify := HostersNotify;
end;

destructor TFilter.Destroy;
begin
  FControls.OnNotify := nil;
  FHosters.OnNotify := nil;
  FControls.Free;
  FHosters.Free;
  inherited;
end;
{$ENDREGION}
{$REGION 'TCustomField'}
{ TCustomField }

function TCustomField.GetName: WideString;
begin
  Result := FName;
end;

procedure TCustomField.SetName(const AName: WideString);
begin
  FName := AName;
  Change;
end;

function TCustomField.GetValue: WideString;
begin
  Result := FValue;
end;

procedure TCustomField.SetValue(const AValue: WideString);
begin
  FValue := AValue;
  Change;
end;

constructor TCustomField.Create(const AName, AValue: WideString);
begin
  inherited Create;
  FName := AName;
  FValue := AValue;
end;
{$ENDREGION}
{$REGION 'TCustomFields'}
{ TCustomFields }

procedure TCustomFields.CustomFieldsNotify(Sender: TObject; const Item: ICustomField; Action: TCollectionNotification);
begin
  if Action in [cnAdded, cnRemoved] then
    Change;
end;

function TCustomFields.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and ListChanged[TList<IChangeable>(FCustomFields)];
end;

procedure TCustomFields.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  ListChanged[TList<IChangeable>(FCustomFields)] := AChanged;
end;

function TCustomFields.GetCustomFields: TList<ICustomField>;
begin
  Result := FCustomFields;
end;

constructor TCustomFields.Create;
begin
  inherited Create;
  FCustomFields := TList<ICustomField>.Create;

  FCustomFields.OnNotify := CustomFieldsNotify;
end;

destructor TCustomFields.Destroy;
begin
  FCustomFields.OnNotify := nil;

  FCustomFields.Free;
  inherited Destroy;
end;
{$ENDREGION}
{$REGION 'TIntelligeNConfigurationFile'}
{ TIntelligeNConfigurationFile }

function TIntelligeNConfigurationFile.GetChanged: WordBool;
begin
  Result := ( inherited GetChanged) and WebsiteFilter.Changed and WebsiteCustomFields.Changed;
end;

procedure TIntelligeNConfigurationFile.SetChanged(AChanged: WordBool);
begin
  inherited SetChanged(AChanged);
  WebsiteFilter.Changed := AChanged;
  WebsiteCustomFields.Changed := AChanged;
end;

function TIntelligeNConfigurationFile.GetWebsiteFilter: IFilter;
begin
  Result := FFilter;
end;

function TIntelligeNConfigurationFile.GetWebsiteCustomFields: ICustomFields;
begin
  Result := FCustomFields;
end;

constructor TIntelligeNConfigurationFile.Create;
begin
  inherited Create;
  FFilter := TFilter.Create;
  FCustomFields := TCustomFields.Create;
end;

destructor TIntelligeNConfigurationFile.Destroy;
begin
  FCustomFields := nil;
  FFilter := nil;
  inherited Destroy;
end;
{$ENDREGION}

const
  TStringHosterType: array [0 .. 1] of string = ('filehoster', 'imagehoster');

function GetHosterTypeName(const AHosterType: THosterType): string;
begin
  Result := TStringHosterType[Integer(AHosterType)];
end;

function GetHosterNameType(const AHosterName: string): THosterType;
var
  I: Integer;
begin
  I := IndexStr(AHosterName, TStringHosterType);

  if not(I = -1) then
    Result := THosterType(I)
  else
    raise Exception.Create('Unknown hoster type');
end;

end.
