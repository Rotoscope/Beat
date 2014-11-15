/*
*  BeatMap: class to represent a complete beatmap with all
*    events.
*/

import java.util.ArrayList;
import java.util.List;

public class BeatMap {
  private List<BeatMapEvent> events;
  private long duration;
  
  int pixelsPerTick = 1;
  int imageWidth = 40;
  
  public BeatMap() {
    events = new ArrayList<BeatMapEvent>();
    duration = 0;
  }  
  
  public BeatMap(List<BeatMapEvent> events, long duration) {
    this.events = events;
    this.duration = duration;
  }
  
  // dummy for now
  public PImage makeImage() {
    int imageHeight = duration*pixelsPerTick;
    PGraphics pg = createGraphics(imageWidth, imageHeight);
    
    pg.beginDraw();
    
    // Draw image code here
    
    pg.endDraw();
    
    
    return pg;
  }
  
  public List<BeatMapEvent> getMap() {
    return events;
  }
  
  public void setMap(List<BeatMapEvent> events) {
    this.events = events;
  }
  
  public long getDuration() {
    return duration;
  }
  
  public void setDuration(long dur) {
    this.duration = dur;
  }
}
