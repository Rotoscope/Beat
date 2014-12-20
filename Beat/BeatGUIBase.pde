/*
  Name: BeatBaseGUI
  Authors: Lowell Milliken
  
  Description: 
    This abstract class is the parent class of all the GUI classes
    in Beat. This class allows us to simplify changing between
    different GUI screens.
    
    All cp5 elements are grouped with the class that owns them. This
    way the buttons and other elements can be toggled on and off
    easily.
*/
public abstract class BeatGUIBase {
  ControlP5 cp5;
  Group group;
  private boolean initialized = false;
  
  public BeatGUIBase(ControlP5 cp5, Group group) {
    this.cp5 = cp5;
    this.group = group;
  }
  
  // initialize creates all cp5 objects
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
