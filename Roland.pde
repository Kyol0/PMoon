public class Roland{
  int hp;
  int stagger;
  String[] pages = {"Allas Workshop", "Wheels Industry", "Zelkova Workshop","Old Boys Workshop","Mook Workshop", "Ranga Workshop", "Crystal Atelier","Atelier Logic","Durandal","Furioso"};
  String[] pagedesc = {"On Clash: Reduce Power of all target's dice by 2 \n dmg: 5~9 \n dmg: 5~8","On Clash Win: Destroy Opponent's next die \n dmg: 14~24 \n block 5~8","dmg: 4~8 \n dmg: 3~8","On hit, recover 5 Stagger \n block: 5~9 \n dmg: 4~8","On hit, deal 3 damage to target \n dmg: 8~15","dmg: 3~7 \n dmg: 3~7 \n dmg: 3~7","evade: 8~11 \n dmg: 7~11 \n dmg: 7~11 \n dmg: 4~8","dmg: 4~8 \n dmg: 5~8 \n dmg: 7~12","dmg: 5~9 \n dmg: 5~9","On Clash win, destroy all of opponent's dice \n dmg: 20~39"};
  int[] dice;
  int phase;
  public Roland(){
    hp = 400;
    stagger = 350;
    phase = 1;
  }
}
