{**************************************************************************************************}
{  WARNING:  JEDI preprocessor generated unit.  Do not edit.                                       }
{**************************************************************************************************}

{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvExCheckLst.pas, released on 2004-01-04

The Initial Developer of the Original Code is Andreas Hausladen [Andreas dott Hausladen att gmx dott de]
Portions created by Andreas Hausladen are Copyright (C) 2004 Andreas Hausladen.
All Rights Reserved.

Contributor(s): -

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id$

unit JvExCheckLst;

{$I jvcl.inc}
{MACROINCLUDE JvExControls.macros}

{*****************************************************************************
 * WARNING: Do not edit this file.
 * This file is autogenerated from the source in devtools/JvExVCL/src.
 * If you do it despite this warning your changes will be discarded by the next
 * update of this file. Do your changes in the template files.
 ****************************************************************************}

interface

uses
  Windows, Messages,
  Graphics, Controls, Forms, CheckLst,
  Classes, SysUtils,
  JvTypes, JvThemes, JVCLVer, JvExControls;


type
  TJvExCheckListBox = class(TCheckListBox, IJvWinControlEvents, IJvControlEvents, IPerformControl)
  protected
   // IJvControlEvents
    procedure VisibleChanged; dynamic;
    procedure EnabledChanged; dynamic;
    procedure TextChanged; dynamic;
    procedure FontChanged; dynamic;
    procedure ColorChanged; dynamic;
    procedure ParentFontChanged; dynamic;
    procedure ParentColorChanged; dynamic;
    procedure ParentShowHintChanged; dynamic;
    function WantKey(Key: Integer; Shift: TShiftState;
      const KeyText: WideString): Boolean; virtual;
    function HintShow(var HintInfo: THintInfo): Boolean; dynamic;
    function HitTest(X, Y: Integer): Boolean; dynamic;
    procedure MouseEnter(Control: TControl); dynamic;
    procedure MouseLeave(Control: TControl); dynamic;
    {$IFNDEF HASAUTOSIZE}
     {$IFNDEF COMPILER6_UP}
    procedure SetAutoSize(Value: Boolean); virtual;
     {$ENDIF !COMPILER6_UP}
    {$ENDIF !HASAUTOSIZE}
  public
    procedure Dispatch(var Msg); override;
  protected
   // IJvWinControlEvents
    procedure CursorChanged; dynamic;
    procedure ShowingChanged; dynamic;
    procedure ShowHintChanged; dynamic;
    procedure ControlsListChanging(Control: TControl; Inserting: Boolean); dynamic;
    procedure ControlsListChanged(Control: TControl; Inserting: Boolean); dynamic;
  {$IFDEF JVCLThemesEnabledD56}
  private
    function GetParentBackground: Boolean;
  protected
    procedure SetParentBackground(Value: Boolean); virtual;
    property ParentBackground: Boolean read GetParentBackground write SetParentBackground;
  {$ENDIF JVCLThemesEnabledD56}
  private
    FHintColor: TColor;
    FSavedHintColor: TColor;
    FMouseOver: Boolean;
    FOnParentColorChanged: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
  protected
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  protected
    procedure CMFocusChanged(var Msg: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure DoFocusChanged(Control: TWinControl); dynamic;
    property MouseOver: Boolean read FMouseOver write FMouseOver;
    property HintColor: TColor read FHintColor write FHintColor default clInfoBk;
    property OnParentColorChange: TNotifyEvent read FOnParentColorChanged write FOnParentColorChanged;
  private
    FAboutJVCL: TJVCLAboutInfo;
  published
    property AboutJVCL: TJVCLAboutInfo read FAboutJVCL write FAboutJVCL stored False;
  protected
    procedure DoGetDlgCode(var Code: TDlgCodes); virtual;
    procedure DoSetFocus(FocusedWnd: HWND); dynamic;
    procedure DoKillFocus(FocusedWnd: HWND); dynamic;
    procedure DoBoundsChanged; dynamic;
    function DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TJvExPubCheckListBox = class(TJvExCheckListBox)
  published
    property BiDiMode;
    property DragCursor;
    property DragKind;
    property DragMode;
    property ParentBiDiMode;
    property OnEndDock;
    property OnStartDock;
  end;
  

implementation

procedure TJvExCheckListBox.Dispatch(var Msg);
asm
        JMP     DispatchMsg
end;

procedure TJvExCheckListBox.VisibleChanged;
asm
        MOV     EDX, CM_VISIBLECHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.EnabledChanged;
asm
        MOV     EDX, CM_ENABLEDCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.TextChanged;
asm
        MOV     EDX, CM_TEXTCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.FontChanged;
asm
        MOV     EDX, CM_FONTCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ColorChanged;
asm
        MOV     EDX, CM_COLORCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ParentFontChanged;
asm
        MOV     EDX, CM_PARENTFONTCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ParentShowHintChanged;
asm
        MOV     EDX, CM_PARENTSHOWHINTCHANGED
        JMP     InheritMsg
end;

function TJvExCheckListBox.WantKey(Key: Integer; Shift: TShiftState;
  const KeyText: WideString): Boolean;
begin
  Result := InheritMsgEx(Self, CM_DIALOGCHAR, Word(Key), ShiftStateToKeyData(Shift)) <> 0;
end;

function TJvExCheckListBox.HintShow(var HintInfo: THintInfo): Boolean;
begin
  Result := InheritMsgEx(Self, CM_HINTSHOW, 0, Integer(@HintInfo)) <> 0;
end;

function TJvExCheckListBox.HitTest(X, Y: Integer): Boolean;
begin
  Result := InheritMsgEx(Self, CM_HITTEST, 0, Integer(PointToSmallPoint(Point(X, Y)))) <> 0;
end;

procedure TJvExCheckListBox.MouseEnter(Control: TControl);
begin
  Control_MouseEnter(Self, Control, FMouseOver, FSavedHintColor, FHintColor,
    FOnMouseEnter);
end;

procedure TJvExCheckListBox.MouseLeave(Control: TControl);
begin
  Control_MouseLeave(Self, Control, FMouseOver, FSavedHintColor, FOnMouseLeave);
end;

procedure TJvExCheckListBox.ParentColorChanged;
begin
  InheritMsg(Self, CM_PARENTCOLORCHANGED);
  if Assigned(FOnParentColorChanged) then
    FOnParentColorChanged(Self);
end;

{$IFNDEF HASAUTOSIZE}
 {$IFNDEF COMPILER6_UP}
procedure TJvExCheckListBox.SetAutoSize(Value: Boolean);
begin
  TOpenControl_SetAutoSize(Self, Value);
end;
 {$ENDIF !COMPILER6_UP}
{$ENDIF !HASAUTOSIZE}
procedure TJvExCheckListBox.CursorChanged;
asm
        MOV     EDX, CM_CURSORCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ShowHintChanged;
asm
        MOV     EDX, CM_SHOWHINTCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ShowingChanged;
asm
        MOV     EDX, CM_SHOWINGCHANGED
        JMP     InheritMsg
end;

procedure TJvExCheckListBox.ControlsListChanging(Control: TControl; Inserting: Boolean);
asm
        JMP     Control_ControlsListChanging
end;

procedure TJvExCheckListBox.ControlsListChanged(Control: TControl; Inserting: Boolean);
asm
        JMP     Control_ControlsListChanged
end;

{$IFDEF JVCLThemesEnabledD56}
function TJvExCheckListBox.GetParentBackground: Boolean;
asm
        JMP     JvThemes.GetParentBackground
end;

procedure TJvExCheckListBox.SetParentBackground(Value: Boolean);
asm
        JMP     JvThemes.SetParentBackground
end;
{$ENDIF JVCLThemesEnabledD56}
  
procedure TJvExCheckListBox.CMFocusChanged(var Msg: TCMFocusChanged);
begin
  inherited;
  DoFocusChanged(Msg.Sender);
end;

procedure TJvExCheckListBox.DoFocusChanged(Control: TWinControl);
begin
end;
  
procedure TJvExCheckListBox.DoBoundsChanged;
begin
end;

procedure TJvExCheckListBox.DoGetDlgCode(var Code: TDlgCodes);
begin
end;

procedure TJvExCheckListBox.DoSetFocus(FocusedWnd: HWND);
begin
end;

procedure TJvExCheckListBox.DoKillFocus(FocusedWnd: HWND);
begin
end;

function TJvExCheckListBox.DoPaintBackground(Canvas: TCanvas; Param: Integer): Boolean;
asm
        JMP     DefaultDoPaintBackground
end;
  
constructor TJvExCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHintColor := Application.HintColor;
end;


destructor TJvExCheckListBox.Destroy;
begin
  inherited Destroy;
end;
  

end.
