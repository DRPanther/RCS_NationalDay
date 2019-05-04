program rcsnd;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, Strutils, crt, DateUtils
  { you can add units after this };

Const
  prog      = 'RCS National Day of ... ';
  ver       = '2.0.0.2';
  copywrite = '2019';
  red       = (#27'[1;31m');
  green     = (#27'[1;32m');
  yellow    = (#27'[1;33m');
  blue      = (#27'[1;34m');
  magenta   = (#27'[1;35m');
  cyan      = (#27'[1;36m');
  nocolor   = (#27'[0m');

Var
  ndin  : textfile;
  ndout : textfile;
  line  : string;
  year  : string;
  month : string;
  day   : string;

Procedure programend(status:integer);
begin
  halt(status);
end;

Function MonthNumberToWord(tempmonth:integer):string;
var
  z : string;
begin
  case tempmonth of
    1 : z:='Jan';
    2 : z:='Feb';
    3 : z:='Mar';
    4 : z:='Apr';
    5 : z:='May';
    6 : z:='Jun';
    7 : z:='Jul';
    8 : z:='Aug';
    9 : z:='Sep';
    10 : z:='Oct';
    11 : z:='Nov';
    12 : z:='Dec';
  else
    z:='No data found';
  end;
  result:=z;
end;

Procedure datecheck;
begin
  year:=(FormatDateTime('YYYY',(today)));
  month:=(FormatDateTime('M',(today)));
  day:=(FormatDateTime('D',(today)));
end;

Procedure startup;
begin
  line:='';
  year:='';
  month:='';
  day:='';
  datecheck;
  assignfile(ndin,'nd.'+month);
  assignfile(ndout,'rcsnd.rpt');
end;

Procedure header;
begin
  writeln(ndout,red);
  writeln(ndout,PadCenter('Today, '+day+' '+MonthNumberToWord(StrToInt(month))+' '+year+', is...',78));
  writeln(ndout);
  writeln(ndout,blue+PadCenter('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-',78));
  writeln(ndout,nocolor);
end;

Procedure footer;
begin
  writeln(ndout);
  writeln(ndout,blue+PadCenter('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-',78));
  writeln(ndout);
  writeln(ndout,red+PadCenter(prog+' '+ver+' (c)'+copywrite,78));
  writeln(ndout,nocolor+' ');
  writeln(ndout,nocolor+'<eof>');
  writeln(ndout,nocolor+' ');
end;

Procedure readndfile;
begin
  rewrite(ndout);
  {$I-}
  reset(ndin);
  {$I+}
  if IOResult<>0 then
  begin
    writeln('File nd.'+month+' could not be opened!');
    programend(1);
  end;
  repeat
    readln(ndin,line)
  until ((line) = (day));
  readln(ndin,line);
  header;
//  day:=IntToStr(StrToInt(day)+1);
  While not eof(ndin) do
  begin
    While not eof(ndin) do
    begin
      repeat
        writeln(ndout,(PadCenter(line,78)));
        readln(ndin,line);
        if line='' then exit;
      until (line='');
    end;
    break;
  end;
  //footer;
end;

Procedure wrapup;
begin
  CloseFile(ndin);
  CloseFile(ndout);
end;

{$R *.res}

begin
  startup;
  readndfile;
  footer;
  wrapup;
end.

