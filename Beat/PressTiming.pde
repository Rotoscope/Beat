/*
*  PressTiming: class for button timing
*    location: the location the timing corresponds to on the
*    timing bar.
*/

public class PressTiming extends BeatMapEvent {
  
  private short location;
  private long offset = 0;
  private BeatMap beatmap;
  
  public PressTiming(long tick, long duration, short location, BeatMap beatmap) {
    this.tick = tick;
    this.duration = duration;
    this.location = location;
    this.beatmap = beatmap;
  }
  
  @Override
  void draw(PGraphics pg) {
    int boxw = pg.width/4;
    int boxh = duration*beatmap.pixelsPerTick;
    
    int boxx = (boxw)*(location - 1);
    int boxy = pg.height - (tick*beatmap.pixelsPerTick + boxh);
    
    int fillColor = #EA1111;
    
    if(pg != null) {
      pg.fill(fillColor);
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
