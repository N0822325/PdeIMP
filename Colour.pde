

public class ColourSelect 
{
  int x;
  int y;
  int w;
  int h;
  int current;
  PImage colourBox; 
  public ColourSelect ( int x_, int y_, int w_, int h_ )
  {
    
    colourBox = new PImage( w_, h_ );
        
    for( int i=0; i<w_; i++ ) 
    {
      int ColourRange = (int)(cos((-360 * (i / (float)w_)) * (PI / 180)) * 127 + 128) << 16 | 
        (int)(cos((-360 * (i / (float)w_)) * (PI / 180) + 2 * PI / 3) * 127 + 128) << 8 | 
        (int)(Math.cos((-360 * (i / (float)w_)) * (PI / 180) + 4 * PI / 3) * 127 + 128);
      

      float RedChannel = red(ColourRange) - red(int(0xFFFFFF));
      float GreenChannel = green(ColourRange) - green(int(0xFFFFFF));
      float BlueChannel = blue(ColourRange) - blue(int(0xFFFFFF));
      float RedChannelInv = red(0x000000) - red(ColourRange);
      float GreenChannelInv = green(0x000000) - green(ColourRange);
      float BlueChannelInv = blue(0x000000) - blue(ColourRange);
      for (int j = 0; j<(h_/2); j++)
      {
        int c = color( red(int(0xFFFFFF))+(j)*(RedChannel/(h_/2)), green(int(0xFFFFFF))+(j)*(GreenChannel/(h_/2)), blue(int(0xFFFFFF))+(j)*(BlueChannel/(h_/2)) );
        colourBox.set( i, j, c );
        int c2 = color( red(ColourRange)+((j+(h_/2))-(h_/2))*(RedChannelInv/(h_/2)), green(ColourRange)+((j+(h_/2))-(h_/2))*(GreenChannelInv/(h_/2)), blue(ColourRange)+((j+(h_/2))-(h_/2))*(BlueChannelInv/(h_/2)) );
        colourBox.set( i, (j+(h_/2)), c2 );
      }


          x = x_; y = y_; w = w_; h = h_;
      
    }
  }
  
  public color getColour()
  {
    return current;
  }

  
  public void Draw()
  {
    image( colourBox, x, y );
    if( mousePressed &&
      mouseX >= x && 
      mouseX < x + w &&
      mouseY >= y &&
      mouseY < y + h )
    {
      current = get( mouseX, mouseY );

    }
    fill( current );
    rect( x-25, y+h-20, 20, 20 );

  }
  

  
}
