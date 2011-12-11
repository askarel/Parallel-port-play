program lpttest;
uses crt, go32,strings;

CONST ppdata=$378; ppstatus=ppdata+1; ppcontrol=ppdata+2; eppdata=ppdata+4;

var i,j,k: byte;

function bytetobits (bytetodump: byte): string[8];
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

procedure epp_init;
begin
{outportb (ppcontrol, (inportb (ppcontrol) and $f7));}
outportb (ppcontrol, $c4);

end;

procedure epp_writedata (data:byte);
begin

end;

function epp_readdata: byte;
begin
outportb (ppcontrol, $e4);              { Turn off output }
outportb (ppcontrol, inportb (ppcontrol) or 1); { I want to read }
outportb (ppcontrol, inportb (ppcontrol) or 2); { data strobe }
epp_readdata:=inportb (ppdata);                 { I can has data ? }
outportb (ppcontrol, inportb (ppcontrol) and $fd ); { release data strobe }
outportb (ppcontrol, inportb (ppcontrol) and $fe ); {  Release the write }
outportb (ppcontrol, inportb (ppcontrol) and $df ); { turn on outputs }
end;

procedure epp_writeaddress (address: byte);
begin
outportb (ppdata, address);
outportb (ppcontrol, $c4);
outportb (ppcontrol, inportb (ppcontrol) or 1); { I want to write }
outportb (ppcontrol, inportb (ppcontrol) or 8); { address strobe }
outportb (ppcontrol, inportb (ppcontrol) and $f7);{ release address strobe }
outportb (ppcontrol, inportb (ppcontrol) and $fe);{ Release the write }
end;

begin
j:=0;
epp_init;
{outportb (ppcontrol, 255);}
clrscr;
gotoxy (10,8); write ('statusport:'); gotoxy (40,8); write ('dataport:');
gotoxy (10,9); write ('76543210'); gotoxy (40,9); write ('76543210');
gotoxy (10,18); write ('controlport:'); gotoxy (40,18); write ('eppdata:');
gotoxy (10,19); write ('76543210'); gotoxy (40,19); write ('76543210');


repeat
        gotoxy (62,10); write (' ',j,' ');
        gotoxy (70,10);
        write (bytetobits (j));
        epp_writeaddress (j);
        {if j = 255 then j:=0;}
        i:=inportb (ppstatus);
        gotoxy (3,10); write ('  ',i,'  ');
        gotoxy (10,10);
        write (bytetobits (i));
{        outportb (eppdata,0);}
        i:=inportb (ppdata);
        gotoxy (33,10); write ('  ',i,'  ');
        gotoxy (40,10);
        write (bytetobits (i));
        i:=inportb (ppcontrol);
        gotoxy (3,20); write ('  ',i,'  ');
        gotoxy (10,20);
        write (bytetobits (i));
        {i:=inportb (eppdata);}
        gotoxy (33,20); write ('  ',i,'  ');
        gotoxy (40,20);
        write (bytetobits (i));
        {delay (200);}
        i:=epp_readdata;
        gotoxy (62,20); write ('  ',i,' ');
        gotoxy (70,20);
        write (bytetobits (i));
        gotoxy (70,25);
        if i=j then
                begin
                textcolor (green);
                write (' ok     ');
                textcolor (white);
                end
                else
                begin
                textcolor (red);
                write ('FAIL:',j);
                textcolor (white);
                delay (2000);
              {  exit;}
                end;
        j:=j+1;
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
