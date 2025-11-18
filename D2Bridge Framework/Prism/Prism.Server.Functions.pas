{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Server.Functions;

interface

uses
  SysUtils, Classes, D2Bridge.JSON, RTTI,
  Prism.Interfaces;


type
  TPrismServerFunctions = class(TDataModule)
   strict private
    procedure Exec_FormEvent(varEventName, varPrismForm, varParametersStr, varLockClient: TValue);
    procedure Exec_CallBack(varPrismCallBack, varPrismSession, varParametersStr, varLockClient: TValue);
    procedure Exec_CallEvent(varPrismCallEvent, varPrismSession, varParametersStr, varLockClient: TValue);
    procedure Exec_OnShowPopup(varPrismForm, varPrismSession, varParametersStr, varLockClient: TValue);
    procedure Exec_OnClosePopup(varPrismForm, varPrismSession, varParametersStr, varLockClient: TValue);
    procedure Exec_ComponentFocused(varPrismForm, varPrismSession, varPrismControl: TValue);


   private
    function ProcessParameters(AParameters: string): TStringList;
    function ProcessEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean): string;
    procedure UnLockClient(Session: IPrismSession);
   public
    procedure ExecEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean);
    function GetFromEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean): string;
    function CallBack(UUID, Token, FormUUID, CallBackID, Parameters: String; LockClient: Boolean): string;
  end;

implementation

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
{$IFDEF FMX}
  FMX.Forms,
{$ELSE}
  Forms,
{$ENDIF}
  Prism.BaseClass, Prism.Session, Prism.Session.Helper, Prism.Forms, Prism.Events, Prism.CallBack,
  Prism.Types, D2Bridge.BaseClass, D2Bridge.Forms, D2Bridge.Util, Prism.ButtonedEdit;


{ TPrismServerFunctions }

function TPrismServerFunctions.CallBack(UUID, Token, FormUUID, CallBackID, Parameters: String; LockClient: Boolean): string;
var
 PrismSession: TPrismSession;
 PrismForm: TPrismForm;
 ParamStrings: TStrings;
 vPrismCallBack: TPrismCallBack;
 I: Integer;
 ResulThread: string;
begin
 Result:= 'ERROR';
 ResulThread:= '';
 if (UUID <> '') and (Token <> '') and (FormUUID <> '') and (CallBackID <> '') then
 begin
  try
   if PrismBaseClass.Sessions.Exist(UUID) then
   begin
    ParamStrings:= ProcessParameters(Parameters);

    PrismSession:= (PrismBaseClass.Sessions.Item[UUID] as TPrismSession);
    //PrismForm:= (PrismSession.ActiveForm as TPrismForm);
    PrismForm:= (PrismSession.ActiveFormByFormUUID(FormUUID) as TPrismForm);

    if (PrismForm = nil) or (PrismSession.Destroying) then
    begin
     ParamStrings.Free;
     abort;
    end;

    if (UUID = PrismSession.UUID) and (Token = PrismSession.Token) and (FormUUID = PrismForm.FormUUID) then
    begin
     for I := 0 to PrismSession.CallBacks.Items.Count -1 do
     if PrismSession.CallBacks.Items.ToArray[I].Value.ID = CallBackID then
     begin
      vPrismCallBack:= (PrismSession.CallBacks.Items.ToArray[I].Value as TPrismCallBack);
      break;
     end;

     if Assigned(vPrismCallBack) then
     begin
      //Exec_CallBack(vPrismCallBack, PrismSession, ParamStrings.Text, LockClient);
      PrismSession.ExecThread(False,
       Exec_CallBack,
       TValue.From<TPrismCallBack>(vPrismCallBack),
       TValue.From<TPrismSession>(PrismSession),
       TValue.From<String>(ParamStrings.Text),
       TValue.From<Boolean>(LockClient)
      );
     end;

     Result:= '';
    end;

    ParamStrings.Free;
   end;
  except
  end;
 end;

