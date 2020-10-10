// SPDX-License-Identifier: LGPL-3.0-only (modified to allow linking)
unit BCComboBox;

{$mode delphi}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, ExtCtrls, Graphics, Dialogs, BCButton,
  StdCtrls, BCTypes, BCBaseCtrls, BGRABitmap, BGRABitmapTypes, LMessages, LCLType;

type

  { TBCComboBox }

  TBCComboBox = class(TBCStyleCustomControl)
  private
    FButton: TBCButton;
    FDropDownBorderSize: integer;
    FDropDownCount: integer;
    FDropDownFontColor: TColor;
    FDropDownFontHighlight: TColor;
    FDropDownHighlight: TColor;
    FFocusBorderColor: TColor;
    FForm: TForm;
    FFormHideDate: TDateTime;
    FHoverItem: integer;
    FItemHeight: integer;
    FListBox: TListBox;
    FDropDownBorderColor: TColor;
    FOnDrawItem: TDrawItemEvent;
    FOnChange: TNotifyEvent;
    FDrawingDropDown: boolean;
    FTimerCheckFormHide: TTimer;
    procedure ButtonClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    function GetArrowFlip: boolean;
    function GetComboCanvas: TCanvas;
    function GetArrowSize: integer;
    function GetArrowWidth: integer;
    function GetGlobalOpacity: byte;
    function GetItemText: string;
    function GetDropDownBorderStyle: TBorderStyle;
    function GetDropDownColor: TColor;
    function GetItemIndex: integer;
    function GetItems: TStrings;
    function GetMemoryUsage: TBCButtonMemoryUsage;
    function GetOnDrawSelectedItem: TOnAfterRenderBCButton;
    function GetRounding: TBCRounding;
    function GetStateClicked: TBCButtonState;
    function GetStateHover: TBCButtonState;
    function GetStateNormal: TBCButtonState;
    function GetStaticButton: boolean;
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure ListBoxMouseUp({%H-}Sender: TObject; {%H-}Button: TMouseButton;
                          {%H-}Shift: TShiftState; {%H-}X, {%H-}Y: Integer);
    procedure ListBoxMouseLeave(Sender: TObject);
    procedure ListBoxMouseMove(Sender: TObject; {%H-}Shift: TShiftState; X,
      Y: Integer);
    procedure ListBoxSelectionChange(Sender: TObject; {%H-}User: boolean);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure OnAfterRenderButton(Sender: TObject; const ABGRA: TBGRABitmap;
      AState: TBCButtonState; ARect: TRect);
    procedure OnTimerCheckFormHide(Sender: TObject);
    procedure SetArrowFlip(AValue: boolean);
    procedure SetArrowSize(AValue: integer);
    procedure SetArrowWidth(AValue: integer);
    procedure SetDropDownBorderStyle(AValue: TBorderStyle);
    procedure SetDropDownColor(AValue: TColor);
    procedure SetGlobalOpacity(AValue: byte);
    procedure SetItemIndex(AValue: integer);
    procedure SetItems(AValue: TStrings);
    procedure SetMemoryUsage(AValue: TBCButtonMemoryUsage);
    procedure SetOnDrawSelectedItem(AValue: TOnAfterRenderBCButton);
    procedure SetRounding(AValue: TBCRounding);
    procedure SetStateClicked(AValue: TBCButtonState);
    procedure SetStateHover(AValue: TBCButtonState);
    procedure SetStateNormal(AValue: TBCButtonState);
    procedure SetStaticButton(AValue: boolean);
  protected
    function GetStyleExtension: String; override;
    procedure WMSetFocus(var Message: {$IFDEF FPC}TLMSetFocus{$ELSE}TWMSetFocus{$ENDIF}); message {$IFDEF FPC}LM_SETFOCUS{$ELSE}WM_SETFOCUS{$ENDIF};
    procedure WMKillFocus(var Message: {$IFDEF FPC}TLMKillFocus{$ELSE}TWMKillFocus{$ENDIF}); message {$IFDEF FPC}LM_KILLFOCUS{$ELSE}WM_KILLFOCUS{$ENDIF};
    procedure UpdateFocus(AFocused: boolean);
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure UTF8KeyPress(var UTF8Key: TUTF8Char); override;
  public
    constructor Create(AOwner: TComponent); override;
    { Assign the properties from Source to this instance }
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    property HoverItem: integer read FHoverItem;
    property Button: TBCButton read FButton write FButton;
    property ListBox: TListBox read FListBox write FListBox;
    property Text: string read GetItemText;
  published
    property Anchors;
    property Canvas: TCanvas read GetComboCanvas;
    property Items: TStrings read GetItems write SetItems;
    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property ItemHeight: integer read FItemHeight write FItemHeight default 0;
    property ArrowSize: integer read GetArrowSize write SetArrowSize;
    property ArrowWidth: integer read GetArrowWidth write SetArrowWidth;
    property ArrowFlip: boolean read GetArrowFlip write SetArrowFlip default false;
    property FocusBorderColor: TColor read FFocusBorderColor write FFocusBorderColor default clBlack;
    property DropDownBorderColor: TColor read FDropDownBorderColor write FDropDownBorderColor default clWindowText;
    property DropDownBorderSize: integer read FDropDownBorderSize write FDropDownBorderSize default 1;
    property DropDownColor: TColor read GetDropDownColor write SetDropDownColor default clWindow;
    property DropDownFontColor: TColor read FDropDownFontColor write FDropDownFontColor default clWindowText;
    property DropDownCount: integer read FDropDownCount write FDropDownCount default 8;
    property DropDownHighlight: TColor read FDropDownHighlight write FDropDownHighlight default clHighlight;
    property DropDownFontHighlight: TColor read FDropDownFontHighlight write FDropDownFontHighlight default clHighlightText;
    property GlobalOpacity: byte read GetGlobalOpacity write SetGlobalOpacity;
    property MemoryUsage: TBCButtonMemoryUsage read GetMemoryUsage write SetMemoryUsage;
    property Rounding: TBCRounding read GetRounding write SetRounding;
    property StateClicked: TBCButtonState read GetStateClicked write SetStateClicked;
    property StateHover: TBCButtonState read GetStateHover write SetStateHover;
    property StateNormal: TBCButtonState read GetStateNormal write SetStateNormal;
    property StaticButton: boolean read GetStaticButton write SetStaticButton;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnDrawSelectedItem: TOnAfterRenderBCButton read GetOnDrawSelectedItem write SetOnDrawSelectedItem;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property TabStop;
    property TabOrder;
  end;

