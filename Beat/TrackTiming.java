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
  
  public void saveToFile(String filename) throws Exception {
    PrintWriter pw;
    List<Note> durationStack = new ArrayList<Note>();
    List<Note> noteONStack = new ArrayList<Note>();
    Note n;

    pw = new PrintWriter(filename);

    for(int i = 0; i < noteList.size(); i++) {
      n = noteList.get(i);
//      pw.printf("%d %d %s\n", randInt(1,4), n.getTick(), n.getCommand());    //debugging line
      
      if(n.getCommand().equals("ON")) {
        noteONStack.add(1, n);  //add the note at the first element of the list
      } else if(n.getCommand().equals("OFF")) {
        for(int j = 0; j < noteONStack.size(); j++) {
          if(n.keyEquals(noteONStack.get(j + 1))) {
            
            //need code
            
          }
        }
      }     
      
    }
    pw.close();
  }
  
  static int randInt(int min, int max) {
    Random rand = new Random();
    
    return rand.nextInt((max - min) + 1) + min;
  }
}