end;

procedure TPrismServerFunctions.ExecEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean);
begin
 ProcessEvent(UUID, Token, FormUUID, ID, EventID, Parameters, LockClient);
end;

procedure TPrismServerFunctions.Exec_CallBack(varPrismCallBack, varPrismSession, varParametersStr, varLockClient: TValue);
var
 vPrismCallBack: TPrismCallBack;
 vPrismSession: TPrismSession;
 vParamStrings: TStrings;
 vLockClient: Boolean;
 vResult: string;
begin
 vParamStrings:= TStringlist.Create;

 try
  try
   vParamStrings.Text:= varParametersStr.AsString;
   vPrismSession:= (varPrismSession.AsObject as TPrismSession);
   vPrismCallBack:= (varPrismCallBack.AsObject as TPrismCallBack);
   vLockClient:= varLockClient.AsBoolean;

   //Result is future implementation
   vResult:= vPrismCallBack.Execute(vParamStrings);
  except
  end;
 finally
  try
   if vLockClient then
    UnLockClient(vPrismSession);
  except
  end;

  vParamStrings.Free;
 end;
end;

procedure TPrismServerFunctions.Exec_CallEvent(varPrismCallEvent,
  varPrismSession, varParametersStr, varLockClient: TValue);
var
 vParamStrings: TStrings;
 vPrismSession: TPrismSession;
 vPrismControlEvent: TPrismControlEvent;
 vLockClient: Boolean;
begin
 vParamStrings:= TStringList.Create;

 try
  try
   vPrismSession:= (varPrismSession.AsObject as TPrismSession);
   vParamStrings.Text:= varParametersStr.AsString;
   vPrismControlEvent:= (varPrismCallEvent.AsObject as TPrismControlEvent);
   vLockClient:= varLockClient.AsBoolean;

   vPrismControlEvent.CallEvent(vParamStrings);
  except on E: Exception do
   if not SameText(e.Message, 'Operation aborted') then
    vPrismSession.DoException(vPrismControlEvent.PrismControl as TObject, E, vPrismControlEvent.EventTypeName);
  end;
 finally
  try
   if vLockClient then
    UnLockClient(vPrismSession);
  except
  end;

  vParamStrings.Free;
 end;

end;

procedure TPrismServerFunctions.Exec_ComponentFocused(varPrismForm, varPrismSession, varPrismControl: TValue);
var
 vPrismForm: TPrismForm;
 vPrismControl: TPrismControl;
 vPrismSession: TPrismSession;
begin
 try
  vPrismForm:= (varPrismForm.AsObject as TPrismForm);
  vPrismControl:= (varPrismControl.AsObject as TPrismControl);
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);

  try
    vPrismForm.FocusedControl:= vPrismControl;
  except on E: Exception do
    vPrismSession.DoException(vPrismControl as TObject, E, 'FocusControl');
  end;
 except
 end;
end;

procedure TPrismServerFunctions.Exec_FormEvent(varEventName, varPrismForm,
  varParametersStr, varLockClient: TValue);
var
 I: Integer;
 vPrismForm: TPrismForm;
 vLockClient: Boolean;
 vParamStrings: TStrings;
 vPrismSession: TPrismSession;
 vEventName: string;
begin
 vParamStrings:= TStringlist.Create;

 try
  vEventName:= varEventName.AsString;
  vParamStrings.Text:= varParametersStr.AsString;
  vPrismForm:= (varPrismForm.AsObject as TPrismForm);
  vPrismSession:= vPrismForm.Session;
  vLockClient:= varLockClient.AsBoolean;

  if SameText(vEventName, 'AfterPageLoad') then
   vPrismForm.OnAfterPageLoad(vParamStrings)
  else
   if SameText(vEventName, 'PageResize') then
    vPrismForm.OnPageResize(vParamStrings)
   else
    if SameText(vEventName, 'OrientationChange') then
     vPrismForm.OnOrientationChange(vParamStrings)
    else
     if SameText(vEventName, 'CameraInitialize') then
      vPrismSession.DoFormCameraInitialize(vPrismForm, vParamStrings);

  vPrismSession.DoHeartBeat;
  vPrismSession.SetIdleSeconds(0);

 finally
  try
   if vLockClient then
    UnLockClient(vPrismSession);
  except
  end;

  vParamStrings.Free;
 end;
