library junocloudme;

{$R *.dres}

uses
  uPlugInInterface,
  uPlugInFileHosterClass,
  uJunocloudMe in 'uJunocloudMe.pas';

{$R *.res}

function LoadPlugin(var APlugIn: IFileHosterPlugIn): WordBool; safecall; export;
begin
  try
    APlugIn := TJunocloudMe.Create;
    Result := True;
  except
    Result := False;
  end;
end;

exports LoadPlugin name 'LoadPlugIn';

begin
end.
