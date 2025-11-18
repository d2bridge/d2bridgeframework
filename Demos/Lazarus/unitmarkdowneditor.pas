unit UnitMarkDownEditor;

{ Copyright 2025 / 2026 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
 Classes, SysUtils, BufDataset, DB, Controls, Graphics, Dialogs, StdCtrls, DBGrids, Menus,  
 D2Bridge.Forms;

type

 { TFormMarkDownEditor }

 TFormMarkDownEditor = class(TD2BridgeForm)
  BufDataset1: TBufDataset;
  BufDataset1Text: TStringField;
  BufDataset1Title: TStringField;
  Button1: TButton;
  Button2: TButton;
  Button3: TButton;
  DataSource1: TDataSource;
  DBGrid1: TDBGrid;
  Memo1: TMemo;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
  procedure Button3Click(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private
  procedure PopuleData;
 public
  { Public declarations }
 protected
  procedure Upload(AFiles: TStrings; Sender: TObject); override;
  procedure ExportD2Bridge; override;
  procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
  procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
 end;

function FormMarkDownEditor: TFormMarkDownEditor;

implementation

uses
 LazarusWebApp, D2BridgeFormTemplate;

{$R *.lfm}

function FormMarkDownEditor: TFormMarkDownEditor;
begin
 result:= (TFormMarkDownEditor.GetInstance as TFormMarkDownEditor);
end;

procedure TFormMarkDownEditor.Button1Click(Sender: TObject);
begin
 Memo1.Enabled:= not Memo1.Enabled;
end;

procedure TFormMarkDownEditor.Button2Click(Sender: TObject);
begin
 Memo1.ReadOnly:= not Memo1.ReadOnly;
end;

procedure TFormMarkDownEditor.Button3Click(Sender: TObject);
begin
 if BufDataset1.State in [dsEdit] then
  BufDataset1.Post
 else
  BufDataset1.Edit;
end;

procedure TFormMarkDownEditor.FormCreate(Sender: TObject);
begin
 PopuleData;
end;

procedure TFormMarkDownEditor.PopuleData;
begin
 BufDataset1.Close;
 BufDataset1.CreateDataSet;

 BufDataset1.AppendRecord(['Example 1',
        '# D2Bridge Markdown Editor Documentation                                          ' + sLineBreak +
        '                                                                                  ' + sLineBreak +
        'Welcome to the official documentation for the **D2Bridge Markdown Editor**.       ' + sLineBreak +
        '                                                                                  ' + sLineBreak +
        '## Installation                                                                   ' + sLineBreak +
        '1. **Download D2Bridge** from the official website.                               ' + sLineBreak +
        '2. **Use InstallD2BridgeWizard.exe to install Wizard in your Delphi/Lazarus IDE** ' + sLineBreak +
        '3. **In your IDE use Menu D2Bridge Wizard**                                       '
        ]);

 BufDataset1.AppendRecord(['Example 2',
        '# D2Bridge Markdown Editor Documentation' + sLineBreak +
        '                                        ' + sLineBreak +
        '                                        ' + sLineBreak +
        '| Column 1 | Column 2 | Column 3 |      ' + sLineBreak +
        '| -------- | -------- | -------- |      ' + sLineBreak +
        '| Text     | Text     | Text     |      '
        ]);

end;

procedure TFormMarkDownEditor.Upload(AFiles: TStrings; Sender: TObject);
begin
 //Handle the attachment here

 //Ex:
 // AFiles[0]:= 'NewLocation\NameFile.jpg';
end;

procedure TFormMarkDownEditor.ExportD2Bridge;
begin
 inherited;

 Title:= 'My D2Bridge Form';

 TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 with D2Bridge.Items.add do
 begin
  with Row.Items.Add do
   with Col.Add.Card('Markdown Editor').Items.Add do
   begin
    with Row.Items.Add do
    begin
     ColAuto.Add.VCLObj(Button1);
     ColAuto.Add.VCLObj(Button2);
    end;

    with Row.Items.Add do
     Col.Add.MarkdownEditor(Memo1);
   end;

  //Markdown with TMemo
  with Row.Items.Add do
   with Col.Add.Card('Markdown Editor with Database').Items.Add do
   begin
    with Row.Items.Add do
     ColAuto.Add.VCLObj(Button3);

    with Row.Items.Add do
    begin
     Col4.Add.VCLObj(DBGrid1);
     with Col.Add.MarkdownEditor(DataSource1, 'Text') do
     begin
      //Personalize your Markdown
      ShowButtonStrikethrough:= false;
      ShowButtonUpload:= false;
      //Show......
     end;
    end;
   end;
 end;

end;

procedure TFormMarkDownEditor.InitControlsD2Bridge(const PrismControl: TPrismControl);
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

procedure TFormMarkDownEditor.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
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
