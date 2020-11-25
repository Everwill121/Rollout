unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  lab: array [1..20, 1..200] of integer;
  x, y, i: integer;

implementation

{$R *.dfm}

function rnd(percents: integer): boolean;
var
 r: integer;
begin
 r:=random(100);
 if r <= percents then result := true else result := false;
end;

procedure filllab(level: integer);
begin
 for x:=1 to 20 do for y:=1 to 200 do lab[x, y]:=0;
 for y:=11 to 190 do
  begin
   lab[1, y]:=1;
   lab[2, y]:=1;
   lab[19, y]:=1;
   lab[20, y]:=1;
  end;

  for x:=3 to 10 do if rnd(50) then
   begin
    lab[x, 11]:=1;
    lab[21-x, 11]:=1;
   end;

  for y:=12 to 190 do
   begin
    for x:=3 to 10 do
     begin
      i:=0;
      if lab[x+1, y-1]=1 then i:=i+1;  //e
      if lab[x, y-1]=1 then i:=i+2;    //d
      if lab[x-1, y-1]=1 then i:=i+4;  //c
      if lab[x-1, y]=1 then i:=i+8;    //b
      if lab[x-2, y]=1 then i:=i+16;   //a
      case i of
       0, 1, 2, 8, 9, 10, 11, 16, 17, 18, 26:
        begin
         lab[x, y]:=1;
         lab[21-x, y]:=1;
        end;
       3, 6, 7, 12, 19, 24, 27, 28:
        begin
         if rnd(50) then
          begin
           lab[x, y]:=1;
           lab[21-x, y]:=1;
          end; 
        end;
      end;

      if (lab[x, y]+lab[x, y-1]+lab[x, y-2]+lab[x, y-3]+lab[x, y-4]+lab[x, y-5]=0) and (rnd((level-1)*10)) then
       begin
        lab[x, y]:=1;
        lab[21-x, y]:=1;
       end;

     end;
   end;
end;



procedure TForm1.Button1Click(Sender: TObject);
var
 s: string;
begin
 memo1.Text:='';

 filllab(strtoint(edit1.text));

 for y:=1 to 200 do
  begin
   s:='';
   for x:=1 to 20 do if lab[x, 201-y]=0 then s:=s+' ' else s:=s+'#';
   memo1.Lines.Add(s);
  end;
end;

end.
