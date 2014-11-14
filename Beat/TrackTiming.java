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
  
  public Note getNote(int i) {
    return noteList.get(i);
  }
  
  public void saveToFile(String filename) {
    PrintWriter pw;
    Note n;
    try {
      pw = new PrintWriter(filename);
      /*PrintWriter outFile = new PrintWriter(new FileWriter("fname", true));  */ //for appendmode
      for(int i = 0; i < noteList.size(); i++) {
        n = noteList.get(i);
        pw.printf("%d %ld %s %s", randInt(1,4), n.getTick(), n.getNoteName(), n.getCommand());
      } 
    } catch(Exception e) {
      System.out.println(e);
    }
  }
  
  static int randInt(int min, int max) {
    Random rand = new Random();
    
    return rand.nextInt((max - min) + 1) + min;
  }
}
