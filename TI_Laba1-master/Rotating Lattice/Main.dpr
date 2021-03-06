program Main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GeneralCryptography in '..\GeneralCryptography.pas';

type
  TCell = record
    number: integer;
    hole: boolean;
    c: char;
  end;

  TMatrix = array of array of TCell;

var PlainText, CipherText: string;
    Key: TMatrix;
    max, min: integer;
    ExitFlag: boolean;
    switch: integer;

procedure RightMatrixRotate(var Matrix: TMatrix);
var i, j, n: integer;
    NNumbers: integer;
    s: set of 1..255;
begin

//  ??????????? ?????????? ?????????? ????? ? ???????
  n :=  Length(Matrix);
  if (n mod 2) = 0 then
  begin
    NNumbers := (n div 2) * (n div 2);
  end
  else
  begin
    NNumbers := (n div 2) * (n div 2 + 1) + 1;
  end;

//  ?????????? ?????????? ????? ?? ?????????
  s := [1..NNumbers];

//  ??????? ???????
  for i := Low(Matrix) to High(Matrix) do
    for j := Low(Matrix[i]) to High(Matrix[i]) do
    begin
      if (Matrix[i, j].hole = true) and (Matrix[i, j].number in s) then
      begin
        Matrix[i, j].hole := false;
        Matrix[j, Length(Matrix)-i - 1].hole := true;
        s := s - [Matrix[i, j].number];
      end;
    end;

end;

procedure LeftMatrixRotate(var Matrix: TMatrix);
var i, j, n: integer;
    NNumbers: integer;
    s: set of 1..255;
begin

//  ??????????? ?????????? ?????????? ????? ? ???????
  n :=  Length(Matrix);
  if (n mod 2) = 0 then
  begin
    NNumbers := (n div 2) * (n div 2);
  end
  else
  begin
    NNumbers := (n div 2) * (n div 2 + 1) + 1;
  end;

//  ?????????? ?????????? ????? ?? ?????????
  s := [1..NNumbers];

//  ??????? ???????
  for i := Low(Matrix) to High(Matrix) do
    for j := Low(Matrix[i]) to High(Matrix[i]) do
    begin
      if (Matrix[i, j].hole = true) and (Matrix[i, j].number in s) then
      begin
        Matrix[i, j].hole := false;
        Matrix[Length(Matrix)-j - 1, i].hole := true;
        s := s - [Matrix[i, j].number];
      end;
    end;

end;

procedure RotateRight(var i, j: integer; n, k: integer);
var NewI, NewJ: integer;
begin
  if k > 1 then RotateRight(i, j, n, k-1);
  if k > 0 then
  begin
    NewI := j;
    NewJ := n - i - 1;
    i := NewI;
    j := NewJ;
  end;
end;

function GenerateKey(min, max: integer): TMatrix;
type
  TQuater = procedure(i, j, n: integer);
var i, j, k, l, e, n, h: integer;
    NNumbers: integer;
    Matrix: TMatrix;
    Mas: TDynamicMas;
begin
  randomize;
  n := random(max - min + 1) + min;

  SetLength(Matrix, n, n);

//  ??????????? ?????????? ?????????? ????? ? ???????
  if (n mod 2) = 0 then
  begin
    NNumbers := (n div 2) * (n div 2);
  end
  else
  begin
    NNumbers := (n div 2) * (n div 2 + 1) + 1;
  end;

  Mas := GenerateMas(NNumbers, NNumbers);

//  ?????????? ???????
  l := 0;
  if (n mod 2) = 0 then
  begin
    for i := 0 to ((n div 2) - 1) do
      for j := 0 to ((n div 2) - 1) do
      begin
        e := i;
        h := j;
        for k := 1 to 4 do
        begin
          Matrix[e, h].number := Mas[l];
          Matrix[e, h].hole := false;
          RotateRight(e, h, n, 1);
        end;
        inc(l);
      end;
  end
  else
  begin
    for i := 0 to ((n div 2) - 1) do
      for j := 0 to ((n div 2)) do
      begin
        e := i;
        h := j;
        for k := 1 to 4 do
        begin
          Matrix[e, h].number := Mas[l];
          Matrix[e, h].hole := false;
          RotateRight(e, h, n, 1);
        end;
        inc(l);
      end;

    i := (n div 2);
    j := (n div 2);
    Matrix[i, j].number := Mas[l];
    Matrix[i, j].hole := false;
  end;

//  ???????? ???????
  if (n mod 2) = 0 then
  begin
    for i := 0 to ((n div 2) - 1) do
      for j := 0 to ((n div 2) - 1) do
      begin
        k := random(4);
        e := i;
        l := j;
        RotateRight(e, l, n, k);
        Matrix[e, l].hole := true;
      end;
  end
  else
  begin
    for i := 0 to ((n div 2) - 1) do
      for j := 0 to ((n div 2)) do
      begin
        k := random(4);
        e := i;
        l := j;
        RotateRight(e, l, n, k);
        Matrix[e, l].hole := true;
      end;

    i := (n div 2);
    j := (n div 2);
    Matrix[i, j].hole := true;
  end;

  result := Matrix;

end;

