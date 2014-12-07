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
    if(offset < 0) {
      noStroke();
      fill(#000000);
      rect(width/2 - img.width/2, 0, img.width, height);
      offset++;
    } else if(justStarted && offset >= 0) {
      try {
        if(mp != null) mp.playSong();
      } catch(Exception e) {
        println(e);
      }
      justStarted = false;
    }
    
    checkMissTiming();
    
    if (img!=null) {
      //    if (offset < 0)
      //      offset = 0;
      //    else if (offset > (img.height - height))
      //      offset = img.height - height;
      //      
      if (mp != null && offset >= 0) {
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
        case 'd':
          if (flags[0] == false) {
            checkPressAccuracy((short) 1);
          }
          flags[0] = true;
          break;
        case 'f':
          if (flags[1] == false) {
            checkPressAccuracy((short) 2);
          }
          flags[1] = true;
          break;
        case 'j':
          if (flags[2] == false) {
            checkPressAccuracy((short) 3);
          }
          flags[2] = true;
          break;
        case 'k':
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
        case 'd':
          flags[0] = false;
          checkReleaseAccuracy((short) 1);
          break;
        case 'f':
          flags[1] = false;
          checkReleaseAccuracy((short) 2);
          break;
        case 'j':
          flags[2] = false;
          checkReleaseAccuracy((short) 3);
          break;
        case 'k':
          flags[3] = false;
          checkReleaseAccuracy((short) 4);
          break;
      }
    }
  }

  public void checkPressAccuracy(short i) {
    if(eventMap != null && eventMap.get(i) != null && eventMap.get(i).peek() != null) {
      long accuracy = Math.abs(mp.getTickPosition() - eventMap.get(i).peek().getTick());
      //only consider the score if the button pushed is near a note
      if (accuracy <= MARGIN_OF_ERROR * 4) {
        if (accuracy <= MARGIN_OF_ERROR) {
          scores[0]++;
          println("PERFECT");
        } else if(accuracy <= MARGIN_OF_ERROR * 2) {
          scores[1]++;
          println("GREAT");
        } else if(accuracy <= MARGIN_OF_ERROR * 3) {
          scores[2]++;
          println("GOOD");
        } else if(accuracy <= MARGIN_OF_ERROR * 4) {
          scores[3]++;
          println("BAD");
        }
        
        event = eventMap.get(i).poll();
        event.setTick(event.getEndTick());
        event.addToQueue(release_events);
      }
    }
  }

  public void checkReleaseAccuracy(short i) {
    if(release_events != null && release_events.get(i) != null && release_events.get(i).peek() != null) {
      long accuracy = Math.abs(mp.getTickPosition() - release_events.get(i).poll().getTick());
  
      if (accuracy <= MARGIN_OF_ERROR) {
        scores[0]++;
        println("PERFECT");
      } else if(accuracy <= MARGIN_OF_ERROR * 2) {
        scores[1]++;
        println("GREAT");
      } else if(accuracy <= MARGIN_OF_ERROR * 3) {
        scores[2]++;
        println("GOOD");
      } else if(accuracy <= MARGIN_OF_ERROR * 4) {
        scores[3]++;
        println("BAD");
      }
    }
  }
  
  void checkMissTiming() {
    for(short i = 1; i <= 4; i++) {
      if(eventMap != null && eventMap.get(i) != null && eventMap.get(i).peek() != null) {
        long acc = mp.getTickPosition() - eventMap.get(i).peek().getTick();

        if(acc > MARGIN_OF_ERROR * 4) {
          eventMap.get(i).poll();
          scores[4]++;
          println("MISS PRESS");
        }
      }
      
      if(release_events != null && release_events.get(i) != null && release_events.get(i).peek() != null) {
        long acc = mp.getTickPosition() - release_events.get(i).peek().getTick();
        
        if(acc > MARGIN_OF_ERROR * 4) {
          release_events.get(i).poll();
          scores[4]++;
          println("MISS RELEASE");
        }
      }
    }
  }
  
  int calculateScore() {
    return scores[0]*200 + scores[1]*150 + scores[2]*100 + scores[3]*50;
  }
}
