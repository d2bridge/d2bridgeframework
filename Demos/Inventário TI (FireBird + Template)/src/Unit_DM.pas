unit Unit_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.IBBase, FireDAC.Comp.UI;

type
  TDM = class(TDataModule)
    DSEquipamento: TDataSource;
    DSSoftware: TDataSource;
    DSAux_Equipamento_Licenca: TDataSource;
    DSSoftware_Licenca: TDataSource;
    DBInventarioTI: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    Equipamento: TFDQuery;
    Aux_Equipamento_Licenca: TFDQuery;
    Software: TFDQuery;
    Software_Licenca: TFDQuery;
    DSLogin: TDataSource;
    Login: TFDQuery;
    procedure DBInventarioTIBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DM: TDM;

implementation

Uses
 D2Bridge.Instance;

function DM: TDM;
begin
 Result:= TDM(D2BridgeInstance.GetInstance(TDM));
end;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DBInventarioTIBeforeConnect(Sender: TObject);
begin
 DBInventarioTI.Params.Database:= '..\..\..\Database\Firebird\INVENTARIOTI.FDB';
end;

end.
