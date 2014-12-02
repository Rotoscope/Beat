/************************************************************
*  Name:       PicFrame                                     *
*  Author:     Lowell Milliken                              *
*  Date:       9/17/2014                                    *
*  Description:                                             *
*      This class creates a box in which a single image is  *
*      scaled and centered. The aspect ratio of the image is*
*      preserved.                                           *
************************************************************/


class PicFrame
{
  private int locx,locy;
  private int framew,frameh;
  private PImage curPic;
  private int dispx, dispy, dispw, disph;
  
  // initialize location and size of the frame
  public PicFrame(int x, int y, int w, int h)
  {
    this.locx = x;
    this.locy = y;
    this.framew = w;
    this.frameh = h;
  }
  
  public void setPic(PImage pic)
  {
    curPic = pic;
  }
  
  public void drawPic()
  {
    // true if image width >= height
    boolean wide = false;
    
    if(curPic.width >= curPic.height)
    {
      wide  = true;
    }
    
    if(wide)
    {
      dispw = framew;
      dispx = locx;
      disph = curPic.height*dispw/curPic.width;
      dispy = locy + (frameh-disph)/2;
    }
    else
    {
      disph = frameh;
      dispy = locy;
      dispw = curPic.width*disph/curPic.height;
      dispx = locx + (framew-dispw)/2;
    }
    
    switch(checkDims(dispw, disph))
    {
      case 1:
        dispw = framew;
        dispx = locx;
        disph = curPic.height*dispw/curPic.width;
        dispy = locy + (frameh-disph)/2;
        break;
      case 2:
        disph = frameh;
        dispy = locy;
        dispw = curPic.width*disph/curPic.height;
        dispx = locx + (framew-dispw)/2;
        break;
    }
    
    image(curPic,dispx,dispy,dispw,disph);
  }
  
  private int checkDims(int w, int h)
  {
    // 0 if the dimensions fit in the frame
    // 1 if it is too wide
    // 2 if it is too tall
    int good = 0;
    
    if(w > framew)
      good = 1;
    else if(h > frameh)
      good = 2;
    
    return good;
  }
  
  public PicFrame getCopy()
  {
    PicFrame copy = new PicFrame(locx,locy,framew,frameh);
    copy.setPic(curPic);
    return copy;
  }
  
  public int getWidth()
  {
    return framew;
  }
  public void setWidth(int w)
  {
    this.framew = w;
  }
  public int getHeight()
  {
    return frameh;
  }
  public void setHeight(int h)
  {
    this.frameh = h;
  }
  public int getX()
  {
    return locx;
  }
  public void setX(int x)
  {
    locx = x;
  }
  public int getY()
  {
    return locy;
  }
  public void setY(int y)
  {
    locy = y;
  }
  public PImage getPic()
  {
    return curPic;
  }
  
  public int getDispX()
  {
    return dispx;
  }
  public int getDispY()
  {
    return dispy;
  }
  public int getDispW()
  {
    return dispw;
  }
  public int getDispH()
  {
    return disph;
  }
}

/*****************
* Stanley's Image Center Code
*****************/

/*

//checks the scaling; if it is wider or taller than it'll scale appropriately
int resChk(PImage aImg) {
  if((double)aImg.width/aImg.height > areaWidth/areaHeight) //700x500 single image display 
    return 1;
  else if((double)aImg.width/aImg.height < areaWidth/areaHeight)
    return -1;
  else 
    return 0;
}

//k was used for the offset when sliding the images
void singleImage(int index, int k) {
  int i = sResChk(img[index]);
  if(i == -1 || i == 0) {
    float wid = img[index].width * areaHeight / img[index].height;
    image(img[index], k + (areaWidth - wid) / 2 + borderSize, borderSize, wid, areaHeight);
  } else if(i == 1) {
    float hei = img[index].height * areaWidth / img[index].width;
    image(img[index], k + borderSize, (areaHeight - hei) / 2 + borderSize, areaWidth, hei);
  }
}

*/

