object Form1: TForm1
  Left = 452
  Top = 55
  Width = 1413
  Height = 1011
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1059#1062#1060
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 504
    Width = 1401
    Height = 265
    ParentShowHint = False
    ShowHint = False
  end
  object Label6: TLabel
    Left = 600
    Top = 496
    Width = 232
    Height = 29
    Caption = #1062#1080#1092#1088#1086#1074#1099#1077' '#1076#1072#1085#1085#1099#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1401
    Height = 241
    ActivePage = TabSheet1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1056#1091#1095#1085#1072#1103' '#1087#1088#1086#1074#1077#1088#1082#1072
      object Button1: TButton
        Left = 16
        Top = 8
        Width = 217
        Height = 73
        Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1082' '#1048#1057#1044
        TabOrder = 0
        OnClick = Button1Click
      end
      object GroupBox4: TGroupBox
        Left = 424
        Top = 80
        Width = 217
        Height = 129
        Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1073#1086#1088#1072
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 32
          Width = 66
          Height = 20
          Caption = #1044#1047#1085#1072#1095'.:'
        end
        object Label8: TLabel
          Left = 8
          Top = 104
          Width = 98
          Height = 20
          Caption = #1040#1084#1087#1083#1047#1085#1072#1095'.:'
        end
        object Label9: TLabel
          Left = 80
          Top = 32
          Width = 6
          Height = 20
        end
        object Label10: TLabel
          Left = 112
          Top = 104
          Width = 6
          Height = 20
        end
        object ComboBox8: TComboBox
          Left = 48
          Top = 64
          Width = 105
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 0
          Text = #1059#1062#1060
          OnChange = ComboBox8Change
          Items.Strings = (
            #1059#1062#1060
            #1059#1062#1060'-01'
            #1059#1062#1060'-02'
            #1059#1062#1060'-03'
            #1059#1062#1060'-04')
        end
      end
      object GroupBox1: TGroupBox
        Left = 1072
        Top = 80
        Width = 313
        Height = 129
        Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1082#1086#1101#1092#1080#1094#1080#1077#1085#1090#1072' '#1091#1089#1080#1083#1077#1085#1080#1103
        TabOrder = 2
        object Label7: TLabel
          Left = 16
          Top = 26
          Width = 73
          Height = 20
          Caption = #1050#1072#1085#1072#1083' 1:'
        end
        object Label1: TLabel
          Left = 16
          Top = 50
          Width = 73
          Height = 20
          Caption = #1050#1072#1085#1072#1083' 2:'
        end
        object Label2: TLabel
          Left = 16
          Top = 74
          Width = 73
          Height = 20
          Caption = #1050#1072#1085#1072#1083' 3:'
        end
        object Label3: TLabel
          Left = 16
          Top = 98
          Width = 73
          Height = 20
          Caption = #1050#1072#1085#1072#1083' 4:'
        end
        object ComboBox7: TComboBox
          Left = 104
          Top = 24
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 0
          Text = '1'
          OnChange = ComboBox7Change
          Items.Strings = (
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128')
        end
        object ComboBox1: TComboBox
          Left = 104
          Top = 48
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 1
          Text = '1'
          OnChange = ComboBox1Change
          Items.Strings = (
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128')
        end
        object ComboBox2: TComboBox
          Left = 104
          Top = 72
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 2
          Text = '1'
          OnChange = ComboBox2Change
          Items.Strings = (
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128')
        end
        object ComboBox3: TComboBox
          Left = 104
          Top = 96
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 3
          Text = '1'
          OnChange = ComboBox3Change
          Items.Strings = (
            '1'
            '2'
            '4'
            '8'
            '16'
            '32'
            '64'
            '128')
        end
      end
      object GroupBox5: TGroupBox
        Left = 880
        Top = 80
        Width = 193
        Height = 129
        Caption = #1042#1099#1073#1086#1088' '#1082#1072#1085#1072#1083#1072
        TabOrder = 3
        object RadioButton1: TRadioButton
          Left = 16
          Top = 24
          Width = 113
          Height = 17
          Caption = #1050#1072#1085#1072#1083'1'
          TabOrder = 0
        end
        object RadioButton2: TRadioButton
          Left = 16
          Top = 40
          Width = 113
          Height = 17
          Caption = #1050#1072#1085#1072#1083'2'
          TabOrder = 1
        end
        object RadioButton3: TRadioButton
          Left = 16
          Top = 56
          Width = 113
          Height = 17
          Caption = #1050#1072#1085#1072#1083'3'
          TabOrder = 2
        end
        object RadioButton4: TRadioButton
          Left = 16
          Top = 72
          Width = 113
          Height = 17
          Caption = #1050#1072#1085#1072#1083'4'
          TabOrder = 3
        end
        object Button5: TButton
          Left = 64
          Top = 96
          Width = 113
          Height = 25
          Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
          TabOrder = 4
          OnClick = Button5Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 640
        Top = 80
        Width = 241
        Height = 129
        Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1095#1072#1089#1090#1086#1090#1099' '#1089#1088#1077#1079#1072
        TabOrder = 4
        object ComboBox4: TComboBox
          Left = 48
          Top = 64
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 0
          Text = 'DF1-(20-500)'
          OnChange = ComboBox4Change
          Items.Strings = (
            'DF1-(20-500)'
            'DF2-(20-1000)'
            'DF3-(20-2000)'
            'DF4-(20-4000)')
        end
      end
      object Button3: TButton
        Left = 256
        Top = 8
        Width = 217
        Height = 73
        Caption = #1055'oc'#1090#1088#1086#1080#1090#1100' '#1040#1063#1061
        TabOrder = 5
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 496
        Top = 8
        Width = 425
        Height = 73
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1077#1088#1072#1074#1085#1086#1084#1077#1088#1085#1086#1089#1090#1080' '#1040#1063#1061
        TabOrder = 6
        OnClick = Button4Click
      end
      object Button6: TButton
        Left = 944
        Top = 8
        Width = 441
        Height = 73
        Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1091#1089#1080#1083#1077#1085#1080#1103
        TabOrder = 7
        OnClick = Button6Click
      end
      object GroupBox7: TGroupBox
        Left = 16
        Top = 80
        Width = 409
        Height = 129
        Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1087#1088#1080#1073#1086#1088#1072' '#1080' '#1062#1044
        TabOrder = 8
        object Label4: TLabel
          Left = 24
          Top = 27
          Width = 222
          Height = 20
          Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088' '#1087#1088#1080#1073#1086#1088#1072':'
        end
        object Button7: TButton
          Left = 8
          Top = 56
          Width = 241
          Height = 33
          Caption = #1055#1088#1080#1077#1084' '#1094#1080#1092#1088#1086#1074#1099#1093' '#1076#1072#1085#1085#1099#1093
          TabOrder = 0
          OnClick = Button7Click
        end
        object Button8: TButton
          Left = 8
          Top = 88
          Width = 241
          Height = 33
          Caption = #1054#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1077#1084#1072' '#1062#1044
          TabOrder = 1
          OnClick = Button8Click
        end
        object RadioButton5: TRadioButton
          Left = 264
          Top = 56
          Width = 121
          Height = 17
          Caption = #1050#1072#1085#1072#1083'1'
          TabOrder = 2
          OnClick = RadioButton5Click
        end
        object RadioButton6: TRadioButton
          Left = 264
          Top = 72
          Width = 121
          Height = 17
          Caption = #1050#1072#1085#1072#1083'2'
          TabOrder = 3
          OnClick = RadioButton6Click
        end
        object RadioButton7: TRadioButton
          Left = 264
          Top = 88
          Width = 121
          Height = 17
          Caption = #1050#1072#1085#1072#1083'3'
          TabOrder = 4
          OnClick = RadioButton7Click
        end
        object RadioButton8: TRadioButton
          Left = 264
          Top = 104
          Width = 121
          Height = 17
          Caption = #1050#1072#1085#1072#1083'4'
          TabOrder = 5
          OnClick = RadioButton8Click
        end
        object Edit1: TEdit
          Left = 264
          Top = 24
          Width = 121
          Height = 28
          TabOrder = 6
          OnClick = Edit1Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1086#1074#1077#1088#1082#1072
      ImageIndex = 1
      object GroupBox6: TGroupBox
        Left = 8
        Top = 16
        Width = 433
        Height = 169
        Caption = #1042#1099#1073#1086#1088' '#1087#1088#1080#1073#1086#1088#1072
        TabOrder = 0
        object ComboBox5: TComboBox
          Left = 128
          Top = 80
          Width = 145
          Height = 28
          ItemHeight = 20
          ItemIndex = 0
          TabOrder = 0
          Text = #1059#1062#1060
          Items.Strings = (
            #1059#1062#1060
            #1059#1062#1060'-01'
            #1059#1062#1060'-02'
            #1059#1062#1060'-03'
            #1059#1062#1060'-04')
        end
      end
      object Button2: TButton
        Left = 768
        Top = 16
        Width = 329
        Height = 169
        Caption = #1047#1072#1087#1091#1089#1082' '#1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1081' '#1087#1088#1086#1074#1077#1088#1082#1080
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 240
    Width = 1401
    Height = 257
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.EndColor = clSilver
    Gradient.Visible = True
    Title.Font.Charset = DEFAULT_CHARSET
    Title.Font.Color = clBlack
    Title.Font.Height = -24
    Title.Font.Name = 'Arial'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      #1040#1063#1061)
    Chart3DPercent = 40
    LeftAxis.Axis.Color = 4227327
    LeftAxis.Axis.Width = 3
    LeftAxis.ExactDateTime = False
    LeftAxis.Grid.Color = clRed
    LeftAxis.LabelsAngle = 90
    LeftAxis.LabelsFont.Charset = RUSSIAN_CHARSET
    LeftAxis.LabelsFont.Color = clBlack
    LeftAxis.LabelsFont.Height = -13
    LeftAxis.LabelsFont.Name = 'MS Sans Serif'
    LeftAxis.LabelsFont.Style = [fsBold]
    LeftAxis.MinorGrid.Color = -1
    LeftAxis.MinorTickLength = 1
    LeftAxis.StartPosition = 10.000000000000000000
    LeftAxis.EndPosition = 90.000000000000000000
    Legend.Font.Charset = RUSSIAN_CHARSET
    Legend.Font.Color = clBlack
    Legend.Font.Height = -13
    Legend.Font.Name = 'MS Sans Serif'
    Legend.Font.Style = [fsBold]
    Legend.Visible = False
    View3D = False
    BevelWidth = 0
    TabOrder = 1
    object Series1: TLineSeries
      Marks.ArrowLength = 2
      Marks.Font.Charset = DEFAULT_CHARSET
      Marks.Font.Color = clBlack
      Marks.Font.Height = -13
      Marks.Font.Name = 'Arial'
      Marks.Font.Style = [fsBold]
      Marks.Style = smsValue
      Marks.Visible = False
      SeriesColor = 8404992
      ValueFormat = '#,##0.### '
      LinePen.Width = 3
      Pointer.Brush.Color = clRed
      Pointer.HorizSize = 1
      Pointer.InflateMargins = False
      Pointer.Pen.Visible = False
      Pointer.Style = psRectangle
      Pointer.VertSize = 1
      Pointer.Visible = True
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 776
    Width = 1400
    Height = 201
    Caption = #1061#1086#1076' '#1087#1088#1086#1074#1077#1088#1082#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object Memo1: TMemo
      Left = 8
      Top = 24
      Width = 1385
      Height = 169
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object HTTP1: TIdHTTP
    MaxLineAction = maException
    ReadTimeout = 0
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = 0
    Request.ContentRangeStart = 0
    Request.ContentType = 'text/html'
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 888
  end
  object IdUDPServer1: TIdUDPServer
    Bindings = <>
    DefaultPort = 1002
    OnUDPRead = IdUDPServer1UDPRead
    Left = 924
    Top = 4
  end
end
