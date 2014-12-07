public class Authoring extends BeatGUIBase {

  List<PImage> images;
  List<BeatMap> beatmaps; 

  int currentIndex = 0;
  int selectedIndex = 0;

  int imagewidth = 100;
  int topMargin = 30;
  int bottomMargin = 30;
  int displayNumber = 2;

  Textarea songArea;

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
            .setPosition(20, 20)
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

    songArea = cp5.addTextarea("songdataA")
      .setGroup(group)
        .setPosition(25, 50)
          .setSize(width/2 - 50, height - 100)
            .setFont(createFont("arial", 12))
              .setLineHeight(14)
                .setColor(#000000)
                  .setColorBackground(color(#ABD7E5))
                    .setColorForeground(color(#6BEAD3))
                      .setText("Choose a midi file")
                        ;
  }

  public void draw() {
    background(backgroundColor);

    if (!images.isEmpty()) {
      for (int i = 0; i < displayNumber; i++) {
        if (i+currentIndex < images.size()) {
          PicFrame f = new PicFrame(width - (displayNumber - i)*imagewidth, topMargin, imagewidth, height - (topMargin + bottomMargin));
          f.setPic(images.get((i+currentIndex)%images.size()));
          f.drawPic();
        }
      }

      stroke(#FF7003);
      strokeWeight(4);
      noFill();
      rect(width - (displayNumber - selectedIndex)*imagewidth, topMargin, imagewidth, height - (topMargin + bottomMargin));
    }
  }

  private void setIndex() {
    if (selectedIndex < 0)
    {
      currentIndex = (currentIndex +images.size() - displayNumber)%images.size();
      selectedIndex = displayNumber - 1;
    } else if (selectedIndex >= displayNumber)
    {
      currentIndex = (currentIndex + displayNumber)%images.size();
      selectedIndex = 0;
    } else if (selectedIndex + currentIndex > images.size()) {
      currentIndex = 0;
      selectedIndex = 0;
    }
  }

  public void keyPressed() {
    if (!images.isEmpty()) {
      if (key == CODED) {
        switch(keyCode) {
        case LEFT:
          selectedIndex--;
          break;
        case RIGHT:
          selectedIndex++;
          break;
        }
      }

      setIndex();
    }
  }

  public void keyReleased() {
  }

  // callbacks for buttons
  public void songBrowse() {
    images.clear();
    beatmaps.clear();
    selectInput("Select a midi file", "songSelected");
  }

  public void toMain() {
    currentGUI.hide();
    currentGUI = menu;
    currentGUI.show();
  }
}

