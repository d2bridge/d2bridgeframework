{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this library; if not, see <https://www.gnu.org/licenses/>.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.Lang.Term;


interface

uses
  Classes, SysUtils, D2Bridge.JSON, TypInfo, Rtti,
{$IFNDEF FPC}

{$ELSE}

{$ENDIF}
  D2Bridge.Lang.Term.BaseClass;

type
  TD2BridgeTermButton = class;
  TD2BridgeTermMessageButton = class;
  TD2BridgeTermMessageType = class;
  TD2BridgeTermUpload = class;
  TD2BridgeTermCombobox = class;
  TD2BridgeTermGrid = class;
  TD2BridgeTermLoader = class;
  TD2BridgeTermError500 = class;
  TD2BridgeTermError429 = class;
  TD2BridgeTermErrorBlackList = class;
  TD2BridgeTermMessages = class;



 TD2BridgeTerm = class(TD2BridgeTermBaseClass)
  private
   FButton: TD2BridgeTermButton;
   FMessageButton: TD2BridgeTermMessageButton;
   FMessageType: TD2BridgeTermMessageType;
   FUpload: TD2BridgeTermUpload;
   FCombobox: TD2BridgeTermCombobox;
   FGrid: TD2BridgeTermGrid;
   FLoader: TD2BridgeTermLoader;
   FError500: TD2BridgeTermError500;
   FError429: TD2BridgeTermError429;
   FErrorBlackList: TD2BridgeTermErrorBlackList;
   FMessages: TD2BridgeTermMessages;
  public
   constructor Create(AID2BridgeLang: ID2BridgeLang); override;
   destructor Destroy; override;

   function Button: TD2BridgeTermButton;
   function MessageButton: TD2BridgeTermMessageButton;
   function MessageType: TD2BridgeTermMessageType;
   function Upload: TD2BridgeTermUpload;
   function Combobox: TD2BridgeTermCombobox;
   function Grid: TD2BridgeTermGrid;
   function Loader: TD2BridgeTermLoader;
   function Error500: TD2BridgeTermError500;
   function Error429: TD2BridgeTermError429;
   function ErrorBlackList: TD2BridgeTermErrorBlackList;
   function Messages: TD2BridgeTermMessages;
 end;


 TD2BridgeTermButton = class(TD2BridgeTermItem)
  private

  public
   function CaptionSave: string;
   function CaptionEdit: string;
   function CaptionDelete: string;
   function CaptionCancel: string;
   function CaptionClose: string;
   function CaptionSearch: string;
   function CaptionOpen: string;
   function CaptionSelect: string;
   function CaptionAdd: string;
   function CaptionOptions: string;
   function CaptionConfig: string;
   function CaptionMenu: string;
   function CaptionRefresh: string;
   function CaptionCut: string;
   function CaptionCopy: string;
   function CaptionShare: string;
   function CaptionPower: string;
   function CaptionPrint: string;
   function CaptionView: string;
   function CaptionUpload: string;
   function CaptionDownload: string;
 end;


 TD2BridgeTermMessageButton = class(TD2BridgeTermItem)
  private

  public
   function ButtonYes: string;
   function ButtonNo: string;
   function ButtonOk: string;
   function ButtonCancel: string;
   function ButtonAbort: string;
   function ButtonRetry: string;
   function ButtonIgnore: string;
   function ButtonAll: string;
   function ButtonNoToAll: string;
   function ButtonYesToAll: string;
   function ButtonmrHelp: string;
   function ButtonmrClose: string;
 end;


 TD2BridgeTermMessageType = class(TD2BridgeTermItem)
  private

  public
   function TypeWarning: string;
   function TypeError: string;
   function TypeSuccess: string;
   function TypeInfo: string;
   function TypeQuestion: string;
   function TypeInformation: string;
 end;


 TD2BridgeTermUpload = class(TD2BridgeTermItem)
  private

  public
   function CaptionInput: string;
   function ButtonClear: string;
   function ButtonUpload: string;
   function MsgSuccessUpload: string;
   function MsgErrorNoFileSelect: string;
   function MsgErrorManyFileSelected: string;
   function MsgErrorFileSize: string;
   function MsgErrorTotalFilesSize: string;
   function MsgErrorFileType: string;
   function MsgErrorOnUpload: string;
 end;



 TD2BridgeTermCombobox = class(TD2BridgeTermItem)
  private

  public
   function Select: string;
 end;



 TD2BridgeTermGrid = class(TD2BridgeTermItem)
  private

  public
   function MsgErrorCellNoneValue: string;
   function MsgErrorCellValue: string;
   function FooterRecordText: string;
   function FooterRecordPageText: string;
   function EmptyRecords: string;
   function LoadingData: string;
 end;



 TD2BridgeTermLoader = class(TD2BridgeTermItem)
  private
  public
   function WaitText: string;
 end;



 TD2BridgeTermError500 = class(TD2BridgeTermItem)
  private

  public
   function Title: string;
   function Text: string;
 end;


 TD2BridgeTermError429 = class(TD2BridgeTermItem)
  private

  public
   function Title: string;
   function Text1: string;
   function Text2: string;
 end;


 TD2BridgeTermErrorBlackList = class(TD2BridgeTermItem)
  private

  public
   function Title: string;
   function SubTitle1: string;
   function SubTitle2: string;
   function YourIP: string;
   function DelistIP: string;
   function MsgTimeOut: string;
   function MsgWrongIP: string;
   function MsgDelistSuccess: string;
   function MsgDelistFailed: string;
   function MsgDelistError: string;
   function MsgInvalidIp: string;
 end;


 TD2BridgeTermMessages = class(TD2BridgeTermItem)
  private

  public
   function SessionIdleTimeOut: string;
   function UserOrPasswordInvalid: string;
 end;

implementation


{ TD2BridgeTerm }

function TD2BridgeTerm.Button: TD2BridgeTermButton;
begin
 Result:= FButton;
end;

function TD2BridgeTerm.Combobox: TD2BridgeTermCombobox;
begin
 Result:= FCombobox;
end;

constructor TD2BridgeTerm.Create(AID2BridgeLang: ID2BridgeLang);
begin
 inherited;

 FButton:= TD2BridgeTermButton.Create(self, 'Button');
 FMessageButton:= TD2BridgeTermMessageButton.Create(self, 'MessageButton');
 FMessageType:= TD2BridgeTermMessageType.Create(self, 'MessageType');
 FUpload:= TD2BridgeTermUpload.Create(self, 'Upload');
 FCombobox:= TD2BridgeTermCombobox.Create(self, 'Combobox');
 FGrid:= TD2BridgeTermGrid.Create(self, 'Grid');
 FLoader:= TD2BridgeTermLoader.Create(self, 'Loader');
 FError500:= TD2BridgeTermError500.Create(self, 'Error500');
 FError429:= TD2BridgeTermError429.Create(self, 'Error429');
 FErrorBlackList:= TD2BridgeTermErrorBlackList.Create(self, 'ErrorBlacklist');
 FMessages:= TD2BridgeTermMessages.Create(self, 'Messages');
end;

destructor TD2BridgeTerm.Destroy;
begin
  FreeAndNil(FButton);
  FreeAndNil(FMessageButton);
  FreeAndNil(FMessageType);
  FreeAndNil(FUpload);
  FreeAndNil(FCombobox);
  FreeAndNil(FGrid);
  FreeAndNil(FLoader);
  FreeAndNil(FError500);
  FreeAndNil(FError429);
  FreeAndNil(FErrorBlackList);
  FreeAndNil(FMessages);

  inherited;
end;

function TD2BridgeTerm.ErrorBlackList: TD2BridgeTermErrorBlackList;
begin
 result:= FErrorBlackList;
end;

function TD2BridgeTerm.Error429: TD2BridgeTermError429;
begin
 result:= FError429;
end;

function TD2BridgeTerm.Error500: TD2BridgeTermError500;
begin
 Result:= FError500;
end;

function TD2BridgeTerm.Grid: TD2BridgeTermGrid;
begin
 Result:= FGrid;
end;

function TD2BridgeTerm.Loader: TD2BridgeTermLoader;
begin
 Result:= FLoader;
end;

function TD2BridgeTerm.MessageButton: TD2BridgeTermMessageButton;
begin
 Result:= FMessageButton;
end;

function TD2BridgeTerm.Messages: TD2BridgeTermMessages;
begin
 Result:= FMessages;
end;

function TD2BridgeTerm.MessageType: TD2BridgeTermMessageType;
begin
 Result:= FMessageType;
end;

function TD2BridgeTerm.Upload: TD2BridgeTermUpload;
begin
 Result:= FUpload;
end;

{ TD2BridgeTermButton }

function TD2BridgeTermButton.CaptionAdd: string;
begin
 Result:= Language.Translate(Context, 'CaptionAdd');
end;

function TD2BridgeTermButton.CaptionCancel: string;
begin
 Result:= Language.Translate(Context, 'CaptionCancel');
end;

function TD2BridgeTermButton.CaptionClose: string;
begin
 Result:= Language.Translate(Context, 'CaptionClose');
end;

function TD2BridgeTermButton.CaptionConfig: string;
begin
 Result:= Language.Translate(Context, 'CaptionConfig');
end;

function TD2BridgeTermButton.CaptionCopy: string;
begin
 Result:= Language.Translate(Context, 'CaptionCopy');
end;

function TD2BridgeTermButton.CaptionCut: string;
begin
 Result:= Language.Translate(Context, 'CaptionCut');
end;

function TD2BridgeTermButton.CaptionDelete: string;
begin
 Result:= Language.Translate(Context, 'CaptionDelete');
end;

function TD2BridgeTermButton.CaptionDownload: string;
begin
 Result:= Language.Translate(Context, 'CaptionDownload');
end;

function TD2BridgeTermButton.CaptionEdit: string;
begin
 Result:= Language.Translate(Context, 'CaptionEdit');
end;

function TD2BridgeTermButton.CaptionMenu: string;
begin
 Result:= Language.Translate(Context, 'CaptionMenu');
end;

function TD2BridgeTermButton.CaptionOpen: string;
begin
 Result:= Language.Translate(Context, 'CaptionOpen');
end;

function TD2BridgeTermButton.CaptionOptions: string;
begin
 Result:= Language.Translate(Context, 'CaptionOptions');
end;

function TD2BridgeTermButton.CaptionPower: string;
begin
 Result:= Language.Translate(Context, 'CaptionPower');
end;

function TD2BridgeTermButton.CaptionPrint: string;
begin
 Result:= Language.Translate(Context, 'CaptionPrint');
end;

function TD2BridgeTermButton.CaptionRefresh: string;
begin
 Result:= Language.Translate(Context, 'CaptionRefresh');
end;

function TD2BridgeTermButton.CaptionSave: string;
begin
 Result:= Language.Translate(Context, 'CaptionSave');
end;

function TD2BridgeTermButton.CaptionSearch: string;
begin
 Result:= Language.Translate(Context, 'CaptionSearch');
end;

function TD2BridgeTermButton.CaptionSelect: string;
begin
 Result:= Language.Translate(Context, 'CaptionSelect');
end;

function TD2BridgeTermButton.CaptionShare: string;
begin
 Result:= Language.Translate(Context, 'CaptionShare');
end;

function TD2BridgeTermButton.CaptionUpload: string;
begin
 Result:= Language.Translate(Context, 'CaptionUpload');
end;

function TD2BridgeTermButton.CaptionView: string;
begin
 Result:= Language.Translate(Context, 'CaptionView');
end;



{ TD2BridgeTermMessageButton }

function TD2BridgeTermMessageButton.ButtonAbort: string;
begin
 Result:= Language.Translate(Context, 'ButtonAbort');
end;

function TD2BridgeTermMessageButton.ButtonAll: string;
begin
 Result:= Language.Translate(Context, 'ButtonAll');
end;

function TD2BridgeTermMessageButton.ButtonCancel: string;
begin
 Result:= Language.Translate(Context, 'ButtonCancel');
end;

function TD2BridgeTermMessageButton.ButtonIgnore: string;
begin
 Result:= Language.Translate(Context, 'ButtonIgnore');
end;

function TD2BridgeTermMessageButton.ButtonmrClose: string;
begin
 Result:= Language.Translate(Context, 'ButtonmrClose');
end;

function TD2BridgeTermMessageButton.ButtonmrHelp: string;
begin
 Result:= Language.Translate(Context, 'ButtonmrHelp');
end;

function TD2BridgeTermMessageButton.ButtonNo: string;
begin
 Result:= Language.Translate(Context, 'ButtonNo');
end;

function TD2BridgeTermMessageButton.ButtonNoToAll: string;
begin
 Result:= Language.Translate(Context, 'ButtonNoToAll');
end;

function TD2BridgeTermMessageButton.ButtonOk: string;
begin
 Result:= Language.Translate(Context, 'ButtonOk');
end;

function TD2BridgeTermMessageButton.ButtonRetry: string;
begin
 Result:= Language.Translate(Context, 'ButtonRetry');
end;

function TD2BridgeTermMessageButton.ButtonYes: string;
begin
 Result:= Language.Translate(Context, 'ButtonYes');
end;

function TD2BridgeTermMessageButton.ButtonYesToAll: string;
begin
 Result:= Language.Translate(Context, 'ButtonYesToAll');
end;


{ TD2BridgeTermMessageType }

function TD2BridgeTermMessageType.TypeError: string;
begin
 Result:= Language.Translate(Context, 'TypeError');
end;

function TD2BridgeTermMessageType.TypeInfo: string;
begin
 Result:= Language.Translate(Context, 'TypeInfo');
end;

function TD2BridgeTermMessageType.TypeInformation: string;
begin
 Result:= Language.Translate(Context, 'TypeInformation');
end;

function TD2BridgeTermMessageType.TypeQuestion: string;
begin
 Result:= Language.Translate(Context, 'TypeQuestion');
end;

function TD2BridgeTermMessageType.TypeSuccess: string;
begin
 Result:= Language.Translate(Context, 'TypeSuccess');
end;

function TD2BridgeTermMessageType.TypeWarning: string;
begin
 Result:= Language.Translate(Context, 'TypeWarning');
end;

{ TD2BridgeTermUpload }

function TD2BridgeTermUpload.ButtonClear: string;
begin
 Result:= Language.Translate(Context, 'ButtonClear');
end;

function TD2BridgeTermUpload.ButtonUpload: string;
begin
 Result:= Language.Translate(Context, 'ButtonUpload');
end;

function TD2BridgeTermUpload.CaptionInput: string;
begin
 Result:= Language.Translate(Context, 'CaptionInput');
end;

function TD2BridgeTermUpload.MsgErrorFileSize: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorFileSize');
end;

function TD2BridgeTermUpload.MsgErrorFileType: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorFileType');
end;

function TD2BridgeTermUpload.MsgErrorManyFileSelected: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorManyFileSelected');
end;

function TD2BridgeTermUpload.MsgErrorNoFileSelect: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorNoFileSelect');
end;

function TD2BridgeTermUpload.MsgErrorOnUpload: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorOnUpload');
end;

function TD2BridgeTermUpload.MsgErrorTotalFilesSize: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorTotalFilesSize');
end;

function TD2BridgeTermUpload.MsgSuccessUpload: string;
begin
 Result:= Language.Translate(Context, 'MsgSucessUpload');
end;

{ TD2BridgeTermCombobox }

function TD2BridgeTermCombobox.Select: string;
begin
 Result:= Language.Translate(Context, 'Select');
end;

{ TD2BridgeTermGrid }

function TD2BridgeTermGrid.EmptyRecords: string;
begin
 Result:= Language.Translate(Context, 'EmptyRecords');
end;

function TD2BridgeTermGrid.FooterRecordPageText: string;
begin
 Result:= Language.Translate(Context, 'FooterRecordPageText');
end;

function TD2BridgeTermGrid.FooterRecordText: string;
begin
 Result:= Language.Translate(Context, 'FooterRecordText');
end;

function TD2BridgeTermGrid.LoadingData: string;
begin
 Result:= Language.Translate(Context, 'LoadingData');
end;

function TD2BridgeTermGrid.MsgErrorCellNoneValue: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorCellNoneValue');
end;

function TD2BridgeTermGrid.MsgErrorCellValue: string;
begin
 Result:= Language.Translate(Context, 'MsgErrorCellValue');
end;

{ TD2BridgeTermLoader }

function TD2BridgeTermLoader.WaitText: string;
begin
 Result:= Language.Translate(Context, 'WaitText');
end;

{ TD2BridgeTermError500 }

function TD2BridgeTermError500.Text: string;
begin
 Result:= Language.Translate(Context, 'Text');
end;

function TD2BridgeTermError500.Title: string;
begin
 Result:= Language.Translate(Context, 'Title');
end;

{ TD2BridgeTermMessages }

function TD2BridgeTermMessages.SessionIdleTimeOut: string;
begin
 Result:= Language.Translate(Context, 'SessionIdleTimeOut');
end;

function TD2BridgeTermMessages.UserOrPasswordInvalid: string;
begin
 Result:= Language.Translate(Context, 'UserOrPasswordInvalid');
end;

{ TD2BridgeTermError429 }

function TD2BridgeTermError429.Text1: string;
begin
 Result:= Language.Translate(Context, 'Text1');

 if Result = '' then
  Result:= 'You have exceeded the connections limit. Please wait';
end;

function TD2BridgeTermError429.Text2: string;
begin
 Result:= Language.Translate(Context, 'Text2');

 if Result = '' then
  Result:= 'seconds and we will try to connect again.';
end;

function TD2BridgeTermError429.Title: string;
begin
 Result:= Language.Translate(Context, 'Title');

 if Result = '' then
  Result:= 'Too Many Connections';
end;

{ TD2BridgeTermErrorBlackList }

function TD2BridgeTermErrorBlackList.DelistIP: string;
begin
 Result:= Language.Translate(Context, 'DelistIP');
end;

function TD2BridgeTermErrorBlackList.MsgDelistError: string;
begin
 Result:= Language.Translate(Context, 'MsgDelistError');
end;

function TD2BridgeTermErrorBlackList.MsgDelistFailed: string;
begin
 Result:= Language.Translate(Context, 'MsgDelistFailed');
end;

function TD2BridgeTermErrorBlackList.MsgDelistSuccess: string;
begin
 Result:= Language.Translate(Context, 'MsgDelistSuccess');
end;

function TD2BridgeTermErrorBlackList.MsgInvalidIp: string;
begin
 Result:= Language.Translate(Context, 'MsgInvalidIp');
end;

function TD2BridgeTermErrorBlackList.MsgTimeOut: string;
begin
 Result:= Language.Translate(Context, 'MsgTimeOut');
end;

function TD2BridgeTermErrorBlackList.MsgWrongIP: string;
begin
 Result:= Language.Translate(Context, 'MsgWrongIP');
end;

function TD2BridgeTermErrorBlackList.SubTitle1: string;
begin
 Result:= Language.Translate(Context, 'SubTitle1');
end;

function TD2BridgeTermErrorBlackList.SubTitle2: string;
begin
 Result:= Language.Translate(Context, 'SubTitle2');
end;

function TD2BridgeTermErrorBlackList.Title: string;
begin
 Result:= Language.Translate(Context, 'Title');
end;

function TD2BridgeTermErrorBlackList.YourIP: string;
begin
 Result:= Language.Translate(Context, 'YourIP');
end;

end.