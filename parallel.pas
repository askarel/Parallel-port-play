program parallel;
uses linux, baseunix, crt, strings;

var ppfd:longint;
    myioresult: integer;

begin
ppfd:=fpOpen ('/dev/parport0',O_RDWR);
myioresult:=fpioctl (ppfd,$8b,nil);
writeln ('ppclaim=',myioresult);


fpclose (ppfd);
end.
