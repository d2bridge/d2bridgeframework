object D2BridgeServerControllerBase: TD2BridgeServerControllerBase
  Height = 470
  Width = 736
  object CDSLog: TClientDataSet
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'AutoCod'
        Attributes = [faReadonly]
        DataType = ftAutoInc
      end
      item
        Name = 'Identify'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'User'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'IP'
        DataType = ftString
        Size = 24
      end
      item
        Name = 'UserAgent'
        DataType = ftString
        Size = 120
      end
      item
        Name = 'Status'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'DateConnection'
        DataType = ftDateTime
      end
      item
        Name = 'DateUpdate'
        DataType = ftDateTime
      end
      item
        Name = 'Expire'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'UUID'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'FormName'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 120
    Top = 40
    object CDSLogAutoCod: TAutoIncField
      FieldName = 'AutoCod'
    end
    object CDSLogIdentify: TStringField
      FieldName = 'Identify'
      Size = 150
    end
    object CDSLogUser: TStringField
      FieldName = 'User'
      Size = 150
    end
    object CDSLogIP: TStringField
      FieldName = 'IP'
      Size = 24
    end
    object CDSLogUserAgent: TStringField
      FieldName = 'UserAgent'
      Size = 120
    end
    object CDSLogStatus: TStringField
      FieldName = 'Status'
      Size = 50
    end
    object CDSLogDateConnection: TDateTimeField
      FieldName = 'DateConnection'
      DisplayFormat = 'DD/MM/YY HH:MM'
    end
    object CDSLogDateUpdate: TDateTimeField
      FieldName = 'DateUpdate'
      DisplayFormat = 'DD/MM/YY HH:MM'
    end
    object CDSLogExpire: TStringField
      FieldName = 'Expire'
      Size = 30
    end
    object CDSLogUUID: TStringField
      FieldName = 'UUID'
      Size = 30
    end
    object CDSLogFormName: TStringField
      FieldName = 'FormName'
      Size = 100
    end
  end
  object DataSourceLog: TDataSource
    DataSet = CDSLog
    Left = 344
    Top = 40
  end
end
