import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
ArrayList<String> hand;
ArrayList<String> selected;
PImage Rfx;
PImage Gfx;
PImage background;
PImage RSprite; 
PImage GSprite;
boolean turn;
Roland enemy;
Gebura player;
void setup(){
  size(1920,1080);
  enemy = new Roland();
  player = new Gebura();
  background = loadImage("phase1bg.png");
  sfx = new SoundFile(this,"Roland_1.mp3");
  sfx.play();
}
void draw(){
  image(background,0,0);
  if(!sfx.isPlaying())
    sfx.loop();
  
}
void phasechange(){
  
}
