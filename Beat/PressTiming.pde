/*
*  PressTiming: class for button timing
*    location: the location the timing corresponds to on the
*    timing bar.
*/

public class PressTiming extends BeatMapEvent {
  
  private short location;
  private long offset = 0;
  private BeatMap beatmap;
  
  public PressTiming(short location, long tick, long duration, BeatMap beatmap) {
    this.tick = tick;
    this.duration = duration;
    this.location = location;
    this.beatmap = beatmap;
  }
  
  @Override
  void draw(PGraphics pg) {
    int boxw = pg.width/beatmap.maxLocations;
    int boxh = int(duration*beatmap.pixelsPerTick);
    
    int boxx = (boxw)*(location - 1);
    int boxy = pg.height - (int(tick*beatmap.pixelsPerTick + boxh));
    
    if(pg != null) {
      pg.fill(beatmap.colors[location-1]);
      pg.noStroke();
      pg.rect(boxx,boxy,boxw,boxh);
    } else {
      
    }
  }
  
  public void setOffset(long offset) {
    this.offset = offset;
  }
  
  public short getLocation() {
    return location;
  }
}
