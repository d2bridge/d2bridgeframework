object DM: TDM
  OnCreate = DataModuleCreate
  Height = 240
  Width = 405
  object CDSImages: TClientDataSet
    PersistDataPacket.Data = {
      510000009619E0BD010000001800000002000000000003000000510009496D61
      67654E616D650100490000000100055749445448020002009600045061746802
      0049000000010005574944544802000200F4010000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'ImageName'
        DataType = ftString
        Size = 150
      end
      item
        Name = 'Path'
        DataType = ftString
        Size = 500
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 48
    Top = 32
    object CDSImagesImageName: TStringField
      FieldName = 'ImageName'
      Size = 150
    end
    object CDSImagesPath: TStringField
      FieldName = 'Path'
      Size = 500
    end
  end
  object DSImages: TDataSource
    DataSet = CDSImages
    Left = 136
    Top = 32
  end
end
