import java.io.File;
import javax.sound.midi.*;

public class MidiParser {
  public static final int NOTE_ON = 0x90;
  public static final int NOTE_OFF = 0x80;
  public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  
  String filepath;
  Sequencer sequencer;
  Sequence sequence;
  Track[] tracks;
  TrackTiming[] trackTimings;
  
  MidiParser(File f) {
    try {
      sequence = MidiSystem.getSequence(f);
    
      sequencer = MidiSystem.getSequencer();
      sequencer.setSequence(sequence);
      
      tracks = sequence.getTracks();
      if(tracks.length > 0) {
        trackTimings = new TrackTiming[tracks.length];
        for(int i = 0; i < trackTimings.length; i++) {
           trackTimings[i] = new TrackTiming(); 
        }
      }
    } catch(Exception e) {
      //InvalidMidiDataException: Error constructing sequence or not a valid MIDI file data recognized by system
      //or IOException
      System.out.println(e);  
    }
  }
  
  public Sequence getSequence() {
    return sequence;
  }
  
  public Sequencer getSequencer() {
    return sequencer;
  }
  
  public void parseMidiFile() {
    int trackNumber = 0;
    for (Track track :  tracks) {
      trackTimings[trackNumber].setTrackNumber(trackNumber);
      trackTimings[trackNumber].setTrackSize(track.size());
      trackNumber++;

      for (int i=0; i < track.size(); i++) { 
        MidiEvent event = track.get(i);
        System.out.print("@" + event.getTick() + " ");
        MidiMessage message = event.getMessage();
        if (message instanceof ShortMessage) {
          ShortMessage sm = (ShortMessage) message;
          System.out.print("Channel: " + sm.getChannel() + " ");
          if (sm.getCommand() == NOTE_ON) {
            int key = sm.getData1();
            int octave = (key / 12)-1;
            int note = key % 12;
            String noteName = NOTE_NAMES[note];
            int velocity = sm.getData2();
            System.out.println("Note on, " + noteName + octave + " key=" + key + " velocity: " + velocity);
          } else if (sm.getCommand() == NOTE_OFF) {
            int key = sm.getData1();
            int octave = (key / 12)-1;
            int note = key % 12;
            String noteName = NOTE_NAMES[note];
            int velocity = sm.getData2();
            System.out.println("Note off, " + noteName + octave + " key=" + key + " velocity: " + velocity);
          } else {
            System.out.println("Command:" + sm.getCommand());
          }
        } else {
          System.out.println("Other message: " + message.getClass());
        }
      }
      System.out.println();
    }
  }
}
