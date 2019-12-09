<h1 align="center"> Oporavak od greske - miniC </h1>
<br>

<p align="center">
  <img width="600" height="250" src="https://technology.amis.nl/wp-content/uploads/2018/06/error1.jpg">
</p>
<br>
  
Nakon otkrivanja greske u programskom tekstu potrebno je navesti:
 - *opis greske* 
 - *ukazati na mesto njene pojave*(broj linije programskog teksta sa greskom)
 
Ukoliko se pojavi ova greska u miniC kodu:
  - kompajler ce prijavi gresku
  - i **NASTAVITI** kompajliranje
  
## Token error

"Hvata" bilo koju gresku i postavlja se izmedju dva tokena(simbola). Ukoliko se pojavi ova greska u miniC kodu:
  - kompajler ce prijavi gresku
  - i **NASTAVITI** kompajliranje


<h1 align="center"> MiniC kompajler - MICKO </h1> 
<p align="center">
  <img width="600" height="250" src="https://previews.123rf.com/images/bentchang/bentchang1803/bentchang180302193/97307045-compiler-it-information-technology-conceptual-word-cloud-for-for-design-wallpaper-texture-or-backgro.jpg">
</p> <br>


Prevodi sa jezika miniC (izvorni jezik) na hipotetski asemblerski jezik(ciljni jezik). Kada je reci o implementaciji,generator skenera je *flex*, generator parsera je *bison* a sav dodatni kod je napisan na programskom jeziku C. 

## Implementacija

Podeljena je na uobicajene faze kompajliranja, pri cemu optimizacija koda nije ovde implementirana:

<p align="center">
  <img width="600" height="250" src="https://i.ibb.co/Rp8nMsP/Screenshot-1.png">
</p> 

**Leksicka** analiza: SKENER
  - deli ulazni string na simbole programskog jezika ( npr. kljucna rec, ime promenljive ili broj)

**Sintaksna** analiza: PARSER
  - proverava da li su simboli navedeni u ispravnom redosledu ( npr. nedostaje otvorena mala zagrada ili tacka-zarez)
  - tokom parsiranja se pravi stablo parsiranja koje odrazava strukturu programa 

**Semanticka** analiza: PARSER
  - proverava konzistentnost programa (npr. da li je promenljiva koja se koristi prethodno deklarisana i da li se koristi u skladu sa svojim tipom)

**Generisanje koda**: PARSER
  - prevodi program na ciljni jezik: hipotetski asemblerski jezik

## Tabela simbola
Sve faze kompajliranja koriste tabelu simbola, a ona je struktura podataka u kojoj se cuvaju sve informacije o svim simbolima koji su prepoznati u toku kompajliranja.<br />Na osnovu ovih informacija moguce je uraditi semanticku analizu i generisanje asemblerskog koda

## Greske u kompajliranju
Greske u izvornom kodu su moguce tokom svih faza kompajliranja pa kompajler treba da pomogne programeru da ih identifikuje i locira.<br />Programi mogu sadrzati greske na razlicitim nivoima: leksicka( npr. pogresno napisano ime,kljucna rec ili operator), sintaksna( npr. relacioni izraz sa nepotpunim parom zagrada), semanticka greska( npr. operator primenjen na nekompatabilni operand). <br />

Kompajler treba da: 
  - saopsti prisustvo gresaka jasno i ispravno
  - da se oporavi od greske dovoljno brzo da bi mogao da detektuje naredne greske
  - da ne usporava bitno obradu ispravnih programa



<h1 align="center"> Dvosmislenost </h1>
<p align="center">
  <img width="600" height="200" src="http://www.thecomicstrips.com/properties/grimmy/art_images/cg5483bad25f6ba.jpg">
</p> <br>

## Parser
Zadatak parsera je da proveri da li je ulazni niz simbola(tokena),u skladu sa gramatikom( da li je ispravan), pri cemu je **ulaz** *niz tokena od skenera* a **izlaz** je *stablo parsiranja programa*(implicitno,eksplicitno) <br /> Parser mora da razlikuje ispravne od neispravnih nizova tokena jer nisu svi nizovi tokena programi !

Parseru je potrebno da ima:
  - jezik za opis ispravnih nizova tokena
  - metode za razlikovanje ispravnih od neispravnih nizova tokena

