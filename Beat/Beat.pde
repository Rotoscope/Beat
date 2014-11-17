
import controlP5.*;

ControlP5 cp5;

PImage img = null;

MidiParser mp;
BeatMap bm;

void setup() {
  size(800, 600);

  cp5 = new ControlP5(this);

  Group gMainMenu = cp5.addGroup("main menu");

  cp5.addBang("songBrowse")
    .setGroup(gMainMenu)
      .setPosition(width/2-40, 20)
        .setSize(80, 20)
          .setLabel("Browse For Songs")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;
  
  cp5.addButton("playSong")
    .setPosition(     /*need code********/)
      .setSize(   /*******need code ********/)
        .setLabel("Play the song")
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
    image(img,0,0);
}

public void songBrowse() {
  selectInput("Select a midi file", "songSelected");
}

public void playSong() {
  try {
//    mp.getSequencer().start();          //plays the midi file
//    mp.getSequencer().stop();           //stops playing the midi file
  } catch(Exception e) {
    System.out.println(e);
  }
}

void songSelected(File songFile) {
  if (songFile != null) {
    println("You selected" + songFile.getAbsolutePath());

    try {   
      bm = new BeatMap();
      bm.loadBeatMap(songFile);
      img = bm.makeImage();
//      mp = new MidiParser(songFile);
//      mp.parseMidiFile();
//      mp.saveNoteTimings(1, "miditest.bm");
    } 
    catch(Exception e) {
      System.out.println(e);
    }
  } else {
    println("User hit cancel or esc");
  }
}

