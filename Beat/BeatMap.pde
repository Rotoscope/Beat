/*
*  BeatMap: class to represent a complete beatmap with all
*    events. This class contains event lists for the beatmap
*    as well as beatmap visual display information.
*
*    This class handles the non GUI functions of the beatmap,
*    including: saving to file, making beatmap image, loading
*    from file, 
*/

import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Comparator;
import java.util.Map;
import java.util.Iterator;
import java.io.BufferedReader;
import java.io.FileReader;

public class BeatMap {
  private Queue<BeatMapEvent> events;
  private long duration;
  private String filePath;
  final long minGap = 100;
  
  String midiName = "";
  
  float pixelsPerTick = 0.05;
  int imageWidth = 300;
  short maxLocations = 4;
  
  int[] colors = new int[]{#EA1111,#11EA74,#1711EA,#E6EA11,
                           #EA1111,#11EA74,#1711EA,#E6EA11,
                           #EA1111,#11EA74,#1711EA,#E6EA11};
  
  boolean in3d = false;
  // rotation angles for 3d image                         
  float xAngle = 0;
  float yAngle = 0;
  float zAngle = 0;
  
  boolean boxOn = false;
  int boxColor = #DE0707;
  int boxZ = -20;
  
  public BeatMap() {
    events = new PriorityQueue<BeatMapEvent>(50, new EventComparator());
    duration = 0;
  }  
  
  public BeatMap(Queue<BeatMapEvent> events, long duration) {
    this.events = events;
    this.duration = duration;
  }
  
  // create a PImage of the beatmap
  public PImage makeImage() {
    // new queue so as to not empty the old one
    Queue<BeatMapEvent> tempEvents = new PriorityQueue<BeatMapEvent>(events);
    
    int imageHeight = int(duration*pixelsPerTick);
    PGraphics pg = createGraphics(imageWidth, imageHeight);
    
    pg.beginDraw();
    
    pg.background(#000000);
    
    while(tempEvents.peek() != null) {
      BeatMapEvent event = tempEvents.poll();
      event.draw(pg);  
    }
    
    pg.endDraw();
    return pg;
  }
  
  // This method loads a beatmap into this object from a file
  public void loadBeatMap(File file) throws IOException {
    BufferedReader reader = new BufferedReader(new FileReader(file));
    filePath = file.getPath();
    
    Map<Short, Long> currentEndTick = new HashMap<Short,Long>();
    
    String line = null;
    String delims = "[ ]+";
    
    // loop for each line in the file
    while((line = reader.readLine()) != null) {
      String[] tokens = line.split(delims);
      short location = (short)(Integer.parseInt(tokens[0]));
      
      // if location > 0, then get the duration and tick information
      if(location > 0) {
        long tick = Long.parseLong(tokens[1]);      
        long duration = Long.parseLong(tokens[2]);
        long endTick = tick + duration;
      
        if(currentEndTick.get(location-1) == null || currentEndTick.get(location-1) + minGap < tick) {
          currentEndTick.put((short)(location-1),endTick);
          events.add(new PressTiming(location, tick, duration, this));
        }
      
        if(location > maxLocations)
          maxLocations = location;
      } else {                                // location < 0, then it is a code for some metadata
                                              // which includes display information
        switch(location) {
          case -1:
            in3d = true;
            xAngle = Float.parseFloat(tokens[1]);
            yAngle = Float.parseFloat(tokens[2]);
            zAngle = Float.parseFloat(tokens[3]);
            break;
          case -2:
            boxOn = true;
            break;
          case -3:
            midiName = "";
            for(int j = 1; j < tokens.length; j++) {
              midiName = midiName + tokens[j] + " ";
            }
        }
      }
    }
    
    long max = 0;
    Iterator<Long> it = currentEndTick.values().iterator();
    while(it.hasNext()) {
      long next = it.next();
      if(max < next)
        max = next;
    }
    duration = max;
  }
  
  // This method saves a beatmap file of this beatmap at location path
  public void saveToFile(String path) throws Exception {
    
    // creating a new queue so the old one is not emptied
    Queue<BeatMapEvent> tempEvents = new PriorityQueue<BeatMapEvent>(events);

    PrintWriter pw = new PrintWriter(path);

    BeatMapEvent event;

    //adds the notes to the file
    while (tempEvents.peek() != null) {
      event = tempEvents.poll();
      pw.println(event.toFileString());
    }    

    // add metadata to the file
    if (in3d) {
      pw.println(-1 + " " + xAngle + " " + yAngle + " " + zAngle);
    }

    if (boxOn) {
      pw.println(-2);
    }

    pw.println(-3 + " " + mp.midiName);

    pw.close();

  }
  
  public void copyCustomize(BeatMap bm) {
    bm.in3d = in3d;
    bm.xAngle = xAngle;
    bm.yAngle = yAngle;
    bm.zAngle = zAngle;
    bm.boxOn = boxOn;
  }
  
  public Queue<BeatMapEvent> getMap() {
    return events;
  }
  
  public Map<Short,Queue<BeatMapEvent>> getEventQueues() {
    Map<Short,Queue<BeatMapEvent>> eventQueues = new HashMap<Short,Queue<BeatMapEvent>>();
    
    Iterator<BeatMapEvent> it = events.iterator();
    while(it.hasNext()) {
      it.next().addToQueue(eventQueues);
    }
    
    return eventQueues;
  }
  
  public void setMap(Queue<BeatMapEvent> events) {
    this.events = events;
  }
  
  public long getDuration() {
    return duration;
  }
  
  public void setDuration(long dur) {
    this.duration = dur;
  }
  
  public short getLocationNumber() {
    return maxLocations;
  }
  
  public String getFilePath() {
    return filePath;
  }
}
