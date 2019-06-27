/*________________________________________________________________________

Quadro - plataforma para el conocimiento descentralizado

SuperCollider: curso intermedio
por Darien Brito
https://www.patreon.com/darienbrito

1. Estructuras de Control 1 (condiciones)
__________________________________________________________________________*/

"Si hoy llueve, llevo paraguas"

true = verdadero
false = falso

if(condición) { función a ejecutar }

if(false) { "llevo paraguas".postln; };

==

(
var llueve = false;
if(llueve) { "llevo paraguas".postln; };
)





















"Si los turistas son hispano-hablantes hablo en español, sino en inglés."

condición - acción - alternativa

(
var turistas = "japoneses";
if(turistas == "hispanos") {
	"hablo español".postln
} {
	"hablo inglés".postln;
}
)




"Si los turistas son hispano-hablantes o hablan portugués, uso el español, sino hablo en inglés"

or (o)

verdad	verdad	=	falso
verdad	falso	=	verdad
falso	verdad	=	verdad
falso   falso   =   falso

(
var turistas = "húngaros";
if( (turistas == "hispanos").or(turistas == "portugueses") ) {
	"hablo español".postln;
} {
	"hablo inglés".postln;
}
)




































// OR
(
var turistas = "hispanos";
if((turistas == "hispanos").or(turistas == "portugues")) {
	"hablo español".postln;
} {
	"hablo en inglés".postln;
}
)

// AND
(
var turistas = "hispanos";
var num = 2;
if((turistas == "hispanos").and(num <= 2)) {
	"hablo español".postln;
} {
	"hablo en inglés".postln;
}
)