procedure ToPrintMatrix(var Matrix: TMatrix);
var i, j: integer;
begin

  for i := Low(Matrix) to High(Matrix) do
  begin
    for j := Low(Matrix[i]) to High(Matrix[i]) do
    begin
      if Matrix[i,j].hole = true then write(1)
      else write(0);
      write('   ');
    end;
    writeln;
    writeln;
  end;
  writeln;
  writeln;
end;

function Encipher(var PlainText: string; var Matrix: TMatrix): string;
var i, j, k, n, l, spaces: integer;
    CipherText: string;
begin
  if Length(PlainText) mod (Length(Matrix) * Length(Matrix)) = 0 then
  begin
    spaces := 0;
  end
  else
  begin
    spaces :=(Length(Matrix) * Length(Matrix)) - (Length(PlainText) mod (Length(Matrix) * Length(Matrix)));
  end;

  SetLength(CipherText, Length(PlainText) + spaces);

  n := Low(PlainText);
  l := Low(CipherText);
  while n <= High(PlainText) do
  begin

//    ?????????? ??????? ???????
    for k := 1 to 4 do
    begin
      for i := Low(Matrix) to High(Matrix) do
        for j := Low(Matrix[i]) to High(Matrix[i]) do
        begin
          if Matrix[i, j].hole = true then
          begin
            if n <= High(PlainText) then
            begin
              Matrix[i, j].c := PlainText[n];
              inc(n);
            end
            else
            begin
              Matrix[i, j].c := ' ';
            end;
          end;
        end;
      RightMatrixRotate(Matrix);

      if (Length(Matrix) mod 2) = 1 then
      begin
        if k = 1 then
        begin
          Matrix[Length(Matrix) div 2, Length(Matrix) div 2].hole := false;
        end
        else if k = 4 then
        begin
          Matrix[Length(Matrix) div 2, Length(Matrix) div 2].hole := true;
        end;
      end;
    end;

//     ?????????? ??????? ? ??????????
    for i := Low(Matrix) to High(Matrix) do
      for j := Low(Matrix[i]) to High(Matrix[i]) do
      begin
        CipherText[l] := Matrix[i, j].c;
        inc(l);
      end;
  end;

  result := CipherText;

end;

function Decipher(var CipherText: string; var Matrix: TMatrix): string;
var i, j, k, n, l: integer;
    PlainText: string;
begin

  SetLength(PlainText, Length(CipherText));

  n := High(CipherText);
  l := High(PlainText);
  while n > 0  do
  begin

//    ?????????? ??????? ????????????
    for i := High(Matrix) downto Low(Matrix) do
      for j := High(Matrix[i]) downto Low(Matrix[i]) do
      begin
        Matrix[i, j].c := CipherText[n];
        dec(n);
      end;

//    ?????????? ??????? ???????
    for k := 4 downto 1 do
    begin
      LeftMatrixRotate(Matrix);

      if (Length(Matrix) mod 2) = 1 then
      begin
        if k = 4 then
        begin
          Matrix[Length(Matrix) div 2, Length(Matrix) div 2].hole := false;
        end
        else if k = 1 then
        begin
          Matrix[Length(Matrix) div 2, Length(Matrix) div 2].hole := true;
        end;
      end;

      for i := High(Matrix) downto Low(Matrix) do
        for j := High(Matrix[i]) downto Low(Matrix[i]) do
        begin
          if Matrix[i, j].hole = true then
          begin
            PlainText[l] := Matrix[i, j].c;
            dec(l);
          end;
        end;
    end;

  end;

  result := PlainText;

end;

begin
  min := 5;
  max := 10;

  SetLength(PlainText, 0);
  SetLength(CipherText, 0);
  Key := nil;

  ExitFlag := false;

  while not(ExitFlag) do
  begin
    writeln('1. Type plain text');
    writeln('2. Encrypt key');
    writeln('3. Decrypt key');
    writeln('4. Output data');
    writeln('0. Exit');
    writeln;

    readln(switch);
    writeln;

    case switch of

      1: begin

           Key := GenerateKey(min, max);
           SetLength(CipherText, 0);
           write('Text: ');readln(PlainText);
           writeln;

         end;

      2: begin

           if (Length(PlainText) = 0) or (Key = nil) then writeln('Encryption failed')
           else
           begin
             CipherText := Encipher(PlainText, Key);
             writeln('Encryption was successful');
           end;
           writeln;

         end;

      3: begin

           if (Length(CipherText) = 0) or (Key = nil) then writeln('Decryption failed')
           else
           begin
             PlainText := Decipher(CipherText, Key);
             writeln('Decryption was successful');
           end;
           writeln;

         end;

      4: begin

           if (Length(PlainText) = 0) or (Length(CipherText) = 0) or (Key = nil) then
           begin
             writeln('You entered the data incorrectly');
             writeln;
           end
           else
           begin
             write('Plain text:  '); writeln(PlainText);  writeln;
             write('Key:         '); writeln; writeln; ToPrintMatrix(Key); writeln;
             write('Cipher text: '); writeln(CipherText); writeln
           end;

         end;

      0: begin

          ExitFlag := true;

         end;

    else begin

           writeln('You entered an invalid choice');
           writeln;

         end;

    end;

  end;

end.
