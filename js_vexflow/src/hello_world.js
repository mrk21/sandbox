import { Flow as VF } from 'vexflow';

const div = document.getElementById('container');
const renderer = new VF.Renderer(div, VF.Renderer.Backends.SVG);
renderer.resize(500, 200);

const context = renderer.getContext();
const stave = new VF.Stave(10, 40, 400);

stave.addClef("treble").addTimeSignature("4/4");
stave.setContext(context).draw();

const notes = [
  new VF.StaveNote({clef: "treble", keys: ["c/4"], duration: "q" }),
  new VF.StaveNote({clef: "treble", keys: ["d/4"], duration: "q" }),
  new VF.StaveNote({clef: "treble", keys: ["b/4"], duration: "qr" }),
  new VF.StaveNote({clef: "treble", keys: ["c/4", "e/4", "g/4"], duration: "q" })
];

const voice = new VF.Voice({num_beats: 4,  beat_value: 4});
voice.addTickables(notes);

const formatter = new VF.Formatter().joinVoices([voice]).format([voice], 400);
voice.draw(context, stave);
