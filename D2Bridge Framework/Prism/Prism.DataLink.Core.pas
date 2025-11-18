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

unit Prism.DataLink.Core;

interface

{$IFNDEF FMX}
uses
  Classes, SysUtils, DBCtrls, DB, Variants,
  Prism.Types;

type

 { TPrismDataLinkCore }

 TPrismDataLinkCore = class(TDataLink)
  private
   FPreviousState: TDataSetState;
   FPreviousBookmark: TBookmark;
   FPreviousRecordCount: Integer;
   FLastRecNo: Integer;

   //Event
   FFinishEdit: boolean;
   FEditing: boolean;
   FInserting: boolean;
   FRowChanged: boolean;
   FCanceled: Boolean;
   FUpdated: boolean;

   FOnActivate: TPrismMethodEvent;
   FOnBeginEditing: TPrismMethodEvent;
   FOnBeginInsert: TPrismMethodEvent;
   FOnCanceled: TPrismMethodEvent;
   FOnDataWareEvent: TOnPrismDataWvent;
   FOnDeactivate: TPrismMethodEvent;
   FOnDeleted: TPrismMethodEvent;
   FOnEndEditting: TPrismMethodEvent;
   FOnEndInsert: TPrismMethodEvent;
   FOnNewRow: TPrismMethodEvent;
   FOnScrolled: TPrismMethodEvent;
   FOnUpdated: TPrismMethodEvent;

   FFiltred: boolean;

   //Property
   procedure SetOnActivate(const Value: TPrismMethodEvent);
   procedure SetOnBeginEditing(const Value: TPrismMethodEvent);
   procedure SetOnBeginInsert(const Value: TPrismMethodEvent);
   procedure SetOnCanceled(const Value: TPrismMethodEvent);
   procedure SetOnDataWareEvent(const Value: TOnPrismDataWvent);
   procedure SetOnDeactivate(const Value: TPrismMethodEvent);
   procedure SetOnDeleted(const Value: TPrismMethodEvent);
   procedure SetOnEndEditting(const Value: TPrismMethodEvent);
   procedure SetOnEndInsert(const Value: TPrismMethodEvent);
   procedure SetOnNewRow(const Value: TPrismMethodEvent);
   procedure SetOnScrolled(const Value: TPrismMethodEvent);
   procedure SetOnUpdated(const Value: TPrismMethodEvent);

   procedure StorePrevious;
  protected
   procedure ActiveChanged; override;
   procedure DataSetChanged; override;
   procedure EditingChanged; override;
   procedure RecordChanged(Field: TField); override;
   procedure UpdateData; override;
   procedure DataSetScrolled(Distance: Integer); override;
   procedure DataEvent(Event: TDataEvent; Info: {$IFnDEF FPC}NativeInt{$ELSE}Ptrint{$ENDIF}); override;
  public
   constructor Create;

   //Do Events
   procedure DoBeginEditing; virtual;
   procedure DoEndEditing; virtual;

   procedure DoActive; virtual;
   procedure DoDeactive; virtual;

   procedure DoBeginInsert; virtual;
   procedure DoEndInsert; virtual;

   procedure DoCanceled; virtual;

   procedure DoNewRow; virtual;

   procedure DoDeleted; virtual;

   procedure DoUpdated; virtual;

   procedure DoDataChanged; virtual;

   procedure DoScrolled; virtual;

   procedure DoDataWareEvent(const ADataWareEvent: TPrismDataLinkEvent); virtual;

   //Inheirted
   property readonly;

   //Property
   property OnUpdated: TPrismMethodEvent read FOnUpdated write SetOnUpdated;
   property OnDeleted: TPrismMethodEvent read FOnDeleted write SetOnDeleted;
   property OnNewRow: TPrismMethodEvent read FOnNewRow write SetOnNewRow;
   property OnCanceled: TPrismMethodEvent read FOnCanceled write SetOnCanceled;
   property OnEndEditting: TPrismMethodEvent read FOnEndEditting write SetOnEndEditting;
   property OnBeginEditing: TPrismMethodEvent read FOnBeginEditing write SetOnBeginEditing;
   property OnEndInsert: TPrismMethodEvent read FOnEndInsert write SetOnEndInsert;
   property OnBeginInsert: TPrismMethodEvent read FOnBeginInsert write SetOnBeginInsert;
   property OnDeactivate: TPrismMethodEvent read FOnDeactivate write SetOnDeactivate;
   property OnActivate: TPrismMethodEvent read FOnActivate write SetOnActivate;
   property OnScrolled: TPrismMethodEvent read FOnScrolled write SetOnScrolled;
   property OnDataWareEvent: TOnPrismDataWvent read FOnDataWareEvent write SetOnDataWareEvent;

 end;

implementation

{$ELSE}
implementation
{$ENDIF}

{ TPrismDataLinkCore }

