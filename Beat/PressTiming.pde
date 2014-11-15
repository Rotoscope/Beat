/*
*  PressTiming: class for button timing
*    location: the location the timing corresponds to on the
*    timing bar.
*/

public class PressTiming extends BeatMapEvent {
  
  short location;
  
  public PressTiming(long tick, long duration, short location) {
    this.tick = tick;
    this.duration = duration;
    this.location = location;
  }
  
  @Override
  void draw(int pixelsPerTick, int imageWidth) {
    
  }
}
