/**
 * Parameterize: Wave
 * from Form+Code in Design, Art, and Architecture 
 * by Casey Reas, Chandler McWilliams, and LUST
 * Princeton Architectural Press, 2010
 * ISBN 9781568989372
 * 
 */

// modified by Caroline for the Ellis School Drawing with Code workshop. 

// These below are the global variables.

int brickWidth;
int brickHeight;
int cols = 20;
int rows = 24;
int columnOffset = 60;
int rowOffset = 30;
float rotationIncrement = 0.15;


//void setup is the 'start-up' procedure for Processing Sketches.
void setup() {

  //size of the application window in pixels.
  size(1200, 768);

  smooth();
  noFill();
  // this sets how many times the draw function loops per second.
  frameRate(1);
}

//The draw function runs every frame. 
void draw() {

  //color of the background in an RGB scale.
  background(255, 255, 255);
  //brickWidth is just that, the width of the individual bricks. right now, they are set to 40pix wide.
  brickWidth = 26;
  //brickHeight is the same. 15pix wide.
  brickHeight = 108;
  //cols is the number of columns of bricks total.
  cols = 11;
  //rows is the number of rows of bricks total.
  rows = 9;
  //columnOffset is the distance between each of the bricks in the columns.
  columnOffset = 142;
  //rowOffset is the distance between each of the bricks in the rows.
  rowOffset = 72;
  //how 'drastically' the wave is changing the orientation of the bricks. 
  rotationIncrement = 0.66;

  // the color of the strokes
  stroke(0, 0, 0);

  translate(30, 30);
  for (int i=0; i<cols; i++) {
    pushMatrix();
    translate(i * columnOffset, 34);
    float r = random(-QUARTER_PI, QUARTER_PI);
    int dir = 1;
    for (int j=0; j<rows; j++) {
      pushMatrix();
      translate(-92, rowOffset * j);
      rotate(r);
      rect(-brickWidth/2, -brickHeight/2, brickWidth, brickHeight);
      popMatrix();
      r += dir * rotationIncrement;
      if (r > QUARTER_PI || r < -QUARTER_PI) dir *= -1;
    }
    popMatrix();
  }
}


void keyPressed() {
  if (key == 's' ) {
    println ("saving new drawing!");
    save("crazyWaves_" +millis()+ ".jpg");
  }
}
