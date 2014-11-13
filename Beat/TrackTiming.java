import java.util.List;
import java.util.ArrayList;

public class TrackTiming {
  int trackNumber, trackSize;
  List<Note> noteList;
  
  TrackTiming() {
    trackNumber = -1;
    trackSize = -1;
    noteList = new ArrayList<Note>();
  }
  
  public void setTrackNumber(int i) {
    trackNumber = i;
  }
  
  public int getTrackNumber() {
    return trackNumber;
  }
  
  public void setTrackSize(int i) {
    trackSize = i;
  }
  
  public int getTrackSize() {
    return trackSize;
  }
  
  public void addNote(long tick, String command, String noteName, int octave, int noteKey, int velocity, int channel) {
    Note n = new Note(tick, command, noteName, octave, noteKey, velocity, channel);
    noteList.add(n);
  }
  
  public Note getNote(int i) {
    return noteList.get(i);
  }
}
