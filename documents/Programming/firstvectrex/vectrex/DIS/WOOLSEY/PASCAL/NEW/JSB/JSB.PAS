program jsb;

(* The unaccompanied violin sonata No. 6 in E major, 1st movement,
                  by Johann Sebastian Bach,
  faithfully transcribed by Michael Baum for the IBM-PC

 Runs 4;06 minutes
*)

type
  twine = string[100];

var
  tune: text;
  a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x: twine;

begin
writeln('SONATA VI in E Major, 1st Movement');
writeln('J.S. BACH');
 A:='g#eg#e';B:='g#eg#d#';C:='g#eg#d';D:='o4aeac#';E:='o4aeao3b';
 F:='o4g#eg#o3b';G:='o4g#eg#o3a';H:='o4f#ef#o3a';I:='o4f#ef#o3g#';
 J:='o4eeeo3g#';K:='o4eeeo3f#';L:='o4d#ed#o3f#';
 M:='o4c#o3ao4c#o3a';N:='o4c#o3ao4c#o3g#';O:='o4c#o3ao4c#o3g';
 P:='o4do3ao4do3f#';Q:='o4do3ao4do3e';R:='O4C#O3AO4C#O3E';
 S:='o4c#o3ao4c#o3d';T:='o3babd';U:='o3babc#';V:='o3aaac#';
 W:='o3aaao2b';X:='o3g#ag#o2b';
 writeln('t100msp8o5l16ED#l8eo4bg#b l16ef#ed#l8eo3bg#b mll16ebf#bg#babg#bf#b eo4ed#c#o3bo4ed#c#o3bag#f#');
 writeln('msl16ebf#bg#babg#bf#b eo4ed#c#o3bo4ed#c#o3bag#f#');
 writeln('mlef#g#abo4c#d#ef#g#af# g#bef#g#abo5c#d#ec#d# eo4babg#babg#bf#b eo5ed#c#o4beo5c#o4ebeae');
 writeln('ms g#bf#bg#babg#bf#b eo5ed#c#o4beo5c#o4ebeae');
 writeln('mn g#eeed#eeef#ed#e eeg#ef#eg#eaef#e');
 writeln('ms g#eeed#eeef#ed#e eeg#ef#eg#eaef#e');
 writeln(a,a,a,b,b,b,c,c,c,d,d,d,e,e,e);
 writeln(f,f,f,g,g,g,h,h,h,i,i,i,j,j,j);
 writeln(k,k,k,l,l,l);
 writeln('mlef#ef#g#bef#g#bef# g#ag#abo4eo3g#abo4eo3g#a bo4c#o3bo4c#dg#o3bo4c#dg#o3bo4c#');
 writeln('dbg#edo3bg#edc#do2b');
 writeln('o3c#d#c#d#fg#c#d#fg#c#d# ff#ff#g#o4c#o3ff#g#o4c#o3ff#');
 writeln('g#ag#abo4fo3g#abo4fo3g#a bo4g#fc#bg#af#fg#c#o3b');
 writeln('ao4c#o3af#o4f#d#ec#cd#o3g#f# eg#ec#eg#o4c#o3g#o4ec#g#c#');
 writeln('cd#co3g#o4g#gg#gg#d#ec# cd#co3g#o4f#ff#ff#d#ec#');
 writeln('cd#co3g#ag#ag#ad#ec# cf#c#f#d#f#c#f#cf#d#f# o2g#o3f#o4d#o3f#o4co3f#o4d#o3f#o4co3f#o4d#o3f#');
 writeln('o2g#o3eo4c#o3eo4eo3eo4c#o3eo4eo3eo4c#o3e');
 writeln('o2g#o3f#o4d#o3f#o4co3f#o4d#o3f#o4co3f#o4d#o3f#');
 writeln('o2g#o3eo4c#o3eo4eo3eo4c#o3eo4eo3eo4c#o3e');
 writeln('o2g#o3go4c#o3go4eo3go4c#o3go4eo3go4c#o3g');
 writeln('o2g#o3go4c#o3go4eo3go4c#o3go4eo3go4c#o3g');
 writeln('o2g#o3g#o4c#o3g#o4d#o3g#o4c#o3g#o4d#o3g#o4c#o3g#');
 writeln('o2g#o3f#o4co3f#o4d#o3f#o4co3f#o4d#o3f#o4co3f#');
 writeln('c#o4c#o3bag#o4c#o3g#f#eg#ed# c#o4c#o3g#f#eg#ed#c#ec#o2b');
 writeln('o2a#o3f#o4c#o3f#o4eo3f#o4c#o3f#o4eo3f#o4c#o3f#');
 writeln('o2a#o3f#o4eo3f#o4c#o3f#o4eo3f#o4c#o3f#o4eo3f#');
 writeln('o2bo4ba#g#f#bf#ed#f#d#c# o3bo4bf#ed#f#d#c#o3bo4d#o3ba');
 writeln('o3g#o4dedg#dbdg#ded o3g#o4dedo3g#o4do3f#o4do3g#o4do3eo4d');
 writeln('o4c#eag#aedec#eo3bo4e o3ao4ag#f#eo3ao4f#o3ao4eo3ao4do3a');
 writeln('mso4c#eo3bo4ec#edec#eo3bo4e o3ao4ag#f#eo3ao4f#o3ao4eo3ao4do3a');
 writeln('mno4c#o3aaag#aaabag#a aao4c#o3abao4c#o3ao4do3aba');
 writeln('mso4c#o3aaag#aaabag#a aao4c#o3abao4c#o3ao4do3aba');
 writeln(m,m,m,n,n,n,o,o,o,p,p,p);
 writeln(q,q,q,r,r,r,s,s,s,t,t,t);
 writeln(u,u,u,v,v,v,w,w,w,x,x,x);
 writeln('ml ababo3c#eo2abo3c#eo2ab o3c#dc#deac#deac#d ef#ef#go4c#o3ef#go4c#o3ef#');
 writeln('go4ec#dec#o3a#bo4c#o3a#f#e dc#o2bo3c#df#o2bo3c#df#o2bo3c#');
 writeln('dedef#bdef#bde f#g#f#g#ao4d#o3f#g#ao4d#o3f#g#');
 writeln('ao4f#d#ef#d#cc#d#co3g#f# fo4bg#abg#ff#g#fc#o3b ao5c#o4abo5c#o4af#g#af#dc#');
 writeln('o3bo5do4bo5c#do4bg#abg#fg# c#d#c#d#fg#c#d#fg#c#d# ff#ff#g#bff#g#bff#');
 writeln('g#ag#abo5do4g#abo5do4g#a bo5do4bg#fbg#fc#bag# f#g#af#o3bo4ag#f#c#g#f#f');
 writeln('def#do3g#o4f#edo3a#o4edc# o3bo4c#do3bfo4dc#o3bf#o4c#o3ba');
 writeln('g#abag#babg#bf#b ff#g#abfo4do3fo4c#o3fbf f#af#c#o2ao3c#f#c#ac#f#c#');
 writeln('fg#fc#fg#o4c#o3g#o4fc#g#o3b ao4c#o3af#ao4c#f#c#af#o5c#o4f#');
 writeln('fg#fc#o5c#cc#cc#o4g#af# fg#fc#ba#ba#bg#af#');
 writeln('fg#fc#dc#dc#do3g#af# fg#o4c#mnbbmlg#af#fg#c#o3b ao4c#f#o5mnc#c#mlo4abg#f#adc#');
 writeln('o3bo4do3gf#fg#c#o2bao3c#f#g# af#bf#o4c#o3f#o4do3f#c#f#g#f');
 writeln('f#ag#mnaaamlg#af#aea d#aeaf#ag#mnaaamlf#a g#ag#f#eo4ed#ec#eo3bo4e');
 writeln('o3a#o4eo3bo4ec#ed#mneeemlc#e d#ed#c#o3bo4c#d#ef#g#af#');
 writeln('bo3babg#bf#bebdb c#ef#g#abo4c#def#g#e o4ao3ag#af#aead#ac#a');
 writeln('o2bo3d#ef#g#abo4c#d#ef#d# g#o3edec#eo2bo3eo2ao3eo2g#o3e');
 writeln('o2ao3eo4c#o3bo4c#eag#af#c#e o2bo3f#o4d#c#d#f#ag#af#d#f#');
 writeln('o2bo3g#babo4eg#f#g#eo3bo4e o2bo3a#o4c#o3bo4c#ea#g#a#ec#e');
 writeln('d#ba#g#f#bf#ed#f#d#c# o3bo4bag#f#af#ed#f#d#c# o3bo4ag#f#eg#ed#c#ec#o3b');
 writeln('ao4g#f#ed#f#d#c#o3bo4d#o3ba g#o4ec#o3bao4c#o3ag#f#af#e');
 writeln('d#f#ao4c#o3bo4d#f#g#ag#af# g#eg#bo5eo4bg#eo3bo4eo5ed#');
 writeln('eo4bg#edec#edeo3bo4e c#eaec#eo3bo4ec#eo3ao4e');
 writeln('o3bo4eg#eo3bo4eo3ao4eo3bo4eo3g#o4e o3ao4ef#ed#mneeemlf#eg#e');
 writeln('a4.b8g#4');
 writeln('mno2l16ao4ag#l32af#f#g#f#g#f#g#f#g#f#g#f#g#l8e');
 writeln('l16eo5ed#c#o4bo5eo4ao5eo4g#o5eo4f#o5e o4eed#c#o3bo4eo3ao4eo3g#o4eo3f#o4e');
 writeln(' mbmlt90o3eg#bo4d#t80eg#t70bo5d#t60l8e');
writeln(' Musical Riddle from ');
writeln(' Art of the Fugue!');
writeln('(Sprechen zie Deutsch?)')
end.
