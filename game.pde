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
boolean phasechange=true;
boolean draw;
boolean turn;
boolean finished;
float i = 0;
PShape transition;
void setup(){
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
  
  //changes the background and the music to align with the phase change
  if(phasechange){
    println("here");
    if(enemy.phase==2){
      background=loadImage("backgrounds/phase2bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_2.mp3");
        bgm.play();
      }
      enemy.changeHP(100);
    }
    if(enemy.phase==3){
      background=loadImage("backgrounds/phase3bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_3.mp3");
        bgm.play();
      }
      enemy.changeHP(100);
    }
    if(enemy.phase==4){
      background=loadImage("backgrounds/phase4bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Gone_Angels.mp3");
        bgm.play();
      }
      enemy.changeHP(100);
    }
    image(background,0,0,1152,648);
    shape(transition,i,0);
    if(i>=width){
      phasechange = false;
      i=0;
    }
    i+=200;
  }  
  else{
    
    //makes sure the background is constantly being refreshed
    image(background,0,0,1152,648);
    
    //checks if the music is looping
    if(!bgm.isPlaying())
      bgm.loop();
    
    //if it is draw phase, draws cards randomly based on how many cards will be in your hand
    if(draw){
      
    }
    
    //check if Gebura is dead
    if(player.hp<=0){
      finished = true;
      image(background,0,0,1152,648);
      transition.setFill(0);
      if(i<height){
        image(background,0,0,1152,648);
        shape(transition,0,i-648);
        i+=200;
      }
      else if (i>=height){
        shape(transition,0,0);
        textSize(100);
        fill(255,0,0);
        text("DEFEAT",width/2-230,height/2);
        fill(255);
        rect(width/2-130,height*3/4-15,200,100);
        textSize(50);
        if(mouseX>width/2-130&&mouseX<width/2+70&&mouseY>height*3/4-15&&mouseY<height*3/4+85){
          if(mousePressed)
            fill(100);
          else
            fill(255,0,0);
        }
        else  
          fill(100);
        text("Retry",width/2-100,height*3/4+50);
      }
    }
    
    //checks if Roland is dead or is moving to next phase
    if(enemy.hp<=0&&enemy.phase!=4){
      println("oh");
      enemy.phase++;
      phasechange=true;
      bgm.pause();
    }
    //roland is defeated
    else if(enemy.hp<=0 && enemy.phase==4){
      finished = true;
      println("done");
      Rsprite=loadImage("roland/rolanddefeated.png");
      image(background,0,0,1152,648);
      transition.setFill(0);
      if(i<height){
        image(background,0,0,1152,648);
        shape(transition,0,i-648);
        i+=200;
      }
      else if (i>=height){
        shape(transition,0,0);
        textSize(100);
        fill(0,255,0);
        text("VICTORY",width/2-230,height/2);
        fill(255);
        rect(width/2-130,height*3/4-15,200,100);
        textSize(50);
        if(mouseX>width/2-130&&mouseX<width/2+70&&mouseY>height*3/4-15&&mouseY<height*3/4+85){
          if(mousePressed)
            fill(100);
          else
            fill(255,0,0);
        }
        else  
          fill(100);
        text("Retry",width/2-100,height*3/4+50);
      }
    }
  } 
}
//restarts the game
void reset(){
  enemy = new Roland();
  player = new Gebura();
  background = loadImage("backgrounds/phase1bg.png");
  bgm = new SoundFile(this,"music/Roland_1.mp3");
  bgm.play();
  transition.setFill(color(255,255,0));
  finished = false;
  phasechange = true;
  i=0;
}

void mouseClicked(){
  if(finished){
    if(mouseX>width/2-130&&mouseX<width/2+70&&mouseY>height*3/4-15&&mouseY<height*3/4+85)
      reset();  
  }
  else if(enemy.phase ==1)
    enemy.damaged(200);
  else
    player.damaged(100);
}
