/*
  Name: Beat
  Authors: Lowell Milliken and Stanley Seeto
  
  Description: This application takes midi files as input and generates
    beatmaps that can be customized and saved locally. It can then read
    those beatmap files and allow the user play a simple rhythm game.
  
    This is the main Processing class. This class contains the global
    variables and objects as well as methods that are forced to be in
    this class by the design of the Processing library (selectInput callbacks).
    
    Draw and keyboard event handling methods here just call the appropriate
    method of the current GUI.
*/
import controlP5.*;
import java.util.Set;

ControlP5 cp5;

PImage img = null;
int backgroundColor = #98B6EA;
String projectName = "Beats";
int offset = 0;
int speed = 5;
int buttonw = 150;
int lineh = 20;
boolean justStarted = false;

Map<Short,Queue<BeatMapEvent>> eventMap;  //used for play
Map<Integer,Short> hotkeys;

boolean newSong, newBM;
boolean tryMode = false;
final String hotkeyPath = "Data" + File.separator + "hotkeys.txt";

MidiParser mp;
BeatMap bm;
BeatGUIBase currentGUI, menu, customize, option;
Authoring author;
Select select;
Play play;

// create and initialize main cp5 and GUI objects
void setup() {
  size(800, 600, P3D);
  newSong = false; newBM = false;
  
  cp5 = new ControlP5(this);
  PFont p = createFont("Verdana",9);
  cp5.setControlFont(p);

  menu = new MainMenu(cp5);
  menu.initialize();
  currentGUI = menu;
  
  select = new Select(cp5);
  select.init();
  select.hide();
  
  author = new Authoring(cp5);
  author.init();
  author.hide();
  
  option = new Option(cp5);
  option.init();
  option.hide();
  
  playmenu = new PlayMenu(cp5);
  playmenu.init();
  playmenu.hide();
  
  hotkeys = new HashMap(13);
  loadHotkeys();
}

// call draw for current GUI
void draw() {
  currentGUI.draw();
}

// this needs to be here because of how selectInput works
// Load a midi file and parse into beatmaps and images
void songSelected(File songFile) {
  if (songFile != null) {
    println("You selected " + songFile.getAbsolutePath());

    String fs = File.separator;
    String path = sketchPath + fs + "Data" + fs + "Beatmaps" + fs;

    try {   
      mp = new MidiParser(songFile);
      mp.setLocationCount(author.locCount);
      mp.parseMidiFile();
      
      int trackcount = 0;
      for (int i = 0; i < mp.numOfTracks (); i++) {
        if (mp.getTrackTiming(i).getNumEventsToFile() > 0) {
          //mp.saveNoteTimings(i+1, path + songFile.getName() + "-" + (i+1) + ".bm");
          //println("Saved to file");
          BeatMap bm = mp.makeBeatMap(i+1);
          author.beatmaps.add(bm);
          author.images.add(bm.makeImage());
        }
      }
      
      select.resetSongMetaData();
      select.setSongMetaData();
      
      String songText = songText = mp.getFilePath() + "\n\n" + select.title + "\n\n" + select.author + "\n\n" + select.copyright + "\n\n" + select.date + "\n\n" + select.comment;
      long sec = author.beatmaps.get(0).getDuration();
      songText += "\n\nApprox Length in Ticks: " + sec;//+ sec/60 + ":" + sec%60;
      author.songArea.setText(songText);
      author.groupS.show();
    } 
    catch(Exception e) {
      System.out.println(e);
    }
  } else {
    println("User hit cancel or esc");
  }
}

// load a midi file
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

// load a beatmap file
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

void loadHotkeys() {
  File f = new File(hotkeyPath);
  if(f.exists() && !f.isDirectory()) {
    loadHotKeyFile(f);
  } else {
    loadDefaultKeys();
    saveHotKeys(f);
  }
}

void loadDefaultKeys() {
  hotkeys.put((int) 'a', (short) 1);
  hotkeys.put((int) 's', (short) 2);
  hotkeys.put((int) 'd', (short) 3);
  hotkeys.put((int) 'r', (short) 4);
  hotkeys.put((int) 'f', (short) 5);
  hotkeys.put((int) 'g', (short) 6);
  hotkeys.put((int) 'h', (short) 7);
  hotkeys.put((int) 'j', (short) 8);
  hotkeys.put((int) 'u', (short) 9);
  hotkeys.put((int) 'k', (short) 10);
  hotkeys.put((int) 'l', (short) 11);
  hotkeys.put((int) ';', (short) 12);
  hotkeys.put((int) 'p', (short) 13);
}

void saveHotKeys(File f) {
  PrintWriter output = createWriter(f);

  Set<Integer> keySet = hotkeys.keySet();
  Iterator<Integer> keyIterator= keySet.iterator();
  
  while(keyIterator.hasNext()) {
    Integer i = keyIterator.next();
    
    output.println(i.toString() + " " + hotkeys.get(i));
  }
  
  output.flush();
  output.close();
}

void loadHotKeyFile(File f) {
  try {
    BufferedReader reader = new BufferedReader(new FileReader(f));
    String line;
    
    while((line = reader.readLine()) != null) {
      String[] tokens = line.split(" ");
      
      hotkeys.put(Integer.parseInt(tokens[0]), (short) Integer.parseInt(tokens[1]));
    }
  } catch(Exception e) {
    println("loadHotKeys() error");
    println(e);
  }
}