procedure Register;

implementation

uses math, PropEdits, BGRAText;

procedure Register;
begin
  RegisterComponents('BGRA Controls', [TBCComboBox]);
end;

{ TBCComboBox }

procedure TBCComboBox.ButtonClick(Sender: TObject);
const MinDelayReopen = 500/(1000*60*60*24);
var
  p: TPoint;
  h: Integer;
  top_parent: TControl;
  s: TSize;
begin
  if FForm=nil then
  begin
    FForm := TForm.Create(Self);
    FForm.Visible := False;
    FForm.ShowInTaskBar:= stNever;
    FForm.BorderStyle := bsNone;
    FForm.OnDeactivate:= FormDeactivate;
    FForm.OnHide:=FormHide;
    FListBox.Parent := FForm;
  end;

  if FForm.Visible then
    FForm.Visible := false
  else
  if Now > FFormHideDate+MinDelayReopen then
  begin
    p := ControlToScreen(Point(FButton.Left, FButton.Top + FButton.Height));
    FForm.Left := p.X;
    FForm.Top := p.Y;
    FForm.Color := FDropDownBorderColor;
    FListBox.Font.Name := Button.StateNormal.FontEx.Name;
    FListBox.Font.Style := Button.StateNormal.FontEx.Style;
    FListBox.Font.Height := FontEmHeightSign*Button.StateNormal.FontEx.Height;
    self.Canvas.Font.Assign(FListBox.Font);
    if Assigned(FOnDrawItem) and (FItemHeight <> 0) then
      h := FItemHeight else h := self.Canvas.GetTextHeight('Hg');
    {$IFDEF WINDOWS}inc(h,6);{$ENDIF}
    FListBox.ItemHeight := h;
    {$IFDEF LINUX}inc(h,6);{$ENDIF}
    {$IFDEF DARWIN}inc(h,2);{$ENDIF}
    s := TSize.Create(FButton.Width, h*min(Items.Count, FDropDownCount) + 2*FDropDownBorderSize);
    FForm.ClientWidth := s.cx;
    FForm.ClientHeight := s.cy;
    FListBox.SetBounds(FDropDownBorderSize,FDropDownBorderSize,
      s.cx - 2*FDropDownBorderSize,
      s.cy - 2*FDropDownBorderSize);
    if FForm.Top + FForm.Height > Screen.WorkAreaTop + Screen.WorkAreaHeight then
      FForm.Top := FForm.Top - FForm.Height - Self.Height;
    FForm.Visible := True;
    if FListBox.CanSetFocus then
      FListBox.SetFocus;
    FTimerCheckFormHide.Enabled:= true;
  end;
