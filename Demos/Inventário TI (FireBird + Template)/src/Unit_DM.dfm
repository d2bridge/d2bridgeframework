object DM: TDM
  OldCreateOrder = True
  Height = 639
  Width = 555
  object DSEquipamento: TDataSource
    DataSet = Equipamento
    Left = 62
    Top = 120
  end
  object DSSoftware: TDataSource
    DataSet = Software
    Left = 62
    Top = 224
  end
  object DSAux_Equipamento_Licenca: TDataSource
    DataSet = Aux_Equipamento_Licenca
    Left = 62
    Top = 176
  end
  object DSSoftware_Licenca: TDataSource
    DataSet = Software_Licenca
    Left = 62
    Top = 280
  end
  object DBInventarioTI: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\talis\OneDrive\Documentos\Projetos\Codigo Font' +
        'e\D2Bridge\Source\trunk\Demos\Invent'#225'rio TI (FireBird + Template' +
        ')\Database\Firebird\INVENTARIOTI.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    BeforeConnect = DBInventarioTIBeforeConnect
    Left = 64
    Top = 56
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrNone
    Left = 280
    Top = 64
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll'
    Left = 200
    Top = 8
  end
  object Equipamento: TFDQuery
    Connection = DBInventarioTI
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_EQUIPAMENTO'
    UpdateOptions.AutoIncFields = 'AUTO_CODIGO'
    SQL.Strings = (
      'Select * from Equipamento')
    Left = 280
    Top = 120
  end
  object Aux_Equipamento_Licenca: TFDQuery
    Connection = DBInventarioTI
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_AUX_EQUIPAMENTO_LICENCA'
    UpdateOptions.AutoIncFields = 'AUTO_CODIGO'
    SQL.Strings = (
      'Select * from Aux_Equipamento_Licenca AEL'
      '')
    Left = 280
    Top = 184
  end
  object Software: TFDQuery
    Connection = DBInventarioTI
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_SOFTWARE'
    UpdateOptions.AutoIncFields = 'AUTO_CODIGO'
    SQL.Strings = (
      'Select * from Software'
      '')
    Left = 280
    Top = 240
  end
  object Software_Licenca: TFDQuery
    Connection = DBInventarioTI
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_SOFTWARE_LICENCA'
    UpdateOptions.AutoIncFields = 'AUTO_CODIGO'
    SQL.Strings = (
      'Select * from Software_Licenca'
      '')
    Left = 280
    Top = 296
  end
  object DSLogin: TDataSource
    DataSet = Login
    Left = 62
    Top = 336
  end
  object Login: TFDQuery
    Connection = DBInventarioTI
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'GEN_LOGIN'
    UpdateOptions.AutoIncFields = 'AUTO_CODIGO'
    SQL.Strings = (
      'Select * from Login'
      '')
    Left = 280
    Top = 344
  end
end
