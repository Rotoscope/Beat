public class Authoring extends BeatGUIBase {

  List<PImage> images;
  List<BeatMap> beatmaps; 

  String filename;

  int currentIndex = 0;
  int selectedIndex = 0;

  int imagewidth = 100;
  int topMargin = 30;
  int bottomMargin = 30;
  int displayNumber = 2;

  Textarea songArea;
  Group groupS;

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
    groupS.hide();
    currentGUI = menu;
    currentGUI.show();
  }

  public void toTry() {
    currentGUI.hide();
    groupS.hide();

    bm = beatmaps.get(selectedIndex + currentIndex);

    newSong = true;
    img = bm.makeImage();
    offset = 0;
    eventMap = bm.getEventQueues();
    newBM = true;
    tryMode = true;

    currentGUI = play;
    currentGUI.show();
  }

  public void toCustomize() {
    currentGUI.hide();
    groupS.hide();
    Customize cust = new Customize(cp5, beatmaps.get(selectedIndex + currentIndex));
    cust.init();
    currentGUI = cust;
    currentGUI.show();
  }

  public void saveSelected() {
    try {
      PrintWriter pw;
      BeatMapEvent event;
      BeatMap bm = beatmaps.get(selectedIndex + currentIndex);

      pw = new PrintWriter(filename);

      //adds the notes to the file
      while (bm.getMap ().peek() != null) {
        event = bm.getMap().poll();
        pw.println(event.toFileString());
      }    

      pw.close();
    } 
    catch (Exception e) {
      println(e.getMessage());
    }
  }

  public void applyToAllBM() {
    BeatMap changedBM = beatmaps.get(selectedIndex + currentIndex);

    for (int i = 0; i < beatmaps.size (); i++) {
      if (i != selectedIndex + currentIndex)
        changedBM.copyCustomize(beatmaps.get(i));
    }
  }
}

