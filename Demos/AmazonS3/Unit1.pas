unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Menus, D2Bridge.Forms, Vcl.ExtCtrls, Vcl.Imaging.jpeg; //Declare D2Bridge.Forms always in the last unit

type
  TForm1 = class(TD2BridgeForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Module11: TMenuItem;
    AppModule21: TMenuItem;
    Modules1: TMenuItem;
    Module12: TMenuItem;
    Module21: TMenuItem;
    SubModules1: TMenuItem;
    SubModule11: TMenuItem;
    SubModule21: TMenuItem;
    SubModule31: TMenuItem;
    CoreModules1: TMenuItem;
    CoreModule11: TMenuItem;
    CoreModule21: TMenuItem;
    btnUploadFile: TButton;
    MemoLog: TMemo;
    btnSendAnyFilePDF: TButton;
    btnSendAnyFilePNG: TButton;
    btnSendAnyFileAudio: TButton;
    btnSendAnyFileJPG: TButton;
    edtAccountName: TEdit;
    edtAccountKey: TEdit;
    edtStorageEndPoint: TEdit;
    edtBucket: TEdit;
    Image1: TImage;
    PictureProfile: TImage;
    procedure Module11Click(Sender: TObject);
    procedure btnUploadFileClick(Sender: TObject);
    procedure btnSendAnyFilePDFClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  var
    ExecutablePath :String;
    URL_PictureProfile:string;

    procedure Upload(AFiles: TStrings; Sender: TObject);
  public

  protected
   procedure ExportD2Bridge; override;
   procedure InitControlsD2Bridge(const PrismControl: TPrismControl); override;
   procedure RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string); override;
  end;

Function Form1: TForm1;

implementation

Uses
   DemoAmazonS3WebApp;

Function Form1: TForm1;
begin
 Result:= TForm1(TForm1.GetInstance);
end;

{$R *.dfm}

{ TForm1 }

procedure TForm1.Upload(AFiles: TStrings; Sender: TObject);
var
    i:integer;
begin

     with D2Bridge.API.Storage.AmazonS3 do
     begin
         for i:=0 to AFiles.Count-1 do
         begin
             FileStoragePath:='MyPath_Test/';
             FileName:=AFiles[i];
             if UploadFile then
             begin
                MemoLog.Lines.Add('File sent successfully');
                MemoLog.Lines.Add('URL File '+ URL_File);
             end
             else
             begin
                MemoLog.Text:='Error: '+Error;
             end;
         end;
     end;
end;

procedure TForm1.btnSendAnyFilePDFClick(Sender: TObject);
begin
         MemoLog.Clear;
         with D2Bridge.API.Storage.AmazonS3 do
         begin
              FileStoragePath:='MyPath_Test/';
              if Sender is TButton then
              begin
                       case (Sender as TButton).Tag of
                            0: FileName :=ExecutablePath+'\Arquivos\D2Shop.pdf';
                            1: FileName:=ExecutablePath+'\Arquivos\D2Shop.png';
                            2: FileName:=ExecutablePath+'\Arquivos\D2Bridge.jpg';
                            3: FileName:=ExecutablePath+'\Arquivos\audio.wav';
                            4: FileName:=ExecutablePath+'\Arquivos\Stiker.webp';
                       end;
              end;

              if UploadFile then
              begin
                 MemoLog.Lines.Add(URL_File);
                 case (Sender as TButton).Tag of
                  1,2:
                  begin
                      URL_PictureProfile:= URL_File;
                      D2Bridge.UpdateD2BridgeControl(PictureProfile);
                  end;
                 end;

              end
              else
              begin
                 MemoLog.Lines.Add('Error: '+Error);
              end;
         end;


end;

procedure TForm1.btnUploadFileClick(Sender: TObject);
begin
   MemoLog.Clear;
   with D2Bridge.API.Storage.AmazonS3 do
   begin
        FileStoragePath:='empresa_x/minha_pasta/';
        FileName       :=ExecutablePath+'\Arquivos\D2Shop.png';

        if UploadFile then
        begin
           MemoLog.Lines.Add(URL_File);
        end
        else
        begin
           MemoLog.Lines.Add('Error: '+Error);
        end;
   end;
