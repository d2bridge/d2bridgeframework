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

unit D2Bridge.Messages;

interface

  function swalPrompt(pTitulo, pTexto, pEditDest : String; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNFAZERLOGOUT'): String;
  function swalConfirm(pTitulo, pTexto : String; pTipo: String = 'success'; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNCONFIRMAR'; pEventoNao : String = 'BTNCANCELAR'): String;
  function swalAlert(pTitulo, pTexto: String): String;
  function swalAlertTimer(pTitulo, pTexto: String; Timer:Longint =1500; pTipo: String = 'success'; pEventoSim : String = ''): String;
  function swalError(pTitulo, pTexto: String): String;
  function swalSuccess(pTitulo, pTexto: String): String;

  function swalError_HTML(pTitulo, pTexto: String): String;

  function swalSuccessTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
  function swalErrorTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String; pExibeBotao:Boolean = false): String;

  Function Get_Lib_CSS_SweetAlert2 :String;
  Function Get_Lib_JS_SweetAlert2 :String;

implementation

uses
  Classes, SysUtils;

Function Get_Lib_CSS_SweetAlert2 :String;
begin
  Result := '<link rel="stylesheet" href="css/sweetalert2.min.css" />';
end;

Function Get_Lib_JS_SweetAlert2 :String;
Begin
  Result := '  <script src="js/sweetalert2.min.js"></script>';
End;


function swalPrompt(pTitulo, pTexto, pEditDest : String; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNFAZERLOGOUT'): String;
var
  strAux : String;
begin

  strAux := 'swal.fire({ ';
  strAux := strAux + '    title: "' + pTitulo + '", ';
  strAux := strAux + '    text: "' + pTexto + '", ';
  strAux := strAux + '    type: "input", ';
  strAux := strAux + '    showCancelButton: true, ';
  strAux := strAux + '    closeOnConfirm: true,';
  strAux := strAux + '    confirmButtonText: "' + pBotaoSim + '", ';
  strAux := strAux + '    cancelButtonText: "' + pBotaoNao + '", ';
  strAux := strAux + '    inputPlaceholder: "Digite algo"';
  strAux := strAux + '  }, function (inputValue) {';
  strAux := strAux + 'if (inputValue === false) return false;';
  strAux := strAux + 'if (inputValue === "") {';
  strAux := strAux + '  swal("Atenção", "Digite alguma coisa!","error");';
  strAux := strAux + '  return false';
  strAux := strAux + '}';
  strAux := strAux + 'document.getElementById(''' +   pEditDest + ''').value= inputValue;';
  strAux := strAux + 'AddChangedControl(''' + pEditDest + ''');';

  strAux := strAux + '});';

  Result := strAux;
end;

function swalConfirm(pTitulo, pTexto : String; pTipo: String = 'success'; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNCONFIRMAR'; pEventoNao : String = 'BTNCANCELAR'): String;
var
  strAux : String;
begin

    strAux := 'swal.fire({ ';
    strAux := strAux + '   title:         "' + pTitulo + '", ';
    strAux := strAux + '   text:         "' + pTexto + '", ';
    strAux := strAux + '   type:         "' + pTipo+'", ';
    strAux := strAux + '   showCancelButton:   ';
    if (pBotaoNao = '') then
      strAux := strAux + '     false, '
    else
      strAux := strAux + '     true, ';
    strAux := strAux + '   confirmButtonColor:   "#135893", ';
    strAux := strAux + '   cancelButtonColor:   "#d92e29", ';
    strAux := strAux + '   confirmButtonText:   "' + pBotaoSim + '", ';
    strAux := strAux + '   cancelButtonText:   "' + pBotaoNao + '", ';

    strAux := strAux + ' closeOnConfirm: false, ';
    strAux := strAux + ' closeOnCancel: false   ';


    strAux := strAux + ' }).then((result) => { ';
    strAux := strAux + '   if (result.value) { ';
    strAux := strAux + '     '+ pEventoSim + '.click(); }';
    strAux := strAux + '   else if (result.dismiss === "cancel") { ';
    if pEventoNao <> '' then
    strAux := strAux + '     '+ pEventoNao + '.click(); ';
    strAux := strAux + '    }';
    strAux := strAux + '  }); ';

    Result := strAux;
end;

function swalAlert(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := 'swal("' + pTitulo + '", "' + pTexto + '", "warning");';

  Result := strAux;
end;

function swalAlertTimer(pTitulo, pTexto: String; Timer:Longint =1500; pTipo: String = 'success'; pEventoSim : String = ''): String;
var
  strAux : String;
begin
  Result:=
   ' Swal.fire({                                                    ' +
   '   icon: '''+pTipo+''',                                         ' +
   '   title: '+QuotedStr(pTitulo)+',                               ' +
   '   text: '+QuotedStr(pTexto)+',                                 ' +
   '   showConfirmButton: false,                                    ' +
   '   timer: '+IntToStr(Timer)+'                                   ' +
   ' }).then((result) => {                                          ' +
   '     '+ pEventoSim + '.click(); });';
end;

function swalSuccessTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
var
  strAux : String;
begin

  strAux := strAux + ' swal.fire({                                          ';
  strAux := strAux + '   title: "' + pTitulo + '",                          ';
  strAux := strAux + '   text: "'+pTexto+'",                                ';
  strAux := strAux + '   icon: ''success'',                                 ';
  strAux := strAux + '   timer: '+IntToStr(Timer)+',                        ';
  strAux := strAux + '   showConfirmButton: false                           ';
  strAux := strAux + ' }).then(function() {                                 ';
  strAux := strAux + '   document.getElementById("'+SetFocus+'").focus();   ';
  strAux := strAux + ' });                                                  ';

  Result := strAux;


end;

function swalErrorTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String; pExibeBotao:Boolean = false): String;
var
  strAux : String;
begin
  strAux:= '';
  strAux := strAux + ' swal.fire({                                          ';
  strAux := strAux + '   title: "' + pTitulo + '",                          ';
  strAux := strAux + '   text: "'+pTexto+'",                                ';
  strAux := strAux + '   icon: ''error'',                                   ';
  strAux := strAux + '   timer: '+IntToStr(Timer)+',                        ';
  if pExibeBotao then
  strAux := strAux + '   showConfirmButton: true                            '
  else
  strAux := strAux + '   showConfirmButton: false                           ';
  strAux := strAux + ' }).then(function() {                                 ';
  strAux := strAux + '   document.getElementById("'+SetFocus+'").focus();   ';
  strAux := strAux + ' });                                                  ';

  Result := strAux;

end;

function swalError(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := 'swal.fire("' + pTitulo + '", "' + pTexto + '", "error");';

  Result := strAux;
end;

function swalError_HTML(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := strAux + ' Swal.fire({                                                    ';
  strAux := strAux + '  title: ''<strong>'+pTitulo+'</strong>'',                      ';
  strAux := strAux + '  icon: ''error'',                                              ';
  strAux := strAux + '  html:                                                         ';
  strAux := strAux + '    '+pTexto+',                                                 ';
  strAux := strAux + '  showCancelButton: true,                                       ';
  strAux := strAux + '  focusConfirm: false,                                          ';
  strAux := strAux + '  confirmButtonText:                                            ';
  strAux := strAux + '    ''<i class="fa fa-thumbs-up"></i> OK'',                     ';
  strAux := strAux + '  confirmButtonAriaLabel: ''OK'',                               ';
//  strAux := strAux + '  cancelButtonText:                                             ';
//  strAux := strAux + '    '<i class="fa fa-thumbs-down"></i>',                        ';
//  strAux := strAux + '  cancelButtonAriaLabel: 'Thumbs down'                          ';
  strAux := strAux + '})                                                              ';

  Result := strAux;
end;

function swalSuccess(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := 'swal.fire("' + pTitulo + '", "' + pTexto + '", "success");';

  Result := strAux;
end;



end.