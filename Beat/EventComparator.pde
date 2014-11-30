class EventComparator implements Comparator<BeatMapEvent> {
    public int compare(BeatMapEvent e1, BeatMapEvent e2) {
      if(e1.tick > e2.tick)
        return 1;
      else if (e1.tick < e2.tick)
        return -1;
      else
        return 0;
    }
  }