end;

procedure TForm1.ExportD2Bridge;
begin
 inherited;

  OnUpload:= Upload;

 Title:= 'My D2Bridge Web Application';
 SubTitle:= 'My WebApp';

 //TemplateClassForm:= TD2BridgeFormTemplate;
 D2Bridge.FrameworkExportType.TemplateMasterHTMLFile:= '';
 D2Bridge.FrameworkExportType.TemplatePageHTMLFile := '';

 //Export yours Controls
 with D2Bridge.Items.add do
 begin
      with Card do
      begin
          ColSize:= CSSClass.Col.colsize12;

          Header.Text:= 'Amazon S3 : Account';
          with Items.Add do
          begin
             with Row.Items.Add do
             begin

              with HTMLDiv(CSSClass.Col.colsize3).Items.Add do
              begin
                       FormGroup('', CSSClass.Col.col,'',false,'','',' width:350px;').AddVCLObj(Image1);
              end;

              with HTMLDiv(CSSClass.Col.colsize9).Items.Add do
              begin
                with Row.Items.Add do
                begin
                    FormGroup('AccountName', CSSClass.Col.colsize4).AddVCLObj(edtAccountName);
                    FormGroup('AccountKey', CSSClass.Col.colsize6).AddVCLObj(edtAccountKey);
                    FormGroup('Bucket', CSSClass.Col.colsize2).AddVCLObj(edtBucket);
                    FormGroup('StorageEndPoint', CSSClass.Col.col).AddVCLObj(edtStorageEndPoint);
                end;
              end;

             end;
          end;
      end;
      with Row.Items.Add do
      begin
               with HTMLDiv(CSSClass.Col.colsize6).Items.Add do
               begin
                 with Card do
                 begin
                     ColSize:= CSSClass.Col.colsize12;
                     with Items.Add do
                     begin
                          with Row.Items.Add do
                          begin
                                with HTMLDiv(CSSClass.Col.colsize8).Items.Add do
                                begin
                                    with Row.Items.Add do
                                    begin
                                         FormGroup('', CSSClass.Col.colauto).AddVCLObj(btnSendAnyFilePDF, CSSClass.Button.open);
                                         FormGroup('', CSSClass.Col.colauto).AddVCLObj(btnSendAnyFilePNG, CSSClass.Button.open);
                                         FormGroup('', CSSClass.Col.colauto).AddVCLObj(btnSendAnyFileJPG, CSSClass.Button.open);
                                         FormGroup('', CSSClass.Col.colauto).AddVCLObj(btnSendAnyFileAudio, CSSClass.Button.open);
                                    end;

                                    with PanelGroup('Send Any File', '', false, CSSClass.Col.colsize12).Items.Add do
                                    begin
                                         Upload;
                                    end;
                                end;

                                with HTMLDiv(CSSClass.Col.colsize4).Items.Add do
                                begin
                                     FormGroup('', CSSClass.Col.col,'',false,'','',' width:250px;').AddVCLObj(PictureProfile);
                                end;
                          end;
                     end;
                 end;
               end;



               with HTMLDiv(CSSClass.Col.colsize6).Items.Add do
               begin
                with Card do
                begin
                     ColSize:= CSSClass.Col.colsize12;
                     with Items.Add do
                     begin
                       FormGroup('Log', CSSClass.Col.colsize12).AddVCLObj(MemoLog);
                     end;
                 end;
               end;


      end;



 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     ExecutablePath := GetCurrentDir;
end;

procedure TForm1.InitControlsD2Bridge(const PrismControl: TPrismControl);
begin
 inherited;
 if PrismControl.VCLComponent = MemoLog then
     PrismControl.AsMemo.Rows:= 9;
end;

procedure TForm1.Module11Click(Sender: TObject);
begin
 Form1.Show;
end;

procedure TForm1.RenderD2Bridge(const PrismControl: TPrismControl; var HTMLControl: string);
begin
 inherited;

  if PrismControl.VCLComponent = PictureProfile then
  PrismControl.AsImage.URLImage:= URL_PictureProfile;
end;

end.
