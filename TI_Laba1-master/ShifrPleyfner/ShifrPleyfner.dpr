program ShifrPleyfner;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  slogi=array of array of char;
  tabl=array[0..4, 0..4] of char;
var
  stroka,kluch:string;
  WantToDo:integer;

//редактирование ключа для таблицы
function StringReadkt(redach:string):string;
var
  i,g,check,schetZamen:integer;
  strCash:string;
begin
  strCash:=redach;
  for g:=1 to length(strCash) do
  begin
    check:=0;
    for i:=1 to length(strCash) do
    begin
      if redach[g]=strCash[i] then
        inc(check);
      if check>=2 then
      begin
        schetZamen:=i;
        while schetZamen<=length(strCash) do
        begin
          strCash[schetZamen]:=strCash[schetZamen+1];
          inc(schetZamen);
        end;
        check:=0;
      end;

    end;
  end;
  result:=strcash;
end;

function TablGenerate(kluch:string):tabl;
var
  KluchMass:tabl;
  box:set of char;
  zapol,i,j,g:integer;
begin
  i:=0;
  j:=0;
  g:=1;
  zapol:=97;
  box:=[];
  kluch:=StringReadkt(kluch);
  while i<=4 do
  begin
    while j<=4 do
    begin
      if length(kluch)>=g then
      begin
        KluchMass[i][j]:=kluch[g];
        box:=box+[kluch[g]];
        inc(g);
      end
      else
      begin
        if not(chr(zapol) in box) then
        begin
          KluchMass[i][j]:=chr(zapol);
        end;
        if KluchMass[i][j]='' then
          dec(j);
        if zapol=105 then
          inc(zapol);
        inc(zapol);
      end;
      inc(j);
    end;
    inc(i);
    j:=0;
  end;
  result:=KluchMass;
end;

//шифрация
function Stukovka(KluchMass:tabl; strShifr:slogi):string;
var
  i,j,g:integer;
  tempi1,tempj1,tempi2,tempj2:integer;
  raznica:integer;
  res:string;
  checkDo:boolean;
begin
  tempi1:=0;
  tempj1:=0;
  tempi2:=0;
  tempj2:=0;
  checkDo:=false;
  res:='';
  for g:=0 to length(strShifr)-1 do
  begin
    for j:=0 to 4 do
      for i:=0 to 4 do
      begin
        if KluchMass[j][i]=strShifr[g][0] then
        begin
          tempi1:=i;
          tempj1:=j;
        end;
        if KluchMass[j][i]=strShifr[g][1] then
        begin
          tempi2:=i;
          tempj2:=j;
        end;
      end;
    if (tempj1=tempj2) and (checkDo=false) then
    begin
      inc(tempi1);
      inc(tempi2);
      if tempi1>4 then
        tempj1:=0;
      if tempi2>4 then
        tempj2:=0;
      checkDo:=true;
    end;
    if (tempi1>tempi2) and (checkDo=false) then
    begin
      raznica:=tempi1-tempi2;
      tempi1:=tempi1-raznica;
      tempi2:=tempi2+raznica;
      checkDo:=true;
    end;
    if (tempi1<tempi2) and (checkDo=false) then
    begin
      raznica:=tempi2-tempi1;
      tempi1:=tempi1+raznica;
      tempi2:=tempi2-raznica;
      checkDo:=true;
    end;
    if (tempi1=tempi2) and (checkDo=false) then
    begin
      inc(tempj1);
      inc(tempj2);
      if tempj1>4 then
        tempj1:=0;
      if tempj2>4 then
        tempj2:=0;
    end;
    res:=res+KluchMass[tempj1][tempi1]+KluchMass[tempj2][tempi2];
    checkDo:=false;
  end;
  result:=res;
end;

//разбиение слова на массив чаров
function Shifratiya(kluch:string;var stroka:string):string;
var
  strShifr:slogi;
  i,j,size:integer;
  itog:string;

  tabel:tabl;
