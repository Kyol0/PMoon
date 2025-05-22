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
  Gsprite = loadShape("kali/Kali-combat-sprite-idle.svg");
}
void draw(){
  image(background,0,0);
  if(!sfx.isPlaying())
    sfx.loop();
   shape(Gsprite, 200,500,26,26);
}
void phasechange(){
  
}
