﻿unit uStockAPI;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TStockAPI = class
  private
    FHttpClientAPI: TNetHTTPClient;
    FApiKey: string;
    const BASE_URL = 'https://api.polygon.io/v2/aggs/ticker/';
  public
    constructor Create;
    destructor Destroy; override;
    function GetStockInfo(const Symbol: string): string;
    function GetStockSuggestions(const Query: string): TStringList;
  end;

implementation

constructor TStockAPI.Create;
begin
  inherited Create;
  FHttpClientAPI := TNetHTTPClient.Create(nil);
  FApiKey := 'acCvZRIAJJxwkKJrKeMiFFPy9bBjIZYN';
end;

destructor TStockAPI.Destroy;
begin
  FHttpClientAPI.Free;
  inherited;
end;

function TStockAPI.GetStockInfo(const Symbol: string): string;
var
  Response: string;
  JSONObj, StockData: TJSONObject;
  ResultsArray: TJSONArray;
  OpenPrice, HighPrice, LowPrice, ClosePrice, VWAP, Volume: Double;
begin
  Result := '';

  try
    Response := FHttpClientAPI.Get(BASE_URL + Symbol + '/prev?adjusted=true&apiKey=' + FApiKey).ContentAsString;

    JSONObj := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    if Assigned(JSONObj) then
    try
      if JSONObj.TryGetValue<TJSONArray>('results', ResultsArray) and (ResultsArray.Count > 0) then
      begin
        StockData := ResultsArray.Items[0] as TJSONObject;

        OpenPrice := StockData.GetValue<Double>('o');
        HighPrice := StockData.GetValue<Double>('h');
        LowPrice := StockData.GetValue<Double>('l');
        ClosePrice := StockData.GetValue<Double>('c');
        VWAP := StockData.GetValue<Double>('vw');
        Volume := StockData.GetValue<Double>('v');

        Result := Format(
          'Opening Price: %.2f' + sLineBreak + sLineBreak +
          'Closing Price: %.2f' + sLineBreak + sLineBreak +
          'Highest Price of the Day: %.2f' + sLineBreak + sLineBreak +
          'Lowest Price of the Day: %.2f' + sLineBreak + sLineBreak +
          'Volume-Weighted Average Price: %.2f' + sLineBreak + sLineBreak +
          'Trading Volume: %.0f',
          [OpenPrice, ClosePrice, HighPrice, LowPrice, VWAP, Volume]
        );
      end;
    finally
      JSONObj.Free;
    end;
  except
    on E: Exception do
      Result := 'Error API: ' + E.Message;
  end;
end;

function TStockAPI.GetStockSuggestions(const Query: string): TStringList;
var
  Response: string;
  JSONObj: TJSONObject;
  ResultsArray: TJSONArray;
  StockData: TJSONObject;
  i: Integer;
  Ticker: string;
begin
  Result := TStringList.Create;
  try
    Response := FHttpClientAPI.Get(
      Format('https://api.polygon.io/v3/reference/tickers?search=%s&active=true&limit=10&apiKey=%s',
             [Query, FApiKey])
    ).ContentAsString();

    JSONObj := TJSONObject.ParseJSONValue(Response) as TJSONObject;
    if Assigned(JSONObj) then
    try
      if JSONObj.TryGetValue<TJSONArray>('results', ResultsArray) then
      begin
        for i := 0 to ResultsArray.Count - 1 do
        begin
          StockData := ResultsArray.Items[i] as TJSONObject;
          Ticker := StockData.GetValue<string>('ticker');

          if Length(Ticker) > 4 then
            Ticker := Copy(Ticker, 1, 4);

          Result.Add(Ticker);
        end;
      end;
    finally
      JSONObj.Free;
    end;
  except
    on E: Exception do
      Result.Add('Error API: ' + E.Message);
  end;
end;

end.