Posto programski jezici imaju *rekurzivnu strukturu* koristimo kontekstno nezavisne gramatike(**CFG** ~ context free grammars) koje su pogodne za zapis rekurzivnih struktura.<br /> **CFG** se sastoji od :
 - skupa simbola ( "(", ")", ";" ...)
 - skupa pojmova (S, A..)
 - pocetnog pojma (S)
 - skupa pravila ( S->.. i slicno )
 
Pravila se koriste u parseru tako sto se leva strana pravila menja desnom stranom pravila.

**Formalno**:
 1. poceti sa stringom koji sadrzi samo *pocetni pojam*: 
 2. zameniti sve pojmove u stringu *desnim stranama* njihovih pravila
 3. ponavljati korak 2 dok ne *nestanu **pojmovi*** i *ostanu samo **simboli***( oni se dalje ne mogu zameniti(ne bi trebali biti tokeni jezika))
 
## Parser - izvodjenje
Izvodjenje je niz primenjenih pravila S -> ... -> ... -> ... ->, gde se pocinje od pocetnog pojma (S) i primenjuje se zamena pravila,jedan po jedan **pojam**
Izvodjenje se moze nacrtati kao *stablo* pri cemu je pocetni pojam *koren stabla*

### Stablo parsiranja
  - *simboli* su *listovi* stabla
  - *pojmovi* su *unutrasnji cvorovi*
  - listovi, s leva na desno, cine *ulazni tekst*
  - stablo odslikava prioritet operatora

### Izvodjenje
  - **s leva**: u svakom koraku se zamenjuje *krajnje levi pojam*
  - **s desna**: u svakom koraku se zamenljuje *krajnje desni pojam*
  
Izvodjenje s leva i izvodjenje s desna imaju **ISTA** stabla parsiranja, razlika je samo u redosledu u kom se dodaju grane stabla.
Izvodjenje definise stablo parsiranja, jedno stablo parsiranja moze imati vise izvodjenja !

## Parser - dvosmislenost
Gramatika je **dvosmislena** kada za jedan ulazni string postoji vise *stabala* parsiranja ili postoji vise od jednog *izvodjenja*(s leva ili s desna).Problem u dvosmislenosti je sto nude dve ili vise ravnopravnih mogucnosti izvodjenja pa time dovode parser u situaciju da ne moze automatski da se jednoznacno opredeli za jednu mogucnost.Posledica je takva da razni parseri mogu razlicito interpretirati isti program.Najbolji nacin za uklanjanja dvosmislenosti iz gramatike je ***pisanje nove gramatike*** tako da bude nedvosmislena


## Parser - Bison
Generatoru LR parsera moraju biti saopstene nedvosmislene gramatike da bi on u svaki element tabele akcija i prelaza mogao da smesti oznaku samo jedne akcije, u suprotnom dolazi do **konflikta**( koji se razresavaju davanjem prednosti jednoj akciji)

Bison-ov nacin za razresavanje konflikta:
  - *shift-reduce konflikt*: prednost daje *shift* akciji
  - *reduce-reduce konflikt*: prednost daje *reduce* akciji po pravilu koje je ranije navedeno

Ako ovaj podrazumevajuci nacin razresavanja konfilkta nije prihatljiv za korisnika moguce je saopstiti generatoru na koji nacin da resi konflikt(navodjenjem prioriteta) ili *izmeniti gramatiku*

Deklaracije prioriteta u bisonu se mogu definisati samo jednom za jedan token, za zavisne prioritete potrebno je koristiti dodatne mehanizme **%prec** za pravila

### %prec 
Modifikator koji deklarise prioritet nekog pravila
  - **%prec token**
  - preuzima prioritet tokena
  - pise se na kraju pravila
  - pravilu dodeljuje prioritet tokena 


### reduce-reduce konfilkt
Javlja se ukoliko postoji 2 ili vise pravila koja se mogu primeniti na isti niz ulaznih simbola i to je **ozbiljna greska u gramatici** ! Bison ovo razresava tako sto bira pravilo koje je ranije navedeno, ali to nikako nije najpametnije resenje, pa je potrebno napraviti ucinkovitije izmene.

















