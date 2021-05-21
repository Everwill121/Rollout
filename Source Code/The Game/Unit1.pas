unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, jpeg, MPlayer, StdCtrls, inifiles, strutils;

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
    Label12: TLabel;
    Panel3: TPanel;
    Image5: TImage;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Panel4: TPanel;
    Image6: TImage;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Panel5: TPanel;
    Image7: TImage;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label29: TLabel;
    Panel6: TPanel;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Timer2: TTimer;
    Image11: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label5Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label25Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure Label15Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label17Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label30Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  sw, sh: integer;
  res: string;
  i, f, phase: integer;
  check: boolean;
  records: array [1..5,1..2] of string;
  lft, right, up, down, fire, sound: integer;
  players: array [1..5] of string;
  levels: array [1..5] of integer;
  scores: array [1..5] of integer;
  curpl: integer;
  ff: tinifile;
  lab: array [1..20, 1..200] of integer;
  x, y: integer;
  csize: integer;       //размер ячейки
  curline: integer;
  dir: integer;         //direction: 0-up, 3-right, 6-down, 9-left
  bombs: integer;

implementation

{$R *.dfm}

function rnd(percents: integer): boolean;
var
 r: integer;
 s: string;
begin
// randomize;
 r:=random(100);
// showmessage(inttostr(r));
 if r<=percents then result:=true else result:=false;
end;

procedure FillLab(level: integer);
begin
 for x:=1 to 20 do for y:=1 to 200 do lab[x,y]:=0;
 for y:=11 to 190 do
  begin
   lab[1,y]:=1;
   lab[2,y]:=1;
   lab[19,y]:=1;
   lab[20,y]:=1;
  end;

 for x:=3 to 10 do if rnd(50) then
  begin
   lab[x,11]:=1;
   lab[21-x,11]:=1;
  end
  else
  begin
   lab[x,11]:=0;
   lab[21-x,11]:=0;
  end;

 for y:=12 to 190 do
  begin
   for x:=3 to 10 do
    begin
     i:=0;
     if lab[x-2,y]=1 then i:=i+16;         //a
     if lab[x-1,y]=1 then i:=i+8;          //b
     if lab[x-1,y-1]=1 then i:=i+4;        //c
     if lab[x,y-1]=1 then i:=i+2;          //d
     if lab[x+1,y-1]=1 then i:=i+1;        //e
     case i of
      0,1,2,8,9,10,11,16,17,18,26:
      begin
       lab[x,y]:=1;
       lab[21-x,y]:=1;
      end;
      3,6,7,12,19,24,27,28:
      begin
       if rnd(50) then
        begin
         lab[x,y]:=1;
         lab[21-x,y]:=1;
        end;
      end;
     end;

     if (lab[x,y]+lab[x,y-1]+lab[x,y-2]+lab[x,y-3]+lab[x,y-4]+lab[x,y-5]=0) and rnd((level-1)*10) then
      begin
         lab[x,y]:=1;
         lab[21-x,y]:=1;
      end;

  end;
 end;
end;

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
 form1.Label12.Font.Size:=sw div 68;
 form1.Panel1.Color:=clblack;
 form1.panel1.Visible:=true;
 phase:=3;
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

procedure gameplay;
begin
 form1.timer2.enabled:=true;
end;

