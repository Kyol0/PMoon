public class Roland{
  int hp;
  int stagger;
  int maxStagger;
  String[] pages = {"Allas Workshop", "Wheels Industry", "Zelkova Workshop","Old Boys Workshop","Mook Workshop", "Ranga Workshop", "Crystal Atelier","Atelier Logic","Durandal","Furioso"};
  String[] pagedesc = {
    " Reduce Power of all\n target's dice by 2 \n dmg: 5~9 \n dmg: 5~8",
    " On Clash Win: Destroy\n Opponent's next die \n dmg: 14~24 \n block 5~8",
    " dmg: 4~8 \n dmg: 3~8",
    " On hit, recover 5 Stagger \n block: 5~9 \n dmg: 4~8",
    " On hit, deal 3 damage to target \n dmg: 8~15",
    " dmg: 3~7 \n dmg: 3~7 \n dmg: 3~7",
    " evade: 8~11 \n dmg: 7~11 \n dmg: 7~11",
    " dmg: 4~8 \n dmg: 5~8 \n dmg: 7~12",
    " dmg: 5~9 \n dmg: 5~9",
    " On Clash win, destroy all of\n opponent's dice \n dmg: 20~39"};
  int dice;
  int phase;
  public Roland(){
    hp = 400;
    stagger = 350;
    maxStagger = stagger;
    phase = 1;
  }
  public void changeHP(int value){
    hp=value;
  }
  public void damaged(int damage){
    hp-=damage;
    if(hp<0)
      hp=0;
  }
  public void changeStagger(int value){
    stagger = value;
  }
  public void staggerDamage(int damage){
    stagger-=damage*2;
    if(stagger<0)
      stagger = 0;
  }
}