begin
  size:=0;
  for i:=1 to length(stroka) do
    if stroka[i]='j' then
      stroka[i]:='i';

  for i:=1 to length(stroka) do
    if stroka[i]=stroka[i+1] then
      inc(size);

  if (length(stroka) mod 2)=0 then
    setlength(strShifr,length(stroka) div 2 +size,2)
  else
    setlength(strShifr,length(stroka) div 2 +size+1,2);

  i:=1;
  j:=0;
  while i<=length(stroka) do
  begin
    if stroka[i]=stroka[i+1] then
    begin
      strShifr[j][0]:=stroka[i];
      strShifr[j][1]:='x';
      if (stroka[i]='x') and (stroka[i+1]='x') then
      begin
        strShifr[j][0]:=stroka[i];
        strShifr[j][1]:='q';
      end;
      i:=i+1;
    end
    else
    begin
      strShifr[j][0]:=stroka[i];
      if i+1>length(stroka) then
        strShifr[j][1]:='x'
      else
        strShifr[j][1]:=stroka[i+1];
      i:=i+2;
    end;
    inc(j);
  end;

  tabel:=TablGenerate(kluch);
  itog:=Stukovka(tabel,StrShifr);

  result:=itog;
end;

function DeShifratiya(kluch:string; stroka:string):string;
var
  KluchMass:tabl;
  strShifr:slogi;

  i,j,g:integer;
  tempi1,tempj1,tempi2,tempj2:integer;
  raznica:integer;
  res:string;
  checkDo:boolean;
begin
  KluchMass:=TablGenerate(kluch);
  setlength(strShifr,length(stroka) div 2,2);

  i:=0;
  j:=1;
  while i<=((length(stroka) div 2)-1) do
  begin
    strShifr[i][0]:=stroka[j];
    strShifr[i][1]:=stroka[j+1];
    inc(i);
    j:=j+2;
  end;

  tempi1:=0;
  tempj1:=0;
  tempi2:=0;
  tempj2:=0;
  checkDo:=false;
  res:='';
  for g:=0 to length(strShifr)-1 do
  begin
    for j:=0 to 4 do
      for i:=0 to 4 do
      begin
        if KluchMass[j][i]=strShifr[g][0] then
        begin
          tempi1:=i;
          tempj1:=j;
        end;
        if KluchMass[j][i]=strShifr[g][1] then
        begin
          tempi2:=i;
          tempj2:=j;
        end;
      end;
    if (tempj1=tempj2) and (checkDo=false) then
    begin
      dec(tempi1);
      dec(tempi2);
      if tempi1<0 then
        tempj1:=4;
      if tempi2<0 then
        tempj2:=4;
      checkDo:=true;
    end;
    if (tempi1>tempi2) and (checkDo=false) then
    begin
      raznica:=tempi1-tempi2;
      tempi1:=tempi1-raznica;
      tempi2:=tempi2+raznica;
      checkDo:=true;
    end;
    if (tempi1<tempi2) and (checkDo=false) then
    begin
      raznica:=tempi2-tempi1;
      tempi1:=tempi1+raznica;
      tempi2:=tempi2-raznica;
      checkDo:=true;
    end;
    if (tempi1=tempi2) and (checkDo=false) then
    begin
      dec(tempj1);
      dec(tempj2);
      if tempj1<0 then
        tempj1:=4;
      if tempj2<0 then
        tempj2:=4;
    end;
    res:=res+KluchMass[tempj1][tempi1]+KluchMass[tempj2][tempi2];
    checkDo:=false;
  end;
  result:=res;
end;

begin
  WantToDo:=1;
  repeat
    writeln('Kluch:');
    readln(kluch);
    writeln;
    writeln('Slovo dlya shifra');
    readln(stroka);
    writeln;
    writeln('Chto sdelat?');
    writeln('1. shifrovat    2. deshifrovat    3.Exit');
    readln(WantToDo);
    if WantToDo=1 then
    begin
      stroka:=Shifratiya(kluch,stroka);
    end;
    if WantToDo=2 then
    begin
      stroka:=DeShifratiya(kluch,stroka);
    end;
    writeln;
  until WantToDo=3;
  writeln(stroka);

  readln
end.
 