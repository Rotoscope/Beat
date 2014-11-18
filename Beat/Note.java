public class Note {
  final int DEFAULT_DURATION = 200;
  
  long tick, duration;
  int channel, velocity, noteKey, octave;
  String noteName, command;
  
  Note(long tic, String com, String nN, int oct, int nK, int vel, int ch) {
    tick = tic;
    command = com;
    noteName = nN;
    octave = oct;
    noteKey = nK;
    velocity = vel;
    channel = ch;
    duration = DEFAULT_DURATION;
  }
  
  public long getTick() {
    return tick;
  }
  
  public String getCommand() {
    return command;
  }
  
  public String getNoteName() {
    return noteName;
  }
  
  public int getOctave() {
    return octave;
  }
  
  public int getNoteKey() {
    return noteKey;
  }
   
  public int getVelocity() {
    return velocity;
  }
  
  public int getChannel() {
    return channel;
  } 

  public boolean keyEquals(Note n) {
    return (this.channel == n.getChannel() &&
            this.noteKey == n.getNoteKey() &&
            this.octave == n.getOctave());
  }
  
  public long getDuration() {
    return duration;
  }
  
  public void setDuration(long i) {
    duration = i;
  }
}
