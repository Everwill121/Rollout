unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, MPlayer, StdCtrls, inifiles;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    MediaPlayer1: TMediaPlayer;
    Image2: TImage;
    Panel1: TPanel;
    Image3: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Image4: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sw, sh: integer;
  res: string;
  i, phase: integer;
  check: boolean;
  records: array [1..5,1..2] of string;
  left, right, up, down, fire, sound: integer;
  players: array [1..5] of string;
  curlevs: array [1..5] of integer;
  curscs: array [1..5] of integer;
  ff: tinifile;

implementation

{$R *.dfm}

procedure mainmenu;
begin
 form1.panel1.width:=sw div 4;
 form1.panel1.height:=sh div 2;
 form1.panel1.left:=sw - form1.panel1.width;
 form1.panel1.top:=sh div 2;
 form1.Label1.Font.Size:=sw div 68;
 form1.Label2.Font.Size:=sw div 68;
 form1.Label3.Font.Size:=sw div 68;
 form1.Label4.Font.Size:=sw div 68;
 form1.Label5.Font.Size:=sw div 68;
 form1.Panel1.Color:=clblack;
 form1.panel1.Visible:=true;
end;

procedure splash;
begin
 phase:=2;
 form1.image2.Left:=sw;
 form1.image2.width:=0;
 form1.image2.Height:=sh;
 form1.image2.Top:=0;
 form1.image2.Visible:=true;
 for i:=0 to 50 do
  begin
   form1.image2.width:=sw*i div 50;
   form1.image2.Left:=sw-sw*i div 50;
   form1.image1.width:=sw-sw*i div 50;
   form1.Repaint;
   sleep(10);
   application.ProcessMessages;
  end;
mainmenu;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
 ff:=tinifile.create(extractfilepath(application.exename)+'rollout.ini');
 for i:=1 to 5 do
  begin
   records[i,1]:=ff.ReadString('recordplayers', 'player'+inttostr(i), 'none');
   records[i,2]:=ff.ReadString('records', 'record'+inttostr(i), '0');
  end;

 addfontresource('media\hellenica.ttf');
 sendmessage(hwnd_broadcast, wm_fontchange, 0, 0);
 label1.Font.Name:='hellenica';
 label2.Font.Name:='hellenica';
 label3.Font.Name:='hellenica';
 label4.Font.Name:='hellenica';
 label5.Font.Name:='hellenica';
 label6.Font.Name:='hellenica';
 label7.Font.Name:='hellenica';
 label8.Font.Name:='hellenica';
 label9.Font.Name:='hellenica';
 label10.Font.Name:='hellenica';
 label11.Font.Name:='hellenica';

 form1.DoubleBuffered:=true;
 sw:=screen.width;
 sh:=screen.Height;
 form1.Color:=clblack;
 form1.Left:=0;
 form1.top:=0;
 form1.width:=sw;
 form1.height:=sh;

 i:=sw*100 div sh;
 if i=177 then res:='16_9' else res:='4_3';

 if res='16_9' then image1.Picture.LoadFromFile('media\splash16_9.jpg') else image1.Picture.LoadFromFile('media\splash4_3.jpg');
 if res='16_9' then image2.Picture.LoadFromFile('media\menu16_9.jpg') else image2.Picture.LoadFromFile('media\menu4_3.jpg');

 if res='16_9' then image3.Picture.LoadFromFile('media\menu16_9piece.jpg') else image3.Picture.LoadFromFile('media\menu4_3piece.jpg');
 image3.Align:=alclient;

 if res='16_9' then image4.Picture.LoadFromFile('media\menu16_9piece.jpg') else image4.Picture.LoadFromFile('media\menu4_3piece.jpg');
 image4.Align:=alclient;

 image1.Left:=0;
 image1.top:=0;
 image1.width:=sw;
 image1.height:=0;

 check:=false;

 mediaplayer1.FileName:='media\main theme.mp3';
 mediaplayer1.Open;
 mediaplayer1.Play;

 timer1.Enabled:=true;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 timer1.Enabled:=false;
 for i:=0 to 50 do
  begin
   image1.Height:=sh*i div 50;
   form1.Repaint;
   sleep(10);
   application.ProcessMessages;
  end;
 phase:=1;

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
 if phase=1 then
  begin
   splash;
  end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if phase=1 then
  begin
   splash;
  end;
end;


procedure TForm1.Label5Click(Sender: TObject);
begin
 form1.Close;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 removefontresource('media\hellenica.ttf');
 sendmessage(hwnd_broadcast, wm_fontchange, 0, 0);
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
 form1.panel2.width:=sw div 4;
 form1.panel2.height:=sh div 2;
 form1.panel2.left:=sw - form1.panel1.width;
 form1.panel2.top:=sh div 2;
 form1.Label6.Font.Size:=sw div 68;
 form1.Label7.Font.Size:=sw div 68;
 form1.Label8.Font.Size:=sw div 68;
 form1.Label9.Font.Size:=sw div 68;
 form1.Label10.Font.Size:=sw div 68;
 form1.Label11.Font.Size:=sw div 68;
 form1.Panel2.Color:=clblack;
 form1.Label6.Caption:=records[1,1]+' ... '+records[1,2];
 form1.Label7.Caption:=records[2,1]+' ... '+records[2,2];
 form1.Label8.Caption:=records[3,1]+' ... '+records[3,2];
 form1.Label9.Caption:=records[4,1]+' ... '+records[4,2];
 form1.Label10.Caption:=records[5,1]+' ... '+records[5,2];


 form1.panel2.Visible:=true;
 form1.panel1.Visible:=false;
end;

procedure TForm1.Label11Click(Sender: TObject);
begin
 form1.panel1.Visible:=true;
 form1.panel2.Visible:=false;
end;

end.
