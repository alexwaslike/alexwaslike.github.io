class CirclePatternCreator{
  
  int x, y;                  // location
  float radius, dotRadius;    // radius of items inside pattern (dots or lines)
  int r, g, b;
  int numCircles;
  
  float _minAlpha = 15;
  private float alpha;
  float alphaDelta;
  
  private int rotation;
  private float dotDistance;
  
  boolean done = false;
  
  Shape shape;
  
  int speed;
  
  CirclePatternCreator(int x, int y, float rad, float dotRad, int r, int g, int b, float ad, int num, Shape shp, float minAlp){
   this.x = x;
   this.y = y;
   radius = rad;
   dotRadius = dotRad;
   this.r = r;
   this.g = g;
   this.b = b;
   alphaDelta = ad;
   numCircles = num;
   
   shape = shp;
   
   _minAlpha = minAlp;
   
   // calculate object distance from eachother
   // based on number of circles
   dotDistance = 360/numCircles;
   
   alpha = 100;
   
   rotation = 0;
   
   speed = (int)random(-2, 2);
  }
  
  void DrawPattern(){
    
    
    if(done){
      for(int deg = rotation; deg < 360+rotation; deg += dotDistance){
        float angle = radians(deg);
        float xLoc = x + (cos(angle) * radius);  
        float yLoc = y + (sin(angle) * radius);  
        
        if(shape == Shape.circle){
          noStroke();
          fill(r, g, b, _minAlpha); 
          ellipse(xLoc, yLoc, dotRadius, dotRadius);
        } else if(shape == Shape.line){
          stroke(r, g, b, _minAlpha);
          line(xLoc, yLoc, xLoc + (cos(angle) * dotRadius), yLoc + (sin(angle) * dotRadius));
        }
      }
    } else {  // STOP TURNING AFTER RIPPLES DONE 
      for(int deg = rotation; deg < 360+rotation; deg += dotDistance){
        float angle = radians(deg);
        float xLoc = x + (cos(angle) * radius);  
        float yLoc = y + (sin(angle) * radius);  
        
        if(shape == Shape.circle){
          noStroke();
          fill(r, g, b, alpha); 
          ellipse(xLoc, yLoc, dotRadius, dotRadius);
        } else if(shape == Shape.line){
          stroke(r, g, b, alpha);
          line(xLoc, yLoc, xLoc + (cos(angle) * dotRadius), yLoc + (sin(angle) * dotRadius));
        }
      }
      alpha -= alphaDelta;
      
      rotation += speed;
      
      if(alpha <= _minAlpha) done = true;
    }
    
  }
  
  
  
}