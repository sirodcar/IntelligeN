unit uSexvideoallCom;

interface

uses
  // Delphi
  SysUtils, StrUtils, HTTPApp,
  // RegEx
  RegExpr,
  // Common
  uBaseConst, uBaseInterface,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // Plugin system
  uPlugInCrawlerClass, uPlugInHTTPClasses,
  // Utils
  uHTMLUtils, uStringUtils;

type
  TSexvideoallCom = class(TCrawlerPlugIn)
  protected { . }
  const
    WEBSITE = 'http://www.sexvideoall.com/';
  public
    function GetName: WideString; override; safecall;

    function InternalGetAvailableTypeIDs: TTypeIDs; override; safecall;
    function InternalGetAvailableControlIDs(const ATypeID: TTypeID): TControlIDs; override; safecall;
    function InternalGetControlIDDefaultValue(const ATypeID: TTypeID; const AControlID: TControlID): WordBool; override; safecall;
    function InternalGetDependentControlIDs: TControlIDs; override; safecall;

    function InternalExecute(const ATypeID: TTypeID; const AControlIDs: TControlIDs; const ALimit: Integer; const AControlController: IControlControllerBase; ACanUse: TCrawlerCanUseFunc): WordBool; override; safecall;

    function GetResultsLimitDefaultValue: Integer; override; safecall;
  end;

implementation

{ TSexvideoallCom }

function TSexvideoallCom.GetName;
begin
  result := 'sexvideoall.com';
end;

function TSexvideoallCom.InternalGetAvailableTypeIDs;
begin
  result := [cXXX];
end;

function TSexvideoallCom.InternalGetAvailableControlIDs;
begin
  result := [cPicture, cGenre, cRuntime, cDescription];
end;

function TSexvideoallCom.InternalGetControlIDDefaultValue;
begin
  result := True;
end;

function TSexvideoallCom.InternalGetDependentControlIDs;
begin
  result := [cTitle];
end;

function TSexvideoallCom.InternalExecute;

  procedure deep_search(AWebsiteSourceCode: string);
  begin
    if ACanUse(cPicture) then
      with TRegExpr.Create do
        try
          InputString := ExtractTextBetween(AWebsiteSourceCode, '<div style="text-align: center; padding: 5px; margin-left: 300px;">', 'clear:');
          Expression := 'src=''(.*?)''';

          if Exec(InputString) then
          begin
            repeat
              AControlController.FindControl(cPicture).AddProposedValue(GetName, Match[1]);
            until not ExecNext;
          end;
        finally
          Free;
        end;

    if ACanUse(cRuntime) then
      with TRegExpr.Create do
        try
          InputString := AWebsiteSourceCode;
          Expression := 'Length:.*?&nbsp;(\d+)';

          if Exec(InputString) then
            AControlController.FindControl(cRuntime).AddProposedValue(GetName, Trim(Match[1]));
        finally
          Free;
        end;

    if ACanUse(cGenre) then
      with TRegExpr.Create do
        try
          InputString := ExtractTextBetween(AWebsiteSourceCode, 'Genre:', '<br />');
          Expression := '> (.*?) <\/a>';

          if Exec(InputString) then
          begin
            repeat
              AControlController.FindControl(cGenre).AddProposedValue(GetName, Trim(Match[1]));
            until not ExecNext;
          end;
        finally
          Free;
        end;

    if ACanUse(cDescription) then
      with TRegExpr.Create do
        try
          InputString := ExtractTextBetween(AWebsiteSourceCode, '<div class=''bottomline''>', '<div class=''bottomline''>');
          Expression := '<br \/><br \/>(.*?)$';

          if Exec(InputString) then
            AControlController.FindControl(cDescription).AddProposedValue(GetName, Trim(HTML2Text(Match[1])));
        finally
          Free;
        end;
  end;

var
  LTitle: string;
  LCount: Integer;

  LRequestID1, LRequestID2: Double;

  LResponeStr: string;
begin
  LTitle := AControlController.FindControl(cTitle).Value;
  LCount := 0;

  // http://www.sexvideoall.com/en/results.aspx?tkword=Amateur%20Japanese

  LResponeStr := GETRequest(WEBSITE + 'en/results.aspx?tkword=' + HTTPEncode(LTitle), LRequestID1);

  if not(Pos('found', LResponeStr) = 0) then
  begin
    with TRegExpr.Create do
      try
        InputString := ExtractTextBetween(LResponeStr, '<div id="main">', '<div id');
        Expression := ';''><a href=''(.*?)''';

        if Exec(InputString) then
        begin
          repeat
            LResponeStr := GETFollowUpRequest(WEBSITE + 'en/' + Match[1], LRequestID1, LRequestID2);

            deep_search(LResponeStr);

            Inc(LCount);
          until not(ExecNext and ((LCount < ALimit) or (ALimit = 0)));
        end;
      finally
        Free;
      end;
  end
  else if not(Pos('page_contentmaster', LResponeStr) = 0) then
  begin
    deep_search(LResponeStr);
  end;
end;

function TSexvideoallCom.GetResultsLimitDefaultValue: Integer;
begin
  result := 5;
end;

end.
