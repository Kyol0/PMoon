import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
ArrayList<String> hand;
ArrayList<String> selected;
PImage Rfx;
PImage Gfx;
PImage background;
PImage Rsprite; 
PImage Gsprite;
boolean turn;
Roland enemy;
Gebura player;
boolean phasechange=false;
float i = 0;
PShape transition;
void setup(){
  frameRate(240);
  size(1152,648);
  //player setup
  enemy = new Roland();
  player = new Gebura();
  //load image
  background = loadImage("backgrounds/phase1bg.png");
  //transition
  transition = createShape(RECT,0,0,1152,648);
  transition.setStroke(false);
  transition.setFill(color(255,255,0));
  //music 
  sfx = new SoundFile(this,"music/Gone_Angels.mp3");
  sfx.play();
  
  turn = true;

  
  
}
void draw(){
  if(!phasechange){
    //background(backgound);
    if(!sfx.isPlaying())
      sfx.loop();
  }
  else if(phasechange){
    image(background,0,0,1152,648);
    shape(transition,i,0);
    i+=30;
    println(i);
    if(i>=width){
      phasechange = false;
      i=0;
    }
  }
}


void mouseClicked(){
  phasechange=true;
}
