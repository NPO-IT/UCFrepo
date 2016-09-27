unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP,IniFiles, IdUDPBase, IdUDPServer, TeEngine, Series,
  ExtCtrls, TeeProcs, Chart, ComCtrls, Visa_h,IdSocketHandle, Lusbapi; //Lusbapi-библиотека для работы с АЦП Е20-10

const
//переменная для хранения идентификатора блока питания(у всех блоков АКИП-1105 он одинаковый)
AkipV7_78_1 = 'USB[0-9]*::0x164E::0x0DAD::?*INSTR';
DEVICEINDEX=5;
MODEINDEX=4;
FREQINDEX=51; {51}    //для массива частот для построения наиболее полной АЧХ
FREQINDEX1=6; {6}      //для массива частот для проверки прибора в соответствии с ТУ
VOLTININDEX=8;

//размер буфера для подсчета действующего значения . Пункт 3.22
NUMBERPOINTS = 10000;

//------------------------------------------------------------------------------

//Константы для работы с АЦП Е20-10. Пункт автоматической проверки 3.21.

// столько блоков по DataStep отсчётов нужно собрать в файл
NBLOCKTOREAD : WORD = 3;
// кол-во активных каналов
CHANNELSQUANTITY : WORD = $04;
// частота ввода данных
ADCRATE : double  = 1000.0;
//-----------------------------------------------------------------------------
//константа хранения размерности массива количество значений для всех каналов
SIZEDIGMAS=3145728;
koef_mV=0.375;
//------------------------------------------------------------------------------
type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Button1: TButton;
    GroupBox4: TGroupBox;
    ComboBox8: TComboBox;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox7: TComboBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    GroupBox5: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button5: TButton;
    GroupBox2: TGroupBox;
    ComboBox4: TComboBox;
    HTTP1: TIdHTTP;
    Button3: TButton;
    GroupBox6: TGroupBox;
    ComboBox5: TComboBox;
    Button2: TButton;
    Button4: TButton;
    Button6: TButton;
    IdUDPServer1: TIdUDPServer;
    Chart1: TChart;
    Series1: TLineSeries;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    GroupBox7: TGroupBox;
    Button7: TButton;
    Button8: TButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Edit1: TEdit;
    Label4: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox7Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox8Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure Button6Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
 
    procedure Edit1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  //тип для работы с АЦП Е20-10
 TShortrArray = array [0..1] of array of SHORT;


var
  Form1: TForm1;

  //переменная для вывода строки модификации
  modifStr:string;
  //переменная для определения режима усиления
  powerMode:string;
  //переменная для хранения ip-адреса адаптера RS485 (ini-файл)
  HostAdapterRS485:string;
  //переменная для хранения номера порта для адаптера
  PortAdapterRS485:integer;
  //переменная для хранения ip-адреса первого ИСД (ini-файл)
  HostISD1:string;
   //переменная для хранения ip-адреса второго ИСД (ini-файл)
  HostISD2:string;
  //переменная для хранения идентификатора генератора
  RigolDg1022:string;
  //переменные для работы проверки наличия
  m_defaultRM_usbtmc, m_instr_usbtmc:array[0..3] of LongWord;
  viAttr:Longword =  $3FFF001A;
  Timeout: integer = 7000;

  masFrequency: array [1..DEVICEINDEX,1..MODEINDEX,1..FREQINDEX] of integer=(

  ((1,2,3,4,5,6,8,9,10,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,450,460,480,500,510,520,525,530,535,540,545,550,560,565,580,600,700,800,900,1000),
  (1,2,4,8,10,20,30,40,50,60,90,130,170,210,250,290,330,370,410,450,490,500,530,570,610,650,690,730,770,810,850,890,900,930,970,1000,1020,1030,1040,1050,1080,1120,1060,1100,1150,1200,1400,1600,1800,1900,2000),
  (1,2,4,8,10,20,30,40,60,80,160,240,320,400,480,560,640,720,800,880,960,1000,1040,1120,1200,1280,1360,1440,1520,1600,1680,1760,1800,1840,1920,2000,2040,2080,2100,2120,2160,2180,2200,2220,2300,2400,2800,3200,3600,3800,4000),
  (1,2,4,8,10,20,30,40,60,160,320,480,640,800,960,1120,1440,1600,1760,1920,2000,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3600,3680,3840,4000,4100,4160,4200,4800,4320,4350,4400,4480,4640,4800,5600,6400,6700,7200,7800,8000)),

  ((1,2,3,4,5,6,8,9,10,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,450,460,480,500,510,520,525,530,535,540,545,550,560,565,580,600,700,800,900,1000),
  (1,2,4,8,10,20,30,40,50,60,90,130,170,210,250,290,330,370,410,450,490,500,530,570,610,650,690,730,770,810,850,890,900,930,970,1000,1020,1030,1040,1050,1080,1120,1060,1100,1150,1200,1400,1600,1800,1900,2000),
  (1,2,4,8,10,20,30,40,60,80,160,240,320,400,480,560,640,720,800,880,960,1000,1040,1120,1200,1280,1360,1440,1520,1600,1680,1760,1800,1840,1920,2000,2040,2080,2100,2120,2160,2180,2200,2220,2300,2400,2800,3200,3600,3800,4000),
  (1,2,4,8,10,20,30,40,60,160,320,480,640,800,960,1120,1440,1600,1760,1920,2000,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3600,3680,3840,4000,4100,4160,4200,4800,4320,4350,4400,4480,4640,4800,5600,6400,6700,7200,7800,8000)),

  ((1,2,3,4,5,6,8,9,10,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,450,460,480,500,510,520,525,530,535,540,545,550,560,565,580,600,700,800,900,1000),
  (1,2,4,8,10,20,30,40,50,60,90,130,170,210,250,290,330,370,410,450,490,500,530,570,610,650,690,730,770,810,850,890,900,930,970,1000,1020,1030,1040,1050,1080,1120,1060,1100,1150,1200,1400,1600,1800,1900,2000),
  (1,2,4,8,10,20,30,40,60,80,160,240,320,400,480,560,640,720,800,880,960,1000,1040,1120,1200,1280,1360,1440,1520,1600,1680,1760,1800,1840,1920,2000,2040,2080,2100,2120,2160,2180,2200,2220,2300,2400,2800,3200,3600,3800,4000),
  (1,2,4,8,10,20,30,40,60,160,320,480,640,800,960,1120,1440,1600,1760,1920,2000,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3600,3680,3840,4000,4100,4160,4200,4800,4320,4350,4400,4480,4640,4800,5600,6400,6700,7200,7800,8000)),


  ((1,2,3,4,5,6,8,9,10,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,450,460,480,500,510,520,525,530,535,540,545,550,560,565,580,600,700,800,900,1000),
  (1,2,4,8,10,20,30,40,50,60,90,130,170,210,250,290,330,370,410,450,490,500,530,570,610,650,690,730,770,810,850,890,900,930,970,1000,1020,1030,1040,1050,1080,1120,1060,1100,1150,1200,1400,1600,1800,1900,2000),
  (1,2,4,8,10,20,30,40,60,80,160,240,320,400,480,560,640,720,800,880,960,1000,1040,1120,1200,1280,1360,1440,1520,1600,1680,1760,1800,1840,1920,2000,2040,2080,2100,2120,2160,2180,2200,2220,2300,2400,2800,3200,3600,3800,4000),
  (1,2,4,8,10,20,30,40,60,160,320,480,640,800,960,1120,1440,1600,1760,1920,2000,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3600,3680,3840,4000,4100,4160,4200,4800,4320,4350,4400,4480,4640,4800,5600,6400,6700,7200,7800,8000)),


  ((1,2,3,4,5,6,8,9,10,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300,320,340,360,380,400,420,440,450,460,480,500,510,520,525,530,535,540,545,550,560,565,580,600,700,800,900,1000),
  (1,2,4,8,10,20,30,40,50,60,90,130,170,210,250,290,330,370,410,450,490,500,530,570,610,650,690,730,770,810,850,890,900,930,970,1000,1020,1030,1040,1050,1080,1120,1060,1100,1150,1200,1400,1600,1800,1900,2000),
  (1,2,4,8,10,20,30,40,60,80,160,240,320,400,480,560,640,720,800,880,960,1000,1040,1120,1200,1280,1360,1440,1520,1600,1680,1760,1800,1840,1920,2000,2040,2080,2100,2120,2160,2180,2200,2220,2300,2400,2800,3200,3600,3800,4000),
  (1,2,4,8,10,20,30,40,60,160,320,480,640,800,960,1120,1440,1600,1760,1920,2000,2080,2240,2400,2560,2720,2880,3040,3200,3360,3520,3600,3680,3840,4000,4100,4160,4200,4800,4320,4350,4400,4480,4640,4800,5600,6400,6700,7200,7800,8000))
  );

  //массив для проверки по ТУ
  //1 индекс модификация прибора, 2 индекс частота среза(режим работы), 3 индекс проверяемые частоты на частоте среза
  masFrequency1: array [1..DEVICEINDEX,1..MODEINDEX,1..FREQINDEX1] of integer=(
  ((20,60,240,450,500,1000),
  (20,60,500,900,1000,2000),
  (20,60,1000,1800,2000,4000),
  (20,60,2000,3600,4000,8000)),

  ((20,60,240,450,500,1000),
  (20,60,500,900,1000,2000),
  (20,60,1000,1800,2000,4000),
  (20,60,2000,3600,4000,8000)),

  ((1,3,40,112,125,250),
  (1,3,120,225,250,500),
  (1,3,240,450,500,1000),
  (1,3,500,900,1000,2000)),

  ((10,30,60,112,125,250),
  (10,30,120,225,250,500),
  (10,30,240,450,500,1000),
  (10,30,500,900,1000,2000)),

  ((20,60,1000,1800,2000,4000),
  (20,60,2000,3600,4000,8000),
  (20,60,4000,7200,8000,16000),
  (20,60,8000,14400,16000,32000)));


  

  //массив амплитуд зависит от коэфициента усиления
  masAmpl: array [1..DEVICEINDEX,1..VOLTININDEX] of real=(
   (5.12,2.56,1.28,0.64,0.32,0.16,0.08,0.04),
   (1.28,0.64,0.32,0.16,0.08,0.04,0.02,0.01),
   (1.28,0.64,0.32,0.16,0.08,0.04,0.02,0.01),
   (1.28,0.64,0.32,0.16,0.08,0.04,0.02,0.01),
   (5.12,2.56,1.28,0.64,0.32,0.16,0.08,0.04)
  );

  //массив для хранения полученных напряжений
  masVolt:array[1..FREQINDEX] of real;

  //массив погрешностей
  Errors:array [1..3] of real;

  chNumber:integer;

  //переменные для хранения минимального и максимального значения проверяемого частотного диапазона
  frMin,frMax:integer;
  //переменная для хранения значения частоты F3 в любом из частотных диапазонов.
  frF3:integer;
  //переменная для хранения коэфициента усиления
  powKoef:integer;
  //переменная для хранения минимального напряжения любого из диапазонов частот
  minU:real;
  //переменная для хранения максимального напряжения любого из диапазонов частот
  maxU:real;
  //переменная для хранения напряжения частоты F3 любого из диапазонов частот
  Uf3:real;
  //переменные для хранение вычисленных погрешностей
  MPlus:real;
  MMinus:real;
  //переменная файла логов проверки прибора УЦФ
  ResultFile:text;
  //переменная файла логов для вывода дополнительной информации о подключении к АЦП Е20-10
  ACPWorkLogFile:text;

  probFile:text;
  strstr:string;
  probFile1:text;
  strstr1:string;
  //переменная строка которая будет дописываться в файл логов по проверке
  FileName:string;
  //переменная строка для ведения логов АЦП
  FileName2:string;
  //переменная для построения графика цифровых данных
  indGraph:integer;



  //переменные для работы с источником питания
  hUSBTMCLIB1:boolean;
  pStrout1:string;
	pStrin1:string;
  instrDescriptor1 :pointerchar;
  m_defaultRM_usbtmc_1: LongWord;
  m_findList_usbtmc_1: LongWord;
  m_nCount_1: LongWord;
  m_instr_usbtmc_1: LongWord;
  m_Timeout: integer = 7000;
  nWritten:LongWord;
  nRead: integer = 0;

// переменные для пункта 3.13.
p1,p2:real;

//переменные для пункта 3.15.
//массив для хранения строк
VoltMas:array [1..4] of real;
//массив для хранения соответствия напряжению на канале, значению по ТУ
flagMas:array [1..4] of boolean;
//массив состояний
strMasStr:array[1..4] of string;

//переменные для пункта 3.16.
masKoeff: array [1..8] of integer=(128,64,32,16,8,4,2,1);
masZn:array [1..32] of real; //Будут записываться значения по принципу: 1канал(DA1-DA8),2канал(DA1-DA8),3канал(DA1-DA8),4канал(DA1-DA8)
masF:array [1..32] of boolean;//Будут записываться значения true или false по принципу: 1канал(DA1-DA8),2канал(DA1-DA8),3канал(DA1-DA8),4канал(DA1-DA8)
masS:array [1..32] of string;//Будут записываться значения НОРМА или НЕ НОРМА по принципу: 1канал(DA1-DA8),2канал(DA1-DA8),3канал(DA1-DA8),4канал(DA1-DA8)

//переменные для пункта 3.17.
//массив для хранения максимальных не искаженных напряжений для каждого канала.
maxVoltMas: array [1..4] of real;
//массив истинности для массива maxVoltMas
trueMasVolt: array [1..4] of boolean;
//массив истинности в строковом виде.
trueMasStr: array [1..4] of string;
AmplitudeMas: array [1..190] of real=(
1.0,1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,1.9,
2.0,2.1,2.2,2.3,2.4,2.5,2.6,2.7,2.8,2.9,
3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,
4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,
5.0,5.1,5.2,5.3,5.4,5.5,5.6,5.7,5.8,5.9,
6.0,6.1,6.2,6.3,6.4,6.5,6.6,6.7,6.8,6.9,
7.0,7.1,7.2,7.3,7.4,7.5,7.6,7.7,7.8,7.9,
8.0,8.1,8.2,8.3,8.4,8.5,8.6,8.7,8.8,8.9,
9.0,9.1,9.2,9.3,9.4,9.5,9.6,9.7,9.8,9.9,
10.0,10.1,10.2,10.3,10.4,10.5,10.6,10.7,10.8,10.9,
11.0,11.1,11.2,11.3,11.4,11.5,11.6,11.7,11.8,11.9,
12.0,12.1,12.2,12.3,12.4,12.5,12.6,12.7,12.8,12.9,
13.0,13.1,13.2,13.3,13.4,13.5,13.6,13.7,13.8,13.9,
14.0,14.1,14.2,14.3,14.4,14.5,14.6,14.7,14.8,14.9,
15.0,15.1,15.2,15.3,15.4,15.5,15.6,15.7,15.8,15.9,
16.0,16.1,16.2,16.3,16.4,16.5,16.6,16.7,16.8,16.9,
17.0,17.1,17.2,17.3,17.4,17.5,17.6,17.7,17.8,17.9,
18.0,18.1,18.2,18.3,18.4,18.5,18.6,18.7,18.8,18.9,
19.0,19.1,19.2,19.3,19.4,19.5,19.6,19.7,19.8,19.9
);

//переменные для пункта 3.18.
masK: array [1..8] of integer=(1,2,4,8,16,32,64,128); 
masRezKoef:array [1..32] of real; //Будут записываться значения по принципу: 1канал(DA1-DA8),2канал(DA1-DA8),3канал(DA1-DA8),4канал(DA1-DA8)


//переменные для пункта 3.20.
mRez:array [1..16] of real; //Будут записываться значения по принципу: 1канал(DF1-DF4),2канал(DF1-DF4),3канал(DF1-DF4),4канал(DF1-DF4)
mTrue:array [1..16] of boolean;//Будут записываться значения true или false по принципу: 1канал(DF1-DF4),2канал(DF1-DF4),3канал(DF1-DF4),4канал(DF1-DF4)
mStr:array [1..16] of string;//Будут записываться значения НОРМА или НЕ НОРМА по принципу: 1канал(DF1-DF4),2канал(DF1-DF4),3канал(DF1-DF4),4канал(DF1-DF4)

//переменные для пункта 3.21.

//Переменные необходимые для работы с АЦП Е20-10.
//------------------------------------------------------------------------------
// номер ошибки при выполнения потока сбора данных
ReadThreadErrorNumber : WORD;
// интерфейс модуля E20-10
pModule : ILE2010;
// идентификатор потока ввода
hReadThread : THANDLE;
// Идентификатор файла данных
FileHandle: Integer;
// указатель на буфер для данных
Buffer : TShortrArray;
// флажок завершения потоков ввода данных
IsReadThreadComplete : boolean;
// экранный счетчик-индикатор
Counter, OldCounter : WORD;
// версия библиотеки Lusbapi.dll
DllVersion : DWORD;
// идентификатор устройства
ModuleHandle : THandle;
// название модуля
ModuleName: String;
// скорость работы шины USB
UsbSpeed : BYTE;
// структура с полной информацией о модуле
ModuleDescription : MODULE_DESCRIPTION_E2010;
// буфер пользовательского ППЗУ
UserFlash : USER_FLASH_E2010;
// структура параметров работы АЦП
ap : ADC_PARS_E2010;
// кол-во отсчетов в запросе ReadData
DataStep : DWORD = 1024*1024;
//Идентификатор потока ввода
ReadTid : DWORD;
// состояние процесса сбора данных
DataState : DATA_STATE_E2010;
//------------------------------------------------------------------------------

//массив для хранения значений с АЦП для их дальнейшего вывода на форму. всего байт в файле 2097152*2 . количество значений 2097152
masACPdat:array [1..SIZEDIGMAS] of smallint;
//отдельные массивы для хранения значений Оцифрованных данных с УЦФ
DigMasCh1:array [1..round(SIZEDIGMAS/16)] of smallint;
DigMasCh2:array [1..round(SIZEDIGMAS/16)] of smallint;
DigMasCh3:array [1..round(SIZEDIGMAS/16)] of smallint;
DigMasCh4:array [1..round(SIZEDIGMAS/16)] of smallint;

//динамический массив для хранения значений Т1
masT1:array of double;
//динамический массив для хранения значений Т2
masT2:array of double;
//динамический массив для хранения значений Амплитуд
masAmpl_test21:array of integer;
//счетчик количества значений T1 в динамическом массиве.
ch_T1:integer;
//счетчик количества значений T2 в динамическом массиве.
ch_T2:integer;
//счетчик количества значений Амплитуд в динамический массиве
ch_Ampl:integer;
//счетчик для вывода содержимого динамического массива Т1
masT1ch:integer;
//счетчик для вывода содержимого динамического массива Т2
masT2ch:integer;
//счетчик для вывода содержимого динамического массива Амплитуд
masAmplch:integer;
//индикаторы правильности полученных амплитуд
testFlagH1:boolean;
testFlagH2:boolean;
testFlagH3:boolean;
testFlagH4:boolean;
//флаг-признак, что  T1 попадает в диапазон обозначенный в ТУ 3.21.
t1Flag:boolean;
//флаг-признак, что  T2 попадает в диапазон обозначенный в ТУ 3.21.
t2Flag:boolean;
//переменные индикаторы для формирования признака удачного или неудачного тестирования пункта ТУ 3.21
flagTest21FCh1:boolean;
flagTest21FCh2:boolean;
flagTest21FCh3:boolean;
flagTest21FCh4:boolean;

//переменные для пункта 3.22.
//содержит номер байта(2-1канал,3-2канал,4-3канал,5-4канал) для вывода цифровых данных с адаптера
indexByte:integer;
//Массив для хранения цифровых значений с адаптера в мВ, по нему ведется подсчет амплитуды и действующего значения
masDigitalZnachActual:array [1..NUMBERPOINTS] of double;
//массив буфер для записи его значений в masDigitalZnachActual
masDigitalZnachBuf:array [1..NUMBERPOINTS] of double;
//переменная содержащая в себе коэфициент для преобразования в мВ
kof:double;
//счетчик для реализации записи в массив   masDigitalZnachActual
kMasDig:integer;
// для хранения действующего значения
DVolume:double;
//амплитудное значение.
AmplVolume:double;

MasDVolume:array [1..4] of double;

StrDigMas:array [1..4] of string;

TrueDigMas:array [1..4] of boolean;


//------------------------------------------------------------------------------
//переменные индикаторы успешности проверок

testTU_3_13Fin:boolean;
testTU_3_15Fin:boolean;
testTU_3_16Fin:boolean;
testTU_3_17Fin:boolean;
testTU_3_18Fin:boolean;
testTU_3_19Fin:boolean;
testTU_3_20Fin:boolean;
testTU_3_21Fin:boolean;
testTU_3_22Fin:boolean;
//------------------------------------------------------------------------------

implementation

uses Unit2;

function viOpenDefaultRM(vi:pLongWord): integer;                                                             stdcall; external 'visa32.DLL' name 'viOpenDefaultRM';
//Переобъявление функций для работы с источником питания. Одноименные функции только без 1 будут вызываться для работы с вольтметром. Разница в том что в переопределенном случае в одном из параметров будет передаваться тип string. А в другом тип pchar.
function viWrite1(vi:LongWord; name:string; len:LongWord; retval:pLongWord): integer;                         stdcall; external 'visa32.DLL' name 'viWrite';
function viRead1(vi:LongWord; name: string; len: LongWord; retval:pLongWord): integer;                        stdcall; external 'visa32.DLL' name 'viRead';

{$R *.dfm}

//процедура для записи в файл логов проверки УЦФ

