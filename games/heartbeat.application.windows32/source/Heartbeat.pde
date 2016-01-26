/*   
//  INSTRUCTIONS FOR USE
//  - The code to initiate reading a serial port inside setup() is commented out. To use the pulse sensor, uncomment it.
//  - To generate a pattern, press ANY KEY or the LET MOUSE CLICK.
//  - Color depends on BPM (faster BPM -> warmer colors)
//  - Pattern generates on KEY, MOUSE CLICK, or with PULSE.
*/


// import serial library
import processing.serial.*;

// off-screen buffer
PGraphics osb;

// serial port for input from Arduino
Serial port;     

int Sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM = 100;         // HOLDS HEART RATE VALUE FROM ARDUINO 
int heart = 0;   // This variable times the heart image 'pulse' on screen
boolean beat = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced

// whether or not to display pattern
boolean displayPattern;

// list of patterns to display
ArrayList<CirclePatternCreator> circlePatterns;
ArrayList<RippleCreator> ripples;

// location in center of screen to center patterns
int _xCenter;
int _yCenter;

// ------------------RANGES-------------------
// variables which control RANGES for randomization of pattern properties
final int _minRadius = 2;
final int _maxRadius = 500;

final int _minItemSize = 5;
final int _maxItemSize = 100;

final int _minNumItems = 3;
final int _maxNumItems = 100;

final int _minNumRipples = 5;
final int _maxNumRipples = 100;

final int _minAlpha = 30;
final int _maxAlpha = 100;

final int _minRingAlpha = 30;
final int _maxRingAlpha = 100;

int _rMin = 100;
int _gMin = 100;
int _bMin = 100;
int _rMax = 200;
int _gMax = 200;
int _bMax = 200;

final int _maxNumRippleSets = 15;
final int _maxNumCirclePatterns = 50;
final int _maxNumPatterns = 15;
// ------------------END RANGES-------------------

// runs once
void setup(){
  
  // size of display
  size(1800, 1000);
  
  // off-screen buffer
  osb = createGraphics(width, height);
  /* Clear the off-screen buffer. */ {
    osb.beginDraw();
    fill(#000000, 1);
    rect(0, 0, width, height);
    osb.endDraw();
  }
  
  // initiate list of ripples
  ripples = new ArrayList<RippleCreator>();
  circlePatterns = new ArrayList<CirclePatternCreator>();
  
  // find center of screen
  _xCenter = width/2;
  _yCenter = height/2;
  
  // GO FIND THE ARDUINO
  println(Serial.list());    // print a list of available serial ports
  // choose the number between the [] that is connected to the Arduino
  
  // !!! UNCOMMENT TO USE ARDUINO
  /*
  port = new Serial(this, "COM4", 115200);  // make sure Arduino is talking serial at this baud rate
  port.clear();            // flush buffer
  port.bufferUntil('\n');  // set buffer full flag on receipt of carriage return
  */
  
}


void draw(){
  
  osb.beginDraw();
  // ----------BEGIN OSB DRAW----------
    // looks cooler than regular blend mode
    blendMode(MULTIPLY);
    
    // controls timing of pulse; 20 = start of beat
    // AddNewPattern() creates a new pattern on screen
    if(heart == 20)
      AddNewPattern();
    heart --;
    // don't go lower than 0
    heart = max(heart, 0);
    
    // clear old images, draw new background
    background(240);
    
    // draw all ripples and patterns generated to create ONE whole pattern
    for(int i=0; i<ripples.size(); i++){
      ripples.get(i).DrawRipple();
    }
    for(int i=0; i<circlePatterns.size(); i++){
      circlePatterns.get(i).DrawPattern();
    }
  // ----------END OSB DRAW----------
  osb.endDraw();
  
  image(osb, 0, 0, width, height);
  
}

// draw new pattern on mouse click
void mouseClicked(){
  AddNewPattern();
}

// draw new pattern on key type
void keyTyped(){
  AddNewPattern();
}


private void AddNewPattern(){
  
  // determine color range based on heart rate
  // lower heart rate = bluer
  // higher heart rate = redder
  _rMax = max((int)map(BPM, 0, 200, 0, 255), 0);
  _gMax = max((int)map(BPM, 0, 200, 200, 0), 0);
  _bMax = max((int)map(BPM, 0, 200, 255, 0), 0);
  
  
  // make sure it's working- print to Processing output window
  println("BPM: " + BPM);
  println("rMax: " + _rMax);
   println("gMax: " + _gMax);
    println("bMax: " + _bMax);
    
  
  // create new pattern
  ripples.clear();
  int numRippleSets = (int)random(1, _maxNumRippleSets);
  for(int i=0; i<=numRippleSets; i++){
    ripples.add( new RippleCreator((int)lerp(_minRadius,_maxRadius, pow(random(0,1), 0.75)), (int)random(_minNumRipples,_maxNumRipples), (int)random(_rMin, _rMax), (int)random(_gMin, _gMax), (int)random(_bMin, _bMax), _xCenter, _yCenter, random(_minRingAlpha,_maxRingAlpha) ) );
  }
  
  circlePatterns.clear();
  int numCirclePatterns = (int)random(1, _maxNumCirclePatterns);
  for(int i=0; i<=numCirclePatterns; i++){
    circlePatterns.add(new CirclePatternCreator(_xCenter, _yCenter, (int)random(_minRadius,_maxRadius), (int)random(_minItemSize,_maxItemSize), (int)random(_rMin, _rMax), (int)random(_gMin, _gMax), (int)random(_bMin, _bMax), 1, (int)random(_minNumItems,_maxNumItems), Shape.circle, random(_minAlpha,_maxAlpha) ) );
  }
  int numLinePatterns = (int)random(1, _maxNumPatterns);
  for(int i=0; i<=numLinePatterns; i++){
    circlePatterns.add(new CirclePatternCreator(_xCenter, _yCenter, (int)random(_minRadius,_maxRadius), (int)random(_minItemSize,_maxItemSize), (int)random(_rMin, _rMax), (int)random(_gMin, _gMax), (int)random(_bMin, _bMax), 1, (int)random(_minNumItems,_maxNumItems), Shape.line, random(_minAlpha,_maxAlpha) ) );
  }
  
}


void serialEvent(Serial port){ 
   String inData = port.readStringUntil('\n');

   if (inData == null) {                 // bail if we didn't get anything
     return;
   }   
   if (inData.isEmpty()) {                // bail if we got an empty line
     return;
   }
   inData = trim(inData);                 // cut off white space (carriage return)   
   if(inData.length() <= 0) {             // bail if there's nothing there
     return;
   }

   if (inData.charAt(0) == 'S'){          // leading 'S' for sensor data
     inData = inData.substring(1);        // cut off the leading 'S'
     Sensor = int(inData);                // convert the string to usable int
   }
   if (inData.charAt(0) == 'B'){          // leading 'B' for BPM data
     inData = inData.substring(1);        // cut off the leading 'B'
     BPM = int(inData);                   // convert the string to usable int
     beat = true;                         // set beat flag to advance heart rate graph
     heart = 20;                          // begin heart image 'swell' timer
   }
 if (inData.charAt(0) == 'Q'){            // leading 'Q' means IBI data 
     inData = inData.substring(1);        // cut off the leading 'Q'
     IBI = int(inData);                   // convert the string to usable int
   }
}