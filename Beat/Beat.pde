/*
  
*/
import controlP5.*;

ControlP5 cp5;

PImage img = null;
int backgroundColor = #98B6EA;
String projectName = "Beats";
int offset = 0;
int speed = 5;
int buttonw = 100;

MidiParser mp;
BeatMap bm;

void setup() {
  size(800, 600);

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
    mp.playSong();
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
  if (key == CODED) {
    if (img != null) {
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
  }
}