procedure SaveResultToFile(str:string);
begin
Writeln(ResultFile,str);
//exit
end;

procedure SaveResultToFile3(str:string);
begin
Writeln(probfile,str);
//exit
end;

procedure SaveResultToFile4(str:string);
begin
Writeln(probfile1,str);
//exit
end;

//процедура для записи в файл логов проверки УЦФ

procedure SaveResultToFile2(str:string);
begin
Writeln(ACPWorkLogFile,str);
//exit
end;


//Работа с АЦП Е20-10**********************************************************
//==============================================================================
//Функции для работы с АЦП Е20-10

//------------------------------------------------------------------------------
// ожидание завершения выполнения очередного запроса на сбор данных
//------------------------------------------------------------------------------
function WaitingForRequestCompleted(var ReadOv : OVERLAPPED) : boolean;
var 	BytesTransferred : DWORD;
begin
	Result := true;
	while true do
	   begin
			if GetOverlappedResult(ModuleHandle, ReadOv, BytesTransferred, FALSE) then break
			else if (GetLastError() <>  ERROR_IO_INCOMPLETE) then
				begin
					// ошибка ожидания ввода очередной порции данных
					ReadThreadErrorNumber := 3; Result := false; break;
				end
		 //	else if IsEscKeyPressed() then
			 //	begin
					// программа прервана (нажата клавиша ESC)
			 //		ReadThreadErrorNumber := 4; Result := false; break;
				//end
			else Sleep(20);
		end;
end;


//------------------------------------------------------------------------------
//      фукция запускаемая в качестве отдельного потока
//             для сбора данных c модуля E20-10
//------------------------------------------------------------------------------
function ReadThread(var param : pointer): DWORD;
var
	i : WORD ;
	RequestNumber : WORD;
	// массив OVERLAPPED структур из двух элементов
	ReadOv : array[0..1] of OVERLAPPED;
	// массив структур с параметрами запроса на ввод/вывод данных
	IoReq : array[0..1] of IO_REQUEST_LUSBAPI;

begin
	Result := 0;
	// остановим работу АЦП и одновременно сбросим USB-канал чтения данных
	if not pModule.STOP_ADC() then begin ReadThreadErrorNumber := 1; IsReadThreadComplete := true; exit; end;

	// формируем необходимые для сбора данных структуры
	for i := 0 to 1 do
		begin
			// инициализация структуры типа OVERLAPPED
			ZeroMemory(@ReadOv[i], sizeof(OVERLAPPED));
			// создаём событие для асинхронного запроса
			ReadOv[i].hEvent := CreateEvent(nil, FALSE , FALSE, nil);
			// формируем структуру IoReq
			IoReq[i].Buffer := Pointer(Buffer[i]);
			IoReq[i].NumberOfWordsToPass := DataStep;
			IoReq[i].NumberOfWordsPassed := 0;
			IoReq[i].Overlapped := @ReadOv[i];
			IoReq[i].TimeOut := Round(Int(DataStep/ap.KadrRate)) + 1000;
		end;

	// заранее закажем первый асинхронный сбор данных в Buffer
	RequestNumber := 0;
	if not pModule.ReadData(@IoReq[RequestNumber]) then
		begin
			CloseHandle(IoReq[0].Overlapped.hEvent); CloseHandle(IoReq[1].Overlapped.hEvent); ReadThreadErrorNumber := 2; IsReadThreadComplete := true; exit;
		end;

	// а теперь можно запускать сбор данных
	if pModule.START_ADC() then
   	begin
			// цикл сбора данных
			for i := 1 to (NBlockToRead-1) do
				begin
					RequestNumber := RequestNumber xor $1;
					// сделаем запрос на очередную порции вводимых данных
					if not pModule.ReadData(@IoReq[RequestNumber]) then
						begin
							ReadThreadErrorNumber := 2; break;
						end;

					// ожидание выполнение очередного запроса на сбор данных
//					if not WaitingForRequestCompleted(IoReq[RequestNumber xor $1].Overlapped^) then break;
					if not WaitForSingleObject(IoReq[RequestNumber xor $1].Overlapped.hEvent, IoReq[RequestNumber xor $1].TimeOut) = WAIT_TIMEOUT then begin ReadThreadErrorNumber := $03; break; end;

					// попробуем получить текущее состояние процесса сбора данных
					if not pModule.GET_DATA_STATE(@DataState) then begin ReadThreadErrorNumber := 7; break; end;
					// теперь можно проверить этот признак переполнения внутреннего буфера модуля
					if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then begin ReadThreadErrorNumber := 8; break; end;

					// пишем файл очередную порцию данных
					if FileWrite(FileHandle, Buffer[RequestNumber xor $1][0], DataStep*sizeof(SHORT)) = -1 then begin ReadThreadErrorNumber := $5; break; end;

					// для примера вносим задержку - для нарушения целостности получаемых данных
//					if i = 33 then Sleep(1000);

					// были ли ошибки или пользователь прервал ввод данных?
					if ReadThreadErrorNumber <> 0 then break
					// была ли программа прервана (нажата клавиша ESC)?
					//else if IsEscKeyPressed() then begin ReadThreadErrorNumber := 4; break; end //прервать нельзя
					// небольшая задержечка
					else Sleep(20);
					// увеличиваем счётчик полученных блоков данных
					Inc(Counter);
				end
		end
	else ReadThreadErrorNumber := 6;

	// последняя порция данных
	if ReadThreadErrorNumber = 0 then
		begin
			// ждём окончания операции сбора последней порции данных
			if WaitingForRequestCompleted(IoReq[RequestNumber].Overlapped^) then
				begin
					// увеличим счётчик полученных блоков данных
		         Inc(Counter);
					// пишем файл последную порцию данных
					if FileWrite(FileHandle, Buffer[RequestNumber][0], DataStep*sizeof(SHORT)) = -1 then ReadThreadErrorNumber := $5;
				end;
		end;

	// остановим сбор данных c АЦП
	// !!!ВАЖНО!!! Если необходима достоверная информация о целостности
	// ВСЕХ собраных данных, то функцию STOP_ADC() следует выполнять не позднее,
	// чем через 800 мс после окончания ввода последней порции данных.
	// Для заданной частоты сбора данных в 5 МГц эта величина определяет время
	// переполнения внутренненого FIFO буфера модуля, который имеет размер 8 Мб.
	if not pModule.STOP_ADC() then ReadThreadErrorNumber := 1;
	// если нужно - анализируем окончательный признак переполнения внутреннего буфера модуля
	if (DataState.BufferOverrun <> (1 shl BUFFER_OVERRUN_E2010)) then
		begin
			// попробуем получить окончательный состояние процесса сбора данных
			if not pModule.GET_DATA_STATE(@DataState) then ReadThreadErrorNumber := 7
			// теперь можно проверить этот признак переполнения внутреннего буфера модуля
		   else if (DataState.BufferOverrun = (1 shl BUFFER_OVERRUN_E2010)) then ReadThreadErrorNumber := 8;
		end;
	// если надо, то прервём все незавершённые асинхронные запросы
	if not CancelIo(ModuleHandle) then ReadThreadErrorNumber := 9;
	// освободим идентификаторы событий
	CloseHandle(IoReq[0].Overlapped.hEvent); CloseHandle(IoReq[1].Overlapped.hEvent);
	// задержечка
	Sleep(100);
	// установим флажок окончания потока сбора данных
	IsReadThreadComplete := true;

end;

//------------------------------------------------------------------------------
// аварийное завершение программы
//------------------------------------------------------------------------------
procedure ExitProgram(ErrorString: string; AbortionFlag : bool = true);
var
	i_ind : WORD ;
begin
	// освободим интерфейс модуля
	if pModule <> nil then
		begin
			// освободим интерфейс модуля
			if not pModule.ReleaseLInstance() then  SaveResultToFile2(' ReleaseLInstance() --> Bad')
			else SaveResultToFile2(' ReleaseLInstance() --> OK');
			// обнулим указатель на интерфейс модуля
			pModule := nil;
		end;

	// освободим идентификатор потока сбора данных
	if hReadThread = THANDLE(nil) then CloseHandle(hReadThread);
  // закроем файл данных
	if FileHandle <> -1 then FileClose(FileHandle);
	// освободим память из-под буферов данных
	for i_ind := 0 to 1 do Buffer[i_ind] := nil;

	// если нужно - аварийно завершаем программу
	if AbortionFlag = true then halt;
end;


//------------------------------------------------------------------------------
// отображение ошибок возникших во время работы потока сбора данных
//------------------------------------------------------------------------------
procedure ShowThreadErrorMessage;
begin
	case ReadThreadErrorNumber of
		$0 : ;
		$1 : WriteLn(' ADC Thread: STOP_ADC() --> Bad! :(((');
		$2 : WriteLn(' ADC Thread: ReadData() --> Bad :(((');
		$3 : WriteLn(' ADC Thread: Waiting data Error! :(((');
		// если программа была злобно прервана, предъявим ноту протеста
		$4 : WriteLn(' ADC Thread: The program was terminated! :(((');
		$5 : WriteLn(' ADC Thread: Writing data file error! :(((');
		$6 : WriteLn(' ADC Thread: START_ADC() --> Bad :(((');
		$7 : WriteLn(' ADC Thread: GET_DATA_STATE() --> Bad :(((');
		$8 : WriteLn(' ADC Thread: BUFFER OVERRUN --> Bad :(((');
		$9 : WriteLn(' ADC Thread: Can''t cancel pending input and output (I/O) operations! :(((');
		else WriteLn(' ADC Thread: Unknown error! :(((');
	end;
end;
//------------------------------------------------------------------------------

//==============================================================================



//Функции для работы с источником питания.
//------------------------------------------------------------------------------
//Неодбходима для подключения к источнику питания. В качестве параметра включения передается '0'
function ConnectToPowerSupply(str:string):integer;
var
  status:integer;
  viAttr:Longword;
  i:integer;
begin
  hUSBTMCLIB1:=true;
  setlength(pStrin1,64);
  setlength(pStrout1,64);
  setlength(instrDescriptor1,255);
  viAttr:=$3FFF001A;
	status:= viOpenDefaultRM(@m_defaultRM_usbtmc_1);
	if (status < 0) then
	begin
		viClose(m_defaultRM_usbtmc_1);
		hUSBTMCLIB1 := false;
		m_defaultRM_usbtmc_1:= 0;
    showmessage('viOpenDefaultRM  '+inttostr(status));
    exit;
	end
	else
	begin
		status:= viFindRsrc(m_defaultRM_usbtmc_1, 'USB[0-9]::0x0471::0x0666::NI-VISA-'+str+'::RAW', @m_findList_usbtmc_1, @m_nCount_1, instrDescriptor1);
 		if (status < 0) then
    begin
			status:= viFindRsrc (m_defaultRM_usbtmc_1, 'USB[0-9]::0x0471::0x0666::NI-VISA-'+str+'::RAW', @m_findList_usbtmc_1, @m_nCount_1, instrDescriptor1);
			if (status < 0) then
			begin
				viClose(m_defaultRM_usbtmc_1);
				hUSBTMCLIB1 := false;
				m_defaultRM_usbtmc_1:= 0;
			end
			else
			begin
				viOpen(m_defaultRM_usbtmc_1, instrDescriptor1, 0, 0, @m_instr_usbtmc_1);
 				status:= viSetAttribute(m_instr_usbtmc_1, viAttr, m_Timeout);
			end
		end
		else
		begin
			status:= viOpen(m_defaultRM_usbtmc_1, instrDescriptor1, 0, 0, @m_instr_usbtmc_1);
  		status:= viSetAttribute(m_instr_usbtmc_1, viAttr, m_Timeout);
		end
	end;
  result:=status;
end;

//Вспомогательная функция для работы с источником питания. Для пересылки управляющей команды на источник питания
function SendCommandToPowerSupply(command:string;size:integer):String;
var
  status:integer;
  viAttr:Longword;
  s:string;
  i,len:integer;
begin
  len:=16;
  while (true) do
  begin
    pStrout1:=command+#13;
	  status := viWrite1(m_instr_usbtmc_1, pStrout1, Length(command)+2, @nWritten);

	  if (status<>0) then
	  begin
		  viClose(m_defaultRM_usbtmc_1);
		  hUSBTMCLIB1 := false;
		  m_defaultRM_usbtmc_1 := 0;
      exit;
	  end;
    status := viRead1(m_instr_usbtmc_1, pStrin1, len, @nRead);
    Result:=pStrin1;
    Result[nRead+1]:=#0;
    if nRead=size then break;
  end;
end;

//Установка на источнике питания необходимого напряжения.
function SetVoltageOnPowerSupply(V:string;mV:string):byte;
var
s:string;
begin
  s:=SendCommandToPowerSupply('VOLT 0 '+V+mV,3);
  if ((s[1]='O') and (s[2]='K')) then Result:=1
    else Result:=0;
  s:=SendCommandToPowerSupply('SOUT 1',3);
  if ((s[1]='O') and (s[2]='K')) then Result:=1
    else Result:=0;
end;

//Выводить или нет напряжение на выход. '0'-нет. '1'-да. Кнопка On
function ControlVoltageOnPowerSupply(value:string):boolean;
var
  s:string;
begin
    s:=SendCommandToPowerSupply('SOUT '+value,3);
    if ((s[1]='O') and (s[2]='K')) then Result:=true
      else Result:=false;
end;

//Функция для считывания тока в источника питания.
function GetCurrentFromPowerSupply():integer;
var
  s,s_tmp:string;
begin
  s:=SendCommandToPowerSupply('GETD',13);
  s_tmp:=s[6]+s[7]+s[8];
  Result:=StrToInt(s_tmp);
end;
//-------------------------------------------------------------------------------


//Вспомогательные функции для реализации доступности, недоступности элементов, для увеличения надежности программы

//Недоступность элементов тестирования.
procedure AllDisable();
begin
form1.GroupBox4.Enabled:=false;
form1.ComboBox8.Enabled:=false;

form1.GroupBox5.Enabled:=false;
form1.RadioButton1.Enabled:=false;
form1.RadioButton2.Enabled:=false;
form1.RadioButton3.Enabled:=false;
form1.RadioButton4.Enabled:=false;
form1.Button5.Enabled:=false;
form1.Button4.Enabled:=false;
form1.Button1.Enabled:=false;

form1.GroupBox1.Enabled:=false;
form1.Label7.Enabled:=false;
form1.Label1.Enabled:=false;
form1.Label2.Enabled:=false;
form1.Label3.Enabled:=false;
form1.ComboBox7.Enabled:=false;
form1.ComboBox1.Enabled:=false;
form1.ComboBox2.Enabled:=false;
form1.ComboBox3.Enabled:=false;


form1.GroupBox2.Enabled:=false;
form1.ComboBox4.Enabled:=false;

form1.Button3.Enabled:=false;

form1.Button6.Enabled:=false;
end;

//Доступность элементов тестирования.
procedure AllEnable();
begin
form1.GroupBox4.Enabled:=true;
form1.ComboBox8.Enabled:=true;

form1.GroupBox5.Enabled:=true;
form1.RadioButton1.Enabled:=true;
form1.RadioButton2.Enabled:=true;
form1.RadioButton3.Enabled:=true;
form1.RadioButton4.Enabled:=true;
form1.Button5.Enabled:=true;

form1.GroupBox1.Enabled:=true;
form1.Label7.Enabled:=true;
form1.Label1.Enabled:=true;
form1.Label2.Enabled:=true;
form1.Label3.Enabled:=true;
form1.ComboBox7.Enabled:=true;
form1.ComboBox1.Enabled:=true;
form1.ComboBox2.Enabled:=true;
form1.ComboBox3.Enabled:=true;

form1.GroupBox2.Enabled:=true;
form1.ComboBox4.Enabled:=true;

form1.Label4.Enabled:=false;
form1.Edit1.Enabled:=false;
end;






//==============================================================================
//Вспомогательные функции для работы с ИСД
//==============================================================================

//Функция задержки
//==============================================================================
function Wait(value:integer):boolean;
var
  i:integer;
begin
  for i:=1 to value do
  begin
    sleep(3);
    application.ProcessMessages;
  end;
end;
//==============================================================================

//Функция подключения к ИСД
function ConnectToISD():boolean;
begin
  try
    form1.HTTP1.Connect(1000);
    Result:=true;
  except
    Result:=false;
  end;
end;
//==============================================================================

//Функция отключения от ИСД
procedure DisconnectFromISD();
begin
  form1.HTTP1.Disconnect;
end;
//==============================================================================

//Посылаем команду на замыкание необходимых каналов
function CommutateChannelOnISD(NumberChannel:integer;signalVolume:string):boolean;
var
  str:string;
begin
  str:=form1.HTTP1.Get('http://'+form1.HTTP1.Host+'/type=2num='+IntToStr(NumberChannel)+'val='+signalVolume);
  if (str<>'Команда успешно выполнена!') then
  begin
    showmessage('Иммитатор сигналов датчиков не отвечает!');
    Result:=false;
  end
  else Result:=true;
end;
//==============================================================================

//Сбросить(разомкнуть) все каналы в 0.
function DecommutateAllChannels():boolean;
var
  str:string;
  i:integer;
begin
  if (ConnectToISD()=false) then exit;
  for i:=1 to 64 do
  begin
    str:=form1.HTTP1.Get('http://'+form1.HTTP1.Host+'/type=2num='+IntToStr(i)+'val=0');
    if (str<>'Команда успешно выполнена!') then
    begin
      showmessage('Иммитатор сигналов датчиков не отвечает!');
      Result:=false;
    end
    else Result:=true;
  end;
  //DisconnectFromISD;
end;
//==============================================================================

//Функция определения режима усиления(для канала 1)
function WhatISPowerMode(A0:string;A1:string;A2:string):string;
begin
//DA1
if((A0='1')and(A1='1')and(A2='1'))then WhatISPowerMode:='DA1';
//DA2
if((A0='0')and(A1='1')and(A2='1'))then WhatISPowerMode:='DA2';
//DA3
if((A0='1')and(A1='0')and(A2='1'))then WhatISPowerMode:='DA3';
//DA4
if((A0='0')and(A1='0')and(A2='1'))then WhatISPowerMode:='DA4';
//DA5
if((A0='1')and(A1='1')and(A2='0'))then WhatISPowerMode:='DA5';
//DA6
if((A0='0')and(A1='1')and(A2='0'))then WhatISPowerMode:='DA6';
//DA7
if((A0='1')and(A1='0')and(A2='0'))then WhatISPowerMode:='DA7';
//DA8
if((A0='0')and(A1='0')and(A2='0'))then WhatISPowerMode:='DA8';
end;

//Функция определения режима частот(для канала 1)
function WhatISFreqMode(FA0:string;FA1:string;FA2:string):string;
begin
//DF1
if((FA0='0')and(FA1='0')and(FA2='1'))then Result:='DF1';
//DF2
if((FA0='1')and(FA1='1')and(FA2='0'))then Result:='DF2';
//DF3
if((FA0='0')and(FA1='1')and(FA2='0'))then Result:='DF3';
//DF4
if((FA0='1')and(FA1='0')and(FA2='0'))then Result:='DF4';
end;


//функция для проверки подключен ли генератор или вольтметр
function TestConnect(Name:string; var m_defaultRM_usbtmc_loc, m_instr_usbtmc_loc:Longword; vAtr:Longword; m_Timeout: integer):integer;
var
  status:integer;
  viAttr:Longword;
  i:integer;
  m_findList_usbtmc: LongWord;
  m_nCount: LongWord;
  instrDescriptor:pointerchar;
begin
  setlength(instrDescriptor,255);

  result:=0;
	status:= viOpenDefaultRM(@m_defaultRM_usbtmc_loc);
	if (status < 0) then
	begin
		viClose(m_defaultRM_usbtmc_loc);
		m_defaultRM_usbtmc_loc:= 0;
    result:=-1;
    showmessage('       Генератор сигналов не найден!');
	end
	else
	begin
		status:= viFindRsrc(m_defaultRM_usbtmc_loc, name, @m_findList_usbtmc, @m_nCount, instrDescriptor);
 		if (status < 0) then
    begin
			status:= viFindRsrc (m_defaultRM_usbtmc_loc, 'USB[0-9]*::5710::3501::?*INSTR', @m_findList_usbtmc, @m_nCount, instrDescriptor);
			if (status < 0) then
			begin
				viClose(m_defaultRM_usbtmc_loc);
        result:=-1;
        showmessage('       Генератор сигналов не найден!');
				m_defaultRM_usbtmc_loc:= 0;
        exit;
			end
			else
			begin
				viOpen(m_defaultRM_usbtmc_loc, instrDescriptor, 0, 0, @m_instr_usbtmc_loc);
				status:= viSetAttribute(m_instr_usbtmc_loc, vatr, m_Timeout);
			end
		end
		else
		begin
			status:= viOpen(m_defaultRM_usbtmc_loc, instrDescriptor, 0, 0, @m_instr_usbtmc_loc);
  		status:= viSetAttribute(m_instr_usbtmc_loc, viAttr, m_Timeout);
		end
	end;

  result:=status;
end;

//Проверяем какая выбрана модификация прибора( панель выбор прибора) и какой выбран режим работы прибора(частота среза)
//внешний case  модификация прибора( панель выбор прибора) 4 модификации
//внутренний case режим работы прибора(частота среза) 4 режима
procedure setFreqUCF(deviceModif:integer;numberMode:integer);
begin
case (deviceModif) of
0: begin
    case (numberMode) of
      0: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'0');
         end;
      1: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'0');
         end;
      2: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'1');
         end;
      3: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
    end;
   end;
