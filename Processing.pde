// Globals
  SimpleUI myUI;
  SimpleUI ImgPreview;

  ColourSelect colours;
  
  DrawingList drawingList;
  
  
  String toolMode = "";
  PImage SourceImage;
  PImage ImageManip;
  
  int imageWidth;
  int imageHeight;
  int imgx;
  int imgy;
  Rect mid_;
  boolean display = false;
//


void setup()
{
   SourceImage = loadImage("screentest.jpg");
  
  int winW = 1000;
  int winH = 800;
  size(1000,800);
  imageWidth = SourceImage.width;
  imageHeight = SourceImage.height;
  
  Rect Left = new Rect(35,5,70,100);
  
  
  
  Rect Right = new Rect(winW-255, 5, 250, winH-10);
  
  Rect Mid = new Rect(Left.x + Left.w + 5, 5, (Right.x) - (Left.x + Left.w + 10), winH-10);
  mid_ = Mid;
  
  myUI = new SimpleUI();
  ImgPreview = new SimpleUI();
  
  imgx = Mid.x + 5;
  imgy = Mid.y + 25;
  
  colours = new ColourSelect( Right.x, Right.y, Right.w, Right.h);
  
  String[] filters =  { "Hue", "GreyScale", "Black&White", "Inversion" };
  myUI.addMenu("Filters",Mid.x, Mid.y, filters);
  String[] effects =  { "Edge", "Blur", "GausianBlur", "Sharpen"  };
  myUI.addMenu("Effects",Mid.x+100, Mid.y, effects);

  myUI.addPlainButton("Reset", (Mid.x+Mid.w)-70, Mid.y);
  
  myUI.addPlainButton("Display Image", (Mid.x+Mid.w)-215, Mid.y);
  myUI.addPlainButton("Close Image", (Mid.x+Mid.w)-145, Mid.y);
  
  drawingList = new DrawingList();

   
    
    int BtnHeight = 30;
    int Gap = 10;
    
    ButtonBaseClass  rectButton = myUI.addRadioButton("draw rect", Left.x-15, Left.y, "group1");
    myUI.addRadioButton("draw circle", Left.x-15, Left.y + BtnHeight, "group1");
    myUI.addRadioButton("draw line", Left.x-15, Left.y + BtnHeight*2, "group1");
    
    myUI.addPlainButton("load file", Left.x-15, Left.y + BtnHeight*3 + Gap);
    myUI.addPlainButton("save file", Left.x-15, Left.y + BtnHeight*4 + Gap);
    myUI.addRadioButton("draw image", Left.x-15, Left.y + BtnHeight*5 + Gap, "group1");
    
    
    myUI.addRadioButton("select", Left.x-15, Left.y + BtnHeight*6 + Gap*2, "group1");
    myUI.addPlainButton("delete", Left.x-15, Left.y + BtnHeight*7 + Gap*2);
    myUI.addPlainButton("delete all", Left.x-15, Left.y + BtnHeight*8 + Gap*2);
    myUI.addSlider("scale", 5, Left.y + BtnHeight*9 + Gap*2);
    
    myUI.addPlainButton("Fill Shape", Left.x-15, Left.y + BtnHeight*10 + Gap*3);
    myUI.addPlainButton("Fill Line", Left.x-15, Left.y + BtnHeight*11 + Gap*3);
    myUI.addSlider("Line Weight", 5, Left.y + BtnHeight*12 + Gap*3);
    
    rectButton.selected = true;
    toolMode = rectButton.UILabel;
    
    myUI.addCanvas(Mid.x, Mid.y+20, Mid.w, Mid.h-20);
    
    

  
  
  
  
  
}


