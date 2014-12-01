public class Play extends BeatGUIBase {
  final long MARGIN_OF_ERROR = 10;
  int[] scores;
  boolean[] flags;
  Map<Short,Queue<BeatMapEvent>> release_events;
  BeatMapEvent event;

  public Play(ControlP5 cp5, Group group) {
    super(cp5, group);
  }

  public void initialize() {
    flags = new boolean[4];
    for(short i = 0; i < 4; i++)
      flags[i] = false;
    scores = new int[5];
    
    release_events = new HashMap<Short,Queue<BeatMapEvent>>();
  }

  public void draw() {
    for(short i = 0; i < 4; i++) {
      long acc = mp.getTickPosition() - eventMap.get(i).peek().getTick();
      if(acc >= MARGIN_OF_ERROR * 5) {
        eventMap.get(i).poll();
      }
    }
  }

  public void keyPressed() {
    if (mp != null && bm != null && eventMap != null) {
      switch(key) {
        case 'D':
          if (flags[0] == false) {
            long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(0).peek().getTick());
            //only consider the score if the button pushed is near a note
            if (accuracy < MARGIN_OF_ERROR * 5) {
              if (accuracy <= MARGIN_OF_ERROR) {
                scores[0]++;
              }
              event = eventMap.get(0).poll();
              event.setTick(event.getEndTick());
              event.addToQueue(release_events);
            }
          }
          flags[0] = true;
          break;
        case 'F':
          if (flags[1] == false) {
            long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(1).peek().getTick());
  
            if (accuracy < MARGIN_OF_ERROR * 5) {
              if (accuracy <= MARGIN_OF_ERROR) {
                scores[0]++;
              }
              event = eventMap.get(1).poll();
              event.setTick(event.getEndTick());
              event.addToQueue(release_events);
            }
          }
          flags[1] = true;
          break;
        case 'J':
          if (flags[2] == false) {
            long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(2).peek().getTick());
  
            if (accuracy < MARGIN_OF_ERROR * 5) {
              if (accuracy <= MARGIN_OF_ERROR) {
                scores[0]++;
              }
              event = eventMap.get(2).poll();
              event.setTick(event.getEndTick());
              event.addToQueue(release_events);
            }
          }
          flags[2] = true;
          break;
        case 'K':
          if (flags[3] == false) {
            long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(3).peek().getTick());
  
            if (accuracy < MARGIN_OF_ERROR * 5) {
              if (accuracy <= MARGIN_OF_ERROR) {
                scores[0]++;
              }
              event = eventMap.get(3).poll();
              event.setTick(event.getEndTick());
              event.addToQueue(release_events);
            }
          }
          flags[3] = true;
          break;
      }
    }
  }

  public void keyReleased() {
    if (mp != null && bm != null) {
      switch(key) {
        case 'D':
          flags[0] = false;
          if (release_events.get(0) != null) {
            long accuracy = Math.abs(mp.getTickPosition() - release_events.get(0).poll().getTick());
  
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;  //scores are rated on pressing and releasing on time
            }
          }
          break;
        case 'F':
          flags[1] = false;
          if (release_events.get(1) != null) {
            long accuracy = Math.abs(mp.getTickPosition() - release_events.get(1).poll().getTick());
  
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;
            }
          }
          break;
        case 'J':
          flags[2] = false;
          if (release_events.get(2) != null) {
            long accuracy = Math.abs(mp.getTickPosition() - release_events.get(2).poll().getTick());
  
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;
            }
          }
          break;
        case 'K':
          flags[3] = false;
          if (release_events.get(3) != null) {
            long accuracy = Math.abs(mp.getTickPosition() - release_events.get(3).poll().getTick());
  
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;
            }
          }
          break;
      }
    }
  }
}
