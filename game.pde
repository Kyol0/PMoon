import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
ArrayList<String> hand;
ArrayList<String> selected;
PShape Rfx;
PShape Gfx;
PImage background;
PShape Rsprite; 
PShape Gsprite;
boolean turn;
Roland enemy;
Gebura player;
void setup(){
  size(1920,1080);
  enemy = new Roland();
  player = new Gebura();
  background = loadImage("backgrounds/phase1bg.png");
  println("1");
  //sfx = new SoundFile(this,"music/Roland_1.mp3");
  //sfx.play();
  phasechange();
  println("done");
}
void draw(){
  //image(background,0,0);
  //if(!sfx.isPlaying())
    //sfx.loop();
   
}
void phasechange(){
  for(int i=width;i>=0;i-=30){
    image(background,0,0);
    println("2");
    noStroke();
    fill(255,255,0);
    rect(0,0,i,height);
    delay(10);
  }  
}
