
% Minimal kod för att demonstrera principen för hur MFCC och Dynamic Time
% Warping kan användas för taligenkänning. Borde snyggas till med mer
% funktionsanrop och loopar, särksilt om fler ord skall in.

%Metoden finns beskriven här:
%https://zenodo.org/record/1074387#.X2EHFD9xdEY
%http://www.rroij.com/open-access/isolated-speech-recognitionusing-mfcc-and-dtw.pdf
%https://www.irjet.net/archives/V5/i2/IRJET-V5I2408.pdf

%Vi utnyttjar att det finns inbyggda funktioner i Matlab för att beräkna MFCC och DTW. 
%-------------------------------------------------------------------------------

clear all

%Läs in ordet som skall testas. I denna enkla demovariant för att visa principen behöver ordet spelas
%in i annat program och sparas som wav-filer (exempelvis i Audacity), är gissningsvis bäst att de är i mono väl det vid inspelningen). Filerna bör trimmas så att det
%inte är lång tystnad före och efter orden.  

%Det här ordet skall testas:
[test,fs] = audioread('vinter15.wav'); 

%De här orden jämför vi med (bör helst vara flera av varje ord med olika talare): 
[referensord1,fs] = audioread('ljud/vinter1.wav');
[referensord2,fs] = audioread('upp2.wav');
[referensord3,fs] = audioread('ner1.wav');
[referensord4,fs] = audioread('ner2.wav');
[referensord5,fs] = audioread('hoger1.wav');
[referensord6,fs] = audioread('hoger2.wav');
[referensord7,fs] = audioread('vanster1.wav');
[referensord8,fs] = audioread('vanster2.wav');

%Ordlista med referensorden för att kunna skriva ut ordet som matchar bäst:
ord = ["upp" , "upp" , "ner" , "ner" , "höger" , "höger" , "vänster" , "vänster"];

coeffs = 4; % 1-14. Antalet MFCC-koefficienter som används. Här kan det kanske löna sig att experimentera lite med hur många som tas med.

%Beräkna MFCC för testordet:
testcoeffs = mfcc(test,fs);
testfirstcoeffs = transpose(testcoeffs(:,1:coeffs));

%Beräkna MFCC för referensorden (borde egentligen vara någon funktion och loop)
ref1coeffs = mfcc(referensord1,fs);
ref1firstcoeffs = transpose(ref1coeffs(:,1:coeffs));

ref2coeffs = mfcc(referensord2,fs);
ref2firstcoeffs = transpose(ref2coeffs(:,1:coeffs));

ref3coeffs = mfcc(referensord3,fs);
ref3firstcoeffs = transpose(ref3coeffs(:,1:coeffs));

ref4coeffs = mfcc(referensord4,fs);
ref4firstcoeffs = transpose(ref4coeffs(:,1:coeffs));

ref5coeffs = mfcc(referensord5,fs);
ref5firstcoeffs = transpose(ref5coeffs(:,1:coeffs));

ref6coeffs = mfcc(referensord6,fs);
ref6firstcoeffs = transpose(ref6coeffs(:,1:coeffs));

ref7coeffs = mfcc(referensord7,fs);
ref7firstcoeffs = transpose(ref7coeffs(:,1:coeffs));

ref8coeffs = mfcc(referensord8,fs);
ref8firstcoeffs = transpose(ref8coeffs(:,1:coeffs));


%beräkna avstånden mellan testord och de olika jämförelseorden med hjälp av Dynamic Time Warping
dist_ref1 = dtw(testfirstcoeffs,ref1firstcoeffs);
dist_ref2 = dtw(testfirstcoeffs,ref2firstcoeffs);
dist_ref3 = dtw(testfirstcoeffs,ref3firstcoeffs);
dist_ref4 = dtw(testfirstcoeffs,ref4firstcoeffs);
dist_ref5 = dtw(testfirstcoeffs,ref5firstcoeffs);
dist_ref6 = dtw(testfirstcoeffs,ref6firstcoeffs);
dist_ref7 = dtw(testfirstcoeffs,ref7firstcoeffs);
dist_ref8 = dtw(testfirstcoeffs,ref8firstcoeffs);

%ordet med minsta avståndet skrivs ut: 
distansvektor = [dist_ref1 dist_ref2 dist_ref3 dist_ref4 dist_ref5 dist_ref6 dist_ref7 dist_ref8];
[distans,ordnummer] = min([distansvektor]);

ord(ordnummer)


%Egentligen borde det vara betydlig fler exempel av varje referensord så det blir
%mer träffsäkert (kanske med någon form av medelvärde som beräknas till alla ord som är samma?).

%Kan också vara ide att testa att lägga till MFCC-deltan (som i . Darabk etc. den första länken ovan). Se dokumentation
%för MFCC hur de tas fram.

%Lycka till!




