object DM: TDM
  Height = 414
  Width = 421
  object DBInventarioTI: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sql;Persist Security Info=True;User' +
      ' ID=sa;Initial Catalog=INVENTARIOTI;Data Source=127.0.0.1'
    CursorLocation = clUseServer
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'SQLOLEDB.1'
    Left = 185
    Top = 21
  end
  object Equipamento: TADOQuery
    Active = True
    Connection = DBInventarioTI
    CursorLocation = clUseServer
    Parameters = <>
    SQL.Strings = (
      'Select * from Equipamento')
    Left = 265
    Top = 111
  end
  object DSEquipamento: TDataSource
    DataSet = Equipamento
    Left = 75
    Top = 112
  end
  object Software: TADOQuery
    Active = True
    Connection = DBInventarioTI
    CursorLocation = clUseServer
    Parameters = <>
    SQL.Strings = (
      'Select * from Software')
    Left = 268
    Top = 240
  end
  object DSSoftware: TDataSource
    DataSet = Software
    Left = 75
    Top = 240
  end
  object Aux_Equipamento_Licenca: TADOQuery
    Active = True
    Connection = DBInventarioTI
    CursorLocation = clUseServer
    Parameters = <>
    SQL.Strings = (
      'Select * from Aux_Equipamento_Licenca AEL')
    Left = 266
    Top = 175
  end
  object DSAux_Equipamento_Licenca: TDataSource
    DataSet = Aux_Equipamento_Licenca
    Left = 75
    Top = 176
  end
  object Software_Licenca: TADOQuery
    Active = True
    Connection = DBInventarioTI
    CursorLocation = clUseServer
    Parameters = <>
    SQL.Strings = (
      'Select * from Software_Licenca')
    Left = 267
    Top = 304
  end
  object DSSoftware_Licenca: TDataSource
    DataSet = Software_Licenca
    Left = 75
    Top = 304
  end
end
