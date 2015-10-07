library sharenownet;

{$R *.dres}

uses
  uPlugInInterface,
  uPlugInFileHosterClass,
  uShareNowNet in 'uShareNowNet.pas';

{$R *.res}

function LoadPlugin(var APlugIn: IFileHosterPlugIn): WordBool; safecall; export;
begin
  try
    APlugIn := TShareNowNet.Create;
    Result := True;
  except
    Result := False;
  end;
end;

exports LoadPlugin name 'LoadPlugIn';

begin
end.
