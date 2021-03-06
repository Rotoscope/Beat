/*
*  TrackTiming: class that holds the note timing from a track in a midi file
*               used to save the data into a file. It also can generate a beatmap
*               from the track information. 
*/

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class TrackTiming {
  int trackNumber, numberOfEvents;
  List<Note> noteList;

  TrackTiming() {
    trackNumber = -1;
    numberOfEvents = -1;
    noteList = new ArrayList<Note>();
  }

  public void setTrackNumber(int i) {
    trackNumber = i;
  }

  public int getTrackNumber() {
    return trackNumber;
  }

  public void setNumberOfEvents(int i) {
    numberOfEvents = i;
  }

  public int getNumberOfEvents() {
    return numberOfEvents;
  }

  public void addNote(long tick, String command, String noteName, int octave, int noteKey, int velocity, int channel) {
    Note n = new Note(tick, command, noteName, octave, noteKey, velocity, channel);
    noteList.add(n);
  }

  // i > 0 && i <= noteList.size()
  public Note getNote(int i) {
    return noteList.get(i);
  }

  public List getDurationTiming() {
    List<Note> durationList = new ArrayList<Note>();
    List<Note> noteONList = new ArrayList<Note>();
    Note n, m;

    for (int i = 0; i < noteList.size (); i++) {
      n = noteList.get(i);

      if (n.getCommand().equals("ON")) {
        noteONList.add(n);  //add the ON note at the first element of the list
      } else if (n.getCommand().equals("OFF")) {

        //tosses away any OFF commands when there are no ON commands
        for (int j = 0; j < noteONList.size (); j++) {
          m = noteONList.get(j);

          //after finding the matching ON Note, it sets the duration and adds it to a different list
          //any off notes is disregarded if there is no matching ON Note
          if (n.keyEquals(m)) {
            m.setDuration(n.getTick() - m.getTick());
            durationList.add(m);
            noteONList.remove(j);
          }
        }
      }
    }

    //move all notes that does not have a NOTE_OFF to the durationList with its default duration
    while (!noteONList.isEmpty ()) {
      durationList.add(noteONList.remove(0));
    }

    return durationList;
  }

  public int getNumEventsToFile() {
    return getDurationTiming().size();
  }

  public void saveToFile(String filename, int locationCount) throws Exception {
    PrintWriter pw;
    List<Note> durationList = getDurationTiming();
    Note n;

    if (!durationList.isEmpty()) {
      pw = new PrintWriter(filename);

      //adds the durationList notes to the file
      for (int i = 0; i < durationList.size (); i++) {
        n = durationList.get(i);
        pw.printf("%d %d %d\n", (n.getNoteKey() % locationCount) + 1, n.getTick(), n.getDuration());
      }    

      pw.close();
    }
  }

  int randInt(int min, int max) {
    Random rand = new Random();

    return rand.nextInt((max - min) + 1) + min;
  }

  public BeatMap toBeatMap(int locationCount) {
    List<Note> durationList = getDurationTiming();
    Note n;

    BeatMap bm = new BeatMap();
    Queue<BeatMapEvent> events = bm.getMap();
    Map<Short, Long> currentEndTick = new HashMap<Short, Long>();

    if (!durationList.isEmpty()) {
      //adds the durationList notes to the file
      for (int i = 0; i < durationList.size (); i++) {
        n = durationList.get(i);
        short location = (short)((n.getNoteKey() % locationCount) + 1);
        long tick = n.getTick();
        long duration = n.getDuration();
        long endTick = tick + duration;

        if (currentEndTick.get(location-1) == null || currentEndTick.get(location-1) + bm.minGap < tick) {
          currentEndTick.put((short)(location-1), endTick);
          events.add(new PressTiming(location, tick, duration, bm));
        }

        if (location > bm.maxLocations)
          bm.maxLocations = location;
      }

      long max = 0;
      Iterator<Long> it = currentEndTick.values().iterator();
      while (it.hasNext ()) {
        long next = it.next();
        if (max < next)
          max = next;
      }
      bm.setDuration(max);
    }

    return bm;
  }
}

