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
  //sfx = new SoundFile(this,"music/Roland_1.mp3");
  //sfx.play();
  println("done");
}
void draw(){
  int count =0;
  if(count==0){
    count=1;
    phasechange();
  }
  image(background,0,0);
  //if(!sfx.isPlaying())
    //sfx.loop();
   
}
void phasechange(){
  for(int i=width;i>=0;i-=30){
    image(background,0,0);
    noStroke();
    fill(255,255,0);
    rect(0,0,i,height);
    println("2");
    delay(10);
  }
}