1: begin
    case (numberMode) of
      0: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'0');
         end;
      1: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'0');
         end;
      2: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'1');
         end;
      3: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
    end;
   end;
2:begin
    case (numberMode) of
      0: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'0');
         end;
      1: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'0');
         end;
      2: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'1');
         end;
      3: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
    end;
   end;
3:begin
    case (numberMode) of
      0: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'0');
         end;
      1: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'0');
         end;
      2: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'1');
         end;
      3: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
    end;
   end;
4:begin
    case (numberMode) of
      0: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
      1: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'0');
         end;
      2: begin
         CommutateChannelOnISD(20,'1');
         CommutateChannelOnISD(19,'0');
         CommutateChannelOnISD(18,'0');
         CommutateChannelOnISD(17,'1');
         end;
      3: begin
         CommutateChannelOnISD(20,'0');
         CommutateChannelOnISD(19,'1');
         CommutateChannelOnISD(18,'1');
         CommutateChannelOnISD(17,'1');
         end;
    end;
   end;
end;
end;

//Как только изменяем Установку частоты среза тут же запускаем функцию перехода в нужный режим
procedure TForm1.ComboBox4Change(Sender: TObject);
begin
setFreqUCF(form1.ComboBox8.ItemIndex,form1.ComboBox4.ItemIndex);
end;

//Процедура по установке коэфициента усиления для каждого канала в зависимости от переданного номера канала
procedure setKoef(numberchannel:integer;powerKoef:integer);
var
channel1:integer;
channel2:integer;
channel3:integer;
begin
if (numberchannel=1) then
  begin
  channel1:=1;
  channel2:=2;
  channel3:=3;
  end;
if (numberchannel=2) then
  begin
  channel1:=5;
  channel2:=6;
  channel3:=7;
  end;
if (numberchannel=3) then
  begin
  channel1:=9;
  channel2:=10;
  channel3:=11;
  end;
if (numberchannel=4) then
  begin
  channel1:=13;
  channel2:=14;
  channel3:=15;
  end;

//замыкаем нужные каналы в зависимости от переданного номера и выбранного коэфициента усиления
case (powerKoef) of
1: begin
   CommutateChannelOnISD(channel1,'1');
   CommutateChannelOnISD(channel2,'1');
   CommutateChannelOnISD(channel3,'1');
   end;
2: begin
   CommutateChannelOnISD(channel1,'0');
   CommutateChannelOnISD(channel2,'1');
   CommutateChannelOnISD(channel3,'1');
   end;
4: begin
   CommutateChannelOnISD(channel1,'1');
   CommutateChannelOnISD(channel2,'0');
   CommutateChannelOnISD(channel3,'1');
   end;
8: begin
   CommutateChannelOnISD(channel1,'0');
   CommutateChannelOnISD(channel2,'0');
   CommutateChannelOnISD(channel3,'1');
   end;
16: begin
   CommutateChannelOnISD(channel1,'1');
   CommutateChannelOnISD(channel2,'1');
   CommutateChannelOnISD(channel3,'0');
   end;
32: begin
   CommutateChannelOnISD(channel1,'0');
   CommutateChannelOnISD(channel2,'1');
   CommutateChannelOnISD(channel3,'0');
   end;
64: begin
   CommutateChannelOnISD(channel1,'1');
   CommutateChannelOnISD(channel2,'0');
   CommutateChannelOnISD(channel3,'0');
   end;
128: begin
   CommutateChannelOnISD(channel1,'0');
   CommutateChannelOnISD(channel2,'0');
   CommutateChannelOnISD(channel3,'0');
   end;
end;
end;

//Функции по работе с вольтметром
//------------------------------------------------------------------------------
//Считывает значение с вольтметра
function GetDatStr(m_instr_usbtmc_loc:Longword; var dat:string):integer;
var
  i:integer;
  len:integer;
  status:integer;
  pStrin:pointerchar;
  nRead: integer;
  stbuffer:string;
begin
  dat:='';
  setlength(pStrin,64);
  sleep(25);//100
  len:= 64;
  status := viRead(m_instr_usbtmc_loc, pStrin, len, @nRead);
	if (nRead > 0) then
	begin
    stbuffer:='';
    for i:=0 to (nRead-1) do stbuffer:=stbuffer+pStrin[i];
	end;
  dat:=stbuffer;
end;

//Отправка команды на вольтметр(переключение вольтметра в режим измерения действующего значения)
function SetConf(m_instr_usbtmc_loc:Longword; command:string):integer;
var
  pStrout:pointerchar;
  i:integer;
  nWritten:LongWord;
begin
  setlength(pStrout,64);
  for i:=0 to length(command) do  pStrout[i]:=command[i+1];
	result:= viWrite(m_instr_usbtmc_loc, pStrout, length(command), @nWritten);
	Sleep(30);
end;



//Функции по работе с генератором сигналов
//-------------------------------------------------------------------------------
procedure SetFrequencyOnGenerator(Freq:integer;Ampl:real);
begin
  SetConf(m_instr_usbtmc[1],'VOLT:UNIT VPP');
  SetConf(m_instr_usbtmc[1],'APPL:SIN '+ inttostr(Freq)+','+floattostr(Ampl)+',0.0');
  SetConf(m_instr_usbtmc[1],'PHAS 0');
  SetConf(m_instr_usbtmc[1],'OUTP ON');
end;
//-------------------------------------------------------------------------------



//Обработчик кнопки Подключиться к ИСД
procedure TForm1.Button1Click(Sender: TObject);
var
flag:boolean;
i:integer;
begin
//создаем файл с указанным серийным номером в названии
//связываем файловую переменную с именем файла. Заменяем : на . и создание файла.

FileName:='Результаты/Результаты_проверки_ФНЧ_№'+Form1.Edit1.Text+'_в_нормальных_условиях_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
for i:=1 to length(FileName) do if (FileName[i]=':') then FileName[i]:='.';
 //FileName:='12345.txt';
AssignFile(ResultFile,FileName);
ReWrite(ResultFile);

//Проверяем включенность ИСД

//Флаг хранит успешность подключения к ИСД
flag:=ConnectToISD;
//Успешно . Делаем кнопки для дальнейшего тестирования доступными
if(flag) then
  begin
   //Вызываем вспомогательную процедуру
   AllEnable;
  end;

if(flag=false) then
  begin
    showmessage('Подключится к ИСД не удалось!');
    exit;
  end;
//------------------------------------------------------------------------------

//Выставляем по умолчанию первый канал для просмотра и вывода цифровых данных на график
form1.RadioButton5.Checked:=true;

//выставление коеф усиления в 1
setKoef(1,1);
setKoef(2,1);
setKoef(3,1);
setKoef(4,1);

//Устанавливаем режим по умочанию
setFreqUCF(0,0);





form1.Button1.Enabled:=false;


end;



procedure TForm1.ComboBox3Change(Sender: TObject);
begin
setKoef(4,strtoint(Form1.ComboBox3.Items[Form1.ComboBox3.ItemIndex]));
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
setKoef(3,strtoint(Form1.ComboBox2.Items[Form1.ComboBox2.ItemIndex]));
end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
setKoef(2,strtoint(Form1.ComboBox1.Items[Form1.ComboBox1.ItemIndex]));
end;


procedure TForm1.FormCreate(Sender: TObject);
var
IniFile:TIniFile;
begin
//обнуление переменных частот
frMin:=0;
frMax:=0;
frF3:=0;
chNumber:=0;
powKoef:=0;
minU:=0.0;
maxU:=0.0;
Uf3:=0.0;
MPlus:=0.0;
MMinus:=0.0;
indGraph:=0;
//ТУ 3.13.
p1:=0;
p2:=0;

//Инициализация конвы для рисования графика
image1.Canvas.Rectangle(0,0,image1.Width,image1.Height);
image1.Canvas.MoveTo(0,0);

//Инициализация доступности панелей для тестирования УЦФ
//Вызов вспомогательной процедуры
AllDisable;

//связываем переменную ini-файла с конфигурационным файлом
IniFile:=TIniFile.Create(ExtractFileDir(ParamStr(0))+'/ConfigUCF.ini');
//
HostAdapterRS485:=IniFile.ReadString('Adapter_RS485','IP_address','0');
//третий параметр это значение по умолчанию, если с ini-файла не удалось считать
//проверяем удалось ли считать ip-адрес
if (HostAdapterRS485='0') then
  begin
    showmessage('Файл "ConfigUCF.ini" отсутствует или содержит некорректные данные!');
    Form1.Close;
    Halt;
  end;
//присваиваем номер порта
PortAdapterRS485:=IniFile.ReadInteger('Adapter_RS485','Port',1000);
//присваиваем ip-адрес ИСД1
HostISD1:=IniFile.ReadString('ISD_1','IP_address','192.168.0.97');
//присваиваем ip-адрес ИСД2
HostISD2:=IniFile.ReadString('ISD_2','IP_address','192.168.0.96');
//связываем ИСД1 с компонентом для генерации GET-запросов
HTTP1.Host:=HostISD1;
//инициализируем генератор
RigolDg1022:=IniFile.ReadString('Generator','Serial_number','USB[0-9]*::0x1AB1::0x0589::?*INSTR');
IniFile.Free;

if (TestConnect(RigolDg1022,m_defaultRM_usbtmc[1],m_instr_usbtmc[1],viAttr,Timeout)=-1) then
begin
  showmessage('Генератор не подключен!');    //Инициализация генератора
  Application.Terminate; //плавное закрытие программы
end;
if (TestConnect(AkipV7_78_1,m_defaultRM_usbtmc[0],m_instr_usbtmc[0],viAttr,Timeout)=-1) then
begin
  showmessage('Вольтметр не подключен!');
  Application.Terminate;
end;
//При инициализации программы переводим вольтметр в режим измерения действующего значения напряжени(По умолчанию измеряется постоянная составляющая)
SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');

form1.Label4.Enabled:=true;
form1.Edit1.Enabled:=true;

end;

procedure TForm1.ComboBox7Change(Sender: TObject);
begin
case (Form1.ComboBox7.ItemIndex) of
0: begin
   CommutateChannelOnISD(1,'1');
   CommutateChannelOnISD(2,'1');
   CommutateChannelOnISD(3,'1');
   end;
1: begin
   CommutateChannelOnISD(1,'0');
   CommutateChannelOnISD(2,'1');
   CommutateChannelOnISD(3,'1');
   end;
2: begin
   CommutateChannelOnISD(1,'1');
   CommutateChannelOnISD(2,'0');
   CommutateChannelOnISD(3,'1');
   end;                     
3: begin
   CommutateChannelOnISD(1,'0');
   CommutateChannelOnISD(2,'0');
   CommutateChannelOnISD(3,'1');
   end;
4: begin
   CommutateChannelOnISD(1,'1');
   CommutateChannelOnISD(2,'1');
   CommutateChannelOnISD(3,'0');
   end;
5: begin
   CommutateChannelOnISD(1,'0');
   CommutateChannelOnISD(2,'1');
   CommutateChannelOnISD(3,'0');
   end;
6: begin
   CommutateChannelOnISD(1,'1');
   CommutateChannelOnISD(2,'0');
   CommutateChannelOnISD(3,'0');
   end;
7: begin
   CommutateChannelOnISD(1,'0');
   CommutateChannelOnISD(2,'0');
   CommutateChannelOnISD(3,'0');
   end;
end;
end;

procedure TForm1.ComboBox8Change(Sender: TObject);
begin
case (Form1.ComboBox8.ItemIndex) of
0:begin
  form1.ComboBox4.Items[0]:='DF1-(20-500)';
  form1.ComboBox4.Items[1]:='DF2-(20-1000)';
  form1.ComboBox4.Items[2]:='DF3-(20-2000)';
  form1.ComboBox4.Items[3]:='DF4-(20-4000)';
  end;
1:begin
  form1.ComboBox4.Items[0]:='DF1-(20-500)';
  form1.ComboBox4.Items[1]:='DF2-(20-1000)';
  form1.ComboBox4.Items[2]:='DF3-(20-2000)';
  form1.ComboBox4.Items[3]:='DF4-(20-4000)';
  end;
2:begin
  form1.ComboBox4.Items[0]:='DF1-(1-125)';
  form1.ComboBox4.Items[1]:='DF2-(1-250)';
  form1.ComboBox4.Items[2]:='DF3-(1-500)';
  form1.ComboBox4.Items[3]:='DF4-(1-1000)';
  end;
3:begin
  form1.ComboBox4.Items[0]:='DF1-(10-125)';
  form1.ComboBox4.Items[1]:='DF2-(10-250)';
  form1.ComboBox4.Items[2]:='DF3-(10-500)';
  form1.ComboBox4.Items[3]:='DF4-(10-1000)';
  end;
4:begin
  form1.ComboBox4.Items[0]:='DF1-(20-2000)';
  form1.ComboBox4.Items[1]:='DF2-(20-4000)';
  form1.ComboBox4.Items[2]:='DF3-(20-8000)';
  form1.ComboBox4.Items[3]:='DF4-(20-16000)';
  end;
end;
//выставляем значение индекса по умолчанию 0, и значение заголовка от нулевого знаение индекса(то что по умолчанию)
form1.ComboBox4.Text:=form1.ComboBox4.Items[0];
form1.ComboBox4.ItemIndex:=0;
end;

//Процедура изменения номера проверяемого канала
procedure changeChannel(numberChannel:integer);
begin

//канал1
if(numberChannel=1) then
  begin
    //замыкаем контакты входа
    CommutateChannelOnISD(49,'1');
    //на других 3-х входовых каналах  размыкаем
    CommutateChannelOnISD(50,'0');
    CommutateChannelOnISD(51,'0');
    CommutateChannelOnISD(52,'0');
    //замыкаем контакты выхода
    CommutateChannelOnISD(25,'1');
    // на других 3-х входовых каналах размыкаем
    CommutateChannelOnISD(26,'0');
    CommutateChannelOnISD(27,'0');
    CommutateChannelOnISD(28,'0');
  end;

//канал2
if(numberChannel=2)then
  begin
    //замыкаем контакты входа
    CommutateChannelOnISD(50,'1');
    //на других 3-х входовых каналах  размыкаем
    CommutateChannelOnISD(49,'0');
    CommutateChannelOnISD(51,'0');
    CommutateChannelOnISD(52,'0');
    //замыкаем контакты выхода
    CommutateChannelOnISD(26,'1');
    // на других 3-х входовых каналах размыкаем
    CommutateChannelOnISD(25,'0');
    CommutateChannelOnISD(27,'0');
    CommutateChannelOnISD(28,'0');
  end;

//канал3
if(numberChannel=3)then
  begin
    //замыкаем контакты входа
    CommutateChannelOnISD(51,'1');
    //на других 3-х входовых каналах  размыкаем
    CommutateChannelOnISD(49,'0');
    CommutateChannelOnISD(50,'0');
    CommutateChannelOnISD(52,'0');
    //замыкаем контакты выхода
    CommutateChannelOnISD(27,'1');
    // на других 3-х входовых каналах размыкаем
    CommutateChannelOnISD(25,'0');
    CommutateChannelOnISD(26,'0');
    CommutateChannelOnISD(28,'0');
  end;

//канал4
if(numberChannel=4) then
  begin
    //замыкаем контакты входа
    CommutateChannelOnISD(52,'1');
    //на других 3-х входовых каналах  размыкаем
    CommutateChannelOnISD(49,'0');
    CommutateChannelOnISD(50,'0');
    CommutateChannelOnISD(51,'0');
    //замыкаем контакты выхода
    CommutateChannelOnISD(28,'1');
    // на других 3-х входовых каналах размыкаем
    CommutateChannelOnISD(25,'0');
    CommutateChannelOnISD(26,'0');
    CommutateChannelOnISD(27,'0');
  end;
end;


procedure TForm1.Button5Click(Sender: TObject);
begin

//проверяем первый канал
if(form1.RadioButton1.Checked) then
  begin
    //разрешаем осуществить проверку неравномерности АЧХ
    form1.Button4.Enabled:=true;
    //разрешаем осуществить построение АЧХ
    form1.Button3.Enabled:=true;
    //разрешение начать проверку коэфициентов усиления.
    form1.Button6.Enabled:=true;
    changeChannel(1);
    chNumber:=1;
  end;

//проверяем второй канал
if(form1.RadioButton2.Checked) then
  begin
    //разрешаем осуществить проверку неравномерности АЧХ
    form1.Button4.Enabled:=true;
    //разрешаем осуществить построение АЧХ
    form1.Button3.Enabled:=true;
    //разрешение начать проверку коэфициентов усиления.
    form1.Button6.Enabled:=true;
    changeChannel(2);
    chNumber:=2;
  end;

//проверяем третий канал
if(form1.RadioButton3.Checked) then
  begin
    //разрешаем осуществить проверку неравномерности АЧХ
    form1.Button4.Enabled:=true;
    //разрешаем осуществить построение АЧХ
    form1.Button3.Enabled:=true;
    //разрешение начать проверку коэфициентов усиления.
    form1.Button6.Enabled:=true;
    changeChannel(3);
    chNumber:=3;
  end;

//проверяем четвертый канал
if(form1.RadioButton4.Checked) then
  begin
    //разрешаем осуществить проверку неравномерности АЧХ
    form1.Button4.Enabled:=true;
    //разрешаем осуществить построение АЧХ
    form1.Button3.Enabled:=true;
    //разрешение начать проверку коэфициентов усиления.
    form1.Button6.Enabled:=true;
    changeChannel(4);
    chNumber:=4;
  end;
end;

//Функция возвращает в зависимости от переданной частоты и амплитуды, показатель с вольтметра
function VoltVolume (testFrequency:integer;testAmpl:real):string;
var
str:string;
begin
//определяемся откуда смотреть коеф усиления в случаем вычисления Неравномерности АЧХ.
//если канал не будет выбран, то по умолчанию на любом канале будет выставлен единичный коэфициент усиления
case (chNumber) of
1:powKoef:=form1.ComboBox7.ItemIndex;
2:powKoef:=form1.ComboBox1.ItemIndex;
3:powKoef:=form1.ComboBox2.ItemIndex;
4:powKoef:=form1.ComboBox3.ItemIndex;
else powKoef:=form1.ComboBox7.ItemIndex;
end;

//Выставляем значение частоты и амплитуды на генераторе сигналов(переданная частота, переданная амплитуда)
SetFrequencyOnGenerator(testFrequency,testAmpl*2*sqrt(2));

//Переводим вольтметр в режим считывания значений с экрана вольтметра
SetConf(m_instr_usbtmc[0],'READ?');

//Даем время на переключение в режим
Wait(500);

//читаем в str показания вольтметра
GetDatStr(m_instr_usbtmc[0],str);

result:=str;
end;

//Занесение точки АЧХ на график и в ход проверки
procedure DrawPointWritelog(deviceMod:integer;freqMode:integer;channelNum:integer;pointFreq:integer;pointValt:real);
begin
//добавляем точку на график АЧХ
form1.Chart1.Series[0].AddXY(pointFreq,pointValt);

//Добавляем в Ход проверки полученное измерение.
//Form1.Memo1.Lines.Add(' Номер проверяемой модификации устройства: '+inttostr(deviceMod)+'   Номер проверяемого канала: '+inttostr(channelNum)+'  Режим проверки(диапазон частот): '+inttostr(freqMode)+' Гц '+' Подаваемая частота на вход '+inttostr(pointFreq)+' Гц '+'   Напряжение: '+FloattoStr(pointValt)+' В ');

//Выводим в ход проверки и файл только те проверки которые должны проходить по ТУ. В зависимости от режима.

