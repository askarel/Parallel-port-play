program lpttest;
uses crt, linux, ports, strings;

CONST ppdata=$378; ppstatus=ppdata+1; ppcontrol=ppdata+2; eppdata=ppdata+4;

var i: byte;

function ioperm (from:cardinal; num:cardinal; turn_on: integer): integer; cdecl; external 'libc';

function bytetobits (bytetodump: byte): string;
const bits: ARRAY[0..1] of char='_Û';
var j: byte;
begin
bytetobits[0]:=#8;
for j:=8 downto 1 do
        begin
        bytetobits[j]:=bits[(bytetodump and 1) mod 2];
        bytetodump:=bytetodump shr 1;
        end;
end;

begin
ioperm (ppdata, 8 , 1);
{outportb (ppcontrol, (inportb (ppcontrol) or 32 ))}
portb[ppcontrol]:=portb[ppcontrol or 32];
clrscr;
gotoxy (10,8); write ('statusport:'); gotoxy (40,8); write ('dataport:');
gotoxy (10,9); write ('76543210'); gotoxy (40,9); write ('76543210');
gotoxy (10,18); write ('controlport:'); gotoxy (40,18); write ('eppdata:');
gotoxy (10,19); write ('76543210'); gotoxy (40,19); write ('76543210');

{for i:=0 to 255 do
        begin
        gotoxy (6,10); write (i);
        gotoxy (10,10);
        write (bytetobits (i));
        outportb (ppdata,i);
        delay (100);
        end;
}
repeat
        {i:=inportb (ppstatus);}
        i:=portb[ppstatus];
        gotoxy (3,10); write ('  ',i,'  ');
        gotoxy (10,10);
        write (bytetobits (i));
{        outportb (eppdata,0);}
        {i:=inportb (ppdata);}
        i:=portb[ppdata];
        gotoxy (33,10); write ('  ',i,'  ');
        gotoxy (40,10);
        write (bytetobits (i));
        {i:=inportb (ppcontrol);}
        i:=portb[ppcontrol];
        gotoxy (3,20); write ('  ',i,'  ');
        gotoxy (10,20);
        write (bytetobits (i));
        {i:=inportb (eppdata);}
        i:=portb[eppdata];
        gotoxy (33,20); write ('  ',i,'  ');
        gotoxy (40,20);
        write (bytetobits (i));
        delay (100);

until keypressed;
readkey;

{repeat
         outportb (ppdata,$aa);
        delay (200);
        outportb (ppdata,$55);
        delay (200 );
until keypressed;
}
{for i:=1 to 255 do
        begin
        outportb (ppdata,i);
        delay (200);

        end;
}
{
outportb (ppdata,$55);
delay (400);
outportb (ppcontrol, $00);
delay (400);
outportb (ppdata,$aa);
delay (400);
outportb (ppcontrol, $ff);
delay (400);
outportb (ppdata,$55);
}


end.
