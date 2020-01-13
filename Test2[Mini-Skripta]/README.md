


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


<h1 align="center"> Hipotetski asemblerski jezik </h1>
<p align="center">
  <img width="600" height="200" src="https://i.pinimg.com/originals/8b/7b/c7/8b7bc7c76af65bfa61d0f974409b3a17.jpg">
</p> <br>

Podrazumeva se da registri i memorijske lokacije zauzimaju po 4 bajta a ukupno imamo 16 registara:
  - %0-%12 su registri *opste namene*
  - %13 - rezervisan za *povratna vrednost* funkcije
  - %14 - sluzi kao *pokazivac frejma*
  - %15 - sluzi kao *pokazivac steka*

### Labele
Zapocinje malim slovom iza koga mogu da slede mala slova, cifre i podcrta (npr. **f:**, **main:** ) a imamo i **sistemske labele** koje zapocinju znakom '**@**'(npr. **@if:**, **@f_body:**, **@exit1:**)

## Operandi
  - **Neposredni operand**
    - Odgovara celom(oznacenom ili neoznacenom) broju: $0 ili $-152, a njegova vrednost vrednosti tog broja,dok $labela odgovara adresi labele labela.
  - **Registarski operand**
    - Odgovara oznaci registra, a njegova vrednost sadrzaju tog registra
  - **Direktni operand**
    - Odgovara labeli, njegova vrednost odgovara adresi labele,ako ona oznacava naredbu i koristi se kao operand naredbe skoka ili poziva potprograma. Ako direktni operand odgovara labeli koja oznacava direktivu i ne koristi se kao operand naredbe skoka ili poziva potprograma, njegova vrednost odgovara sadrzaju adresirane lokacije.
  - **Indirektni operand**
    - Odgovara oznaci registra navednoj izmedju malih zagrada : (%0) a njegova vrednost sadrzaju memorijske lokacije koju adresira sadrzaj registra
  - **Indeksni operand**
    - zapocinje celim ( oznacenim ili neoznacenim) brojem ili labelom iza cega sledi oznaka registra navedena izmedju malih zagrada: -8(%14) ili 4(%14) ili tabela(%0) gde njegova vrednost odgovara sadrzaju memorijske lokacije koju adresira zbir vrednosti broja i sadrzaja registra, odnosno *zbir adrese labele i sadrzaja registra*

Operandi se dele na 
  - ulazne(sve vrste operanada)
  - izlazne( sve vrste bez neposrednog)

## Neke od naredbi
  - naredba **poredjenja** brojeva postavlja bite status registra u skladu sa razlikom prvog i drugog ulaznog operanda:
    - **CMPx ulazni operand, ulazni operand**
  - naredba **bezusluvnog skoka** smesta u programski brojac vrednost ulaznog operanda ( omogucujuci tako nastavak izvrsavanja od ciljne naredbe koju adresira ova vrednost): 
    - **JMP ulazni operand**
  - naredba **uslovnog skoka** smestaju u programski brojac vrednost ulaznog operanda samo ako je ispunjen uslov odredjen kodom naredbe( gde ispunjenost uslova zavisi od bita status registra): 
    - **JEQ,JNE,JGTx,JLTx,JGEx,JLEx ulazni operand**
  - naredbe **rukovanja stekom** omogucuju smestanje na vrh steka vrednosti ulaznog operanda,odnosno preuzimanje vrednosti sa vrha steka i njeno smestanje u izlazni operand:
    - **PUSH ulazni operand**
    - **POP izlazni operand**
  - naredba **poziva potprograma** smesta na vrh steka zateceni sadrzaj programskog brojaca, a u programski brojac smesta vrednost ulaznog operanda:
    - **CALL ulazni operand**
  - naredba **povratka iz potprograma** preuzima vrednost sa vrha steka i smesta je u programski brojac
    - **RET**
  - naredba za **sabiranje brojeva**
    - **ADDx ulazni operand, ulazni operand, izlazni operand**
  - naredba za **oduzimanje brojeva**
    - **SUBx ulazni operand, ulazni operand, izlazni operand**
  - naredba za **mnozenje brojeva**
    - **MULx ulazni operand, ulazni operand, izlazni operand**
  - naredba za **deljenje brojeva**
    - **DIVx ulazni operand, ulazni operand, izlazni operand**
  - naredba za **prebacivanje vrednosti**
    - **MOV ulazni operand,izlazni operand**
  - naredba **konverzije celog broja u razlomljeni broj**
    - **TOF ulazni operand, izlazni operand** (vrednost ulaznog operanda je celi broj, a vrednost izlaznog operanda je ekvivalentni razlomljeni broj u MNF-masinskoj normalizovanoj formi)
  - naredba **konverzije razlomljenog broja u celi broj**
    - **TOI ulazni operand, izlazni operand** ( vrednost ulaznog operanda je razlomljeni broj u MNF, a vrednost izlaznog operanda je ekvivalentni celi broj ako je konverzija moguca, inace se izaziva izuzetak)
  - **direktiva zauzimanja memorijskih lokacija** omogucuje zauzimanje broja uzastopnih memorijskih lokacija koji je naveden kao njen operand
    - **WORD broj**

