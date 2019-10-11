
Scene scene;
color c_sky = color(111, 218, 236);
color c_red = color(238, 110, 92);
color c_red_light = color(236, 129, 111);
color c_red_dark = color(220, 91, 76);
color c_red_shadow = color(165, 66, 52);
color c_white = color(253, 244, 238);
color c_white_shadow = color(208, 174, 165);
color c_gray_dark = color(50);
//color c_yellow = color(247, 252, 2);
color c_yellow_dark = color(222, 226, 1);
//color c_yellow_shadow = color(177, 180, 0);
color c_red_poison = color(190, 8, 3);

void setup() {
  size(1200, 900);
  smooth();
  scene = new Scene();
}

void draw() {
  background(c_sky);
  scene.move();
  scene.display();
  scene.aircraft.setPosition(width/2 - 92, mouseY - 44);
  scene.aircraft.display();
  scene.detectCollisions();
}

class Aircraft {
  float x;
  float y; 
  
  Aircraft(float xPos, float yPos) {
    x = xPos;
    y = yPos;
  }
  
  void setPosition(float xPos, float yPos) {
    x = xPos;
    y = yPos;
  }
  
  void display() {
    fill(c_red);
    stroke(c_red);    
    // tail
    rect(x, y, 32, 36);
    // body
    rect(x+16, y+18, 72, 50);
    //quad(x+16, y+18, x+88, y+18, x+88, y+70, x+16, y+54);
    rect(x+88, y+12, 46, 70);
    //quad(x+88, y+18, x+134, y+12, x+134, y+88, x+88, y+88);
    // head
    fill(c_white);
    stroke(c_white);   
    rect(x+134, y+12, 30, 58);
    fill(c_white_shadow);
    stroke(c_white_shadow);  
    quad(x+164, y+12, x+184, y+18, x+184, y+64, x+164, y+70);
    // wing
    fill(c_red_light);
    stroke(c_red_light); 
    quad(x+36, y+36, x+80, y+34, x+80, y+44, x+36, y+42);
    fill(c_red_dark);
    stroke(c_red_dark); 
    quad(x+80, y+34, x+80, y+44, x+96, y+42, x+96, y+36);
    fill(c_red_shadow);
    stroke(c_red_shadow); 
    quad(x+56, y+42, x+96, y+42, x+76, y+68, x+36, y+68);
    // propeller
    fill(c_gray_dark);
    stroke(c_gray_dark);
    quad(x+170, y+2, x+173, y-6, x+193, y+78, x+190, y+86);
    quad(x+190, y-4, x+193, y+4, x+173, y+88, x+170, y+80);
    rect(x+175, y+36, 6, 8);
  }
}

class Scene {
  Aircraft aircraft;
  int score;
  int speed;
  PFont joystix;
  int totalCoins = 5;
  int totalPoisons = 5;
  
  Coin[] coins = new Coin[totalCoins];
  Coin[] poisons = new Coin[totalPoisons];
  
  Scene() {
    // generate rewards
    for(int i = 0; i < totalCoins; i++) {
      coins[i] = new Coin(random(0, width), random(15, height-15), 30, false);
    }
    // generate poison
    for(int i = 0; i < totalPoisons; i++) {
      poisons[i] = new Coin(random(0, width), random(15, height-15), 30, true);
    }
    aircraft = new Aircraft(width/2 - 92, height/2 - 44);
    score = 0;
    speed = 2;
  }
  
  void display() {
    joystix = createFont("joystix.ttf", 32);
    textFont(joystix);
    String str_score = "Score: " + score;
    text(str_score, 30, 50);
    joystix = createFont("joystix.ttf", 24);
    textFont(joystix);
    String str_speed = "Speed: " + speed;
    text(str_speed, 30, 90);
    for(int i = 0; i < totalCoins; i++) {
      coins[i].display();
    }
    for(int i = 0; i < totalPoisons; i++) {
      poisons[i].display();
    }
  }
  
  void move() {
    for(int i = 0; i < totalCoins; i++) {
      coins[i].move(speed);
    }
    for(int i = 0; i < totalPoisons; i++) {
      poisons[i].move(speed);
    }
  }
  
  void setSpeed(boolean increase) {
    speed = increase ? speed + 1 : speed - 1;
  }
  
  void detectCollisions() {
    boolean collision = false;
    for(int i = 0; i < totalCoins; i++) {
      collision = coins[i].checkCollision(aircraft);
      if(collision) {
        score += 1;
      }
    }
    for(int i = 0; i < totalPoisons; i++) {
      collision = poisons[i].checkCollision(aircraft);
      if(collision) {
        score -= 1;
      }
    }
  }
}

class Coin {
  float x;
  float y;
  int l;
  float radians;
  boolean isPoison;
  
  Coin(float xPos, float yPos, int len, boolean poison) {
    x = xPos;
    y = yPos;
    l = len;
    radians = random(0, 180);
    isPoison = poison;
  }
  
  void display() {
    noStroke();
    if(isPoison) {
      fill(c_red_poison);
    } else {
      fill(c_yellow_dark);
    }
    rect(x, y, l, l);
  }
  
  void move(int speed) {
    x -= speed;
    if(x <= 0) {
      restart();
    }
  }
  
  void restart() {
    x = width;
    y = random(15, height-15);
  }
  
  boolean checkCollision(Aircraft a) {
    if (x >= a.x && x <= a.x+16) {
      if (y >= a.y && y <= a.y+36 || y+l >= a.y && y+l <= a.y+36) {
        restart();
        return true;
      }
    } else if (x >= a.x+16 && x <= a.x+32) {
      if (y >= a.y && y <= a.y+68 || y+l >= a.y && y+l <= a.y+68) {
        restart();
        return true;
      }
    } else if (x >= a.x+32 && x <= a.x+88) {
      if (y >= a.y+18 && y <= a.y+68 || y+l >= a.y+18 && y+l <= a.y+68) {
        restart();
        return true;
      }
    } else if (x >= a.x+88 && x <= a.x+134) {
      if (y >= a.y+12 && y <= a.y+82 || y+l >= a.y+12 && y+l <= a.y+82) {
        restart();
        return true;
      }
    } else if (x >= a.x+134 && x <= a.x+184) {
      if (y >= a.y+12 && y <= a.y+70 || y+l >= a.y+12 && y+l <= a.y+70) {
        restart();
        return true;
      }
    } 
    return false;
  }
}

void keyPressed() {
  if (keyCode == UP) {
    scene.setSpeed(true);
  } else  if (keyCode == DOWN) {
    if (scene.speed > 2) {
      scene.setSpeed(false);
    }
  }
}
