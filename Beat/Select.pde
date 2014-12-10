public class Select extends BeatGUIBase {
  private Textarea songArea, bmArea;
  String author, date, copyright, title, comment;
  String songText;

  public Select(ControlP5 cp5) {
    super(cp5, cp5.addGroup("SELECT"));
  }
  
  public void initialize() {
    cp5.addBang("songBrowseNoParse")
      .plugTo(this)
        .setGroup(group)
          .setPosition(25, 20)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Load your song")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;

    cp5.addBang("bmBrowse")
      .plugTo(this)
        .setGroup(group)
          .setPosition(25, 280)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Load your beatmap")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
                    
    songArea = cp5.addTextarea("songdata")
                 .setGroup(group)
                   .setPosition(25, 50)
                     .setSize(width - 50, 200)
                       .setFont(createFont("arial", 12))
                         .setLineHeight(14)
                           .setColor(#000000)
                             .setColorBackground(color(#ABD7E5))
                               .setColorForeground(color(#6BEAD3))
                                 .setText("Choose a midi file")
                                   ;
    
    bmArea = cp5.addTextarea("bmdata")
               .setGroup(group)
                 .setPosition(25, 310)
                   .setSize(width - 50, 200)
                     .setFont(createFont("arial", 12))
                       .setLineHeight(14)
                         .setColor(#000000)
                           .setColorBackground(color(#ABD7E5))
                             .setColorForeground(color(#6BEAD3))
                               .setText("Choose a bm file")
                                 ;
    
    cp5.addBang("play")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/4 - buttonw/2, height - 50)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("PLAY")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
/*                  
    cp5.addBang("option")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2 - buttonw/2, height - 50)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("OPTION")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
*/    
    cp5.addBang("menu")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width*3/4 - buttonw/2, height - 50)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("RETURN TO MENU")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
    
    resetSongMetaData();
  }
  
  public void draw() {
    background(backgroundColor);
  
    if(mp != null) {
      if(newSong) {   
        resetSongMetaData();
        setSongMetaData();
        newSong = false;
      }
      songText = mp.getFilePath() + "\n\n" + title + "\n\n" + author + "\n\n" + copyright + "\n\n" + date + "\n\n" + comment;
      songArea.setText(songText);
    }
    if(bm != null) {
      if(newBM) {
        newBM = false;
      }
      bmArea.setText(bm.getFilePath());
    }
  }
  
  public void keyPressed() {
  }
  
  public void keyReleased() {
    
  }
  
  public void songBrowseNoParse() {
    selectInput("Select a midi file", "songSelectedNoParse");
  }
  
  public void bmBrowse() {
    selectInput("Select a beatmap file", "bmSelected");
  }

  //assumes that the metadata was not provided in the midi file
  //midi files do not require authors to include such information
  void resetSongMetaData() {
    author = "Unknown author";
    date = "Unknown creation date";
    copyright = "Unknown copyright information";
    title = "Unknown title song";
    comment = "No comments";
  }
  
  void setSongMetaData() {
    if(mp.getMetaData().getAuthor() != null)
      author = mp.getMetaData().getAuthor();
    if(mp.getMetaData().getDate() != null)
      date = mp.getMetaData().getDate();
    if(mp.getMetaData().getCopyright() != null)
      copyright = mp.getMetaData().getCopyright();
    if(mp.getMetaData().getTitle() != null)
      title = mp.getMetaData().getTitle();
    if(mp.getMetaData().getComment() != null)
      comment = mp.getMetaData().getComment();
  }
  
  public void play() {
    if(mp == null) {
      println("Select a song");
    } else if(bm == null) {
      println("Select a beatmap");
    } else {
      currentGUI.hide();
      play.init();
      currentGUI = play;
      currentGUI.show();
      offset = -800;
      justStarted = true;
    }
  }
/*  
  public void option() {
    currentGUI.hide();
    currentGUI = option;
    currentGUI.show();
  }
*/  
  public void menu() {
    currentGUI.hide();
    currentGUI = menu;
    currentGUI.show();
  }
  
/*  //if want to shorten the displayed path
  String pathDivision(String s) {
    String path;
    int i = s.indexOf("Data");
    if(i != -1)
      path = "." + File.separator + s.substring(i);
    else
      path = s;
    return(path);
  }
*/
}