case (freqMode) of
0: begin
   if((pointFreq=20)or(pointFreq=60)or(pointFreq=240)or(pointFreq=450)or(pointFreq=500)or(pointFreq=1000))then
    begin
     Form1.Memo1.Lines.Add(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
     //Запись результатов в файл
     SaveResultToFile(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
    end;
   end;
1: begin
   if((pointFreq=20)or(pointFreq=60)or(pointFreq=500)or(pointFreq=900)or(pointFreq=1000)or(pointFreq=2000))then
    begin
     Form1.Memo1.Lines.Add(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
     //Запись результатов в файл
     SaveResultToFile(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
    end;
   end;
2: begin
   if((pointFreq=20)or(pointFreq=60)or(pointFreq=1000)or(pointFreq=1800)or(pointFreq=2000)or(pointFreq=4000))then
    begin
     Form1.Memo1.Lines.Add(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
     //Запись результатов в файл
     SaveResultToFile(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
    end;
   end;
3: begin
   if((pointFreq=20)or(pointFreq=60)or(pointFreq=2000)or(pointFreq=3600)or(pointFreq=4000)or(pointFreq=8000))then
    begin
     Form1.Memo1.Lines.Add(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
     //Запись результатов в файл
     SaveResultToFile(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStrF(pointValt,ffFixed,4,3)+' В ');
    end;
   end;
end;

{
Form1.Memo1.Lines.Add(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStr(pointValt)+' В ');
//Запись результатов в файл
SaveResultToFile(' Частота '+inttostr(pointFreq)+' Гц '+' Амплитуда '+FloattoStr(pointValt)+' В ');
}
end;

//строим АЧХ
procedure buildACH(deviceModif:integer;frequencyMode:integer;Powkoef:integer;chNum:integer);
var
VoltValue:real;
i:integer;
begin
//подготовительный этап перед проверкой

//Выставляем проверяемый канал (переданный номер канала)
changeChannel(chNum);

//Выставляем частоту среза(режим работы) переданный режим работы для выбранный модификации прибора
setFreqUCF(deviceModif,frequencyMode);

//Отладка для функции setKoef()


//Выставляем коэфициент усиления (на переданном канале канале, коеф усиления переданный)
//setKoef(chNum,Powkoef);

//определяем какую частоту и амплитуду подавать


for i:=1 to FREQINDEX do
  begin
   //заполняем массив значениями напряжений с вольтметра (значения частот берем из массива частот по ТУ. Массив частот masFrequency1)
   masVolt[i]:=strtofloat(VoltVolume(masFrequency1[deviceModif+1,frequencyMode+1,i],masAmpl[deviceModif+1,Powkoef+1]));
   // получаем показание вольтметра для массива измерений masFrequency для построения наиболее полной АЧХ
   VoltValue:=strtofloat(VoltVolume(masFrequency[deviceModif+1,frequencyMode+1,i],masAmpl[deviceModif+1,Powkoef+1]));
   //получение значения напряжения
   //VoltValue:=masVolt[i];
   DrawPointWritelog(deviceModif,frequencyMode,chNum,masFrequency[deviceModif+1,frequencyMode+1,i],VoltValue);
  end;
//пропуск строки для красоты
Form1.Memo1.Lines.Add('');
SaveResultToFile('');
end;


//Построение АЧХ и занесение результатов в Ход событий
procedure TForm1.Button3Click(Sender: TObject);

begin

//Установили нужный канал и коэфициент усиления на нем?
//Тогда блокируем панель для выставления коэф. усиления
form1.ComboBox7.Enabled:=false;
form1.ComboBox1.Enabled:=false;
form1.ComboBox2.Enabled:=false;
form1.ComboBox3.Enabled:=false;

//Установлена нужная частота среза?
form1.ComboBox4.Enabled:=false;

//Прибор выбрали?
form1.ComboBox8.Enabled:=false;

//Если мы строим АЧХ, то проверку неравномерности и проверку коэфициентов запустить не можем
form1.Button4.Enabled:=false;
form1.Button6.Enabled:=false;
form1.Button3.Enabled:=false;

//блокировка кнопки Установить
form1.Button5.Enabled:=false;

form1.Button2.Enabled:=false;


//очистка предидущей АЧХ
form1.Series1.Clear;
//определяемся откуда смотреть коеф усиления.
case (chNumber) of
1:powKoef:=form1.ComboBox7.ItemIndex;
2:powKoef:=form1.ComboBox1.ItemIndex;
3:powKoef:=form1.ComboBox2.ItemIndex;
4:powKoef:=form1.ComboBox3.ItemIndex;
end;

//получаем значение напряжения в зависимости от выбранной модификации прибора, выбранного режима работы(частота среза),коэфициента усиления, и выбранного канала и строим АЧХ

buildACH(form1.ComboBox8.ItemIndex,form1.ComboBox4.ItemIndex,powKoef,chNumber);

//заблокированные проверки снова можно осуществлять
form1.Button4.Enabled:=true;
form1.Button6.Enabled:=true;
form1.Button3.Enabled:=true;
//доступность кнопки установить
form1.Button5.Enabled:=true;

//делаем доступной панель установки коэфициентов
form1.ComboBox7.Enabled:=true;
form1.ComboBox1.Enabled:=true;
form1.ComboBox2.Enabled:=true;
form1.ComboBox3.Enabled:=true;

//делаем доступным выбор частоты среза
form1.ComboBox4.Enabled:=true;

//делаем доступным выбор прибора
form1.ComboBox8.Enabled:=true;

//кнопка автоматической проверки
form1.Button2.Enabled:=true;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetConf(m_instr_usbtmc[0],'CONF:VOLT:DC');
  idUDPServer1.Active:=false;
  if CloseQuery then Halt;
  //Application.Terminate; //мягкое закрытие приложения
  //Halt;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SetConf(m_instr_usbtmc[0],'CONF:VOLT:DC');

  //Проверка файлы на существование . Если файлы не создавались то их и не надо закрывать. WORK!
  {$I-} {Отключаем контроль ошибок ввода-вывода}
  reset(ResultFile);
  reset(ACPWorkLogFile);
  {$I+} {Включаем контроль ошибок ввода-вывода}
  if IOResult=0 then 
  begin
    //закрыть файлы логов если они были открыты
    CloseFile(ResultFile);
    CloseFile(ACPWorkLogFile);
  end;
end;

//Процедура
procedure SearchMinAndMaxU(leftRange:integer;rightRange:integer);
var
i:integer;
begin
minU:=masVolt[leftRange];
maxU:=masVolt[leftRange];
Uf3:=masVolt[3];

//поиск минимального напряжения
for i:=leftRange to rightRange-1  do
  begin
    if (minU>masVolt[i+1]) then minU:=masVolt[i+1];
  end;
//поиск максимальной частоты из диапазона рабочих частот
for i:=leftRange to rightRange-1 do
  begin
    if (maxU<masVolt[i+1]) then maxU:=masVolt[i+1];
  end;
end;

//в переменую записывается значение погрешности при проверке
procedure WhatIsProcentValue(devicemodif:integer);
begin
//записываем в переменную неообходимую погрешность
if (devicemodif=4) then
  begin
    Errors[1]:=10.0;
    Errors[2]:=5.0;
    Errors[3]:=15.0;
  end
else
  begin
    Errors[1]:=10.0;
    Errors[2]:=5.0;
    Errors[3]:=10.0;
  end;
end;

function CalkMPlusMMinus(Umin:real;Umax:real;Uf3:real):real;
begin
 Mplus:=abs(((Umax-Uf3)/Uf3)*100);
 MMinus:=abs(((Umin-Uf3)/Uf3)*100);
 if(Mplus>=MMinus) then result:=Mplus
  else  result:=MMinus;
end;


function NormIndicator(minU:real;maxU:real;f3U:real;procentValue:real):boolean;
var
error:real;
begin
error:=CalkMPlusMMinus(minU,maxU,f3U);
if((Mplus<=procentValue)and(MMinus<=procentValue)) then result:=true
  else result:=false;
Form1.Memo1.Lines.Add(' Отклонение: '+floattostr(error));
end;

function test (leftRange:integer;rightRange:integer;procentValue:real):boolean;
begin
//вычисляем минимальное напряжение
SearchMinAndMaxU(leftRange,rightRange);
Form1.Memo1.Lines.Add('');
SaveResultToFile('');
Form1.Memo1.Lines.Add('ДИАПАЗОН ЧАСТОТ '+IntToStr(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,leftrange])+' - '+IntToStr(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,rightrange])+' Гц ');
SaveResultToFile('ДИАПАЗОН ЧАСТОТ '+IntToStr(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,leftrange])+' - '+IntToStr(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,rightrange])+' Гц ');
Form1.Memo1.Lines.Add('Мин U: '+FloatToStrF(minU,ffFixed,4,3)+' В'+' Макс U: '+FloatToStrF(maxU,ffFixed,4,3)+' В'+' UF3: '+floattostrF(Uf3,ffFixed,4,3)+' В');
SaveResultToFile('Мин U: '+FloatToStrF(minU,ffFixed,4,3)+' В'+' Макс U: '+FloatToStrF(maxU,ffFixed,4,3)+' В'+' UF3: '+floattostrF(Uf3,ffFixed,4,3)+' В');
if(NormIndicator(minU, maxU,Uf3,procentValue)) then
begin
Form1.Memo1.Lines.Add('Неравномерность амплитудно-частотной характеристики '+modifStr+' : НОРМА ');
SaveResultToFile('Неравномерность амплитудно-частотной характеристики '+modifStr+' : НОРМА ');
result:=true;
end
else
  begin
    Form1.Memo1.Lines.Add(' Неравномерность амплитудно-частотной характеристики '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile(' Неравномерность амплитудно-частотной характеристики '+modifStr+' : НЕ НОРМА ');
    result:=false;
  end;
end;



procedure TForm1.Button4Click(Sender: TObject);

var
fl1,fl2,fl3:boolean;
begin

//Установили нужный канал и коэфициент усиления на нем?
//Тогда блокируем панель для выставления коэф. усиления
form1.ComboBox7.Enabled:=false;
form1.ComboBox1.Enabled:=false;
form1.ComboBox2.Enabled:=false;
form1.ComboBox3.Enabled:=false;

//Установлена нужная частота среза?
form1.ComboBox4.Enabled:=false;

//Прибор выбрали?
form1.ComboBox8.Enabled:=false;

//Если мы проверяем неравномерности, то не можем запустить построение АЧХ и проверку коэфициентов усиления
form1.Button3.Enabled:=false;
form1.Button6.Enabled:=false;
form1.Button4.Enabled:=false;
form1.Button5.Enabled:=false;

form1.Button2.Enabled:=false;

//заполнение массива погрешностей

WhatIsProcentValue(form1.ComboBox8.ItemIndex);

Button3Click (Form1);

fl1:=test(1,2,Errors[1]);

fl2:=test(3,4,Errors[2]);

fl3:=test(5,5,Errors[3]);

//заблокированные проверки снова доступны
form1.Button3.Enabled:=true;
form1.Button6.Enabled:=true;
form1.Button4.Enabled:=true;
form1.Button5.Enabled:=true;


//делаем доступной панель установки коэфициентов
form1.ComboBox7.Enabled:=true;
form1.ComboBox1.Enabled:=true;
form1.ComboBox2.Enabled:=true;
form1.ComboBox3.Enabled:=true;

//делаем доступным выбор частоты среза
form1.ComboBox4.Enabled:=true;

//делаем доступным выбор прибора
form1.ComboBox8.Enabled:=true;

//кнопка автоматической проверки
form1.Button2.Enabled:=true;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
idUDPServer1.Active:=true;
//form2.show;
end;

//Функция для переключения(непосредственно каналды переключаться не будут) каналов прибора и вывода цифровых данных с интерфейса RS-485 для выбранного канала на график.
//На вход принимается выбранный для вывода канал.
function ShowDigitalChannel():integer;
begin
// Определяем какой канал надо выводить на просмотр
if (form1.RadioButton5.Checked) then result:=2;
if (form1.RadioButton6.Checked) then result:=3;
if (form1.RadioButton7.Checked) then result:=4;
if (form1.RadioButton8.Checked) then result:=5;
end;

//Функция для расчета действующего значения . Пункт 3.22.
function CalculateDeistvZnach():double;
var
  Srednee,Max,Min:double;
  NumbersMax:integer;
  NumbersMin:integer;
  //счетчик для вычисления среднего значения по массиву
  i:integer;
  begin

  //непосредственно сама переменная в которой суммируются все значения массива
  Srednee:=0;
  //записываем дельту смещения от значения в массиве до оси X для положительных
  Max:=0;
  // записываем дельту смещения от значения в массиве до оси X для отрицательных
  Min:=0;
  //Счетчик количества точек попадающих выше оси X
  NumbersMax:=0;
  //Счетчик количества точек попадающих ниже оси X
  NumbersMin:=0;
  // NUMBERPOINTS- размерность буфера(массива) из всех данных которого будет высчитываться среднее значение сигнала(или просто среднее значение всех значений в разбираемом массиве)
  for i:=1 to NUMBERPOINTS do Srednee:=Srednee+masDigitalZnachActual[i];
  //получили среднее для того, чтобы определять как подсчитывать значения выше и ниже среднего.
  Srednee:=Srednee/NUMBERPOINTS;

  for i:=1 to NUMBERPOINTS do
  begin
    //выше
    if (masDigitalZnachActual[i]>=Srednee) then
      begin
        Max:=Max+(masDigitalZnachActual[i]-Srednee);
        //+1 точка
        inc(NumbersMax);
      end
    //ниже
    else if(masDigitalZnachActual[i]<=Srednee) then
      begin
        Min:=Min+(Srednee-masDigitalZnachActual[i]);
        //+1 точка
        inc(NumbersMin);
      end;
  end;

  result:=(((Max/NumbersMax)+(Min/NumbersMin))/2);
end;

procedure TForm1.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
//массив хранящий 220 байтов
buf:array [1..220] of byte;
i_kol:integer;
begin
//коэфициент для перевода в мВ
kof:=5/256*1000;
AData.ReadBuffer(buf,210);

 //
if(indGraph>=form1.Image1.Width)then
  begin
    indGraph:=0;
    //form1.LineSeries2.Clear;
    //очищаем форму 1 для вывода
    form1.image1.Canvas.Rectangle(0,0,form1.image1.Width,form1.image1.Height);
    form1.image1.Canvas.MoveTo(0,0);

    //очищаем форму 2 для вывода
    //form2.image1.Canvas.Rectangle(0,0,form2.image1.Width,form2.image1.Height);
    //form2.image1.Canvas.MoveTo(0,0);
  end;
indexByte:=ShowDigitalChannel();

for i_kol:=1 to 35 do
begin
  //Выводим на график  цифровые данные с адаптера (комп не успевает)
  //form1.Chart3.Series[0].AddXY(indGraph,buf[index]);

  //Пересчет значения с адаптера в мВ и занесение их в массив
  //Если при заполнении массива заполнены все 10000 значений и все с одного канала то перезаписываем значения Актуального массива для подсчета действующих значений и амплитуды , значениями из заполненного буфера
  if kMasDig>10000 then
    begin

     for kMasDig:=1 to 10000 do  masDigitalZnachActual[kMasDig]:=masDigitalZnachBuf[kMasDig];
     kMasDig:=1;
     //Вычисление действующего значения и амплитудного значения masDigitalZnachActual. Так как оно должно быть одно на массив.
     DVolume:=CalculateDeistvZnach();
     AmplVolume:=DVolume*sqrt(2);
     //Выводим их на форму
     form1.Label9.Caption:=FloatToStr(DVolume);
     form1.Label10.Caption:=FloatToStr(AmplVolume);
    end;
  masDigitalZnachBuf[kMasDig]:=(buf[indexByte]-127)*kof;
    // masDigitalZnachBuf[kMasDig]:=buf[indexByte]-127;
  //----------------------------------------------------------
  //На канву выводим значения в обычных единицах.
  form1.Image1.Canvas.LineTo(indGraph,buf[indexByte]);
  //Вывод в милливольтах.
  //form2.Image1.Canvas.LineTo(indGraph,round(masDigitalZnachBuf[kMasDig]/5)+400);
  indexByte:=indexByte+6;
  inc(indGraph);
  //следующий индекс массива
  inc(kMasDig);

end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var
i:integer;
voltage:real;
koef: real;
begin

//Установили нужный канал и коэфициент усиления на нем?
//Тогда блокируем панель для выставления коэф. усиления
form1.ComboBox7.Enabled:=false;
form1.ComboBox1.Enabled:=false;
form1.ComboBox2.Enabled:=false;
form1.ComboBox3.Enabled:=false;

//Установлена нужная частота среза?
form1.ComboBox4.Enabled:=false;

//Прибор выбрали?
form1.ComboBox8.Enabled:=false;

//Если мы осуществляем проверку коэфициентов усиления то, не можем запустить построение АЧХ и проверку неравномерности амплитудно частотной характеристики
form1.Button3.Enabled:=false;
form1.Button4.Enabled:=false;
form1.Button6.Enabled:=false;
form1.Button5.Enabled:=false;

form1.Button2.Enabled:=false;

  form1.Memo1.Lines.Add(' Проверяемый канал: '+inttostr(chNumber));
  SaveResultToFile(' Проверяемый канал: '+inttostr(chNumber));
  setKoef(chNumber,1);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,1]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,1];
  form1.Memo1.Lines.Add(' Коеф. усиления Х1(DA8): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х1(DA8): '+floattostr(koef));

  setKoef(chNumber,2);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,2]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,2];
  form1.Memo1.Lines.Add(' Коеф. усиления Х2(DA7): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х2(DA7): '+floattostr(koef));

  setKoef(chNumber,4);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,3]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,3];
  form1.Memo1.Lines.Add(' Коеф. усиления X3(DA6): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления X3(DA6): '+floattostr(koef));

  setKoef(chNumber,8);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,4]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,4];
  form1.Memo1.Lines.Add(' Коеф. усиления Х4(DA5): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х4(DA5): '+floattostr(koef));

  setKoef(chNumber,16);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,5]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,5];
  form1.Memo1.Lines.Add(' Коеф. усиления Х5(DA4): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х5(DA4): '+floattostr(koef));

  setKoef(chNumber,32);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,6]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,6];
  form1.Memo1.Lines.Add(' Коеф. усиления Х6(DA3): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х6(DA3): '+floattostr(koef));

  setKoef(chNumber,64);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,7]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,7];
  form1.Memo1.Lines.Add(' Коеф. усиления Х7(DA2): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х7(DA2): '+floattostr(koef));

  setKoef(chNumber,128);
  voltage:=strtofloat(VoltVolume(masFrequency1[Form1.Combobox8.ItemIndex+1,Form1.Combobox4.ItemIndex+1,3],masAmpl[Form1.Combobox8.ItemIndex+1,8]));
  koef:=  voltage/masAmpl[Form1.Combobox8.ItemIndex+1,8];
  form1.Memo1.Lines.Add(' Коеф. усиления Х8(DA1): '+floattostr(koef));
  SaveResultToFile(' Коеф. усиления Х8(DA1): '+floattostr(koef));

//заблокированные операции снова доступны
form1.Button3.Enabled:=true;
form1.Button4.Enabled:=true;
form1.Button6.Enabled:=true;
form1.Button5.Enabled:=true;

//делаем доступной панель установки коэфициентов
form1.ComboBox7.Enabled:=true;
form1.ComboBox1.Enabled:=true;
form1.ComboBox2.Enabled:=true;
form1.ComboBox3.Enabled:=true;

//делаем доступным выбор частоты среза
form1.ComboBox4.Enabled:=true;

//делаем доступным выбор прибора
form1.ComboBox8.Enabled:=true;

//Кнопка автоматической проверки

form1.Button2.Enabled:=true;

end;
//Автоматическая проверка.

//Реализация пункта 3.13.Проверка напряжения питания и мощности потребления преобразования
function testTU_3_13():boolean;
var
flag1,flag2:boolean;
currentOnGen:integer;
P:real;
P_34:real;
P_22:real;
begin
P_34:=2.4;
P_22:=2.04;
//подкл. к источнику питания
ConnectToPowerSupply('0');

//Устанавливаем напряжение 34 В
SetVoltageOnPowerSupply('34','00');
sleep(2000);
//Замеряем значение тока на генераторе
currentOnGen:=GetCurrentFromPowerSupply;
//Производим расчет мощности. Мы получаем ток с источника в целочисленном формате. Для приведения его к вещественному делим на 1000. Т.к. прибор и адаптер потебляют одинаковый ток, а измерения мы должны проводить без адаптера, то делим мощность на 2.
P1:=(34.00*(currentOnGen/1000))-P_34;
//проверяем соответствует ли мощность норме. 6 ВТ
if(P1<=6) then flag1:=true
  else flag1:=false;

//Устанавливаем напряжение на источнике питания в 22 В.
SetVoltageOnPowerSupply('22','00');
sleep(2000);
//Замеряем значение тока на генераторе
currentOnGen:=GetCurrentFromPowerSupply;
//Производим расчет мощности. Мы получаем ток с источника в целочисленном формате. Для приведения его к вещественному делим на 1000. Т.к. прибор и адаптер потебляют одинаковый ток, а измерения мы должны проводить без адаптера, то делим мощность на 2.
P2:=(22.00*(currentOnGen/1000))-P_22;
//проверяем соответствует ли мощность норме. 6 ВТ
if(P2<=6) then flag2:=true
  else flag2:=false;
//результат
if((flag1)and(flag2)) then result:=true
  else result:=false;
  
SetVoltageOnPowerSupply('27','00');
sleep(2000);
end;

//Реализация пункта 3.15. Проверка напряжения постоянного тока на выходе преобразователя.
function testTU_3_15():boolean;
var
strok:string;
kolChannel,i:integer;

begin
kolChannel:=4;
//Для проверки переводим вольтметр в режим измерения постоянного тока
SetConf(m_instr_usbtmc[0],'CONF:VOLT:DC');

//проверяем c первого по четвертый канал. Заполняем массив значениями напряжений с вольтметра
for i:=1 to kolChannel do
  begin
    changeChannel(i);
    chNumber:=i;
    //Переводим вольтметр в режим считывания значений с экрана вольтметра. Проверяем на соответствие значению напряжения по ТУ.
    SetConf(m_instr_usbtmc[0],'READ?');
    //Даем время на переключение в режим
    Wait(500);
    //читаем в str показания вольтметра
    GetDatStr(m_instr_usbtmc[0],strok);
    VoltMas[i]:=strToFloat(strok);
    //проверка. И заполнение массива флагов. И состояний для вывода
    if(VoltMas[i]>=2.4)and(VoltMas[i]<=2.6)then
      begin
        flagMas[i]:=true;
        strMasStr[i]:='НОРМА';
      end
    else
      begin
        flagMas[i]:=false;
        strMasStr[i]:='НЕ НОРМА';
      end;
  end;
if((flagMas[1])and(flagMas[2])and(flagMas[3])and(flagMas[4]))then result:=true
  else result:=false;
end;

//Реализация пункта 3.16. Проверка амплитуды напряжения собственных шумов на выходе преобразователя.
function testTU_3_16():boolean;
var
kolCh,i,kolKoef,j,k:integer;
str:string;
begin
//переменная количества каналов
kolCh:=4;
//переменная количества режимов (DA1-DA8)
kolKoef:=8;
k:=1;
//Переключаем вольтметр в режим измерения переменной составляющей
SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');

