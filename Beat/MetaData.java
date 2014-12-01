/*
  Will hold the metadata of the midi file
*/

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
  
  public int getMidiType() {
    return midiType;
  }
  
  public String getAuthor() {
    return author;
  }
  
  public String getTitle() {
    return title;
  }
  
  //will parse the date and return in XX/XX/XXXX format or XX/XX/XX
  public String getDate() {
    return "";
  }
}
