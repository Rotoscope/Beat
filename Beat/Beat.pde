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
int lineh = 20;

Map<Short,Queue<BeatMapEvent>> eventMap;  //used for play
boolean newSong, newBM;

MidiParser mp;
BeatMap bm;
BeatGUIBase currentGUI, menu, play, select, customize;
Authoring author;

void setup() {
  size(800, 600, P3D);
  newSong = false; newBM = false;
  
  cp5 = new ControlP5(this);

  menu = new MainMenu(cp5);
  menu.initialize();
  currentGUI = menu;
  
  select = new Select(cp5);
  select.initialize();
  select.hide();
  
  play = new Play(cp5);
  play.initialize();
  play.hide();
  
  author = new Authoring(cp5);
  author.initialize();
  author.hide();
}

void draw() {
  currentGUI.draw();
}

// this needs to be here because of how selectInput works
void songSelected(File songFile) {
  if (songFile != null) {
    println("You selected " + songFile.getAbsolutePath());

    String fs = File.separator;
    String path = sketchPath + fs + "Data" + fs + "Beatmaps" + fs;

    try {   
      mp = new MidiParser(songFile);
      mp.parseMidiFile();
      
      int trackcount = 0;
      for (int i = 0; i < mp.numOfTracks (); i++) {
        if (mp.getTrackTiming(i).getNumEventsToFile() > 0) {
          mp.saveNoteTimings(i+1, path + songFile.getName() + "-" + (i+1) + ".bm");
          println("Saved to file");
          BeatMap bm = mp.makeBeatMap(i+1);
          author.beatmaps.add(bm);
          author.images.add(bm.makeImage());
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

void songSelectedNoParse(File songFile) {
  if (songFile == null) {
    println("User hit cancel or esc");
  } else if(songFile.isDirectory()) {
    println("\"" + songFile + "\" is a directory.");
  } else if(songFile.getPath().endsWith(".mid")) {
    println("You selected " + songFile.getAbsolutePath());
    
    try {   
      mp = new MidiParser(songFile);
      newSong = true;
    } 
    catch(Exception e) {
      System.out.println(e);
    }
  } else {
    println(songFile.getPath() + " is invalid.");
    println("Enter a '.mid' file.");
  }
}

void bmSelected(File bmFile) {
  if (bmFile == null) {
    println("User hit cancel or esc");
  } else if(bmFile.isDirectory()) {
    println("\"" + bmFile + "\" is a directory.");
  } else if(bmFile.getPath().endsWith(".bm")) {
    println("You selected " + bmFile.getAbsolutePath());

    try {   
      bm = new BeatMap();
      bm.loadBeatMap(bmFile);
      img = bm.makeImage();
      offset = 0;
      eventMap = bm.getEventQueues();
      newBM = true;
    } 
    catch(Exception e) {
      System.out.println(e);
      //e.printStackTrace();
    }
    
  } else {
    println(bmFile.getPath() + " is invalid.");
    println("Enter a '.bm' file.");
  }
}

void keyPressed() {
  currentGUI.keyPressed();
}

void keyReleased() {
  currentGUI.keyReleased();
}
