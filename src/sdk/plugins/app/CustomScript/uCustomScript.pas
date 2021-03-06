﻿unit uCustomScript;

interface

uses
  // Delphi
  Windows, SysUtils, Classes, Variants,
  // RegEx
  RegExpr,
  // LkJSON
  uLkJSON,
  // MultiEvent
  Generics.MultiEvents.NotifyHandler,
  // HTTPManager
  uHTTPInterface, uHTTPClasses,
  // Common
  uBaseConst, uBaseInterface, uAppConst, uAppInterface,
  // Plugin system
  uPlugInAppClass, uPlugInEvent, uPlugInHTTPClasses,
  // Utils
  uPathUtils, uStringUtils, uSystemUtils, uURLUtils,
  // CustomScript
  uCustomScriptEngine, uCustomScriptSettings;

type
  TCustomScript = class(TAppPlugIn)
  private
    FAppController: IAppController;

    FCustomScriptSettings: TCustomScriptSettings;

    FExecuteMenuItem, FExecuteAllMenuItem, FSettingsMenuItem: IMenuItem;
    FExecuteNotifyEventHandler, FExecuteAllNotifyEventHandler, FSettingsNotifyEventHandler: TINotifyEventHandler;
    procedure OnExecute(const Sender: IUnknown);
    procedure OnExecuteAll(const Sender: IUnknown);
    procedure OnSettings(const Sender: IUnknown);
  public
    function GetAuthor: WideString; override;
    function GetAuthorURL: WideString; override;
    function GetDescription: WideString; override;
    function GetName: WideString; override;

    function Start(const AAppController: IAppController): WordBool; override;
    function Stop: WordBool; override;
  end;

implementation

uses
  uCustomScriptSettingsForm;

{ TCustomScript }

procedure TCustomScript.OnExecute(const Sender: IInterface);
begin
  with FAppController.PageController do
  begin
    if (TabSheetCount > 0) then
    begin
      with TCustomScriptEngine.Create do
        try
          Execute(ActiveTabSheetController, FCustomScriptSettings);
        finally
          Free;
        end;
    end;
  end;
end;

procedure TCustomScript.OnExecuteAll(const Sender: IInterface);
var
  I: Integer;
begin
  with FAppController.PageController do
  begin
    for I := 0 to TabSheetCount - 1 do
    begin
      with TCustomScriptEngine.Create do
        try
          Execute(TabSheetController[I], FCustomScriptSettings);
        finally
          Free;
        end;
    end;
  end;
end;

procedure TCustomScript.OnSettings(const Sender: IInterface);
begin
  if not Assigned(fCustomScriptSettingsForm) then
    fCustomScriptSettingsForm := TfCustomScriptSettingsForm.Create(nil);

  fCustomScriptSettingsForm.LoadSettings(FCustomScriptSettings);
  fCustomScriptSettingsForm.Show;
end;

function TCustomScript.GetAuthor;
begin
  Result := 'Sebastian Klatte';
end;

function TCustomScript.GetAuthorURL;
begin
  Result := 'http://www.intelligen2009.com/';
end;

function TCustomScript.GetDescription;
begin
  Result := GetName + ' app plug-in.';
end;

function TCustomScript.GetName: WideString;
begin
  Result := 'CustomScript';
end;

function TCustomScript.Start(const AAppController: IAppController): WordBool;
begin
  FAppController := AAppController;

  FCustomScriptSettings := TCustomScriptSettings.Create(ExtractFilePath(GetModulePath) + ChangeFileExt(ExtractFileName(GetModulePath), '.json'));

  FExecuteNotifyEventHandler := TINotifyEventHandler.Create(OnExecute);
  with FAppController.MainMenu.GetMenuItems.GetItem(3) do
    FExecuteMenuItem := InsertMenuItem(GetMenuItems.GetCount, 'CustomScript', 'Execute the CustomScript plugin', 0, -1, 0, FExecuteNotifyEventHandler);

  FExecuteAllNotifyEventHandler := TINotifyEventHandler.Create(OnExecuteAll);
  with FAppController.MainMenu.GetMenuItems.GetItem(4) do
    FExecuteAllMenuItem := InsertMenuItem(GetMenuItems.GetCount, 'AutoCustomScript', 'Execute the CustomScript plugin for all tabs', 0, -1, 0, FExecuteAllNotifyEventHandler);

  FSettingsNotifyEventHandler := TINotifyEventHandler.Create(OnSettings);
  with FAppController.MainMenu.GetMenuItems.GetItem(3) do
    FSettingsMenuItem := InsertMenuItem(GetMenuItems.GetCount, 'CustomScript settings', 'Configurate the CustomScript plugin', 0, -1, 0, FSettingsNotifyEventHandler);

  Result := True;
end;

function TCustomScript.Stop: WordBool;
begin
  if Assigned(fCustomScriptSettingsForm) then
    fCustomScriptSettingsForm.Free;

  FAppController.MainMenu.GetMenuItems.GetItem(3).GetMenuItems.RemoveItem(FSettingsMenuItem);
  FSettingsNotifyEventHandler := nil;

  FAppController.MainMenu.GetMenuItems.GetItem(4).GetMenuItems.RemoveItem(FExecuteAllMenuItem);
  FExecuteAllNotifyEventHandler := nil;

  FAppController.MainMenu.GetMenuItems.GetItem(3).GetMenuItems.RemoveItem(FExecuteMenuItem);
  FExecuteNotifyEventHandler := nil;

  FCustomScriptSettings.Free;

  Result := True;
end;

end.
