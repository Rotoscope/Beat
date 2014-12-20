/*
  Name: Authoring
  Authors: Lowell Milliken
  
  Description: 
    This class handles the GUI for the Authoring mode as well as
    input events.
*/
public class Authoring extends BeatGUIBase {

  List<PImage> images = null;
  List<BeatMap> beatmaps = null; 
  int locCount = 12;

  int currentIndex = 0;
  int selectedIndex = 0;

  int imagewidth = 100;
  int topMargin = 30;
  int bottomMargin = 30;
  int displayNumber = 3;

  Textarea songArea;
  Group groupS;
  PFont font;
  String saveStatus = "";

  public Authoring(ControlP5 cp5) {
    super(cp5, cp5.addGroup("AUTHOR"));
    beatmaps = new ArrayList<BeatMap>();
    images = new ArrayList<PImage>();
    font = createFont("Arial", 24);
  }

  // create all buttons etc.
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

    groupS = cp5.addGroup("groupS");
    groupS.hide();

    cp5.addButton("toTry")
      .plugTo(this)
        .setGroup(groupS)
          .setPosition(width/2-buttonw/2, 50)
            .setSize(buttonw, 20)
              .setLabel("Try it out")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addButton("toCustomize")
      .plugTo(this)
        .setGroup(groupS)
          .setPosition(width/2-buttonw/2, 80)
            .setSize(buttonw, 20)
              .setLabel("Customize")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addButton("saveSelected")
      .plugTo(this)
        .setGroup(groupS)
          .setPosition(width/2-buttonw/2, 165)
            .setSize(buttonw, 20)
              .setLabel("Save Selected")
                .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                  ;

    cp5.addTextfield("bmName")
      .setGroup(groupS)
        .setPosition(width/2 - 100, 110)
          .setSize(200, 40)
            .setLabel("Enter a beatmap name")
              .setFont(createFont("arial", 20))
                .setAutoClear(false)
                  ;

    songArea = cp5.addTextarea("songdataA")
      .setGroup(group)
        .setPosition(25, 50)
          .setSize(width/2 - 130, height - 100)
            .setFont(createFont("arial", 12))
              .setLineHeight(14)
                .setColor(#000000)
                  .setColorBackground(color(#ABD7E5))
                    .setColorForeground(color(#6BEAD3))
                      .setText("Choose a midi file")
                        ;

    cp5.addSlider("locCount")
      .plugTo(this)
        .setGroup(group)
          .setPosition(20 + buttonw + 20, 20)
            .setWidth(100)
              .setRange(4, 12)
                .setValue(12)
                  .setNumberOfTickMarks(9)
                    .setLabel("Choose desired number of Timing Locations")
                      .setSliderMode(Slider.FLEXIBLE)
                        ;
  }

  public void draw() {
    background(backgroundColor);

    if (!images.isEmpty()) {
      for (int i = 0; i < displayNumber; i++) {
        if (i+currentIndex < images.size()) {
          PImage curIm = images.get((i+currentIndex)%images.size());
          int curH = curIm.height*imagewidth/(height - (topMargin + bottomMargin));
          image(curIm, width - (displayNumber - i)*imagewidth, - curH + height - bottomMargin, imagewidth, curH);
        }
      }
      noStroke();
      fill((#FF7003 & 0xffffff) | (126 << 24));

      rect(width - (displayNumber - selectedIndex)*imagewidth, 0, imagewidth, height - bottomMargin);
    }

    fill(#FFFFFF);
    textFont(font);
    textAlign(CENTER);
    text(saveStatus, width/2, 250);
  }

  private void setIndex() {
    if (selectedIndex < 0)
    {
      if (images.size() > displayNumber) {
        currentIndex = (currentIndex +images.size() - displayNumber)%images.size();
        selectedIndex = displayNumber - 1;
      } else {
        selectedIndex = images.size()-1;
      }
    } else if (selectedIndex >= displayNumber)
    {
      currentIndex = (currentIndex + displayNumber)%images.size();
      selectedIndex = 0;
    } else if (selectedIndex + currentIndex >= images.size()) {
      currentIndex = 0;
      selectedIndex = 0;
    }
  }

  public void keyPressed() {
    if (!images.isEmpty() && !cp5.get(Textfield.class, "bmName").isFocus()) {
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
    groupS.hide();
    currentGUI = menu;
    currentGUI.show();
  }

  public void show() {
    super.show();
    groupS.show();
  }

  public void toTry() {
    if (mp != null) {
      currentGUI.hide();
      groupS.hide();

      bm = beatmaps.get(selectedIndex + currentIndex);

      newSong = true;
      img = bm.makeImage();
      offset = 0;
      eventMap = bm.getEventQueues();
      newBM = true;
      tryMode = true;
      justStarted = true;
  
      currentGUI.hide();
      play = new Play(cp5);
      play.init();
      play.hide();
      currentGUI = play;
      currentGUI.show();
    }
  }

  public void toCustomize() {

    if (!beatmaps.isEmpty()) {
      currentGUI.hide();
      groupS.hide();
      Customize cust = new Customize(cp5, beatmaps.get(selectedIndex + currentIndex));
      cust.init();
      currentGUI = cust;
      currentGUI.show();
    }
  }

  // save the currently selected beatmap to local storage
  public void saveSelected() {
    if (!beatmaps.isEmpty()) {
      saveStatus = "Saving...";
      try {
        PrintWriter pw;
        BeatMap bm = beatmaps.get(selectedIndex + currentIndex);

        String filename = cp5.get(Textfield.class, "bmName").getText() + ".bm";
        String fs = File.separator;
        String path = sketchPath + fs + "Data" + fs + "Beatmaps" + fs + filename;

        bm.saveToFile(path);

        println(filename + " Saved");
        saveStatus = "Saved";
      } 
      catch (Exception e) {
        println(e.getMessage());
      }
    }
  }

  // this method applies customizations to all beatmaps currently being
  // considered.
  public void applyToAllBM(BeatMap changedBM) {

    for (int i = 0; i < beatmaps.size (); i++) {
      if (i != selectedIndex + currentIndex)
        changedBM.copyCustomize(beatmaps.get(i));
    }
  }
}
