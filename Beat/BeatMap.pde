/*
*  BeatMap: class to represent a complete beatmap with all
*    events.
*/

import java.util.ArrayList;
import java.util.List;

public class BeatMap {
  List<BeatMapEvent> events;
  long duration;
  
  private final int pixelsPerTick = 1;
  private final int imageWidth = 40;
  
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
}
