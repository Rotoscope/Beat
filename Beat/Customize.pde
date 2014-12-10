class Customize extends BeatGUIBase {

  private BeatMap beatmap = null;
  private PImage image = null;

  private boolean in3d = false;
  // rotation angles for 3d image                         
  private float xAngle = PI/3.0;
  private float yAngle = 0;//PI/3.0;
  private float zAngle = 0;

  private int offset = 0;
  private int speed = 20;
  
  private boolean boxOn = true;
  private int boxColor = #DE0707;
  private int boxZ = -20;

  Group group3d;

  public Customize(ControlP5 cp5, BeatMap beatmap) {
    super(cp5, cp5.addGroup("CUSTOMIZE"));
    this.beatmap = beatmap;
    image = beatmap.makeImage();
  }

  public void initialize() {

    cp5.addBang("toggle3d")
      .plugTo(this)
        .setGroup(group)
          .setPosition(buttonw/2, 50)
            .setSize(buttonw, 20)
              .setLabel("3d ON/OFF")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    group3d = cp5.addGroup("group3d");
    group3d.hide();

    cp5.addSlider("x_Angle")
      .plugTo(this)
        .setGroup(group3d)
          .setPosition(buttonw/2 + buttonw + 10, 20)
            .setRange(-45, 90)
              ;
    cp5.addSlider("y_Angle")
      .plugTo(this)
        .setGroup(group3d)
          .setPosition(buttonw/2 + buttonw + 10, 40)
            .setRange(-45, 45)
              ;
    cp5.addSlider("z_Angle")
      .plugTo(this)
        .setGroup(group3d)
          .setPosition(buttonw/2 + buttonw + 10, 60)
            .setRange(-45, 45)
              ;

    cp5.addBang("resetAngles")
      .plugTo(this)
        .setGroup(group3d)
          .setPosition(buttonw/2 + buttonw + 10, 80)
            .setSize(buttonw, 20)
              .setLabel("Reset Angles")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;  


    cp5.addBang("confirmC")
      .plugTo(this)
        .setGroup(group)
          .setPosition(buttonw/2 + 10, height-30)
            .setSize(buttonw, 20)
              .setLabel("Confirm Changes")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addBang("cancelC")
      .plugTo(this)
        .setGroup(group)
          .setPosition(buttonw/2 + 20 + buttonw, height-30)
            .setSize(buttonw, 20)
              .setLabel("Cancel Changes")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;
                  
     cp5.addButton("playSongC")
      .plugTo(this)
        .setGroup(group)
          .setPosition(buttonw/2 + 30 + buttonw*2, height-30)
            .setSize(buttonw, 20)
              .setLabel("Play the song")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addButton("stopSongC")
      .plugTo(this)
        .setGroup(group)
          .setPosition(buttonw/2 + 35 + buttonw*3, height-30)
            .setSize(buttonw, 20)
              .setLabel("Stop the song")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;
  }

  public void draw() {
    background(backgroundColor);

    if (image!=null)
    {
      pushMatrix();
      translate(width - image.width/2, height, 0);
      
      if(mp.isPlaying())
        offset = (int)(mp.getTickPosition()*beatmap.pixelsPerTick);
        
      if (in3d) {
        rotateX(xAngle);
        rotateY(yAngle);
        rotateZ(zAngle);
        pushMatrix();
        
        if(boxOn)
        stroke(boxColor);
        translate(0,offset,boxZ);
        box(image.width,image.height,20);
        popMatrix();
      }

      image(image, -image.width/2, -image.height+offset - lineh);

      // draw timing line
      stroke(#98F79E);
      strokeWeight(4);
      line(-image.width/2, -lineh, image.width/2, -lineh);
      popMatrix();
    }
  }

  public void keyPressed() {
    if (image != null) {
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

  public void toggle3d() {
    in3d = !in3d;
    if (in3d) group3d.show();
    else group3d.hide();
  }

  void x_Angle(float angle) {
    xAngle = radians(angle);
  }
  void y_Angle(float angle) {
    yAngle = radians(angle);
  }
  void z_Angle(float angle) {
    zAngle = radians(angle);
  }

  void resetAngles() {
    xAngle = 0;
    yAngle = 0;
    zAngle = 0;

    cp5.get(Slider.class, "x_Angle").setValue(0);
    cp5.get(Slider.class, "y_Angle").setValue(0);
    cp5.get(Slider.class, "z_Angle").setValue(0);
  }

  void confirmC() {

    // save changes to beatmap object
    bm.in3d = in3d;
    bm.xAngle = xAngle;
    bm.yAngle = yAngle;
    bm.zAngle = zAngle;

    author.applyToAllBM();

    group.remove();
    currentGUI = author;
    currentGUI.show();
  }

  void cancelC() {
    group.remove();
    group3d.remove();
    currentGUI = author;
    currentGUI.show();
  }
  
  public void playSongC() {
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

  public void stopSongC() {
    mp.stopSong();
  }
  
}