end;

procedure TPrismServerFunctions.Exec_OnClosePopup(varPrismForm,
  varPrismSession, varParametersStr, varLockClient: TValue);
var
 vPrismForm: TPrismForm;
 vPrismSession: TPrismSession;
 vLockClient: Boolean;
 vNamePopup: string;
begin
 try
  vPrismForm:= TPrismForm(varPrismForm.AsObject);
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);
  vLockClient:= varLockClient.AsBoolean;
  vNamePopup:= varParametersStr.AsString;

  try
   if Assigned(vPrismForm.OnClosePopup) then
    vPrismForm.OnClosePopup(vNamePopup);
  except on E: Exception do
   try
    vPrismSession.DoException(vPrismForm.D2BridgeForm.ActiveControl, E, 'ClosePopup');
   except
   end;
  end;

  try
   vPrismForm.D2BridgeForm.DoPopupClosed(vNamePopup);
  except on E: Exception do
   try
    vPrismSession.DoException(vPrismForm.D2BridgeForm.ActiveControl, E, 'ClosedPopup');
   except
   end;
  end;
 finally
  try
   if vLockClient then
    UnLockClient(vPrismSession);
  except
  end;
 end;
end;

procedure TPrismServerFunctions.Exec_OnShowPopup(varPrismForm, varPrismSession, varParametersStr, varLockClient: TValue);
var
 vPrismForm: TPrismForm;
 vPrismSession: TPrismSession;
 vLockClient: Boolean;
 vNamePopup: string;
begin
 try
  vPrismForm:= TPrismForm(varPrismForm.AsObject);
  vPrismSession:= (varPrismSession.AsObject as TPrismSession);
  vLockClient:= varLockClient.AsBoolean;
  vNamePopup:= varParametersStr.AsString;

  try
   if Assigned(vPrismForm.OnShowPopup) then
    vPrismForm.OnShowPopup(vNamePopup);
  except on E: Exception do
   vPrismSession.DoException(vPrismForm.D2BridgeForm.ActiveControl, E, 'ShowPopup');
  end;

  try
   vPrismForm.D2BridgeForm.DoPopupOpened(vNamePopup);
  except on E: Exception do
   vPrismSession.DoException(vPrismForm.D2BridgeForm.ActiveControl, E, 'ShowedPopup');
  end;
 finally
  try
   if vLockClient then
    UnLockClient(vPrismSession);
  except
  end;
 end;
end;

function TPrismServerFunctions.GetFromEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean): string;
begin
 Result:= ProcessEvent(UUID, Token, FormUUID, ID, EventID, Parameters, LockClient);
end;

function TPrismServerFunctions.ProcessEvent(UUID, Token, FormUUID, ID, EventID, Parameters: String; LockClient: Boolean): string;
var
 PrismSession: TPrismSession;
 PrismForm: TPrismForm;
 FEvent: TPrismControlEvent;
 ParamStrings: TStrings;
 vComponentID, PrismComponentsStatusStr: String;
 PrismComponentsJSONArray: TJSONArray;
 I, J, Z, X: Integer;
 //vFocusedPrismControl: IPrismControl;
 ResulThread: string;
 vComponentDisableIgnore: boolean;
