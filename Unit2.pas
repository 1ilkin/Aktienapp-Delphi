unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ExtCtrls, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, uStockAPI;

type
  TForm2 = class(TForm)
    HttpClientAPI: TNetHTTPClient;
    Information: TPanel;
    SearchPanel: TPanel;
    pnlStockInfo: TPanel;
    lblStockInfo: TLabel;
    lstSuggestions: TListBox;
    tmrSearch: TTimer;
    SearchAktien1: TSearchBox;
    procedure SearchAktien1InvokeSearch(Sender: TObject);
    procedure SearchAktien1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchSuggestions(Sender: TObject);
    procedure TimerSearchTimer(Sender: TObject);
    procedure lstSuggestionsClick(Sender: TObject);
  private
    StockPrices: array of record
      OpenPrice, HighPrice, LowPrice, ClosePrice: Double;
    end;
    procedure StartSearch;
  public
  end;
var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.lstSuggestionsClick(Sender: TObject);
var
  Ticker: string;
  StockAPI: TStockAPI;
begin
  if lstSuggestions.ItemIndex = -1 then Exit;

  Ticker := lstSuggestions.Items[lstSuggestions.ItemIndex];

  StockAPI := TStockAPI.Create;
  try
    lblStockInfo.Caption := StockAPI.GetStockInfo(Ticker);
  finally
  StockAPI.Free;
  end;
end;

procedure TForm2.SearchAktien1InvokeSearch(Sender: TObject);
var
  StockAPI: TStockAPI;
  StockInfo: string;
begin
  if Trim(SearchAktien1.Text) = '' then Exit;

  StockAPI := TStockAPI.Create;
  try
    StockInfo := StockAPI.GetStockInfo(SearchAktien1.Text);
    lblStockInfo.Caption := StockInfo;
  finally
    StockAPI.Free;
  end;
end;

procedure TForm2.SearchAktien1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    SearchAktien1InvokeSearch(Sender);
  end;
end;

procedure TForm2.SearchSuggestions(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  tmrSearch.Interval := 1000;
  tmrSearch.Enabled := True;
end;

procedure TForm2.StartSearch;
var
  StockAPI: TStockAPI;
  Suggestions: TStringList;
  I: Integer;
begin
  lstSuggestions.Items.Clear;
  if Trim(SearchAktien1.Text) = '' then Exit;

  StockAPI := TStockAPI.Create;
  try
    Suggestions := StockAPI.GetStockSuggestions(SearchAktien1.Text);
    try
      for I := 0 to Suggestions.Count - 1 do
        lstSuggestions.Items.Add(Suggestions[I]);
    finally
      Suggestions.Free;
    end;
  finally
    StockAPI.Free;
  end;
end;

procedure TForm2.TimerSearchTimer(Sender: TObject);
begin
  tmrSearch.Enabled := False;
  StartSearch;
end;
end.
