public class MainMenu extends BeatGUIBase {

  boolean in3d = false;
  
  public MainMenu(ControlP5 cp5) {
    super(cp5, cp5.addGroup("MENU"));
  }

  public void initialize() {
    cp5.addButton("playSong")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 50)
            .setSize(buttonw, 20)
              .setLabel("Play the song")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addButton("stopSong")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 80)
            .setSize(buttonw, 20)
              .setLabel("Stop the song")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addBang("bmBrowseMM")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 110)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Browse For Beatmaps")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;

    cp5.addBang("songBrowseNoParseMM")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 20)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Load Song for Playing")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;

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
  }

  public void draw() {
    background(backgroundColor);

    textSize(32);
    fill(#F56707);
    textAlign(CENTER);
    text(projectName, width/2, height - 50); 

    if (img!=null)
    {
      //    if (offset < 0)
      //      offset = 0;
      //    else if (offset > (img.height - height))
      //      offset = img.height - height;
      //      
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
    mp.stopSong();
  }
  
  public void authoring() {
    currentGUI.hide();
    currentGUI = author;
    currentGUI.show();
  }
  
  public void playing() {
    currentGUI.hide();
    currentGUI = select;
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
}

