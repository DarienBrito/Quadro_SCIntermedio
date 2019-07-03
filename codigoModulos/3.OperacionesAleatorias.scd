/*________________________________________________________________________

Quadro - plataforma para el conocimiento descentralizado

SuperCollider: curso intermedio
por Darien Brito
https://www.patreon.com/darienbrito

3. Operaciones aleatorias como control
__________________________________________________________________________*/
















/////////////////////////////////
// METODOS DE LA CLASE NUMBER
/////////////////////////////////

///////////
// coin
////////////

// El método coin (lanzar una moneda), devuelve true o false.
// El número es la probabilidad de que resulte en verdadero
0.5.coin; // 50%
0.75.coin; // 75%






10.do{|i| i.postln; };















// Probemos realizando 10 lanzamientos
10.do{|i| "lanzamiento % = %".format(i, 0.5.coin).postln };

// Probemos realizando 10 lanzamientos
10.do{|i| "lanzamiento % = %".format(i, 0.25.coin).postln };

// Probemos realizando 10 lanzamientos
10.do{|i| "lanzamiento % = %".format(i, 0.75.coin).postln };















///////////
// rand
////////////

// El método rand produce un numero al azar entre 0
// y el valor dado

// Con números float
1.0.rand;
10.0.rand;
100.0.rand;

// Con números íntegros
2.rand;
10.rand;
100.rand;

// Generar 10 valores aleatorios entre 0 y 100















///////////
// rrand
////////////

// El método rrand produce un numero al azar entre
// dos valores dados

// Con números float
rrand(0.5, 1.0);
rrand(50.0, 100.0);

// Con números íntegros
rrand(1, 10);
rrand(50, 100);

// Generar 10 valores aleatorios entre 23 y 33









////////////////////////////////////
// METODOS DE LA CLASE COLLECTION
///////////////////////////////////

// El método choose selecciona aleatoriamente
// elementos de la collección dada

[1, 2, 3].choose;



















// El método wchoose selecciona probabilisticamente
// elementos de la colección dada. Las probabilidades
// se pasan con un segundo array y tienen que sumar 1

[1, 2, 3].wchoose([0.25, 0.25, 0.5]);

// Para no tener que pensar en sumar exactamente uno,
// podemos normalizar el rango antes de la operacion
// (que es precisamente convertir algo al rango 0-1)
[1, 2, 3].wchoose([1, 2, 30].normalizeSum);

[1, 1, 2].normalizeSum;

[1, 2, 30].normalizeSum














// Creamos una SynthDef
(
SynthDef(\simple, { | freq = 220, amp = 0.25, rel = 1 |
	var sig = SinOsc.ar(freq) * EnvGen.kr(Env.perc(releaseTime: rel), doneAction: 2);
	Out.ar(0, sig * amp);
}).add;
)

// Crear dos posibilidades distintas usando coin
(
if(0.5.coin) {
	Synth(\simple);
} {
	Synth(\simple, [\freq, 440]);
}
)





// Crear tres posibilidades distintas usando rand
(
var valor = 3.rand;
switch(valor)
{0} { Synth(\simple) }
{1} { Synth(\simple, [\freq, 440]); }
{2} { Synth(\simple, [\freq, 880, \amp, 0.1]); };
)














// Crear tres posibilidades distintas usando rand
// y valores de frecuencia aleatorios con rrand
(
var valor = 3.rand;
switch(valor)
{0} { Synth(\simple) }
{1} { Synth(\simple, [\freq, 440]); }
{2} { Synth(\simple, [\freq, rrand(500, 1000), \amp, 0.1]); };
)












// Un resultado similar usando choose y valores probabilísticos
// para la frecuencia con wchoose
(
var valor = [0, 1, 2].choose;
switch(valor)
{0} { Synth(\simple) }
{1} { Synth(\simple, [\freq, 440]); }
{2} { Synth(\simple, [\freq, [440*1.75, 440*1.25, 440*2.25].wchoose([2, 1, 2].normalizeSum)]); };
)

















