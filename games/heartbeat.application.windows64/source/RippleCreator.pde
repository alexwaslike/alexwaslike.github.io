class RippleCreator{
  
  float minRadius, maxRadius;
  int x, y;
  
  int numRipples;
  
  int r, g, b;
  
  private final float _maxAlpha = 100;
  float _minAlpha = 15;
  
  // makes ripples increasingly far away from each other
  private final float _rMult = 1.5;
  
  // for incrementing ripple properties
  float alphaDelta;
  
  Ripple[] ripples;
  
  int step = 0;
  
  boolean done = false;
  
  final int _minLineWeight = 1;
  final int _maxLineWeight = 5;
  
  RippleCreator(float min, int num, int r, int g, int b, int x, int y, float minAlp){
    minRadius = min;
    numRipples = num;
    this.r = r;
    this.g = g;
    this.b = b;
    this.x = x;
    this.y = y;
    
    _minAlpha = minAlp;
    
    // calculate alpha change based on max alpha and num ripples
    alphaDelta = (_maxAlpha - _minAlpha)/ numRipples;
    
    // fill array of Ripples with prepared locations and rgb and at max alpha
    ripples = new Ripple[numRipples];
    float rStep = minRadius;
    for(int i=0; i<ripples.length; i++){
      
      ripples[i] = new Ripple(x, y, rStep, _maxAlpha, r, g, b);
      
      rStep *= _rMult;
    }
    
  }
  
  
  void DrawRipple(){
    
    noFill();
    strokeWeight((int)random(_minLineWeight, _maxLineWeight));
    
    if(done){
      
      for(int i=0; i<step; i++){
        ripples[i].alpha = _minAlpha; 
        
        stroke(r, g, b, ripples[i].alpha);
        ellipse(x, y, ripples[i].radius, ripples[i].radius);
      }
      
    } else {
        // fade ripples before step
        // draw all ripples up to step
        for(int i=0; i<step; i++){
          ripples[i].alpha -= alphaDelta; 
          
          stroke(r, g, b, ripples[i].alpha);
          ellipse(x, y, ripples[i].radius, ripples[i].radius);
        }
        
        // increase step
        if(step < ripples.length-1)
          step++;
        else
          alphaDelta+=0.07;
        
        if(ripples[ripples.length-2].alpha <= _minAlpha) done = true;
      }
      
      
      
  }
  
  
  
}