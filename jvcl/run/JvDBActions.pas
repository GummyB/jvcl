{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDBActions.Pas, released on 2004-12-30.

The Initial Developer of the Original Code is Jens Fudickar [jens dott fudicker  att oratool dott de]
Portions created by Jens Fudickar are Copyright (C) 2002 Jens Fudickar.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvDBActions;

{$I jvcl.inc}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows, ActnList, ImgList,
  {$ENDIF MSWINDOWS}
  {$IFDEF UNIX}
  QActnList, QWindows, QImgList,
  {$ENDIF UNIX}
  Forms, Controls, Classes, DB,
  JvDynControlEngineDB, JvDynControlEngineDBTools;

type
  TComponentClass = class of TComponent;

  TJvShowSingleRecordWindowOptions = class(TPersistent)
  private
    FDialogCaption: string;
    FPostButtonCaption: string;
    FCancelButtonCaption: string;
    FCloseButtonCaption: string;
    FBorderStyle: TFormBorderStyle;
    FPosition: TPosition;
    FTop: Integer;
    FLeft: Integer;
    FWidth: Integer;
    FHeight: Integer;
  public
    constructor Create;
    procedure SetOptionsToDialog(ADialog: TJvDynControlDataSourceEditDialog);
  published
    property DialogCaption: string read FDialogCaption write FDialogCaption;
    property PostButtonCaption: string read FPostButtonCaption write FPostButtonCaption;
    property CancelButtonCaption: string read FCancelButtonCaption write FCancelButtonCaption;
    property CloseButtonCaption: string read FCloseButtonCaption write FCloseButtonCaption;
    property BorderStyle: TFormBorderStyle read FBorderStyle write FBorderStyle default bsDialog;
    property Position: TPosition read FPosition write FPosition default poScreenCenter;
    property Top: Integer read FTop write FTop default 0;
    property Left: Integer read FLeft write FLeft default 0;
    property Width: Integer read FWidth write FWidth default 640;
    property Height: Integer read FHeight write FHeight default 480;
  end;

  TJvDatabaseActionList = class(TActionList)
  private
    FDataComponent: TComponent;
  protected
    procedure SetDataComponent(Value: TComponent);
  public
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  published
    property DataComponent: TComponent read FDataComponent write SetDataComponent;
  end;

  TJvDatabaseActionBaseEngine = class(TComponent)
  protected
    function GetDataSource(ADataComponent: TComponent): TDataSource; virtual;
    function GetDataSet(ADataComponent: TComponent): TDataSet; virtual;
  public
    function Supports(ADataComponent: TComponent): Boolean; virtual;
    function IsActive(ADataComponent: TComponent): Boolean; virtual;
    function HasData(ADataComponent: TComponent): Boolean; virtual;
    function FieldCount(ADataComponent: TComponent): Integer; virtual;
    function RecordCount(ADataComponent: TComponent): Integer; virtual;
    function RecNo(ADataComponent: TComponent): Integer; virtual;
    function CanModify(ADataComponent: TComponent): Boolean; virtual;
    function Eof(ADataComponent: TComponent): Boolean; virtual;
    function Bof(ADataComponent: TComponent): Boolean; virtual;
    procedure DisableControls(ADataComponent: TComponent); virtual;
    procedure EnableControls(ADataComponent: TComponent); virtual;
    function ControlsDisabled(ADataComponent: TComponent): Boolean; virtual;
    function EditModeActive(ADataComponent: TComponent): Boolean; virtual;
    procedure First(ADataComponent: TComponent); virtual;
    procedure Last(ADataComponent: TComponent); virtual;
    procedure MoveBy(ADataComponent: TComponent; Distance: Integer); virtual;
    procedure ShowSingleRecordWindow(AOptions: TJvShowSingleRecordWindowOptions;
      ADataComponent: TComponent); virtual;
  end;

  TJvDatabaseActionBaseEngineClass = class of TJvDatabaseActionBaseEngine;

  TJvDatabaseActionDBGridEngine = class(TJvDatabaseActionBaseEngine)
  private
    FCurrentDataComponent: TComponent;
  protected
    function GetDataSource(ADataComponent: TComponent): TDataSource; override;
    procedure OnCreateDataControls(ADynControlEngineDB: TJvDynControlEngineDB;
      AParentControl: TWinControl);
  public
    function Supports(ADataComponent: TComponent): Boolean; override;
    procedure ShowSingleRecordWindow(AOptions: TJvShowSingleRecordWindowOptions;
      ADataComponent: TComponent); override;
  end;

  TJvDatabaseExecuteEvent = procedure(Sender: TObject; DataEngine: TJvDatabaseActionBaseEngine;
    DataComponent: TComponent) of object;
  TJvDatabaseExecuteDataSourceEvent = procedure(Sender: TObject; DataSource: TDataSource) of object;

  TJvDatabaseBaseAction = class(TAction)
  private
    FOnExecute: TJvDatabaseExecuteEvent;
    FOnExecuteDataSource: TJvDatabaseExecuteDataSourceEvent;
    FDataEngine: TJvDatabaseActionBaseEngine;
    FDataComponent: TComponent;
  protected
    procedure SetDataComponent(Value: TComponent);
    procedure SetEnabled(Value: Boolean);
    function GetDataSet: TDataSet;
    function GetDataSource: TDataSource;
    function EngineIsActive: Boolean;
    function EngineHasData: Boolean;
    function EngineFieldCount: Integer;
    function EngineRecordCount: Integer;
    function EngineRecNo: Integer;
    function EngineCanModify: Boolean;
    function EngineEof: Boolean;
    function EngineBof: Boolean;
    function EngineControlsDisabled: Boolean;
    function EngineEditModeActive: Boolean;
    property DataEngine: TJvDatabaseActionBaseEngine read FDataEngine;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateTarget(Target: TObject); override;
    function HandlesTarget(Target: TObject): Boolean; override;
    procedure ExecuteTarget(Target: TObject); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property DataSource: TDataSource read GetDataSource;
    property DataSet: TDataSet read GetDataSet;
  published
    property OnExecute: TJvDatabaseExecuteEvent read FOnExecute write FOnExecute;
    property OnExecuteDataSource: TJvDatabaseExecuteDataSourceEvent
      read FOnExecuteDataSource write FOnExecuteDataSource;
    property DataComponent: TComponent read FDataComponent write SetDataComponent;
  end;

  TJvDatabaseSimpleAction = class(TJvDatabaseBaseAction)
  private
    FIsActive: Boolean;
    FHasData: Boolean;
    FCanModify: Boolean;
    FEditModeActive: Boolean;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateTarget(Target: TObject); override;
  published
    property IsActive: Boolean read FIsActive write FIsActive default True;
    property HasData: Boolean read FHasData write FHasData default True;
    property CanModify: Boolean read FCanModify write FCanModify default False;
    property EditModeActive: Boolean read FEditModeActive write FEditModeActive default False;
  end;

  TJvDatabaseBaseActiveAction = class(TJvDatabaseBaseAction)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TJvDatabaseBaseEditAction = class(TJvDatabaseBaseActiveAction)
  public
    procedure UpdateTarget(Target: TObject); override;
  end;

  TJvDatabaseBaseNavigateAction = class(TJvDatabaseBaseActiveAction)
  end;

  TJvDatabaseFirstAction = class(TJvDatabaseBaseNavigateAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseLastAction = class(TJvDatabaseBaseNavigateAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabasePriorAction = class(TJvDatabaseBaseNavigateAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseNextAction = class(TJvDatabaseBaseNavigateAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabasePriorBlockAction = class(TJvDatabaseBaseNavigateAction)
  public
    FBlockSize: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  published
    property BlockSize: Integer read FBlockSize write FBlockSize default 50;
  end;

  TJvDatabaseNextBlockAction = class(TJvDatabaseBaseNavigateAction)
  private
    FBlockSize: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  published
    property BlockSize: Integer read FBlockSize write FBlockSize default 50;
  end;

  TJvDatabaseRefreshAction = class(TJvDatabaseBaseActiveAction)
  private
    FRefreshLastPosition: Boolean;
    FRefreshAsOpenClose: Boolean;
  protected
    procedure Refresh;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecuteTarget(Target: TObject); override;
  published
    property RefreshLastPosition: Boolean read FRefreshLastPosition write FRefreshLastPosition default True;
    property RefreshAsOpenClose: Boolean read FRefreshAsOpenClose write FRefreshAsOpenClose default False;
  end;

  TJvDatabasePositionAction = class(TJvDatabaseBaseNavigateAction)
  public
    procedure ShowPositionDialog;
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseInsertAction = class(TJvDatabaseBaseEditAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseOnCopyRecord = procedure(Field: TField; OldValue: Variant) of object;
  TJvDatabaseBeforeCopyRecord = procedure(DataSet: TDataSet; var RefreshAllowed: Boolean) of object;
  TJvDatabaseAfterCopyRecord = procedure(DataSet: TDataSet) of object;

  TJvDatabaseCopyAction = class(TJvDatabaseBaseEditAction)
  private
    FBeforeCopyRecord: TJvDatabaseBeforeCopyRecord;
    FAfterCopyRecord: TJvDatabaseAfterCopyRecord;
    FOnCopyRecord: TJvDatabaseOnCopyRecord;
  public
    procedure CopyRecord;
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  published
    property BeforeCopyRecord: TJvDatabaseBeforeCopyRecord read FBeforeCopyRecord write FBeforeCopyRecord;
    property AfterCopyRecord: TJvDatabaseAfterCopyRecord read FAfterCopyRecord write FAfterCopyRecord;
    property OnCopyRecord: TJvDatabaseOnCopyRecord read FOnCopyRecord write FOnCopyRecord;
  end;

  TJvDatabaseEditAction = class(TJvDatabaseBaseEditAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseDeleteAction = class(TJvDatabaseBaseEditAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabasePostAction = class(TJvDatabaseBaseEditAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseCancelAction = class(TJvDatabaseBaseEditAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseSingleRecordWindowAction = class(TJvDatabaseBaseActiveAction)
  private
    FOptions: TJvShowSingleRecordWindowOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteTarget(Target: TObject); override;
  published
    property Options: TJvShowSingleRecordWindowOptions read FOptions write FOptions;
  end;

  TJvDatabaseOpenAction = class(TJvDatabaseBaseActiveAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

  TJvDatabaseCloseAction = class(TJvDatabaseBaseActiveAction)
  public
    procedure UpdateTarget(Target: TObject); override;
    procedure ExecuteTarget(Target: TObject); override;
  end;

procedure RegisterActionEngine(AEngineClass: TJvDatabaseActionBaseEngineClass);

implementation

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  SysUtils, DBGrids, Grids,
  JvResources, JvParameterList, JvParameterListParameter, JvPanel;

type
  TJvDatabaseActionEngineList = class(TList)
  public
    destructor Destroy; override;
    procedure RegisterEngine(AEngineClass: TJvDatabaseActionBaseEngineClass);
    function GetEngine(AComponent: TComponent): TJvDatabaseActionBaseEngine;
  end;

var
  RegisteredActionEngineList: TJvDatabaseActionEngineList;

//=== { TJvDatabaseActionList } ==============================================

procedure TJvDatabaseActionList.SetDataComponent(Value: TComponent);
var
  I: Integer;
begin
  FDataComponent := Value;
  if FDataComponent <> nil then
    FDataComponent.FreeNotification(Self);
  for I := 0 to ActionCount - 1 do
    if Actions[I] is TJvDatabaseBaseAction then
      TJvDatabaseBaseAction(Actions[I]).DataComponent := Value;
end;

procedure TJvDatabaseActionList.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FDataComponent then
      DataComponent := nil;
end;

//=== { TJvShowSingleRecordWindowOptions } ===================================

constructor TJvShowSingleRecordWindowOptions.Create;
begin
  inherited Create;
  FDialogCaption := '';
  FPostButtonCaption := RsSRWPostButtonCaption;
  FCancelButtonCaption := RsSRWCancelButtonCaption;
  FCloseButtonCaption := RsSRWCloseButtonCaption;
  FBorderStyle := bsDialog;
  FTop := 0;
  FLeft := 0;
  FWidth := 640;
  FHeight := 480;
  FPosition := poScreenCenter;
end;

procedure TJvShowSingleRecordWindowOptions.SetOptionsToDialog(ADialog: TJvDynControlDataSourceEditDialog);
begin
  if Assigned(ADialog) then
  begin
    ADialog.DialogCaption := DialogCaption;
    ADialog.PostButtonCaption := PostButtonCaption;
    ADialog.CancelButtonCaption := CancelButtonCaption;
    ADialog.CloseButtonCaption := CloseButtonCaption;
    ADialog.Position := Position;
    ADialog.BorderStyle := BorderStyle;
    ADialog.Top := Top;
    ADialog.Left := Left;
    ADialog.Width := Width;
    ADialog.Height := Height;
  end;
end;

//=== { TJvDatabaseActionBaseEngine } ========================================

function TJvDatabaseActionBaseEngine.GetDataSource(ADataComponent: TComponent): TDataSource;
begin
  if Assigned(ADataComponent) and (ADataComponent is TDataSource) then
    Result := TDataSource(ADataComponent)
  else
    Result := nil;
end;

function TJvDatabaseActionBaseEngine.GetDataSet(ADataComponent: TComponent): TDataSet;
begin
  if Assigned(GetDataSource(ADataComponent)) then
    Result := GetDataSource(ADataComponent).DataSet
  else
    Result := nil;
end;

function TJvDatabaseActionBaseEngine.Supports(ADataComponent: TComponent): Boolean;
begin
  Result := Assigned(ADataComponent) and (ADataComponent is TDataSource);
end;

function TJvDatabaseActionBaseEngine.IsActive(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.Active
  else
    Result := False;
end;

function TJvDatabaseActionBaseEngine.HasData(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.RecordCount > 0
  else
    Result := False;
end;

function TJvDatabaseActionBaseEngine.FieldCount(ADataComponent: TComponent): Integer;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.FieldCount
  else
    Result := -1;
end;

function TJvDatabaseActionBaseEngine.RecordCount(ADataComponent: TComponent): Integer;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.RecordCount
  else
    Result := -1;
end;

function TJvDatabaseActionBaseEngine.RecNo(ADataComponent: TComponent): Integer;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.RecNo
  else
    Result := -1;
end;

function TJvDatabaseActionBaseEngine.CanModify(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.CanModify
  else
    Result := False;
end;

function TJvDatabaseActionBaseEngine.Eof(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.Eof
  else
    Result := False;
end;

function TJvDatabaseActionBaseEngine.Bof(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.Bof
  else
    Result := False;
end;

procedure TJvDatabaseActionBaseEngine.DisableControls(ADataComponent: TComponent);
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    DataSet.DisableControls;
end;

procedure TJvDatabaseActionBaseEngine.EnableControls(ADataComponent: TComponent);
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    DataSet.EnableControls;
end;

function TJvDatabaseActionBaseEngine.ControlsDisabled(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.ControlsDisabled
  else
    Result := False;
end;

function TJvDatabaseActionBaseEngine.EditModeActive(ADataComponent: TComponent): Boolean;
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    Result := DataSet.State in [dsInsert, dsEdit]
  else
    Result := False;
end;

procedure TJvDatabaseActionBaseEngine.First(ADataComponent: TComponent);
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    DataSet.First;
end;

procedure TJvDatabaseActionBaseEngine.Last(ADataComponent: TComponent);
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    DataSet.Last;
end;

procedure TJvDatabaseActionBaseEngine.MoveBy(ADataComponent: TComponent; Distance: Integer);
var
  DataSet: TDataSet;
begin
  DataSet := GetDataSet(ADataComponent);
  if Assigned(DataSet) then
    DataSet.MoveBy(Distance);
end;

procedure TJvDatabaseActionBaseEngine.ShowSingleRecordWindow(AOptions: TJvShowSingleRecordWindowOptions;
  ADataComponent: TComponent);
var
  Dialog: TJvDynControlDataSourceEditDialog;
begin
  Dialog := TJvDynControlDataSourceEditDialog.Create;
  try
    AOptions.SetOptionsToDialog(Dialog);
    Dialog.DataSource := GetDataSource(ADataComponent);
    Dialog.ShowDialog;
  finally
    Dialog.Free;
  end;
end;

//=== { TJvDatabaseActionDBGridEngine } ======================================

function TJvDatabaseActionDBGridEngine.GetDataSource(ADataComponent: TComponent): TDataSource;
begin
  if Assigned(ADataComponent) and (ADataComponent is TCustomDBGrid) then
    Result := TCustomDBGrid(ADataComponent).DataSource
  else
    Result := nil;
end;

type
  TAccessCustomDBGrid = class(TCustomDBGrid);
  TAccessCustomControl = class(TCustomControl);

procedure TJvDatabaseActionDBGridEngine.OnCreateDataControls(ADynControlEngineDB: TJvDynControlEngineDB;
  AParentControl: TWinControl);
var
  I: Integer;
  ds: TDataSource;
  Field: TField;
//  LabelControl : TControl;
  Control: TWinControl;
  Column: TColumn;
begin
  if Assigned(FCurrentDataComponent) and (FCurrentDataComponent is TCustomDBGrid) then
  begin
    ds := GetDataSource(FCurrentDataComponent);
    for I := 0 to TAccessCustomDBGrid(FCurrentDataComponent).ColCount - 2 do
    begin
      Column := TAccessCustomDBGrid(FCurrentDataComponent).Columns[I];
      if Column.Visible then
      begin
        Field := Column.Field;
        Control := ADynControlEngineDB.CreateDBFieldControl(Field, AParentControl, AParentControl, '', ds);
        if Field.Size > 0 then
          Control.Width :=
            TAccessCustomControl(AParentControl).Canvas.TextWidth(' ') * Field.Size;
{        LabelControl := }ADynControlEngineDB.DynControlEngine.CreateLabelControlPanel(AParentControl, AParentControl,
          '', '&' + Column.Title.Caption, Control, True, 0);
//        if (AFieldSizeStep > 0) then
//          if ((LabelControl.Width mod AFieldSizeStep) <> 0) then
//            LabelControl.Width := ((LabelControl.Width div AFieldSizeStep) + 1) * AFieldSizeStep;
      end;
    end;
  end;
end;

function TJvDatabaseActionDBGridEngine.Supports(ADataComponent: TComponent): Boolean;
begin
  Result := Assigned(ADataComponent) and (ADataComponent is TCustomDBGrid);
end;

procedure TJvDatabaseActionDBGridEngine.ShowSingleRecordWindow(AOptions: TJvShowSingleRecordWindowOptions;
  ADataComponent: TComponent);
var
  Dialog: TJvDynControlDataSourceEditDialog;
begin
  Dialog := TJvDynControlDataSourceEditDialog.Create;
  try
    AOptions.SetOptionsToDialog(Dialog);
    FCurrentDataComponent := ADataComponent;
    Dialog.DataSource := GetDataSource(ADataComponent);
    Dialog.OnCreateDataControlsEvent := OnCreateDataControls;
    Dialog.ShowDialog;
  finally
    Dialog.Free;
  end;
end;

//=== { TJvDatabaseBaseAction } ==============================================

constructor TJvDatabaseBaseAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(AOwner) and (AOwner is TJvDatabaseActionList) then
    DataComponent := TJvDatabaseActionList(AOwner).DataComponent;
end;

function TJvDatabaseBaseAction.GetDataSet: TDataSet;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.GetDataSet(DataComponent)
  else
    Result := nil;
end;

function TJvDatabaseBaseAction.GetDataSource: TDataSource;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.GetDataSource(DataComponent)
  else
    Result := nil;
end;

procedure TJvDatabaseBaseAction.SetDataComponent(Value: TComponent);
begin
  FDataComponent := Value;
  if FDataComponent <> nil then
    FDataComponent.FreeNotification(Self);
  if Assigned(RegisteredActionEngineList) then
    FDataEngine := RegisteredActionEngineList.GetEngine(FDataComponent)
  else
    FDataEngine := nil;
end;

procedure TJvDatabaseBaseAction.SetEnabled(Value: Boolean);
begin
  if Enabled <> Value then
    Enabled := Value;
end;

function TJvDatabaseBaseAction.EngineIsActive: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.IsActive(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineHasData: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.HasData(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineFieldCount: Integer;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.FieldCount(DataComponent)
  else
    Result := -1;
end;

function TJvDatabaseBaseAction.EngineRecordCount: Integer;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.RecordCount(DataComponent)
  else
    Result := -1;
end;

function TJvDatabaseBaseAction.EngineRecNo: Integer;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.RecNo(DataComponent)
  else
    Result := -1;
end;

function TJvDatabaseBaseAction.EngineCanModify: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.CanModify(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineEof: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.Eof(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineBof: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.Bof(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineControlsDisabled: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.ControlsDisabled(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.EngineEditModeActive: Boolean;
begin
  if Assigned(DataEngine) then
    Result := DataEngine.EditModeActive(DataComponent)
  else
    Result := False;
end;

function TJvDatabaseBaseAction.HandlesTarget(Target: TObject): Boolean;
begin
//  Result := inherited HandlesTarget(Target);
  Result := Assigned(DataEngine);
end;

procedure TJvDatabaseBaseAction.UpdateTarget(Target: TObject);
begin
  if Assigned(DataSet) and not EngineControlsDisabled then
    SetEnabled(True)
  else
    SetEnabled(False);
end;

procedure TJvDatabaseBaseAction.ExecuteTarget(Target: TObject);
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self, DataEngine, DataComponent)
  else
  if Assigned(FOnExecuteDataSource) then
    FOnExecuteDataSource(Self, DataSource)
  else
    inherited ExecuteTarget(Target);
end;

procedure TJvDatabaseBaseAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

//=== { TJvDatabaseSimpleAction } ============================================

constructor TJvDatabaseSimpleAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsActive := True;
  FHasData := True;
  FCanModify := False;
  FEditModeActive := False;
end;

procedure TJvDatabaseSimpleAction.UpdateTarget(Target: TObject);
var
  Res: Boolean;
begin
  if Assigned(DataSet) and not EngineControlsDisabled then
  begin
    Res := False;
    if IsActive then
      Res := Res and EngineIsActive;
    if HasData then
      Res := Res and EngineHasData;
    if CanModify then
      Res := Res and EngineCanModify;
    if EditModeActive then
      Res := Res and EngineEditModeActive;
    SetEnabled(Res)
  end
  else
    SetEnabled(False);
end;

//=== { TJvDatabaseBaseActiveAction } ========================================

procedure TJvDatabaseBaseActiveAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive);
end;

//=== { TJvDatabaseBaseEditAction } ==========================================

procedure TJvDatabaseBaseEditAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and EngineCanModify);
end;

//=== { TJvDatabaseFirstAction } =============================================

procedure TJvDatabaseFirstAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineBof);
end;

procedure TJvDatabaseFirstAction.ExecuteTarget(Target: TObject);
begin
  DataEngine.First(DataComponent);
end;

//=== { TJvDatabaseLastAction } ==============================================

procedure TJvDatabaseLastAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineEof);
end;

procedure TJvDatabaseLastAction.ExecuteTarget(Target: TObject);
begin
  DataEngine.Last(DataComponent);
end;

//=== { TJvDatabasePriorAction } =============================================

procedure TJvDatabasePriorAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineBof);
end;

procedure TJvDatabasePriorAction.ExecuteTarget(Target: TObject);
begin
  DataEngine.MoveBy(DataComponent, -1);
end;

//=== { TJvDatabaseNextAction } ==============================================

procedure TJvDatabaseNextAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineEof);
end;

procedure TJvDatabaseNextAction.ExecuteTarget(Target: TObject);
begin
  DataEngine.MoveBy(DataComponent, 1);
end;

//=== { TJvDatabasePriorBlockAction } ========================================

constructor TJvDatabasePriorBlockAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBlockSize := 50;
end;

procedure TJvDatabasePriorBlockAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineBof);
end;

procedure TJvDatabasePriorBlockAction.ExecuteTarget(Target: TObject);
begin
  with DataEngine do
  try
    DisableControls(DataComponent);
    MoveBy(DataComponent, -BlockSize);
  finally
    EnableControls(DataComponent);
  end;
end;

//=== { TJvDatabaseNextBlockAction } =========================================

constructor TJvDatabaseNextBlockAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBlockSize := 50;
end;

procedure TJvDatabaseNextBlockAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataEngine) and not EngineControlsDisabled and EngineIsActive and not EngineEof);
end;

procedure TJvDatabaseNextBlockAction.ExecuteTarget(Target: TObject);
begin
  with DataEngine do
  try
    DisableControls(DataComponent);
    MoveBy(DataComponent, BlockSize);
  finally
    EnableControls(DataComponent);
  end;
end;

//=== { TJvDatabaseRefreshAction } ===========================================

constructor TJvDatabaseRefreshAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRefreshLastPosition := True;
  FRefreshAsOpenClose := False;
end;

procedure TJvDatabaseRefreshAction.ExecuteTarget(Target: TObject);
begin
  Refresh;
end;

procedure TJvDatabaseRefreshAction.Refresh;
var
  MyBookmark: TBookmark;
begin
  with DataEngine.GetDataSet(DataComponent) do
  begin
    MyBookmark := nil;
    if RefreshLastPosition then
      MyBookmark := GetBookMark;

    try
      if RefreshAsOpenClose then
      begin
        Close;
        Open;
      end
      else
        Refresh;

      if RefreshLastPosition then
        if Active then
          if Assigned(MyBookMark) then
            if BookMarkValid(MyBookMark) then
              try
                GotoBookMark(MyBookMark);
              except
              end;
    finally
      if RefreshLastPosition then
        FreeBookmark(MyBookmark);
    end;
  end;
end;

//=== { TJvDatabasePositionAction } ==========================================

procedure TJvDatabasePositionAction.UpdateTarget(Target: TObject);
const
 cFormat = ' %3d / %3d ';
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and EngineHasData);
  try
    if not EngineIsActive then
      Caption := Format(cFormat, [0, 0])
    else
    if EngineRecordCount = 0 then
      Caption := Format(cFormat, [0, 0])
    else
      Caption := Format(cFormat, [EngineRecNo + 1, EngineRecordCount]);
  except
    Caption := Format(cFormat, [0, 0]);
  end;
end;

procedure TJvDatabasePositionAction.ExecuteTarget(Target: TObject);
begin
  ShowPositionDialog;
end;

procedure TJvDatabasePositionAction.ShowPositionDialog;
const
  cCurrentPosition = 'CurrentPosition';
  cNewPosition = 'NewPosition';
  cKind = 'Kind';
var
  ParameterList: TJvParameterList;
  Parameter: TJvBaseParameter;
  S: string;
  Kind: Integer;
begin
  if not Assigned(DataSet) then
    Exit;
  ParameterList := TJvParameterList.Create(Self);
  try
    Parameter := TJvBaseParameter(tJvEditParameter.Create(ParameterList));
    with TJvEditParameter(Parameter) do
    begin
      SearchName := cCurrentPosition;
      ReadOnly := True;
      Caption := RsDBPosCurrentPosition;
      AsString := IntToStr(EngineRecNo + 1) + ' / ' + IntToStr(EngineRecordCount);
      Width := 150;
      LabelWidth := 80;
      Enabled := False;
    end;
    ParameterList.AddParameter(Parameter);
    Parameter := TJvBaseParameter(TJvEditParameter.Create(ParameterList));
    with TJvEditParameter(Parameter) do
    begin
      Caption := RsDBPosNewPosition;
      SearchName := cNewPosition;
     // EditMask := '999999999;0;_';
      Width := 150;
      LabelWidth := 80;
    end;
    ParameterList.AddParameter(Parameter);
    Parameter := TJvBaseParameter(TJvRadioGroupParameter.Create(ParameterList));
    with TJvRadioGroupParameter(Parameter) do
    begin
      Caption := RsDBPosMovementType;
      SearchName := cKind;
      Width := 305;
      Height := 54;
      Columns := 2;
      ItemList.Add(RsDBPosAbsolute);
      ItemList.Add(RsDBPosForward);
      ItemList.Add(RsDBPosBackward);
      ItemList.Add(RsDBPosPercental);
      ItemIndex := 0;
    end;
    ParameterList.AddParameter(Parameter);
    ParameterList.ArrangeSettings.WrapControls := True;
    ParameterList.ArrangeSettings.MaxWidth := 350;
    ParameterList.Messages.Caption := RsDBPosDialogCaption;
    if ParameterList.ShowParameterDialog then
    begin
      S := ParameterList.ParameterByName(cNewPosition).AsString;
      if S = '' then
        Exit;
      Kind := TJvRadioGroupParameter(ParameterList.ParameterByName(cKind)).ItemIndex;
      DataSet.DisableControls;
      try
        case Kind of
          0:
            begin
              DataSet.First;
              DataSet.MoveBy(StrToInt(S) - 1);
            end;
          1:
            DataSet.MoveBy(StrToInt(S));
          2:
            DataSet.MoveBy(StrToInt(S) * -1);
          3:
            begin
              DataSet.First;
              DataSet.MoveBy(Round((EngineRecordCount / 100) * StrToInt(S)) - 1);
            end;
        end;
      finally
        DataSet.EnableControls;
      end;
    end;
  finally
    ParameterList.Free;
  end;
end;

//=== { TJvDatabaseInsertAction } ============================================

procedure TJvDatabaseInsertAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and
    EngineIsActive and EngineCanModify and not EngineEditModeActive);
end;

procedure TJvDatabaseInsertAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Insert;
end;

//=== { TJvDatabaseCopyAction } ==============================================

procedure TJvDatabaseCopyAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and
    EngineCanModify and EngineHasData and not EngineEditModeActive);
end;

procedure TJvDatabaseCopyAction.ExecuteTarget(Target: TObject);
begin
  CopyRecord;
end;

procedure TJvDatabaseCopyAction.CopyRecord;
var
  Values: array of Variant;
  I: Integer;
  Value: Variant;
  Allowed: Boolean;
begin
  with DataSet do
  begin
    if not Active then
      Exit;
    if State in [dsInsert, dsEdit] then
      Post;
    if State <> dsBrowse then
      Exit;
    Allowed := True;
  end;
  if Assigned(FBeforeCopyRecord) then
    FBeforeCopyRecord(DataSet, Allowed);
  with DataSet do
  begin
    // (rom) this suppresses AfterCopyRecord. Is that desired?
    if not Allowed then
      Exit;
    SetLength(Values, FieldCount);
    for I := 0 to FieldCount - 1 do
      Values[I] := Fields[I].AsVariant;
    Insert;
    if Assigned(FOnCopyRecord) then
      for I := 0 to FieldCount - 1 do
      begin
        Value := Values[I];
        FOnCopyRecord(Fields[I], Value);
      end
    else
      for I := 0 to FieldCount - 1 do
        Fields[I].AsVariant := Values[I];
  end;
  if Assigned(FAfterCopyRecord) then
    FAfterCopyRecord(DataSet);
end;

//=== { TJvDatabaseEditAction } ==============================================

procedure TJvDatabaseEditAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and
    EngineCanModify and EngineHasData and not EngineEditModeActive);
end;

procedure TJvDatabaseEditAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Edit;
end;

//=== { TJvDatabaseDeleteAction } ============================================

procedure TJvDatabaseDeleteAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and
    EngineCanModify and EngineHasData and not EngineEditModeActive);
end;

procedure TJvDatabaseDeleteAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Delete;
end;

//=== { TJvDatabasePostAction } ==============================================

procedure TJvDatabasePostAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and EngineEditModeActive);
end;

procedure TJvDatabasePostAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Post;
end;

//=== { TJvDatabaseCancelAction } ============================================

procedure TJvDatabaseCancelAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineControlsDisabled and EngineIsActive and EngineEditModeActive);
end;

procedure TJvDatabaseCancelAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Cancel;
end;

//=== { TJvDatabaseSingleRecordWindowAction } ================================

constructor TJvDatabaseSingleRecordWindowAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions := TJvShowSingleRecordWindowOptions.Create;
end;

destructor TJvDatabaseSingleRecordWindowAction.Destroy;
begin
  FOptions.Free;
  inherited Destroy;
end;

procedure TJvDatabaseSingleRecordWindowAction.ExecuteTarget(Target: TObject);
begin
  DataEngine.ShowSingleRecordWindow(Options, DataComponent);
end;

//=== { TJvDatabaseOpenAction } ==============================================

procedure TJvDatabaseOpenAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and not EngineIsActive);
end;

procedure TJvDatabaseOpenAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Open;
end;

//=== { TJvDatabaseCloseAction } =============================================

procedure TJvDatabaseCloseAction.UpdateTarget(Target: TObject);
begin
  SetEnabled(Assigned(DataSet) and EngineIsActive and not EngineEditModeActive);
end;

procedure TJvDatabaseCloseAction.ExecuteTarget(Target: TObject);
begin
  DataSet.Close;
end;

//=== { TJvDatabaseActionEngineList } ========================================

destructor TJvDatabaseActionEngineList.Destroy;
var
  I: Integer;
begin
  for i := Count-1 Downto 0 do
  begin
    TJvDatabaseActionBaseEngine(Items[I]).Free;
    Delete(I);
  end;
  inherited Destroy;
end;

procedure TJvDatabaseActionEngineList.RegisterEngine(AEngineClass: TJvDatabaseActionBaseEngineClass);
begin
  Add(AEngineClass.Create(nil));
end;

function TJvDatabaseActionEngineList.GetEngine(AComponent: TComponent): TJvDatabaseActionBaseEngine;
var
  Ind: Integer;
begin
  Result := nil;
  for Ind := 0 to Count - 1 do
    if TJvDatabaseActionBaseEngine(Items[Ind]).Supports(AComponent) then
    begin
      Result := TJvDatabaseActionBaseEngine(Items[Ind]);
      Break;
    end;
end;

//=== { Global } =============================================================

procedure RegisterActionEngine(AEngineClass: TJvDatabaseActionBaseEngineClass);
begin
  if Assigned(RegisteredActionEngineList) then
    RegisteredActionEngineList.RegisterEngine(AEngineClass);
end;

procedure CreateActionEngineList;
begin
  RegisteredActionEngineList := TJvDatabaseActionEngineList.Create;
end;

procedure DestroyActionEngineList;
begin
  if Assigned(RegisteredActionEngineList) then
    RegisteredActionEngineList.Free;
end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$RCSfile$';
    Revision: '$Revision$';
    Date: '$Date$';
    LogPath: 'JVCL\run'
    );
{$ENDIF UNITVERSIONING}

initialization
  CreateActionEngineList;
  RegisterActionEngine(TJvDatabaseActionBaseEngine);
  RegisterActionEngine(TJvDatabaseActionDBGridEngine);

  {$IFDEF UNITVERSIONING}
  RegisterUnitVersion(HInstance, UnitVersioning);
  {$ENDIF UNITVERSIONING}

finalization
  {$IFDEF UNITVERSIONING}
  UnregisterUnitVersion(HInstance);
  {$ENDIF UNITVERSIONING}
  DestroyActionEngineList;

end.

