program Main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GeneralCryptography in '../GeneralCryptography.pas';

var PlainText, CipherText: string;
    Key: integer;
    max, min: integer;
    ExitFlag: boolean;
    switch: integer;

function Encipher(var PlainText: string; Key: integer): string;
var CipherText: string;
    i, j, k, l, e, n, period: integer;
begin
  if Key > 1 then
  begin
    period := 2*Key - 2;
    k := Length(PlainText) div period;
    i := Length(PlainText) mod period;
    if i <> 0 then inc(k);
    SetLength(CipherText, k*period);

//    Шифрование
    e := Low(CipherText);
    for i := 1 to Key do
    begin
      l := i;
      for j := 1 to k do
      begin
        if (i = 1) or (i = Key) then
        begin

          if l <= Length(PlainText) then
          begin
            CipherText[e] := PlainText[l];
            l := l + period;
            inc(e);
          end
          else
          begin
            CipherText[e] := ' ';
            inc(e);
          end;

        end
        else
        begin

          if l <= Length(PlainText) then
          begin
            CipherText[e] := PlainText[l];
            inc(e);
          end
          else
          begin
            CipherText[e] := ' ';
            inc(e);
          end;

          l := l + period - 2*(i-1);

          if l <= Length(PlainText) then
          begin
            CipherText[e] := PlainText[l];
            inc(e);
          end
          else
          begin
            CipherText[e] := ' ';
            inc(e);
          end;

          n := Key - (i - 1);
          l := l + period - 2*(n-1);
        end;
      end;
    end;
  end
  else if Key = 1 then CipherText := PlainText
  else SetLength(CipherText, 0);

  result := CipherText;

end;

function Decipher(var CipherText: string; Key: integer): string;
var PlainText: string;
    i, j, k, l, e, n, period: integer;
begin
  if Key > 1 then
  begin
    period := 2*Key - 2;
    k := Length(CipherText) div period;
    SetLength(PlainText, k*period);

//    Шифрование
    e := Low(CipherText);
    for i := 1 to Key do
    begin
      l := i;
      for j := 1 to k do
      begin
        if (i = 1) or (i = Key) then
        begin

          PlainText[l] := CipherText[e];
          l := l + period;
          inc(e);

        end
        else
        begin

          PlainText[l] := CipherText[e];
          inc(e);

          l := l + period - 2*(i-1);


          PlainText[l] := CipherText[e];
          inc(e);

          n := Key - (i - 1);
          l := l + period - 2*(n-1);
        end;
      end;
    end;
  end
  else if Key = 1 then PlainText := CipherText
  else SetLength(PlainText, 0);

  result := PlainText;
end;

begin
  min := 5;
  max := 10;

  SetLength(PlainText, 0);
  SetLength(CipherText, 0);
  Key := 0;

  ExitFlag := false;
   repeat
    writeln('------------------------');
    SetLength(CipherText, 0);
    writeln('Kluch');
    readln(key);
    writeln;
    writeln('Slovo dlya shifra');
    readln(PlainText);
    writeln('Chto sdelat?');
    writeln('1. shifrovat    2. deshifrovat    3.Exit');
    readln(switch);
    case switch of
      1:
      begin
        if (Length(PlainText) = 0) or (Key = 0) then writeln('Encryption failed')
           else
           begin
             CipherText := Encipher(PlainText, Key);
             writeln('Encryption was successful');
           end;
           write('Plain text:  '); writeln(PlainText);  writeln;
           write('Key:         '); writeln(Key); writeln;
           write('Cipher text: '); writeln(CipherText); writeln;
      end;
      2:
      begin
        if (Length(CipherText) = 0) or (Key = 0) then writeln('Decryption failed')
           else
           begin
             PlainText := Decipher(CipherText, Key);
             writeln('Decryption was successful');
           end;
           write('Plain text:  '); writeln(PlainText);  writeln;
           write('Key:         '); writeln(Key); writeln;
           write('Cipher text: '); writeln(CipherText); writeln;
      end;
      3:
        exitflag:=true;
    end;
  until ExitFlag=true;

end.
