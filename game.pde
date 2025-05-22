import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
ArrayList<String> hand;
ArrayList<String> selected;
PImage fx;
PImage background;
PImage RSprite; 
PImage GSprite;
boolean turn;
Roland enemy;
Gebura player;
void setup(){
  enemy = new Roland();
  player = new Gebura();
  background = loadImage("phase1bg.png");
}
void draw(){
  image(background,0,0);
}
