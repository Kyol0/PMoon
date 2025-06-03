import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
PVector mousepos = new PVector(mouseX,mouseY);
PVector corner;
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
boolean EgoOn; //checks if red mist is active
float i = 0;
PShape transition; //transition screen
int scene; //current turn
boolean spear; //checks if spear passive is active
boolean level; //checks if level slash passive is active
boolean upstand; //checks if upstanding slash passive is active 
void setup(){
  size(1152,648);
  corner = new PVector(width,height);
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
  dupeCheck((int)random(5));
  scene = 1;
  
  
  
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
  
  //update mouseposition;
  mousepos.set(mouseX,mouseY);

  //changes the background and the music to align with the phase change
  if(phasechange){
    turn = false;
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
    image(background,0,0,1152,648);
    image(Gsprite,700,340,122.4,142.6);
    image(Rsprite,300,340,35.2,99.6);
    fill(0);
    rect(0,0,200,200);
    fill(255);
    textSize(50);
    text("Roland",15,55);
    textSize(25);
    text("HP:" + enemy.hp,15,75);
    text("Stagger: " + enemy.stagger,15,130);
    fill(255,0,0);
    rect(width-200,0,200,200);
    fill(0);
    textSize(50);
    text("Gebura",width-170,55);
    textSize(25);
    text("HP: " + player.hp,width-170,75);
    text("Stagger: " + player.stagger,width-170,110);
    text("Light: " + player.light + "/" + player.maxLight,width-170,145);
    text("Emotion Lvl: " + player.emotionlvl,width-170,180);
   if(player.egoCount >=9){
      fill(158,0,0);
      circle(width,height,200);
      textSize(25);
      fill(0);
      text("E.G.O \nPages", width-70,height-50);
    }
    fill(255,255,0);
    circle(width/2,0,100);
    shape(transition,i,0);
    if(i>=width){
      phasechange = false;
      i=0;
      draw=true;
      drawn = false;
      current= 0;
    }
    i+=200;
  }  
  else{
    
    //makes sure the background is constantly being refreshed with the display board to show health and other stats
    image(background,0,0,1152,648);
    image(Gsprite,700,340,122.4,142.6);
    image(Rsprite,300,340,35.2,99.6);
    fill(0);
    rect(0,0,200,200);
    fill(255);
    textSize(50);
    text("Roland",15,55);
    textSize(25);
    text("HP:" + enemy.hp,15,75);
    text("Stagger: " + enemy.stagger,15,130);
    text("Scene: " + scene, 15,160);
    fill(255,0,0);
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
    if(player.egoCount >=9){
      fill(158,0,0);
      circle(width,height,200);
      textSize(25);
      fill(0);
      text("E.G.O \nPages", width-70,height-50);
    }
    else{
      fill(150);
      circle(width,height,200);
      textSize(25);
      fill(0);
      text("E.G.O \nPages", width-70,height-50);
    }
   
    //checks if the music is looping
    if(!bgm.isPlaying())
      bgm.loop();
      
    SoundFile cards = new SoundFile(this,"other_sfx/Card_Over.wav");
    
    //if it is draw phase, draws cards randomly based on how many cards will be in your hand
    if(draw){
      if(!drawn){
        dupeCheck((int)random(5));
        drawn=true;
      }
      for(int i=0;i<=current;i++){
        PImage page;
        
        //classifies kali's normal pages
          if(hand.get(i)==0){
           fill(146, 200, 139);
           page = loadImage("kali/CardUpstandingSlashArt.png");
          }
          else if(hand.get(i)==1){
            fill(146, 200, 139);
            page = loadImage("kali/CardSpearArt.png");
          }
          else if(hand.get(i)==2){
            fill(146, 200, 139);
            page = loadImage("kali/CardLevelSlashArt.png");
          }
          else if(hand.get(i)==3){
            fill(95, 139, 227);
            page = loadImage("kali/CardFocusSpiritArt.png");
          }
          else if(hand.get(i)==4){
            fill(124, 62, 219);
            page = loadImage("kali/CardOnrushArt.png");
          }
          else if(hand.get(i)==5){
          fill(124, 34, 60);
          page = loadImage("kali/CardManifestEgoArt.png");
        }
        else if(hand.get(i)==6){ //Manifest EGO
          fill(124, 34, 60);
          page = loadImage("kali/CardGreaterSplitVerticalArt.png");
        }
        else{  //Greater Split: Horizontal
          fill(234, 205, 1);
          page = loadImage("kali/CardManifestEgoArt.png"); 
        }
        rect(width/4*3-105*(i+1),height-120,100,125);
        image(page,width/4*3-105*(i+1),height-100,100,76);
        textSize(10);
        fill(0);
        if(hand.get(i)<=4){
          text(player.pages[hand.get(i)],width/4*3-105*(i+1)+3,height-105);
        }
        else{
          text(player.egopages[hand.get(i)-5],width/4*3-105*(i+1)+3,height-105);
        }
      }
      cards.play();
      current++;
      if(current>=hand.size()){
        draw = false;
        turn = true;
        current = 0;
      }
    }
    
    //if it is attack phase, uses the cards selected and compare the values of kalis and rolands
    if(animate){
      
    }
    
    //if it is the selection phase, lets the player select cards and compare them through hovering over the cards
    if(turn){
      
      //opens the ego cards page
      if(EGO){
        fill(158,0,0);
        rect(0,220,width,height);
        textSize(30);
        fill(0);
        text("Select E.G.O Page",20,250);
        if(mouseX>width-50&&mouseY>height-50){
          stroke(255,255,0);
        }
        else{
          stroke(0);
        }
        fill(124,34,60);
        rect(width-50,height-50,50,50);
        fill(0);
        textSize(25);
        text("X", width-30,height-20);
        stroke(0);
        if(player.emotionlvl<4){
          fill(124,34,60);
          if(mouseX>width/2-205/2&&mouseY>height-380&&mouseX<width/2-205/2+210&&mouseY<height-380+330){
            stroke(255,255,0);
          }
          rect(width/2-205/2,height-380,210,330);
          stroke(0);
          PImage ego = loadImage("kali/CardGreaterSplitVerticalArt.png");
          textSize(15);
          fill(0);
          text(player.egopages[1],width/2-205/2+15,height-360);
          text(player.pagedesc[6],width/2-205/2+15,height-170);
          image(ego,width/2-205/2,height-350,210,159);
        }
        else if(EgoOn){
          for(int c= 1; c<=2;c++){
            fill(124,34,60);
           if(c==1){
             if(mouseX>width/2-205/2-110&&mouseY>height-380&&mouseX<width/2-205/2+110&&mouseY<height-380+330){
                stroke(255,255,0);
              }
             rect(width/2-205/2-110,height-380,210,330);
             stroke(0);
             PImage ego = loadImage("kali/CardGreaterSplitVerticalArt.png");
              textSize(15);
              fill(0);
              text(player.egopages[1],width/2-205/2-105,height-360);
              text(player.pagedesc[6],width/2-205/2-105,height-170);
              image(ego,width/2-205/2-110,height-350,210,159);
           }
           else if(c==2){
             if(mouseX>width/2-205/2+120&&mouseY>height-380&&mouseX<width/2-205/2+340&&mouseY<height-380+330){
                stroke(255,255,0);
              }
             rect(width/2-205/2+120,height-380,210,330);
             stroke(0);
             PImage ego = loadImage("kali/CardManifestEgoArt.png");
              textSize(15);
              fill(0);
              text(player.egopages[0],width/2-205/2+125,height-360);
              text(player.pagedesc[5],width/2-205/2+125,height-170);
              image(ego,width/2-205/2+120,height-350,210,159);
           }
          }
        }
        else{
          for(int c= 1; c<=2;c++){
            fill(124,34,60);
           if(c==1){
             if(mouseX>width/2-205/2-110&&mouseY>height-380&&mouseX<width/2-205/2+110&&mouseY<height-380+330){
                stroke(255,255,0);
              }
             rect(width/2-205/2-110,height-380,210,330);
             stroke(0);
             PImage ego = loadImage("kali/CardGreaterSplitVerticalArt.png");
              textSize(15);
              fill(0);
              text(player.egopages[1],width/2-205/2-102,height-360);
              text(player.pagedesc[6],width/2-205/2-102,height-170);
              image(ego,width/2-205/2-110,height-350,210,159);
           }
           else if(c==2){
             if(mouseX>width/2-205/2+120&&mouseY>height-380&&mouseX<width/2-205/2+340&&mouseY<height-380+330){
                stroke(255,255,0);
              }
             fill(234, 205, 1);
             rect(width/2-205/2+120,height-380,210,330);
             stroke(0);
             PImage ego = loadImage("kali/CardManifestEgoArt.png");
              textSize(15);
              fill(0);
              text(player.egopages[2],width/2-205/2+125,height-360);
              text(player.pagedesc[7],width/2-205/2+125,height-170);
              image(ego,width/2-205/2+120,height-350,210,159);
           }
          }
        }
      }
      else{
        for(int i=0;i<hand.size();i++){
        PImage page;
        if(hand.get(i)==0){
         fill(146, 200, 139);
         page = loadImage("kali/CardUpstandingSlashArt.png");
        }
        else if(hand.get(i)==1){
          fill(146, 200, 139);
          page = loadImage("kali/CardSpearArt.png");
        }
        else if(hand.get(i)==2){
          fill(146, 200, 139);
          page = loadImage("kali/CardLevelSlashArt.png");
        }
        else if(hand.get(i)==3){
          fill(95, 139, 227);
          page = loadImage("kali/CardFocusSpiritArt.png");
        }
        else if(hand.get(i)==4){
          fill(124, 62, 219);
          page = loadImage("kali/CardOnrushArt.png");
        }
        else if(hand.get(i)==5){ // Greater Split Horizontal
          fill(124, 34, 60);
          page = loadImage("kali/CardManifestEgoArt.png"); 
        }
        else if(hand.get(i)==6){ 
          fill(124, 34, 60);
          page = loadImage("kali/CardGreaterSplitVerticalArt.png");
        }
        else{  //Manifest Ego
          fill(234, 205, 1);
          page = loadImage("kali/CardManifestEgoArt.png"); 
        }
        
        //mouse hover to show description of the card of kalis
        if(mouseX>width/4*3-105*(i+1)&&mouseX<width/4*3-105*(i+1)+100&&mouseY>height-125&&mouseY<height){
          rect(width-210,210,210,330);
          textSize(15);
          fill(0);
          if(hand.get(i)<=4){
            text(player.pages[hand.get(i)],width-200,235);
          }
          else{
            text(player.egopages[hand.get(i)-5],width-200,235);
          }
          text(player.pagedesc[hand.get(i)],width-200,410);
          image(page,width-210,240,210,159);
          if(hand.get(i)==0){
           fill(146, 200, 139);
          }
          else if(hand.get(i)==1){
            fill(146, 200, 139);
          }
          else if(hand.get(i)==2){
            fill(146, 200, 139);
          }
          else if(hand.get(i)==3){
            fill(95, 139, 227);
          }
          else if(hand.get(i)==4){
            fill(124, 62, 219);
          }
          else if(hand.get(i)==5){
            fill(124, 34, 60);
          }
          else if(hand.get(i)==6){ //Horizontal
            fill(124, 34, 60);
          }
          else{  //Ego
            fill(234, 205, 1);
          }
            
            stroke(255,255,0);
          }
          else{
            stroke(0);
          }
        rect(width/4*3-105*(i+1),height-120,100,125);
        image(page,width/4*3-105*(i+1),height-100,100,76);
        textSize(10);
        fill(0);
        if(hand.get(i)<=4){
          text(player.pages[hand.get(i)],width/4*3-105*(i+1)+3,height-105);
        }
        else{
          text(player.egopages[hand.get(i)-5],width/4*3-105*(i+1)+3,height-105);
        }
        
        if(mousepos.dist(corner)<=100&&player.egoCount>=9){
          stroke(255,255,0);
        }
        else
          stroke(0);
        if(player.egoCount >=9){
          fill(158,0,0);
          circle(width,height,200);
          textSize(25);
          fill(0);
          text("E.G.O \nPages", width-70,height-50);
        }
        else{
          fill(150);
          circle(width,height,200);
          textSize(25);
          fill(0);
          text("E.G.O \nPages", width-70,height-50);
        }
      }  
      stroke(0);
      
      //black silence cards used
      if(scene%4 ==1){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Atelier Logic.png"); 
          }
          else if(i==2){
            rPages = loadImage("roland/Zelkova Workshop.png");
          }
          else if(i==3){
            rPages = loadImage("roland/Allas Workshop.png");
          }
          else if(i==4){
            rPages = loadImage("roland/Ranga Workshop.png"); 
          }
          else{
            rPages = loadImage("roland/Old Boys Workshop.png"); 
          }
          
          //show selected cards
          for(int r=0; r<)
          
          //hover over black silence cards
          if(mouseX>200+i*55&&mouseX<200+i*55+50&&mouseY>300&&mouseY<338){
           stroke(255,255,0);
           rect(200+i*55,300,50,38);
           stroke(0);
           int page;
           if(i==1){
            fill(95, 139, 227);
            page = 7;
            }
            else if(i==2){
              fill(146, 200, 139);
              page = 2;
            }
            else if(i==3){
              fill(95, 139, 227);
              page=0;
            }
            else if(i==4){
              fill(146, 200, 139); 
              page= 5;
            }
            else{
              fill(146, 200, 139); 
              page = 3;
            }
            rect(0,210,210,330);
            image(rPages,0,240,210,159);
            fill(0);
            textSize(15);
            text(enemy.pages[page],10,235);
            text(enemy.pagedesc[page],10,440);
          }
          image(rPages,200+i*55,300,50,38);
        }
      }
      if(scene%4 ==2){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Wheels Industry.png"); 
          }
          else if(i==2){
            rPages = loadImage("roland/Old Boys Workshop.png");
          }
          else if(i==3){
            rPages = loadImage("roland/DurandalPage.png");
          }
          else if(i==4){
            rPages = loadImage("roland/Allas Workshop.png"); 
          }
          else{
            rPages = loadImage("roland/Ranga Workshop.png"); 
          }
          
          //hover over black silence cards
          if(mouseX>200+i*55&&mouseX<200+i*55+50&&mouseY>300&&mouseY<338){
           stroke(255,255,0);
           rect(200+i*55,300,50,38);
           stroke(0);
           int page;
           if(i==1){
            fill(124, 62, 219);
            page = 1;
            }
            else if(i==2){
              fill(146, 200, 139);
              page = 3;
            }
            else if(i==3){
              fill(124, 62, 219);
              page=8;
            }
            else if(i==4){
              fill(95, 139, 227); 
              page= 0;
            }
            else{
              fill(146, 200, 139); 
              page = 5;
            }
            rect(0,210,210,330);
            image(rPages,0,240,210,159);
            fill(0);
            textSize(15);
            text(enemy.pages[page],10,235);
            text(enemy.pagedesc[page],10,440);
          }
          image(rPages,200+i*55,300,50,38);
        }
      }
      if(scene%4 ==3){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Crystal Atelier.png"); 
          }
          else if(i==2){
            rPages = loadImage("roland/Mook Workshop.png");
          }
          else if(i==3){
            rPages = loadImage("roland/Ranga Workshop.png");
          }
          else if(i==4){
            rPages = loadImage("roland/DurandalPage.png"); 
          }
          else{
            rPages = loadImage("roland/Atelier Logic.png"); 
          }
          
          //hover over black silence cards
          if(mouseX>200+i*55&&mouseX<200+i*55+50&&mouseY>300&&mouseY<338){
           stroke(255,255,0);
           rect(200+i*55,300,50,38);
           stroke(0);
           int page;
           if(i==1){
            fill(95, 139, 227);
            page = 6;
            }
            else if(i==2){
              fill(95, 139, 227);
              page = 5;
            }
            else if(i==3){
              fill(146, 200, 139);
              page=5;
            }
            else if(i==4){
              fill(124, 62, 219); 
              page= 8;
            }
            else{
              fill(95, 139, 227); 
              page = 7;
            }
            rect(0,210,210,330);
            image(rPages,0,240,210,159);
            fill(0);
            textSize(15);
            text(enemy.pages[page],10,235);
            text(enemy.pagedesc[page],10,440);
          }
          image(rPages,200+i*55,300,50,38);
        }
      }
      if(scene%4 ==0){
        for(int i = 1; i<=3;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Furioso.png"); 
          }
          else if(i==2){
            rPages = loadImage("roland/DurandalPage.png");
          }
          else{
            rPages = loadImage("roland/DurandalPage.png"); 
          }
          
          //hover over black silence cards
          if(mouseX>200+i*55&&mouseX<200+i*55+50&&mouseY>300&&mouseY<338){
           stroke(255,255,0);
           rect(200+i*55,300,50,38);
           stroke(0);
           int page;
           if(i==1){
            fill(234, 205, 1);
            page = 9;
            }
            else if(i==2){
              fill(124, 62, 219);
              page = 8;
            }
            else{
              fill(124, 62, 219); 
              page = 8;
            }
            rect(0,210,210,330);
            image(rPages,0,240,210,159);
            fill(0);
            textSize(15);
            text(enemy.pages[page],10,235);
            text(enemy.pagedesc[page],10,440);
          }
          image(rPages,200+i*55,300,50,38);
        }
      }
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
  hand = new ArrayList<Integer>();
  hand.add((int)random(5));
  hand.add((int)random(5));
  dupeCheck((int)random(5));
  scene = 1;
}