procedure TPrismDataLinkCore.ActiveChanged;
begin
 inherited;

 try
  if Assigned(DataSet) and DataSet.Active then
  begin
   FLastRecNo := DataSet.RecNo;

   FFiltred:= DataSet.Filtered;

   FPreviousRecordCount:= DataSet.RecordCount;

   DoActive;
  end else
  begin
   FLastRecNo := -1;

   FFiltred:= false;

   FPreviousRecordCount:= 0;

   DoDeactive;
  end;

  StorePrevious;
 except
 end;
end;

constructor TPrismDataLinkCore.Create;
begin
 inherited;

 FEditing:= false;
 FInserting:= false;
 FRowChanged:= false;
 FCanceled:= false;
 FUpdated:= false;
 FFinishEdit:= false;
 FFiltred:= false;
end;

procedure TPrismDataLinkCore.DataSetChanged;
var
 CurBookmark: TBookmark;
 FDeleted: boolean;
 FScrolled: boolean;
 FNewRow: Boolean;
begin
 inherited;

 try
  FDeleted:= false;
  FScrolled:= false;
  FNewRow:= false;

  if DataSet.RecNo <> FLastRecNo then
  begin
   FScrolled:= false;
   FLastRecNo:= DataSet.RecNo;
  end;

  // Detectar deleção com mais precisão
  if (DataSet <> nil) and DataSet.Active then
  begin
   if (DataSet.RecordCount < FPreviousRecordCount) then
   begin
    if (FPreviousBookmark <> nil) then
    begin
     if DataSet.BookmarkValid(FPreviousBookmark) then
     begin
      FCanceled:= true;
     end else
      begin
       FDeleted:= true;
      end;
    end else
     if DataSet.IsEmpty then
     begin
      FPreviousRecordCount:= DataSet.RecordCount;
      FDeleted:= true;
     end;
   end else
    if (DataSet.RecordCount > FPreviousRecordCount) then
    begin
     FPreviousRecordCount:= DataSet.RecordCount;
     FNewRow:= true;
    end else
     if (DataSet.RecordCount = FPreviousRecordCount) then
     begin
      if DataSet.BookmarkValid(FPreviousBookmark) then
      begin
       FCanceled:= true;
      end
     end;

   if (FFiltred <> DataSet.Filtered) then
   begin
    FFinishEdit:= false;
    FEditing:= false;
    FInserting:= false;
    FRowChanged:= false;
    FCanceled:= false;
    FUpdated:= false;

    FFiltred:= DataSet.Filtered;

    FPreviousRecordCount:= DataSet.RecordCount;

    DoActive;
   end else
    if FFinishEdit then
    begin
     FFinishEdit:= false;
     FEditing:= false;
     DoEndEditing;

     if FInserting and (not FCanceled) then
      DoEndInsert;

     if FDeleted then
     begin
      DoDeleted;
     end else
      if FRowChanged and FUpdated and FInserting then
      begin
       DoNewRow;
      end else
       if FRowChanged and FUpdated then
       begin
        DoUpdated;
       end else
        if FCanceled then
        begin
         DoCanceled;
        end;

     FInserting:= false;
     FRowChanged:= false;
     FCanceled:= false;
     FUpdated:= false;
    end else
     if FNewRow then
     begin
      FInserting:= false;
      DoNewRow;
     end else
      if FDeleted then
      begin
       if not DataSet.IsEmpty then
         FPreviousBookmark := DataSet.GetBookmark
       else
         FPreviousBookmark := nil;

       DoDeleted;
      end else
       if FScrolled then
       begin
        DoScrolled;
       end;
  end;

  FPreviousState := DataSet.State;

  StorePrevious;
 except
 end;
end;


procedure TPrismDataLinkCore.DataSetScrolled(Distance: Integer);
begin
  inherited;

end;

procedure TPrismDataLinkCore.DataEvent(Event: TDataEvent; Info: {$IFnDEF FPC}NativeInt{$ELSE}Ptrint{$ENDIF});
begin
 inherited;

 if Event = deLayoutChange then
 begin
  if (FFiltred = DataSet.Filtered) then
   DoDataChanged;
 end;
end;

procedure TPrismDataLinkCore.DoActive;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnActivate) then
  FOnActivate;

 DoDataWareEvent(TPrismDataLinkEvent.Activate);
end;

procedure TPrismDataLinkCore.DoBeginEditing;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnBeginEditing) then
  FOnBeginEditing;

 DoDataWareEvent(TPrismDataLinkEvent.BeginEditing);
end;

procedure TPrismDataLinkCore.DoBeginInsert;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnBeginInsert) then
  FOnBeginInsert;

 DoDataWareEvent(TPrismDataLinkEvent.BeginInsert);
end;

procedure TPrismDataLinkCore.DoCanceled;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnCanceled) then
  FOnCanceled;

 DoDataWareEvent(TPrismDataLinkEvent.Canceled);
end;

procedure TPrismDataLinkCore.DoDataWareEvent(const ADataWareEvent: TPrismDataLinkEvent);
begin
 try
  if Assigned(DataSet) then
   if DataSet.ControlsDisabled then
    Exit;

  if Assigned(FOnDataWareEvent) then
   FOnDataWareEvent(ADataWareEvent);
 except
 end;
