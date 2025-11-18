unit Unit_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TDM = class(TDataModule)
    DBInventarioTI: TADOConnection;
    Equipamento: TADOQuery;
    DSEquipamento: TDataSource;
    Software: TADOQuery;
    DSSoftware: TDataSource;
    Aux_Equipamento_Licenca: TADOQuery;
    DSAux_Equipamento_Licenca: TDataSource;
    Software_Licenca: TADOQuery;
    DSSoftware_Licenca: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
