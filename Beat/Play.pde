public class Play extends BeatGUIBase {
  final long MARGIN_OF_ERROR = 10;
  int[] scores;
  boolean[] flags;

  public Play(ControlP5 cp5, Group group) {
    super(cp5, group);
  }

  public void initialize() {
    flags = new boolean[4];
    for(int i = 0; i < 4; i++)
      flags[i] = false;
    scores = new int[5];
  }

  public void draw() {
  }

  public void keyPressed() {
    if (mp != null && bm != null && events != null) {
      switch(key) {
      case 'D':
        if (flags[0] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[0].peek().getTick());
          //only consider the score if the button pushed is near a note
          if (accuracy < MARGIN_OF_ERROR * 5) {
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[0]++;
            }
            release_events[0].add(events[0].poll());
          }
        }
        flags[0] = true;
        break;
      case 'F':
        if (flags[1] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[1].peek().getTick());

          if (accuracy < MARGIN_OF_ERROR * 5) {
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[1]++;
            }
            release_events[1].add(events[1].poll());
          }
        }
        flags[1] = true;
        break;
      case 'J':
        if (flags[2] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[2].peek().getTick());

          if (accuracy < MARGIN_OF_ERROR * 5) {
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[2]++;
            }
            release_events[2].add(events[2].poll());
          }
        }
        flags[2] = true;
        break;
      case 'K':
        if (flags[3] == false) {
          long accuracy = Math.abs(mp.getTickPosition() - events[3].peek().getTick());

          if (accuracy < MARGIN_OF_ERROR * 5) {
            if (accuracy <= MARGIN_OF_ERROR) {
              scores[3]++;
            }
            release_events[3].add(events[3].poll());
          }
        }
        flags[3] = true;
        break;
      }
    }
  }

  public void keyReleased() {
    if (mp != null && bm != null) {
      switch(key) {
      case 'D':
        flags[0] = false;
        if (!release_events[0].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[0].poll().getEndTick());

          if (accuracy <= MARGIN_OF_ERROR) {
            scores[0]++;  //scores are rated on pressing and releasing on time
          }
        }
        break;
      case 'F':
        flags[1] = false;
        if (!release_events[1].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[1].poll().getEndTick());

          if (accuracy <= MARGIN_OF_ERROR) {
            scores[1]++;
          }
        }
        break;
      case 'J':
        flags[2] = false;
        if (!release_events[2].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[2].poll().getEndTick());

          if (accuracy <= MARGIN_OF_ERROR) {
            scores[2]++;
          }
        }
        break;
      case 'K':
        flags[3] = false;
        if (!release_events[3].isEmpty()) {
          long accuracy = Math.abs(mp.getTickPosition() - release_events[3].poll().getEndTick());

          if (accuracy <= MARGIN_OF_ERROR) {
            scores[3]++;
          }
        }
        break;
      }
    }
  }
}