end;

procedure TPrismDataLinkCore.DoDeactive;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnDeactivate) then
  FOnDeactivate;

 DoDataWareEvent(TPrismDataLinkEvent.Deactivate);
end;

procedure TPrismDataLinkCore.DoDeleted;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnDeleted) then
  FOnDeleted;

 DoDataWareEvent(TPrismDataLinkEvent.Deleted);

end;

procedure TPrismDataLinkCore.DoEndEditing;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnEndEditting) then
  FOnEndEditting;

 DoDataWareEvent(TPrismDataLinkEvent.EndEditting);
end;

procedure TPrismDataLinkCore.DoEndInsert;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnEndInsert) then
  FOnEndInsert;

 DoDataWareEvent(TPrismDataLinkEvent.EndInsert);
end;

procedure TPrismDataLinkCore.DoNewRow;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnNewRow) then
  FOnNewRow;

 DoDataWareEvent(TPrismDataLinkEvent.NewRow);
end;

procedure TPrismDataLinkCore.DoScrolled;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnScrolled) then
  FOnScrolled;

 DoDataWareEvent(TPrismDataLinkEvent.Scrolled);
end;

procedure TPrismDataLinkCore.DoUpdated;
begin
 if Assigned(DataSet) then
  if DataSet.ControlsDisabled then
   Exit;

 if Assigned(FOnUpdated) then
  FOnUpdated;

 DoDataWareEvent(TPrismDataLinkEvent.Updated);

end;

procedure TPrismDataLinkCore.DoDataChanged;
begin
 FFinishEdit:= false;
 FEditing:= false;
 FInserting:= false;
 FRowChanged:= false;
 FCanceled:= false;
 FUpdated:= false;

 DoActive;
end;

procedure TPrismDataLinkCore.EditingChanged;
begin
 inherited;

 try
  if DataSet.State = dsEdit then
  begin
   if not FEditing then
   begin
    FEditing:= true;
    FFinishEdit:= false;
    DoBeginEditing;
   end;
  end else
   if DataSet.State = dsInsert then
   begin
    FLastRecNo := DataSet.RecNo;

    if not FEditing then
    begin
     FInserting:= true;
     DoBeginInsert;

     FEditing:= true;
     DoBeginEditing;
    end;
  end else
   if DataSet.State = dsBrowse then
   begin
    FFinishEdit:= true;
   end;

  FPreviousState := DataSet.State;
 except
 end;
end;

procedure TPrismDataLinkCore.RecordChanged(Field: TField);
begin
 inherited;

 try
  if (Field = nil) then
    Exit;

  FRowChanged:= true;
 except
 end;
end;

procedure TPrismDataLinkCore.SetOnActivate(const Value: TPrismMethodEvent);
begin
 FOnActivate := Value;
end;

procedure TPrismDataLinkCore.SetOnBeginEditing(const Value: TPrismMethodEvent);
begin
 FOnBeginEditing := Value;
end;

procedure TPrismDataLinkCore.SetOnBeginInsert(const Value: TPrismMethodEvent);
begin
 FOnBeginInsert := Value;
end;

procedure TPrismDataLinkCore.SetOnCanceled(const Value: TPrismMethodEvent);
begin
 FOnCanceled := Value;
end;

procedure TPrismDataLinkCore.SetOnDataWareEvent(const Value: TOnPrismDataWvent);
begin
 FOnDataWareEvent := Value;
end;

procedure TPrismDataLinkCore.SetOnDeactivate(const Value: TPrismMethodEvent);
begin
 FOnDeactivate := Value;
end;

procedure TPrismDataLinkCore.SetOnDeleted(const Value: TPrismMethodEvent);
begin
 FOnDeleted := Value;
end;

procedure TPrismDataLinkCore.SetOnEndEditting(const Value: TPrismMethodEvent);
begin
 FOnEndEditting := Value;
end;

procedure TPrismDataLinkCore.SetOnEndInsert(const Value: TPrismMethodEvent);
begin
 FOnEndInsert := Value;
end;

procedure TPrismDataLinkCore.SetOnNewRow(const Value: TPrismMethodEvent);
begin
 FOnNewRow := Value;
end;

procedure TPrismDataLinkCore.SetOnScrolled(const Value: TPrismMethodEvent);
begin
 FOnScrolled := Value;
end;

procedure TPrismDataLinkCore.SetOnUpdated(const Value: TPrismMethodEvent);
begin
 FOnUpdated := Value;
end;

procedure TPrismDataLinkCore.StorePrevious;
begin
 try
  if (DataSet <> nil) and DataSet.Active then
  begin
   FPreviousRecordCount := DataSet.RecordCount;
   if not DataSet.IsEmpty then
     FPreviousBookmark := DataSet.GetBookmark
   else
     FPreviousBookmark := nil;
  end else
  begin
   FPreviousRecordCount:= 0;
   FPreviousBookmark := nil;
  end;
 except
 end;
end;

procedure TPrismDataLinkCore.UpdateData;
begin
 FUpdated:= true;

 inherited;
end;

end.