void draw()
{
  //print(drawList
  background(200);
  

  
  
  if(SourceImage !=null && display){

    image(SourceImage, imgx,imgy);
  }
  if(ImageManip !=null && display){
    image(ImageManip, imgx,imgy);
  }
  
   if (SourceImage.width > mid_.w){
     
     int before = SourceImage.width;
     
      SourceImage.resize(mid_.w - 10,SourceImage.height * ((mid_.w-10)/before));
      if(ImageManip !=null){
        ImageManip.resize(mid_.w - 10,SourceImage.height * ((mid_.w-10)/before));
      }
      
      imageWidth = mid_.w;
      imageHeight = mid_.h;

    }
    
    else if (SourceImage.height > mid_.h){
     
     int before = SourceImage.height;
     
      SourceImage.resize(SourceImage.height * ((mid_.h-30)/before), mid_.h - 30);
      if(ImageManip !=null){
        ImageManip.resize(SourceImage.height * ((mid_.h-30)/before), mid_.h - 30);
      }
      
      imageWidth = mid_.w;
      imageHeight = mid_.h;
    }
  
  
  myUI.update();
  
  colours.Draw();
  
  drawingList.drawMe();
  
  ImgPreview.update();
  
}




void handleUIEvent(UIEventData eventData){
  
  
  if(eventData.uiLabel == "load file"){
    myUI.openFileLoadDialog("load an image");
  }
  if(eventData.uiLabel == "fileLoadDialog"){
    SourceImage = loadImage(eventData.fileSelection);
    ImageManip = SourceImage.copy();
    imageWidth = SourceImage.width;
    imageHeight = SourceImage.height;
  }  
  if(eventData.uiLabel == "save file"){
    myUI.openFileSaveDialog("save an image");
  }  
  if(eventData.uiLabel == "fileSaveDialog"){
    if(ImageManip == null){
      SourceImage.save(eventData.fileSelection + ".jpg");
    }
    else{
      ImageManip.save(eventData.fileSelection + ".jpg");
    }
  }
  

  if(eventData.uiLabel == "delete"){        
    drawingList.Delete();
  } 
  
  if(eventData.uiLabel == "Reset"){        
    Reset();
  } 
  
  if(eventData.uiLabel == "Display Image"){        
    display = true;
    
  }
  if(eventData.uiLabel == "Close Image"){        
    display = false;
  } 
  
  
  if(eventData.uiLabel == "delete all"){        
    drawingList.DeleteAll();
  }  
  
  if(eventData.uiLabel == "scale"){
    for (DrawnShape ss : drawingList.selectList)
    {
      ss.scale(eventData.sliderValue);
      //ss.
    }
    print(eventData.sliderValue);
    
  }  
  

   if (eventData.menuItem.equals("Hue"))
   {
     
      Hue();
        
   }
   
   if (eventData.menuItem.equals("GreyScale"))
   {
     
      greyScale();
        
   }
   
   if (eventData.menuItem.equals("Black&White"))
   {
     
      blackwhite();
        
   }
   
   if (eventData.menuItem.equals("Inversion"))
   {
     
      Inversion();
        
   }
   
   
   
   if (eventData.menuItem.equals("GausianBlur"))
   {
     
      Glas();
        
   }
   
   if (eventData.menuItem.equals("Blur"))
   {
     
      Blur();
        
   }

   if (eventData.menuItem.equals("Edge"))
   {
     
      Edge();
        
   }
      
  if (eventData.menuItem.equals("Sharpen"))
   {
     
      Sharpen();
        
   }
 

  if (eventData.uiLabel == "Fill Line")
  {
    drawingList.changeLine(colours.getColour()); 
  }

  

  if (eventData.uiLabel == "Fill Shape")
  {
    drawingList.changeFill(colours.getColour()); 
  }


  if(eventData.eventIsFromWidget("Line Weight"))
  {
    float siderval = eventData.sliderValue * 20;
    drawingList.changeWeight((int)siderval);
  }
  
   
  if(eventData.uiComponentType == "RadioButton"){
    toolMode = eventData.uiLabel;

    return;
  }

  // only canvas events below here!
  if(eventData.eventIsFromWidget("canvas")==false) return;
  PVector p =  new PVector(eventData.mousex, eventData.mousey);
  
  // this next line catches all the tool modes containing the word "draw"
  // so that drawing events are sent to the display list class only if the current tool 
  // is a drawing tool
  if( toolMode.contains("draw") ) {    
     drawingList.handleMouseDrawEvent(toolMode,eventData.mouseEventType, p);
  }
   
  // if the current tool is "select" then do this
  if( toolMode.equals("select") ) {
      drawingList.trySelect(eventData.mouseEventType, p);
    }
    

  


}


public class Rect
{ 
  public int x, y, w, h;
  
  public Rect ( int x, int y, int w, int h )
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  } 
}
