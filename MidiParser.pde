import java.io.File;
import javax.sound.midi.*;

class MidiParse {
  public static final int NOTE_ON = 0x90;
  public static final int NOTE_OFF = 0x80;
  public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  
  String filepath;
  Sequencer sequencer;
  Sequence sequence;
  
  MidiParse(File f) {
    sequence = MidiSystem.getSequence(f);
    
    sequencer = MidiSystem.getSequencer();
    sequencer.setSequence(sequence);
  }
  
  public Sequence getSequence() {
    return sequence;
  }
  
  public Sequencer getSequencer() {
    return sequencer;
  }
}
