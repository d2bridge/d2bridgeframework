{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  Copyright (c) 2024 Talis Jonatas Gomes - talisjonatas@me.com
  Intellectual property of computer programs protected by international and
  brazilian (9.609/1998) laws.
  Software licensed under "opensource" license.

  Rules:
  Everone is permitted to copy and distribute verbatim copies of this license
  document, but changing it is not allowed.

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

unit D2Bridge.ConfigNewUnit.View;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 SysUtils, Variants, Classes, IniFiles, Forms, Controls, Graphics,
 Dialogs, ExtCtrls, StdCtrls, Generics.Collections,
{$IFnDEF FPC}
 Winapi.Windows, Winapi.Messages, Vcl.Imaging.pngimage,
 {$IFDEF DESIGNMODE}DesignIntf, ToolsAPI, DesignEditors,{$ENDIF}
{$ELSE}
 LazFileUtils, FileUtil, ProjectIntf, LazIDEIntf, RegExpr,
{$ENDIF}
 D2Bridge.Wizard.Util, D2Bridge.Wizard.Types;

type

  { TD2BridgeConfigNewUnitForm }

  TD2BridgeConfigNewUnitForm = class(TForm)
    Panel_Left: TPanel;
    Panel_Left_Top: TPanel;
    Image1: TImage;
    Panel_Left_Button: TPanel;
    Label18: TLabel;
    Panel1: TPanel;
    Panel_Client: TPanel;
    Panel_Client_Top: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label_Close: TLabel;
    Label_Wizard_Version: TLabel;
    Panel_Client_Button: TPanel;
    Image_Button_Next: TImage;
    Label_Button_Next: TLabel;
    Panel_Client_Tabs: TPanel;
    Label14: TLabel;
    Label3: TLabel;
    Label_ClassType: TLabel;
    Edit_ClassName: TEdit;
    Label4: TLabel;
    Edit_TableName: TEdit;
    Panel_Container: TPanel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Label_CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label_Button_NextClick(Sender: TObject);
    procedure Image_Button_NextClick(Sender: TObject);
    procedure Edit_ClassNameExit(Sender: TObject);
  private
    { Private declarations }
  public
    EnableCreateNewUnit: boolean;
  end;

var
  D2BridgeConfigNewUnitForm: TD2BridgeConfigNewUnitForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}


procedure TD2BridgeConfigNewUnitForm.Edit_ClassNameExit(Sender: TObject);
begin
 if SameText(Label_ClassType.Caption, 'D2Bridge Rest API Crud') then
  exit;

 if Edit_ClassName.Text <> '' then
  if Copy(Edit_ClassName.Text, 1, 1) <> 'T' then
   Edit_ClassName.Text:= 'T'+ Edit_ClassName.Text;
end;

procedure TD2BridgeConfigNewUnitForm.FormCreate(Sender: TObject);
begin
 EnableCreateNewUnit:= false;

 Label_Wizard_Version.Caption:= StringReplace('D2Bridge Wizard Version: '+FloatToStr(D2Bridge.Wizard.Util.D2BridgeWizardVersion), ',', '.', [rfIgnoreCase, rfReplaceAll]);
end;

procedure TD2BridgeConfigNewUnitForm.Image_Button_NextClick(Sender: TObject);
begin
 Label_Button_Next.OnClick(Label_Button_Next);
end;

procedure TD2BridgeConfigNewUnitForm.Label_Button_NextClick(Sender: TObject);
begin
 Edit_ClassNameExit(Edit_ClassName);

 if (Trim(Edit_ClassName.Text) = '') or (UpperCase(Edit_ClassName.Text) = 'T') then
 begin
  showmessage('Enter class name');
  Edit_ClassName.SetFocus;
  exit;
 end;


 if Edit_TableName.Visible and (Trim(Edit_TableName.Text) = '') then
 begin
  showmessage('Enter Table name');
  Edit_TableName.SetFocus;
  exit;
 end;


 EnableCreateNewUnit:= true;

 self.Close;
end;

procedure TD2BridgeConfigNewUnitForm.Label_CloseClick(Sender: TObject);
begin
 self.close;
end;

procedure TD2BridgeConfigNewUnitForm.FormShow(Sender: TObject);
begin
 if not Edit_TableName.Visible then
 begin
  self.Height:= self.Height - 40;
  Label4.Visible:= false;
 end else
  Label4.Visible:= true;
end;

procedure TD2BridgeConfigNewUnitForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
 if not Edit_TableName.Visible then
 begin
  self.Height:= self.Height + 40;
 end;
end;

end.