procedure preparegameplay;
begin
// Set English Keyboard
 LoadKeyboardLayout('00000409', KLF_ACTIVATE);
 phase:=4;
 form1.panel5.width:=sw div 4;
 form1.panel5.height:=sh div 2;
 form1.panel5.left:=sw - form1.panel1.width;
 form1.panel5.top:=sh div 2;
 form1.Label26.Font.Size:=sw div 68;
 form1.Label27.Font.Size:=sw div 68;
 form1.Label28.Font.Size:=sw div 68;
 form1.Label29.Font.Size:=sw div 68;
 form1.Label30.Font.Size:=sw div 68;
 form1.Panel2.Color:=clblack;

 form1.Label26.Caption:=players[curpl];
 form1.Label27.Caption:='уровень: '+inttostr(levels[curpl]);
 form1.Label28.Caption:='очки: '+inttostr(scores[curpl]);
 bombs:=5;
 form1.Label29.Caption:='снаряды: '+inttostr(bombs);

 form1.panel5.visible:=true;
 form1.panel3.visible:=false;
 form1.panel1.visible:=false;

 FillLab(levels[curpl]);
 form1.Panel6.Width:=sw div 2;
 form1.Panel6.Height:=sw div 2;
 form1.Panel6.Top:=(sh - sw div 2) div 2;
 form1.Panel6.Left:=sw div 4;

 curline:=0;
 csize:=form1.Panel6.Width div 20;
 form1.Image8.Width:=sw div 2;
 form1.Image8.Height:=csize*200;
 form1.Image8.Left:=0;
 form1.Image8.Top:=-180*csize+curline;

 form1.image9.Width:=csize;
 form1.image9.Height:=csize;
 form1.image10.Width:=csize;
 form1.image10.Height:=csize;
 form1.image11.Width:=csize;
 form1.image11.Height:=csize;
 form1.image9.Picture.LoadFromFile('media\wall.bmp');
 form1.image10.Picture.LoadFromFile('media\floor.bmp');
 form1.image11.Picture.LoadFromFile('media\ball.bmp');

 for x:=1 to 20 do for y:=1 to 200 do
  begin
//  if lab[x,y]=0 then form1.image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,csize,csize))
//                else form1.image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image9.Picture.Bitmap.Canvas,rect(0,0,csize,csize));
  if lab[x,y]=0 then form1.image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height))
                else form1.image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image9.Picture.Bitmap.Canvas,rect(0,0,form1.image9.Picture.Bitmap.Width,form1.image9.Picture.Bitmap.height));
  end;

 x:=10;
 y:=195;
 form1.image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));

 form1.Panel6.Visible:=true;
 gameplay;
end;

procedure LevelFailed;
begin
 phase:=5;
 form1.Timer2.Enabled:=false;
 form1.label12.Caption:='Уровень провален. Повторить? (Y/N)';
 form1.label12.Left:=sw div 2 - form1.label12.Width div 2;
 form1.label12.Top:=sh div 2 - 100;
 form1.label12.Visible:=true;
 form1.panel5.Visible:=false;
 form1.panel6.Visible:=false;
end;

procedure LevelComplete;
begin
 phase:=6;
 form1.Timer2.Enabled:=false;
 levels[curpl]:=levels[curpl]+1;
 scores[curpl]:=scores[curpl]+1000-(5-bombs)*100;
 form1.label12.Caption:='Уровень пройден. Перейти на следующий? (Y/N)';
 form1.label12.Left:=sw div 2 - form1.label12.Width div 2;
 form1.label12.Top:=sh div 2 - 100;
 form1.label12.Visible:=true;
 form1.panel5.Visible:=false;
 form1.panel6.Visible:=false;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 ff:=tinifile.create(extractfilepath(application.exename)+'rollout.ini');
 for i:=1 to 5 do
  begin
   records[i,1]:=ff.ReadString('recordplayers', 'player'+inttostr(i), 'none');
   records[i,2]:=ff.ReadString('records', 'record'+inttostr(i), '0');
   players[i]:=ff.ReadString('players', 'curpl'+inttostr(i), 'none');
   levels[i]:=ff.ReadInteger('levels', 'curlev'+inttostr(i), 1);
   scores[i]:=ff.ReadInteger('scores', 'cursc'+inttostr(i), 1);
  end;

