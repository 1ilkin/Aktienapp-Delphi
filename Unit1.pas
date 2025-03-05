unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TUIElementFactory = class
    function CreateElement(ElementType: string; ParentPanel: TPanel; Left, Top: Integer;
    Width, Height: Integer; Caption: string) : TControl;
  end;

  TForm1 = class(TForm)
    Panel: TPanel;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TUIElementFactory.CreateElement(ElementType: string; ParentPanel: TPanel;
  Left, Top, Width, Height: Integer; Caption: string): TControl;
begin
  Result := nil;

  if ElementType = 'Button' then
    Result := TButton.Create(ParentPanel)
  else if ElementType = 'Label' then
    Result := TLabel.Create(ParentPanel)
  else if ElementType = 'Edit' then
    Result := TEdit.Create(ParentPanel)
  else
    raise Exception.Create('Unbekannter Elementtyp: ' + ElementType);

  if Assigned(Result) then
  begin
    Result.Parent := ParentPanel;
    Result.Left := Left;
    Result.Top := Top;
    Result.Width := Width;
    Result.Height := Height;

    if Result is TButton then
      TButton(Result).Caption := Caption
    else if Result is TLabel then
      TLabel(Result).Caption := Caption
    else if Result is TEdit then
      TEdit(Result).Text := Caption;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Factory: TUIElementFactory;
begin
  Factory := TUIElementFactory.Create;
  try
    Factory.CreateElement('Button', Panel, 10, 10, 100, 30, 'Click Me');
  finally
    FreeAndNil(Factory);
  end;
end;

end.

