***Skripta je nastavak na skripte koje su se koristile za prvi test,drugi test samim tim ovo je samo dodatak na prethodna dva testa, ako te skripte prvo savladate a potom i ovu, trebali bi biti spremni za predrok iz ispita Programskih prevodioca. Na sam ispit dolazi i dodatno gradivo koje nije u ovom ctivu. Ostale skripte mozete potraziti na tekucem repozitorijumu.***

<h1 align = "center"> Medjukod </h1>
<br>

## Faze kompajliranja

Su grupisane na :
  - faze zavisne od izvornog jezika ( *analiza* ), pripadaju prednjem modulu kompajlera ( **front end** )
  - faze zavisne od ciljnog jezika ( *sinteza* ), pripadaju zadnjem modulu kompajlera ( **back end** )

<p align="center">
  <img width="600" height="250" src="https://user-images.githubusercontent.com/45834270/72284114-81b2b180-3640-11ea-8cc6-6b7751c62e03.png">
</p>
<br>

Komunikacija frontenda i bekenda podrazumeva uvodjenje **medjukoda** ( jezika hipotetskog racunara- apstraktne masine), koji predstavlja:
  - ciljni jezik za frontend kompajlera 
  - izvorni jezik za bekend kompajlera
  
***Medjujezik*** je jezik izmedju izvornog jezika i ciljnog jezika: **IL** = *intermediate language*

Kompajler moze sadrzati samo frontend i tada je njegov ciljni jezik medjukod, koga izvrsava poseban program - **interpreter** ( liniju po liniju koda prevodi i odmah je izvrsi )

## Vrste medjukoda

Medju kod moze imati oblik:
  - **sintaksnog stabla**
  - **postfiksne** (obrnute Poljske) **notacije** ili **prefiksne** (Poljske) **notacije**
  - **troadresnog koda** koji odgovara hipotetskom asemblerskom jeziku
  
## Sintaksno stablo 

Je prezentacija sintakse izvornog koda u obliku stabla, prikazuje redosled izvrsavanja operacija programa, svaki cvor stabla oznacava pojam ili simbol koji se pojavljuje u pravoj sintaksi i po tome se razlikuje od konkretnog stabla parsiranja.
  - stablo parsiranja pokazuje postupak izvodjenja programa iz gramatike
  - sintaksno stablo je kondezovano stablo parsiranja
 
## Postfiksna notacija

Ili ti obrnuta Poljska notacija je prilagodjena apstraktnoj *stek* masini, uniformno tretira sve operatore i ne zahteva zagrade a takodje i operator sledi iza svih svojih operanada( za razliku od Poljske notacije gde se prvo navodi operator)

## Troadresni kod

*Three-address code* **TAC** ili **3AC** ne mora imati simbolicki oblik hipotetskog asemblerskog jezika, nego moze imati numericki oblik, gde pojedini brojevi predstavljaju kod naredbe i kodove operanada.
Ako kao kodovi operanada sluze indeksi elemenata tabele simbola, tada se generatoru koda prepusta da zauzima memoriju za operande.
Numericki oblik troadresnog koda je zgodniji za bekend kompajlera. Neke varijante 2-,3- ili 4-adresnog koda se cesto koriste kao **medjukod** jer se dobro prevode na vecinu asemblerskih jezika.

Svaka instrukcija se moze opisati kao grupa od 4 elementa:
  - (operator, operand1, operand2, result)
Svaka naredba ima uopstenu formu:
  **result := operand1 operator operand2**

Izrazi koji sadrze vise od jedne operacije(npr p := x+y * z) nisu pogodni za predstavljanje kao jedna instrukcija troadresnog koda, pa se one dekomponuju u ekvivalentnu sekvencu instrukcija:
  - t_1 := y * z
  - P := x+t_1

Osnovna osobina TAC je to da svaka instrukcija implementira samo jednu operaciju i da *source* i *destintion* mogu da se odnose na bilo koji slobodan registar.

## Zakljucak

Generisanje medjukoda je vrlo slicno generisanju koda
  - IL moze koristiti neogranicen broj registara
    - olaksano generisanje koda
  - u asemblerskom jeziku postoji ogranicen broj registara

