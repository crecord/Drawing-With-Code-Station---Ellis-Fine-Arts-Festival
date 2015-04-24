import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

AudioInput microphone;
final float CLAP_LEVEL = 0.1f; // loudness threshold from 0 to 1
float lastMicLevel = 0.0f;
FFT fft;
float lastClap = 0.0f;
Minim minim; 


import oscP5.*;
OscP5 oscP5;


// num faces found
int found;
// modification of Dan Wilcox's original 
// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;
//float pointx;
//float pointy;

PImage[] lips= new PImage[7];
PImage[] nose= new PImage[9];
PImage[] leftEye= new PImage[11];
PImage[] rightEye= new PImage[11];
PImage[] leftBrow= new PImage[5];
PImage[] rightBrow= new PImage[5];

int lipsIndex; 
int noseIndex; 
int eyeIndex; 
int browIndex; 

void setup() {
  size(displayWidth, displayHeight);
  frameRate(30);

  lipsIndex = 0;
  noseIndex = 0; 
  eyeIndex = 0;
  browIndex = 0; 

  minim = new Minim(this);
  microphone = minim.getLineIn(Minim.MONO, 4096, 44100);
  fft = new FFT(microphone.left.size(), 44100);


  for ( int i = 0; i< lips.length; i++ )
  {
    lips[i] = loadImage("lips/"+ (i +1)+ ".png" );
  }
  for ( int i = 0; i< nose.length; i++ )
  {
    nose[i] = loadImage( "nose/"+(i +1)+ ".png" );
  }
  for ( int i = 0; i< leftEye.length; i++ )
  {
    leftEye[i] = loadImage( "leftEye/"+(i +1)+ ".png" );  
    rightEye[i] = loadImage("rightEye/"+ (i+1) + ".png" );
  }
  for ( int i = 0; i< leftBrow.length; i++ )
  {
    leftBrow[i] = loadImage( "leftBrow/"+(i+1) + ".png" );   
    rightBrow[i] = loadImage( "rightBrow/"+(i +1)+ ".png" );
  }

  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
  //  oscP5.plug(this, "rawRecieved", "/raw");
}

void draw() {  
  background(255);
  stroke(0);
  println ("found is: " + found);
  if (found > 0) {
    translate(map(posePosition.x, 0,640,0, width) , map(posePosition.y,0,480,0,height));
    scale(poseScale);
    noFill();
    image (leftEye[eyeIndex], -20, eyeLeft * -9, 20, 7);
    // ellipse(-20, eyeLeft * -9, 20, 7);
    // ellipse(20, eyeRight * -9, 20, 7);
    image (rightEye[eyeIndex], 20, eyeRight * -9, 20, 7);
    //ellipse(0, 20, mouthWidth* 3, mouthHeight * 3);
    image(lips[lipsIndex], 0, 20, mouthWidth* 3, mouthHeight * 5 ); 
    imageMode(CENTER);
    image(nose[noseIndex], 0, -15, 20, 35); 
    image(leftBrow[browIndex], -20, eyebrowLeft * -5, 25, 5); 
    image(rightBrow[browIndex], 20, eyebrowRight * -5, 25, 5);
  } else {
    println ("not found");
  }

  float currentMicLevel = microphone.mix.level();
  if (currentMicLevel >= CLAP_LEVEL && currentMicLevel > lastMicLevel)
  {
    fft.forward(microphone.left);
    int max = fft.specSize();
    int sum = 0;
    for (int i = max / 2; i < max; i++) {
      sum += fft.getBand(i);
    }

    if (sum > 50) {
      onClap();
    }
  }
  lastMicLevel = currentMicLevel;
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  //println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  //println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  //println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}

public void mouthWidthReceived(float w) {
  //println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  //println("mouth height: " + h);
  mouthHeight = h;
}

public void eyeLeftReceived(float f) {
  //println("eye left: " + f);
  eyeLeft = f;
}

public void eyeRightReceived(float f) {
  //println("eye right: " + f);
  eyeRight = f;
}

public void eyebrowLeftReceived(float f) {
  //println("eyebrow left: " + f);
  eyebrowLeft = f;
}

public void eyebrowRightReceived(float f) {
  //println("eyebrow right: " + f);
  eyebrowRight = f;
}

public void jawReceived(float f) {
  //println("jaw: " + f);
  jaw = f;
}

public void nostrilsReceived(float f) {
  //println("nostrils: " + f);
  nostrils = f;
}

void mousePressed() {
  lipsIndex = int(random(0.0, float(lips.length)));
  noseIndex = int(random(0.0, float(nose.length)));
  eyeIndex = int(random(0.0, float(leftEye.length)));
  browIndex = int(random(0.0, float(leftBrow.length)));
} 


void onClap() {
  if (millis() - lastClap <= 750) {
    println("Double clap!");
    lipsIndex = int(random(0.0, float(lips.length)));
    noseIndex = int(random(0.0, float(nose.length)));
    eyeIndex = int(random(0.0, float(leftEye.length)));
    browIndex = int(random(0.0, float(leftBrow.length)));
  }
  lastClap = millis();
}
void keyPressed() {
  if (key == 's') {
    // save a picture with a unique file name.
    int m = millis();
    save("facePuppet" + m +".jpg");
  } else if (key == 'c') {
    // clear the screen by drawing a white rectangle.
    fill(255);
    rect(0, 0, width, height);
  }
}
