
import controlP5.*;

ControlP5 cp5;

void setup() {
  size(800,600);
  
  cp5 = new ControlP5(this);
  
  Group gMainMenu = cp5.addGroup("main menu");
}

void draw() {

}


/* Stanley's Debug Code */

/*
import java.io.*;

MidiParser mp;

void setup() {
  size(800,600);

 try {   
  mp = new MidiParser(new File("teddybear.mid"));
  mp.parseMidiFile();
  mp.saveNoteTimings(2, "miditest.txt");
  
 } catch(Exception e) {
   System.out.println(e);
 }

}
*/