begin
 Result:= '';
 vComponentDisableIgnore:= false;
 FEvent:= nil;
 PrismForm:= nil;
 ParamStrings:= nil;
 PrismComponentsJSONArray:= nil;

 if (UUID <> '') and (Token <> '') and (FormUUID <> '') and (ID <> '') and (EventID <> '') then
 begin
  if PrismBaseClass.Sessions.Exist(UUID) then
  begin
   try
    ParamStrings:= ProcessParameters(Parameters);

    PrismSession:= (PrismBaseClass.Sessions.Item[UUID] as TPrismSession);
    //PrismForm:= (PrismSession.ActiveForm as TPrismForm);
    PrismForm:= (PrismSession.ActiveFormByFormUUID(FormUUID) as TPrismForm);

    if (PrismForm = nil) or (PrismSession.Destroying) then
    begin
     ParamStrings.Free;
     Exit;
    end;


    //Checa se é o form atual
    if (FormUUID = PrismForm.FormUUID) then
    begin
     //Processa ComponentsState
     if (ParamStrings.Text <> '') then
     begin
      PrismComponentsStatusStr:= ParamStrings.Values['PrismComponentsStatus'];
      if PrismComponentsStatusStr <> '' then
      begin
       PrismForm.onComponentsUpdating;
       PrismComponentsJSONArray:= TJSONObject.ParseJSONValue(PrismComponentsStatusStr) as TJSONArray;
       if PrismComponentsJSONArray <> nil then
       begin
        for J := 0 to PrismComponentsJSONArray.Count - 1 do
        for I := 0 to PrismForm.Controls.Count - 1 do
        if AnsiUpperCase(PrismForm.Controls[I].NamePrefix) = AnsiUpperCase(TJSONObject(PrismComponentsJSONArray.Items[J]).GetValue('id').Value) then
        begin
         if ((PrismForm.Controls[I].Form as TPrismForm) = PrismForm) or
            ((PrismForm.Controls[I].Form as TPrismForm).D2BridgeForm.Showing) then //Nested
          if PrismForm.Controls[I].Enabled and PrismForm.Controls[I].Visible and not PrismForm.Controls[I].ReadOnly then
          begin
           try
            PrismForm.Controls[I].ProcessComponentState(TJSONObject(PrismComponentsJSONArray.Items[J]));
           except
            on E: Exception do
            PrismSession.DoException(PrismForm.Controls[I] as TPrismControl, E, 'ProcessComponentState');
           end;

           try
            PrismForm.D2BridgeForm.DoUpdateD2BridgeControls(PrismForm.Controls[I] as TPrismControl);
           except
            on E: Exception do
            PrismSession.DoException(PrismForm.Controls[I] as TPrismControl, E, 'UpdateD2BridgeControls');
           end;
          end;
         break;
        end;
        PrismComponentsJSONArray.Free;
       end;
       PrismForm.onComponentsUpdated;
      end;
     end;

     //Eventos do Form
     if (ID = PrismForm.FormUUID) and (FormUUID = PrismForm.FormUUID) then
     begin
      if EventID = 'UpdateD2BridgeControls' then
      begin

      end;

      if (EventID = 'AfterPageLoad') or
         (EventID = 'PageResize') or
         (EventID = 'OrientationChange') or
         (EventID = 'CameraInitialize') then
      begin
       PrismSession.ExecThread(false,
         Exec_FormEvent,
         TValue.From<String>(EventID),
         TValue.From<TPrismForm>(PrismForm),
         TValue.From<String>(ParamStrings.Text),
         TValue.From<Boolean>(LockClient)
       );
      end;

      if EventID = 'OnShowPopup' then
      begin
       PrismSession.ExecThread(false,
         Exec_OnShowPopup,
         TValue.From<TPrismForm>(PrismForm),
         TValue.From<TPrismSession>(PrismSession),
         TValue.From<String>(ParamStrings.Values['popupname']),
         TValue.From<Boolean>(LockClient)
       );
      end;

      if EventID = 'OnClosePopup' then
      begin
       PrismSession.ExecThread(false,
         Exec_OnClosePopup,
         TValue.From<TPrismForm>(PrismForm),
         TValue.From<TPrismSession>(PrismSession),
         TValue.From<String>(ParamStrings.Values['popupname']),
         TValue.From<Boolean>(LockClient)
       );
      end;

      if EventID = 'ComponentFocused' then
      begin
       vComponentID := ParamStrings.Values['FocusedID'];
       for I := 0 to PrismForm.Controls.Count - 1 do
       if SameText(PrismForm.Controls[I].NamePrefix, vComponentID) then
       begin
        if PrismForm.Controls[I].Enabled and PrismForm.Controls[I].Visible and not PrismForm.Controls[I].ReadOnly then
        begin
         //Exec_ComponentFocused(PrismForm, PrismSession, PrismForm.Controls[I] as TPrismControl);
         PrismSession.ExecThread(false,
           Exec_ComponentFocused,
           TValue.From<TPrismForm>(PrismForm),
           TValue.From<TPrismSession>(PrismSession),
           TValue.From<TPrismControl>(PrismForm.Controls[I] as TPrismControl)
         );

         if not PrismForm.Controls[I].Updatable then
          vComponentDisableIgnore:= true;
        end else
         vComponentDisableIgnore:= true;
       end;
      end;
     end else
     begin
      for I := 0 to PrismForm.Controls.Count - 1 do
      begin
       for Z := 0 to PrismForm.Controls[I].Events.Count-1 do
       begin
        if PrismForm.Controls[I].Events.Item(Z).EventID = EventID then
        begin
         if
          {$IFNDEF FMX}
             (((PrismForm.Controls[I] is TPrismButtonedEdit) and (PrismForm.Controls[I].Updatable)) and
             ((PrismForm.Controls[I].Events.Item(Z).EventType = EventOnLeftClick) and
               ((PrismForm.Controls[I] as TPrismButtonedEdit).ButtonLeftVisible) and ((PrismForm.Controls[I] as TPrismButtonedEdit).ButtonLeftEnabled)) or
             ((PrismForm.Controls[I].Events.Item(Z).EventType = EventOnRightClick) and
               ((PrismForm.Controls[I] as TPrismButtonedEdit).ButtonRightVisible) and ((PrismForm.Controls[I] as TPrismButtonedEdit).ButtonRightEnabled))) or
          {$ENDIF}
            (PrismForm.Controls[I].Updatable and PrismForm.Controls[I].Enabled and PrismForm.Controls[I].Visible and not PrismForm.Controls[I].ReadOnly) then
         begin
          //NeedCheckValidation
          if PrismForm.Controls[I].NeedCheckValidation and (PrismForm.Controls[I].ValidationGroup <> '') then
          begin
           for X := 0 to PrismForm.Controls.Count - 1 do
            if PrismForm.Controls[X] <> PrismForm.Controls[I] then
             if PrismForm.Controls[X].ValidationGroup = PrismForm.Controls[I].ValidationGroup then
              if not PrismForm.Controls[X].ValidationGroupPassed then
              begin
               vComponentDisableIgnore:= true;
               PrismSession.ExecJS('insertValidationFeedback("'+ AnsiUpperCase(PrismForm.Controls[X].NamePrefix) +'", ' + BoolToStr(false, True).ToLower + ', "*")');
               break;
              end;
          end;

          if not vComponentDisableIgnore then
           FEvent:= (PrismForm.Controls[I].Events.Item(Z) as TPrismControlEvent)
         end else
          vComponentDisableIgnore:= true;
         Break;
        end;
        if FEvent <> nil then
        Break;
       end;
      end;

      if vComponentDisableIgnore  then
      begin
       if LockClient then
        UnLockClient(PrismSession);
      end else
      if FEvent <> nil then
      begin
  //      PrismSession.ExecThread(true,
  //        procedure
  //        begin
          try
           FEvent.PrismControl.ProcessEventParameters(FEvent, ParamStrings);
          except
           on E: Exception do
           PrismSession.DoException(FEvent.PrismControl as TObject, E, 'ProcessEvent');
          end;
  //        end
  //      );


       if Supports(FEvent.PrismControl, IPrismGrid) and (FEvent.EventType = EventOnLoadJSON) then
       begin
  //         PrismSession.ExecThreadSynchronize(
  //           procedure
  //           begin
             try
              try
               if FEvent.PrismControl.Enabled and FEvent.PrismControl.Visible and not FEvent.PrismControl.ReadOnly then
                ResulThread:= FEvent.CallEventResponse(ParamStrings);
              except
               on E: Exception do
               PrismSession.DoException(FEvent.PrismControl as TObject, E, FEvent.EventTypeName);
              end;
             finally
              if LockClient then
              UnLockClient(PrismSession);
             end;
  //           end
  //         );

        Result:= ResulThread;
       end else
       begin
         if
          {$IFNDEF FMX}
            (((FEvent.PrismControl is TPrismButtonedEdit) and (FEvent.PrismControl.Updatable)) and
             ((FEvent.EventType = EventOnLeftClick) and
               ((FEvent.PrismControl as TPrismButtonedEdit).ButtonLeftVisible) and ((FEvent.PrismControl as TPrismButtonedEdit).ButtonLeftEnabled)) or
             ((FEvent.EventType = EventOnRightClick) and
               ((FEvent.PrismControl as TPrismButtonedEdit).ButtonRightVisible) and ((FEvent.PrismControl as TPrismButtonedEdit).ButtonRightEnabled))) or
          {$ENDIF}
            (FEvent.PrismControl.Updatable and FEvent.PrismControl.Enabled and FEvent.PrismControl.Visible and not FEvent.PrismControl.ReadOnly) then
             begin
              PrismSession.ExecThread(false,
                Exec_CallEvent,
                TValue.From<TPrismControlEvent>(FEvent),
                TValue.From<TPrismSession>(PrismSession),
                TValue.From<String>(ParamStrings.Text),
                TValue.From<Boolean>(LockClient)
              );
              //Exec_CallEvent(FEvent, PrismSession, ParamStrings.Text, LockClient);
        end;
       end;
      end;
     end;
    end;


   //PrismSession.ActiveForm
    ParamStrings.Destroy;
    ParamStrings:= nil;
   except
   end;


   try
    if Assigned(ParamStrings) then
   ParamStrings.Free;
   except
  end;
 end;
 end;


