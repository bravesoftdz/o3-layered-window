unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, O3LayeredWindowUnit, StdCtrls, pngimage, ExtCtrls, Menus;

type
  TMainForm = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    PopupMenu1: TPopupMenu;
    tetst1: TMenuItem;
    mag1: TMenuItem;
    foobar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
    { Private �錾 }
    FLayeredWindow: TO3LayeredWindow;
  public
    { Public �錾 }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

const
  ImageSourceFileName = '..\images\coolBG0001.png';

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FLayeredWindow.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);

  procedure LoadPNG();
    procedure PNGBitmapToSurface(PNGBitmap: TPNGObject);
    var x, y: Integer;
      pDest, pSrc, pAlpha: PByteArray;
      Alpha: Byte;
    begin
      FLayeredWindow.Surface.SetSize(PNGBitmap.Width, PNGBitmap.Height);

      with FLayeredWindow.Surface do
        for y := 0 to Height - 1 do begin
          pSrc := PNGBitmap.Scanline[y];
          pAlpha := PNGBitmap.AlphaScanline[y];
          pDest := ScanLine[y];
          for x := 0 to Width - 1 do begin
            if pAlpha = nil then
              Alpha := 255
            else
              Alpha := pAlpha[x];

//            Alpha := 255;
            pDest[x * 4 + 0] := pSrc[x * 3 + 0] * Alpha div 255;
            pDest[x * 4 + 1] := pSrc[x * 3 + 1] * Alpha div 255;
            pDest[x * 4 + 2] := pSrc[x * 3 + 2] * Alpha div 255;
            pDest[x * 4 + 3] := Alpha;
          end;
        end;
    end;
  var PNGBitmap: TPNGObject;
  begin
    PNGBitmap := TPNGObject.Create;
    try
      PNGBitmap.LoadFromFile(ImageSourceFileName);
      PNGBitmapToSurface(PNGBitmap);
    finally
      FreeAndNil(PNGBitmap);
    end;
  end;
begin
//  TMouseHook.Create(Self);

  FLayeredWindow := TO3LayeredWindow.Create(Self);
  FLayeredWindow.Parent := Self;

  LoadPNG;
  FLayeredWindow.UpdateLayer;
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  ShowMessage('double clicked!!');
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE: Close;
    Ord('E'): begin
      if FLayeredWindow.Enabled then begin
        FLayeredWindow.Enabled := False;
        BorderStyle := bsSizeable;
        Brush.Style := bsSolid;
        RedrawWindow(Self.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
      end
      else begin
        FLayeredWindow.Enabled := True;
      end;

    end;
  end;
end;

end.
