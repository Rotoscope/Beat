import java.util.Date;
import javax.sound.midi.*;

class MetaData {
  int midiType;
  String author, title, copyright, comment;
  Date date;
 
  MetaData(MidiFileFormat midff) {
    midiType = midff.getType();
   // author = midff.getProperty("author");  // returns object; did not test what it is yet
  }
  
}
