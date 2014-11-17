/*
*  BeatMap: class to represent a complete beatmap with all
*    events.
*/

import java.util.PriorityQueue;
import java.util.Queue;
import java.util.Comparator;
import java.io.BufferedReader;
import java.io.FileReader;

public class BeatMap {
  private Queue<BeatMapEvent> events;
  private long duration;
  
  float pixelsPerTick = 0.05;
  int imageWidth = 300;
  short maxLocations = 4;
  
  int[] colors = new int[]{#EA1111,#11EA74,#1711EA,#E6EA11};
  
  public BeatMap() {
    events = new PriorityQueue<BeatMapEvent>(50, new EventComparator());
    duration = 0;
  }  
  
  public BeatMap(Queue<BeatMapEvent> events, long duration) {
    this.events = events;
    this.duration = duration;
  }
  
  public PImage makeImage() {
    int imageHeight = int(duration*pixelsPerTick);
    PGraphics pg = createGraphics(imageWidth, imageHeight);
    
    pg.beginDraw();
    
    pg.background(#000000);
    
    while(events.peek() != null) {
      BeatMapEvent event = events.poll();
      event.draw(pg);
    }
    
    pg.endDraw();
    return pg;
  }
  
  public void loadBeatMap(File file) throws IOException {
    BufferedReader reader = new BufferedReader(new FileReader(file));
    
    long[] currentEndTick = new long[maxLocations];
    
    String line = null;
    String delims = "[ ]+";
    while((line = reader.readLine()) != null) {
      String[] tokens = line.split(delims);
      short location = (short)(Integer.parseInt(tokens[0]));
      long tick = Long.parseLong(tokens[1]);
      long duration = Long.parseLong(tokens[2]);
      long endTick = tick + duration;
      
      if(currentEndTick[location-1] < endTick) {
        currentEndTick[location-1] = endTick;
        events.add(new PressTiming(location, tick, duration, this));
      }
    }
    
    long max = currentEndTick[0];
    for(int i = 1; i < maxLocations; i++) {
      if(max < currentEndTick[i])
        max = currentEndTick[i];
    }
    
    duration = max;
  }
  
  public Queue<BeatMapEvent> getMap() {
    return events;
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
  
  class EventComparator implements Comparator<BeatMapEvent> {
    public int compare(BeatMapEvent e1, BeatMapEvent e2) {
      if(e1.tick > e2.tick)
        return 1;
      else if (e1.tick < e2.tick)
        return -1;
      else
        return 0;
    }
  }
}
