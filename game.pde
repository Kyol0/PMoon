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
Roland enemy;
Gebura player;
boolean phasechange=false;
boolean draw;
boolean turn;
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
  bgm = new SoundFile(this,"music/Roland_1.mp3");
  bgm.play();
}
void draw(){
  if(phasechange){
    if(enemy.phase==2){
      bgm = new SoundFile(this,"music/Roland_2.mp3");
      background=loadImage("backgrounds/phase2bg.png");
      bgm.play();
    }
    if(enemy.phase==3){
      bgm = new SoundFile(this,"music/Roland_3.mp3");
      background=loadImage("backgrounds/phase3bg.png");
      bgm.play();
    }
    if(enemy.phase==4){
      bgm = new SoundFile(this,"music/Gone_Angels.mp3");
      background=loadImage("backgrounds/phase4bg.png");
      bgm.play();
    }
    image(background,0,0,1152,648);
    shape(transition,i,0);
    i+=30;
    println(i);
    if(i>=width){
      phasechange = false;
      i=0;
    }
  }  
  else{
    if(!bgm.isPlaying())
      bgm.loop();
      
  }
}


void mouseClicked(){
  phasechange=true;
}