<h1 align = "center" > Generisanje koda </h1>
<p align="center">
  <img width="760" height="350" src="https://images.unsplash.com/photo-1504639725590-34d0984388bd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80">
</p>
<br>

Generator koda preuzima ispravan medjukod i tabelu simbola, a proizvodi:
  - izvrsni masinski kod ili
  - objektni masinski kod ili
  - asemblerski kod
  
Generisanje koda se zasniva na odredjivanju nacina implementacije svake naredbe medjukoda pomocu naredbi koda.

## Registri

Za generisanje koda je vazno koriscenje registara (procesora) jer je registarsko adresiranje
  - najbrzi i
  - najkraci nacin adresiranja
  
**RIG: register interference graph** je graf kome su cvorovi promenljive koje su dodeljene registrima. Dve promenljive mogu biti dodeljene istom registru ako nisu povezane u grafu.
**Algoritam bojenja grafa** ima onoliko boja koliko ima radnih registara, cvorovi grafa se boje tako da medjusobno povezani cvorovi budu obojeni razlicitim bojama.
U slucaju da bojenje ne uspe, dolazi do prelivanja, pa se pre svake operacije koja cita f ubacuje **f := load fa**, a posle svake operacije koja pise f **store f,fa** i onda se ponovo pokusa bojenje grafa.
**Alokacija registara** jedan od najznacajnih poslova koje radi **kompajler**
  - od nacina alokacije registara zavise perfomanse i efikasnost

## Optimizacija koda
Zavisi od optimizacije medjukoda, masinski je zavisna, obuhvata parcijalnu optimizaciju, ima za cilj da na najbolji nacin iskoristi *specificnost racunara* i u modernim kompajlerima optimizacija koda je najveca i najkompleksnija faza kompajliranja.
  

<h1 align="center"> Osvrt na kompajlere </h1>
<br>

<p align="center">
  <img width="600" height="450" src="https://i.pinimg.com/originals/cc/ab/0e/ccab0e84303fd95373205ff4d9cd686d.png">
</p>

