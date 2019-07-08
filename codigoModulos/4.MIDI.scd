////////////////////////////
// MIDI, notas y control
////////////////////////////

///////////////////
// RECIBIR MIDI
//////////////////

// Primer paso, iniciar el cliente para MIDI
MIDIClient.init;

// Segundo paso, detectando interfaces

MIDIIn.connectAll; // Conecta todas las interfaces disponibles, la forma más simple

// Conectar una interface specifica:
m = MIDIClient.sources; // Primero detecta los nombres de las interfaces disponibles
MIDIIn.connect(inport: 0, device:  m[0]) // Luego pasa el índice de la interface deseada

// Tercer paso, crear un mapeo de la interface

MIDIResponder, MIDIFunc //<--- No las usaremos!

// La clase que usaremos para controlar MIDI, la única que necesitamos, su creación
// es muy similar a un SynthDef, solo que existen varios tipos de MIDIdef:
MIDIdef.cc
MIDIdef.noteOn
MIDIdef.noteOff
MIDIdef.polytouch
MIDIdef.touch
MIDIdef.bend
MIDIdef.program
MIDIdef.sysex

// Y varias más, sin embargo, para 99% de los usos basta saber:

MIDIdef.cc // Detecta señales de control contínuo, como sliders o knobs
MIDIdef.noteOn // Detecta cuando una nota es presionada


/////////////////////
// CC
////////////////////

// Esta sintaxis (...args) significa tomar cuales sean los argumentos de
// la función sin tener que escribirlos todos uno por uni. Es útil cuando
// no sabemos exáctamente que argumentos tiene.
(
MIDIdef.cc(\miControl, { |...args|
	args.postln;
});
)

// Mapeo usando switch
(
MIDIdef.cc(\miControl, { | cc, val |
	switch(cc)
	{60} { "El valor del cc 60 es %".format(val) }
	{61} { "El valor del cc 61 es %".format(val) };
});
)

// Integrando con una SynthDef
(
SynthDef(\algo, { | freq, cFreq, amp |
	var sig = VarSaw.ar(freq);
	Out.ar(0, BPF.ar(sig, cFreq) * amp);
}).add;
)

// Tocamos la synth
x = Synth(\algo);

(
MIDIdef.cc(\miControl, { | cc, val |
	switch(cc)
	{60} { x.set(\freq, val) }
	{61} { x.set(\cFreq, val) }
	{62} { x.set(\amp, val) };
});
)

// Limpiar la MIDIdef
MIDIdef(\miControl).free;


// Otra opción usando varias MIDIdef
// La desventaja de esto no es costo
// computacional, en realidad no hay
// diferencia notable, sino que es más largo
MIDIdef.cc(\control0, { | cc, val |
	x.set(\freq, val);
}, 60);

MIDIdef.cc(\control1, { | cc, val |
	x.set(\cFreq, val);
}, 61);

MIDIdef.cc(\control2, { | cc, val |
	x.set(\amp, val);
}, 62);



// Sin embargo, podemos crear esto programáticamente
// Lo cual facilita mucho la tarea:
(
var param = [\freq, \cFreq, \amp];
var ccs = [60, 61, 62];
~midi = param.collect{|param, i|
	MIDIdef.cc(\control ++ i.asSymbol, { | cc, val |
		x.set(param, val)
	}, ccs[i])
};
)

// Liberar las definiciones
~midi.do{|midi| midi.free };

// Esta forma puede ser útil en tareas más avanzadas, cuando
// necesitamos crear mapeos automáticamente por ejemplo, sin
// embargo para nuestros propósitos inmediatos recomiendo
// usar el método con switch


/////////////////////
// NOTE ON
////////////////////

(
MIDIdef.noteOn(\miControl, { |...args|
	args.postln;
});
)

.midicps // Convierte valores MIDI a ciclos por segundo
.cpsmidi // Converite ciclos por segundo en valores MIDI

(
SynthDef(\simple, { | freq = 220, amp = 0.25, rel = 1 |
	var sig = SinOsc.ar([freq, freq + 2]) * EnvGen.kr(Env.perc(releaseTime: rel), doneAction: 2);
	Out.ar(0, sig * amp);
}).add;
)

(
MIDIdef.noteOn(\miControl, { | vel, val |
	Synth(\simple, [\freq, val.midicps]);
});
)


(
MIDIdef.noteOn(\miControl, { | vel, val |
	if(val == 69) {
		Synth(\simple, [\freq, (val-24).midicps, \rel, 4]);
		Synth(\simple, [\freq, val.midicps, \rel, 2]);
	} {
		Synth(\simple, [\freq, val.midicps]);
	}
});
)

.fix // hace que la definición MIDI dure incluso si se presion cmd + .

MIDIdef.freeAll

///////////////////
// ENVIAR MIDI
//////////////////

m = MIDIOut.newByName("IAC Driver", "Bus 1");
m.noteOn(16, 80, 60);

(
r = Routine({
	inf.do{
		m.control(1, 7, rrand(0, 127));
		0.25.wait;
	}
}).play;
)
