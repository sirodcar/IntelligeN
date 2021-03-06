{ ********************************************************
  *                            IntelligeN PLUGIN SYSTEM  *
  *  Mediafire.com Delphi API                            *
  *  Version 2.5.0.0                                     *
  *  Copyright (c) 2016 Sebastian Klatte                 *
  *                                                      *
  ******************************************************** }
unit uMediafireCom;

interface

uses
  // Delphi
  Windows, SysUtils, Classes, Math, HTTPApp,
  // Reg Ex
  RegExpr,
  // Common
  uBaseConst,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // plugin system
  uPlugInConst, uPlugInInterface, uPlugInFileHosterClass, uPlugInFileHosterClasses, uPlugInHTTPClasses,
  // Utils
  uPathUtils, uSizeUtils, uURLUtils;

type
  TMediafireCom = class(TFileHosterPlugIn)
  protected
    function InternalCheckLinks(const AFiles: WideString; out ALinksInfo: ILinksInfo): WordBool; override;
  public
    function GetAuthor: WideString; override;
    function GetAuthorURL: WideString; override;
    function GetDescription: WideString; override;
    function GetName: WideString; override;
  end;

implementation

{ TMediafireCom }

function TMediafireCom.InternalCheckLinks(const AFiles: WideString; out ALinksInfo: ILinksInfo): WordBool;

  function GetRandomFourLetters(): string;
  const
    LETTERS = 'abcdefghijklmnopqrstuvwxyz';
  var
    LIndex: Integer;
  begin
    Randomize;
    Result := '';
    for LIndex := 0 to 4 - 1 do
      Result := Result + LETTERS[Random(Length(LETTERS)) + 1];
  end;

  function GetDownloadlinkID(const ALink: string): string;
  begin
    Result := '';

    with TRegExpr.Create do
      try
        InputString := ALink;
        Expression := '(file|download)\/(\w+)';

        if Exec(InputString) then
        begin
          Result := Match[2];
        end
        else
        begin
          Expression := '(\w+)(\/)?$';
          if Exec(InputString) then
            Result := Match[1];
        end;
      finally
        Free;
      end;
  end;

var
  LLinkIndex: Integer;
  LLinksInfo: TLinksInfo;

  LHTTPRequest: IHTTPRequest;
  LRequestID: Double;

  LResponeStr, LIDsString, LOverAllPostReply: string;
begin
  Result := True;

  LLinksInfo := TLinksInfo.Create;

  with TStringList.Create do
    try
      Text := AFiles;

      LOverAllPostReply := '';
      LIDsString := '';
      for LLinkIndex := 0 to Count - 1 do
      begin
        LIDsString := LIDsString + GetDownloadlinkID(Strings[LLinkIndex]);
        if not(LLinkIndex = Count - 1) then
          LIDsString := LIDsString + ',';

        if (LLinkIndex > 0) and (LLinkIndex mod 100 = 0) or (LLinkIndex = Count - 1) then
        begin
          LHTTPRequest := THTTPRequest.Create('https://www.mediafire.com/api/1.5/file/get_info.php' + '?r=' + GetRandomFourLetters() + '&quick_key=' + LIDsString);

          LRequestID := HTTPManager.Get(LHTTPRequest, TPlugInHTTPOptions.Create(Self));

          HTTPManager.WaitFor(LRequestID);

          LResponeStr := HTTPManager.GetResult(LRequestID).HTTPResult.SourceCode;

          LOverAllPostReply := LOverAllPostReply + LResponeStr;
          LIDsString := '';
        end;
      end;

      for LLinkIndex := 0 to Count - 1 do
        with TRegExpr.Create do
          try
            InputString := LOverAllPostReply;
            Expression := '<quickkey>' + GetDownloadlinkID(Strings[LLinkIndex]) + '<\/quickkey><filename>(.*?)<\/filename>.*?<size>(\d+)<\/size>.*?<hash>(\w+)<\/hash>';

            if Exec(InputString) then
              LLinksInfo.AddLink(Strings[LLinkIndex], Match[1], csOnline, StrToInt64Def(Match[2], 0), Match[3], ctSHA256)
            else
              LLinksInfo.AddLink(Strings[LLinkIndex], '', csOffline, 0);
          finally
            Free;
          end;
    finally
      Free;
    end;

  ALinksInfo := LLinksInfo;
end;

function TMediafireCom.GetAuthor;
begin
  Result := 'Sebastian Klatte';
end;

function TMediafireCom.GetAuthorURL;
begin
  Result := 'http://www.intelligen2009.com/';
end;

function TMediafireCom.GetDescription;
begin
  Result := GetName + ' file hoster plug-in.';
end;

function TMediafireCom.GetName: WideString;
begin
  Result := 'Mediafire.com';
end;

end.
