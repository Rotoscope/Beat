/*
  
*/
import controlP5.*;
import java.util.LinkedList;

ControlP5 cp5;

PImage img = null;
int backgroundColor = #98B6EA;
String projectName = "Beats";
int offset = 0;
int speed = 5;
int buttonw = 100;

String mode;
boolean[] flags;  //is button pushed down
Queue<BeatMapEvent>[] events, release_events;
int[] scores;
final int MARGIN_OF_ERROR = 10;

MidiParser mp;
BeatMap bm;

void setup() {
  size(800, 600);

  mode = "SELECT";
  flags = new boolean[4];
  for(int i = 0; i < 4; i++)
    flags[i] = false;
  scores = new int[5];
  
  cp5 = new ControlP5(this);

  Group gMainMenu = cp5.addGroup("main menu");

  cp5.addBang("songBrowse")
    .setGroup(gMainMenu)
      .setPosition(width/2-buttonw/2, 20)
        .setSize(buttonw, 20)
          .setLabel("Browse For Songs")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;

  cp5.addButton("playSong")
    .setGroup(gMainMenu)
      .setPosition(width/2-buttonw/2, 50)
        .setSize(buttonw, 20)
          .setLabel("Play the song")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;

  cp5.addButton("stopSong")
    .setGroup(gMainMenu)
      .setPosition(width/2-buttonw/2, 80)
        .setSize(buttonw, 20)
          .setLabel("Stop the song")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;

  cp5.addBang("bmBrowse")
    .setGroup(gMainMenu)
      .setPosition(width/2-buttonw/2, 110)
        .setSize(buttonw, 20)
          .setLabel("Browse For Beatmaps")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;
              
              
  println(sketchPath);
  //  cp5.addTextlabel("title")
  //    .setText(projectName)
  //      .setPosition(width/2, height-50)
  //        .setColorValue(#F56707)
  //         .setFont(createFont("Georgia",20))
  //         .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
  //          ;
}

void draw() {
  background(backgroundColor);

    textSize(32);
    fill(#F56707);
    textAlign(CENTER);
    text(projectName, width/2, height - 50); 
    
  if (img!=null)
  {
    if (offset < 0)
      offset = 0;
    else if (offset > (img.height - height))
      offset = img.height - height;

    image(img, 0, height - img.height+offset);
  }
}

// callback for song browsing
public void songBrowse() {
  selectInput("Select a midi file", "songSelected");
}

// callback for beatmap browsing
public void bmBrowse() {
  selectInput("Select a beatmap file", "bmSelected");
}

public void playSong() {
  try {
    if(mp != null)
      mp.playSong();
    else
      System.out.println("No song was selected");
  } 
  catch(Exception e) {
    System.out.println(e);
  }
}

public void stopSong() {
  mp.stopSong();
}

void songSelected(File songFile) {
  if (songFile != null) {
    println("You selected " + songFile.getAbsolutePath());

    String fs = File.separator;
    String path = sketchPath + fs + "Data" + fs + "Beatmaps" + fs;
    try {   
      mp = new MidiParser(songFile);
      mp.parseMidiFile();
      for (int i = 0; i < mp.numOfTracks (); i++) {
        if (mp.getTrackTiming(i).getNumEventsToFile() > 0) {
          mp.saveNoteTimings(i+1, path + songFile.getName() + "-" + (i+1) + ".bm");
          println("Saved to file");
        }
      }
    } 
    catch(Exception e) {
      System.out.println(e);
    }
  } else {
    println("User hit cancel or esc");
  }
}

void bmSelected(File bmFile) {
  if (bmFile != null) {
    println("You selected" + bmFile.getAbsolutePath());

    try {   
      bm = new BeatMap();
      bm.loadBeatMap(bmFile);
      img = bm.makeImage();
      offset = 0;
//      events = bm.getMap();
      release_events = new Queue[events.length];
      for(int i = 0; i < release_events.length; i++)
        release_events[i] = new LinkedList<BeatMapEvent>();
    } 
    catch(Exception e) {
      System.out.println(e);
      //e.printStackTrace();
    }
  } else {
    println("User hit cancel or esc");
  }
}

void keyPressed() {
  if(mode.equals("SELECT") && img != null) {
    if(key == CODED) {
      switch(keyCode) {
        case UP:
          offset += speed;
          break;
        case DOWN:
          offset -= speed;
          break;
      }
  
      println(offset);
    }
  } else if(mode.equals("PLAY") && mp != null && bm != null && events != null) {
    switch(key) {
      case 'D':
        if(flags[0] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[0].peek().getTick());
          //only consider the score if the button pushed is near a note
          if(accuracy < MARGIN_OF_ERROR * 5) {
            if(accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;
            }
            release_events[0].add(events[0].poll());
          }
        }
        flags[0] = true;
        break;
      case 'F':
        if(flags[1] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[1].peek().getTick());

          if(accuracy < MARGIN_OF_ERROR * 5) {
            if(accuracy <= MARGIN_OF_ERROR) {
              scores[1]++;
            }
            release_events[1].add(events[1].poll());
          }
        }
        flags[1] = true;
        break;
      case 'J':
        if(flags[2] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[2].peek().getTick());

          if(accuracy < MARGIN_OF_ERROR * 5) {
            if(accuracy <= MARGIN_OF_ERROR) {
              scores[2]++;
            }
            release_events[2].add(events[2].poll());
          }
        }
        flags[2] = true;
        break;
      case 'K':
        if(flags[3] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[3].peek().getTick());

          if(accuracy < MARGIN_OF_ERROR * 5) {
            if(accuracy <= MARGIN_OF_ERROR) {
              scores[3]++;
            }
            release_events[3].add(events[3].poll());
          }
        }
        flags[3] = true;
        break;
    }
  }
}

void keyReleased() {
  if(mode.equals("PLAY") && mp != null && bm != null) {
    switch(key) {
      case 'D':
        flags[0] = false;
        if(!release_events[0].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[0].poll().getEndTick());
          
          if(accuracy <= MARGIN_OF_ERROR) {
            scores[0]++;  //scores are rated on pressing and releasing on time
          }
        }
        break;
      case 'F':
        flags[1] = false;
        if(!release_events[1].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[1].poll().getEndTick());
          
          if(accuracy <= MARGIN_OF_ERROR) {
            scores[1]++;
          }
        }
        break;
      case 'J':
        flags[2] = false;
        if(!release_events[2].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[2].poll().getEndTick());
          
          if(accuracy <= MARGIN_OF_ERROR) {
            scores[2]++;
          }
        }
        break;
      case 'K':
        flags[3] = false;
        if(!release_events[3].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[3].poll().getEndTick());
          
          if(accuracy <= MARGIN_OF_ERROR) {
            scores[3]++;
          }
        }
        break;
    }
  }
}
