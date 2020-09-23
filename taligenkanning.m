
% Minimal kod för att demonstrera principen för hur MFCC och Dynamic Time
% Warping kan användas för taligenkänning. Borde snyggas till med mer
% funktionsanrop och loopar, särksilt om fler ord skall in.

%Metoden finns beskriven här:
%https://zenodo.org/record/1074387#.X2EHFD9xdEY
%http://www.rroij.com/open-access/isolated-speech-recognitionusing-mfcc-and-dtw.pdf
%https://www.irjet.net/archives/V5/i2/IRJET-V5I2408.pdf
%
%Vi utnyttjar att det finns inbyggda funktioner i Matlab för att beräkna MFCC och DTW. 
%-------------------------------------------------------------------------------

clear all

%Läs in ordet som skall testas. I denna enkla demovariant för att visa principen behöver ordet spelas
%in i annat program och sparas som wav-filer (exempelvis i Audacity), är gissningsvis bäst att de är i mono väl det vid inspelningen). Filerna bör trimmas så att det
%inte är lång tystnad före och efter orden.  

%Det här ordet skall testas:
[test,fs] = audioread('ljud/sommar15.wav'); 

%Ordlista med referensorden för att kunna skriva ut ordet som matchar bäst:
ord = ["vinter" , "sommar"];

coeffs = 4; % 1-14. Antalet MFCC-koefficienter som används. Här kan det kanske löna sig att experimentera lite med hur många som tas med.

antalord=length(ord); %antal ord i ordlistan
dataord = 14; %antal av respektive ord i ordlistan

%Beräkna MFCC för testordet:
testcoeffs = mfcc(test,fs);
testfirstcoeffs = transpose(testcoeffs(:,1:coeffs));

distanslista=zeros(1,dataord); %lista för avstånd mellan testord och referensord
medeldistans=zeros(1,antalord); %lista för medelavstånd mellan testord och respektive ord i ordlistan


%Loopar igenom varje ord i ordlistan
for i=1:2
 
    %Loopar igenom varje version av ordet
    for j=1:dataord
        
        %Läsa i referensord
        filnamn='ljud/'+ord(i)+j+'.wav';
        [referensord,fs]=audioread(filnamn);
        
        %Beräkna MFCC för referensorden
        refcoeffs = mfcc(referensord,fs);
        reffirstcoeffs = transpose(refcoeffs(:,1:coeffs));
        
        %Beräkna avstånde mellan testordets och referensordets
        %MFCC-koeficcienter
        distans=dtw(testfirstcoeffs, reffirstcoeffs);
        
        %Lagra avståndet i lista med avstånd
        distanslista(j)=distans;
        
    end
    
    %Beräkna medelavståndet till testordet, för varje ord i ordlistan
    medeldistans(i)=mean(distanslista);
    
end

%Ta fram minsta avståndet och koppla till ord i ordlistan
[dist,ordnummer] = min(medeldistans);
rattord=ord(ordnummer);

%Slumpa siffra
nr=randi([1 15],1,1);

%Hitta motsatsord
if mod(ordnummer,2)==0
    motsatsord=ord(ordnummer-1);
else
    motsatsord=ord(ordnummer+1);
end

filnamn='ljud/'+motsatsord+nr+'.wav';
[sound, fs] = audioread(filnamn);
soundsc(sound,fs);

    

%Skriva ut/spela upp motsats (slumpmässigt vilken inspelning)



%Egentligen borde det vara betydlig fler exempel av varje referensord så det blir
%mer träffsäkert (kanske med någon form av medelvärde som beräknas till alla ord som är samma?).

%Kan också vara ide att testa att lägga till MFCC-deltan (som i . Darabk etc. den första länken ovan). Se dokumentation
%för MFCC hur de tas fram.

%Lycka till!




