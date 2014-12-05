/*
*  Will hold the metadata of the midi file
*  Midi files do not require these fields to be filled
*  It will be empty a majority of the time
*/

import java.util.Date;
import javax.sound.midi.*;

class MetaData {
  int midiType;
  String author, title, copyright, comment;
  Date date;
 
  MetaData(MidiFileFormat midff) {
    midiType = midff.getType();
    
    if(midff.getProperty("author") != null)
      author = midff.getProperty("author").toString();
      
    if(midff.getProperty("title") != null)
      title = midff.getProperty("title").toString(); 
      
    if(midff.getProperty("copyright") != null)
      copyright = midff.getProperty("copyright").toString(); 
      
    if(midff.getProperty("date") != null)
      date = (Date) midff.getProperty("date"); 
      
    if(midff.getProperty("comment") != null)
      comment = midff.getProperty("comment").toString(); 
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
  
  public String getCopyright() {
    return copyright;
  }
  
  public String getComment() {
    return comment;
  }
  
  //will parse the date and return in XX/XX/XXXX format or XX/XX/XX
  public String getDate() {
    return date.toString();
  }
}
