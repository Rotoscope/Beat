public class Authoring extends BeatGUIBase {

  List<PImage> images;
  List<BeatMap> beatmaps; 
  int currentIndex = 0;
  int imagewidth = 100;
  int topMargin = 30;
  int bottomMargin = 30;
  int displayNumber = 2;
  
  public Authoring(ControlP5 cp5, Group group) {
    super(cp5, group);
    beatmaps = new ArrayList<BeatMap>();
    images = new ArrayList<PImage>();
  }
  
  public void initialize() {
    cp5.addBang("songBrowse")
    .setGroup(group)
      .setPosition(width/2-buttonw/2, 20)
        .setSize(buttonw, 20)
          .setLabel("Browse For Songs")
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;
  }
  
  public void draw() {
    background(backgroundColor);
    
    for(int i = 0; i < displayNumber; i++) {
      if(i+currentIndex < images.size()) {
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
