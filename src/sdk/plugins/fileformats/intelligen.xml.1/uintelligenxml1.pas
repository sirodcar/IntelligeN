unit uintelligenxml1;

interface

uses
  // Delphi
  SysUtils, Variants, XMLDoc, XMLIntf, ActiveX, DECFmt,
  // Common
  uBaseConst, uAppConst, uAppInterface,
  // Plugin system
  uPlugInFileFormatClass;

type
  TInArray = class
  public
    class function str(str: string; AArray: array of string): Integer;
  end;

  Tintelligenxml1 = class(TFileFormatPlugIn)
  private const
    TStringComponentIDEx: array [0 .. 20] of string = ('eReleaseName', '', 'ePostTitle', '', 'cobPicture', 'eTrailer', 'cobSample', 'cobNotes', 'ePassword', 'cobBitrate', 'cobEncoder', 'cobQuality', 'cobAudioSource', 'cobGenre', 'cobLanguage', '',
      'cobVideoFormat', 'cobVideoSource', 'cobSystem', 'mNfo', 'mDescription');
    eDownloadLink = 'eDownloadLink';
  public
    function GetName: WideString; override; safecall;
    function GetFileFormatName: WideString; override; safecall;
    function CanSaveControls: WordBool; override; safecall;
    procedure SaveControls(AFileName, ATemplateFileName: WideString; const ATabSheetController: ITabSheetController); override; safecall;
    function CanLoadControls: WordBool; override; safecall;
    function LoadControls(AFileName, ATemplateDirectory: WideString; const APageController: IPageController): Integer; override; safecall;
  end;

implementation