for i:=1 to kolCh do
 begin
 //выставляем проверяемый канал
 changeChannel(i);
 //внутренний цикл для переключения коэфициентов усиления
 for j:=1 to kolKoef do
  begin
   //устанавливаем на очередном канале, очередной коэфициент усиления
    setKoef(i,masKoeff[j]);
   //считываем показатель вольтметра.
   //Переводим вольтметр в режим считывания значений с экрана вольтметра. Проверяем на соответствие значению напряжения по ТУ.
    SetConf(m_instr_usbtmc[0],'READ?');
    //Даем время на переключение в режим
    Wait(600);
    //читаем в str показания вольтметра
    GetDatStr(m_instr_usbtmc[0],str);
    masZn[k]:=strToFloat(str);

   if masKoeff[j]=128 then
    begin
      //показатель с вольтметра попадает в диапазон <=100мВ
      if(masZn[k]<=0.1) then
        begin
          masF[k]:=true;
          masS[k]:='НОРМА';
          inc(k);
        end
        else
          begin
          masF[k]:=false;
          masS[k]:='НЕ НОРМА';
          inc(k);
          end;
    end
      else
        begin
          //показатель с вольтметра попадает в диапазон <=50мВ
          if(masZn[k]<=0.05) then
            begin
              masF[k]:=true;
              masS[k]:='НОРМА';
              inc(k);
            end
          else
          begin
            masF[k]:=false;
            masS[k]:='НЕ НОРМА';
            inc(k);
          end;
        end;
  end;
 end;

//определение, успешности проверки
for k:=1 to 32 do
  begin
    if(not masF[k])then
        begin
          result:=false;
          break;
        end;
    result:=true;
  end;
end;

//Пункт автоматической проверки 3.17.

function testTU_3_17():boolean;
var
i,kolCh,maxAmpl,j,k:integer;
str:string;
voltage:real;
maxKoefDiap,minKoefDiap:real;
uSrTU,UDTu:real;
koef:real;
begin
//переменная количества каналов
kolCh:=4;
//переменная с максимальной величиной амплитуды на генераторе
maxAmpl:=190;
//левая граница диапазона  (коэффициент усиления в режиме DA4 4+-0.2)
minKoefDiap:=3.8;
//правая граница диапазона
maxKoefDiap:=4.2;
//счетчик для записи в массив значений максимальных неискаженных напряжений.
k:=1;
//величина среднеквадратического максимального неискаженного напряжения по ТУ
uSrTU:=1.4;
//действительное значение
UDTu:=2.0;
//Установка частоты среза DF2 в зависимости от модификации прибора.
 setFreqUCF(form1.ComboBox5.ItemIndex,1);
//Установка режима измерения вольтметра в AC
SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');
for i:=1 to kolCh do
  begin
    //выставляем проверяемый канал
    changeChannel(i);
    //устанавливаем на проверяемом канале коеф. усиления DA4
    setKoef(i,16);
    j:=1;

    //j-счетчик для перебора величины амплитуд на генераторе от минимального до максимального
    for j:=1 to maxAmpl do
      begin
        //Выставляем значение частоты F3 в зависимости от модиф.прибора и амплитуды на генераторе сигналов(переданная частота, переданная амплитуда)
        SetFrequencyOnGenerator(masFrequency1[Form1.Combobox5.ItemIndex+1,2,3],AmplitudeMas[j]);

        //Переводим вольтметр в режим считывания значений с экрана вольтметра
        SetConf(m_instr_usbtmc[0],'READ?');

        //Даем время на переключение в режим
        Wait(500);

        //читаем в str показания вольтметра
        GetDatStr(m_instr_usbtmc[0],str);
        voltage:=strToFloat(str);

        //Считаем коэфициент максимального неискаженного напряжения
        koef:=voltage*2*sqrt(2)/AmplitudeMas[j];
        //Проверяем соответствие попаданию в диапазон.
        if (not(koef>=minKoefDiap)and(koef<=maxKoefDiap)) then
          begin
           SetFrequencyOnGenerator(masFrequency1[Form1.Combobox5.ItemIndex+1,2,3],AmplitudeMas[j-1]);
           SetConf(m_instr_usbtmc[0],'READ?');
           Wait(500);
           GetDatStr(m_instr_usbtmc[0],str);
           //заносим в массив максимальных неискаженных напряжений значения для текущего канала
           maxVoltMas[k]:=strToFloat(str);
           //Проверяем проходят ли оно по ТУ.
           if maxVoltMas[k]>=uSrTU then
              begin
                trueMasVolt[k]:=true;
                trueMasStr[k]:='НОРМА';
              end
            else
              begin
                trueMasVolt[k]:=false;
                trueMasStr[k]:='НЕ НОРМА';
              end;
           inc(k);

           //Нашли максимальное неискаженнон напряжение, дальше проверять нет смысла, переходим к следующему каналу.
           break;
          end;


      end;


  end;
//Определяем успешность проверки
if ((trueMasVolt[1]) and (trueMasVolt[2]) and (trueMasVolt[3]) and (trueMasVolt[4])) then result:=true
  else result:=false;
end;

//Пункт автоматической проверки 3.18.
function testTU_3_18():boolean;
var
kolCh,i,kolKoef,j,k,ch:integer;
str:string;
voltage:real;
koef: real;
//Переменные индикаторы для определения успешности проверки
testTU_3_18RezCur:boolean;
testTU_3_18RezSh:integer;
stringTest_3_18:string;
testTU_3_18RezF:boolean;
begin
//Устанавливаем частотный диапазон DF2 в зависимости от модификации прибора.
setFreqUCF(form1.ComboBox5.ItemIndex,1);
//------------------------------------------------------------------------------
//переменная количества каналов
kolCh:=4;
//переменная количества режимов (DA8-DA1)
kolKoef:=8;
testTU_3_18RezSh:=0;

k:=1;
//Переключаем вольтметр в режим измерения переменной составляющей
SetConf(m_instr_usbtmc[0],'CONF:VOLT:AC');

for i:=1 to kolCh do
 begin
 //выставляем проверяемый канал
 changeChannel(i);
 //счетчик для вывода режима
 ch:=8;
 form1.Memo1.Lines.Add('Проверяемый канал: '+inttostr(i));
 SaveResultToFile('Проверяемый канал: '+inttostr(i));
 //внутренний цикл для переключения коэфициентов усиления (DA8-DA1)
 for j:=1 to kolKoef do
  begin

   //устанавливаем на очередном канале, очередной коэфициент усиления(переключение прибора в необходимый режим для тестирования от DA1-DA8)
   setKoef(i,masKoeff[ch]); {j}

   //Производим измерения напряжения.
   //Выставляем значение частоты и амплитуды на генераторе сигналов(переданная частота, переданная амплитуда)
   SetFrequencyOnGenerator(masFrequency1[Form1.Combobox5.ItemIndex+1,2,3],(masAmpl[Form1.Combobox5.ItemIndex+1,j]*2*SQRT(2))); {ch}

   //Переводим вольтметр в режим считывания значений с экрана вольтметра
   SetConf(m_instr_usbtmc[0],'READ?');

   //Даем время на переключение в режим
   Wait(500);

   //читаем в str показания вольтметра
   GetDatStr(m_instr_usbtmc[0],str);
   voltage:=strToFloat(str);

   koef:=  voltage/masAmpl[Form1.Combobox5.ItemIndex+1,j];
   //выполнение проверки полученных коэффициентов на соответствие норме пункта ТУ 3.18.
    case masKoeff[ch] of
    //DA1 коэф (31.2,32.8)
    128:
        begin
          if(koef>=31.2)and(koef<=32.8) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA2 коэф (15.6,16.4)
    64:
        begin
          if(koef>=15.6)and(koef<=16.4) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA3 коэф (7.8,8.2)
    32:
        begin
          if(koef>=7.8)and(koef<=8.2) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA4 коэф (3.9,4.1)
    16:
        begin
          if(koef>=3.9)and(koef<=4.1) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA5 коэф (1.95,2.05)
    8:
        begin
          if(koef>=1.95)and(koef<=2.05) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA6 коэф (0.975,1.025)
    4:
        begin
          if(koef>=0.975)and(koef<=1.025) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA7 коэф (0.4875,0.5125)
    2:
        begin
          if(koef>=0.4875)and(koef<=0.5125) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    //DA8 коэф (0.2437,0.2563)
    1:
        begin
          if(koef>=0.2437)and(koef<=0.2563) then
            begin
              testTU_3_18RezCur:=true;
              stringTest_3_18:='НОРМА';
              inc(testTU_3_18RezSh);
            end
          else
            begin
              testTU_3_18RezCur:=false;
              stringTest_3_18:='НЕ НОРМА';
            end;
        end;
    end;

   //---------------------------------------------------------------------------
   form1.Memo1.Lines.Add('Номер канала:'+intToStr(i)+' Коеф. усиления Х'+intToStr(j)+'(DA'+intToStr(ch)+'):'+floattostrF(koef,ffFixed,4,4)+' Соответствие норме:'+stringTest_3_18);
   SaveResultToFile('Номер канала:'+intToStr(i)+' Коеф. усиления Х'+intToStr(j)+'(DA'+intToStr(ch)+'):'+floattostrF(koef,ffFixed,4,4)+' Соответствие норме:'+stringTest_3_18);

   dec(ch);
  end;
 end;
 if (testTU_3_18RezSh>31) then testTU_3_18RezF:=true
  else testTU_3_18RezF:=false;
 result:=testTU_3_18RezF;
end;


// Пункт автоматической проверки 3.19.
function testTU_3_19():boolean;
var
i,j,kount:integer;
fl1,fl2,fl3:boolean;
VoltVal:real;
begin
kount:=1;
//устанавливаем очередной канал
for i:=1 to 4 do
begin
  //установка очередной частоты среза Df1,Df2,Df3,Df4.
  for j:=1 to 4 do
    begin
      //очищаем график АЧХ
      form1.Series1.Clear;
      form1.Memo1.Lines.Add('');
      SaveResultToFile('');
      //используем в автоматической проверке эллемент ручной проверки  ComboBox4
      form1.Memo1.Lines.Add(' Проверка '+inttostr(i)+' канала на диапазоне частот: '+form1.ComboBox4.Items[j-1]);
      SaveResultToFile(' Проверка '+inttostr(i)+' канала на диапазоне частот: '+form1.ComboBox4.Items[j-1]);
      //Выставляем коэфициент усиления DA4 на очередном канале
      setKoef(i,16);

      //Строим АЧХ, заполняем массив погрешностей

      //заполнение массива погрешностей

      WhatIsProcentValue(form1.ComboBox5.ItemIndex);

     //Строим АЧХ

      //выставляем сам очередной канал на ИСД для проверки
      changeChannel(i);
      //устанавливаем для выбранной модификации прибора очередную частоту среза.
      setFreqUCF(form1.ComboBox5.ItemIndex,j-1);


      for kount:=1 to FREQINDEX do
        begin
          //заполняем массив значениями напряжений с вольтметра при коэфициенте усиления 16(0.32)
          masVolt[kount]:=strtofloat(VoltVolume(masFrequency1[form1.ComboBox5.ItemIndex+1,j,kount],masAmpl[form1.ComboBox5.ItemIndex+1,5]));
          //получение текущего значения напряжения и отрисовка АЧХ
          VoltVal:=strtofloat(VoltVolume(masFrequency[form1.ComboBox5.ItemIndex+1,j,kount],masAmpl[form1.ComboBox5.ItemIndex+1,5]));
          DrawPointWritelog(form1.ComboBox5.ItemIndex,j-1,i,masFrequency[form1.ComboBox5.ItemIndex+1,j,kount],VoltVal);
          wait(20);
        end;
      //-----------------------------------------------------

       //проверяем значения напряжения на соответствие погрешностям по ТУ.
      if((not(test(1,2,Errors[1])))or(not(test(3,4,Errors[2])))or(not(test(5,5,Errors[3])))) then result:=false
        else result:=true;

    end;
end;
end;

// Пункт автоматической проверки 3.20.
function testTU_3_20():boolean;
var
powerK,k,kolCh,kolDF,j:integer;
i:integer;
str:string;
voltage:real;
strFor3_20:string;

begin
//переменная количества каналов
kolCh:=4;
//переменная количества режимов среза
kolDF:=4;
k:=1;
for i:=1 to kolCh do
  begin
    //выставляем очередной канал на ИСД для проверки
    changeChannel(i);

    //Определяем модификацию прибора и с каким коэфициентом надо будет проводить проверку
    if (form1.ComboBox5.ItemIndex=0)or(form1.ComboBox5.ItemIndex=4) then powerK:=4 {DA6}
      else powerK:=16 {DA4};
    //Установка коэфициента усиления в зависимости от модификации прибора (УЦФ, УЦФ-04)-DA6, (УЦФ-01-УЦФ-03)-DA4
    setKoef(i,powerK);

    //Устанавливаем очередную частоту среза. (DF1-DF4)
    for j:=1 to kolDF do
      begin
         //Устанавливаем очередной частотный диапазон в зависимости от модификации прибора.
         setFreqUCF(form1.ComboBox5.ItemIndex,j-1);

        //Производим измерения напряжения.
        //Выставляем значение частоты и амплитуды на генераторе сигналов(переданная частота, переданная амплитуда)
         SetFrequencyOnGenerator(masFrequency1[Form1.Combobox5.ItemIndex+1,j,6],2*2*sqrt(2)); {ch}

        //Переводим вольтметр в режим считывания значений с экрана вольтметра
         SetConf(m_instr_usbtmc[0],'READ?');

        //Даем время на переключение в режим
        Wait(500);

        //читаем в str показания вольтметра
        GetDatStr(m_instr_usbtmc[0],str);
        voltage:=strToFloat(str);
        //заносим полученное значение в массив
        mRez[k]:=voltage;
        //проверяем не превышает ли напряжение выхода на вольтметре значения оговоренного по ТУ.
        if(voltage<=0.11) then
          begin
            //занополняем массив истинности и строк, для вывода
            mTrue[k]:=true;
            mStr[k]:='НОРМА';
          end
          else
            begin
              mTrue[k]:=false;
              mStr[k]:='НЕ НОРМА';
            end;
        inc(k);
      end;
  end;
//проверяем устпешность проверки
for i:=1 to 16 do
  if(mTrue[i]) then result:=true
    else
      begin
        result:=false;
        break;
      end;

end;

//Функция для инициализации и работы с АЦП Е20-10. Если всё прошло успешно вернет TRUE, были ошибки вернет FALSE
function ACP_E20_10_Initialise_Work():boolean;
var
//вспомогательная строковая переменная
Str:string;
//счетчик для работы
i:integer;
j:integer;
begin
//связываем файловую переменную с именем файла. Заменяем : на . и создание файла.
//
FileName2:='Результаты/AcpLogE20-10/LOG_ACP20_10'+'_'+DateToStr(Date)+'_'+TimeToStr(Time)+'.txt';
for i:=1 to length(FileName2) do if (FileName2[i]=':') then FileName2[i]:='.';
AssignFile(ACPWorkLogFile,FileName2);
ReWrite(ACPWorkLogFile);

//Заголовок лога
SaveResultToFile2('Лог работы с АЦП Е20-10');

//Инициализация работы АЦП и сбор данных
// сбросим флаги ошибки потока ввода
ReadThreadErrorNumber := 0;
// сбросим флажок завершённости потока сбора данных
IsReadThreadComplete := false;
// пока откытого файла нет :(
FileHandle := -1;
// сбросим счётчики
Counter := $0; OldCounter := $FFFF;

// проверим версию используемой DLL библиотеки
DllVersion := GetDllVersion;
  //если есть просблемы или нет пишем в лог.
	if DllVersion <> CURRENT_VERSION_LUSBAPI then
		begin
      Str:='Неверная версия DLL библиотеки Lusbapi.dll! ' + #10#13 +
						'           Текущая: ' + IntToStr(DllVersion shr 16) +  '.' + IntToStr(DllVersion and $FFFF) + '.' +
						' Требуется: ' + IntToStr(CURRENT_VERSION_LUSBAPI shr 16) + '.' + IntToStr(CURRENT_VERSION_LUSBAPI and $FFFF) + '.';

			SaveResultToFile2(Str);
			ExitProgram(Str);
		end
	else SaveResultToFile2(' DLL Version --> OK');

	// попробуем получить указатель на интерфейс для модуля E20-10
 	pModule := CreateLInstance(pCHAR('e2010'));
	if pModule = nil then ExitProgram('Не могу найти интерфейс модуля E20-10!')
	else SaveResultToFile2(' Module Interface --> OK');

	// попробуем обнаружить модуль E20-10 в первых MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI виртуальных слотах
	for i := 0 to (MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI-1) do if pModule.OpenLDevice(i) then break;
	// что-нибудь обнаружили?
	if i = MAX_VIRTUAL_SLOTS_QUANTITY_LUSBAPI then ExitProgram('Не удалось обнаружить модуль E20-10 в первых 127 виртуальных слотах!')
	else SaveResultToFile2(Format(' OpenLDevice(%u) --> OK', [i]));

	// получим идентификатор устройства
	ModuleHandle := pModule.GetModuleHandle();

	// прочитаем название модуля в текущем виртуальном слоте
	ModuleName := '0123456';
	if not pModule.GetModuleName(pCHAR(ModuleName)) then ExitProgram('Не могу прочитать название модуля!')
	else SaveResultToFile2(' GetModuleName() --> OK');
	// проверим, что это модуль E20-10
	if Boolean(AnsiCompareStr(ModuleName, 'E20-10')) then ExitProgram('Обнаруженный модуль не является E20-10!')
	else SaveResultToFile2(' The module is ''E20-10''');

	// попробуем получить скорость работы шины USB
	if not pModule.GetUsbSpeed(@UsbSpeed) then ExitProgram(' Не могу определить скорость работы шины USB')
	else SaveResultToFile2(' GetUsbSpeed() --> OK\n');
	// теперь отобразим скорость работы шины USB
	if UsbSpeed = USB11_LUSBAPI then Str := 'Full-Speed Mode (12 Mbit/s)' else Str := 'High-Speed Mode (480 Mbit/s)';
	SaveResultToFile2(Format('   USB is in %s', [Str]));

	// Образ для ПЛИС возьмём из соответствующего ресурса DLL библиотеки Lusbapi.dll
	if not pModule.LOAD_MODULE(nil) then ExitProgram('Не могу загрузить модуль E20-10!')
	else SaveResultToFile2(' LOAD_MODULE() --> OK');

	// проверим загрузку модуля
 	if not pModule.TEST_MODULE() then ExitProgram('Ошибка в загрузке модуля E20-10!')
	else SaveResultToFile2(' TEST_MODULE() --> OK');

	// теперь получим номер версии загруженного драйвера DSP
	if not pModule.GET_MODULE_DESCRIPTION(@ModuleDescription) then ExitProgram('Не могу получить информацию о модуле!')
	else SaveResultToFile2(' GET_MODULE_DESCRIPTION() --> OK');

	// попробуем прочитать содержимое пользовательского ППЗУ
	if not pModule.READ_FLASH_ARRAY(@UserFlash) then ExitProgram('Не могу прочитать пользовательское ППЗУ!')
	else SaveResultToFile2(' READ_FLASH_ARRAY() --> OK');

	// получим текущие параметры работы ввода данных
	if not pModule.GET_ADC_PARS(@ap) then ExitProgram('Не могу получить текущие параметры ввода данных!')
	else SaveResultToFile2(' GET_ADC_PARS --> OK');

	// установим желаемые параметры ввода данных с модуля E20-10
	if ModuleDescription.Module.Revision = BYTE(REVISIONS_E2010[REVISION_A_E2010]) then
		ap.IsAdcCorrectionEnabled := FALSE				// запретим автоматическую корректировку данных на уровне модуля (для Rev.A)
	else
		begin
			ap.IsAdcCorrectionEnabled := TRUE; 				// разрешим автоматическую корректировку данных на уровне модуля (для Rev.B и выше)
			ap.SynchroPars.StartDelay := 0;
			ap.SynchroPars.StopAfterNKadrs := 0;
			ap.SynchroPars.SynchroAdMode := NO_ANALOG_SYNCHRO_E2010;
//			ap.SynchroPars.SynchroAdMode := ANALOG_SYNCHRO_ON_HIGH_LEVEL_E2010;
			ap.SynchroPars.SynchroAdChannel := $0;
			ap.SynchroPars.SynchroAdPorog := 0;
			ap.SynchroPars.IsBlockDataMarkerEnabled := $0;
		end;
	ap.SynchroPars.StartSource := INT_ADC_START_E2010;			// внутренний старт сбора с АЦП
//	ap.SynchroPars.StartSource := EXT_ADC_START_ON_RISING_EDGE_E2010;		// внешний старт сбора с АЦП
	ap.SynchroPars.SynhroSource := INT_ADC_CLOCK_E2010;			// внутренние тактовые импульсы АЦП
