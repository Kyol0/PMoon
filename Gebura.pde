public class Gebura{
  int hp;
  int light;
  int emotion;
  int emotionlvl;
  int stagger;
  String[] pages = { "Upstanding Slash", "Spear", "Level Slash", "Focus Spirit", "Onrush"};
  String[] pagedesc = {"Light: 1 \n If 8 or more damage was done with this page, draw 1 page and reduce the cost of all other 'Upstanding Slashes' by 1 \n dmg: 6~10 \n dmg: 6~9","Light: 1 \n If 8 or more damage was done with this page, draw 1 page and reduce the cost of all other 'Spears' by 1 \n dmg: 3~8 \n dmg: 3~7 \n dmg: 3~7","Light: 1 \n If 8 or more damage was done with this page, restore 2 Light and reduce the cost of all other 'Level Slashes' by 1 \n dmg: 5~9 \n dmg: 5~8","Light: 2 \n block: 8~12 \n dmg: 5~7","Light: 3 \n If target is Staggered, use this page again \n dmg: 14~26","Light: 6 \n dmg: 28~42","Light: 5 \n Destroy a Combat Page set on another die of the target \n dmg: 20~39","Light: 2 \n Single Use - Restore 6 Light; fully recover Stagger. Manifest the E.G.O. of the Red Mist next Scene. \n block: 8~15 \n evade: 8~15"};
  String[] egopages = {"Great Split: Horizontal", "Great Split: Vertical", "Manifest: E.G.O."};
  int[] dice;
  public Gebura(){
    hp = 120;
    stagger = 67;
    emotion = 0;
    emotionlvl = 1;
  }
}
