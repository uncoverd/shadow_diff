# Avtomatska zaznava regresij s senčenjem produkcijskih zahtev

ShadowDiff je celovita rešitev za zaznavanje regresij novih verzij ciljne spletne aplikacije, ki temelji na podvajanju spletnih zahtev v produkcijskem okolju.

Implementirana rešitev omogoča:
* transparentno testiranje nove verzije ciljne aplikacije s produkcijskimi zahtevami,
* avtomatsko zaznavanje vsebinskih in zmogljivostnih regresij nove verzije ciljne aplikacije,
* preprosto integracijo s ciljnimi aplikacijami.

## Senčenje spletnih zahtev

+![Senčenje](general.png?raw=true)
Senčenje spletnih zahtev temelji na naslednjih korakih:

* posredniški strežnik podvaja produkcijske spletne zahteve v senčeno okolje z novo izdajo,
* spletna zahteva se obdela v produkcijskem in senčenem okolju,
* uporabnik dobi samo odgovor produkcijskega okolja,
* primerjava obeh odgovorov na isto zahtevo omogoča zaznavo regresij.

## Implementacija

Za praktično uporabo senčenja produkcijskih zahtev ciljne spletne aplikacije je bila uporabljena arhitektura s sledečimi gradniki:

* Posredniški strežnik za senčenje
+![Implementacija](implementation.png?raw=true)

