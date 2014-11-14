import java.io.File;
import javax.sound.midi.*;

public class MidiParser {
  public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  
  String filepath;
  Sequencer sequencer;
  Sequence sequence;
  MetaData metaData;
  MidiFileFormat mff;
  Track[] tracks;
  TrackTiming[] trackTimings;
  
  MidiParser(File f) {
    try {
      filepath = f.getAbsolutePath();
      sequence = MidiSystem.getSequence(f);
      mff = MidiSystem.getMidiFileFormat(f);
      metaData = new MetaData(mff);
    
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
  
  public Track[] getTracks() {
    return tracks;
  }
  
  public Track getTrack(int i) {
    return tracks[i];
  }
  
  public TrackTiming getTrackTiming(int i) {
    return trackTimings[i];
  }
  
  //altered code from 
  public void parseMidiFile() {
    int trackNumber = 0, channel;
    long tick;
    
    for (Track track :  tracks) {
      trackTimings[trackNumber].setTrackNumber(trackNumber + 1);
      trackTimings[trackNumber].setNumberOfEvents(track.size());
      
      for (int i=0; i < track.size(); i++) { 
        MidiEvent event = track.get(i);
        tick = event.getTick();
        MidiMessage message = event.getMessage();
        
        if (message instanceof ShortMessage) {
          ShortMessage sm = (ShortMessage) message;
          channel = sm.getChannel();
          int velocity = sm.getData2();
          
          if (sm.getCommand() == ShortMessage.NOTE_ON && velocity != 0) {
            int noteKey = sm.getData1();
            int octave = (noteKey / 12)-1;
            int note = noteKey % 12;
            String noteName = NOTE_NAMES[note];
            
            trackTimings[trackNumber].addNote(tick, "ON", noteName, octave, noteKey, velocity, channel); 
          } else if (sm.getCommand() == ShortMessage.NOTE_OFF || 
                      (sm.getCommand() == ShortMessage.NOTE_ON && velocity == 0)) {
            int noteKey = sm.getData1();
            int octave = (noteKey / 12)-1;
            int note = noteKey % 12;
            String noteName = NOTE_NAMES[note];
            
            trackTimings[trackNumber].addNote(tick, "OFF", noteName, octave, noteKey, velocity, channel); 
          } else {
            System.out.println("Command:" + sm.getCommand());
          }
        } else {
          System.out.println("Other message: " + message.getClass());
        }
      }
      trackNumber++;
    }
  }
  
  public void saveNoteTimings(int trackNumber, String filePath) {  //trackNumber is determined by which beatmap was selected in authoring mode
    trackTimings[trackNumber - 1].saveToFile(filePath);
  }
}