## Organizacija memorije 
<p align="center">
  <img width="800" height="400" src="https://i.ibb.co/SKBzK58/organizacijamemorije.png">
</p> <br>

Posto se medjurezultati izraza koriste u suprotnom redosledu od onog u kome su izracunati, radni registri, koji se koriste za smestanje medjurezultata, se zauzimaju i oslobadjaju **po principu steka**.<br /> Kao *pokazivac steka registara* koristi se promenljiva ***free_reg_num***, koja sadrzi broj prvog slobodnog radnog registra.<br /> <br>
**Zauzimanje** radnog registra se sastoji od preuzimanja vrednosti promenljive ***free_reg_num*** i njenog inkrementiranja. <br /> **Oslobadjanje** radnog registra se sastoji od dekrementiranja promenljive ***free_reg_num***.Treba i zapaziti da je broj registra istovremeno i **indeks** elementa tabele simbola.

Funkcija cuva lokalne promenljive i parametre na stek frejmu.

## Labele 
U generisanom kodu moraju biti **jedinstvene** a svaka labela se zavrsava brojem. Promenljiva ***lab_num*** sadrzi aktuelni broj labele,nju samo inkrementiramo kad naidjemo na sledecu komponentu( npr **@if0:**, **@if1:** ...)

## C blokovi
Blokovi se medjusobno razlikuju po rednom broju koji im dodeljuje kompajler, u tabeli simbola za svaku lokalnu promenljivu blloka mora biti vezan redni broj bloka. Kompajler koristi redne brojeve blokova kod odredjivanja porducja vazenja identifikatora.

Lokalne promenljive blokova se cuvaju u frejmu bloka na steku ( za razliku od frejma poziva funkcije, **frejm bloka** ne sadrzi argumente kao ni povratnu vrednost ). *Frejm bloka* se stvara na ulazu u blok, a unistava na izlasku iz bloka.

## Slogovi
Za svaki slog je potrebna posebna tabela simbola, koja sadrzi njegova polja sa relativnom pozicijom u slogu kao dodatnim atributom.

## Nizovi
Za svaki niz u tabeli simbola treba registrovati i broj njegovih elemenata


<h1 align = "center"> Generisanje koda </h1> <br>
<br>
<p align="center">
  <img width="800" height="450" src="https://images.wallpapersden.com/image/wxl-minimal-glowing-code-binary_63680.jpg">
</p>
<br>

## Implementacija generisanja koda
Odmah nakon prepoznavanja imena funkcije generise se:
  - labela **imefunkcije:**
  - kod koji opisuje pripremu stek frejma
    - smestanje starog FP
    - postavljanje novog FP

Posle prepoznavanja cele funkcije( na kraju pravila function), generise se:
  - labela **@imefunkcije_exit:**
  - kod koji opisuje ciscenje stek frejma 
    - ocisti stek od lokalnih promenljivih( pomeri SP)
    - vrati stari FP
  - naredba **RET** koja podize povratnu adresu sa steka u PC brojac i preusmerava tok izvrsavanja na tu adresu

Telo funkcije pocinje labelom **@imefunkcije_body:** i zauzima se prostor na steku
Poziv funkcije generise **CALL** naredbu i kod koji **SKIDA** argumente sa steka

Generisanje koda za miniC 
  - **argumenti**. Generise **PUSH** naredbu za svaki argument. **$$** sadrzi ukupan broj argumenata.
  - **Return** naredba. Generise **MOV** naredbu za kopiranje povratne vrednosti funkcije u registar **%13**. Generise bezuslovni skok na labelu koja opisuje kraj funkcije.
  - **Relacioni izrazi**. Generise **CMP** naredbu.











