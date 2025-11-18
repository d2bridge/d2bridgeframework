unit unitQRCodeReader;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,  
 D2Bridge.Forms;

type

 { TFormQRCodeReader }

 TFormQRCodeReader = class(TD2BridgeForm)
  Button1: TButton;
  Button2: TButton;
  Button7: TButton;
  Button8: TButton;
  ComboBox1: TComboBox;
  Image1: TImage;
  Memo1: TMemo;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button7Click(Sender: TObject);
  procedure Button8Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  procedure UpdateCameraList(Sender: TObject);
  procedure OnQRCodeReader(ACode: string);
 public
  { Public declarations }
 protected
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; 
   var HTMLControl: string); override;
 end;

function FormQRCodeReader: TFormQRCodeReader;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormQRCodeReader: TFormQRCodeReader;
begin
 result:= (TFormQRCodeReader.GetInstance as TFormQRCodeReader);
end;

procedure TFormQRCodeReader.FormCreate(Sender: TObject);
begin
 Image1.QRCodeReader.OnChangeDevices:= UpdateCameraList;
end;

procedure TFormQRCodeReader.Button7Click(Sender: TObject);
begin
 Image1.QRCodeReader.RequestPermission;
end;

procedure TFormQRCodeReader.Button8Click(Sender: TObject);
begin
 if ComboBox1.Items.Count > 0 then
 begin
  Image1.QRCodeReader.CurrentDevice:= Image1.QRCodeReader.Devices.ItemFromIndex(ComboBox1.ItemIndex);

  //ShowMessage('new camera "' + Image1.QRCodeReader.CurrentDevice.Name + '" selected');

  //Modify QRCodeReader now
  if Image1.QRCodeReader.Started then
  begin
   Image1.QRCodeReader.Stop;
   Image1.QRCodeReader.Start;
  end;
 end;
end;

procedure TFormQRCodeReader.Button1Click(Sender: TObject);
begin
 Memo1.Text:= '';

 if not Image1.QRCodeReader.Allowed then
  Image1.QRCodeReader.RequestPermission;

 Image1.QRCodeReader.Start;

end;

procedure TFormQRCodeReader.Button2Click(Sender: TObject);
begin
 Image1.QRCodeReader.Stop;
end;

procedure TFormQRCodeReader.UpdateCameraList(Sender: TObject);
var
 I: Integer;
begin
 ComboBox1.Items.Clear;

 if Image1.QRCodeReader.Devices.Count > 0 then
 begin
  for I := 0 to Pred(Image1.QRCodeReader.Devices.Count) do
   ComboBox1.Items.Add(Image1.QRCodeReader.Devices.Items[I].Name);

  ComboBox1.ItemIndex:= Image1.QRCodeReader.CurrentDeviceIndex;
 end;
end;

procedure TFormQRCodeReader.OnQRCodeReader(ACode: string);
begin
 Memo1.Text:= ACode;
end;

procedure TFormQRCodeReader.ExportD2Bridge;
begin
 inherited;

 Title:= 'QRCode/BarCode Reader';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   Col4.Add.QRCodeReader(Image1, Memo1);
   //*****Or use Event
   //Col4.Add.QRCodeReader(Image1, OnQRCodeReader)

   {
    *** Options Example ***

    With Col4.Add.QRCodeReader(Image1, OnQRCodeReader) do
    begin
     //--> Shaders code limit
     BorderShaders:= true/false;

     //--> Scan not stop on Read
     ContinuousScan:= true/false;

     //--> Send ENTER on Read the code
     PressReturnKey:= true/false;

     //--> Enable All Code Format
     EnableAllCodesFormat;

     //--> Disable All Code Format
     DisableAllCodesFormat;

     //--> Enable / Disable Code Types
     PressReturnKey:= true/false;
     TextVCLComponent:= true/false;
     EnableQRCODE:= true/false;
     EnableAZTEC:= true/false;
     EnableCODABAR:= true/false;
     EnableCODE39:= true/false;
     EnableCODE93:= true/false;
     EnableCODE128:= true/false;
     EnableDATAMATRIX:= true/false;
     EnableMAXICODE:= true/false;
     EnableITF:= true/false;
     EnableEAN13:= true/false;
     EnableEAN8:= true/false;
     EnablePDF417:= true/false;
     EnableRSS14:= true/false;
     EnableRSSEXPANDED:= true/false;
     EnableUPCA:= true/false;
     EnableUPCE:= true/false;
     EnableUPCEANEXTENSION:= true/false;
    end;
   }
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   with ColAuto.Items.Add do
   begin
    VCLObj(ComboBox1);
    VCLObj(Button8, CSSClass.Button.select);
   end;
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
  begin
   with ColAuto.Items.Add do
   begin
    VCLObj(Button7, CSSClass.Button.userSecurity);
    VCLObj(Button1, CSSClass.Button.start);
    VCLObj(Button2, CSSClass.Button.stop);
   end;
  end;

  with Row(CSSClass.Col.Align.center).Items.Add do
   FormGroup('Last Code Read', CSSClass.Col.colsize8).AddVCLObj(Memo1);
 end;

end;

procedure TFormQRCodeReader.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;

 //Change Init Property of Prism Controls
 {
 if PrismControl.VCLComponent = Edit1 then
  PrismControl.AsEdit.DataType:= TPrismFieldType.PrismFieldTypeInteger;

 if PrismControl.IsDBGrid then
 begin
  PrismControl.AsDBGrid.RecordsPerPage:= 10;
  PrismControl.AsDBGrid.MaxRecords:= 2000;
 end;
 }
end;

procedure TFormQRCodeReader.RenderD2Bridge(const PrismControl: TPrismControl;
 var HTMLControl: string);
begin
 inherited;

 //Intercept HTML
 {
 if PrismControl.VCLComponent = Edit1 then
 begin
  HTMLControl:= '</>';
 end;
 }
end;

end.
