
% Minimal kod f�r att demonstrera principen f�r hur MFCC och Dynamic Time
% Warping kan anv�ndas f�r taligenk�nning. Borde snyggas till med mer
% funktionsanrop och loopar, s�rksilt om fler ord skall in.

%Metoden finns beskriven h�r:
%https://zenodo.org/record/1074387#.X2EHFD9xdEY
%http://www.rroij.com/open-access/isolated-speech-recognitionusing-mfcc-and-dtw.pdf
%https://www.irjet.net/archives/V5/i2/IRJET-V5I2408.pdf
% Hej
%Vi utnyttjar att det finns inbyggda funktioner i Matlab f�r att ber�kna MFCC och DTW. 
%-------------------------------------------------------------------------------

clear all

%L�s in ordet som skall testas. I denna enkla demovariant f�r att visa principen beh�ver ordet spelas
%in i annat program och sparas som wav-filer (exempelvis i Audacity), �r gissningsvis b�st att de �r i mono v�l det vid inspelningen). Filerna b�r trimmas s� att det
%inte �r l�ng tystnad f�re och efter orden.  

%Det h�r ordet skall testas:
[test,fs] = audioread('ljud/vinter15.wav'); 

%Ordlista med referensorden f�r att kunna skriva ut ordet som matchar b�st:
ord = ["vinter" , "sommar"];

coeffs = 4; % 1-14. Antalet MFCC-koefficienter som anv�nds. H�r kan det kanske l�na sig att experimentera lite med hur m�nga som tas med.

antalord=length(ord);

%Ber�kna MFCC f�r testordet:
testcoeffs = mfcc(test,fs);
testfirstcoeffs = transpose(testcoeffs(:,1:coeffs));

referens=zeros(4,150,15*antalord);
distans=zeros(1,antalord);


%Loopar igenom varje ord
for i=1:2
 
    %Loopar igenom varje version av ordet
    for j=1:15
        
        %L�sa i referensord
        filename='ljud/'+ord(i)+j+'.wav';
        [referensord,fs]=audioread(filename);
        
        %Ber�kna MFCC f�r referensorden
        refcoeffs = mfcc(referensord,fs);
        reffirstcoeffs = transpose(refcoeffs(:,1:coeffs));
        
        %Lagra reffirstcoeffs i lista med koefficienter
        referens(:,1:length(reffirstcoeffs), j) = reffirstcoeffs;
    end
    
    medelreferens=mean(referens,3);
    distans(i)=dtw(testfirstcoeffs, medelreferens);
end

[dist,ordnummer] = min(distans);

ord(ordnummer)

%Egentligen borde det vara betydlig fler exempel av varje referensord s� det blir
%mer tr�ffs�kert (kanske med n�gon form av medelv�rde som ber�knas till alla ord som �r samma?).

%Kan ocks� vara ide att testa att l�gga till MFCC-deltan (som i . Darabk etc. den f�rsta l�nken ovan). Se dokumentation
%f�r MFCC hur de tas fram.

%Lycka till!