end;

function TPrismServerFunctions.ProcessParameters(AParameters: string): TStringList;
begin
 Result:= TStringList.Create;
 Result.LineBreak:= '&';
 if AParameters <> '' then
  if ((Copy(AParameters, 1, 1) = '''') or (Copy(AParameters, 1, 1) = '"')) and ((Copy(AParameters, 2, 1) <> '''') and (Copy(AParameters, 2, 1) <> '"')) then
   Result.Text:= Copy(AParameters, 2, Length(AParameters) - 1)
  else
   if ((Copy(AParameters, 1, 1) = '''') or (Copy(AParameters, 1, 1) = '"')) and ((Copy(AParameters, 2, 1) = '''') or (Copy(AParameters, 2, 1) = '"')) then
    Result.Text:= Copy(AParameters, 3, Length(AParameters) - 2)
   else
    Result.Text:= AParameters;

 Result.LineBreak:= sLineBreak;

 Result.Text:= StringReplace(Result.Text, '|^e^|', '&', [rfReplaceAll]);
end;



procedure TPrismServerFunctions.UnLockClient(Session: IPrismSession);
begin
 if Assigned(Session) then
  if not (csDestroying in (Session as TPrismSession).ComponentState) then
   if not Session.Closing then
    Session.ExecJS('UnLockThreadClient();')
end;

end.