end;

procedure TBCComboBox.FormDeactivate(Sender: TObject);
begin
  FForm.Visible:= false;
end;

procedure TBCComboBox.FormHide(Sender: TObject);
begin
  FFormHideDate := Now;
end;

function TBCComboBox.GetArrowFlip: boolean;
begin
  result := Button.FlipArrow;
end;

function TBCComboBox.GetComboCanvas: TCanvas;
begin
  if FDrawingDropDown then
    result := ListBox.Canvas
  else
    result := inherited Canvas;
end;

function TBCComboBox.GetArrowSize: integer;
begin
  result := Button.DropDownArrowSize;
end;

function TBCComboBox.GetArrowWidth: integer;
begin
  result := Button.DropDownWidth;
end;

function TBCComboBox.GetGlobalOpacity: byte;
begin
  result := Button.GlobalOpacity;
end;

function TBCComboBox.GetItemText: string;
begin
  if FListBox.ItemIndex<>-1 then
    result := FListBox.Items[FListBox.ItemIndex]
  else
    result := '';
end;

function TBCComboBox.GetDropDownBorderStyle: TBorderStyle;
begin
  result := FListBox.BorderStyle;
end;

function TBCComboBox.GetDropDownColor: TColor;
begin
  result := FListBox.Color;
end;

function TBCComboBox.GetItemIndex: integer;
begin
  result := FListBox.ItemIndex;
end;

function TBCComboBox.GetItems: TStrings;
begin
  Result := FListBox.Items;
end;

function TBCComboBox.GetMemoryUsage: TBCButtonMemoryUsage;
begin
  result := Button.MemoryUsage;
end;

function TBCComboBox.GetOnDrawSelectedItem: TOnAfterRenderBCButton;
begin
  result := FButton.OnAfterRenderBCButton;
end;

function TBCComboBox.GetRounding: TBCRounding;
begin
  result := Button.Rounding;
end;

function TBCComboBox.GetStateClicked: TBCButtonState;
begin
  result := Button.StateClicked;
end;

function TBCComboBox.GetStateHover: TBCButtonState;
begin
  result := Button.StateHover;
end;

function TBCComboBox.GetStateNormal: TBCButtonState;
begin
  result := Button.StateNormal;
end;

function TBCComboBox.GetStaticButton: boolean;
begin
  result := Button.StaticButton;
end;

procedure TBCComboBox.ListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    ButtonClick(nil);

  if (Key = VK_ESCAPE) then
  begin
    ButtonClick(nil);
    Key := VK_UNDEFINED;
  end;
end;

procedure TBCComboBox.ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
                          Shift: TShiftState; X, Y: Integer);
begin
  FForm.Visible := false;
  FFormHideDate := 0;
end;

procedure TBCComboBox.ListBoxMouseLeave(Sender: TObject);
begin
  FHoverItem := -1;
  FListBox.Repaint;
end;

procedure TBCComboBox.ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  TempItem: integer;
begin
  TempItem := FListBox.ItemAtPos(Point(x, y), True);

  if TempItem <> FHoverItem then
  begin
    FHoverItem := TempItem;
    if (FHoverItem<>-1) and ([ssLeft,ssRight]*Shift <> []) then
      FListBox.ItemIndex := FHoverItem;
    FListBox.Repaint;
  end;
end;

procedure TBCComboBox.ListBoxSelectionChange(Sender: TObject; User: boolean);
begin
  Button.Caption := GetItemText;
  if User and Assigned(FOnChange) then FOnChange(self);
end;

procedure TBCComboBox.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
var
  aCanvas: TCanvas;
