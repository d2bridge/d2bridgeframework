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

unit D2Bridge.Prism.Form;

interface

uses
  Classes,
{$IFDEF HAS_UNIT_SYSTEM_THREADING}
  System.Threading,
{$ENDIF}
  Prism.Forms,
  D2Bridge, D2Bridge.Prism, D2Bridge.Interfaces, D2Bridge.BaseClass, D2Bridge.Forms,
  Prism.Forms.Controls, Prism.CSS.Bootstrap.Button, Prism.Types;

type
 TPrismControl = Prism.Forms.Controls.TPrismControl;
 TButtonModel = Prism.CSS.Bootstrap.Button.TButtonModelClass;
 TPrismFieldType = Prism.Types.TPrismFieldType;
 TPrismFieldModel = Prism.Types.TPrismFieldModel;

type
 TD2BridgePrismForm = class(TPrismForm, ID2BridgeFrameworkForm)
  private
   FBaseClass: TD2BridgeClass;
  public
   constructor Create(AOwner: TComponent; D2BridgePrismFramework: TObject); virtual;
   destructor Destroy; override;

   procedure Hide;
   procedure Show; override;

   function GetBaseClass: TObject;
   procedure SetBaseClass(BaseClass: TObject);
   function D2BridgeForm: TD2BridgeForm;
   function D2Bridge: TD2Bridge;
   Procedure AddNested(AD2BridgeForm: TObject);

   property BaseClass: TD2BridgeClass read FBaseClass;
 end;


 TD2BridgePrismFormClass = class of TD2BridgePrismForm;


implementation

{$IFDEF MSWINDOWS}
uses
  Windows;
{$ENDIF}


{ TD2BridgePrismForm }

procedure TD2BridgePrismForm.AddNested(AD2BridgeForm: TObject);
var
 AD2BridgeClassForm: TD2BridgeClass;
begin
 D2Bridge.AddNested(TD2BridgeForm(AD2BridgeForm));

 AD2BridgeClassForm:= TD2BridgeForm(AD2BridgeForm).D2Bridge;
 self.Controls.AddRange((AD2BridgeClassForm.FrameworkForm as TD2BridgePrismForm).Controls);
end;

constructor TD2BridgePrismForm.Create(AOwner: TComponent; D2BridgePrismFramework: TObject);
var
 I: Integer;
begin
 Inherited Create(Aowner);

 SetBaseClass(TD2BridgePrismFramework(D2BridgePrismFramework).BaseClass);

 Session:= TD2BridgePrismFramework(D2BridgePrismFramework).BaseClass.PrismSession;

 TemplateMasterHTMLFile:= TD2BridgePrismFramework(D2BridgePrismFramework).TemplateMasterHTMLFile;
 TemplatePageHTMLFile:= TD2BridgePrismFramework(D2BridgePrismFramework).TemplatePageHTMLFile;

 //Include Controls for Nested Forms
 for I := 0 to D2Bridge.NestedCount-1 do
 begin
  self.Controls.AddRange((D2Bridge.Nested(I).FrameworkForm as TD2BridgePrismForm).Controls);
 end;
end;

function TD2BridgePrismForm.D2Bridge: TD2Bridge;
begin
 Result:= D2BridgeForm.D2Bridge;
end;

function TD2BridgePrismForm.D2BridgeForm: TD2BridgeForm;
begin
 Result:= TD2BridgeForm(FBaseClass.FormAOwner);
end;

destructor TD2BridgePrismForm.Destroy;
begin
 inherited;
end;

function TD2BridgePrismForm.GetBaseClass: TObject;
begin
 Result:= FBaseClass;
end;

procedure TD2BridgePrismForm.Hide;
begin
 onFormUnload;

 Session.D2BridgeForms.Remove(Session.D2BridgeBaseClassActive);

 if Session.D2BridgeForms.Count > 0 then
 begin
  Session.D2BridgeBaseClassActive:= Session.D2BridgeForms.Last;

  TD2BridgeForm(TD2BridgeClass(Session.D2BridgeBaseClassActive).FormAOwner).Show;
 end;
end;

procedure TD2BridgePrismForm.SetBaseClass(BaseClass: TObject);
begin
 FBaseClass:= TD2BridgeClass(BaseClass);
end;

procedure TD2BridgePrismForm.Show;
begin
 Inherited;
end;


end.