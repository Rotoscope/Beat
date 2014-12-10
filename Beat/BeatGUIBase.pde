public abstract class BeatGUIBase {
  ControlP5 cp5;
  Group group;
  private boolean initialized = false;
  
  public BeatGUIBase(ControlP5 cp5, Group group) {
    this.cp5 = cp5;
    this.group = group;
  }
  
  public abstract void initialize();
  public abstract void draw();
  public abstract void keyPressed();
  public abstract void keyReleased();
  
  public void init() {
    if(!initialized) {
      initialize();
      initialized = true;
    }
  }
  
  public void hide() {
    group.hide();
  }
  
  public void show() {
    group.show();
  }
  
  public boolean isInit() {
    return initialized;
  }
}