begin
  if Assigned(FOnDrawItem) then
  begin
    FDrawingDropDown := true;
    Exclude(State, odSelected);
    if Index = HoverItem then Include(State, odSelected);
    if Index = ItemIndex then Include(State, odChecked);
    try
      FOnDrawItem(Control, Index, ARect, State);
    finally
      FDrawingDropDown := false;
    end;
    exit;
  end;

  aCanvas := TListBox(Control).Canvas;
  if Index = HoverItem then
  begin
    aCanvas.Brush.Color := DropDownHighlight;
    aCanvas.Font.Color := DropDownFontHighlight;
  end
  else
  begin
    aCanvas.Brush.Color := DropDownColor;
    aCanvas.Font.Color := DropDownFontColor;
  end;
  aCanvas.Pen.Style := psClear;
  aCanvas.FillRect(ARect);
  aCanvas.TextRect(ARect, ARect.Left+4, ARect.Top +
    (ARect.Height - aCanvas.GetTextHeight(Items[Index])) div 2,
    Items[Index]);
end;

procedure TBCComboBox.OnAfterRenderButton(Sender: TObject;
  const ABGRA: TBGRABitmap; AState: TBCButtonState; ARect: TRect);
begin
  if Focused then
    ABGRA.RectangleAntialias(ARect.Left + 2, ARect.Top + 2, ARect.Right - 3, ARect.Bottom - 3, FFocusBorderColor, 1);
end;

procedure TBCComboBox.OnTimerCheckFormHide(Sender: TObject);
begin
  if Assigned(FForm) and FForm.Visible and not FForm.Active then
  begin
    FForm.Visible := false;
    FreeAndNil(FForm);
    FTimerCheckFormHide.Enabled := false;
  end;
end;

procedure TBCComboBox.SetArrowFlip(AValue: boolean);
begin
  Button.FlipArrow:= AValue;
end;

procedure TBCComboBox.SetArrowSize(AValue: integer);
begin
  Button.DropDownArrowSize:= AValue;
end;

procedure TBCComboBox.SetArrowWidth(AValue: integer);
begin
  Button.DropDownWidth:= AValue;
end;

procedure TBCComboBox.SetDropDownBorderStyle(AValue: TBorderStyle);
begin
  FListBox.BorderStyle:= AValue;
end;

procedure TBCComboBox.SetDropDownColor(AValue: TColor);
begin
  FListBox.Color := AValue;
end;

procedure TBCComboBox.SetGlobalOpacity(AValue: byte);
begin
  Button.GlobalOpacity := AValue;
end;

procedure TBCComboBox.SetItemIndex(AValue: integer);
begin
  FListBox.ItemIndex := AValue;
end;

procedure TBCComboBox.SetItems(AValue: TStrings);
begin
  FListBox.Items.Assign(AValue);
end;

procedure TBCComboBox.SetMemoryUsage(AValue: TBCButtonMemoryUsage);
begin
  Button.MemoryUsage := AValue;
end;

procedure TBCComboBox.SetOnDrawSelectedItem(AValue: TOnAfterRenderBCButton);
begin
  if @OnDrawSelectedItem = @AValue then Exit;
  FButton.OnAfterRenderBCButton:= AValue;
  FButton.ShowCaption := not Assigned(AValue)
end;

procedure TBCComboBox.SetRounding(AValue: TBCRounding);
begin
  Button.Rounding := AValue;
end;

procedure TBCComboBox.SetStateClicked(AValue: TBCButtonState);
begin
  Button.StateClicked := AValue;
end;

procedure TBCComboBox.SetStateHover(AValue: TBCButtonState);
begin
  Button.StateHover := AValue;
end;

procedure TBCComboBox.SetStateNormal(AValue: TBCButtonState);
begin
  Button.StateNormal := AValue;
end;

procedure TBCComboBox.SetStaticButton(AValue: boolean);
begin
  Button.StaticButton:= AValue;
end;

function TBCComboBox.GetStyleExtension: String;
begin
  result := 'bccombo';
end;

procedure TBCComboBox.WMSetFocus(var Message: TLMSetFocus);
begin
  UpdateFocus(True);
end;

