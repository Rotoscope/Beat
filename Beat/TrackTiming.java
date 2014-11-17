import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class TrackTiming {
  int trackNumber, numberOfEvents;
  List<Note> noteList;
  
  TrackTiming() {
    trackNumber = -1;
    numberOfEvents = -1;
    noteList = new ArrayList<Note>();
  }
  
  public void setTrackNumber(int i) {
    trackNumber = i;
  }
  
  public int getTrackNumber() {
    return trackNumber;
  }
  
  public void setNumberOfEvents(int i) {
    numberOfEvents = i;
  }
  
  public int getNumberOfEvents() {
    return numberOfEvents;
  }
  
  public void addNote(long tick, String command, String noteName, int octave, int noteKey, int velocity, int channel) {
    Note n = new Note(tick, command, noteName, octave, noteKey, velocity, channel);
    noteList.add(n);
  }
  
  // i > 0 && i <= noteList.size()
  public Note getNote(int i) {
    return noteList.get(i);
  }
  
  public List getDurationTiming() {
    List<Note> durationList = new ArrayList<Note>();
    List<Note> noteONList = new ArrayList<Note>();
    Note n, m;

    for(int i = 0; i < noteList.size(); i++) {
      n = noteList.get(i);
      
      if(n.getCommand().equals("ON")) {
        noteONList.add(n);  //add the ON note at the first element of the list
      } else if(n.getCommand().equals("OFF")) {
        
        //tosses away any OFF commands when there are no ON commands
        for(int j = 0; j < noteONList.size(); j++) {
          m = noteONList.get(j);
          
          //after finding the matching ON Note, it sets the duration and adds it to a different list
          //any off notes is disregarded if there is no matching ON Note
          if(n.keyEquals(m)) {
            m.setDuration(n.getTick() - m.getTick());
            durationList.add(m);
            noteONList.remove(j);
          }
        }
      }
    }
    
    //move all notes that does not have a NOTE_OFF to the durationList with its default duration
    while(!noteONList.isEmpty()) {
      durationList.add(noteONList.remove(0));
    }
    
    return durationList;
  }
  
  public void saveToFile(String filename) throws Exception {
    PrintWriter pw;
    List<Note> durationList = getDurationTiming();
    Note n;

    pw = new PrintWriter(filename);

    //adds the durationList notes to the file
    while(!durationList.isEmpty()) {
      n = durationList.get(0);
      pw.printf("%d %d %d\n", randInt(1,4), n.getTick(), n.getDuration());
      durationList.remove(0);
    }    

    pw.close();
  }
  
  static int randInt(int min, int max) {
    Random rand = new Random();
    
    return rand.nextInt((max - min) + 1) + min;
  }
}
