unit Unit_DM;

{ Copyright 2024 / 2025 D2Bridge Framework by Talis Jonatas Gomes }

interface

uses
  System.SysUtils, System.Classes, Data.DB, MidasLib, Datasnap.DBClient, D2Bridge.BaseClass;

type
  TDM = class(TDataModule)
    CDSImages: TClientDataSet;
    CDSImagesImageName: TStringField;
    CDSImagesPath: TStringField;
    DSImages: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    FD2Bridge: TD2BridgeClass;

    procedure PopulateCDS;
  public
    class procedure CreateInstance;
  end;

function DM:TDM;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

Uses
  D2Bridge.Instance, ServerController;

{$R *.dfm}

class procedure TDM.CreateInstance;
begin
 D2BridgeInstance.CreateInstance(self);
end;

function DM:TDM;
begin
  result:= TDM(D2BridgeInstance.GetInstance(TDM));
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
 PopulateCDS;
end;

procedure TDM.PopulateCDS;
begin
 CDSImages.AppendRecord(['Image1.jpg', 'images\Image1.jpg']);
 CDSImages.AppendRecord(['Image2.jpg', 'images\Image2.jpg']);
 CDSImages.AppendRecord(['Image3.jpg', 'images\Image3.jpg']);
 CDSImages.AppendRecord(['Image4.jpg', 'images\Image4.jpg']);
 CDSImages.AppendRecord(['Image5.jpg', 'images\Image5.jpg']);
end;

end.