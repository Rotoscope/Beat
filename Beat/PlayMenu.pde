/*
  Name: PlayMenu
  Authors: Stanley Seeto
  
  Description: 
    This class handles the GUI for the Play mode pause menu.
*/
public class PlayMenu extends BeatGUIBase {
  
  public PlayMenu(ControlP5 cp5) {
    super(cp5, cp5.addGroup("PLAYMENU"));
  }
  
  public void initialize() {
    cp5.addBang("playMenuToResume")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 100)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Resume")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
                    
    cp5.addBang("playMenuToRestart")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 200)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Restart")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
    
    cp5.addBang("playMenuToSelect")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 300)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Song Select")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
    
    cp5.addBang("playMenuToMain")
      .plugTo(this)
        .setGroup(group)
          .setPosition(width/2-buttonw/2, 400)
            .setSize(buttonw, 20)
              .setTriggerEvent(Bang.RELEASE)
                .setLabel("Main Menu")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;
    
    
  }
  
  public void draw() {
    background(backgroundColor);
  }
  
  public void keyPressed() {
  }
  
  public void keyReleased() {  
  }
  
  void playMenuToResume() {
    currentGUI.hide();
    currentGUI = play;
    currentGUI.show();
    try {
      play.resumeGame();
    } catch(Exception e) {
      println("SONG MENU RESUME GAME ERROR");
      println(e);
    }
  }
  
  void playMenuToRestart() {
    currentGUI.hide();
    try {
      play.restartGame();
      currentGUI = play;
      currentGUI.show();
    } catch(Exception e) {
      println("FAILED TO RESTART");
      println(e);
    }
  }
  
  void playMenuToSelect() {
    currentGUI.hide();
    currentGUI = select;
    currentGUI.show();
  }
  
  void playMenuToMain() {
    currentGUI.hide();
    currentGUI = menu;
    currentGUI.show();
  }
}
