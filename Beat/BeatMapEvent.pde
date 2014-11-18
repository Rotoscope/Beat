/*
*  BeatMapEvent: abstract class for events that go in the beatmap
*  such as button press timings or tempo changes
*/

public abstract class BeatMapEvent {
  long tick;
  long duration;
  abstract void draw(PGraphics pg);
  
  public long getTick() {
    return tick;
  }
  
  public long getDuration() {
    return duration;
  }
}
