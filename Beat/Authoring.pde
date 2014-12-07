public class Authoring extends BeatGUIBase {

  List<PImage> images;
  List<BeatMap> beatmaps; 
  int currentIndex = 0;
  int imagewidth = 100;
  int topMargin = 30;
  int bottomMargin = 30;
  int displayNumber = 2;

  public Authoring(ControlP5 cp5) {
    super(cp5, cp5.addGroup("AUTHOR"));
    beatmaps = new ArrayList<BeatMap>();
    images = new ArrayList<PImage>();
  }

  public void initialize() {
    cp5.addBang("songBrowse")
      .plugTo(this)
        .setGroup(group)
          .setTriggerEvent(Bang.RELEASE)
            .setPosition(width/2-buttonw/2, 20)
              .setSize(buttonw, 20)
                .setLabel("Browse For Songs")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
    
     cp5.addBang("toMain")
       .plugTo(this)
        .setGroup(group)
            .setPosition(buttonw/2 + 10, height-30)
              .setSize(buttonw, 20)
                .setLabel("Main Menu")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
  }

  // callback for song browsing
  public void songBrowse() {
    selectInput("Select a midi file", "songSelected");
  }
  
  public void toMain() {
    currentGUI.hide();
    currentGUI = menu;
    currentGUI.show();
  }

  public void draw() {
    background(backgroundColor);

    for (int i = 0; i < displayNumber; i++) {
      if (i+currentIndex < images.size()) {
        PicFrame f = new PicFrame(width - (displayNumber - i)*imagewidth, topMargin, imagewidth, height - (topMargin + bottomMargin));
        f.setPic(images.get(i+currentIndex));
        f.drawPic();
      }
    }
  }

  public void keyPressed() {
  }

  public void keyReleased() {
  }
}