void mouseClicked(){
  SoundFile click = new SoundFile(this,"other_sfx/Ui_Click.wav");

  click.play();

  //prompt for when the game is over
  if(finished){
    if(mouseX>width/2-130&&mouseX<width/2+70&&mouseY>height*3/4-15&&mouseY<height*3/4+85)
      reset();  
  }

  //close ego page
  if(mouseX>width-50&&mouseY>height-50&&EGO){
    EGO=false;
  }

  //open ego page
  else if(turn&&mousepos.dist(corner)<=100&&player.egoCount>=9){
     EGO = true;
  }

  //select ego page
  if(turn&&EGO){
    if(player.emotionlvl<4){
      if(mouseX>width/2-205/2&&mouseY>height-380&&mouseX<width/2-205/2+210&&mouseY<height-380+330){
        hand.add(6);
        EGO=false;
        player.egoCount-=9;
      }
    }
    else if(EgoOn){
      if(mouseX>width/2-205/2-110&&mouseY>height-380&&mouseX<width/2-205/2+110&&mouseY<height-380+330){
        hand.add(6);
        EGO=false;
        player.egoCount-=9;
      }
      else if(mouseX>width/2-205/2+120&&mouseY>height-380&&mouseX<width/2-205/2+340&&mouseY<height-380+330){
        hand.add(5);
        EGO=false;
        player.egoCount-=9;
      }
    }
    else{
      if(mouseX>width/2-205/2-110&&mouseY>height-380&&mouseX<width/2-205/2+110&&mouseY<height-380+330){
        hand.add(6);
        EGO=false;
        player.egoCount-=9;
      }
      else if(mouseX>width/2-205/2+120&&mouseY>height-380&&mouseX<width/2-205/2+340&&mouseY<height-380+330){
        hand.add(7);
        EGO=false;
        player.egoCount-=9;
      }
    }
  }

  else if(turn){

    //select pages in hand
    for(int r=0;r<hand.size();r++){
      if(mouseX>width/4*3-105*(r+1)&&mouseX<width/4*3-105*(r+1)+100&&mouseY>height-125&&mouseY<height){
        selected.add(hand.remove(r));
      }
    }
    
    //deselect pages from selected
    for(int r=0;r<selected.size();s++){
      if(mouseX){
        hand.add(selected.remove(r));
      }
    }
  }
  
}
void keyPressed(){
  if(key == 'e')
    player.addEmotion(1);
  if(key=='f')
    player.egoCount = 0;
  if(key=='d')
    enemy.damaged(1000);
  if(key=='p')
    player.damaged(1000);
  if(key=='s')
    scene++;
  if(key=='m')
    EgoOn = true;
}
//adds pages into the hand, and makes sure there are a correct corresponding number of pages in the hand
void dupeCheck(int i){
  int count=0;
  for(int c: hand){
     if(c==i) 
       count++;
  }
  if(count >=2||(i==4&&count>=1))
    dupeCheck((int)random(5));
  else if(hand.size()>=8){
    return;
  }
  else
    hand.add(i);
}
