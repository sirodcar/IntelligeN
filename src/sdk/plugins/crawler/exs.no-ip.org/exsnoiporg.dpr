library exsnoiporg;

uses
  uPlugInInterface,
  uPlugInCrawlerClass,
  uExsnoipOrg in 'uExsnoipOrg.pas';

{$R *.res}

function LoadPlugin(var APlugIn: ICrawlerPlugIn): WordBool; safecall; export;
begin
  try
    APlugIn := TExsnoipOrg.Create;
    Result := True;
  except
    Result := False;
  end;
end;

exports
  LoadPlugIn name 'LoadPlugIn';

begin
end.