// Set English Keyboard
 LoadKeyboardLayout('00000409', KLF_ACTIVATE);

 up:=ff.ReadInteger('settings', 'up', 119);
 down:=ff.ReadInteger('settings', 'down', 115);
 lft:=ff.ReadInteger('settings', 'left', 97);
 right:=ff.ReadInteger('settings', 'right', 100);
 fire:=ff.ReadInteger('settings', 'fire', 32);
 sound:=ff.ReadInteger('settings', 'sound', 122);

 curpl:=0;

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

 label12.Font.Name:='hellenica';

 label13.Font.Name:='hellenica';
 label14.Font.Name:='hellenica';
 label15.Font.Name:='hellenica';
 label16.Font.Name:='hellenica';
 label17.Font.Name:='hellenica';
 label18.Font.Name:='hellenica';

 label19.Font.Name:='hellenica';
 label20.Font.Name:='hellenica';
 label21.Font.Name:='hellenica';
 label22.Font.Name:='hellenica';
 label23.Font.Name:='hellenica';
 label24.Font.Name:='hellenica';
 label25.Font.Name:='hellenica';

 label26.Font.Name:='hellenica';
 label27.Font.Name:='hellenica';
 label28.Font.Name:='hellenica';
 label29.Font.Name:='hellenica';
 label30.Font.Name:='hellenica';

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

 if res='16_9' then image5.Picture.LoadFromFile('media\menu16_9piece.jpg') else image5.Picture.LoadFromFile('media\menu4_3piece.jpg');
 image5.Align:=alclient;

 if res='16_9' then image6.Picture.LoadFromFile('media\menu16_9piece.jpg') else image6.Picture.LoadFromFile('media\menu4_3piece.jpg');
 image6.Align:=alclient;

 if res='16_9' then image7.Picture.LoadFromFile('media\menu16_9piece.jpg') else image7.Picture.LoadFromFile('media\menu4_3piece.jpg');
 image7.Align:=alclient;

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
 if (ord(key)=sound) and (label12.Visible=false) then mediaplayer1.Pause;

 if phase=1 then
 begin
  splash;
 end;

 if phase=3 then
 begin
  if label12.Visible=true then
  begin
   if ord(Key)=27 then
    begin
     label12.Visible:=false;
     panel1.Visible:=true;
    end;
   if ord(Key)>32 then
    begin
     if length(label12.Caption)<35 then label12.Caption:=label12.Caption+key;
    end;
   if ord(Key)=8 then
    begin
     if length(label12.Caption)>27 then label12.Caption:=leftstr(label12.Caption, length(label12.Caption)-1);
    end;
   if ord(Key)=13 then
    begin
     if length(label12.Caption)>27 then
     begin
      i:=1;
      while players[i]<>'none' do i:=i+1;
      curpl:=i;
      players[i]:=rightstr(label12.Caption, length(label12.Caption)-27);
      label12.Visible:=false;
      preparegameplay;
     end
    end;
  end
  else
  begin
   if (ord(Key)=27) and (panel1.Visible=true) then
    begin
     form1.Close;
    end;
  end;
 end;

 if phase=4 then
 begin
  if label12.Visible=false then
  begin
   if ord(Key)=27 then
   begin
    label12.Caption:='Выйти из уровня? (Y/N)';
    label12.Left:=sw div 2 - label12.Width div 2;
    label12.Top:=sh div 2 - 100;
    label12.Visible:=true;
    panel5.Visible:=false;
    panel6.Visible:=false;
