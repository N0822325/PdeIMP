float[][] edge_matrix = { { 0,  -2,  0 },
                          { -2,  8, -2 },
                          { 0,  -2,  0 } }; 
                     
float[][] blur_matrix = {  {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 },
                           {0.1,  0.1,  0.1 } };                      

float[][] sharpen_matrix = {  { 0, -1, 0 },
                              {-1, 5, -1 },
                              { 0, -1, 0 } };  
                         
float[][] gaussianblur_matrix = { { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.001,  0.020,  0.109, 0.172, 0.109, 0.020, 0.001},
                                  { 0.001,  0.012,  0.068, 0.109, 0.068, 0.012, 0.001},
                                  { 0.000,  0.002,  0.012, 0.020, 0.012, 0.002, 0.000},
                                  { 0.000,  0.000,  0.001, 0.001, 0.001, 0.000, 0.000}
                                  };
                                  
                                  
color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc,0,img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}
  void Reset() {
    ImageManip= SourceImage;
  }
                                   
  void Glas() {
    
  ImageManip = createImage(SourceImage.width,SourceImage.height,RGB);
  SourceImage.loadPixels();
  
  int matrixSize = 7;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = convolution(x, y, gaussianblur_matrix, matrixSize, SourceImage);
    
    ImageManip.set(x,y,c);
    
    }
    }
  }
  
  void Blur()
  {
     
  ImageManip = createImage(SourceImage.width,SourceImage.height,RGB);
  SourceImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = convolution(x, y, blur_matrix, matrixSize, SourceImage);
    
    ImageManip.set(x,y,c);
    
    }
    }
    
  }
  
  void Edge()
  {
    
  ImageManip = createImage(SourceImage.width,SourceImage.height,RGB);
  SourceImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = convolution(x, y, edge_matrix, matrixSize, SourceImage);
    
    ImageManip.set(x,y,c);
    
    }
    }
    
  }
  
  
  void Sharpen()
  
  {
    ImageManip = createImage(SourceImage.width,SourceImage.height,RGB);
  SourceImage.loadPixels();
  
  int matrixSize = 3;
  for(int y = 0; y < imageHeight; y++){
    for(int x = 0; x < imageWidth; x++){
    
    color c = convolution(x, y, sharpen_matrix, matrixSize, SourceImage);
    
    ImageManip.set(x,y,c);
    
    }
    }
  }

  public void Hue()
  {
    ImageManip = SourceImage.copy();

    for (int y = 0; y < imageHeight; y++) {
    
      for (int x = 0; x < imageWidth; x++){
        
        color PicColour = SourceImage.get(x,y);

        
        float[] hsv = RGBtoHSV(red(PicColour),green(PicColour),blue(PicColour));
        float hue = hsv[0];
        float sat = hsv[1];
        float val = hsv[2];

        hue += 30;
        if( hue < 0 ) hue += 360;
        if( hue > 360 ) hue -= 360;
        
        color newRGB =   HSVtoRGB(hue,  sat,  val);
        ImageManip.set(x,y, newRGB);
        }    
     }     
  }
  
  public void greyScale()
  {
   ImageManip = SourceImage.copy();
   for(int y =0; y < SourceImage.height; y++){
      for(int x =0; x < SourceImage.width; x++){
        color thisPix = SourceImage.get(x,y);
        int r = (int) red(thisPix);
        int g = (int) green(thisPix);
        int b = (int) blue(thisPix);
        int greyscale = (int) ((r+g+b)/3);
        color newColour = color(greyscale);
        ImageManip.set(x,y, newColour);
      }
   }
  } 
  
  public void blackwhite()
  {
    ImageManip = SourceImage.copy();
    ImageManip.filter(THRESHOLD, 0.8);
  } 
  
  public void Inversion()
  {
    ImageManip = SourceImage.copy();
    ImageManip.filter(INVERT);    
  }
  
  
  float[] RGBtoHSV(float r, float g, float b){
  
  
  float minRGB = min( r, g, b );
  float maxRGB = max( r, g, b );
    
    
  float value = maxRGB/255.0; 
  float delta = maxRGB - minRGB;
  float hue = 0;
  float saturation;
  
  float[] returnVals = {0f,0f,0f};
  

   if( maxRGB != 0 ) {
     saturation = delta / maxRGB; }
   else {
       return returnVals;
       }
       
   if(delta == 0){ 
         hue = 0;
        }
   else {
      if( b == maxRGB ) hue = 4 + ( r - g ) / delta;   
      if( g == maxRGB ) hue = 2 + ( b - r ) / delta;   
      if( r == maxRGB ) hue = ( g - b ) / delta;
    }
   hue = hue * 60;
   if( hue < 0 ) hue += 360;   
   returnVals[0] = hue;
   returnVals[1] = saturation;
   returnVals[2] = value;   
   return returnVals;
}

color HSVtoRGB(float hue, float sat, float val)
{  
    hue = hue/360.0;
    int h = (int)(hue * 6);
    float f = hue * 6 - h;
    float p = val * (1 - sat);
    float q = val * (1 - f * sat);
    float t = val * (1 - (1 - f) * sat);
    float r,g,b;

    switch (h) {
      case 0: r = val; g = t; b = p; break;
      case 1: r = q; g = val; b = p; break;
      case 2: r = p; g = val; b = t; break;
      case 3: r = p; g = q; b = val; break;
      case 4: r = t; g = p; b = val; break;
      case 5: r = val; g = p; b = q; break;
      default: r = val; g = t; b = p;
    }    
    return color(r*255,g*255,b*255);
}