Pogledaj razliku izmedju [ kompajlera i interpretera ](https://www.youtube.com/watch?v=_C5AHaS1mOA)

<br>

U toku kompajliranja mogu da se izdvoje **prolazi**, to su delovi procesa kompajliranja koji obuhvataju:
  - citanje ulazne datoteke
  - pisanje izlazne datoteke
Na osnovu broja prolaza imamo:
  - jednoprolazne
    - sve faze u jednom prolazu
  - dvoprolazne
    - prvi prolaz je frontend kompajlera, a
    - drugi prolaza je bekend kompajlera
    
## Osobine kompajlera
  - mora generisati ispravan masinski kod 
  - brzina prevodjenja
  - kvalitet izgenerisanog koda
  - dobra dijagnostika gresaka
  - dobra optimizacija
  - prenosivost
  - lakoca odrzavanja
  - bug-free

Kompajlere karakterisu izvorni,ciljni i *implementacioni* jezik
Kompajleri ciji ciljni jezik ne pripada racunaru na kome se oni izvrsavaju se nazivaju **kros-kompajleri**(*cross-compiler*)


 <h1 align="center"> Optimizacija </h1>

<p align="center">
  <img width="700" height="350" src="https://www.quickbeyond.com/blog/wp-content/uploads/2019/03/ROR-optimization-1024x538.jpg">
</p>

Pre optimizacije medjukoda koju vrsi kompajler moguca je optimizacija izvornog koda koja je u nadleznosti programera.

## Optimizacija izvornog koda

Neophodno je analizirati izvorni kod, a analiza programa moze biti:
  - staticka ( analiza izvornog koda )
  - dinamicka ( analiza izvrsavanja programa)
  - analizom perfomansi se utvrdjuju mesta u programu na cije izvrsavanje odlazi najveci deo vremena izvrsavanja programa
  - cilj: odrediti delove programa koje treba optimizovati
  
## Profajler
  
Alat koji obavlja analizu perfomansi, merenjem broja poziva funkcija i merenjem trajanja svakog poziva.


## Optimizacija medjukoda

Ona je **masinski nezavisna** optimizacija, podrazumeva transformaciju medjukoda koja:
  - **ne menja znacenje koda** (programa)
  - **poboljsava koriscenje resursa** ( ubrzava njegovo izvrsavanje, smanjuje mem. zahteve, smanjuje velicinu koda...)

Optimizacija medjukoda se zasniva na **analizi upravljackog toka** i oktrivanju **baznih blokova** tj BB.

### Bazni blok:
  - je sekvenca instrukcija sa jednom tackom ulaza i jednom tackom izlaza
  - maksimalan broj instrukcija
  - instrukcije se uvek izvrsavaju od prve do poslednje
  - ne sadrzi labele - osim u *prvoj instrukciji*
  - ne sadrzi skokove - osim u *poslednjoj instrukciji*

Ideja je da :
  - nema ulaska (jump in) u BB( osim na pocetku BB )
  - nema izlaska(jump out) iz BB( osim na kraju BB )
  - samim tim, tok izvrsavanja tece od prve do poslednje instrukcije bez zaustavljanja.

**Dijagram toka** je usmereni graf ciji cvorovi su BB,spojnice su usmerene i pokazuju **redosled izvrsavanja**

### Granulizacija optimizacije:
  1. **lokalne optimizacije** ( *najisplativija* )
    - primenjuju se u jednom BB
    - vecina kompajlera ih radi
  2. **globalne optimizacije**
    - primenjuju se u jednom dijagramu toka ( telu funkcije )
    - puno kompajlera ih radi
  3. **medju-proceduralne optimizacije**
    - primenjuje se izmedju procedura
    - nekoliko kompajlera ih radi
    

## Lokalna optimizacija medjukoda

Najednostavniji i najisplativiji oblik optimizacije, optimizuje jedan BB:
  - **algebarske transformacije**
    - neke naredbe mogu biti uklonjenje
    - neke pojednostavljene
  - **slaganje konstanti**
    - neke operacije nad konstantama mogu biti izracunate u vreme kompajliranja
  - **nedostupan kod**
    - ne postoji skok na taj deo koda ili se ne moze "propasti" na izvrsavanje tog dela koda
    - nedostupan kod se moze obrisati
  - **mrtav kod**
    - kod koji se izvrsava ali ne utice na ostatak koda
    - optimizacija izbacuje ovakve naredbe
  - **suvisni kod**
    - kod koji ima ponovljen efekat i nepotreban je **zajednicki podizraz**
  - **propagacija kopije**
    - upotreba neke promenljive moze se zameniti sa nekom drugom promenljivom
    - ukoliko je u pitanju konstanta, odna se zove **propagacija konstante**

### Usmereni aciklicni graf

Za **otkrivanje zajednickih podizraza** se koristi *directed acyclic graph - DAG*, DAG se koristi za prikazivanje redosleda dogadjaja i ne sadrzi petlje. Takodje se koristi za lako otkrivanje zajednickih podizraza i ima po 1 cvor za svaki podizraz.

**Optimizacija petlji** ima za cilj da smanji vreme izvrsavanja petlje tj. smanjiti broj naredbi u telu petlje ( naredbe koje ne zavise od petlje idu ispred tela petlje)

## Peephole

Posebna vrsta optimizacije gde se posmatraju kratke sekvence uzastopnih naredbi i zamenjuju kracim i brzim sekvencama, a sekvenca naredbi se posmatra kroz zamisljeni prorez(***peephole***), pri cemu se prorez pomera preko naredbi od pocetka ka kraju programa.
Parcijalna optimizacija je najdelotvornija kada se uzastopno visestruko ponavlja.

U toku parcijalne optimizacije traze se pojave unapred zadatih slucajeva kao sto su:
  - suvisne naredbe
  - suvisni skokovi
  - nedostupne naredbe
  - mrtve naredbe
  - algebarske transformacije

I za svaki od slucajeva se sprovodi parcijalna optimizacija da bi se pojave doticnog slucaja pronasle i uklonile.

## Globalna optimizacija medjukoda

Odluka o transformaciji BB se donosi na osnovu poznavanja nacina koriscenja promenljivih u programu.
Zbog provere uslova obavlja se **globalna analiza toka podataka** koja za cilj ima da se za svaku promenljivu odredi poslednji BB u kome se ona koristi ( u kome se preuzima njena vrednost) i rezultati analize toka podataka se cuvaju u tabeli simbola.



















