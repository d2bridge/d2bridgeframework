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

unit D2Bridge.ItemCommon.Add;

interface

uses
  Classes, SysUtils, Generics.Collections, DB,
{$IFDEF FMX}
  FMX.Menus, FMX.StdCtrls, FMX.Objects,
{$ELSE}
  Menus, StdCtrls, ExtCtrls,
{$ENDIF}
  Prism.Types,
  D2Bridge.Interfaces, D2Bridge.HTML.CSS;



type

  { TItemAdd }

  TItemAdd = class(TInterfacedPersistent, IItemAdd)
  strict private

  private
   FBaseClass: TObject;
   FD2BridgeItems: ID2BridgeAddItems;
  public
   //Generic
   procedure D2BridgeItem(AD2BridgeItem: TObject);
   //Functions
   function VCLObj: ID2BridgeItemVCLObj; overload;
   function VCLObj(VCLItem: TObject; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function VCLObj(VCLItem: TObject; APopupMenu: TPopupMenu; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function VCLObj(VCLItem: TObject; AValidationGroup: Variant; ARequired: Boolean; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function VCLObjHidden(VCLItem: TObject): ID2BridgeItemVCLObj;
{$IFDEF FPC}
   function LCLObj: ID2BridgeItemVCLObj; overload;
   function LCLObj(VCLItem: TObject; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function LCLObj(VCLItem: TObject; APopupMenu: TPopupMenu; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function LCLObj(VCLItem: TObject; AValidationGroup: Variant; ARequired: Boolean = false; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj; overload;
   function LCLObjHidden(VCLItem: TObject): ID2BridgeItemVCLObj;
{$ENDIF}
   function Row(ACSSClass: String = ''; AItemID: string = ''; AHTMLinLine: Boolean = false; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLRow;
   function FormGroup(ATextLabel: String = ''; AColSize: string = 'col-auto'; AItemID: string = ''; AHTMLinLine: Boolean = false; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLFormGroup; overload;
   function FormGroup(ALabelComponent: TComponent; AColSize: string = 'col-auto'; AItemID: string = ''; AHTMLinLine: Boolean = false; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLFormGroup; overload;
{$IFNDEF FMX}
   procedure FormGroup(LabeledEdit: TLabeledEdit; AColSize: string = 'col-auto'; AItemID: string = ''; AHTMLinLine: Boolean = false; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''); overload;
   procedure FormGroup(LabeledEdit: TLabeledEdit; AValidationGroup: Variant; ARequired: Boolean; AColSize: string = 'col-auto'; AItemID: string = ''; AHTMLinLine: Boolean = false; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''); overload;
{$ENDIF}
   function PanelGroup(ATitle: String = ''; AItemID: string = ''; AHTMLinLine: Boolean = false; AColSize: string = ''; ACSSClass: String = PanelColor.default; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLPanelGroup;
   function HTMLDIV(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow;
   function Tabs(AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLTabs;
   function Accordion(AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLAccordion;
   function Popup(AName: String; ATitle: String = ''; AShowButtonClose: Boolean = true; ACSSClass: String = 'modal-lg'; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLPopup;
   function Nested(AFormNestedName: String): ID2BridgeItemNested; overload;
   function Nested(AD2BridgeForm: TObject): ID2BridgeItemNested; overload;
   function Upload(ACaption: string = 'Upload'; AAllowedFileTypes: string = '*'; AItemID: string = ''; AMaxFiles: integer = 12; AMaxFileSize: integer = 20; AInputVisible: Boolean = true; ACSSInput : string = 'form-control'; ACSSButtonUpload: string = 'btn btn-primary rounded-0'; ACSSButtonClear: string = 'btn btn-secondary rounded-0'; AFontICOUpload: String = 'fe-upload fa fa-upload me-2'; AFontICOClear: String = 'fe fe-x fa fa-x me-2'; AShowFinishMessage: Boolean = false; AMaxUploadSize: integer = 128): ID2BridgeItemHTMLInput;
   function HTMLElement(AHTMLElement: string; AItemID: string = ''): ID2BridgeItemHTMLElement; overload;
   function HTMLElement(ComponentHTMLElement: TComponent; AItemID: string = ''): ID2BridgeItemHTMLElement; overload;
   function Card(AHeaderTitle: string = ''; AColSize: string = ''; AText: string = '';  AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard;
   function CardGroup(AMarginCardsSize: string = 'mx-2'; AItemID: string = ''; AColSize: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCardGroup;
   function CardGrid(AEqualHeight: boolean = false; AItemID: string = ''; AColSize: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCardGrid; overload;
{$IFNDEF FMX}
   function CardGrid({$IFNDEF FMX}ADataSource: TDataSource;{$ELSE}ARecordCount: integer;{$ENDIF} AColSize: string = ''; AEqualHeight: boolean = true; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCardGridDataModel; overload;
{$ENDIF}
   function Link(AText: string = ''; AOnClick : TNotifyEvent = nil; AItemID: string = ''; Href: string = ''; OnClickCallBack : string = ''; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function Link(AText: string; Href: string; AItemID: string = ''; OnClickCallBack : string = ''; AOnClick : TNotifyEvent = nil; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function LinkCallBack(AText: string; OnClickCallBack : string; AItemID: string = ''; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function Link(ComponentHTMLElement: TComponent; Href: string = ''; AOnClick : TNotifyEvent = nil; OnClickCallBack : string = ''; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function Link(ComponentHTMLElement: TComponent; AOnClick : TNotifyEvent; Href: string = ''; OnClickCallBack : string = ''; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function LinkCallBack(ComponentHTMLElement: TComponent; OnClickCallBack : string; AHint: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLLink; overload;
   function Carousel(AImageList: TStrings = nil; AItemID: string = ''; AAutoSlide: boolean = true; AInterval: integer = 4000; AShowIndicator: boolean = true; AShowButtons: boolean = true; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCarousel; overload;
{$IFNDEF FMX}
   function Carousel(ADataSource: TDataSource; ADataFieldImagePath: string; AItemID: string = ''; AAutoSlide: boolean = true; AInterval: integer = 4000; AShowIndicator: boolean = true; AShowButtons: boolean = true; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCarousel; overload;
{$ENDIF}
   function QRCode(AText: string = ''; AItemID: string = ''; ASize: integer = 128; AColorCode: string = 'black'; AColorBackgroud: string = 'white'; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLQRCode; overload;
{$IFNDEF FMX}
   function QRCode(ADataSource: TDataSource; ADataField: string; AItemID: string = ''; ASize: integer = 128; AColorCode: string = 'black'; AColorBackgroud: string = 'white'; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLQRCode; overload;
{$ENDIF}
   function SideMenu(MainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}): ID2BridgeItemHTMLSideMenu;
   function MainMenu(MainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}): ID2BridgeItemHTMLMainMenu;
   function ImageFromURL(AURL: string; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLImage;
   function ImageFromLocal(PathFromImage: string; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLImage;
   function ImageFromTImage(ATImage: TImage; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLImage;
{$IFNDEF FMX}
   function ImageFromDB(ADataSource: TDataSource; ADataFieldImagePath: string; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLDBImage; overload;
   function ImageFromDB(AImageFolder: string; ADataSource: TDataSource; ADataFieldImageFile: string; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLDBImage; overload;
{$ENDIF}
   //Badge
   function BadgeText(ComponentLabel: TComponent; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLBadgeText; overload;
   function BadgePillText(ComponentLabel: TComponent; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLBadgeText; overload;
   function BadgeButtonText(ComponentButton: TComponent; ComponentLabel: TComponent; ACSSClassButton: String = ''; ACSSClassLabel: String = ''; AHTMLExtrasButton: String = ''; AHTMLExtrasLabel: String = ''; AHTMLStyleButton: String = ''; AHTMLStyleLabel: String = ''): ID2BridgeItemHTMLBadgeButton; overload;
   function BadgeButtonTopText(ComponentButton: TComponent; ComponentLabel: TComponent; ACSSClassButton: String = ''; ACSSClassLabel: String = ''; AHTMLExtrasButton: String = ''; AHTMLExtrasLabel: String = ''; AHTMLStyleButton: String = ''; AHTMLStyleLabel: String = ''): ID2BridgeItemHTMLBadgeButton; overload;
   function BadgeButtonIndicator(ComponentButton: TComponent; ComponentLabel: TComponent; ACSSClassButton: String = ''; ACSSClassLabel: String = ''; AHTMLExtrasButton: String = ''; AHTMLExtrasLabel: String = ''; AHTMLStyleButton: String = ''; AHTMLStyleLabel: String = ''): ID2BridgeItemHTMLBadgeButton; overload;
   //Kanban
   function Kanban(AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLKanban;
   //Col Size
   function Col(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function ColAuto(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col1(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col2(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col3(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col4(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col5(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col6(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col7(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col8(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col9(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col10(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col11(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col12(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function ColFull(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   //Col Size Responsive
   function Col(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function ColAuto(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col1(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col2(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col3(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col4(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col5(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col6(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col7(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col8(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col9(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col10(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col11(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function Col12(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   function ColFull(AAutoResponsive: boolean; ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow; overload;
   //MarkDown Editor
   function MarkdownEditor(TextVCLItem: TComponent; AHeight: integer = 0; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLMarkDownEditor; overload;
{$IFNDEF FMX}
   function MarkdownEditor(ADataSource: TDataSource; ADataFieldName: string; AItemID: string = ''; AHeight: integer = 0; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLMarkDownEditor; overload;
{$ENDIF}
   //WYSIWYG
   function WYSIWYGEditor(TextVCLItem: TComponent; AHeight: integer = 0; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLWYSIWYGEditor; overload;
   function WYSIWYGEditor(TextVCLItem: TComponent; AAirMode: Boolean; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemHTMLWYSIWYGEditor; overload;
{$IFNDEF FMX}
   function WYSIWYGEditor(ADataSource: TDataSource; ADataFieldName: string; AItemID: string = ''; AHeight: integer = 0; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLWYSIWYGEditor; overload;
   function WYSIWYGEditor(ADataSource: TDataSource; ADataFieldName: string; AAirMode: Boolean; AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLWYSIWYGEditor; overload;
{$ENDIF}
   //Camera
   function Camera(AImage: TImage): ID2BridgeItemHTMLCamera;
   //QRCode Reader
   function QRCodeReader(AImage: TImage; TextVCLItem: TComponent; AContinuousScan: Boolean = true; APressReturnKey: Boolean = false): ID2BridgeItemHTMLQRCodeReader; overload;
   function QRCodeReader(AImage: TImage; AOnRead: TNotifyEventStr; AContinuousScan: Boolean = true; APressReturnKey: Boolean = false): ID2BridgeItemHTMLQRCodeReader; overload;
   //Constructor / Destructor
   constructor Create(D2BridgeItems: ID2BridgeAddItems);
   destructor Destroy; override;
 end;


implementation

uses
  D2Bridge.ItemCommon, D2Bridge.BaseClass, D2Bridge.Item, D2Bridge.Item.HTML.Row, D2Bridge.Item.HTML.FormGroup,
  D2Bridge.Forms,
  D2Bridge.Item.VCLObj, D2Bridge.Item.Nested, D2Bridge.Item.HTML.Card, D2Bridge.Item.HTML.Card.Group,
  D2Bridge.Item.HTML.Card.Grid, D2Bridge.Item.HTML.Card.Grid.DataModel,
  D2Bridge.Item.HTML.PanelGroup, D2Bridge.Item.HTML.Tabs,
  D2Bridge.Item.HTML.Accordion, D2Bridge.Item.HTML.Popup, D2Bridge.Item.HTML.Upload,
  D2Bridge.Item.HTMLelement, D2Bridge.Item.HTML.Link, D2Bridge.Item.HTML.Carousel, D2Bridge.Item.HTML.QRCode,
  D2Bridge.Item.HTML.MainMenu, D2Bridge.Item.HTML.SideMenu, D2Bridge.Item.HTML.Image, D2Bridge.Item.HTML.DBImage,
  D2Bridge.Item.HTML.Kanban, D2Bridge.Item.HTML.Editor.MarkDown, D2Bridge.Item.HTML.Editor.WYSIWYG,
  D2Bridge.Item.HTML.Camera, D2Bridge.Item.HTML.QRCodeReader,
  D2Bridge.Item.HTML.Badge.Text, D2Bridge.Item.HTML.Badge.Button;

{ TItemsAdd }


function TItemAdd.Accordion(AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLAccordion;
begin
 Result := TD2BridgeItemHTMLAccordion.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Accordion')
 else
  Result.ItemID:= AItemID;
 if ACSSClass <> '' then
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.BadgeButtonIndicator(ComponentButton,
  ComponentLabel: TComponent; ACSSClassButton, ACSSClassLabel,
  AHTMLExtrasButton, AHTMLExtrasLabel, AHTMLStyleButton,
  AHTMLStyleLabel: String): ID2BridgeItemHTMLBadgeButton;
begin
 result:= BadgeButtonText(ComponentButton, ComponentLabel, ACSSClassButton, ACSSClassLabel,
           AHTMLExtrasButton, AHTMLExtrasLabel, AHTMLStyleButton,
           AHTMLStyleLabel);

 result.Indicator:= true;
end;

function TItemAdd.BadgeButtonText(ComponentButton,
  ComponentLabel: TComponent; ACSSClassButton, ACSSClassLabel,
  AHTMLExtrasButton, AHTMLExtrasLabel, AHTMLStyleButton,
  AHTMLStyleLabel: String): ID2BridgeItemHTMLBadgeButton;
begin
 Result:= TD2BridgeItemHTMLBadgeButton.Create(TD2BridgeClass(FBaseClass));

 if Assigned(ComponentLabel) then
 begin
  //Result.ItemID:= ComponentButton.Name;
  Result.PrismBadge.LabelHTMLElement:= ComponentLabel;
  REsult.PrismBadge.ButtonHTMLElement:= ComponentButton;
//  Result.PrismBadge.
  //Result.PrismBadge LabelHTMLElement:= ComponentLabel;
 end;

 if Result.ItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('BadgeButton');

 Result.CSSClasses:= ACSSClassButton;
 Result.HTMLExtras:= AHTMLExtrasButton;
 Result.HTMLStyle:= AHTMLStyleButton;

 Result.LabelStyles.CSSClasses:= ACSSClassLabel;
 Result.LabelStyles.HTMLExtras:= AHTMLExtrasLabel;
 Result.LabelStyles.HTMLStyle:= AHTMLStyleLabel;


 FD2BridgeItems.Add(Result);

end;

function TItemAdd.BadgeButtonTopText(ComponentButton,
  ComponentLabel: TComponent; ACSSClassButton, ACSSClassLabel,
  AHTMLExtrasButton, AHTMLExtrasLabel, AHTMLStyleButton,
  AHTMLStyleLabel: String): ID2BridgeItemHTMLBadgeButton;
begin
 result:= BadgeButtonText(ComponentButton, ComponentLabel, ACSSClassButton, ACSSClassLabel,
           AHTMLExtrasButton, AHTMLExtrasLabel, AHTMLStyleButton,
           AHTMLStyleLabel);

 result.TopPosition:= true;
end;

function TItemAdd.BadgePillText(ComponentLabel: TComponent; ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLBadgeText;
begin
 result:= BadgeText(ComponentLabel, ACSSClass, AHTMLExtras, AHTMLStyle);

 result.Pill:= true;
end;

function TItemAdd.BadgeText(ComponentLabel: TComponent; ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLBadgeText;
begin
 Result:= TD2BridgeItemHTMLBadgeText.Create(TD2BridgeClass(FBaseClass));

 if Assigned(ComponentLabel) then
 begin
  //Result.ItemID:= ComponentLabel.Name;
  Result.PrismBadge.LabelHTMLElement:= ComponentLabel;
 end;

 if Result.ItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('BadgeText');

 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Camera(AImage: TImage): ID2BridgeItemHTMLCamera;
begin
 result:= TD2BridgeItemHTMLCamera.Create(TD2BridgeClass(FBaseClass));

 Result.ItemID:= AImage.Name;
 Result.PrismCamera.VCLComponent:= AImage;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Card(AHeaderTitle: string = ''; AColSize: string = ''; AText: string = '';  AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLCard;
begin
 Result:= TD2BridgeItemHTMLCard.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Card')
 else
  Result.ItemID:= AItemID;
 //Result.Title:= ATitle;
 if AHeaderTitle <> '' then
 Result.Header(AHeaderTitle);
 Result.Text:= AText;
 Result.ColSize:= AColSize;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.CardGrid(AEqualHeight: boolean; AItemID: string;
  AColSize: string; ACSSClass: String; AHTMLExtras: String; AHTMLStyle: String
  ): ID2BridgeItemHTMLCardGrid;
begin
 Result:= TD2BridgeItemHTMLCardGrid.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('CardGrid')
 else
  Result.ItemID:= AItemID;
 Result.EqualHeight:= AEqualHeight;
 Result.ColSize:= AColSize;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);

end;

{$IFNDEF FMX}
function TItemAdd.CardGrid({$IFNDEF FMX}ADataSource: TDataSource;{$ELSE}ARecordCount: integer;{$ENDIF}
  AColSize: string; AEqualHeight: boolean; AItemID, ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLCardGridDataModel;
begin
 Result:= TD2BridgeItemHTMLCardGridDataModel.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('CardGriddatamodel')
 else
  Result.ItemID:= AItemID;
 Result.EqualHeight:= AEqualHeight;
 Result.ColSize:= AColSize;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;
 Result.DataSource:= ADataSource;

 FD2BridgeItems.Add(Result);
end;
{$ENDIF}

function TItemAdd.CardGroup(AMarginCardsSize: string; AItemID: string;
  AColSize: string; ACSSClass: String; AHTMLExtras: String; AHTMLStyle: String
  ): ID2BridgeItemHTMLCardGroup;
begin
 Result:= TD2BridgeItemHTMLCardGroup.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('CardGroup')
 else
  Result.ItemID:= AItemID;
 Result.MarginCardsSize:= AMarginCardsSize;
 Result.ColSize:= AColSize;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

{$IFNDEF FMX}
function TItemAdd.Carousel(ADataSource: TDataSource; ADataFieldImagePath,
  AItemID: string; AAutoSlide: boolean; AInterval: integer; AShowIndicator,
  AShowButtons: boolean; ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLCarousel;
begin
 Result:= Carousel(nil, AItemID, AAutoSlide, AInterval, AShowIndicator, AShowButtons, ACSSClass, AHTMLExtras, AHTMLStyle);

 if Assigned(ADataSource) then
  Result.PrismCarousel.DataSource:= ADataSource;
 Result.PrismCarousel.DataFieldImagePath:= ADataFieldImagePath;
end;
{$ENDIF}

function TItemAdd.Carousel(AImageList: TStrings; AItemID: string;
  AAutoSlide: boolean; AInterval: integer; AShowIndicator,
  AShowButtons: boolean; ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLCarousel;
begin
 Result:= TD2BridgeItemHTMLCarousel.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Carousel')
 else
  Result.ItemID:= AItemID;

 if Assigned(AImageList) then
  Result.PrismCarousel.ImageFiles.AddRange(AImageList.ToStringArray);
 Result.PrismCarousel.AutoSlide:= AAutoSlide;
 Result.PrismCarousel.Interval:= AInterval;
 Result.PrismCarousel.ShowIndicator:= AShowIndicator;
 Result.PrismCarousel.ShowButtons:= AShowButtons;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;


constructor TItemAdd.Create(D2BridgeItems: ID2BridgeAddItems);
begin
 FD2BridgeItems:= D2BridgeItems;
 TD2BridgeClass(FBaseClass):= (D2BridgeItems as TD2BridgeItems).BaseClass;
end;

procedure TItemAdd.D2BridgeItem(AD2BridgeItem: TObject);
var
 vD2BridgeItem: ID2BridgeItem;
begin
 if Supports(AD2BridgeItem, ID2BridgeItem, vD2BridgeItem) then
 begin
  if vD2BridgeItem.ItemID = '' then
   vD2BridgeItem.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('d2bridgeitem');
  FD2BridgeItems.Add(vD2BridgeItem);
 end;
end;

destructor TItemAdd.Destroy;
begin
 FD2BridgeItems:= nil;

 inherited;
end;


function TItemAdd.FormGroup(ALabelComponent: TComponent; AColSize, AItemID: string; AHTMLinLine: Boolean; ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLFormGroup;
begin
 Result:= FormGroup('', AColSize, AItemID, AHTMLinLine, ACSSClass, AHTMLExtras, AHTMLStyle) as TD2BridgeItemHTMLFormGroup;
 Result.LabelComponent:= ALabelComponent;
end;

{$IFNDEF FMX}
procedure TItemAdd.FormGroup(LabeledEdit: TLabeledEdit; AColSize: string; AItemID: string; AHTMLinLine: Boolean; ACSSClass: String; AHTMLExtras: String; AHTMLStyle: String);
var
 vFormGroup: TD2BridgeItemHTMLFormGroup;
begin
 vFormGroup:= FormGroup(LabeledEdit.EditLabel.Caption, AColSize, AItemID, AHTMLinLine, ACSSClass, AHTMLExtras, AHTMLStyle) as TD2BridgeItemHTMLFormGroup;
 vFormGroup.AddVCLObj(LabeledEdit);
end;

procedure TItemAdd.FormGroup(LabeledEdit: TLabeledEdit; AValidationGroup: Variant; ARequired: Boolean; AColSize, AItemID: string;
  AHTMLinLine: Boolean; ACSSClass, AHTMLExtras, AHTMLStyle: String);
var
 vFormGroup: TD2BridgeItemHTMLFormGroup;
begin
 vFormGroup:= FormGroup(LabeledEdit.EditLabel.Caption, AColSize, AItemID, AHTMLinLine, ACSSClass, AHTMLExtras, AHTMLStyle) as TD2BridgeItemHTMLFormGroup;
 vFormGroup.AddVCLObj(LabeledEdit, AValidationGroup, ARequired);
end;
{$ENDIF}


function TItemAdd.FormGroup(ATextLabel: String = ''; AColSize: string = 'col-auto'; AItemID: string = ''; AHTMLinLine: Boolean = false; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLFormGroup;
begin
 Result := TD2BridgeItemHTMLFormGroup.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
 Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('FormGroup')
 else
 Result.ItemID:= AItemID;
 Result.TextLabel:= ATextLabel;
 Result.ColSize1:= AColSize;
 Result.HTMLInLine:= AHTMLinLine;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;


function TItemAdd.HTMLDIV(ACSSClass: String = ''; AItemID: string = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''; AHTMLTag: String = 'div'): ID2BridgeItemHTMLRow;
begin
 Result := TD2BridgeItemHTMLRow.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('div')
 else
  Result.ItemID:= AItemID;

 Result.IsDiv:= true;
 Result.HTMLTagRow:= AHTMLTag;
 Result.CSSClasses:= Trim('d2bridgediv ' + ACSSClass);
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.HTMLElement(ComponentHTMLElement: TComponent; AItemID: string = ''): ID2BridgeItemHTMLElement;
begin
 Result := TD2BridgeItemHTMLElement.Create(TD2BridgeClass(FBaseClass));
 if AItemID <> '' then
  Result.ItemID:= AItemID
 else
  Result.ItemID:= ComponentHTMLElement.Name;

 Result.ComponentHTMLElement:= ComponentHTMLElement;

 FD2BridgeItems.Add(Result);
end;

{$IFNDEF FMX}
function TItemAdd.ImageFromDB(ADataSource: TDataSource; ADataFieldImagePath,
  ACSSClass, AItemID, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLDBImage;
begin
 Result := ImageFromDB('', ADataSource, ADataFieldImagePath, ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle);
end;
{$ENDIF}


{$IFNDEF FMX}
function TItemAdd.ImageFromDB(AImageFolder: string; ADataSource: TDataSource; ADataFieldImageFile, ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLDBImage;
begin
 Result := TD2BridgeItemHTMLDBImage.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('img')
 else
  Result.ItemID:= AItemID;

 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 Result.DataSource:= ADataSource;
 Result.DataFieldImagePath:= ADataFieldImageFile;
 Result.ImageFolder:= AImageFolder;

 FD2BridgeItems.Add(Result);
end;
{$ENDIF}


function TItemAdd.ImageFromLocal(PathFromImage: string; ACSSClass: String;
  AItemID: string; AHTMLExtras: String; AHTMLStyle: String
  ): ID2BridgeItemHTMLImage;
begin
 Result := TD2BridgeItemHTMLImage.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('img')
 else
  Result.ItemID:= AItemID;

 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 Result.ImageFromLocal(PathFromImage);

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.ImageFromTImage(ATImage: TImage; ACSSClass: String;
  AItemID: string; AHTMLExtras: String; AHTMLStyle: String
  ): ID2BridgeItemHTMLImage;
begin
 Result := TD2BridgeItemHTMLImage.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('img')
 else
  Result.ItemID:= AItemID;

 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 Result.ImageFromTImage(ATImage);

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.ImageFromURL(AURL: string; ACSSClass: String;
  AItemID: string; AHTMLExtras: String; AHTMLStyle: String
  ): ID2BridgeItemHTMLImage;
begin
 Result := TD2BridgeItemHTMLImage.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('img')
 else
  Result.ItemID:= AItemID;

 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 Result.ImageFromURL(AURL);

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Kanban(AItemID, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLKanban;
begin
 Result := TD2BridgeItemHTMLKanban.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('kanban')
 else
  Result.ItemID:= AItemID;
 if ACSSClass <> '' then
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

//ColSize
function TItemAdd.Col(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.Col);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.ColAuto(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' '+D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colauto);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.ColFull(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colfull);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col1(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' '+ D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize1);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col2(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize2);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col3(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize3);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col4(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize4);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col5(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize5);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col6(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize6);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col7(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize7);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col8(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize8);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col9(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize9);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col10(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize10);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col11(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize11);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Col12(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
begin
 ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colinline+' d2bridgecol');

 if (POS('col-', ACSSClass) <= 0) and (ACSSClass <> 'col') then
  ACSSClass:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colsize12);

 Result:= HTMLDIV(ACSSClass, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
 Result.IsCol:= true;
end;

function TItemAdd.Link(ComponentHTMLElement: TComponent; Href: string; AOnClick: TNotifyEvent; OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 Result:= TD2BridgeItemHTMLLink.Create(TD2BridgeClass(FBaseClass));

 if Assigned(ComponentHTMLElement) then
 begin
  Result.ItemID:= ComponentHTMLElement.Name;
  Result.PrismLink.LabelHTMLElement:= ComponentHTMLElement;
 end;

 if Result.ItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Link');

// if Href = '' then
//  Href:= '#';

 Result.PrismLink.href:= Href;
 Result.PrismLink.OnClick := AOnClick;
 Result.PrismLink.OnClickCallBack := OnClickCallBack;
 Result.PrismLink.Hint := AHint;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);

end;

function TItemAdd.LinkCallBack(AText, OnClickCallBack, AItemID, AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 Result:= TD2BridgeItemHTMLLink.Create(TD2BridgeClass(FBaseClass));

// if Href = '' then
//  Href:= '#';

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Link')
 else
  Result.ItemID:= AItemID;

 Result.PrismLink.Text:= AText;
// Result.PrismLink.href:= Href;
// Result.PrismLink.OnClick := AOnClick;
 Result.PrismLink.OnClickCallBack := OnClickCallBack;
 Result.PrismLink.Hint := AHint;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Nested(AD2BridgeForm: TObject): ID2BridgeItemNested;
begin
 Result:= TD2BridgeItemNested.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Nested');
 Result.NestedFormName:= TD2BridgeForm(AD2BridgeForm).NestedName;

 FD2BridgeItems.Add(Result);
end;


function TItemAdd.HTMLElement(AHTMLElement: string; AItemID: string = ''): ID2BridgeItemHTMLElement;
begin
 Result := TD2BridgeItemHTMLElement.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('htmlelement')
 else
  Result.ItemID:= AItemID;

 Result.HTML:= AHTMLElement;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Nested(AFormNestedName: String): ID2BridgeItemNested;
begin
 Result:= TD2BridgeItemNested.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Nested');
 Result.NestedFormName:= AFormNestedName;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.PanelGroup(ATitle: String = ''; AItemID: string = ''; AHTMLinLine: Boolean = false; AColSize: string = ''; ACSSClass: String = PanelColor.default; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLPanelGroup;
begin
 Result:= TD2BridgeItemHTMLPanelGroup.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('PanelGroup')
 else
  Result.ItemID:= AItemID;
 Result.Title:= ATitle;
 Result.ColSize:= AColSize;
 Result.HTMLInLine:= AHTMLinLine;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Popup(AName: String; ATitle: String = ''; AShowButtonClose: Boolean = true; ACSSClass: String = 'modal-lg'; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLPopup;
begin
 Result := TD2BridgeItemHTMLPopup.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= AnsiUpperCase(AName);
 Result.Title:= ATitle;
 Result.ShowButtonClose:= AShowButtonClose;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);

 (TD2BridgeClass(FBaseClass)).AddPopup(Result);
end;

{$IFNDEF FMX}
function TItemAdd.QRCode(ADataSource: TDataSource; ADataField,
  AItemID: string; ASize: integer; AColorCode, AColorBackgroud, ACSSClass,
  AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLQRCode;
begin
 Result:= QRCode;

 Result.PrismQRCode.DataSource:= ADataSource;
 Result.PrismQRCode.DataField:= ADataField;
end;
{$ENDIF}

function TItemAdd.QRCode(AText, AItemID: string; ASize: integer; AColorCode,
  AColorBackgroud, ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLQRCode;
begin
 Result:= TD2BridgeItemHTMLQRCode.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('QRCode')
 else
  Result.ItemID:= AItemID;

 Result.PrismQRCode.Text:= AText;
 Result.PrismQRCode.ColorCode:= AColorCode;
 Result.PrismQRCode.ColorBackground:= AColorBackgroud;
 Result.PrismQRCode.Size:= ASize;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.QRCodeReader(AImage: TImage; AOnRead: TNotifyEventStr;
  AContinuousScan,
  APressReturnKey: Boolean): ID2BridgeItemHTMLQRCodeReader;
begin
 result:= TD2BridgeItemHTMLQRCodeReader.Create(TD2BridgeClass(FBaseClass));

 Result.ItemID:= AImage.Name;
 Result.PrismQRCodeReader.VCLComponent:= AImage;

 Result.OnRead:= AOnRead;
 Result.PressReturnKey:= APressReturnKey;
 Result.ContinuousScan:= AContinuousScan;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.QRCodeReader(AImage: TImage; TextVCLItem: TComponent; AContinuousScan: Boolean = true; APressReturnKey: Boolean = false): ID2BridgeItemHTMLQRCodeReader;
begin
 result:= TD2BridgeItemHTMLQRCodeReader.Create(TD2BridgeClass(FBaseClass));

 Result.ItemID:= AImage.Name;
 Result.PrismQRCodeReader.VCLComponent:= AImage;

 Result.TextVCLComponent:= TextVCLItem;
 Result.PressReturnKey:= APressReturnKey;
 Result.ContinuousScan:= AContinuousScan;

 FD2BridgeItems.Add(Result);
end;


//function TItemAdd.Row(AHTMLTag, ACSSClass: String): ID2BridgeItemHTMLRow;
//begin
// Result:= Row;
// Result.HTMLTagRow:= AHTMLTag;
// Result.CSS:= ACSS;
//end;

//function TItemAdd.PanelGroup: ID2BridgeItemHTMLPanelGroup;
//begin
// Result := TD2BridgeItemHTMLPanelGroup.Create(TD2BridgeClass(FBaseClass));
//
// FD2BridgeItems.Add(Result);
//end;

function TItemAdd.Row(ACSSClass: String = ''; AItemID: string = ''; AHTMLinLine: Boolean = false; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLRow;
begin
 Result := TD2BridgeItemHTMLRow.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('row')
 else
  Result.ItemID:= AItemID;

 if Pos('row', ACSSClass) <= 0 then
  ACSSClass := Trim('row ' + ACSSClass);

 Result.IsRow:= true;
 Result.HTMLTagRow:= 'div';
 Result.HTMLInLine:= AHTMLinLine;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.SideMenu(MainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}): ID2BridgeItemHTMLSideMenu;
begin
 Result := TD2BridgeItemHTMLSideMenu.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= MainMenu.Name;

 Result.Options.VCLComponent:= MainMenu;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Tabs(AItemID: string = ''; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLTabs;
begin
 Result := TD2BridgeItemHTMLTabs.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Tabs')
 else
  Result.ItemID:= AItemID;
 if ACSSClass <> '' then
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.Upload(ACaption: string = 'Upload'; AAllowedFileTypes: string = '*'; AItemID: string = ''; AMaxFiles: integer = 12; AMaxFileSize: integer = 20; AInputVisible: Boolean = true; ACSSInput : string = 'form-control'; ACSSButtonUpload: string = 'btn btn-primary rounded-0'; ACSSButtonClear: string = 'btn btn-secondary rounded-0'; AFontICOUpload: String = 'fe-upload fa fa-upload me-2'; AFontICOClear: String = 'fe fe-x fa fa-x me-2'; AShowFinishMessage: Boolean = false; AMaxUploadSize: integer = 128): ID2BridgeItemHTMLInput;
begin
 Result:= TD2BridgeItemHTMLUpload.Create(TD2BridgeClass(FBaseClass));
 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Upload')
 else
  Result.ItemID:= AItemID;
 Result.CaptionUpload:= ACaption;
 if AMaxFiles = 0 then
  Result.MaxFiles:= 12;
 Result.MaxFiles:= AMaxFiles;
 if AMaxFileSize = 0 then
  Result.MaxFileSize := 20;
 Result.MaxFileSize:= AMaxFileSize;
 if AMaxUploadSize = 0 then
  AMaxUploadSize:= 128;
 Result.MaxUploadSize:= AMaxUploadSize;
 Result.InputVisible:= AInputVisible;
 Result.CSSInput:= ACSSInput;
 Result.CSSButtonUpload:= ACSSButtonUpload;
 Result.CSSButtonClear:= ACSSButtonClear;
 Result.IconButtonUpload:= AFontICOUpload;
 Result.IconButtonClear:= AFontICOClear;

 if AAllowedFileTypes = '*' then
  Result.AllowedFileTypes.Text:= ''
 else
  Result.AllowedFileTypes.Text:= AAllowedFileTypes;

 Result.ShowFinishMessage:= AShowFinishMessage;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.VCLObj: ID2BridgeItemVCLObj;
var
 FItemID: string;
begin
 Result := TD2BridgeItemVCLObj.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('D2BridgeItemVCLObj');
 FD2BridgeItems.Add(Result);
end;

function TItemAdd.VCLObj(VCLItem: TObject; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj;
begin
 if not (TD2BridgeClass(FBaseClass)).D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
   Exit;

 Result:= VCLObj;
 Result.Item:= TComponent(VCLItem);
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= HTMLExtras;
 Result.HTMLStyle:= HTMLStyle;
end;

function TItemAdd.VCLObj(VCLItem: TObject; APopupMenu: TPopupMenu;
  ACSSClass: String; HTMLExtras: String; HTMLStyle: String
  ): ID2BridgeItemVCLObj;
begin
 if not (TD2BridgeClass(FBaseClass)).D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 Result:= VCLObj(VCLItem, ACSSClass, HTMLExtras, HTMLStyle);
 if Assigned(APopupMenu) then
 Result.PopupMenu:= APopupMenu;
end;

function TItemAdd.VCLObjHidden(VCLItem: TObject): ID2BridgeItemVCLObj;
begin
 if not (TD2BridgeClass(FBaseClass)).D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 Result:= VCLObj;
 Result.Hidden:= true;
 Result.Item:= TComponent(VCLItem);
end;

{$IFNDEF FMX}
function TItemAdd.WYSIWYGEditor(ADataSource: TDataSource; ADataFieldName: string; AAirMode: Boolean; AItemID: string;
  ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLWYSIWYGEditor;
begin
 result:= WYSIWYGEditor(ADataSource, ADataFieldName, AItemID, 0, ACSSClass, AHTMLExtras, AHTMLStyle);

 result.PrismWYSIWYGEditor.AirMode:= AAirMode;
end;
{$ENDIF}

function TItemAdd.WYSIWYGEditor(TextVCLItem: TComponent; AAirMode: Boolean; ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLWYSIWYGEditor;
begin
 result:= WYSIWYGEditor(TextVCLItem, 0, ACSSClass, HTMLExtras, HTMLStyle);

 result.PrismWYSIWYGEditor.AirMode:= AAirMode;
end;

{$IFNDEF FMX}
function TItemAdd.WYSIWYGEditor(ADataSource: TDataSource; ADataFieldName, AItemID: string; AHeight: integer; ACSSClass, AHTMLExtras,
  AHTMLStyle: String): ID2BridgeItemHTMLWYSIWYGEditor;
begin
 Result:= TD2BridgeItemHTMLWYSIWYGEditor.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('WYSIWYGEditor')
 else
  Result.ItemID:= AItemID;

 Result.PrismWYSIWYGEditor.DataWare.DataSource:= ADataSource;
 Result.PrismWYSIWYGEditor.DataWare.FieldName:= ADataFieldName;

 Result.PrismWYSIWYGEditor.Height:= AHeight;

 FD2BridgeItems.Add(Result);
end;
{$ENDIF}

function TItemAdd.WYSIWYGEditor(TextVCLItem: TComponent; AHeight: integer; ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLWYSIWYGEditor;
begin
 Result:= TD2BridgeItemHTMLWYSIWYGEditor.Create(TD2BridgeClass(FBaseClass));

 Result.ItemID:= TextVCLItem.Name;
 Result.TextVCLComponent:= TextVCLItem;

 Result.PrismWYSIWYGEditor.Height:= AHeight;

 FD2BridgeItems.Add(Result);
end;

{$IFDEF FPC}
function TItemAdd.LCLObj: ID2BridgeItemVCLObj;
begin
 result:= VCLObj;
end;

function TItemAdd.LCLObj(VCLItem: TObject; ACSSClass: String;
  HTMLExtras: String; HTMLStyle: String): ID2BridgeItemVCLObj;
begin
 result:= VCLObj(VCLItem, ACSSClass, HTMLExtras, HTMLStyle)
end;

function TItemAdd.LCLObj(VCLItem: TObject; APopupMenu: TPopupMenu;
  ACSSClass: String; HTMLExtras: String; HTMLStyle: String
  ): ID2BridgeItemVCLObj;
begin
 result:= VCLObj(VCLItem, APopupMenu, ACSSClass, HTMLExtras, HTMLStyle)
end;

function TItemAdd.LCLObj(VCLItem: TObject; AValidationGroup: Variant;
  ARequired: Boolean; ACSSClass: String; HTMLExtras: String; HTMLStyle: String
  ): ID2BridgeItemVCLObj;
begin
 result:= VCLObj(VCLItem, AValidationGroup, ARequired, ACSSClass, HTMLExtras, HTMLStyle)
end;

function TItemAdd.LCLObjHidden(VCLItem: TObject): ID2BridgeItemVCLObj;
begin
 result:= VCLObjHidden(VCLItem)
end;
{$ENDIF}

function TItemAdd.VCLObj(VCLItem: TObject; AValidationGroup: Variant; ARequired: Boolean; ACSSClass: String = ''; HTMLExtras: String = ''; HTMLStyle: String = ''): ID2BridgeItemVCLObj;
begin
  if not (TD2BridgeClass(FBaseClass)).D2BridgeManager.SupportsVCLClass(VCLItem.ClassType) then
  Exit;

 Result:= VCLObj(VCLItem, ACSSClass, HTMLExtras, HTMLStyle);
 Result.Required:= ARequired;
 Result.ValidationGroup:= AValidationGroup;
end;

function TItemAdd.Link(ComponentHTMLElement: TComponent; AOnClick: TNotifyEvent; Href, OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 Result:= Link(ComponentHTMLElement, Href, AOnClick, OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle);
end;

function TItemAdd.Link(AText, Href, AItemID, OnClickCallBack: string; AOnClick: TNotifyEvent; AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 result:= Link(AText, AOnClick, AItemID, Href, OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle);
end;

function TItemAdd.Link(AText: string; AOnClick: TNotifyEvent; AItemID, Href, OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 Result:= TD2BridgeItemHTMLLink.Create(TD2BridgeClass(FBaseClass));

// if Href = '' then
//  Href:= '#';

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Link')
 else
  Result.ItemID:= AItemID;

 Result.PrismLink.Text:= AText;
 Result.PrismLink.href:= Href;
 Result.PrismLink.OnClick := AOnClick;
 Result.PrismLink.OnClickCallBack := OnClickCallBack;
 Result.PrismLink.Hint := AHint;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.LinkCallBack(ComponentHTMLElement: TComponent; OnClickCallBack, AHint, ACSSClass, AHTMLExtras, AHTMLStyle: String): ID2BridgeItemHTMLLink;
begin
 Result:= TD2BridgeItemHTMLLink.Create(TD2BridgeClass(FBaseClass));

 if Assigned(ComponentHTMLElement) then
 begin
  Result.ItemID:= ComponentHTMLElement.Name;
  Result.PrismLink.LabelHTMLElement:= ComponentHTMLElement;
 end;

 if Result.ItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('Link');

// if Href = '' then
//  Href:= '#';

// Result.PrismLink.href:= Href;
// Result.PrismLink.OnClick := AOnClick;
 Result.PrismLink.OnClickCallBack := OnClickCallBack;
 Result.PrismLink.Hint := AHint;
 Result.CSSClasses:= ACSSClass;
 Result.HTMLExtras:= AHTMLExtras;
 Result.HTMLStyle:= AHTMLStyle;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.MainMenu(MainMenu: {$IFNDEF FMX}TMainMenu{$ELSE}TMenuBar{$ENDIF}): ID2BridgeItemHTMLMainMenu;
begin
 Result := TD2BridgeItemHTMLMainMenu.Create(TD2BridgeClass(FBaseClass));
 Result.ItemID:= MainMenu.Name;

 Result.Options.VCLComponent:= MainMenu;

 FD2BridgeItems.Add(Result);
end;

function TItemAdd.MarkdownEditor(TextVCLItem: TComponent;  AHeight: integer; ACSSClass, HTMLExtras, HTMLStyle: String): ID2BridgeItemHTMLMarkDownEditor;
begin
 Result:= TD2BridgeItemHTMLMarkDownEditor.Create(TD2BridgeClass(FBaseClass));

 Result.ItemID:= TextVCLItem.Name;
 Result.TextVCLComponent:= TextVCLItem;

 Result.PrismMarkDownEditor.Height:= AHeight;

 FD2BridgeItems.Add(Result);
end;


{$IFNDEF FMX}
function TItemAdd.MarkdownEditor(ADataSource: TDataSource; ADataFieldName: string; AItemID: string = ''; AHeight: integer = 0; ACSSClass: String = ''; AHTMLExtras: String = ''; AHTMLStyle: String = ''): ID2BridgeItemHTMLMarkDownEditor;
begin
 Result:= TD2BridgeItemHTMLMarkDownEditor.Create(TD2BridgeClass(FBaseClass));

 if AItemID = '' then
  Result.ItemID:= TD2BridgeClass(FBaseClass).CreateItemID('MarkDownEditor')
 else
  Result.ItemID:= AItemID;

 Result.PrismMarkDownEditor.DataWare.DataSource:= ADataSource;
 Result.PrismMarkDownEditor.DataWare.FieldName:= ADataFieldName;

 Result.PrismMarkDownEditor.Height:= AHeight;

 FD2BridgeItems.Add(Result);
end;
{$ENDIF}


function TItemAdd.Col(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + 'col');

 result:= Col(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col1(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col1);

 result:= Col1(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col10(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col10);

 result:= Col10(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col11(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col11);

 result:= Col11(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col12(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col12);

 result:= Col12(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col2(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col2);

 result:= Col2(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col3(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col3);

 result:= Col3(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col4(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col4);

 result:= Col4(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col5(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col4);

 result:= Col4(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col6(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col6);

 result:= Col6(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col7(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col7);

 result:= Col7(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col8(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col8);

 result:= Col8(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.Col9(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.col9);

 result:= Col9(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.ColAuto(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colauto);

 result:= ColAuto(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

function TItemAdd.ColFull(AAutoResponsive: boolean; ACSSClass, AItemID,
  AHTMLExtras, AHTMLStyle, AHTMLTag: String): ID2BridgeItemHTMLRow;
var
 vCSSCallCol: string;
begin
 if not AAutoResponsive then
  vCSSCallCol:= Trim(ACSSClass + ' ' + D2Bridge.HTML.CSS.Col.colfull);

 result:= ColFull(vCSSCallCol, AItemID, AHTMLExtras, AHTMLStyle, AHTMLTag);
end;

end.