procedure TBCComboBox.WMKillFocus(var Message: TLMKillFocus);
begin
  if Message.FocusedWnd <> Handle then
    UpdateFocus(False);
end;

procedure TBCComboBox.UpdateFocus(AFocused: boolean);
var
  lForm: TCustomForm;
  oldCaption: string;
begin
  lForm := GetParentForm(Self);
  if lForm = nil then
    exit;

  {$IFDEF FPC}//#
  if AFocused then
    ActiveDefaultControlChanged(lForm.ActiveControl)
  else
    ActiveDefaultControlChanged(nil);
  {$ENDIF}

  oldCaption := FButton.Caption;
  FButton.Caption := FButton.Caption + '1';
  FButton.Caption := oldCaption;

  Invalidate;
end;

procedure TBCComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    ButtonClick(nil);
  end
  else if Key = VK_DOWN then
  begin
    if FListBox.ItemIndex + 1 < FListBox.Count then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex + 1;
      Button.Caption := GetItemText;
      if Assigned(FOnChange) then
        FOnChange(Self);
    end;
    Key := VK_UNDEFINED;
  end
  else if Key = VK_UP then
  begin
    if FListBox.ItemIndex - 1 >= 0 then
    begin
      FListBox.ItemIndex := FListBox.ItemIndex - 1;
      Button.Caption := GetItemText;
      if Assigned(FOnChange) then
        FOnChange(Self);
    end;
    Key := VK_UNDEFINED;
  end;
end;

procedure TBCComboBox.UTF8KeyPress(var UTF8Key: TUTF8Char);
var
  i: integer;
begin
  for i:=0 to FListBox.Count-1 do
  begin
    if (FListBox.Items[i] <> '') and FListBox.Items[i].ToLower.StartsWith(LowerCase(UTF8Key)) then
    begin
      if FListBox.ItemIndex <> i then
      begin
        FListBox.ItemIndex := i;
        Button.Caption := GetItemText;
        if Assigned(FOnChange) then
          FOnChange(Self);
        break;
      end;
    end;
  end;
end;

constructor TBCComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButton := TBCButton.Create(Self);
  FButton.Align := alClient;
  FButton.Parent := Self;
  FButton.OnClick := ButtonClick;
  FButton.DropDownArrow := True;
  FButton.OnAfterRenderBCButton := OnAfterRenderButton;

  FListBox := TListBox.Create(self);
  FListBox.Parent := nil;
  FListBox.BorderStyle:= bsNone;
  FListBox.OnSelectionChange := ListBoxSelectionChange;
  FListBox.OnMouseLeave:=ListBoxMouseLeave;
  FListBox.OnMouseMove:=ListBoxMouseMove;
  FListBox.OnMouseUp:= ListBoxMouseUp;
  FListBox.Style := lbOwnerDrawFixed;
  FListBox.OnDrawItem:= ListBoxDrawItem;
  FListBox.Options := []; // do not draw focus rect
  FListBox.OnKeyDown:=ListBoxKeyDown;
  FHoverItem := -1;

  FDropDownBorderSize := 1;
  DropDownColor:= clWindow;
  FDropDownCount := 8;
  FDropDownFontColor:= clWindowText;
  FDropDownHighlight:= clHighlight;
  FDropDownFontHighlight:= clHighlightText;

  FTimerCheckFormHide := TTimer.Create(self);
  FTimerCheckFormHide.Interval:= 30;
  FTimerCheckFormHide.OnTimer:= OnTimerCheckFormHide;
end;

procedure TBCComboBox.Assign(Source: TPersistent);
var
  src: TBCComboBox;
begin
  if Source is TBCComboBox then
  begin
    src := TBCComboBox(Source);
    Button.Assign(src.Button);
    Items.Assign(src.Items);
    ItemIndex := src.ItemIndex;
    DropDownBorderColor := src.DropDownBorderColor;
    DropDownBorderSize := src.DropDownBorderSize;
    DropDownColor := src.DropDownColor;
    DropDownFontColor := src.DropDownFontColor;
    DropDownCount := src.DropDownCount;
    DropDownHighlight := src.DropDownHighlight;
    DropDownFontHighlight := src.DropDownFontHighlight;
  end else
    inherited Assign(Source);
end;

procedure TBCComboBox.Clear;
begin
  Items.Clear;
end;

end.
