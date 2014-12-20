/*
*  MidiParser: class to hold the parse the midi file into separate tracks with note timings
*              allows playback of the midi file
*/

import java.io.File;
import javax.sound.midi.*;

public class MidiParser {
  public final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  
  String filepath;
  Sequencer sequencer;
  Sequence sequence;
  MetaData metaData;
  MidiFileFormat mff;
  Track[] tracks;
  TrackTiming[] trackTimings;
  
  int locationCount;
  String midiName;
  
  private boolean isPlaying = false;

  /*
    InvalidMidiDataException: Error constructing sequence or not a valid MIDI file data recognized by system
    or IOException if midi file can't be read
  */  
  MidiParser(File f) throws Exception {
      filepath = f.getAbsolutePath();
      midiName = f.getName();
      sequence = MidiSystem.getSequence(f);
      mff = MidiSystem.getMidiFileFormat(f);
      metaData = new MetaData(mff);
    
      sequencer = MidiSystem.getSequencer();
      if(sequencer == null) throw new MidiUnavailableException();

      
      tracks = sequence.getTracks();
      if(tracks.length > 0) {
        trackTimings = new TrackTiming[tracks.length];
        for(int i = 0; i < trackTimings.length; i++) {
           trackTimings[i] = new TrackTiming(); 
        }
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
  
  public int numOfTracks() {
    return tracks.length;
  }
  
  //returns duration of sequence or 0 if no sequence is set
  public long getTickLength() {
    return sequencer.getTickLength();
  }
  
  //returns the current position in the sequence
  public long getTickPosition() {
    return sequencer.getTickPosition();
  }
  
  public void playSong() throws Exception {
    sequencer.open();
    sequencer.setSequence(sequence);
    sequencer.start();
    isPlaying = true;
  }
  
  public void stopSong() {
    if(sequencer.isOpen()) {
      sequencer.stop();
      sequencer.close();
      isPlaying = false;
    }
  }
  
  public void pauseSong() {
    if(sequencer.isOpen()) sequencer.stop();
  }
  
  public void restartSong() {
    sequencer.setTickPosition(0);
  }
  
  public void resumeSong() {
    if(!sequencer.isRunning())
      sequencer.start();
  }
  
  public String getFilePath() {
    return filepath;
  }
  
  public MetaData getMetaData() {
    return(metaData);
  }
  
  //altered code from http://stackoverflow.com/questions/3850688/reading-midi-files-in-java
  public void parseMidiFile() {
    int trackNumber = 0, channel;
    long tick;
    
    for (Track track : sequence.getTracks()) {
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
          
          //only add note messages
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
//            System.out.println("Command:" + sm.getCommand());    //looks at what command is given
          }
        } else {
//          System.out.println("Other message: " + message.getClass());    //looks at other messages like metamessages in the tracks
        }
      }
      trackNumber++;
    }
  }
  
  //trackNumber is determined by which beatmap was selected in authoring mode
  //trackNumber > 0 && <= # of tracks in the midi file
  public void saveNoteTimings(int trackNumber, String filePath) throws Exception {  
    trackTimings[trackNumber - 1].saveToFile(filePath, locationCount);
  }
  
  public BeatMap makeBeatMap(int trackNumber) {
    return trackTimings[trackNumber - 1].toBeatMap(locationCount);
  }
  
  public boolean isPlaying() {
    return isPlaying;
  }
  
  public void setLocationCount(int lc) {
    locationCount = lc;
  }
}