class function TInArray.str(str: string; AArray: array of string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := low(AArray) to high(AArray) do
    if (AArray[I] = str) then
    begin
      Result := I;
      exit;
    end;
end;

function Tintelligenxml1.GetName;
begin
  Result := 'intelligen.xml.1';
end;

function Tintelligenxml1.GetFileFormatName;
begin
  Result := 'IntelligeN %s (*.xml)|*.xml|';
end;

function Tintelligenxml1.CanSaveControls;
begin
  Result := True;
end;

procedure Tintelligenxml1.SaveControls;
var
  XMLDoc: IXMLDocument;
  I, X: Integer;
begin
  CoInitialize(nil);
  try
    XMLDoc := NewXMLDocument;
    try
      with XMLDoc do
      begin
        Options := Options + [doNodeAutoIndent];
        DocumentElement := CreateElement('xml', '');
        Active := True;
        Encoding := 'utf-8';

        ChildNodes.Insert(1, CreateNode('THIS FILE IS AUTOMATICALLY GENERATED DO NOT EDIT THIS', ntComment, ''));
        ChildNodes.Insert(2, CreateNode('POWERED BY INTELLIGEN', ntComment, ''));
      end;
      with XMLDoc.DocumentElement do
      begin
        with AddChild(ExtractFileName(ChangeFileExt(ATemplateFileName, ''))) do
        begin
          with ATabSheetController.ControlController do
          begin
            case TypeID of
              cAudio:
                with AddChild('cobAudioType') do
                begin
                  if Assigned(FindControl(cGenre)) then
                    if (FindControl(cGenre).Value = 'Hip-Hop') or (FindControl(cGenre).Value = 'R&B') then
                      NodeValue := 'Black - Hip Hop - RNB'
                    else if (FindControl(cGenre).Value = 'Dance') or (FindControl(cGenre).Value = 'Electronic') or (FindControl(cGenre).Value = 'House') or (FindControl(cGenre).Value = 'Pop') or (FindControl(cGenre).Value = 'Trance') then
                      NodeValue := 'Pop - Techno - Electro - House'
                    else if (FindControl(cGenre).Value = 'Metal') or (FindControl(cGenre).Value = 'Rock') then
                      NodeValue := 'Rock - Metal'
                end;
              cMovie:
                with AddChild('cobMovieType') do
                begin
                  if Assigned(FindControl(cVideoCodec)) then
                    if (FindControl(cVideoCodec).Value = 'MPEG-4 DivX / Xvid') then
                      NodeValue := 'Xvid - DivX'
                    else if FindControl(cVideoCodec).Value = 'MPEG-2' then
                      NodeValue := 'DVD'
                    else if FindControl(cVideoCodec).Value = 'MPEG-4 H.264 / AVC' then
                      NodeValue := 'HD2DVD'
                    else if FindControl(cVideoCodec).Value = 'VC-1' then
                      NodeValue := 'HD:WMV'
                end;
              cWii:
                with AddChild('cobWiiType') do
                  NodeValue := 'Wii';
              cXbox360:
                with AddChild('cobXbox360Type') do
                  NodeValue := 'Xbox 360';
              cXXX:
                with AddChild('cobXXXType') do
                begin
                  if Assigned(FindControl(cVideoCodec)) then
                    if FindControl(cVideoCodec).Value = 'MPEG-2' then
                      NodeValue := 'DVD'
                    else
                      NodeValue := 'Xvid - DivX';
                end;
            end;

            for I := 0 to ControlCount - 1 do
              if not(TStringComponentIDEx[Integer(Control[I].ControlID)] = '') then
                with AddChild(TStringComponentIDEx[Integer(Control[I].ControlID)]) do
                  NodeValue := Control[I].Value;
          end;
          with ATabSheetController.MirrorController do
            for I := 0 to MirrorCount - 1 do
              for X := 0 to Mirror[I].CrypterCount - 1 do
                if Mirror[I].Crypter[X].name = 'Linksave.in' then
                begin
                  with AddChild('cobDownloadHostername' + IntToStr(I)) do
                    NodeValue := ChangeFileExt(Mirror[I].Crypter[X].Hoster, '');
                  with AddChild('eDownloadFilename' + IntToStr(I)) do
                    NodeValue := Mirror[I].Directlink[X].FileName;
                  with AddChild(eDownloadLink + IntToStr(I)) do
                    NodeValue := Mirror[I].Crypter[X].Value;
                end;
        end;
      end;

      XMLDoc.SaveToFile(AFileName);
    finally
      XMLDoc := nil;
    end;
  finally
    CoUninitialize;
  end;
end;

function Tintelligenxml1.CanLoadControls;
begin
  Result := True;
end;

function Tintelligenxml1.LoadControls;
var
  XMLDoc: IXMLDocument;
  I, J, K, CompPos: Integer;
  TemplateType: TTypeID;
  Base64, _CrypterExists: Boolean;
  _value: string;
begin
  Base64 := False;

  Result := -1;
  try
    CoInitialize(nil);
    try
      XMLDoc := NewXMLDocument;
      try
        with XMLDoc do
        begin
          LoadFromFile(AFileName);
          Active := True;
        end;

        with XMLDoc.DocumentElement do
          if HasChildNodes then
          begin

            for I := 0 to ChildNodes.Count - 1 do
              with ChildNodes.Nodes[I] do
              begin
                TemplateType := StringToTypeID(NodeName);

                if HasAttribute('BASE64') then
                  Base64 := Attributes['BASE64'] = VarToStr('1');

                with APageController.TabSheetController[APageController.Add(ATemplateDirectory + NodeName + '.xml', TemplateType, True)] do
                begin
                  for J := 0 to ChildNodes.Count - 1 do
                    with ChildNodes.Nodes[J] do
                    begin
                      CompPos := TInArray.str(NodeName, TStringComponentIDEx);

                      if (CompPos <> -1) then
                      begin
                        _value := VarToStr(NodeValue);

                        if Base64 then
                          _value := TFormat_MIME64.Decode(_value);

                        ControlController.FindControl(TControlID(CompPos)).Value := _value;
                      end
                      else if copy(NodeName, 0, length(eDownloadLink)) = eDownloadLink then
                        with MirrorController.Mirror[MirrorController.Add] do
                        begin
                          if ForceAddCrypter then
                          begin
                            _CrypterExists := False;
                            for K := 0 to CrypterCount - 1 do
                              if (Crypter[K].name = 'Linksave.in') then
                              begin
                                _CrypterExists := True;
                                break;
                              end;
                            if not _CrypterExists then
                              AddCrypter('Linksave.in');
                          end;
                          for K := 0 to CrypterCount - 1 do
                            if Crypter[K].name = 'Linksave.in' then
                            begin
                              _value := VarToStr(NodeValue);

                              if Base64 then
                                _value := TFormat_MIME64.Decode(_value);

                              Crypter[K].Value := _value;
                              Crypter[K].CheckFolder;
                            end;
                        end;
                    end;
                  ResetDataChanged(AFileName, GetName);
                  Result := TabSheetIndex;
                end;

                APageController.CallControlAligner;
              end;
          end
          else
          begin
            raise Exception.Create('');
          end;
      finally
        XMLDoc := nil;
      end;
    finally
      CoUninitialize;
    end;
  except
    Result := -1;
  end;
end;

end.
