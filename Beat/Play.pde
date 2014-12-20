/*
  Name: Play
  Authors: Lowell Milliken and Stanley Seeto
  
  Description: 
    This class handles the GUI for the Play mode as well as
    input events. This class keeps track of score information while
    a user is playing and displays feedback for hits (correctly timing
    a button press) and misses (the opposite).
*/
public class Play extends BeatGUIBase {
  final long MARGIN_OF_ERROR = 20;
  final int timingOffset = 5;
  
  boolean miss, paused;
  int[] scores;
  boolean[] flags;
  int[] hitFlags;
  Map<Short,Queue<BeatMapEvent>> release_events;
  BeatMapEvent event;

  PFont pf;

  public Play(ControlP5 cp5) {
    super(cp5, cp5.addGroup("PLAY"));
    pf = createFont("Arial", 24);
    println(bm.getLocationNumber());
  }

  public void initialize() {
    cp5.addBang("playToPlayMenu")
      .plugTo(this)
        .setGroup(group)
          .setPosition(25, height - 55)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("MENU")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
                    
    paused = false;
    
    if(bm != null) {
      int j = (int) bm.getLocationNumber();
      flags = new boolean[j];
      hitFlags = new int[j];
    
      for(short i = 0; i < j; i++) {
        flags[i] = false;
        hitFlags[i] = 0;
      }
    }
    scores = new int[5];
    miss = false;
    
    release_events = new HashMap<Short,Queue<BeatMapEvent>>();
  }

  public void draw() {
    if(!paused) {
      background(backgroundColor);
      
      pushMatrix();
      translate(width/2, height, 0);
      
      if (bm.in3d) {
        translate(0,-lineh,0);
        rotateX(bm.xAngle);
        rotateY(bm.yAngle);
        rotateZ(bm.zAngle);
      }
      
      if(offset < 0) {
        noStroke();
        fill(#000000);
        rect(-img.width/2, -height, img.width, height);
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
        if (mp != null && offset >= 0) {
          offset = (int)(mp.getTickPosition()*bm.pixelsPerTick);
        }
        
        
        if(bm.boxOn) {
          pushMatrix();
          stroke(bm.boxColor);
          translate(0,offset,bm.boxZ);
          box(img.width,img.height,20);
          popMatrix();
        }
  
        image(img, -img.width/2, -img.height+offset - lineh + timingOffset);
  
        // draw timing line
        stroke(#98F79E);
        strokeWeight(4);
        line(-img.width/2, -lineh, +img.width/2, -lineh);
        
        if(bm.in3d) {
          pushMatrix();
          translate(0,-10,0);
        }
        
        flashLine();
        showHotKeys();
        
        if(bm.in3d){
          popMatrix();
        }
      }
      
      popMatrix();
            
      checkMissTiming();   
      if(miss) {
        displayAccuracy("MISS");
        miss = false;
      }
      
      displayScore();
    }
  }

  public void keyPressed() {
    Short i;
    
    if (mp != null && bm != null && eventMap != null) {
      if(key == CODED)
        i = hotkeys.get(((int) keyCode) + 65535);
      else
        i = hotkeys.get((int) key);
        
      if(i != null) {
        if(i == 13) pauseGame();
        else if(i <= bm.getLocationNumber()) {
          if(flags[(int) (i - 1)] == false) {
            checkPressAccuracy(i);
          }
          flags[(int) (i - 1)] = true;
        }
      }
    }
  }

  public void keyReleased() {
    Short i;
    
    if (mp != null && bm != null && release_events != null) {
      if(key == CODED)
        i = hotkeys.get((int) keyCode + 65535);
      else
        i = hotkeys.get((int) key);
      
      if(i != null && i != 13 && i <= bm.getLocationNumber()) {
        flags[i - 1] = false;
        checkReleaseAccuracy(i);
      }
    }
  }
  
  /*
    public void keyPressed() {
    short i = 100;

    if (mp != null && bm != null && eventMap != null) {
      if(key == CODED)
        if(hotkeys.containsKey((int) keyCode + 65535))
          i = hotkeys.get((int) keyCode + 65535);
      else
        if(hotkeys.containsKey((int) key))
          i = hotkeys.get((int) key);
        
      if(i == 13) playToPlayMenu();
      else if(i != 100) {
        if(flags[(int) (i - 1)] == false) {
          checkPressAccuracy(i);
        }
        flags[(int) (i - 1)] = true;
      }
    }
  }

  public void keyReleased() {
    short i = 100;
    
    if (mp != null && bm != null && release_events != null) {
      if(key == CODED)
        if(hotkeys.containsKey((int) keyCode + 65535))
          i = hotkeys.get((int) keyCode + 65535);
      else
        if(hotkeys.containsKey((int) key))
          i = hotkeys.get((int) key);
      
      if(i != 100 && i != 13 && i <= bm.getLocationNumber()) {
        flags[i - 1] = false;
        checkReleaseAccuracy(i);
      }
    }
  }
  */

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
        
        hitFlags[i-1] = 5;
        
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
    paused = true;
    mp.pauseSong();
  }
  
  void resumeGame() throws Exception {
    paused = false;
    mp.resumeSong();
  }
  
  void restartGame() throws Exception {
//    eventMap = bm.getEventQueues();
    mp.restartSong();
    mp.pauseSong();
    offset = -800;
    justStarted = true;
    paused = false;
    resetScore();
  }
  
  void resetScore() {
    for(int i = 0; i < scores.length; i++)
      scores[i] = 0;
  }
  
  void playToPlayMenu() {
    pauseGame();
    currentGUI.hide();
    currentGUI = playmenu;
    currentGUI.show();
  }
  
  void showHotKeys() {
    int labelWidth = img.width/bm.getLocationNumber();
    int xStart = -img.width/2;
    int yStart = -lineh;
    Set<Integer> keySet = hotkeys.keySet();
    
    for(int i = 0; i < bm.getLocationNumber(); i++) {
      strokeWeight(1);
      stroke(#000000);
      fill(#FFFFFF);
      rect(xStart + i*labelWidth, yStart, labelWidth, lineh);
  
      Iterator<Integer> keyIterator = keySet.iterator();
      while(keyIterator.hasNext()) {
        Integer k = keyIterator.next();
        short j = hotkeys.get(k);
        fill(#000000);
        //textSize(24);
        textFont(pf);
        textAlign(LEFT,TOP);
        if(j == (short) i + 1)
          text((char) k.intValue(), xStart + i*(labelWidth), yStart);
      }
    } 
  }
  
  // display a column flash for hit feedback
  void flashLine() {
    int j = bm.getLocationNumber();
    for(int i = 0; i < j; i++) {
      if(hitFlags[i] > 0) {
        noStroke();
        fill((bm.colors[i] & 0xffffff) | (126 << 24));
        strokeWeight(4);
        int x =  -img.width/2 + i * img.width/j;
        pushMatrix();
        translate(0,50,0);
        rect(x,-img.height,img.width/j, img.height);
        popMatrix();
        
        hitFlags[i]--;
      }
    }
  } 
}
