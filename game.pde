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
  sfx = new SoundFile(this,"music/Roland_1.mp3");
  sfx.play();
  //Rsprite = loadImage("roland/rolandidle.png");
  Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
}
void draw(){
  image(background,0,0);
  if(!sfx.isPlaying())
    sfx.loop();
  image(Gsprite,900,200);
}
void phasechange(){
  
}
