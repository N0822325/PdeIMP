

class DrawnShape {
  // type of shape
  // line
  // circle
  // Rect .....
  String shapeType;
  

  // used to define the shape bounds during drawing and after
  PVector shapeStartPoint, shapeEndPoint;

  public boolean isSelected = false;
  boolean isBeingDrawn = false;
  boolean isImage = false;
  
  public color line = color(0,0,0);
  public color fill = color(100,100,100);
  public int weight = 1;
  
  void changeFill(color c)
  {
    fill = c;
  }
  void changeLine(color c)
  {
    line = c;
  }
  void changeWeight(int w)
  {
    weight = w; 
  }

  public DrawnShape(String shapeType) {
    this.shapeType  = shapeType;
  }


  public void startMouseDrawing(PVector startPoint) {
    this.isBeingDrawn = true;
    this.shapeStartPoint = startPoint;
    this.shapeEndPoint = startPoint;
  }



  public void duringMouseDrawing(PVector dragPoint) {
    if (this.isBeingDrawn) this.shapeEndPoint = dragPoint;
  }


  public void endMouseDrawing(PVector endPoint) {
    this.shapeEndPoint = endPoint;

    this.isBeingDrawn = false;
  }


  public boolean tryToggleSelect(PVector p) {

    UIRect boundingBox = new UIRect(shapeStartPoint, shapeEndPoint);

    if ( boundingBox.isPointInside(p)) {
      this.isSelected = !this.isSelected;
      return true;
    }
    return false;
  }



  public void drawMe() {

    if (this.isSelected) {
      setSelectedDrawingStyle();
    } else {
      setDefaultDrawingStyle();
    }

    float x1 = this.shapeStartPoint.x;
    float y1 = this.shapeStartPoint.y;
    float x2 = this.shapeEndPoint.x;
    float y2 = this.shapeEndPoint.y;
    float w = x2-x1;
    float h = y2-y1;

    if ( shapeType.equals("draw rect")) rect(x1, y1, w, h);
    if ( shapeType.equals("draw circle")) ellipse(x1+ w/2, y1 + h/2, w, h);
    if ( shapeType.equals("draw line")) line(x1, y1, x2, y2);
  }

  void setSelectedDrawingStyle() {
    strokeWeight(weight + 5);
    stroke(0);
    fill(fill);
  }

  void setDefaultDrawingStyle() {
    strokeWeight(weight);
    stroke(line);
    fill(fill);
  }

  public void setPos(float x, float y)
  {
    this.shapeStartPoint.x = x;
    this.shapeStartPoint.y = y;
  }

  public void scale(float s)
  {
    //this.
  }
}     // end DrawnShape




////////////////////////////////////////////////////////////////////
// DrawingList Class
// this class stores all the drawn shapes during and after thay have been drawn
//
// 


class DrawingList {

  ArrayList<DrawnShape> shapeList = new ArrayList<DrawnShape>();
  public ArrayList<DrawnShape> selectList = new ArrayList<DrawnShape>();
  boolean isDrawing;

  // this references the currently drawn shape. It is set to null
  // if no shape is currently being drawn
  public DrawnShape currentlyDrawnShape = null;

  public DrawingList() {
  }

  public void blackwhite()
  {

    for (DrawnShape s : selectList)
    {
      print("wooow");
       if (s.isImage)
       {
         print("wooow");
       }
    }
  }



  public void drawMe() {
    for (DrawnShape s : shapeList) {
      s.drawMe();
    }
  }

  public void Delete() {
    boolean flag = true;
    while (flag) {
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          shapeList.remove(s);
          break;
        }
      }
      flag = false;
      for (DrawnShape s : shapeList) {
        if (s.isSelected) {
          flag = true;
        }
      }
    }
  }

  public void DeleteAll()
  {
    shapeList.clear();
    selectList.clear();
  }
  
  public void changeFill(color Colour){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeFill(Colour);
      }
    }
  }
  
  public void changeLine(color Colour){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeLine(Colour);
      }
    }
  }
  
  public void changeWeight(int weight){
    for (DrawnShape s: shapeList){
      if (s.isSelected == true){
        s.changeWeight(weight);
      }
    }
  }


  public void handleMouseDrawEvent(String shapeType, String mouseEventType, PVector mouseLoc) {





      if ( mouseEventType.equals("mousePressed")) {
        isDrawing = true;
        DrawnShape newShape;
        if ( shapeType.equals("draw image") ) {
          newShape = new ImageShape();
          ((ImageShape)newShape).setSourceImage(SourceImage);
        } else {
          newShape = new DrawnShape( shapeType );
        }



        newShape.startMouseDrawing(mouseLoc);
        shapeList.add(newShape);
        currentlyDrawnShape = newShape;
      }

      if ( mouseEventType.equals("mouseDragged")) {
        if (isDrawing) {
          currentlyDrawnShape.duringMouseDrawing(mouseLoc);
        }
      }

      if ( mouseEventType.equals("mouseReleased")) {
        if (isDrawing) {
          currentlyDrawnShape.endMouseDrawing(mouseLoc);
        }      
        isDrawing = false;
      }
    }

    public void trySelect(String mouseEventType, PVector mouseLoc) {
      if ( mouseEventType.equals("mousePressed")) {
        selectList.clear();
        for (DrawnShape s : shapeList) { 

          boolean prvSelect = s.isSelected;
          boolean selectionFound = s.tryToggleSelect(mouseLoc);



          if (selectionFound) {

            for (DrawnShape ss : shapeList)
            {
              if (ss.isSelected)
              {
                selectList.add(ss);
              }
            }
            print(selectList.size());
            break;
          }
        }
      }
    }
  }
