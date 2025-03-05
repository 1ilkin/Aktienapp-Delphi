object Form2: TForm2
  Left = 0
  Top = 0
  Align = alLeft
  Caption = 'Form2'
  ClientHeight = 635
  ClientWidth = 839
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Information: TPanel
    Left = 385
    Top = 70
    Width = 414
    Height = 504
    TabOrder = 0
    object pnlStockInfo: TPanel
      Left = 1
      Top = 288
      Width = 412
      Height = 215
      Align = alBottom
      ParentBackground = False
      TabOrder = 0
      ExplicitTop = 286
      object lblStockInfo: TLabel
        Left = 12
        Top = 16
        Width = 21
        Height = 15
        Caption = 'Info'
      end
    end
  end
  object SearchPanel: TPanel
    Left = 35
    Top = 70
    Width = 257
    Height = 405
    TabOrder = 1
    object lstSuggestions: TListBox
      Left = 1
      Top = 27
      Width = 255
      Height = 377
      Align = alBottom
      ItemHeight = 15
      TabOrder = 0
      OnClick = lstSuggestionsClick
      ExplicitLeft = 11
      ExplicitTop = 30
      ExplicitWidth = 243
    end
    object SearchAktien1: TSearchBox
      Left = 1
      Top = 1
      Width = 255
      Height = 29
      Align = alTop
      TabOrder = 1
      OnChange = SearchSuggestions
      OnInvokeSearch = SearchAktien1InvokeSearch
    end
  end
  object HttpClientAPI: TNetHTTPClient
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 1
    Top = 606
  end
  object tmrSearch: TTimer
    OnTimer = TimerSearchTimer
    Left = 33
    Top = 606
  end
end