//	ap.OverloadMode := MARKER_OVERLOAD_E2010;			// фиксация факта перегрузки входных каналов при помощи маркеров в отсчёте АЦП (только для Rev.A)
	ap.OverloadMode := CLIPPING_OVERLOAD_E2010;		// обычная фиксация факта перегрузки входных каналов путём ограничения отсчёта АЦП (только для Rev.A)
	ap.ChannelsQuantity := CHANNELSQUANTITY; 			// кол-во активных каналов
	for i:=0 to (ap.ChannelsQuantity-1) do ap.ControlTable[i] := i;
	// частоту сбора будем устанавливать в зависимости от скорости USB
	ap.AdcRate := ADCRATE;														// частота АЦП данных в кГц
	if UsbSpeed = USB11_LUSBAPI then
		begin
			ap.InterKadrDelay := 0.01;		// межкадровая задержка в мс
			DataStep := 256*1024;			// размер запроса
		end
	else
		begin
			ap.InterKadrDelay := 0.0;		// межкадровая задержка в мс
			DataStep := 1024*1024;			// размер запроса
		end;
	// конфигурим входные каналы
	for i:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
		begin
			ap.InputRange[i] := ADC_INPUT_RANGE_3000mV_E2010; 	// входной диапазон 3В
			ap.InputSwitch[i] := ADC_INPUT_SIGNAL_E2010;			// источник входа - сигнал
		end;
	// передаём в структуру параметров работы АЦП корректировочные коэффициенты АЦП
	for i:=0 to (ADC_INPUT_RANGES_QUANTITY_E2010-1) do
		for j:=0 to (ADC_CHANNELS_QUANTITY_E2010-1) do
		begin
			// корректировка смещения
			ap.AdcOffsetCoefs[i][j] := ModuleDescription.Adc.OffsetCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
			// корректировка масштаба
			ap.AdcScaleCoefs[i][j] := ModuleDescription.Adc.ScaleCalibration[j + i*ADC_CHANNELS_QUANTITY_E2010];
		end;

	// передадим в модуль требуемые параметры по вводу данных
	if not pModule.SET_ADC_PARS(@ap) then ExitProgram('Не могу установить параметры ввода данных!')
	else SaveResultToFile2(' SET_ADC_PARS --> OK');

	// попробуем выделить нужное кол-во памяти под буфера данных
	for i := 0 to 1 do begin SetLength(Buffer[i], DataStep); ZeroMemory(Buffer[i], DataStep*SizeOf(SHORT)); end;

	// попробуем открыть файл для записи собранных данных
	SaveResultToFile2('');
	FileHandle := FileCreate('APC_Digital_data.dat');
	if FileHandle = -1 then ExitProgram('Не могу создать файл APC_Digital_data.dat для записи собираемых данных!')
	else SaveResultToFile2(' Create file Test.dat ... OK');

	// запустим поток сбора данных
	hReadThread := CreateThread(nil, $2000, @ReadThread, nil, 0, ReadTid);
	if hReadThread = THANDLE(nil) then ExitProgram('Не могу запустить поток сбора данных!')
	else SaveResultToFile2(' Create ReadThread ... OK');

	// отобразим параметры работы модуля по вводу данных на экране монитора
	SaveResultToFile2('');
	SaveResultToFile2  (' Module E20-10 (S/N '+StrPas(@ModuleDescription.Module.SerialNumber)+') is ready ... ');
  SaveResultToFile2('   Module Info:');
	SaveResultToFile2(Format('     Module  Revision   is ''%1.1s''', [StrPas(@ModuleDescription.Module.Revision)]));
	SaveResultToFile2(Format('     MCU Driver Version is %s (%s)', [StrPas(@ModuleDescription.Mcu.Version.FwVersion.Version), StrPas(@ModuleDescription.Mcu.Version.FwVersion.Date)]));
	SaveResultToFile2(Format('     PLD    Version     is %s (%s)', [StrPas(@ModuleDescription.Pld.Version.Version), StrPas(@ModuleDescription.Pld.Version.Date)]));
	SaveResultToFile2('   ADC parameters:');
	SaveResultToFile2('     ChannelsQuantity = '+ IntToStr(ap.ChannelsQuantity));
	SaveResultToFile2(Format('     AdcRate = %5.3f kHz', [ap.AdcRate]));
	SaveResultToFile2(Format('     InterKadrDelay = %2.4f ms', [ap.InterKadrDelay]));
	SaveResultToFile2(Format('     KadrRate =  %5.3f kHz', [ap.KadrRate]));

