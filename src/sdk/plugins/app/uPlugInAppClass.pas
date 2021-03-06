{ ********************************************************
  *                            IntelligeN PLUGIN SYSTEM  *
  *  PlugIn application class                            *
  *  Version 2.5.0.0                                     *
  *  Copyright (c) 2016 Sebastian Klatte                 *
  *                                                      *
  ******************************************************** }
unit uPlugInAppClass;

interface

uses
  // Common
  uAppInterface,
  // Plugin
  uPlugInConst, uPlugInInterfaceAdv, uPlugInClass;

type
  TAppPlugIn = class(TPlugIn, IAppPlugIn)
  public
    function GetType: TPlugInType; override; safecall;

    function Start(const AAppController: IAppController): WordBool; virtual; safecall; abstract;
    function Stop: WordBool; virtual; safecall; abstract;
  end;

implementation

{ TAppPlugIn }

function TAppPlugIn.GetType: TPlugInType;
begin
  Result := ptApp;
end;

end.
