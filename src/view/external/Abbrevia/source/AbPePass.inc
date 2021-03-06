(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is TurboPower Abbrevia
 *
 * The Initial Developer of the Original Code is
 * TurboPower Software
 *
 * Portions created by the Initial Developer are Copyright (C) 1997-2002
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** *)

{*********************************************************}
{* ABBREVIA: AbPePass.inc 3.05                           *}
{*********************************************************}
{* ABBREVIA: Password property editor                    *}
{*   See AbPePass.pas for the VCL header                 *}
{*   See AbQPePas.pas for the CLX header                 *}
{*********************************************************}

{$I AbDefine.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF UsingClx}
  QGraphics,
  QForms,
  QControls,
  QStdCtrls,
  QButtons,
  QExtCtrls,
{$ELSE}
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
{$ENDIF}
{$IFDEF LINUX}
  DesignIntf,
  DesignEditors,
{$ELSE}
{$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF VERSION6}
{$ENDIF LINUX}
  SysUtils,
  Classes;

type
  TAbPasswordProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes;
             override;
    procedure Edit;
              override;
  end;

implementation

uses
{$IFDEF UsingClx}
  AbQDgPwd;
{$ELSE}
  AbDlgPwd;
{$ENDIF}

function TAbPasswordProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TAbPasswordProperty.Edit;
var
  D : TPasswordDlg;
begin
  D := TPasswordDlg.Create( Application );
  try
    D.Edit1.Text := Value;
    D.ShowModal;
    if D.ModalResult = mrOK then
      Value := D.Edit1.Text;
  finally
    D.Free;
  end;
end;

end.