{ !!!  Основной цикл программы ожидания конца сбора данных !!!													}
		repeat
		if Counter <> OldCounter then
			begin
				SaveResultToFile2(Format(' Counter %3u from %3u'#13, [Counter, NBlockToRead]));
				OldCounter := Counter;
			end
		else Sleep(20);
	until IsReadThreadComplete;

	// ждём окончания работы потока ввода данных
	WaitForSingleObject(hReadThread, INFINITE);

	// две пустые строчки
	SaveResultToFile2(#10#13#10#13);

	// посмотрим были ли ошибки при сборе данных
	ExitProgram(' ', false);
	if ReadThreadErrorNumber <> 0 then
    begin
      result:=false;
      ShowThreadErrorMessage();
    end
	else
    begin
      SaveResultToFile2(' Ошибок нет, все этапы инициализации и работы прошли успешно');
      result:=true;
    end;
end;

//===============================================================================
//Функция для вычисления среднего значения переданных количеством NUM точек в зависимости от переданного канала(берем из разных массивов)

function CulculateAmplAVGPoint(masNum:smallint;numPoint:integer;index:integer):smallint;
var
i:integer;
//переменная сумматор
sum:integer;
  begin
    case masNum of
    //считаем среднее значение по numPoint точек для первого массива
    0:begin
       for i:=index to numPoint do
        begin
          sum:=sum+DigMasCh1[i];
        end;
      end;
     //считаем среднее значение по numPoint точек для второго массива
    1:begin
       for i:=index to numPoint do
        begin
          sum:=sum+DigMasCh2[i];
        end;
      end;
     //считаем среднее значение по numPoint точек для третьего массива
    2:begin
       for i:=index to numPoint do
        begin
          sum:=sum+DigMasCh3[i];
        end;
      end;
     //считаем среднее значение по numPoint точек для четвертого массива
    3:begin
       for i:=index to numPoint do
        begin
          sum:=sum+DigMasCh4[i];
        end;
      end;
    end;
  result:=round(sum/numPoint);
end;

//===============================================================================
//вспомогательные процедуры для channalTest_21



//--------------------------------------------------------------------------------

//Переделанная функция ChannelTest_21 . 1 запуск соответствует проверке одного канала(4 запуска -4канала)
function ChannalTest_21(numberOfChannel:integer):boolean;
var
//переменные для работы
//основной счетчик для полного просмотра  массива индекс которого был передан
count1:integer;
//переменная хранящая среднее значение переданного процедуре канала
srednee:smallint;
//переменная содержит в себе номер первой точки после нахождения первого перехода
beginPoint:integer;
//общий счетчик переходов по нему будем определять четный или нечетный переход
countPerex:integer;
//переменная хранящая текущее значение периода t1
t1:double;
//переменная хранящая текущее значение периода t2
t2:double;
//переменная для подсчета точек в периоде T1
numberPointCountT1:integer;
//переменная для подсчета точек в периоде Т2
numberPointCountT2:integer;
//переменная для подсчета точек половины периода T1
numberPointCountT1Past:integer;
//переменная для сохнанения значения переменной numberPointCountT1Past. При вычислении Т2
numberPointCountT1Past2:integer;
//количество точек в секунду
ACPkoef:integer;
//переменные для T2
//Среднее максимальное значение по модулю для нечетного пересечения первой половины периода Т1
//onePeriodPart:smallint;
//Среднее максимальное значение по модулю для четного пересечения второй половины периода Т1
//twoPeriodPart:smallint;

nechetZnachPeriodPart:smallint;
chetZnachPeriodPart:smallint;
//флаг для осуществление подсчета текущей амплитуды
//flagAmpl:boolean;
//переменная для хранения текущей на момент подсчета амплитуды , т.е h1,h2,h3,h4
currentAmpl:smallint;
//переменные для хранения амплитуд
h1,v1:smallint;
h2,v2:smallint;
h3,v3:smallint;
h4,v4:smallint;
//счетчик амплитуд
chAmpl:integer;
//индикатор что первый период посчитан
flagF:boolean;
etalM:integer;
etalB:integer;
DeltaetalMetalB:integer;
//переменная аккумулятор для измерения среднего значения по модулю
sredAmplPoluperiod:integer;
//
kolTochek:smallint;
chSred:smallint;
flagTest21:boolean;
//1
begin
//первичная инициализация переменных
//с начала массива
count1:=1;
//предварительное обнуление переменной
srednee:=0;
//предварительное обнуление переменной
beginPoint:=0;
//предварительное обнуление счетчика переходов
countPerex:=0;
//обнуление
t1:=0;
//обнуление
t2:=0;
//обнуление
numberPointCountT1:=0;
//обнуление
numberPointCountT2:=0;
//обнуление
numberPointCountT1Past:=0;
//обнуление
numberPointCountT1Past2:=0;
//переменная количества точек в зависимости от Выбранной частоты опроса АЦП  1мс=количество точек (ADCRATE/CHANNELSQUANTITY)
ACPkoef:=round(ADCRATE/CHANNELSQUANTITY);
//счетчик для динамического массива. Индекс у динамического массива с 0
ch_T1:=1;
//счетчик для динамического массива. Индекс у динамического массива с 0
ch_T2:=1;
//
ch_Ampl:=1;
//счетчик для вывода содержимого динамического массива T1
masT1ch:=0;
//счетчик для вывода содержимого динамического массива T2
masT2ch:=0;
//
masAmplch:=0;
//по умолчанию t1 неверен
t1Flag:=false;
//по умолчанию t2 неверен
t2Flag:=false;
//обнуление
//onePeriodPart:=0;
//обнуление
nechetZnachPeriodPart:=0;
//обнуление
chetZnachPeriodPart:=0;
//обнуление
//twoPeriodPart:=0;
//первичная реализация
//flagAmpl:=true;
//текущая амплитуда по умолчанию 0
currentAmpl:=0;
//амплитуды по умолчанию
h1:=0;
v1:=0;
h2:=0;
v2:=0;
h3:=0;
v3:=0;
h4:=0;
v4:=0;
//счетчик подсчета колличества амплитуд
chAmpl:=0;
//индикаторы правильности полученных амплитуд
testFlagH1:=false;
testFlagH2:=false;
testFlagH3:=false;
testFlagH4:=false;
flagF:=false;
flagTest21:=false;
etalM:=0;
etalB:=0;
//
DeltaetalMetalB:=0;
//счетчик для подсчета среднего значения в полупериоде
sredAmplPoluperiod:=0;
//переменная для выставления колличества точек для подсчета среднего значения полупериода
kolTochek:=100;
chSred:=0;
//-----------------------------------------------------------------------------

//перед тем как начать разбирать переданный канал(0-3), найдем ось X , среднее значение всех точек канала
srednee:=CulculateAmplAVGPoint(numberOfChannel,round(SIZEDIGMAS/16),count1);

//Предварительно перед началом разбора массива найдем первый переход (с плюса в минус или с минуса в плюс)
//основной цикл для полного просмотра уже заполненных массивов
//DigMasCh1,DigMasCh2,DigMasCh3,DigMasCh4
while count1<=round(SIZEDIGMAS/16)-1 do
  //8
  begin
  //В зависимости от канала анализируем разные каналы(массивы) 0-3(4) (case)
  //==========================================================================
  //9
  case numberOfChannel of
    //1 канал
    0:
      //10
      begin
        //начальная точка выше среднего значения
        if (DigMasCh1[count1]>=srednee) then
          //14
          begin
            //следующеее значение ниже среднего(переход)
            if(DigMasCh1[count1+1]<srednee)then
              //15
              begin
                //номер точки с которой происходит переход и начинается отсчет
                beginPoint:=count1+1;
                //нашли переход и вышли из цикла
                break;
              //15
              end;
          //14
          end

          //начальная точка ниже среднего значения
          else if(DigMasCh1[count1]<srednee) then
            //16
            begin
              //следующеее значение ниже среднего(переход)
              if(DigMasCh1[count1+1]>=srednee)then
                //17
                begin
                  //номер точки с которой происходит переход и начинается отсчет
                  beginPoint:=count1+1;
                  //нашли переход и вышли из цикла
                  break;
                //17
                end;
            //16
            end;

      //10
      end;
    //2 канал
    1:
      //11
      begin
      //начальная точка выше среднего значения
        if (DigMasCh2[count1]>=srednee) then
          //18
          begin
            //следующеее значение ниже среднего(переход)
            if(DigMasCh2[count1+1]<srednee)then
              //19
              begin
                //номер точки с которой происходит переход и начинается отсчет
                beginPoint:=count1+1;
                //нашли переход и вышли из цикла
                break;
              //19
              end;
          //18
          end

          //начальная точка ниже среднего значения
          else if(DigMasCh2[count1]<srednee) then
            //20
            begin
              //следующеее значение ниже среднего(переход)
              if(DigMasCh2[count1+1]>=srednee)then
                //21
                begin
                  //номер точки с которой происходит переход и начинается отсчет
                  beginPoint:=count1+1;
                  //нашли переход и вышли из цикла
                  break;
                //21
                end;
            //20
            end;

      //11
      end;
    //3 канал
    2:
      //12
      begin
      //начальная точка выше среднего значения
        if (DigMasCh3[count1]>=srednee) then
          //22
          begin
            //следующеее значение ниже среднего(переход)
            if(DigMasCh3[count1+1]<srednee)then
              //23
              begin
                //номер точки с которой происходит переход и начинается отсчет
                beginPoint:=count1+1;
                //нашли переход и вышли из цикла
                break;
              //23
              end;
          //22
          end

          //начальная точка ниже среднего значения
          else if(DigMasCh3[count1]<srednee) then
            //24
            begin
              //следующеее значение ниже среднего(переход)
              if(DigMasCh3[count1+1]>=srednee)then
                //25
                begin
                  //номер точки с которой происходит переход и начинается отсчет
                  beginPoint:=count1+1;
                  //нашли переход и вышли из цикла
                  break;
                //25
                end;
            //24
            end;
      //12
      end;
    //4 канал
    3:
      //13
      begin
        //начальная точка выше среднего значения
        if (DigMasCh4[count1]>=srednee) then
          //26
          begin
            //следующеее значение ниже среднего(переход)
            if(DigMasCh4[count1+1]<srednee)then
              //27
              begin
                //номер точки с которой происходит переход и начинается отсчет
                beginPoint:=count1+1;
                //нашли переход и вышли из цикла
                break;
              //27
              end;
          //26
          end

          //начальная точка ниже среднего значения
          else if(DigMasCh4[count1]<srednee) then
            //28
            begin
              //следующеее значение ниже среднего(переход)
              if(DigMasCh4[count1+1]>=srednee)then
                //29
                begin
                  //номер точки с которой происходит переход и начинается отсчет
                  beginPoint:=count1+1;
                  //нашли переход и вышли из цикла
                  break;
                //29
                end;
            //28
            end;
      //13
      end;
  //9
  end;
  //увеличиваем счетчик для перехода к следующему значению
  inc(count1)
  //8
  end;

//+++

//перереализация поиска Т1 ,Т2, Амплитуд

//начинаем анализировать массив с найденной первой точки после первого перехода
count1:=beginPoint;

//основной цикл для полного просмотра уже заполненных массивов
//DigMasCh1,DigMasCh2,DigMasCh3,DigMasCh4
while count1<=round(SIZEDIGMAS/16)-1 do
  //2
  begin
  //В зависимости от канала анализируем разные каналы(массивы) 0-3(4) (case)
  //==========================================================================
  //3
  case numberOfChannel of
  //1 канал
  0:
    begin
      //начальная точка ВЫШЕ среднего значения
        if (DigMasCh1[count1]>=srednee) then
          begin
            //следующеее значение НИЖЕ среднего(переход)
            if((DigMasCh1[count1+1]<srednee) and (DigMasCh1[count1+2]<srednee) and (DigMasCh1[count1+3]<srednee) and (DigMasCh1[count1+4]<srednee) and (DigMasCh1[count1+5]<srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh1[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2/2)]-srednee;

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                     chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                     sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;


                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;

                    //form1.Memo1.Lines.Add('Неч полу-д '+ ' Кол. т: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));


                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                     if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                    // (abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                           // form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh1[count1])+' И '+intToStr(DigMasCh1[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                       //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;


                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin

                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                        chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                        sredAmplPoluperiod:=0;



                      //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      //nechetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2/2)]-srednee;

                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;


                      //ЧЕТНОЕ значение предидущего полупериода
                      //chetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;

                      if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                      else
                        begin
                          etalM:=abs(nechetZnachPeriodPart) ;
                          etalB:=abs(chetZnachPeriodPart);
                        end;

                    //  form1.Memo1.Lines.Add(' Чет. полу-д '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                      //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                      //  if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                        begin
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                             //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Количество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t1
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                        end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end
        //начальная точка НИЖЕ среднего значения
        else
          begin
            //следующеее значение ВЫШЕ среднего(переход)
            if((DigMasCh1[count1+1]>=srednee) and (DigMasCh1[count1+2]>=srednee) and (DigMasCh1[count1+3]>=srednee) and (DigMasCh1[count1+4]>=srednee) and (DigMasCh1[count1+5]>=srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh1[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2/2)]-srednee;
                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;
                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                     // form1.Memo1.Lines.Add(' Неч. полуп. '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                     //if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                       //  form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2));
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                        //    form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh1[count1])+' И '+intToStr(DigMasCh1[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                    //   form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;

                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh1[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;
                     //ЧЕТНОЕ значение предидущего полупериода
                   if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                     //form1.Memo1.Lines.Add(' Чет. полуп. '+ ' Колич. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                   if (abs(etalM)+abs(round(etalM*0.5)))<abs(etalB) then
                    // if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2));
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                        //    form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end;

    end;
  //2 канал
  1:
    begin
      //начальная точка ВЫШЕ среднего значения
        if (DigMasCh2[count1]>=srednee) then
          begin
            //следующеее значение НИЖЕ среднего(переход)
            if((DigMasCh2[count1+1]<srednee) and (DigMasCh2[count1+2]<srednee) and (DigMasCh2[count1+3]<srednee) and (DigMasCh2[count1+4]<srednee) and (DigMasCh2[count1+5]<srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                     // form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh2[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2/2)]-srednee;

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                     chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                     sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;


                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;

                    //form1.Memo1.Lines.Add('Неч полу-д '+ ' Кол. т: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));


                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                     if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                    // (abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)
                      begin
                       //  form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                       //  form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh2[count1])+' И '+intToStr(DigMasCh2[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                    //   form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;


                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin

                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                        chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                        sredAmplPoluperiod:=0;



                      //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      //nechetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2/2)]-srednee;

                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;


                      //ЧЕТНОЕ значение предидущего полупериода
                      //chetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;

                      if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                      else
                        begin
                          etalM:=abs(nechetZnachPeriodPart) ;
                          etalB:=abs(chetZnachPeriodPart);
                        end;

                      //form1.Memo1.Lines.Add(' Чет. полу-д '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                      //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                      //  if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                        begin
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                             //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t1
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                        end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end
        //начальная точка НИЖЕ среднего значения
        else
          begin
            //следующеее значение ВЫШЕ среднего(переход)
            if((DigMasCh2[count1+1]>=srednee) and (DigMasCh2[count1+2]>=srednee) and (DigMasCh2[count1+3]>=srednee) and (DigMasCh2[count1+4]>=srednee) and (DigMasCh2[count1+5]>=srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh2[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2/2)]-srednee;
                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;
                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                      //form1.Memo1.Lines.Add(' Неч. полуп. '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                     //if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh2[count1])+' И '+intToStr(DigMasCh2[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                       //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;

                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh2[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;
                     //ЧЕТНОЕ значение предидущего полупериода
                   if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                     //form1.Memo1.Lines.Add(' Чет. полуп. '+ ' Колич. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                   if (abs(etalM)+abs(round(etalM*0.5)))<abs(etalB) then
                    // if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                       //  form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end;

    end;
  //3 канал
  2:
    begin
      //начальная точка ВЫШЕ среднего значения
        if (DigMasCh3[count1]>=srednee) then
          begin
            //следующеее значение НИЖЕ среднего(переход)
            if((DigMasCh3[count1+1]<srednee) and (DigMasCh3[count1+2]<srednee) and (DigMasCh3[count1+3]<srednee) and (DigMasCh3[count1+4]<srednee) and (DigMasCh3[count1+5]<srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh3[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2/2)]-srednee;

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                     chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                     sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;


                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;

                    //form1.Memo1.Lines.Add('Неч полу-д '+ ' Кол. т: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));


                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                     if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                    // (abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)
                      begin
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                      //   form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh3[count1])+' И '+intToStr(DigMasCh3[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                    //   form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;


                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin

                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                        chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                        sredAmplPoluperiod:=0;



                      //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      //nechetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2/2)]-srednee;

                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;


                      //ЧЕТНОЕ значение предидущего полупериода
                      //chetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;

                      if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                      else
                        begin
                          etalM:=abs(nechetZnachPeriodPart) ;
                          etalB:=abs(chetZnachPeriodPart);
                        end;

                      //form1.Memo1.Lines.Add(' Чет. полу-д '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                      //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                      //  if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                        begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                             //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t1
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                        end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end
        //начальная точка НИЖЕ среднего значения
        else
          begin
            //следующеее значение ВЫШЕ среднего(переход)
            if((DigMasCh3[count1+1]>=srednee) and (DigMasCh3[count1+2]>=srednee) and (DigMasCh3[count1+3]>=srednee) and (DigMasCh3[count1+4]>=srednee) and (DigMasCh3[count1+5]>=srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh3[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2/2)]-srednee;
                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;
                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                      //form1.Memo1.Lines.Add(' Неч. полуп. '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                     //if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh3[count1])+' И '+intToStr(DigMasCh3[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                      // form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;

                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh3[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;
                     //ЧЕТНОЕ значение предидущего полупериода
                   if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                    // form1.Memo1.Lines.Add(' Чет. полуп. '+ ' Колич. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                   if (abs(etalM)+abs(round(etalM*0.5)))<abs(etalB) then
                    // if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                        // form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end;

    end;
  //4 канал
  3:
    begin
      //начальная точка ВЫШЕ среднего значения
        if (DigMasCh4[count1]>=srednee) then
          begin
            //следующеее значение НИЖЕ среднего(переход) !!!! если следующая точка меньше среднего значения и пятая точка вперед меньше среднего, то переход!
            if((DigMasCh4[count1+1]<srednee) and (DigMasCh4[count1+2]<srednee) and (DigMasCh4[count1+3]<srednee) and (DigMasCh4[count1+4]<srednee) and (DigMasCh4[count1+5]<srednee)) then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh4[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2/2)]-srednee;

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                     chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                     sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;


                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;

                    //form1.Memo1.Lines.Add('Неч полу-д '+ ' Кол. т: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));


                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                     if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                    // (abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh4[count1])+' И '+intToStr(DigMasCh4[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                       //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;


                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin

                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                        chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                        sredAmplPoluperiod:=0;



                      //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      //nechetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2/2)]-srednee;

                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;


                      //ЧЕТНОЕ значение предидущего полупериода
                      //chetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;

                      if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                      else
                        begin
                          etalM:=abs(nechetZnachPeriodPart) ;
                          etalB:=abs(chetZnachPeriodPart);
                        end;

                      //form1.Memo1.Lines.Add(' Чет. полу-д '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                      //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                      //  if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                        begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                             form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));

                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t1
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                        end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end
        //начальная точка НИЖЕ среднего значения
        else
          begin
            //следующеее значение ВЫШЕ среднего(переход)
            if((DigMasCh4[count1+1]>=srednee) and (DigMasCh4[count1+2]>=srednee) and (DigMasCh4[count1+3]>=srednee) and (DigMasCh4[count1+4]>srednee) and (DigMasCh4[count1+5]>=srednee))then
              begin
                //увеличиваем счетчик переходов
                inc(countPerex);

                // Проверяем какой из переходов был получен

                //НЕЧЕТНЫЙ
                if (countPerex mod 2 <>0) then
                  begin
                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый НЕЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                      //form1.Memo1.Lines.Add('Первый нечетный полупериод'+ ' Количество точек в нем:'+intToStr(numberPointCountT1Past2)+' Среднее значение:'+intToStr(DigMasCh4[count1-round(numberPointCountT1Past2/2)]-srednee));
                    end
                  //уже не первый по счету НЕЧЕТНЫЙ полупериод
                  else
                    begin

                     for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                     //nechetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2/2)]-srednee;
                      for chSred:=1 to kolTochek do
                      begin
                        sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                      end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //ЧЕТНОЕ значение предидущего полупериода
                     //chetZnachPeriodPart:=DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)]-srednee;
                     if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                      //form1.Memo1.Lines.Add(' Неч. полуп. '+ ' Кол. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Неч. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. чет. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                      if ((abs(etalM)+abs(round(etalM*0.5)))<abs(etalB)) then
                     //if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

                //ЧЕТНЫЙ
                if (countPerex mod 2 =0) then
                  begin

                  //в этот момент накопилось необходимое количество точек для расчета t1
                  //считаем t1
                  //----------------------------------------------------------
                  //form1.Memo1.Lines.Add('Переход выше/ниже между. Конец периода '+intToStr(DigMasCh4[count1])+' И '+intToStr(DigMasCh4[count1+1])+' Количество насчитаных точек в периоде '+intToStr(numberPointCountT1));
                  //считаем период t1 из расчета накопленных точек.
                  t1:=numberPointCountT1/ACPkoef;
                  //проверяем попадает ли t1 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                  if((t1<8) or (t1>10)) then
                    //36
                    begin
                      // form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t1)+' Колличество точек:'+inttostr(numberPointCountT1));
                       t1:=t1*2;
                      //36
                    end;
                  //записываем значение в массив для t1
                  //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                  SetLength(masT1,ch_T1);
                  //записываем в новую ячейку полученное значение t1
                  masT1[ch_T1-1]:=t1;
                  //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                  inc(ch_T1);
                  // t1 посчитали для текущего периода, сбрасываем счетчик
                  numberPointCountT1:=0;

                  // T2-----------------------------------------------------------
                  //Получили количество точек в полупериоде записали их в отдельную переменную и обнулили
                  numberPointCountT1Past2:=numberPointCountT1Past;
                  numberPointCountT1Past:=0;
                  //------------------------------------------------------------
                  //Если это первый ЧЕТНЫЙ полупериод то не сравниваем с предидущим
                  if (flagF=false) then
                    begin
                      //меняем флаг , так как след. раз будет уже не первым
                      flagF:=true;
                    end
                  //уже не первый по счету ЧЕТНЫЙ полупериод
                  else
                    begin
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      chetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;

                     //сравниваем среднее значение НЕЧЕТНОГО полупериода с предидущим значением ЧЕТНОГО
                      for chSred:=1 to kolTochek do
                        begin
                          sredAmplPoluperiod:=sredAmplPoluperiod+(DigMasCh4[count1-round(numberPointCountT1Past2+numberPointCountT1Past2/2)-round(kolTochek/2)+chSred]-srednee);
                        end;
                      nechetZnachPeriodPart:=round(sredAmplPoluperiod/kolTochek);
                      sredAmplPoluperiod:=0;
                     //ЧЕТНОЕ значение предидущего полупериода
                   if (abs(nechetZnachPeriodPart)>=abs(chetZnachPeriodPart)) then
                        begin
                          etalM:=abs(chetZnachPeriodPart);
                          etalB:=abs(nechetZnachPeriodPart);
                        end
                     else
                      begin
                        etalM:=abs(nechetZnachPeriodPart) ;
                        etalB:=abs(chetZnachPeriodPart);
                      end;
                     //form1.Memo1.Lines.Add(' Чет. полуп. '+ ' Колич. точ.: '+intToStr(numberPointCountT1Past2)+' Сред. знач. Чет. пер.: '+intToStr(nechetZnachPeriodPart)+' Сред. знач. пред. Неч. '+intToStr(chetZnachPeriodPart)+' 150%'+intToStr(abs(etalM)+abs(round(etalM*0.5)))+' Текущая ступенька:'+intToStr(abs(etalB)));
                     //сравниваем два этих значения для поиска перехода для Т2. Если нужный переход, то разница должна быть больше 40%
                   if (abs(etalM)+abs(round(etalM*0.5)))<abs(etalB) then
                    // if(abs(abs(nechetZnachPeriodPart)-abs(chetZnachPeriodPart))>etal)then
                      begin
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 до вычета полупериода'+intToStr(numberPointCountT2));
                         //отнимаем целиковый период
                         numberPointCountT2:=numberPointCountT2-numberPointCountT1Past2;
                         //form1.Memo1.Lines.Add('Количество точек в периоде Т2 после вычета полупериода'+intToStr(numberPointCountT2));
                         //считаем Т2
                         //------------------------------------------------------
                         //считаем период t2 из расчета накопленных точек.
                         t2:=numberPointCountT2/ACPkoef;
                         form1.Memo1.Lines.Add('Период Т2 '+FloatToStr(t2)+'мс');
                         //проверяем попадает ли t2 в норму ТУ пункт 3.21. Если нет то выдаем отладочную информацию
                         if((t2<60) or (t2>80)) then
                          //36
                          begin
                            //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' T1='+floatToStr(t2)+' Колличество точек:'+inttostr(numberPointCountT2));
                            //36
                          end;
                          //записываем значение в массив для t2
                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masT2,ch_T2);
                          //записываем в новую ячейку полученное значение t2
                          masT2[ch_T2-1]:=t2;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_T2);
                          //-----------------------------------------------------
                          //Подсчет амплитуд
                          //занесение всех значений амплитуд в массив амплитуд

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение минимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalM;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);

                          //задаем размерность для записи. Заказываем дополнительную ячейку в массиве
                          SetLength(masAmpl_test21,ch_Ampl);
                          //записываем в новую ячейку полученное значение максимальной амплитуды при переходе
                          masAmpl_test21[ch_Ampl-1]:=etalB;
                          //увеличиваем счетчик для записи в массив, чтобы можно было при следующей записи записать еще
                          inc(ch_Ampl);
                          //----------------------------------------------------
                          // t2 посчитали для текущего периода, сбрасываем счетчик
                          numberPointCountT2:=0;
                      end;

                    end;
                    //T2--------------------------------------------------------
                  end;

              end;
          end;

    end;

  end;

  //основной счетчик
  inc(count1);
  //подсчет точек для периода Т1
  inc(numberPointCountT1);
  //подсчет точек для периода Т2
  inc(numberPointCountT2);
  //подсчет точек для ровно половины периода
  inc(numberPointCountT1Past);

end;


//------------------------------------------------------------------------------
//Выводим в Мемо, периоды t1 и номер периода для ацифрованного сигнала
form1.Memo1.Lines.Add('');
for masT1ch:=1 to high(masT1)+1 do
  begin
    form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' Период №'+intToStr(masT1ch)+' T1='+FloatToStr(masT1[masT1ch-1])+' мс');
  end;
//формируем признак Правильности периода Т1
for masT1ch:=1 to high(masT1)+1 do
  begin
    //проверяем попали ли в диапазон t1 по ТУ для пункта 3.21. Попадает или не попадает формируем соответствующий признак
    if((masT1[masT1ch-1]>=8) and (masT1[masT1ch-1]<=10)) then t1Flag:=true
      else
        begin
          t1Flag:=false;
          break;
        end;
  end;

//Содержимое динамического массива для текущего канала выведено, делаем его пустым
masT1:=nil;
//------------------------------------------------------------------------------

//Выводим в Мемо, периоды t2 и номер периода для ацифрованного сигнала
form1.Memo1.Lines.Add('');
for masT2ch:=1 to high(masT2) do
  begin
    form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' Период №'+intToStr(masT2ch)+' T2='+FloatToStr(masT2[masT2ch])+' мс');
  end;

//
for masT2ch:=1 to high(masT2) do
  begin
    //проверяем попали ли в диапазон t2 по ТУ для пункта 3.21. Попадает или не попадает формируем соответствующий признак
    if((masT2[masT2ch]>=60) and (masT2[masT2ch]<=80)) then t2Flag:=true
      else
        begin
          t2Flag:=false;
          break;
        end;
  end;


//Содержимое динамического массива для текущего канала выведено, делаем его пустым
masT2:=nil;
//------------------------------------------------------------------------------
//Выводим в Мемо, Амплитуды и номер периода для ацифрованного сигнала
form1.Memo1.Lines.Add('');
masAmplch:=1;
masT2ch:=1;
while masAmplch<=high(masAmpl_test21) do
  begin
    //form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' Период №'+intToStr(masT2ch)+' АмплитудаMin='+FloatToStr(masAmpl_test21[masAmplch-1])+'мB'+' АмплитудаMax='+FloatToStr(masAmpl_test21[masAmplch])+'мB');

    currentAmpl:=masAmpl_test21[masAmplch-1];
    //счетчик амплитуд с нуля
if(chAmpl<4) then
  begin
  //h1
  if(currentAmpl>=36)and(currentAmpl<=44)and(not testFlagH1) then
    begin
      v1:=currentAmpl;
      h1:=round(currentAmpl*2);
      //раз уж мы тут то true
      testFlagH1:=true;
      //счетчик амплитуд +1 . всего амплитуд должно быть 4
      inc(chAmpl);
    end;
  //h2
  if(currentAmpl>=72)and(currentAmpl<=88)and(not testFlagH2) then
    begin
      v2:=currentAmpl;
      h2:=round(currentAmpl*2);
      //раз уж мы тут то true
      testFlagH2:=true;
      //счетчик амплитуд +1 . всего амплитуд должно быть 4
      inc(chAmpl);
    end;
  //h3
  if(currentAmpl>=288)and(currentAmpl<=352)and(not testFlagH3) then
    begin
      v3:=currentAmpl;
      h3:=round(currentAmpl*2);
      //раз уж мы тут то true
      testFlagH3:=true;
      //счетчик амплитуд +1 . всего амплитуд должно быть 4
      inc(chAmpl);
    end;
  //h4
  if(currentAmpl>=1125)and(currentAmpl<=1375)and(not testFlagH4) then
    begin
      v4:=currentAmpl;
      h4:=round(currentAmpl*2);
      //раз уж мы тут то true
      testFlagH4:=true;
      //счетчик амплитуд +1 . всего амплитуд должно быть 4
      inc(chAmpl);
    end;

 end;
    masAmplch:=masAmplch+1;
    masT2ch:=masT2ch+1;
  end;

  //------------------------------------------------------------------------------
//Выводим содержимое переменных амплитуд
form1.Memo1.Lines.Add('Канал №'+intToStr(numberOfChannel+1)+' H1='+intToStr(h1)+' мВ'+' V1='+intToStr(v1)+' мВ'+' H2='+intToStr(h2)+' мВ'+' V2='+intToStr(v2)+' мВ'+' H3='+intToStr(h3)+' мВ'+' V3='+intToStr(v3)+' мВ'+' H4='+intToStr(h4)+' мВ'+' V4='+intToStr(v4)+' мВ');
//
//Успешность выполнения проверки ТУ пункт 3.21
if(testFlagH1)and(testFlagH2)and(testFlagH3)and(testFlagH4)and(t1Flag)and(t2Flag) then
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка сигнала проверки функционирования '+modifStr+' Канала №'+intToStr(numberOfChannel+1)+' : НОРМА ');
    flagTest21:=true;
    SaveResultToFile('Автоматическая проверка сигнала проверки функционирования '+modifStr+' Канала №'+intToStr(numberOfChannel+1)+' : НОРМА ');
  end
else
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка сигнала проверки функционирования '+modifStr+' Канала №'+intToStr(numberOfChannel+1)+' : НЕ НОРМА ');
    flagTest21:=false;;
    SaveResultToFile('Автоматическая проверка сигнала проверки функционирования '+modifStr+' Канала №'+intToStr(numberOfChannel+1)+' : НЕ НОРМА ');
  end;



//Содержимое динамического массива для текущего канала выведено, делаем его пустым
masAmpl_test21:=nil;
//------------------------------------------------------------------------------
result:=flagTest21;
//1
end;




// Пункт автоматической проверки 3.21.
procedure testTU_3_21();
var
sm,i_chan:integer;
//переменная для файла формируемого АЦП для получения значений
APC_Digital_data:file of smallint;
//переменная для хранения одного цифрового значения со входа АЦП (16 бит).
rez:smallint;
fl:boolean;
count,count1:integer;
begin
//инициализация счетчика
count:=1;
//инициализируем сигнал на УЦФ.
//выключили подачу напряжения с источника на выход
ControlVoltageOnPowerSupply('0');
//размыкаем на ИСД 33 канал.
CommutateChannelOnISD(33,'0');
sleep(500);
ControlVoltageOnPowerSupply('1');
//замыкаем на ИСД 33 канал.
CommutateChannelOnISD(33,'1');
//задержка полученная экспериментальным путем для выбора времени оцифровки сигнала
sleep(8);

//------начинаем сбор данных с АЦП---------------------------------

//Инициализируем АЦП Е20-10, производим все этапы тестирования для работы, записываем всё в лог файл и осуществляем запись (не разобранных!) цифровых данных в массив и файл APC_Digital_data.dat
fl:=ACP_E20_10_Initialise_Work;
//После выполнения у нас есть файл APC_Digital_data.dat из которого надо собрать переданный цифровой сигнал с каналов.
//устанавливаем связь файловой переменной с файлом APC_Digital_data.dat
assignfile(APC_Digital_data,'APC_Digital_data.dat');
// Открытие файла c данными на чтение
Reset(APC_Digital_data);
//непосредственно тело парсера для сбора каналов
//пока не конец файла, читаем
while not eof(APC_Digital_data) do
  begin
    //считываем первую строку
    read(APC_Digital_data,rez);
    //заполняем значения в массив
    masACPdat[count]:=rez;
    inc(count);
  end;

//смещение для выборки нужных значений каналов из массива
sm:=0;
//убираем точки для вывода на экран
form1.Series1.Pointer.Visible:=false;
//Вывод проверочного сигнала для текущего канала I[1..4]


strstr1:='000.txt';
AssignFile(probfile1,strstr1);
ReWrite(probfile1);

//!!!Для одного канала (4). 1
for i_chan:=1 to 4 do
  begin
    //счетчик для выборки значений нужного канала из масива значений АЦП
    count:=1+sm;
    //счетчик для вывода номера точки
    count1:=1;
    //меняем название графика с АЧХ на Цифровой сигнал № канала
    form1.Chart1.Title.Text.Strings[0]:='Сигнал проверки УЦФ. Канал №'+IntToStr(i_chan);



    while count<=round(SIZEDIGMAS/4) do
      begin
        //Вывод значения в мВ на график
        form1.Chart1.Series[0].AddXY(count1,round(masACPdat[count]*koef_mV));

        case i_chan of
        1: begin
            DigMasCh1[count1]:=round(masACPdat[count]*koef_mV);
            SaveResultToFile4(intTostr(DigMasCh1[count1]));
           end;
        2: begin
            DigMasCh2[count1]:=round(masACPdat[count]*koef_mV);
            SaveResultToFile4(intTostr(DigMasCh2[count1]));
           end;
        3: begin
            DigMasCh3[count1]:=round(masACPdat[count]*koef_mV);
            SaveResultToFile4(intTostr(DigMasCh3[count1]));
           end;
        4: begin
            DigMasCh4[count1]:=round(masACPdat[count]*koef_mV);
            SaveResultToFile4(intTostr(DigMasCh4[count1]));
           end;
        end;

        //form1.Image1.Canvas.LineTo(count1,masACPdat[count]);
        count:=count+4;
        inc(count1);
      end;
    wait(1000);
    inc(sm);
    //очищаем сигнал для отображения следующего канала
    form1.Chart1.Series[0].Clear;
    wait(500);
  end;
form1.Chart1.Title.Text.Strings[0]:='АЧХ';
//form1.Series1.Pointer.Visible:=true;

closefile(probfile1);

//Выполняем поиск параметров для каждого канала

//Находим и выводим время T1 для каждого канала
//для канала 1 (0)
flagTest21FCh1:=ChannalTest_21(0);
//для канала 2 (1)
flagTest21FCh2:=ChannalTest_21(1);
//для канала 3 (2)
flagTest21FCh3:=ChannalTest_21(2);
//для канала 4 (3)
flagTest21FCh4:=ChannalTest_21(3);


//result:=fl;
end;




// Пункт автоматической проверки 3.22.
function testTU_3_22():boolean;
var
kolCh,i:integer;
voltage:double;
str:string;
begin
//Количество каналов в приборе
kolCh:=4;

for i:=1 to kolCh do
  begin
    //выставляем очередной канал на ИСД для проверки
    changeChannel(i);
    //установка частоты среза DF2
    setFreqUCF(form1.ComboBox5.ItemIndex,1);
    //Установка коэфициента усиления 1 , режим DA8
    setKoef(i,1);
    //для вывода на график цифровых значении проверяемого канала, перелючаем тумблера.
    case i of
     1:form1.RadioButton5.Checked:=true;
     2:form1.RadioButton6.Checked:=true;
     3:form1.RadioButton7.Checked:=true;
     4:form1.RadioButton8.Checked:=true;
    end;
    //==========================================================================
    //Производим измерения напряжения c вольтметра.
    //Выставляем значение частоты и амплитуды на генераторе сигналов(переданная частота, переданная амплитуда) Частота F3, Амплитуда в зависимости от модификации устройства соответствует режиму преобразования DA8.
    SetFrequencyOnGenerator(masFrequency1[Form1.Combobox5.ItemIndex+1,2,3],masAmpl[Form1.Combobox5.ItemIndex+1,1]); {ch}

    //Переводим вольтметр в режим считывания значений с экрана вольтметра
    SetConf(m_instr_usbtmc[0],'READ?');

    //Даем время на переключение в режим
    Wait(500);

    //читаем в str показания вольтметра
    GetDatStr(m_instr_usbtmc[0],str);
    voltage:=strToFloat(str);
    //Производим вычисление действующего значения по цифровым данным
    //Включаем принятие цифровых данных с адаптера
    form1.idUDPServer1.Active:=true;
    //Процедура для получения данных с адаптера когда они придут TForm1.IdUDPServer1UDPRead
    wait(500);
    //К данному моменту массив с переведенными данными должен быть заполнен
    //Вычисление действующего значения
    DVolume:=CalculateDeistvZnach();
    //Заносим действующее значение в массив действующих значений по каналам
    MasDVolume[i]:=DVolume;
    //Вычисление Амплитуды
    AmplVolume:=DVolume*sqrt(2);

    //Сравнение действующего значения с показателями с вольтметра.
    if ((DVolume<=(1000*(voltage+0.04)))and(DVolume>=(1000*(voltage-0.04)))) then
      begin
        TrueDigMas[i]:=true;
        StrDigMas[i]:='НОРМА';
      end
    else
      begin
        TrueDigMas[i]:=false;
        StrDigMas[i]:='НЕ НОРМА';
      end;

    //Либо сравнение с показателями по ТУ 1280+-40 мВ [1.24,1.32]
   { if ((DVolume<=1.32)and(DVolume>=1.24)) then
      begin
        TrueDigMas[i]:=true;
        StrDigMas[i]:='НОРМА';
      end
    else
      begin
        TrueDigMas[i]:=false;
        StrDigMas[i]:='НЕ НОРМА';
      end;   }

  end;

  //Выключаем принятие цифровых данных с адаптера
    form1.idUDPServer1.Active:=false;
  //Очищаем форму для вывода.
    form1.image1.Canvas.Rectangle(0,0,form1.image1.Width,form1.image1.Height);
    form1.image1.Canvas.MoveTo(0,0);
  //Выводим результат проверки.
  for i:=1 to 4 do
    begin
      if (TrueDigMas[i]) then result:=true
        else
          begin
           result:=false;
           break;
          end;
    end;

end;
//------------------------------------------------------------------------------

procedure TForm1.Button2Click(Sender: TObject);
var
//счетчик для реализации цикла по выводу.
i:integer;
//счетчик для реализации вывода из массива по 8 значений(DA1-DA8)
j:integer;
//счетчик для перебора значений из общего массива
k:integer;

sbrosFlag:boolean;

strFor3_20:string;
begin
//Определение модификации устройства.
case (form1.ComboBox5.ItemIndex) of
0:modifStr:=form1.ComboBox5.Items[0];
1:modifStr:=form1.ComboBox5.Items[1];
2:modifStr:=form1.ComboBox5.Items[2];
3:modifStr:=form1.ComboBox5.Items[3];
4:modifStr:=form1.ComboBox5.Items[4];
end;
//------------------------------------------------------------------------------

//Поключение к ИСД
Button1Click (Form1);

//Проверка началась, делаем недоступными другие элементы
AllDisable;
form1.ComboBox5.Enabled:=false;
form1.Button2.Enabled:=false;
//------------------------------------------------------------------------------

//Отключаем принятие цифровых данных
idUDPServer1.Active:=false;
//------------------------------------------------------------------------------

// По ТУ необходимо проверять именно в этих условиях
//Перевод в режим частоты среза DF2 в зависимости от выбранного прибора
setFreqUCF(form1.ComboBox5.ItemIndex,1);

//Включение коэфициента усиления DA4 на всех 4-х каналах
//1 канал

setKoef(1,16);
//2 канал

setKoef(2,16);
//3 канал

setKoef(3,16);
//4 канал

setKoef(4,16);
//------------------------------------------------------------------------------

//Проверка пункта 3.13.
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ ПИТАНИЯ И МОЩНОСТИ ПОТРЕБЛЕНИЯ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ ПИТАНИЯ И МОЩНОСТИ ПОТРЕБЛЕНИЯ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

if(testTU_3_13) then
begin
form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Uисточника=34.00 В'+' Pпотребления='+floatToStr(P1)+' Вт');
form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Uисточника=22.00 В'+' Pпотребления='+floatToStr(P2)+' Вт');
form1.Memo1.Lines.Add('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НОРМА ');
SaveResultToFile('Модификация устройства:'+modifStr+' Uисточника=34.00 В'+' Pпотребления='+floatToStr(P1)+' Вт');
SaveResultToFile('Модификация устройства:'+modifStr+' Uисточника=22.00 В'+' Pпотребления='+floatToStr(P2)+' Вт');
SaveResultToFile('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НОРМА ');
testTU_3_13Fin:=true;
end
  else
  begin
    form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Uисточника=34.00 В'+' Pпотребления='+floatToStr(P1)+' Вт');
    form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Uисточника=22.00 В '+'Pпотребления='+floatToStr(P2)+' Вт');
    form1.Memo1.Lines.Add('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile('Модификация устройства:'+modifStr+' Uисточника=34.00 В'+' Pпотребления='+floatToStr(P1)+' Вт');
    SaveResultToFile('Модификация устройства:'+modifStr+' Uисточника=22.00 В'+' Pпотребления='+floatToStr(P2)+' Вт');
    SaveResultToFile('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НЕ НОРМА ');
    testTU_3_13Fin:=false;
  end;
//-------------------------------------------------------------------------------

//Проверка пункта 3.15.
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ ПОСТОЯННОГО ТОКА НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ ПОСТОЯННОГО ТОКА НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();
if(testTU_3_15) then
  begin
    for i:=1 to 4 do
      begin
        form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Напряжение на вольтметре:'+floatToStrF(VoltMas[i],ffFixed,4,3)+' В '+strMasStr[i]);
        SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Напряжение на вольтметре:'+floatToStrF(VoltMas[i],ffFixed,4,3)+' В '+strMasStr[i]);
      end;
    form1.Memo1.Lines.Add('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НОРМА ');
    SaveResultToFile('Автоматическая проверка напряжения постоянного тока на выходе преобразователя '+modifStr+' : НОРМА ');
    testTU_3_15Fin:=true;
  end
else
  begin
     for i:=1 to 4 do
      begin
        form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Напряжение на вольтметре:'+floatToStrF(VoltMas[i],ffFixed,4,3)+' В '+strMasStr[i]);
        SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Напряжение на вольтметре:'+floatToStrF(VoltMas[i],ffFixed,4,3)+' В '+strMasStr[i]);
      end;
      form1.Memo1.Lines.Add('Автоматическая проверка напряжения питания и мощности потребления преобразователя '+modifStr+' : НЕ НОРМА ');
      SaveResultToFile('Автоматическая проверка напряжения постоянного тока на выходе преобразователя '+modifStr+' : НЕ НОРМА ');
      testTU_3_15Fin:=false;
  end;
//-------------------------------------------------------------------------------
//Проверка пункта 3.16.
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ СОБСТВЕННЫХ ШУМОВ НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЯ СОБСТВЕННЫХ ШУМОВ НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');
k:=1;
//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();
//if(sbrosFlag) then ShowMessage('Успешно')
//  else ShowMessage('Не Успешно');
if(testTU_3_16) then
  begin
    for i:=1 to 4 do
     begin
      for j:=1 to 8 do
         begin
          form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Коэфициент преобразования: '+intToStr(masKoeff[j])+' Напряжение на вольтметре: '+floatToStrF(masZn[k]*1000,ffFixed,4,3)+' мВ '+masS[k]);
          SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Коэфициент преобразования: '+intToStr(masKoeff[j])+' Напряжение на вольтметре: '+floatToStrF(masZn[k]*1000,ffFixed,4,3)+' мВ '+masS[k]);
          inc(k);
         end;
     form1.Memo1.Lines.Add('');
     SaveResultToFile('');
     end;
  form1.Memo1.Lines.Add('Автоматическая проверка напряжения собственных шумов на выходе преобразователя '+modifStr+' : НОРМА ');
  SaveResultToFile('Автоматическая проверка напряжения собственных шумов на выходе преобразователя '+modifStr+' : НОРМА ');
  testTU_3_16Fin:=true;
  end
else
  begin
  for i:=1 to 4 do
    begin
      for j:=1 to 8 do
         begin
          form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Коэфициент преобразования:'+intToStr(masKoeff[j])+' Напряжение на вольтметре:'+floatToStrF(masZn[k]*1000,ffFixed,4,3)+'мВ '+masS[k]);
          SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Коэфициент преобразования:'+intToStr(masKoeff[j])+' Напряжение на вольтметре: '+floatToStrF(masZn[k]*1000,ffFixed,4,3)+' мВ '+masS[k]);
          inc(k);
         end;
    form1.Memo1.Lines.Add('');
    SaveResultToFile('');
    end;
  form1.Memo1.Lines.Add('Автоматическая проверка напряжения собственных шумов на выходе преобразователя '+modifStr+' : НЕ НОРМА ');
  SaveResultToFile('Автоматическая проверка напряжения собственных шумов на выходе преобразователя '+modifStr+' : НЕ НОРМА ');
  testTU_3_16Fin:=false;
  end;

//-------------------------------------------------------------------------------

//Проверка пункта 3.17
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА МАКСИМАЛЬНОГО ЗНАЧЕНИЯ АМПЛИТУДЫ НАПРЯЖЕНИЯ ПЕРЕМЕННОГО ТОКА НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА МАКСИМАЛЬНОГО ЗНАЧЕНИЯ АМПЛИТУДЫ НАПРЯЖЕНИЯ ПЕРЕМЕННОГО ТОКА НА ВЫХОДЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');
//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();
if(testTU_3_17) then
  begin
    for i:=1 to 4 do
      begin
        form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Максимальное неискаженное напряжение на выходе:'+FloatToStrF(maxVoltMas[i],ffFixed,4,3)+' В'+' Cоответствие ТУ:'+trueMasStr[i]);
        SaveResultToFile('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Максимальное неискаженное напряжение на выходе:'+FloatToStrF(maxVoltMas[i],ffFixed,4,3)+'В'+' Cоответствие ТУ:'+trueMasStr[i]);
      end;
    form1.Memo1.Lines.Add('Автоматическая проверка максимального значения амплитуды напряжения переменного тока на выходе преобразователя '+modifStr+' : НОРМА ');
    SaveResultToFile('Автоматическая проверка максимального значения амплитуды напряжения переменного тока на выходе преобразователя '+modifStr+' : НОРМА ');
    testTU_3_17Fin:=true;
  end
else
  begin
    for i:=1 to 4 do
      begin
        form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Максимальное неискаженное напряжение на выходе:'+FloatToStrF(maxVoltMas[i],ffFixed,4,3)+' В'+' Cоответствие ТУ:'+trueMasStr[i]);
        SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Максимальное неискаженное напряжение на выходе:'+FloatToStrF(maxVoltMas[i],ffFixed,4,3)+' В'+' Cоответствие ТУ:'+trueMasStr[i]);
      end;
    form1.Memo1.Lines.Add('Автоматическая проверка максимального значения амплитуды напряжения переменного тока на выходе преобразователя '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile('Автоматическая проверка максимального значения амплитуды напряжения переменного тока на выходе преобразователя '+modifStr+' : НЕ НОРМА ');
    testTU_3_17Fin:=false;
  end;

//------------------------------------------------------------------------------
//Проверка пункта 3.18
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА КОЭФИЦИЕНТОВ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА КОЭФИЦИЕНТОВ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();
//процедура по вычислению коэфициентов усиления на 1-4 канале в соответствии с требованиями пункта 3.16.
testTU_3_18Fin:=testTU_3_18;
if(testTU_3_18Fin) then
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка коэфициентов преобразователя '+modifStr+' : НОРМА ');
    SaveResultToFile('Автоматическая проверка коэфициентов преобразователя '+modifStr+' : НОРМА ');
  end
else
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка коэфициентов преобразователя '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile('Автоматическая проверка коэфициентов преобразователя '+modifStr+' : НЕ НОРМА ');
  end;

//------------------------------------------------------------------------------
//Проверка пункта 3.19
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НЕРАВНОМЕРНОСТИ АМПЛИТУДНО-ЧАСТОТНОЙ ХАРАКТЕРИСТИКИ В ДИАПАЗОНЕ РАБОЧИХ ЧАСТОТ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА НЕРАВНОМЕРНОСТИ АМПЛИТУДНО-ЧАСТОТНОЙ ХАРАКТЕРИСТИКИ В ДИАПАЗОНЕ РАБОЧИХ ЧАСТОТ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();
//if(sbrosFlag) then ShowMessage('Успешно')
//  else ShowMessage('Не Успешно');

if(testTU_3_19) then
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка неравномерности АЧХ прибора '+modifStr+' : НОРМА ');
    SaveResultToFile('Автоматическая проверка неравномерности АЧХ прибора '+modifStr+' : НОРМА ');
    testTU_3_19Fin:=true;
  end
else
  begin
    form1.Memo1.Lines.Add('Автоматическая проверка неравномерности АЧХ прибора '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile('Автоматическая проверка неравномерности АЧХ прибора '+modifStr+' : НЕ НОРМА ');
    testTU_3_19Fin:=false;
  end;
 
//------------------------------------------------------------------------------
//Проверка пункта 3.20
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА КОЭФФИЦИЕНТА ЗАТУХАНИЯ АМПЛИТУДНО-ЧАСТОТНОЙ ХАРАКТЕРИСТИКИ НА ОКТАВНОЙ ЧАСТОТЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА КОЭФФИЦИЕНТА ЗАТУХАНИЯ АМПЛИТУДНО-ЧАСТОТНОЙ ХАРАКТЕРИСТИКИ НА ОКТАВНОЙ ЧАСТОТЕ ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();

k:=1;
if(testTU_3_20) then
  begin

    //канал
    for i:=1 to 4 do
      begin
        //частота среза
        for j:=1 to 4 do
          begin
            //Определяем для вывода режим частоты среза
            case (j) of
              1:strFor3_20:='DF1';
              2:strFor3_20:='DF2';
              3:strFor3_20:='DF3';
              4:strFor3_20:='DF4';
            end;
            form1.Memo1.Lines.Add('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Частота среза:'+strFor3_20+' Напряжение на выходе:'+FloatToStrF(mRez[k]*1000,ffFixed,4,3)+' мВ'+' Cоответствие ТУ:'+mStr[k]);
            SaveResultToFile('Модификация устройства:'+modifStr+' Номер канала:'+intToStr(i)+' Частота среза:'+strFor3_20+' Напряжение на выходе:'+FloatToStrF(mRez[k]*1000,ffFixed,4,3)+' мВ'+' Cоответствие ТУ:'+mStr[k]);
            inc(k);
          end
      end;
    form1.Memo1.Lines.Add('Автоматическая проверка коэффициента затухания амплитудно-частотной характеристики на октавной частоте преобразователя '+modifStr+' : НОРМА ');
    SaveResultToFile('Автоматическая проверка коэффициента затухания амплитудно-частотной характеристики на октавной частоте преобразователя '+modifStr+' : НОРМА ');
    testTU_3_20Fin:=true;

  end
else
  begin

    for i:=1 to 4 do
      begin
        for j:=1 to 4 do
        begin
         //Определяем для вывода режим частоты среза
          case (j) of
          1:strFor3_20:='DF1';
          2:strFor3_20:='DF2';
          3:strFor3_20:='DF3';
          4:strFor3_20:='DF4';
          end;
         form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Частота среза:'+strFor3_20+' Напряжение на выходе:'+FloatToStrF(mRez[k]*1000,ffFixed,4,3)+' мВ'+' Cоответствие ТУ:'+mStr[k]);
         SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала:'+intToStr(i)+' Частота среза:'+strFor3_20+' Напряжение на выходе:'+FloatToStrF(mRez[k]*1000,ffFixed,4,3)+' мВ'+' Cоответствие ТУ:'+mStr[k]);
         inc(k);
        end
      end;
    form1.Memo1.Lines.Add('Автоматическая проверка коэффициента затухания амплитудно-частотной характеристики на октавной частоте преобразователя '+modifStr+' : НЕ НОРМА ');
    SaveResultToFile('Автоматическая проверка коэффициента затухания амплитудно-частотной характеристики на октавной частоте преобразователя '+modifStr+' : НЕ НОРМА ');
    testTU_3_20Fin:=false;
  end;



//------------------------------------------------------------------------------
//Проверка пункта 3.20а
//form1.Memo1.Lines.Add('');
//SaveResultToFile('');
//form1.Memo1.Lines.Add(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЙ ПИТАНИЯ СОГЛАСУЮЩИХ УСТРОЙСТВ ДАТЧИКОВ(СУ) ФОРМИРУЕМЫХ ПРЕОБРАЗОВАТЕЛЯМИ ');
//SaveResultToFile(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА НАПРЯЖЕНИЙ ПИТАНИЯ СОГЛАСУЮЩИХ УСТРОЙСТВ ДАТЧИКОВ(СУ) ФОРМИРУЕМЫХ ПРЕОБРАЗОВАТЕЛЯМИ ');
//form1.Memo1.Lines.Add('');
//SaveResultToFile('');
{
if(testTU_3_20а) then
  begin

  end
else
  begin

  end;

}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//Проверка пункта 3.21
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА СИГНАЛА ПРОВЕРКИ ФУНКЦИОНИРОВАНИЯ '+modifStr);
SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА СИГНАЛА ПРОВЕРКИ ФУНКЦИОНИРОВАНИЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();

testTU_3_21;
if((flagTest21FCh1)and(flagTest21FCh2)and(flagTest21FCh3)and(flagTest21FCh4)) then testTU_3_21Fin:=true
  else testTU_3_21Fin:=false;


if(testTU_3_21Fin) then
  begin
   form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+ 'Cоответствие ТУ пункт 3.21: НОРМА');
   SaveResultToFile('Модификация устройства: '+modifStr+ 'Cоответствие ТУ пункт 3.21: НОРМА');
   //закрываем данный файл для того, чтобы дописать все данные в него.
   //FileClose(FileHandle);
  // form1.Memo1.Lines.Add('АЦП E20-10 инициализирован, логи записаны, данные записаны в файл .dat: ОШИБОК НЕТ');
  end
else
  begin
  form1.Memo1.Lines.Add(' Модификация устройства: '+modifStr+ 'Cоответствие ТУ пункт 3.21: НЕ НОРМА');
   SaveResultToFile(' Модификация устройства: '+modifStr+ 'Cоответствие ТУ пункт 3.21: НЕ НОРМА');
  //закрываем данный файл для того, чтобы дописать все данные в него.
  //FileClose(FileHandle);
  // form1.Memo1.Lines.Add('АЦП E20-10: ОБНАРУЖЕНЫ ОШИБКИ В РАБОТЕ');
  end;



//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//Проверка пункта 3.22
form1.Memo1.Lines.Add('');
SaveResultToFile('');
form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
SaveResultToFile(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr);
form1.Memo1.Lines.Add('');
SaveResultToFile('');

//размыкаем на ИСД каналы к 1 по 64, для того чтобы
sbrosFlag:=DecommutateAllChannels();

if(testTU_3_22) then
  begin
    for i:=1 to 4 do
      begin
       form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала: '+intToStr(i)+' Действующеее значение: '+FloatToStr(MasDVolume[i])+'мВ'+' Cоответствие ТУ: '+StrDigMas[i]);
       SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала: '+intToStr(i)+' Действующее значение: '+FloatToStr(MasDVolume[i])+'мВ'+' Cоответствие ТУ: '+StrDigMas[i]);
      end;
  form1.Memo1.Lines.Add('Автоматическая проверка преобразователя '+modifStr+' : НОРМА ');
  SaveResultToFile('Автоматическая проверка преобразователя '+modifStr+' : НОРМА ');
  testTU_3_22Fin:=true;
  end
else
  begin
    for i:=1 to 4 do
      begin
       form1.Memo1.Lines.Add('Модификация устройства: '+modifStr+' Номер канала: '+intToStr(i)+' Действующеее значение: '+FloatToStr(MasDVolume[i])+'мВ'+' Cоответствие ТУ: '+StrDigMas[i]);
       SaveResultToFile('Модификация устройства: '+modifStr+' Номер канала: '+intToStr(i)+' Действующее значение: '+FloatToStr(MasDVolume[i])+'мВ'+' Cоответствие ТУ: '+StrDigMas[i]);
      end;
  form1.Memo1.Lines.Add('Автоматическая проверка преобразователя '+modifStr+' :НЕ НОРМА ');
  SaveResultToFile('Автоматическая проверка преобразователя '+modifStr+' :НЕ НОРМА ');
  testTU_3_22Fin:=false;
  end;
//------------------------------------------------------------------------------
//общий результат Автоматической проверки УЦФ
if((testTU_3_13Fin)and(testTU_3_15Fin)and(testTU_3_16Fin)and(testTU_3_17Fin)and(testTU_3_18Fin)and(testTU_3_19Fin)and(testTU_3_20Fin)and(testTU_3_21Fin)and(testTU_3_22Fin)) then
  begin
    form1.Memo1.Lines.Add('АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr+' В СООТВЕТСТВИИ С БЫ2.032.054 ТУ:НОРМА ');
    SaveResultToFile('АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr+' В СООТВЕТСТВИИ С БЫ2.032.054 ТУ:НОРМА ');
  end
else
  begin
    form1.Memo1.Lines.Add(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr+' В СООТВЕТСТВИИ С БЫ2.032.054 ТУ:НЕ НОРМА ');
    SaveResultToFile(' АВТОМАТИЧЕСКАЯ ПРОВЕРКА ПРЕОБРАЗОВАТЕЛЯ '+modifStr+' В СООТВЕТСТВИИ С БЫ2.032.054 ТУ:НЕ НОРМА ');
  end;
//------------------------------------------------------------------------------
//Автоматическая проверка закончена, все элементы доступны
AllEnable;
form1.ComboBox5.Enabled:=true;
form1.Button2.Enabled:=true;
//------------------------------------------------------------------------------

end;



procedure TForm1.Edit1Click(Sender: TObject);
begin
 form1.Button1.Enabled:=true;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
idUDPServer1.Active:=false;
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
var
kl:integer;
begin
indexByte:=ShowDigitalChannel();
//поменяли канал, обнулили все данные в массиве masDigitalZnachBuf
for kl:=1 to 10000 do masDigitalZnachBuf[kl]:=0;
//счетчик для занесения значений в мВ в массив.
kMasDig:=1;
end;

procedure TForm1.RadioButton6Click(Sender: TObject);
var
kl:integer;
begin
indexByte:=ShowDigitalChannel();
//поменяли канал, обнулили все данные в массиве masDigitalZnachBuf
for kl:=1 to 10000 do masDigitalZnachBuf[kl]:=0;
//счетчик для занесения значений в мВ в массив.
kMasDig:=1;
end;

procedure TForm1.RadioButton7Click(Sender: TObject);
var
kl:integer;
begin
indexByte:=ShowDigitalChannel();
//поменяли канал, обнулили все данные в массиве masDigitalZnachBuf
for kl:=1 to 10000 do masDigitalZnachBuf[kl]:=0;
//счетчик для занесения значений в мВ в массив.
kMasDig:=1;
end;

procedure TForm1.RadioButton8Click(Sender: TObject);
var
kl:integer;
begin
indexByte:=ShowDigitalChannel();
//поменяли канал, обнулили все данные в массиве masDigitalZnachBuf
for kl:=1 to 10000 do masDigitalZnachBuf[kl]:=0;
//счетчик для занесения значений в мВ в массив.
kMasDig:=1;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
form1.show;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
form2.Show;
end;

end.
