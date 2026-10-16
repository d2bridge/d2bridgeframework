unit UnitCamera;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
 Classes, SysUtils, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,  
 D2Bridge.Forms;

type

 { TFormCamera }

 TFormCamera = class(TD2BridgeForm)
  Button1: TButton;
  Button2: TButton;
  Button3: TButton;
  Button4: TButton;
  Button5: TButton;
  Button6: TButton;
  Button7: TButton;
  Button8: TButton;
  ComboBox1: TComboBox;
  Image1: TImage;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure Button4Click(Sender: TObject);
  procedure Button5Click(Sender: TObject);
  procedure Button6Click(Sender: TObject);
  procedure Button7Click(Sender: TObject);
  procedure Button8Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  procedure UpdateCameraList(Sender: TObject);
 public
  { Public declarations }
 protected
  procedure Upload(AFiles: TStrings; Sender: TObject); override;
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
 end;

function FormCamera: TFormCamera;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormCamera: TFormCamera;
begin
 result:= (TFormCamera.GetInstance as TFormCamera);
end;

procedure TFormCamera.FormCreate(Sender: TObject);
begin
 Image1.Camera.OnChangeDevices:= UpdateCameraList;
end;

procedure TFormCamera.Button8Click(Sender: TObject);
begin
 if ComboBox1.Items.Count > 0 then
 begin
  Image1.Camera.CurrentDevice:= Image1.Camera.Devices.ItemFromIndex(ComboBox1.ItemIndex);

  //ShowMessage('new camera "' + Image1.Camera.CurrentDevice.Name + '" selected');

  //Modify camera now
  if Image1.Camera.Started then
  begin
   Image1.Camera.Stop;
   Image1.Camera.Start;
  end;
 end;
end;

procedure TFormCamera.Button7Click(Sender: TObject);
begin
 Image1.Camera.RequestPermission;
end;

procedure TFormCamera.Button1Click(Sender: TObject);
begin
 if not Image1.Camera.Allowed then
  Image1.Camera.RequestPermission;

 Image1.Camera.Start;
end;

procedure TFormCamera.Button2Click(Sender: TObject);
begin
 Image1.Camera.Stop;
end;

procedure TFormCamera.Button3Click(Sender: TObject);
begin
 Image1.Camera.TakePicture;
end;

procedure TFormCamera.Button4Click(Sender: TObject);
begin
 if not Image1.Camera.Allowed then
  Image1.Camera.RequestPermission;

 Image1.Camera.RecordVideo;

end;

procedure TFormCamera.Button5Click(Sender: TObject);
begin
 Image1.Camera.SaveVideo;
end;

procedure TFormCamera.Button6Click(Sender: TObject);
begin
 Image1.Camera.CancelVideo;
end;

//Your can use also update camera list in onActivate event
procedure TFormCamera.UpdateCameraList(Sender: TObject);
var
 I: Integer;
begin
 ComboBox1.Items.Clear;

 if Image1.Camera.Devices.Count > 0 then
 begin
  for I := 0 to Pred(Image1.Camera.Devices.Count) do
   ComboBox1.Items.Add(Image1.Camera.Devices.Items[I].Name);

  ComboBox1.ItemIndex:= Image1.Camera.CurrentDeviceIndex;
 end;
end;

procedure TFormCamera.Upload(AFiles: TStrings; Sender: TObject);
begin
 ShowMessage('New file received on '+ ExtractFileName(AFiles[0]), true, true);

 //Example identify sender
 {
 if Sender is TPrismControl then
  if (Sender as TPrismControl).VCLComponent = Image1 then
  begin
   ///
  end;
 }
end;

procedure TFormCamera.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  with Row(CSSClass.Col.Align.center).Items.Add do
   Col6.Add.Camera(Image1);

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

   ColAuto.Items.Add.VCLObj(Button3, CSSClass.Button.camera);

   with ColAuto.Items.Add do
   begin
    VCLObj(Button4, CSSClass.Button.video);
    VCLObj(Button5, CSSClass.Button.videofile);
    VCLObj(Button6, CSSClass.Button.videoNo);
   end;
  end;
 end;
end;

procedure TFormCamera.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormCamera.RenderD2Bridge(const PrismControl: TPrismControl;
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
