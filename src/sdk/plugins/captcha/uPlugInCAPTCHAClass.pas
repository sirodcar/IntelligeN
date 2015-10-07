unit uPlugInCAPTCHAClass;

interface

uses
  // Plugin
  uPlugInInterface, uPlugInClass, uPlugInConst;

type
  TCAPTCHAPlugIn = class(TPlugIn, ICAPTCHAPlugIn)
  private
    FCAPTCHA, FGetCAPTCHAName, FCAPTCHAResult, FCookies: WideString;
    FCAPTCHAType: TCAPTCHAType;
  public
    function GetCAPTCHA: WideString; safecall;
    procedure SetCAPTCHA(ACAPTCHA: WideString); safecall;
    function GetCAPTCHAType: TCAPTCHAType; safecall;
    procedure SetCAPTCHAType(ACAPTCHAType: TCAPTCHAType); safecall;
    function GetCAPTCHAName: WideString; safecall;
    procedure SetCAPTCHAName(ACAPTCHAName: WideString); safecall;
    function GetCAPTCHAResult: WideString; safecall;
    procedure SetCAPTCHAResult(ACAPTCHAResult: WideString); safecall;
    function GetCookies: WideString; safecall;
    procedure SetCookies(ACookies: WideString); safecall;

    property CAPTCHA: WideString read GetCAPTCHA write SetCAPTCHA;
    property CAPTCHAType: TCAPTCHAType read GetCAPTCHAType write SetCAPTCHAType;
    property CAPTCHAName: WideString read GetCAPTCHAName write SetCAPTCHAName;
    property CAPTCHAResult: WideString read GetCAPTCHAResult write SetCAPTCHAResult;
    property Cookies: WideString read GetCookies write SetCookies;

    function Exec: WordBool; virtual; safecall; abstract;
  end;

implementation

{ TCAPTCHAPlugIn }

function TCAPTCHAPlugIn.GetCAPTCHA: WideString;
begin
  Result := FCAPTCHA;
end;

procedure TCAPTCHAPlugIn.SetCAPTCHA(ACAPTCHA: WideString);
begin
  FCAPTCHA := ACAPTCHA;
end;

function TCAPTCHAPlugIn.GetCAPTCHAType: TCAPTCHAType;
begin
  Result := FCAPTCHAType;
end;

procedure TCAPTCHAPlugIn.SetCAPTCHAType(ACAPTCHAType: TCAPTCHAType);
begin
  FCAPTCHAType := ACAPTCHAType;
end;

function TCAPTCHAPlugIn.GetCAPTCHAName: WideString;
begin
  Result := FGetCAPTCHAName;
end;

procedure TCAPTCHAPlugIn.SetCAPTCHAName(ACAPTCHAName: WideString);
begin
  FGetCAPTCHAName := ACAPTCHAName;
end;

function TCAPTCHAPlugIn.GetCAPTCHAResult: WideString;
begin
  Result := FCAPTCHAResult;
end;

procedure TCAPTCHAPlugIn.SetCAPTCHAResult(ACAPTCHAResult: WideString);
begin
  FCAPTCHAResult := ACAPTCHAResult;
end;

function TCAPTCHAPlugIn.GetCookies: WideString;
begin
  Result := FCookies;
end;

procedure TCAPTCHAPlugIn.SetCookies(ACookies: WideString);
begin
  FCookies := ACookies;
end;

end.
