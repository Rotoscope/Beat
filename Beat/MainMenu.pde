/*
  Name: MainMenu
  Authors: Lowell Milliken and Stanley Seeto
  
  Description: 
    This class handles the GUI for the MainMenu mode as well as
    input events. If there is a currently selected global beatmap
    it is displayed as well.
*/
public class MainMenu extends BeatGUIBase {

  boolean in3d = false;
  PImage mmBackground;
  
  public MainMenu(ControlP5 cp5) {
    super(cp5, cp5.addGroup("MENU"));
  }

  public void initialize() {
    
    cp5.addBang("authoring")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 140)
            .setSize(buttonw, 20)
              .setLabel("Authoring Mode")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;
              
     cp5.addBang("playing")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 170)
            .setSize(buttonw, 20)
              .setLabel("Play Mode")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;
                  
     cp5.addBang("optionsMM")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 200)
            .setSize(buttonw, 20)
              .setLabel("Options")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;
                  
      mmBackground = loadImage("mainBackground.jpg");
  }

  public void draw() {
    background(backgroundColor);
    image(mmBackground, 0,0, width, height);

    if (img!=null)
    {
      if (mp != null) {
        offset = (int)(mp.getTickPosition()*bm.pixelsPerTick);
      }

      pushMatrix();
      translate(img.width/2, height, 0);
      
      if(in3d) {
        rotateX(bm.xAngle);
        rotateY(bm.yAngle);
        rotateZ(bm.zAngle);
      }
        
      image(img, -img.width/2, -img.height+offset - lineh);

      // draw timing line
      stroke(#98F79E);
      strokeWeight(4);
      line(-img.width/2, -lineh, img.width/2, -lineh);
      popMatrix();
    }
  }


  public void songBrowseNoParseMM() {
    selectInput("Select a midi file", "songSelectedNoParse");
  }

  // callback for beatmap browsing
  public void bmBrowseMM() {
    selectInput("Select a beatmap file", "bmSelected");
  }

  public void playSong() {
    try {
      if (mp != null)
        mp.playSong();
      else
        System.out.println("No song was selected");
    } 
    catch(Exception e) {
      System.out.println(e);
    }
  }

  public void stopSong() {
    if(mp != null)
      mp.stopSong();
  }
  
  public void authoring() {
    currentGUI.hide();
    author.init();
    currentGUI = author;
    currentGUI.show();
  }
  
  public void playing() {
    currentGUI.hide();
    select.init();
    currentGUI = select;
    currentGUI.show();
  }
  
  public void optionsMM() {
    currentGUI.hide();
    option.init();
    currentGUI = option;
    currentGUI.show();
  }

  public void keyPressed() {
    if (img != null) {
      if (key == CODED) {
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
  
  public void keyReleased() {
  }
  
  public void show() {
    bm = null;
    mp = null;
    super.show();
  }
}
