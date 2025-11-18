unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, D2Bridge.Forms;

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelHTMLElement2: TLabel;
    Memo_ListGroup: TMemo;
    Button_Step: TButton;
    LabelHTMLElement_WithCallBack: TLabel;
    Label_ResultCallBack: TLabel;
    procedure Button_StepClick(Sender: TObject);
  private
    var
     ValueStep: integer;
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
   procedure CallBack(const CallBackName: string; EventParams: TStrings); override;
  end;

Function Form1: TForm1;

implementation

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Button_StepClick(Sender: TObject);
begin
 Inc(ValueStep);

 LabelHTMLElement2.Caption:=
  '<div class="progress mt-2">' +
  ' <div class="progress-bar" role="progressbar" style="width: ' + IntToStr(ValueStep) + '%;" aria-valuenow="' + IntToStr(ValueStep) + '" aria-valuemin="0" aria-valuemax="100">' + IntToStr(ValueStep) + '%</div>' +
 '</div>';
end;

procedure TForm1.CallBack(const CallBackName: string; EventParams: TStrings);
begin
 inherited;

 if SameText(CallBackName, 'GetValueTest') then
 begin
  Label_ResultCallBack.Caption:= 'Result CallBack = ' + EventParams.Strings[0];
 end;

end;

procedure TForm1.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Application';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
  VCLObj(Label1, CSSClass.Text.Size.fs2 + ' ' + CSSClass.Text.Style.bold);
  VCLObj(Label2, CSSClass.Text.Size.fs3);
  VCLObj(Label3, CSSClass.Text.Size.fs4);

  //Example1 - HTML Element with Text
  //HTMLElementText is a Name of Control
  with PanelGroup('HTML Element 1 - Range').Items.Add do
   HTMLElement('<input type="range" class="form-range" min="0" max="5" step="0.5" id="customRange3">', 'HTMLElementText');

  //Example2 - HTML Element with TLabel
  //When no name is mentioned, it receives the name of the Component (TLabel)
  with PanelGroup('HTML Element 2 - Progress Bar').Items.Add do
  begin
   VCLObj(Button_Step);
   HTMLElement(LabelHTMLElement2);
  end;

  //Example3 - HTML Element with TLabel and CallBack Result
  //When no name is mentioned, it receives the name of the Component (TLabel)
  with PanelGroup('HTML Element 3 - Progress Bar with CallBack').Items.Add do
  begin
   HTMLElement(LabelHTMLElement_WithCallBack);
   VCLObj(Label_ResultCallBack, CSSClass.Text.Size.fs3);
  end;

  //Example4 - HTML Element with TMemo
  //Name is MyListGroup
  with PanelGroup('HTML Element 4 - Memo').Items.Add do
   HTMLElement(Memo_ListGroup, 'MyListGroup');
 end;



end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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
