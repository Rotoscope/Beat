
import controlP5.*;

ControlP5 cp5;

PImage img = null;
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

  
  //  BeatMap bm = new BeatMap();
  //  
  //  PressTiming tm = new PressTiming((short)1,10L,250L,bm);
  //  bm.getMap().add(tm);
  //  bm.getMap().add(new PressTiming((short)2,20L,100L,bm));
  //  bm.getMap().add(new PressTiming((short)3,320L,1240L,bm));
  //  bm.getMap().add(new PressTiming((short)3,320L,1240L,bm));
  //  bm.getMap().add(new PressTiming((short)4,200L,500L,bm));
  //  
  //  bm.setDuration(1240L + 320L);
  //  
  //  image = bm.makeImage();
}

void draw() {
  if(img!=null)
  {
    image(img,0,height - img.height+offset);
  }
}

public void songBrowse() {
  selectInput("Select a midi file", "songSelected");
}

public void bmBrowse() {
  selectInput("Select a midi file", "bmSelected");
}

public void playSong() {
  try {
    mp.playSong();
  } catch(Exception e) {
    System.out.println(e);
  }
}

public void stopSong() {
  try {
    mp.stopSong();
  } catch(Exception e) {
    System.out.println(e);
  }
}

void songSelected(File songFile) {
  if (songFile != null) {
    println("You selected" + songFile.getAbsolutePath());

    try {   
      mp = new MidiParser(songFile);
      mp.parseMidiFile();
      for(int i = 0; i < mp.numOfTracks(); i++) {
        if(mp.getTrackTiming(i).noteList.size() > 0) {
          mp.saveNoteTimings(i, "miditest" + i + ".bm");
        }
      }
      
      println("Saved to file");
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
    }
  } else {
    println("User hit cancel or esc");
  }
}

void keyPressed(){
  if(key == CODED) {
    if(img != null) {
      switch(keyCode) {
        case UP:
          offset += speed;
          break;
        case DOWN:
          offset -= speed;
          break;
      }
    }
  }
}
