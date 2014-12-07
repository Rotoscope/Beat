public class Play extends BeatGUIBase {
  final long MARGIN_OF_ERROR = 10;
  int[] scores;
  boolean[] flags;
  Map<Short,Queue<BeatMapEvent>> release_events;
  BeatMapEvent event;

  public Play(ControlP5 cp5) {
    super(cp5, cp5.addGroup("PLAY"));
  }

  public void initialize() {
    flags = new boolean[4];
    for(short i = 0; i < 4; i++)
      flags[i] = false;
    scores = new int[5];
    
    release_events = new HashMap<Short,Queue<BeatMapEvent>>();
  }

  public void draw() {
//    checkTiming();
    
    if (img!=null) {
      //    if (offset < 0)
      //      offset = 0;
      //    else if (offset > (img.height - height))
      //      offset = img.height - height;
      //      
      if (mp != null) {
        offset = (int)(mp.getTickPosition()*bm.pixelsPerTick);
      }

      image(img, width/2 - img.width/2, height - img.height+offset - lineh);

      // draw timing line
      stroke(#98F79E);
      strokeWeight(4);
      line(width/2 - img.width/2, height-lineh, width/2 + img.width/2, height-lineh);
    }
  }

  public void keyPressed() {
    if (mp != null && bm != null && eventMap != null) {
      switch(key) {
        case 'D':
          if (flags[0] == false) {
            checkPressAccuracy((short) 1);
          }
          flags[0] = true;
          break;
        case 'F':
          if (flags[1] == false) {
            checkPressAccuracy((short) 2);
          }
          flags[1] = true;
          break;
        case 'J':
          if (flags[2] == false) {
            checkPressAccuracy((short) 3);
          }
          flags[2] = true;
          break;
        case 'K':
          if (flags[3] == false) {
            checkPressAccuracy((short) 4);
          }
          flags[3] = true;
          break;
      }
    }
  }

  public void keyReleased() {
    if (mp != null && bm != null && release_events != null) {
      switch(key) {
        case 'D':
          flags[0] = false;
          checkReleaseAccuracy((short) 1);
          break;
        case 'F':
          flags[1] = false;
          checkReleaseAccuracy((short) 2);
          break;
        case 'J':
          flags[2] = false;
          checkReleaseAccuracy((short) 3);
          break;
        case 'K':
          flags[3] = false;
          checkReleaseAccuracy((short) 4);
          break;
      }
    }
  }

  public void checkPressAccuracy(short i) {
    if(eventMap != null && eventMap.get(i) != null) {
      long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(i).peek().getTick());
      //only consider the score if the button pushed is near a note
      if (accuracy < MARGIN_OF_ERROR * 5) {
        if (accuracy <= MARGIN_OF_ERROR) {
          scores[0]++;
        } else if(accuracy <= MARGIN_OF_ERROR * 2) {
          scores[1]++;
        } else if(accuracy <= MARGIN_OF_ERROR * 3) {
          scores[2]++;
        } else if(accuracy <= MARGIN_OF_ERROR * 4) {
          scores[3]++;
        }
        
        event = eventMap.get(i).poll();
        event.setTick(event.getEndTick());
        event.addToQueue(release_events);
      }
    }
  }

  public void checkReleaseAccuracy(short i) {
    if(release_events != null && release_events.get(i) != null) {
      long accuracy = Math.abs(mp.getTickPosition() - release_events.get(i).poll().getTick());
  
      if (accuracy <= MARGIN_OF_ERROR) {
        scores[0]++;
      } else if(accuracy <= MARGIN_OF_ERROR * 2) {
        scores[1]++;
      } else if(accuracy <= MARGIN_OF_ERROR * 3) {
        scores[2]++;
      } else if(accuracy <= MARGIN_OF_ERROR * 4) {
        scores[3]++;
      }
    }
  }
  
  void checkTiming() {
    for(short i = 1; i <= 4; i++) {
      if(eventMap != null && eventMap.get(i) != null) {
        long acc = Math.abs(eventMap.get(i).peek().getTick() - mp.getTickPosition());
        
        if(acc > MARGIN_OF_ERROR * 4) {
          eventMap.get(i).poll();
          scores[4]++;
        }
      }
      
      if(release_events != null && release_events.get(i) != null) {
        long acc = Math.abs(release_events.get(i).peek().getTick() - mp.getTickPosition());
        
        if(acc > MARGIN_OF_ERROR * 4) {
          release_events.get(i).poll();
          scores[4]++;
        }
      }
    }
  }
}
