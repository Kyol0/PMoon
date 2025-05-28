import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
ArrayList<Integer> hand;
int current = 0; //index for the cards that will show up on the screen;
ArrayList<Integer> selected;
PImage Rfx;
PImage Gfx;
PImage background;
PImage Rsprite; 
PImage Gsprite;
Roland enemy;
Gebura player;
boolean phasechange=true;//phase change
boolean draw; //draw phase
boolean drawn; //if cards have been drawn
boolean turn; //selecting cards phase
boolean animate; //attack phase
boolean finished; //if the game has ended
boolean EGO; //checks if EGO cards has been selected
float i = 0;
PShape transition; //transition screen
void setup(){
  size(1152,648);
  
  //enemy setup
  enemy = new Roland();
  Rsprite = loadImage("roland/rolandidle.png");
  
  //player setup
  player = new Gebura();
  Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
  hand = new ArrayList<Integer>();
  selected = new ArrayList<Integer>();
  hand.add((int)random(5));
  hand.add((int)random(5));
  hand.add((int)random(5));
  
  
  //load image
  background = loadImage("backgrounds/phase1bg2.png");
  
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
    if(enemy.phase==2){
      enemy.changeHP(1000);
      enemy.changeStagger(150);
      background=loadImage("backgrounds/phase2bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_2.mp3");
        bgm.play();
      }
    }
    if(enemy.phase==3){
      enemy.changeHP(400);
      enemy.changeStagger(200);
      background=loadImage("backgrounds/phase3bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_3.mp3");
        bgm.play();
      }
    }
    if(enemy.phase==4){
      enemy.changeHP(999);
      enemy.changeStagger(500);
      background=loadImage("backgrounds/phase4bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Gone_Angels.mp3");
        bgm.play();
      }
    }
    fill(255,255,0);
    image(background,0,0,1152,648);
    image(Gsprite,700,340,122.4,142.6);
    image(Rsprite,300,340,35.2,99.6);
    rect(0,0,200,200);
    rect(width-200,0,200,200);
    circle(width/2,0,100);
    shape(transition,i,0);
    if(i>=width){
      phasechange = false;
      i=0;
      draw=true;
      drawn = true;
    }
    i+=200;
  }  
  else{
    
    //makes sure the background is constantly being refreshed with the display board to show health and other stats
    image(background,0,0,1152,648);
    image(Gsprite,700,340,122.4,142.6);
    image(Rsprite,300,340,35.2,99.6);
    fill(255,0,0);
    rect(0,0,200,200);
    fill(0);
    textSize(50);
    text("Roland",15,55);
    textSize(25);
    println(enemy.hp);
    text("HP:" + enemy.hp,15,75);
    text("Stagger: " + enemy.stagger,15,130);
    fill(0,0,255);
    rect(width-200,0,200,200);
    fill(0);
    textSize(50);
    text("Gebura",width-170,55);
    textSize(25);
    text("HP: " + player.hp,width-170,75);
    text("Stagger: " + player.stagger,width-170,110);
    text("Light: " + player.light + "/" + player.maxLight,width-170,145);
    text("Emotion Lvl: " + player.emotionlvl,width-170,180);
    fill(255,255,0);
    circle(width/2,0,100);
   
    //checks if the music is looping
    if(!bgm.isPlaying())
      bgm.loop();
    
    //if it is draw phase, draws cards randomly based on how many cards will be in your hand
    if(draw){
      if(!drawn){
        hand.add((int)random(5));
        drawn=true;
      }
      for(int i=0;i<current;i++){
        PImage page;
        rect(width/4*3-105*(i+1),height-125,100,125);
        page = loadImage("kali/CardManifestEgoArt.png");
        image(page,width/4*3-105*(i+1),height-100,100,76);
        textSize(12);
        fill(0);
        text(player.egopages[2],width/4*3-105*(i+1)+10,height-105);
      }
      delay(150);
      current++;
      if(current>=hand.size()){
        draw = false;
        turn = true;
      }
    }
    
    //if it is attack phase, uses the cards selected and compare the values of kalis and rolands
    if(animate){
      
    }
    
    //if it is the selection phase, lets the player select cards and compare them through hovering over the cards
    if(turn){
      for(int i=0;i<current;i++){
        PImage page;
        fill(0,255,0);
        rect(width/4*3-105*(i+1),height-125,100,125);
        page = loadImage("kali/CardManifestEgoArt.png");
        image(page,width/4*3-105*(i+1),height-100,100,76);
        textSize(12);
        fill(0);
        text(player.egopages[2],width/4*3-105*(i+1)+10,height-105);
      }  
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
      enemy.phase++;
      phasechange=true;
      bgm.pause();
    }
    
    //roland is defeated
    else if(enemy.hp<=0 && enemy.phase==4){
      finished = true;
      Rsprite=loadImage("roland/rolanddefeated.png");
      transition.setFill(0);
      if(i<height){
        image(background,0,0,1152,648);
        image(Gsprite,700,340,122.4,142.6);
        image(Rsprite,300,360,136.5,83.4);
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
  bgm.pause();
  enemy = new Roland();
  player = new Gebura();
  Rsprite = loadImage("roland/rolandidle.png");
  Gsprite= loadImage("kali/Kali-combat-sprite-idle.png");
  background = loadImage("backgrounds/phase1bg2.png");
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
  enemy.damaged(999);
}