///---------------------Pause gameplay-----------------------
    timer2.Enabled:=false;
   end;
   // up
   if ord(Key)=up then
   begin
    dir:=0;
    if (curline div csize - 1 > 180 - y) and (lab[x,y-1]=0) then
     begin
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
      y:=y-1;
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));
     end;
   end;
   // down
   if ord(Key)=down then
   begin
    dir:=6;
    if (curline div csize + 1 < 200 - y) and (lab[x,y+1]=0) then
     begin
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
      y:=y+1;
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));
     end;
   end;
   // left
   if ord(Key)=lft then
   begin
    dir:=9;
    if (x>1) and (lab[x-1,y]=0) then
     begin
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
      x:=x-1;
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));
     end;
   end;
   // right
   if ord(Key)=right then
   begin
    dir:=3;
    if (x<20) and (lab[x+1,y]=0) then
     begin
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
      x:=x+1;
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));
     end;
   end;
   // fire
   if ord(Key)=fire then
   begin
    if bombs>0 then
     begin
      case dir of
      0: begin
       if (curline div csize - 1 > 180 - y) and (lab[x,y-1]=1) then
        begin
         lab[x,y-1]:=0;
         bombs:=bombs-1;
         form1.Label29.Caption:='снаряды: '+inttostr(bombs);
         image8.Canvas.CopyRect(rect((x-1)*csize,(y-2)*csize,x*csize,(y-1)*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
        end;
      end;
      6: begin
       if (curline div csize + 1 < 200 - y) and (lab[x,y+1]=1) then
        begin
         lab[x,y+1]:=0;
         bombs:=bombs-1;
         form1.Label29.Caption:='снаряды: '+inttostr(bombs);
        image8.Canvas.CopyRect(rect((x-1)*csize,y*csize,x*csize,(y+1)*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
        end;
      end;
      9: begin
       if (x>2) and (lab[x-1,y]=1) then
        begin
         lab[x-1,y]:=0;
         bombs:=bombs-1;
         form1.Label29.Caption:='снаряды: '+inttostr(bombs);
         image8.Canvas.CopyRect(rect((x-2)*csize,(y-1)*csize,(x-1)*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
        end;
      end;
      3: begin
       if (x<19) and (lab[x+1,y]=1) then
        begin
         lab[x+1,y]:=0;
         bombs:=bombs-1;
         form1.Label29.Caption:='снаряды: '+inttostr(bombs);
         image8.Canvas.CopyRect(rect(x*csize,(y-1)*csize,(x+1)*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
        end;
      end;
      end;
     end;

   end;
  end
  else
  begin
   if ord(Key)=121 then
   begin
///---------------------Stop gameplay------------------------
    phase:=3;
    label12.Visible:=false;
    panel1.Visible:=true;
    panel5.Visible:=false;
   end;
   if ord(Key)=110 then
   begin
    label12.Visible:=false;
    panel5.Visible:=true;
    panel6.Visible:=true;
///-------------------Continue gameplay----------------------
    timer2.Enabled:=true;
   end;
  end;
  if y<11 then LevelComplete;
 end;

 if phase=5 then
  begin
   if ord(Key)=121 then
   begin
    label12.Visible:=false;
    preparegameplay;
   end;
   if ord(Key)=110 then
   begin
    phase:=3;
    label12.Visible:=false;
    panel1.Visible:=true;
    panel5.Visible:=false;
   end;
  end;

 if phase=6 then
  begin
   if ord(Key)=121 then
   begin
    label12.Visible:=false;
    preparegameplay;
   end;
   if ord(Key)=110 then
   begin
    phase:=3;
    label12.Visible:=false;
    panel1.Visible:=true;
    panel5.Visible:=false;
   end;
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

 for i:=1 to 5 do
 begin
  ff.WriteString('recordplayers', 'player'+inttostr(i), records[i,1]);
  ff.WriteString('records', 'record'+inttostr(i), records[i,2]);
  ff.WriteString('players', 'curpl'+inttostr(i), players[i]);
  ff.WriteInteger('levels', 'curlev'+inttostr(i), levels[i]);
  ff.WriteInteger('scores', 'cursc'+inttostr(i), scores[i]);
 end;

 ff.WriteInteger('settings', 'up', up);
 ff.WriteInteger('settings', 'down', down);
 ff.WriteInteger('settings', 'left', lft);
 ff.WriteInteger('settings', 'right', right);
 ff.WriteInteger('settings', 'fire', fire);
 ff.WriteInteger('settings', 'sound', sound);
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

procedure TForm1.Label18Click(Sender: TObject);
begin
 form1.panel1.Visible:=true;
 form1.panel3.Visible:=false;
end;

procedure TForm1.Label4Click(Sender: TObject);
begin
 form1.panel4.width:=sw div 4;
 form1.panel4.height:=sh div 2;
 form1.panel4.left:=sw - form1.panel1.width;
 form1.panel4.top:=sh div 2;
 form1.Label19.Font.Size:=sw div 68;
 form1.Label20.Font.Size:=sw div 68;
 form1.Label21.Font.Size:=sw div 68;
 form1.Label22.Font.Size:=sw div 68;
 form1.Label23.Font.Size:=sw div 68;
 form1.Label24.Font.Size:=sw div 68;
 form1.Label25.Font.Size:=sw div 68;
 form1.Panel4.Color:=clblack;
 form1.Label19.Caption:='вверх  ... "'+chr(up)+'"';
 form1.Label20.Caption:='вниз ... "'+chr(down)+'"';
 form1.Label21.Caption:='влево ... "'+chr(lft)+'"';
 form1.Label22.Caption:='вправо ... "'+chr(right)+'"';
 form1.Label23.Caption:='огонь ... "'+chr(fire)+'"';
 form1.Label24.Caption:='звук ... "'+chr(sound)+'"';


 form1.panel4.Visible:=true;
 form1.panel1.Visible:=false;
end;

procedure TForm1.Label2Click(Sender: TObject);
begin
 form1.panel3.width:=sw div 4;
 form1.panel3.height:=sh div 2;
 form1.panel3.left:=sw - form1.panel1.width;
 form1.panel3.top:=sh div 2;
 form1.Label13.Font.Size:=sw div 68;
 form1.Label14.Font.Size:=sw div 68;
 form1.Label15.Font.Size:=sw div 68;
 form1.Label16.Font.Size:=sw div 68;
 form1.Label17.Font.Size:=sw div 68;
 form1.Label18.Font.Size:=sw div 68;
 form1.Panel3.Color:=clblack;
 form1.Label13.Caption:=players[1];
 form1.Label14.Caption:=players[2];
 form1.Label15.Caption:=players[3];
 form1.Label16.Caption:=players[4];
 form1.Label17.Caption:=players[5];
 if players[1]<>'none' then form1.Label13.visible:=true else form1.Label13.visible:=false;
 if players[2]<>'none' then form1.Label14.visible:=true else form1.Label14.visible:=false;
 if players[3]<>'none' then form1.Label15.visible:=true else form1.Label15.visible:=false;
 if players[4]<>'none' then form1.Label16.visible:=true else form1.Label16.visible:=false;
 if players[5]<>'none' then form1.Label17.visible:=true else form1.Label17.visible:=false;

 form1.panel3.Visible:=true;
 form1.panel1.Visible:=false;
end;

procedure TForm1.Label25Click(Sender: TObject);
begin
 form1.panel1.Visible:=true;
 form1.panel4.Visible:=false;
end;

procedure TForm1.Label13Click(Sender: TObject);
begin
 curpl:=1;
 preparegameplay;
end;

procedure TForm1.Label14Click(Sender: TObject);
begin
 curpl:=2;
 preparegameplay;
end;

procedure TForm1.Label15Click(Sender: TObject);
begin
 curpl:=3;
 preparegameplay;
end;

procedure TForm1.Label16Click(Sender: TObject);
begin
 curpl:=4;
 preparegameplay;
end;

procedure TForm1.Label17Click(Sender: TObject);
begin
 curpl:=5;
 preparegameplay;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
 if players[5]='none' then
 begin
  label12.Caption:='введите имя нового игрока: ';
  label12.Left:=sw div 2 - label12.Width div 2 - 125;
  label12.Top:=sh div 2 - 100;
  label12.Visible:=true;
  panel1.Visible:=false;
 end;
end;

procedure TForm1.Label30Click(Sender: TObject);
begin
 label12.Caption:='Выйти из уровня? (Y/N)';
 label12.Left:=sw div 2 - label12.Width div 2;
 label12.Top:=sh div 2 - 100;
 label12.Visible:=true;
 panel5.Visible:=false;
 panel6.Visible:=false;
///---------------------Pause gameplay-----------------------
 timer2.Enabled:=false;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
 if form1.Image8.Top<0 then
  begin
   curline:=curline+1;
   form1.Image8.Top:=-180*csize+curline;
   if curline div csize = 200 - y then
    begin
    dir:=0;
    if lab[x,y-1]=0 then
     begin
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image10.Picture.Bitmap.Canvas,rect(0,0,form1.image10.Picture.Bitmap.Width,form1.image10.Picture.Bitmap.height));
      y:=y-1;
      image8.Canvas.CopyRect(rect((x-1)*csize,(y-1)*csize,x*csize,y*csize),form1.image11.Picture.Bitmap.Canvas,rect(0,0,form1.image11.Picture.Bitmap.Width,form1.image11.Picture.Bitmap.height));
     end
     else
     begin
      LevelFailed;
     end;
    end;
  end;
end;

procedure TForm1.MediaPlayer1Notify(Sender: TObject);
begin
with MediaPlayer1 do
  if NotifyValue=nvSuccessful then
    begin
    Notify:=True;
    Play;
    end;
end;

end.
