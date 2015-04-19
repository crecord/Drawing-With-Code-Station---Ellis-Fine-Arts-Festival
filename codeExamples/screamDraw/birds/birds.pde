/**
 * Flocking 
 * by Daniel Shiffman.  
 * 
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on 
 * rules of avoidance, alignment, and coherence.
 * 
 * Click the mouse to add a new boid.
 */

Flock flock;
import processing.sound.*;

//global variables. 
//
Amplitude amp;
AudioIn audioInput;
float volume; 
float mappedVolume; 

void setup() {
  //size(640, 800);
  size(displayWidth, displayHeight);
  flock = new Flock();
  // Add an initial set of boids into the system

  
  amp = new Amplitude(this);
  audioInput = new AudioIn(this, 1);
  audioInput.play();
  amp.input(audioInput);
}

void draw() {
  
  volume = amp.analyze();
  mappedVolume = map(volume, 0, .1, 0, 90);
  if (mappedVolume > 6 ){
    mappedVolume = map(mappedVolume, 6, 90, 1.5, 3);
    Boid bid = new Boid(width/2,height/2);
    bid.r = mappedVolume;
    //fill(246,147,142); 
    //stroke(120,228,244);
    fill(246,147,142); 
    stroke(120,228,244);
    flock.addBoid(bid);
  }
  else{
    flock.removeBoid();  
  }
  println("mapped vol: "+ mappedVolume); 
  background(255,255,255);
  flock.run();
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}

void keyPressed() {
  if (key == 's' ) {
    println ("saving new drawing!");
    save("birds_" +millis()+ ".jpg");
  }
}
