import processing.sound.*;
SoundFile bgm;
SoundFile sfx;
PVector mousepos = new PVector(mouseX,mouseY);
PVector corner;
PVector button;
ArrayList<Integer> hand;
int current = 0; //index for the cards that will show up on the screen;
ArrayList<Integer> selected; // selected cards
ArrayList<Integer> eSelected = new ArrayList<Integer>(); //rolands cards
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
boolean allasPassive; //checks if allas Workshop passive is active
boolean wheelsPassive; //checks if wheels industry passive is active
int pAtk; // number of attacks in a certain card for player
int eAtk; // number of attacks in a page for roland
int currentPage; //current attack for player
int enemyPage; //current attack for enemy
int rx; //location on the screen of the enemy
int gx; // location on the screen of player
boolean pause; //split second of peace in atk
boolean pstaggered; //checks for player is staggered
boolean estaggered; //checks for enemy being staggered
boolean qEgo; //checks if manifest ego has been used;
int Gdmg; //dice roll for gebura
int Rdmg; // dice roll for roland
boolean rolled; // checks if rolled
boolean onrush; // checks for onrush passive
void setup(){
  size(1152,648);
  corner = new PVector(width,height);
  button = new PVector(width/2,0);

  //enemy setup
  enemy = new Roland();
  Rsprite = loadImage("roland/rolandidle.png");
  rx = 300;
  
  //player setup
  player = new Gebura();
  Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
  hand = new ArrayList<Integer>();
  selected = new ArrayList<Integer>();
  hand.add((int)random(5));
  hand.add((int)random(5));
  dupeCheck((int)random(5));
  scene = 1;
  gx = 700;
  pause = false;
  
  
  
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
    eAtk=0;
    pAtk = 0;
    Rsprite = loadImage("roland/rolandidle.png");
    if(EgoOn){
      Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
    }
    else{
      Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
    }
    turn = false;
    if(enemy.phase==2){
      enemy.changeHP(1000);
      enemy.changeStagger(150);
      enemy.maxStagger = enemy.stagger;
      background=loadImage("backgrounds/phase2bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_2.mp3");
        bgm.play();
      }
    }
    if(enemy.phase==3){
      enemy.changeHP(400);
      enemy.changeStagger(200);
      enemy.maxStagger = enemy.stagger;
      background=loadImage("backgrounds/phase3bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Roland_3.mp3");
        bgm.play();
      }
    }
    if(enemy.phase==4){
      enemy.changeHP(999);
      enemy.changeStagger(500);
      enemy.maxStagger = enemy.stagger;
      background=loadImage("backgrounds/phase4bg.png");
      if(!bgm.isPlaying()){
        bgm = new SoundFile(this,"music/Gone_Angels.mp3");
        bgm.play();
      }
    }
    image(background,0,0,1152,648);
    if(EgoOn){
      image(Gsprite,700,340,187,100);
    }
    else{
      image(Gsprite,700,340,122.4,142.6);
    }
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
    fill(52, 168, 235);
    quad(width/2,0,width/2+10,25,width/2,70,width/2-10,25);
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
  
  //check if Gebura is dead
  else if(player.hp<=0){
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
  else if(enemy.hp<=0&&enemy.phase!=4){
    enemy.phase++;
    animate = false;
    while(selected.size()>0)
      selected.remove(0);
    while(eSelected.size()>0)
      eSelected.remove(0);
    phasechange=true;
    bgm.pause();
  }
  
  //roland is defeated
  else if(enemy.hp<=0 && enemy.phase==4){
    if(!finished){
      delay(2000);
    }
    finished = true;
    Rsprite=loadImage("roland/rolanddefeated.png");
    if(EgoOn){
      Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
    }
    else{
      Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
    }
    transition.setFill(0);
    if(i<height){
      image(background,0,0,1152,648);
      if(EgoOn){
        image(Gsprite,700,340,187,100);
      }
      else{
        image(Gsprite,700,340,122.4,142.6);
      }
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
  else{
    
    //makes sure the background is constantly being refreshed with the display board to show health and other stats
    image(background,0,0,1152,648);
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
    fill(52, 168, 235);
    quad(width/2,0,width/2+10,25,width/2,70,width/2-10,25);
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
      if(EgoOn){
        image(Gsprite,700,340,187,100);
      }
      else{
        image(Gsprite,700,340,122.4,142.6);
      }
      image(Rsprite,300,340,35.2,99.6);
      if(!drawn){
        dupeCheck((int)random(5));
        drawn=true;
        if(upstand){
          dupeCheck((int)random(5));
        }
        if(spear){
          dupeCheck((int)random(5));
        }
        if(level){
          player.changeLight(2);
        }
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
      SoundFile snap = new SoundFile(this, "other_sfx/Finger_Snapping.wav");
      SoundFile roll = new SoundFile(this,"other_sfx/Dice_Roll.wav");
        if(pAtk <= 0&&eAtk<=0){
          if(selected.size()>0){
            currentPage = selected.remove(0);
            if(currentPage==0){
              pAtk = 2;
            }
            else if(currentPage==1){
              pAtk=3;
            }
            else if(currentPage==2){
              pAtk = 2;
            }
            else if(currentPage==3){
              pAtk = 2;
            }
            else if(currentPage==4){
              pAtk = 1;
            }
            else if(currentPage==5){
              pAtk = 12;
            }
            else if(currentPage == 6){
              pAtk = 15;
            }
            else if (currentPage==7){
              pAtk =2;
            }
          }
          else{
            currentPage =-1; 
          }
          if(eSelected.size()>0){
            enemyPage = eSelected.remove(0);
            if(enemyPage==0){
              eAtk = 2;
            }
            else if(enemyPage==1){
              eAtk=2;
            }
            else if(enemyPage==2){
              eAtk = 2;
            }
            else if(enemyPage==3){
              eAtk = 2;
            }
            else if(enemyPage==4){
              eAtk = 1;
            }
            else if(enemyPage==5){
              eAtk = 3;
            }
            else if(enemyPage == 6){
              eAtk = 4;
            }
            else if (enemyPage==7){
              eAtk =3;
            }
            else if(enemyPage == 8){
              eAtk = 2;
            }
            else if(enemyPage ==9){
              eAtk=1;
            }
          }
          else{
            enemyPage =-1; 
          }
        }

        //greater split horizontal
        else if(currentPage == 5){
          PImage pageImage;
          if(!rolled){
            Gdmg = (int)(random(15)+28);
            if(enemyPage==0){
              Rdmg = (int)(random(5)+5);
            }
            else if(enemyPage==1){
              Rdmg = (int)(random(11)+14);
            }
            else if(enemyPage==2){
              Rdmg = (int)(random(5)+4);
            }
            else if(enemyPage==3){
              Rdmg = (int)(random(5)+5);
            }
            else if(enemyPage==4){
              Rdmg = (int)(random(8)+8);
            }
            else if(enemyPage==5){
              Rdmg = (int)(random(5)+3);
            }
            else if(enemyPage==6){
              Rdmg = (int)(random(4)+8);
            }
            else if(enemyPage==7){
              Rdmg = (int)(random(5)+4);
            }
            else if(enemyPage==8){
              Rdmg = (int)(random(5)+5);
            }
            else if(enemyPage==9){
              Rdmg = (int)(random(20)+20);
            }
            else{
              Rdmg= 0;
            }
            rolled = true;
          }
          if(enemyPage==0){
            pageImage = loadImage("roland/Allas Workshop.png");
          }
          else if(enemyPage==1){
            pageImage = loadImage("roland/Wheels Industry.png");
          }
          else if(enemyPage==2){
            pageImage = loadImage("roland/Zelkova Workshop.png");
          }
          else if(enemyPage==3){
            pageImage = loadImage("roland/Old Boys Workshop.png");
          }
          else if(enemyPage==4){
            pageImage = loadImage("roland/Mook Workshop.png");
          }
          else if(enemyPage==5){
            pageImage = loadImage("roland/Ranga Workshop.png");
          }
          else if(enemyPage==6){
            pageImage = loadImage("roland/Crystal Atelier.png");
          }
          else if(enemyPage==7){
            pageImage = loadImage("roland/Atelier Logic.png");
          }
          else if(enemyPage==8){
            pageImage = loadImage("roland/DurandalPage.png");
          }
          else {
            pageImage = loadImage("roland/Furioso.png");
          }
          fill(0);
          rect(rx,280,90,58);
          fill(255);
          textSize(10);
          if(enemyPage!=-1){
            text(enemy.pages[enemyPage],rx+2,288);
            image(pageImage,rx,300,50,38);
          }
          
          
          fill(0);
          rect(gx,280,90,58);
          fill(255);
          textSize(10);
          text(player.egopages[currentPage-5],gx,288);
          PImage myImage = loadImage("kali/CardManifestEgoArt.png");
          image(myImage,gx+40,300,50,38);
          
          

          if(gx-rx>180){
            Rsprite = loadImage("roland/rolandidle.png");
            image(Rsprite,rx,340,35.2,99.6);
            Gsprite = loadImage("kali/The-red-mist-combat-sprite-move.png");
            image(Gsprite,gx,350,164,95);
            gx-=40;
            textSize(20);
            text(Rdmg,rx+60,330);
            text(Gdmg,gx+60,335);
          }
          else if(pAtk == 12){ 
            delay(250);
            SoundFile mimieye = new SoundFile(this,"red_mist_sfx/Kali_Special_Hori_Eyeon.wav");
            SoundFile swing = new SoundFile(this,"red_mist_sfx/Kali_Special_Hori_Start.wav");
            swing.play();
            mimieye.play();
            PImage bg = loadImage("kali/background.png");
            image(bg,0,0,2147,648);
            PImage mimicry = loadImage("kali/mimicry.png");
            image(mimicry,width-758,0,758,611);
            pAtk-=1;
          }
          else if(pAtk==11){
            delay(1000);
            SoundFile slice = new SoundFile(this,"red_mist_sfx/Kali_EGO_Hori.wav");
            slice.play();
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame1 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==10){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame2 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==9){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame3 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==8){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame4 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==7){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame5 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==6){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame6 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==5){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame7 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==4){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame8 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==3){
            fill(0);
            rect(0,0,width,height);
            PImage slash = loadImage("kali/frame9 (copy).png");
            image(slash,0,0,1152,648);
            pAtk-=1;
          }
          else if(pAtk==2){
            Gsprite = loadImage("kali/The-red-mist-combat-sprite-special-1.png");
            Gfx = loadImage("kali/horizontal.png");
            Rsprite = loadImage("roland/BlackSilenceCombatDamaged.png");
            pAtk-=1;
            SoundFile pain = new SoundFile(this,"red_mist_sfx/Kali_Special_Hori_Fin.wav");
            pain.play();
            textSize(20);
            text(Rdmg,rx+60,330);
            text(Gdmg,gx+20,335);
            image(Rsprite,rx,340,61,100);
            image(Gsprite,gx,280,200,150);
            image(Gfx, gx-200,250,423,250);
            if(Rdmg<=Gdmg){
              enemy.damaged(Gdmg);
              enemy.staggerDamage(Gdmg);
              eAtk=0;
              player.addEmotion(1);
            }
            else{
              currentPage = -1;
            }
          }
          else if(pAtk==1){
            delay(3000);
            pAtk-=1;
            rolled = false;
            pause = true;
          }
        }

        //atelier logic
        else if(enemyPage==7){
          delay(250);
          SoundFile logic = new SoundFile(this,"black_silence_sfx/Roland_Revolver.wav");
          PImage pageImage = loadImage("roland/Atelier Logic.png");
          fill(0);
          rect(rx,280,90,58);
          fill(255);
          textSize(10);
          text(enemy.pages[7],rx+2,288);
          image(pageImage,rx,300,50,38);
          if(pAtk>0&&!pause){
            snap.play();
            delay(300);
          }
          if(pause){
            Rsprite = loadImage("roland/BlackSilenceCombatMove.png");
            image(Rsprite,rx-30,360,136,80);
          }
          else if(eAtk == 3){
            Rsprite = loadImage("roland/BlackSilenceCombatSpecial1.png");
            logic.play();
            Rdmg = (int)(random(5)+4);
            if(EgoOn){
              Rdmg-=2;
            }
            image(Rsprite,rx,340,151,99);
            eAtk--;
          }
          else if(eAtk ==2){
            Rsprite = loadImage("roland/BlackSilenceCombatSpecial2.png");
            logic.play();
            image(Rsprite,rx,340,151,99);
            Rdmg = (int)(random(4)+5);
            if(EgoOn){
              Rdmg-=2;
            }
            eAtk--;
          }
          else if(eAtk == 1){
            Rsprite = loadImage("roland/BlackSilenceCombatSpecial11.png");
            logic = new SoundFile(this,"black_silence_sfx/Roland_Shotgun.wav");
            logic.play();
            image(Rsprite,rx,340,203,97);
            Rdmg = (int)(random(6)+7);
            if(EgoOn){
              Rdmg-=2;
            }
            eAtk--;
          }
          fill(255);
          textSize(20);
          text(Rdmg,rx+60,330);
          SoundFile mist;
          
          PImage myImage;
          fill(0);
          rect(gx,280,90,58);
          fill(255);
          textSize(10);
          if(currentPage==0&&pAtk>0){
            text(player.pages[0],gx+2,288);
            myImage = loadImage("kali/CardUpstandingSlashArt.png");
            image(myImage,gx+40,300,50,38);
          }
          else if(currentPage == 1&&pAtk>0){
            text(player.pages[1],gx+2,288);
            myImage = loadImage("kali/CardSpearArt.png");
            image(myImage,gx+40,300,50,38);
          }    
          else if(currentPage == 2&&pAtk>0){
            text(player.pages[currentPage],gx+2,288);
            myImage = loadImage("kali/CardLevelSlashArt.png");
            image(myImage,gx+40,300,50,38);
          }   
          else if(currentPage == 3&&pAtk>0){
            text(player.pages[currentPage],gx+2,288);
            myImage = loadImage("kali/CardFocusSpiritArt.png");
            image(myImage,gx+40,300,50,38);
          }     
          else if(currentPage == 4&&pAtk>0){
            text(player.pages[currentPage],gx+2,288);
            myImage = loadImage("kali/CardOnrushArt.png");
            image(myImage,gx+40,300,50,38);
          }           
          else if(currentPage==6&&pAtk>0){
            text(player.egopages[currentPage-5],gx+2,288);
            myImage = loadImage("kali/CardGreaterSplitVerticalArt.png");
            image(myImage,gx+40,300,50,38);
          } 
          else if(currentPage==7&&pAtk>0){
            text(player.egopages[currentPage-5],gx+2,288);
            myImage = loadImage("kali/CardManifestEgoArt.png");
            image(myImage,gx+40,300,50,38);
          }                                         

          //gebura fighting back
          if(pause){
            if(EgoOn){
              Gsprite = loadImage("kali/The-red-mist-combat-sprite-move.png");
              image(Gsprite,gx,350,164,95);
            }
            else{
              Gsprite = loadImage("kali/Kali-combat-sprite-move.png");
              image(Gsprite,gx,350,164,97);
            }
            pause = false;
          }

          //upstanding slash
          else if(currentPage==0){
            
            pause = true;
            myImage = loadImage("kali/CardUpstandingSlashArt.png");
            if(pAtk ==2){
              Gdmg = (int)(random(5)+6);
              textSize(20);
              text(Gdmg,gx+20,335);
              if(EgoOn){
                Gdmg+=2;
              }
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding.png");
                  image(Gsprite,gx-90,325,226,160);
                  image(Gfx,gx-140,250,275,275);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding1.png");
                  image(Gsprite, gx-10,330,193,137);
                  image(Gfx,gx-150,140,420,420);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(4)+6);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding.png");
                  image(Gsprite,gx-90,325,226,160);
                  image(Gfx,gx-140,250,275,275);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding1.png");
                  image(Gsprite,gx-10,330,193,137);
                  image(Gfx,gx-140,150,420,420);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //spear
          else if(currentPage==1){
            pause = true;
            myImage = loadImage("kali/CardSpearArt.png");
            if(pAtk ==3){
              Gdmg = (int)(random(6)+3);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite,gx-200,350,391,94);
                  image(Gfx,gx-180,367,327,80);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite,gx-180,350,227,94);
                  image(Gfx,gx-140,367,327,80);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==2){
              Gdmg = (int)(random(5)+3);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite,gx-200,350,391,94);
                  image(Gfx,gx-180,367,327,80);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite, gx-150,350,227,94);
                  image(Gfx,gx-150,367,327,80);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(5)+3);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite,gx-200,350,391,94);
                  image(Gfx,gx-180,367,327,80);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                  Gfx = loadImage("kali/spear.png");
                  image(Gsprite,gx-150,350,227,94);
                  image(Gfx,gx-150,367,327,80);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //level slash
          else if(currentPage==2){
            pause = true;
            myImage = loadImage("kali/CardLevelSlashArt.png");
            if(pAtk ==2){
              Gdmg = (int)(random(5)+5);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                  Gfx = loadImage("kali/level.png");
                  image(Gsprite,gx-50,330,218,120);
                  image(Gfx,gx-170,310,383,190);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                  Gfx = loadImage("kali/horizontal.png");
                  image(Gsprite, gx-10,325,156,120);
                  image(Gfx,gx-180,300,355,210);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(4)+5);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                  Gfx = loadImage("kali/level.png");
                  image(Gsprite,gx-50,330,218,120);
                  image(Gfx,gx-170,310,383,190);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                  Gfx = loadImage("kali/horizontal.png");
                  image(Gsprite,gx-10,325,156,120);
                  image(Gfx,gx-180,300,355,210);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //focus spirit
          else if(currentPage==3){
            pause = true;
            myImage = loadImage("kali/CardFocusSpiritArt.png");
            if(pAtk ==2){
              Gdmg = (int)(random(5)+8);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/Defense_Guard_Win.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-block.png");
                  image(Gsprite,gx-50,345,141,120);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-guard.png");
                  image(Gsprite, gx,340,57,102);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg-Gdmg);
                player.staggerDamage(Rdmg-Gdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(3)+5);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding.png");
                  image(Gsprite,gx-90,325,226,160);
                  image(Gfx,gx-140,250,275,275);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding1.png");
                  image(Gsprite, gx-10,330,193,137);
                  image(Gfx,gx-150,140,420,420);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //onrush
          else if(currentPage==4){
            pause = true;
            myImage = loadImage("kali/CardOnrushArt.png");
            if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(13)+14);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+15,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                  image(Gsprite,gx-90,325,226,160);
                  Gfx = loadImage("kali/onrush.png");
                  image(Gfx,gx-100,200,158,300);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                  Gfx = loadImage("kali/upstanding1.png");
                  image(Gsprite, gx-10,330,193,137);
                  image(Gfx,gx-150,140,420,420);
                }
                
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              if(enemy.stagger!=0){
                pAtk--;
              }
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //great split vertical
          else if(currentPage==6){
            if(pAtk == 15){
              pAtk=1;
            }
            pause = true;
            myImage = loadImage("kali/CardGreaterSplitVerticalArt.png");
            if(pAtk ==1){
              snap.play();
              Gdmg = (int)(random(20)+20);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+15,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/clash.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-5.png");
                  image(Gsprite,gx-90,325,226,160);
                  Gfx = loadImage("kali/vertical.png");
                  image(Gfx,gx-150,200,339,310);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-attack-5.png");
                  Gfx = loadImage("kali/vertical.png");
                  image(Gsprite, gx-50,330,190,150);
                  image(Gfx,gx-150,200,339,310);
                }
                
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //manifest ego
          else if(currentPage==7){
            qEgo = true;
            pause = true;
            myImage = loadImage("kali/CardManifestEgoArt.png");
            if(pAtk ==2){
              Gdmg = (int)(random(8)+8);
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/Defense_Guard_Win.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-block.png");
                  image(Gsprite,gx-50,345,141,120);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-guard.png");
                  image(Gsprite, gx,340,57,102);
                }
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg-Gdmg);
                player.staggerDamage(Rdmg-Gdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              pAtk--;
            }
            else if(pAtk ==1){
              pause = true;
              Gdmg = (int)(random(8)+8);
              if(EgoOn){
                Gdmg+=2;
              }
              textSize(20);
              text(Gdmg,gx+20,335);
              if(Gdmg>=Rdmg){
                mist = new SoundFile(this,"other_sfx/Defense_Evasion.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-evade.png");
                  image(Gsprite,gx-50,325,243,160);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-evade.png");
                  image(Gsprite,gx-10,335,135,110);
                }
                player.staggerDamage(-1*Gdmg);
              }
              else{
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
              }
              if(Gdmg<=Rdmg||eAtk==0){
                pAtk--;
              }
            }
            else{
              if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,119,130);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                  image(Gsprite,gx,340,109,130);
                }
                gx+=2;
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
                if(player.stagger==0){
                  pAtk=0;
                  while(selected.size()>0){
                    selected.remove(0);
                  }
                }
            }
          }

          //no page
          else if(currentPage==-1){
            if(EgoOn){
              Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
              image(Gsprite,gx,340,119,130);
            }
            else{
              Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
              image(Gsprite,gx,340,109,130);
            }
            gx+=2;
            if(player.stagger==0){
              player.damaged(Rdmg*2);
            }
            else{
              player.damaged(Rdmg);
              player.staggerDamage(Rdmg);
              if(player.stagger==0){
                pAtk=0;
                while(selected.size()>0){
                  selected.remove(0);
                }
              }

            }
            
          }
        }
        else{
          PImage pageImage;
          PImage myImage;
          fill(0);
          rect(gx,280,90,58);
          fill(255);
          textSize(10);
          SoundFile mist;
          SoundFile silence;
          if(currentPage==0&&pAtk>0){
            text(player.pages[0],gx+2,288);
            myImage = loadImage("kali/CardUpstandingSlashArt.png");
            image(myImage,gx+40,300,50,38);
          }
          else if(currentPage == 1&&pAtk>0){
            text(player.pages[1],gx+2,288);
            myImage = loadImage("kali/CardSpearArt.png");
            image(myImage,gx+40,300,50,38);
          }    
          else if(currentPage == 2&&pAtk>0){
            text(player.pages[2],gx+2,288);
            myImage = loadImage("kali/CardLevelSlashArt.png");
            image(myImage,gx+40,300,50,38);
          }   
          else if(currentPage == 3&&pAtk>0){
            text(player.pages[currentPage],gx+2,288);
            myImage = loadImage("kali/CardFocusSpiritArt.png");
            image(myImage,gx+40,300,50,38);
          }     
          else if(currentPage == 4&&pAtk>0){
            text(player.pages[currentPage],gx+2,288);
            myImage = loadImage("kali/CardOnrushArt.png");
            image(myImage,gx+40,300,50,38);
          }           
          else if(currentPage==6&&pAtk>0){
            text(player.egopages[currentPage-5],gx+2,288);
            myImage = loadImage("kali/CardGreaterSplitVerticalArt.png");
            image(myImage,gx+40,300,50,38);
          } 
          else if(currentPage==7&&pAtk>0){
            text(player.egopages[currentPage-5],gx+2,288);
            myImage = loadImage("kali/CardManifestEgoArt.png");
            image(myImage,gx+40,300,50,38);
          }                  
          if(enemyPage==0){
            pageImage = loadImage("roland/Allas Workshop.png");
          }
          else if(enemyPage==1){
            pageImage = loadImage("roland/Wheels Industry.png");
          }
          else if(enemyPage==2){
            pageImage = loadImage("roland/Zelkova Workshop.png");
          }
          else if(enemyPage==3){
            pageImage = loadImage("roland/Old Boys Workshop.png");
          }
          else if(enemyPage==4){
            pageImage = loadImage("roland/Mook Workshop.png");
          }
          else if(enemyPage==5){
            pageImage = loadImage("roland/Ranga Workshop.png");
          }
          else if(enemyPage==6){
            pageImage = loadImage("roland/Crystal Atelier.png");
          }
          else if(enemyPage==7){
            pageImage = loadImage("roland/Atelier Logic.png");
          }
          else if(enemyPage==8){
            pageImage = loadImage("roland/DurandalPage.png");
          }
          else{
            pageImage = loadImage("roland/Furioso.png");
          }
          fill(0);
          rect(rx,280,90,58);
          fill(255);
          textSize(10);
          if(enemyPage!=-1){
            text(enemy.pages[enemyPage],rx+2,288);
            image(pageImage,rx,300,50,38);
          }

          //approach 
          if(gx-rx>180){
            Rdmg=0;
            if(!estaggered){
              Rsprite = loadImage("roland/BlackSilenceCombatMove.png");
              image(Rsprite,rx-30,360,136,80);
              rx+=20;
            }
            else{
              Rsprite = loadImage("roland/rolandidle.png");
              image(Rsprite,rx,340,35.2,99.6);
            }
            if(!pstaggered){
              if(EgoOn){
                Gsprite = loadImage("kali/The-red-mist-combat-sprite-move.png");
                image(Gsprite,gx,350,164,95);
              }
              else{
                Gsprite = loadImage("kali/Kali-combat-sprite-move.png");
                image(Gsprite,gx,350,164,97);
              }
              gx-=20;
            }
            else{
              if(EgoOn){
                Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
                image(Gsprite,gx,340,187,100);
              }
              else{
                Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
                image(Gsprite,gx,340,122.4,142.6);
              }
            }
          }
          
          else{
            if(currentPage!=6)
              delay(250);
            if(enemyPage==0)
              delay(1000);
            //they fight back
            if(enemyPage!=0)
            eAtk=0;
            if(pause&&currentPage!=6){
              if(EgoOn){
                Gsprite = loadImage("kali/The-red-mist-combat-sprite-move.png");
                image(Gsprite,gx,350,164,95);
              }
              else{
                Gsprite = loadImage("kali/Kali-combat-sprite-move.png");
                image(Gsprite,gx,350,164,97);
              }
              Rsprite = loadImage("roland/BlackSilenceCombatMove.png");
              image(Rsprite,rx-30,360,136,80);
              pause = false;
            }

            //upstanding slash
            else if(currentPage==0){
              snap.play();
              
              pause = true;
              myImage = loadImage("kali/CardUpstandingSlashArt.png");
              
              if(pAtk ==2){
                Gdmg = (int)(random(5)+6);
                if(allasPassive)
                  Gdmg-=2;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(EgoOn){
                  Gdmg+=2;
                }

                //allas Workshop
                if(enemyPage==0){
                  allasPassive = true;
                  if(eAtk==2){
                    Rdmg = (int)(random(5)+5);
                    textSize(20);
                    text(Rdmg,rx+60,335);
                    if(Rdmg>Gdmg){
                      silence = new SoundFile(this,"black_silence_sfx/Sword_Stab.wav");
                      Rsprite = loadImage("roland/BlackSilenceCombatPierce.png");
                      Rfx = loadImage("roland/allas.png");
                      silence.play();
                      image(Rsprite,rx+20,360,228,80);
                      image(Rfx,rx+50,330,228,120);
                      player.addEmotion(-1);
                    }
                    else if(Rdmg==Gdmg||(currentPage==3&&pAtk==2)||currentPage==7){
                      Rsprite = loadImage("roland/BlackSilenceCombatPierce.png");
                      image(Rsprite,rx+20,360,228,80);
                    }
                    else{
                      Rsprite = loadImage("roland/BlackSilenceCombatDamaged.png");
                      image(Rsprite, rx+50,340,61,100);
                    }
                    eAtk--;
                  }
                  else if(eAtk==1){
                    Rdmg = (int)(random(4)+5);
                    textSize(20);
                    text(Rdmg,rx+60,335);
                    if(Rdmg>Gdmg){
                      silence = new SoundFile(this,"black_silence_sfx/Sword_Stab.wav");
                      Rsprite = loadImage("roland/BlackSilenceCombatPierce.png");
                      Rfx = loadImage("roland/allas.png");
                      silence.play();
                      image(Rsprite,rx+20,360,228,80);
                      image(Rfx,rx+50,330,228,120);
                      player.addEmotion(-1);
                    }
                    else if(Rdmg==Gdmg||(currentPage==3&&pAtk==2)||currentPage==7){
                      Rsprite = loadImage("roland/BlackSilenceCombatPierce.png");
                      image(Rsprite,rx,360,228,80);
                    }
                    else{
                      Rsprite = loadImage("roland/BlackSilenceCombatDamaged.png");
                      image(Rsprite, rx+50,340,61,100);
                    }
                    eAtk--;
                  }
                }

                println("pdmg:" + Gdmg);
                println("edmg:" + Rdmg);
                
                if(Gdmg>Rdmg){
                  
                  if(Gdmg>=8)
                    upstand = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding.png");
                    image(Gsprite,gx-90,325,226,160);
                    image(Gfx,gx-140,250,275,275);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Vert.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding1.png");
                    image(Gsprite, gx-10,330,193,137);
                    image(Gfx,gx-150,140,420,420);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Vert.wav");
                  }
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else if((enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==1){
                pause = true;
                Gdmg = 3;//(int)(random(4)+6);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    upstand = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding.png");
                    image(Gsprite,gx-90,325,226,160);
                    image(Gfx,gx-140,250,275,275);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Vert.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding1.png");
                    image(Gsprite,gx-10,330,193,137);
                    image(Gfx,gx-140,150,420,420);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Vert.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //spear
            else if(currentPage==1){
              snap.play();
              pause = true;
              myImage = loadImage("kali/CardSpearArt.png");
              if(pAtk ==3){
                Gdmg = (int)(random(6)+3);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    spear = true;
                  
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite,gx-200,350,391,94);
                    image(Gfx,gx-180,367,327,80);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Stab.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite,gx-180,350,227,94);
                    image(Gfx,gx-140,367,327,80);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Stab.wav");
                  }
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((Gdmg==Rdmg)||(enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-200,350,391,94);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite,gx-180,350,227,94);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==2){
                Gdmg = (int)(random(5)+3);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    spear = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite,gx-200,350,391,94);
                    image(Gfx,gx-180,367,327,80);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Stab.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite, gx-150,350,227,94);
                    image(Gfx,gx-150,367,327,80);

                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Stab.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((Gdmg==Rdmg)||(enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-200,350,391,94);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite,gx-180,350,227,94);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==1){
                pause = true;
                Gdmg = (int)(random(5)+3);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    spear = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite,gx-200,350,391,94);
                    image(Gfx,gx-180,367,327,80);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Stab.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    Gfx = loadImage("kali/spear.png");
                    image(Gsprite,gx-150,350,227,94);
                    image(Gfx,gx-150,367,327,80);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Stab.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((Gdmg==Rdmg)||(enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-200,350,391,94);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite,gx-180,350,227,94);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-pierce.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-pierce.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //level slash
            else if(currentPage==2){
              snap.play();
              pause = true;
              myImage = loadImage("kali/CardLevelSlashArt.png");
              if(pAtk ==2){
                Gdmg = (int)(random(5)+5);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    level = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    Gfx = loadImage("kali/level.png");
                    image(Gsprite,gx-50,330,218,120);
                    image(Gfx,gx-170,310,383,190);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Hori.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    Gfx = loadImage("kali/horizontal.png");
                    image(Gsprite, gx-10,325,156,120);
                    image(Gfx,gx-180,300,355,210);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Hori.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((Gdmg==Rdmg)||(enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    image(Gsprite,gx-50,330,218,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    image(Gsprite, gx-10,325,156,120);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    image(Gsprite,gx-50,330,218,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    image(Gsprite, gx-10,325,156,120);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==1){
                pause = true;
                Gdmg = (int)(random(4)+5);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  if(Gdmg>=8)
                    level = true;
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    Gfx = loadImage("kali/level.png");
                    image(Gsprite,gx-50,330,218,120);
                    image(Gfx,gx-170,310,383,190);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Hori.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    Gfx = loadImage("kali/horizontal.png");
                    image(Gsprite,gx-10,325,156,120);
                    image(Gfx,gx-180,300,355,210);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Hori.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((Gdmg==Rdmg)||(enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    image(Gsprite,gx-50,330,218,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    image(Gsprite, gx-10,325,156,120);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-blunt.png");
                    image(Gsprite,gx-50,330,218,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-blunt.png");
                    image(Gsprite, gx-10,325,156,120);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //focus spirit
            else if(currentPage==3){
              snap.play();
              pause = true;
              myImage = loadImage("kali/CardFocusSpiritArt.png");
              if(pAtk ==2){
                Gdmg = (int)(random(5)+8);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  mist = new SoundFile(this,"other_sfx/Defense_Guard_Win.wav");
                  mist.play();
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-block.png");
                    image(Gsprite,gx-50,345,141,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-guard.png");
                    image(Gsprite, gx,340,57,102);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg-Gdmg);
                  player.staggerDamage(Rdmg-Gdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==1){
                pause = true;
                Gdmg = (int)(random(3)+5);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding.png");
                    image(Gsprite,gx-90,325,226,160);
                    image(Gfx,gx-140,250,275,275);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Vert.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding1.png");
                    image(Gsprite, gx-10,330,193,137);
                    image(Gfx,gx-150,140,420,420);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Vert.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //onrush
            else if(currentPage==4){
              snap.play();
              pause = true;
              myImage = loadImage("kali/CardOnrushArt.png");
              if(pAtk ==1){
                pause = true;
                Gdmg = (int)(random(13)+14);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+15,335);
                if(Gdmg>=Rdmg){
                  
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                    Gfx = loadImage("kali/onrush.png");
                    image(Gfx,gx-100,200,158,300);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_EGO_Vert.wav");
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    Gfx = loadImage("kali/upstanding1.png");
                    image(Gsprite, gx-10,330,193,137);
                    image(Gfx,gx-150,140,420,420);
                    mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Vert.wav");
                  }
                  
                  mist.play();
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                    enemy.staggerDamage(Gdmg-Rdmg);
                  }
                  else{
                    enemy.damaged(Gdmg);
                    enemy.staggerDamage(Gdmg);
                  }
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-slash.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-slash.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                if(enemy.stagger==0&&onrush)
                  onrush = false;
                else if(enemy.stagger==0){
                  onrush = true;
                }
                if(!onrush){
                  pAtk--;
                }
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //great split vertical
            if(currentPage==6){
              myImage = loadImage("kali/CardGreaterSplitVerticalArt.png");
              if(pAtk == 15){
                Gdmg = (int)(random(20)+20);
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+15,335);
                if(Gdmg>=Rdmg){
                  eAtk=0;
                  Rsprite = loadImage("roland/BlackSilenceCombatDamaged.png");
                  mist = new SoundFile(this,"red_mist_sfx/Kali_Normal_Vert.wav");
                  mist.play();
                  image(Rsprite, rx+50,340,61,100);
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-1.png");
                    image(Gsprite,gx-10,265,150,170);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-attack-1.png");
                    image(Gsprite, gx-10,255,57,170);
                  }
                  pAtk--;
                }
                else{
                  pAtk = 2;
                }
              }
              else if(pAtk == 14){
                delay(1250);
                textSize(20);
                text(Gdmg,gx+15,335);
                image(Rsprite, rx+50,340,61,100);
                mist = new SoundFile(this,"red_mist_sfx/Kali_Special_Vert_Hit.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-2.png");
                  image(Gsprite,gx-100,330,253,110);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-attack-2.png");
                  image(Gsprite, gx-100,330,153,95);
                }
                pAtk--;
              }
              else if(pAtk == 13){
                delay(750);
                textSize(20);
                text(Gdmg,gx+15,335);
                image(Rsprite, rx+50,340,61,100);
                mist = new SoundFile(this,"red_mist_sfx/Kali_Special_Vert_Hit.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-3.png");
                  image(Gsprite,gx-100,330,248,110);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-attack-3.png");
                  image(Gsprite, gx-100,330,155,95);
                }
                pAtk--;
              }
              else if(pAtk == 12){
                delay(750);
                textSize(20);
                text(Gdmg,gx+15,335);
                image(Rsprite, rx+50,340,61,100);
                mist = new SoundFile(this,"red_mist_sfx/Kali_Special_Vert_Hit.wav");
                mist.play();
                gx-=2;
                if(EgoOn){
                  Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-4.png");
                  image(Gsprite,gx-100,340,251,95);
                }
                else{
                  Gsprite = loadImage("kali/Kali-combat-sprite-attack-4.png");
                  image(Gsprite, gx-100,330,159,95);
                }
                pAtk--;
              }
              else if(pAtk == 11){
                delay(1250);
                SoundFile slice = new SoundFile(this,"red_mist_sfx/Kali_Special_Cut.wav");
                slice.play();
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame1.png");
                image(slash,0,0,1152,648);
                pAtk-=1;  
              }
              else if(pAtk == 10){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame2.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 9){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame3.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 8){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame4.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 7){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame5.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 6){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame6.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 5){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame7.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 4){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame8.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk == 3){
                fill(0);
                rect(0,0,width,height);
                PImage slash = loadImage("kali/frame9.png");
                image(slash,0,0,1152,2048);
                pAtk-=1;
              }
              else if(pAtk ==2){
                textSize(20);
                text(Gdmg,gx+15,335);
                if(Gdmg>Rdmg){
                  image(Rsprite, rx+50,340,61,100);
                  mist = new SoundFile(this,"red_mist_sfx/Kali_Special_Vert_Fin.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-5.png");
                    image(Gsprite,gx-90,325,226,160);
                    Gfx = loadImage("kali/vertical.png");
                    image(Gfx,gx-150,240,339,310);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-attack-5.png");
                    Gfx = loadImage("kali/vertical.png");
                    image(Gsprite, gx-50,330,190,150);
                    image(Gfx,gx-150,200,339,310);
                  }
                  if((enemyPage ==1&&eAtk==1)||(enemyPage==3&&eAtk==2)){
                    enemy.damaged(Gdmg-Rdmg);
                  }
                  else 
                    enemy.damaged(Gdmg);
                  if(eSelected.size()>0)
                    eSelected.remove(0);
                  player.addEmotion(1);
                  player.recoverHP(Gdmg);
                }
                else if((enemyPage==1&&eAtk==1)||(enemyPage==3&&eAtk==2)||(enemyPage==6&&eAtk==4)){
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-5.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-attack-5.png");
                    image(Gsprite, gx-50,330,190,150);
                  }
                }
                else if(Gdmg==Rdmg){
                  mist = new SoundFile(this,"other_sfx/clash.wav");
                  mist.play();
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-attack-5.png");
                    image(Gsprite,gx-90,325,226,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-attack-5.png");
                    image(Gsprite, gx-10,330,193,137);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk == 1){
                if(Gdmg>Rdmg){
                  delay(1250);
                }
                else
                  delay(250);
                pAtk--;
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //manifest ego
            else if(currentPage==7){
              snap.play();
              qEgo = true;
              pause = true;
              myImage = loadImage("kali/CardManifestEgoArt.png");
              if(pAtk ==2){
                Gdmg = (int)(random(8)+8);
                
                if(allasPassive)
                  Gdmg-=2;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  mist = new SoundFile(this,"other_sfx/Defense_Guard_Win.wav");
                  mist.play();
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-block.png");
                    image(Gsprite,gx-50,345,141,120);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-guard.png");
                    image(Gsprite, gx,340,57,102);
                  }
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg-Gdmg);
                  player.staggerDamage(Rdmg-Gdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                pAtk--;
              }
              else if(pAtk ==1){
                pause = true;
                Gdmg = (int)(random(8)+8);
                
                if(allasPassive)
                  Gdmg-=2;
                if(EgoOn){
                  Gdmg+=2;
                }
                allasPassive=false;
                textSize(20);
                text(Gdmg,gx+20,335);
                if(Gdmg>=Rdmg){
                  mist = new SoundFile(this,"other_sfx/Defense_Evasion.wav");
                  mist.play();
                  gx-=2;
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-evade.png");
                    image(Gsprite,gx-50,325,243,160);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-evade.png");
                    image(Gsprite,gx-10,335,135,110);
                  }
                  player.staggerDamage(-1*Gdmg);
                }
                else{
                  if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
                }
                if(Gdmg<=Rdmg||eAtk==0){
                  pAtk--;
                }
              }
              else{
                if(EgoOn){
                    Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,119,130);
                  }
                  else{
                    Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                    image(Gsprite,gx,340,109,130);
                  }
                  gx+=2;
                  player.damaged(Rdmg);
                  player.staggerDamage(Rdmg);
                  if(player.stagger==0){
                    pAtk=0;
                    while(selected.size()>0){
                      selected.remove(0);
                    }
                  }
              }
            }

            //no page
            else if(currentPage==-1){
              pause = true;
              
              if(EgoOn){
                Gsprite = loadImage("kali/The-red-mist-combat-sprite-damaged.png");
                image(Gsprite,gx,340,119,130);
              }
              else{
                Gsprite = loadImage("kali/Kali-combat-sprite-damaged.png");
                image(Gsprite,gx,340,109,130);
              }
              gx+=2;
              if(player.stagger==0){
                pAtk=0;
                while(selected.size()>0){
                  selected.remove(0);
                }
                player.damaged(Rdmg*2);
              }
              else{
                player.damaged(Rdmg);
                player.staggerDamage(Rdmg);
              }
            }
          }
        }
        if(currentPage==-1&&enemyPage==-1){
          animate = false;
          draw = true;
          drawn = false;
          scene++;
          eAtk=0;
          pAtk = 0;
          if(player.stagger ==0){
            if(!pstaggered)
              pstaggered = true;
          }
          if(!pstaggered)
            player.changeLight(1);
          else{
            pstaggered = false;
            player.stagger = player.maxStagger;
          }
            
          if(estaggered){
            estaggered = false;
            enemy.stagger = enemy.maxStagger;
          }
            
          Rsprite = loadImage("roland/rolandidle.png");
          if(EgoOn){
            Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
          }
          else{
            Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
          }
          snap.play();
        }
      
    }
    
    //if it is the selection phase, lets the player select cards and compare them through hovering over the cards
    if(turn){
      gx=700;
      rx=300;
      if(qEgo){
        SoundFile ego = new SoundFile(this,"red_mist_sfx/Kali_Change.wav");
        Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
        EgoOn = true;
        qEgo = false;
        ego.play();
        player.changeLight(6);
        player.changeStagger(player.maxStagger);
      }
      if(EgoOn){
        image(Gsprite,700,340,187,100);
      }
      else{
        image(Gsprite,700,340,122.4,142.6);
      }
      image(Rsprite,300,340,35.2,99.6);
      while(eSelected.size()>0){
        eSelected.remove(0);
      }
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
          if(spear&&hand.get(i)==1){
            text(player.pagedesc2[hand.get(i)],width-200,410);
          }
          else if(level&&hand.get(i)==2){
            text(player.pagedesc2[hand.get(i)],width-200,410);
          }
          else if(upstand&&hand.get(i)==0){
            text(player.pagedesc2[hand.get(i)],width-200,410);
          }
          else{
            text(player.pagedesc[hand.get(i)],width-200,410);
          }
            
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

      //show selected cards
      for(int r=0; r<selected.size();r++){
        PImage selection;
        if(selected.get(r)==0){
          selection = loadImage("kali/CardUpstandingSlashArt.png");
        }
        else if(selected.get(r)==1){
          selection = loadImage("kali/CardSpearArt.png");
        }
        else if(selected.get(r)==2){
          selection = loadImage("kali/CardLevelSlashArt.png");
        }
        else if(selected.get(r)==3){
          selection = loadImage("kali/CardFocusSpiritArt.png");
        }
        else if(selected.get(r)==4){
          selection = loadImage("kali/CardOnrushArt.png");
        }
        else if(selected.get(r)==5){ // Greater Split Horizontal
          selection = loadImage("kali/CardManifestEgoArt.png"); 
        }
        else if(selected.get(r)==6){ 
          selection = loadImage("kali/CardGreaterSplitVerticalArt.png");
        }
        else{  //Manifest Ego
          selection = loadImage("kali/CardManifestEgoArt.png"); 
        }
        if(mouseX>600+r*55&&mouseX<600+r*55+50&&mouseY>300&&mouseY<338){
          stroke(255,255,0);
          rect(600+r*55,300,50,38);
          stroke(0);
          
          if(selected.get(r)==0){
          fill(146, 200, 139);
          }
          else if(selected.get(r)==1){
            fill(146, 200, 139);
          }
          else if(selected.get(r)==2){
            fill(146, 200, 139);
          }
          else if(selected.get(r)==3){
            fill(95, 139, 227);
          }
          else if(selected.get(r)==4){
            fill(124, 62, 219);
          }
          else if(selected.get(r)==5){
            fill(124, 34, 60);
          }
          else if(selected.get(r)==6){ //Horizontal
            fill(124, 34, 60);
          }
          else{  //Ego
            fill(234, 205, 1);
          }
          rect(width-210,210,210,330);
          textSize(15);
          fill(0);
          if(selected.get(r)<=4){
            text(player.pages[selected.get(r)],width-200,235);
          }
          else{
            text(player.egopages[selected.get(r)-5],width-200,235);
          }
          if(upstand&&selected.get(r)==0){
            text(player.pagedesc2[selected.get(r)],width-200,410);
          }
          else if(spear&&selected.get(r)==1){
            text(player.pagedesc2[selected.get(r)],width-200,410);
          }
          else if(level&&selected.get(r)==2){
            text(player.pagedesc2[selected.get(r)],width-200,410);
          }
          else{
            text(player.pagedesc[selected.get(r)],width-200,410);
          }
          image(selection,width-210,240,210,159);
        }
        image(selection,600+r*55,300,50,38);
      }
      
      //if roland is staggered he does nothing.
      if(estaggered){

      }

      //black silence cards used
      else if(scene%4 ==1){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Atelier Logic.png"); 
            eSelected.add(7);
          }
          else if(i==2){
            rPages = loadImage("roland/Zelkova Workshop.png");
            eSelected.add(2);
          }
          else if(i==3){
            rPages = loadImage("roland/Allas Workshop.png");
            eSelected.add(0);
          }
          else if(i==4){
            rPages = loadImage("roland/Ranga Workshop.png"); 
            eSelected.add(5);
          }
          else{
            rPages = loadImage("roland/Old Boys Workshop.png"); 
            eSelected.add(3);
          }
          println(eSelected);
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
      else if(scene%4 ==2){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Wheels Industry.png"); 
            eSelected.add(1);
          }
          else if(i==2){
            rPages = loadImage("roland/Old Boys Workshop.png");
            eSelected.add(3);
          }
          else if(i==3){
            rPages = loadImage("roland/DurandalPage.png");
            eSelected.add(8);
          }
          else if(i==4){
            rPages = loadImage("roland/Allas Workshop.png"); 
            eSelected.add(0);
          }
          else{
            rPages = loadImage("roland/Ranga Workshop.png"); 
            eSelected.add(5);
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
      else if(scene%4 ==3){
        for(int i = 1; i<=5;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Crystal Atelier.png"); 
            eSelected.add(6);
          }
          else if(i==2){
            rPages = loadImage("roland/Mook Workshop.png");
            eSelected.add(4);
          }
          else if(i==3){
            rPages = loadImage("roland/Ranga Workshop.png");
            eSelected.add(5);
          }
          else if(i==4){
            rPages = loadImage("roland/DurandalPage.png"); 
            eSelected.add(8);
          }
          else{
            rPages = loadImage("roland/Atelier Logic.png"); 
            eSelected.add(7);
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
      else if(scene%4 ==0){
        for(int i = 1; i<=3;i++){
          PImage rPages;
          if(i==1){
            rPages = loadImage("roland/Furioso.png"); 
            eSelected.add(9);
          }
          else if(i==2){
            rPages = loadImage("roland/DurandalPage.png");
            eSelected.add(8);
          }
          else{
            rPages = loadImage("roland/DurandalPage.png"); 
            eSelected.add(8);
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
    
    
  } 
}

//restarts the game
void reset(){
  while(selected.size()>0)
    selected.remove(0);
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
  animate = false;
  EgoOn = false;
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
    if(player.stagger>0){
      for(int r=0;r<hand.size();r++){
        if(mouseX>width/4*3-105*(r+1)&&mouseX<width/4*3-105*(r+1)+100&&mouseY>height-125&&mouseY<height){
          if(hand.get(r)==0){
            if(upstand){
              selected.add(hand.remove(r));
            }
            else if(player.light>=1){
              selected.add(hand.remove(r));
              player.light-=1;
            }
          }
          else if(hand.get(r)==1){
            if(spear){
              selected.add(hand.remove(r));
            }
            else if(player.light>=1){
              selected.add(hand.remove(r));
              if(!spear)
                player.light-=1;
            }
          }
          else if(hand.get(r)==2){
            if(level){
              selected.add(hand.remove(r));
            }
            else if(player.light>=1){
              selected.add(hand.remove(r));
              if(!level)
                player.light-=1;
            }
          }
          else if(hand.get(r)==3){
            if(player.light>=2){
              selected.add(hand.remove(r));
              player.light-=2;
            }
          }
          else if(hand.get(r)==4){
            if(player.light>=3){
              selected.add(hand.remove(r));
              player.light-=3;
            }
          }
          else if(hand.get(r)==5){
            if(player.light>=6){
              selected.add(hand.remove(r));
              player.light-=6;
            }
          }
          else if(hand.get(r)==6){
            if(player.light>=5){
              selected.add(hand.remove(r));
              player.light-=5;
            }
          }
          else if(hand.get(r)==7){
            if(player.light>=2){
              selected.add(hand.remove(r));
              player.light-=2;
            }
          }
        }
      }
      
      //deselect pages from selected
      for(int r=0;r<selected.size();r++){
        if(mouseX>600+r*55&&mouseX<600+r*55+50&&mouseY>300&&mouseY<338){
          if(selected.get(r)==0){
            if(!upstand)
              player.light+=1;
          }
          else if(selected.get(r)==1){
            if(!spear)
              player.light+=1;
          }
          else if(selected.get(r)==2){
            if(!level)
              player.light+=1;
          }
          else if(selected.get(r)==3){
            player.light+=2;
          }
          else if(selected.get(r)==4){
            player.light+=3;
          }
          else if(selected.get(r)==5){
            player.light+=6;
          }
          else if(selected.get(r)==6){
            player.light+=5;
          }
          else if(selected.get(r)==7){
            player.light+=2;
          }
          hand.add(selected.remove(r));
        }
      }
    }
  }
  

  //start battle phase
    if(turn &&mousepos.sub(button).mag()<=50){
      turn = false;
      animate = true;
      SoundFile start = new SoundFile(this, "other_sfx/Finger_Snapping.wav");
      start.play();
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
  if(key=='m'){
    if(!EgoOn){
      EgoOn = true;
      Gsprite = loadImage("kali/The-red-mist-combat-sprite-idle.png");
    }
    else{
      EgoOn = false;
      Gsprite = loadImage("kali/Kali-combat-sprite-idle.png");
    }
  }
  if(key=='b'){
    player.stagger=10;
  }
  if(key=='u'){
    enemy.stagger = 0; 
    estaggered = true;
  }
  if(key=='l'){
    if(spear){
      spear = false;
      upstand = false;
      level = false;
    }
    else{
      spear = true;
      upstand = true;
      level = true;
    }
  }
  if(key=='z'){
    enemy.hp= 1;
  }
  if(key=='k'){
    player.light++;
  }
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
