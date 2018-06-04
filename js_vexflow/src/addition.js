import { Flow as VF } from 'vexflow';

function init() {
  const containerDom = document.getElementById('container');
  const addNoteDom = document.getElementById('add_note');
  const clearNotesDom = document.getElementById('clear_notes');

  const renderer = new VF.Renderer(containerDom, VF.Renderer.Backends.SVG);
  renderer.resize(600, 200);
  const context = renderer.getContext();
  const notes = [];

  const stave = new VF.Stave(10, 40, 500);
  stave.addClef("treble").addTimeSignature("4/4");
  stave.setContext(context)

  addNoteDom.addEventListener('click', addNote.bind(this, context, stave, notes));
  clearNotesDom.addEventListener('click', clearNotes.bind(this, context, stave, notes));

  draw(context, stave, notes);
}

function getNotes(voice, notes) {
  const addedNotes = [];

  for (const note of notes) {
    if (!canAddNotes(voice, [...addedNotes, note])) {
      break;
    }
    addedNotes.push(note);
  }

  return addedNotes;
}

function getRestNotes(voice) {
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

    if (!canAddNotes(voice, [...restNotes, restNote])) {
      restNoteDurations.shift();
      if (restNoteDurations.length === 0) break;
      continue;
    }
    restNotes.push(restNote);
  }

  return restNotes.reverse();
}

function canAddNotes(voice, notes) {
  return fracValue(voice.ticksUsed) + sumTics(notes) <= fracValue(voice.totalTicks);
}

function draw(context, stave, notes) {
  const voice = new VF.Voice({ num_beats: 4,  beat_value: 4 });

  const addedNotes = getNotes(voice, notes);
  voice.addTickables(addedNotes);

  const beams = VF.Beam.generateBeams(addedNotes);
  beams.forEach(beam => beam.setContext(context));

  const restNotes = getRestNotes(voice);
  voice.addTickables(restNotes);

  const formatter = new VF.Formatter().joinVoices([voice]).format([voice], 400);

  context.clear();
  stave.draw();
  voice.draw(context, stave);
  beams.forEach(beam => beam.draw() );
}

function addNote(context, stave, notes) {
  notes.push(new VF.StaveNote({ clef: "treble", keys: ["c/4"], duration: "16" }));
  draw(context, stave, notes);
}

function clearNotes(context, stave, notes) {
  notes.splice(0);
  context.clear();
  stave.draw();
  draw(context, stave, notes);
}

function fracValue(frac) {
  return 1.0 * frac.numerator / frac.denominator;
}

function sumTics(notes) {
  return notes.reduce((acc, note) => acc + fracValue(note.ticks), 0);
}

init();
