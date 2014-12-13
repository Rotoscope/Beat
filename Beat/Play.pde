public class Play extends BeatGUIBase {
  final long MARGIN_OF_ERROR = 10;
  boolean miss;
  int[] scores;
  boolean[] flags;
  Map<Short,Queue<BeatMapEvent>> release_events;
  BeatMapEvent event;

  public Play(ControlP5 cp5) {
    super(cp5, cp5.addGroup("PLAY"));
    
    cp5.addBang("songMenu")
      .plugTo(this)
        .setGroup(group)
          .setPosition(25, 20)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("MENU")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
  }

  public void initialize() {
    if(bm != null) {
      int j = (int) bm.getLocationNumber();
      flags = new boolean[j];
    
      for(short i = 0; i < j; i++)
        flags[i] = false;
    }
    scores = new int[5];
    miss = false;
    
    release_events = new HashMap<Short,Queue<BeatMapEvent>>();
  }

  public void draw() {
    background(backgroundColor);
    
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
    
    checkMissTiming();   
    if(miss) {
      displayAccuracy("MISS");
      miss = false;
    }
    
    displayScore();
  }

  public void keyPressed() {
    short i;
    
    if (mp != null && bm != null && eventMap != null) {
      if(key == CODED)
        i = hotkeys.get(((int) keyCode) + 65535);
      else
        i = hotkeys.get((int) key);
        
      if(i == 13) pauseGame();
      else {
        if(flags[(int) (i - 1)] == false) {
          checkPressAccuracy(i);
        }
        flags[(int) (i - 1)] = true;
      }
    }
  }

  public void keyReleased() {
    short i;
    
    if (mp != null && bm != null && release_events != null) {
      if(key == CODED)
        i = hotkeys.get((int) keyCode + 65535);
      else
        i = hotkeys.get((int) key);
      
      if(i != 13) {
        flags[i - 1] = false;
        checkReleaseAccuracy(i);
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
          displayAccuracy("PERFECT");
        } else if(accuracy <= MARGIN_OF_ERROR * 2) {
          scores[1]++;
          println("GREAT");
          displayAccuracy("GREAT");
        } else if(accuracy <= MARGIN_OF_ERROR * 3) {
          scores[2]++;
          println("GOOD");
          displayAccuracy("GOOD");
        } else if(accuracy <= MARGIN_OF_ERROR * 4) {
          scores[3]++;
          println("BAD");
          displayAccuracy("BAD");
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
        displayAccuracy("PERFECT");
      } else if(accuracy <= MARGIN_OF_ERROR * 2) {
        scores[1]++;
        println("GREAT");
        displayAccuracy("GREAT");
      } else if(accuracy <= MARGIN_OF_ERROR * 3) {
        scores[2]++;
        println("GOOD");
        displayAccuracy("GOOD");
      } else if(accuracy <= MARGIN_OF_ERROR * 4) {
        scores[3]++;
        println("BAD");
        displayAccuracy("BAD");
      } else {
        scores[4]++;
        println("RELEASE MISS");
        displayAccuracy("MISS");
      }
    }
  }
  
  void checkMissTiming() {
    for(short i = 1; i <= bm.getLocationNumber(); i++) {
      if(eventMap != null && eventMap.get(i) != null && eventMap.get(i).peek() != null) {
        long acc = mp.getTickPosition() - eventMap.get(i).peek().getTick();

        if(acc > MARGIN_OF_ERROR * 4) {
          eventMap.get(i).poll();
          scores[4]++;
          println("MISS PRESS");
          miss = true;
        }
      }
      
      if(release_events != null && release_events.get(i) != null && release_events.get(i).peek() != null) {
        long acc = mp.getTickPosition() - release_events.get(i).peek().getTick();
        
        if(acc > MARGIN_OF_ERROR * 4) {
          release_events.get(i).poll();
          scores[4]++;
          println("MISS RELEASE");
          miss = true;
        }
      }
    }
  }
  
  int calculateScore() {
    return scores[0]*200 + scores[1]*150 + scores[2]*100 + scores[3]*50;
  }
  
  void displayAccuracy(String s) {
    textSize(32);
    fill(#8FBC8F);
    textAlign(CENTER);
    text(s, width/2, height/4);//, width/2 + img.width/2, 40);
  }
  
  void displayScore() {
    textSize(24);
    fill(#A9DFA7);
    text("SCORE:\n" + calculateScore(), width*5/6, height/6);
  }
  
  void pauseGame() {
    mp.pauseSong();
  }
  
  void resumeGame() throws Exception {
    mp.resumeSong();
  }
  
  void songMenu() {
    
  }
}
