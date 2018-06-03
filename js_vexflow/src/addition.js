import { Flow as VF } from 'vexflow';

const container = document.getElementById('container');
const renderer = new VF.Renderer(container, VF.Renderer.Backends.SVG);
renderer.resize(500, 500);
const context = renderer.getContext();

const stave = new VF.Stave(10, 40, 400);
stave.addClef("treble").addTimeSignature("4/4");
stave.setContext(context)
stave.draw();

const notes = [];

document.getElementById('add_note').addEventListener('click', _ => {
  notes.push(new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "16" }));

  const voice = new VF.Voice({num_beats: 4,  beat_value: 4});

  const addedNotes = addNotes(voice, notes);
  const beams = VF.Beam.generateBeams(addedNotes);
  beams.forEach(beam => beam.setContext(context));
  fillRestNotes(voice);

  const formatter = new VF.Formatter().joinVoices([voice]).format([voice], 400);

  context.clear();
  stave.draw();
  voice.draw(context, stave);
  beams.forEach(beam => beam.draw() );
});

document.getElementById('clear_note').addEventListener('click', _ => {
  notes.splice(0);
  context.clear();
  stave.draw();
});

const fracValue = (frac) => 1.0 * frac.numerator / frac.denominator;

const sumTics = (notes) => notes.reduce((acc, note) => acc + fracValue(note.ticks), 0);

const addNotes = (voice, notes) => {
  const addedNotes = [];

  for (const note of notes) {
    if (fracValue(voice.ticksUsed) + sumTics([...addedNotes, note]) > fracValue(voice.totalTicks)) {
      break;
    }
    addedNotes.push(note);
  }

  voice.addTickables(addedNotes);
  return addedNotes;
};

const fillRestNotes = (voice) => {
  const restNoteDurations = [
    "1r",
    "2r",
    "4r",
    "8r",
    "16r",
    "32r",
  ];

  const restNotes = [];

  while (true) {
    const restNote = new VF.StaveNote({ clef: "treble", keys: ["b/4"], duration: restNoteDurations[0] });

    if (fracValue(voice.ticksUsed) + sumTics([...restNotes, restNote]) > fracValue(voice.totalTicks)) {
      restNoteDurations.shift();
      if (restNoteDurations.length === 0) break;
      continue;
    }
    restNotes.push(restNote);
  }
  voice.addTickables(restNotes.reverse());
};
