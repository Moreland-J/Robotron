Digger digger;
ArrayList<Section> map;
int wave, possPows;
boolean waveStarted;
boolean surviving;
int score;

Player player;
ArrayList<Human> family;
ArrayList<AttackRob> attackers;
ArrayList<AttackFamRob> famAttackers;
ArrayList<TransformRob> transformers;
ArrayList<SuperRob> supers;
ArrayList<Bullet> bullets;
ArrayList<PowerUp> powers;
ArrayList<Obstacle> obs;

void setup() {
  fullScreen();
  background(50);
  rectMode(CENTER);
  textAlign(CENTER);
  wave = 0;
  surviving = true;
  score = 0;
  
  nextWave();
}


void nextWave() {
  background(50);
  wave++;
  waveStarted = false;
  digger = new Digger();
  map = new ArrayList<Section>();
  createBoard();
  
  player = new Player(map.get(0));
  family = new ArrayList<Human>();
  attackers = new ArrayList<AttackRob>();
  famAttackers = new ArrayList<AttackFamRob>();
  transformers = new ArrayList<TransformRob>();
  supers = new ArrayList<SuperRob>();
  bullets = new ArrayList<Bullet>();
  powers = new ArrayList<PowerUp>();
  obs = new ArrayList<Obstacle>();
  
  int room = 0;
  for (int i = 0; i < wave + 1; i++) {
    if (i % 3 == 0 && i != 0) {
      room = (int) random(1, map.size());
      AttackFamRob rob = new AttackFamRob(map.get(room));
      famAttackers.add(rob);
    }
    if (i % 4 == 0 && i != 0) {
      room = (int) random(1, map.size());
      TransformRob trans = new TransformRob(map.get(room));
      transformers.add(trans);
    }
    else {
      room = (int) random(1, map.size());
      AttackRob rob = new AttackRob(map.get(room));
      attackers.add(rob);
    }
  }
  
  if (possPows <= 25) {
    possPows++;
  }
  for (int i = 0; i < 1; i++) {
    int which = (int) random(1, 2);
    room = (int) random(0, map.size());
    PowerUp power = new PowerUp(map.get(room), which);
    powers.add(power);
    
    room = (int) random(1, map.size());
    Obstacle ob = new Obstacle(map.get(room));
    obs.add(ob);
  }
  
  // generate humans
  for (int i  = 0; i < wave; i++) {
    room = (int) random(1, map.size());
    family.add(new Human(map.get(room)));
  }
  waveStarted = true;
}

void createBoard() {  
  digger.drawRoom();
  int maxRooms = wave + 1;
  int currRooms = 0;
  while (currRooms < 5 && currRooms < maxRooms) {
    println("move and corridor");
    digger.move();
    Section corridor = digger.drawCorridor();
    if (corridor != null) {
      map.add(corridor);
    }
    int chance = (int) random(0, 100);
    //println(chance);
    if (chance < 25) {
      println("chance");
      Section room = digger.drawRoom();
      if (room != null) {
        map.add(room);
        currRooms++;
      }
    }
    println("----------------------------OOOOO----------------------------");
  }
}


void draw() {
  background(50);
  if (!waveStarted) {
    // screen offering to move to next wave
    text("Another wave is coming.\nPress ENTER to engage.", displayWidth / 2, displayHeight / 2);
  }
  else if (surviving) {
    for (int i = 0; i < map.size(); i++) {
      map.get(i).draw();
    }
    player.draw();
    strokeWeight(1);
    stroke(0);
    for (int i = 0; i < family.size(); i++) {
      family.get(i).draw();
    }
    for (int i = 0; i < bullets.size(); i++) {
      if (bullets.get(i) != null && bullets.get(i).isInRoom()) {
        bullets.get(i).draw();
      }
      else {
        bullets.remove(i--);
        if (!bullets.isEmpty() && i < 0) {
          i = 0;
        }
      }
    }
    
    // CREATE ALL ROBOTS
    for (int i = 0; i < attackers.size(); i++) {
      Bullet shot = (attackers.get(i).draw());
      if (shot != null) {
        bullets.add(shot);
      }
    }
    for (int i = 0; i < famAttackers.size(); i++) {
      Bullet shot = (famAttackers.get(i).draw());
      if (shot != null) {
        bullets.add(shot);
      }
    }
    for (int i = 0; i < transformers.size(); i++) {
      transformers.get(i).draw();
    }
    for (int i = 0; i < supers.size(); i++) {
      Bullet shot = supers.get(i).draw();
      if (shot != null) {
        bullets.add(shot);
      }
    }
        
    for (int i = 0; i < powers.size(); i++) {
      powers.get(i).draw();
    }
    for (int i = 0; i < obs.size(); i++) {
      obs.get(i).draw();
    }
    
    // TEXT ON SCREEN
    textSize(25);
    fill(255, 0, 0);
    text("Lives: " + player.lives + "\nScore: " + score + "\nWave: " + wave, displayWidth / 2, 30);
    stroke(0);
    strokeWeight(3);
    line(mouseX - 10, mouseY, mouseX + 10, mouseY);
    line(mouseX, mouseY - 10, mouseX, mouseY + 10);
    
    contact();
    if (attackers.isEmpty() && famAttackers.isEmpty() && transformers.isEmpty() && supers.isEmpty()) {
      waveStarted = false;
    }
    if (player.lives <= 0) {
      surviving = false;
    }
  }
  else {
    // game over, humanity is over
    text("Game Over.\nHumanity has fallen.\nScore: " + score + "\nPress ENTER to try again.", displayWidth / 2, displayHeight / 2);
  }
}

void mousePressed() {
}

void mouseReleased() {
  if (waveStarted) {
    bullets.add(player.fire(mouseX, mouseY));
  }
}

void keyPressed() {
  if (key == 'w' && waveStarted && surviving) {
    player.move('w');
  }
  if (key == 'a' && waveStarted && surviving) {
    player.move('a');
  }
  if (key == 'd' && waveStarted && surviving) {
    player.move('d');
  }
  if (key == 's' && waveStarted && surviving) {
    player.move('s');
  }
  if (key == ENTER && !waveStarted) {
    nextWave();
  }
  if (key == ENTER && !surviving) {
    setup();
  }
}

void keyReleased() {
  
}

void contact() {
  // comment out to switch off detection features
  bulletContact();
  playObsCont();
  if (surviving) {
    playHumCont();
    playPowCont();
    robHumCont();
  }
}

void bulletContact() {
  // check if bullet has come into contact with player
  // humans or any of the robots
  // destroy anything that is in contact
  // if humans arraylist reaches size 0 then return   surviving = false
  
  // player hit
  int topedge1 = (int) player.position.y - player.height / 2;
  int leftedge1 = (int) player.position.x - player.width / 2;
  int bottomedge1 = (int) player.position.y + player.height / 2;
  int rightedge1 = (int) player.position.x + player.width / 2;
  
  for (int i = 0; i < bullets.size(); i++) {
    if (!bullets.isEmpty() && (bullets.get(i).owner == 1 || bullets.get(i).owner == 3)) {
      int topedge2 = (int) bullets.get(i).position.y - bullets.get(i).height / 2;
      int leftedge2 = (int) bullets.get(i).position.x - bullets.get(i).width / 2;
      int bottomedge2 = (int) bullets.get(i).position.y + bullets.get(i).height / 2;
      int rightedge2 = (int) bullets.get(i).position.x + bullets.get(i).width / 2;
      
      if (leftedge1 < rightedge2 && rightedge1 > leftedge2 && bottomedge1 > topedge2 && topedge1 < bottomedge2) {
        bullets.remove(i--);         
        if (!bullets.isEmpty() && i < 0) {
          i = 0;
        };
        player.hit();
        println("Player Lives: " + player.lives);
        if (player.lives == 0) {
          surviving = false;
          return;
        }
      }
      
      // SHOOT OBSTACLE BY ATTACKER
      for (int j = 0; j < obs.size(); j++) {
        if (!bullets.isEmpty()) {
          int topedge3 = (int) obs.get(j).position.y - obs.get(j).height / 2;
          int leftedge3 = (int) obs.get(j).position.x - obs.get(j).width / 2;
          int bottomedge3 = (int) obs.get(j).position.y + obs.get(j).height / 2;
          int rightedge3 = (int) obs.get(j).position.x + obs.get(j).width / 2;
          
          if (leftedge3 < rightedge2 && rightedge3 > leftedge2 && bottomedge3 > topedge2 && topedge3 < bottomedge2) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
          }
        }
      }
    }
    
    // famattack robot shot
    if (!bullets.isEmpty() && bullets.get(i).owner == 2) {
      int topedge2 = (int) bullets.get(i).position.y - bullets.get(i).height / 2;
      int leftedge2 = (int) bullets.get(i).position.x - bullets.get(i).width / 2;
      int bottomedge2 = (int) bullets.get(i).position.y + bullets.get(i).height / 2;
      int rightedge2 = (int) bullets.get(i).position.x + bullets.get(i).width / 2;
      
      for (int j = 0; j < obs.size(); j++) {
        if (!bullets.isEmpty() && !family.isEmpty()) {
          int topedge3 = (int) family.get(j).position.y - family.get(j).height / 2;
          int leftedge3 = (int) family.get(j).position.x - family.get(j).width / 2;
          int bottomedge3 = (int) family.get(j).position.y + family.get(j).height / 2;
          int rightedge3 = (int) family.get(j).position.x + family.get(j).width / 2;
          
          if (leftedge3 < rightedge2 && rightedge3 > leftedge2 && bottomedge3 > topedge2 && topedge3 < bottomedge2) {
            bullets.remove(i--);         
            if (!bullets.isEmpty() && i < 0) {
              i = 0;
            };
            family.remove(j);
            if (family.isEmpty()) {
              surviving = false;
            }
          }
        }
      }
    }
    
    // shots from player
    else if (!bullets.isEmpty() && surviving && bullets.get(i).owner == 0) {
      for (int j = 0; j < attackers.size(); j++) {
        if (!bullets.isEmpty()) {
          PVector dist = new PVector();
          dist.x = abs(attackers.get(j).position.x - bullets.get(i).position.x);
          dist.y = abs(attackers.get(j).position.y - bullets.get(i).position.y);
          
          if (dist.x > (bullets.get(i).width / 2 + attackers.get(j).width / 2) || (dist.y > (bullets.get(i).height / 2 + attackers.get(j).height / 2))) {
            continue;
          }
          if (dist.x <= bullets.get(i).width / 2 || dist.y <= bullets.get(i).height / 2) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
            attackers.remove(j);
            incScore(-1);
            continue;
          }
          
          int dist_sq = (int) Math.pow(dist.x - bullets.get(i).width / 2, 2) + (int) Math.pow(dist.y - bullets.get(i).width/ 2, 2);
          if (dist_sq <= (int) Math.pow(attackers.get(j).width, 2) || dist_sq <= (int) Math.pow(attackers.get(j).height, 2)) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
            attackers.remove(j);
            incScore(-1);
          }
        }
      }
      for (int j = 0; j < famAttackers.size(); j++) {
        if (!bullets.isEmpty()) {
          PVector dist = new PVector();
          dist.x = abs(famAttackers.get(j).position.x - bullets.get(i).position.x);
          dist.y = abs(famAttackers.get(j).position.y - bullets.get(i).position.y);
          
          if (dist.x > (bullets.get(i).width / 2 + famAttackers.get(j).width / 2) || (dist.y > (bullets.get(i).height / 2 + famAttackers.get(j).height / 2))) {
            continue;
          }
          if (dist.x <= bullets.get(i).width / 2 || dist.y <= bullets.get(i).height / 2) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
            famAttackers.remove(j);
            incScore(-2);
            continue;
          }
          
          int dist_sq = (int) Math.pow(dist.x - bullets.get(i).width / 2, 2) + (int) Math.pow(dist.y - bullets.get(i).width/ 2, 2);
          if (dist_sq <= (int) Math.pow(famAttackers.get(j).width, 2) || dist_sq <= (int) Math.pow(famAttackers.get(j).height, 2)) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
            famAttackers.remove(j);
            incScore(-2);
          }
        }
      }
      for (int j = 0; j < transformers.size(); j++) {
        if (!bullets.isEmpty()) {
          PVector dist = new PVector();
          dist.x = abs(transformers.get(j).position.x - bullets.get(i).position.x);
          dist.y = abs(transformers.get(j).position.y - bullets.get(i).position.y);
          
          if (dist.x > (bullets.get(i).width / 2 + transformers.get(j).width / 2) || (dist.y > (bullets.get(i).height / 2 + transformers.get(j).height / 2))) {
            continue;
          }
          if (dist.x <= bullets.get(i).width / 2 || dist.y <= bullets.get(i).height / 2) {
            bullets.remove(i--);
            if (!bullets.isEmpty() && i < 0) {
              i = 0;
            };
            transformers.remove(j);
            incScore(-2);
            continue;
          }
          
          int dist_sq = (int) Math.pow(dist.x - bullets.get(i).width / 2, 2) + (int) Math.pow(dist.y - bullets.get(i).width/ 2, 2);
          if (dist_sq <= (int) Math.pow(transformers.get(j).width, 2) || dist_sq <= (int) Math.pow(transformers.get(j).height, 2)) {
            bullets.remove(i--);         
            if (!bullets.isEmpty() && i < 0) {
              i = 0;
            };
            transformers.remove(j);
            incScore(-2);
          }
        }
      }
      for (int j = 0; j < supers.size(); j++) {
        // TODO: supers can have multiple lives
        if (!bullets.isEmpty()) {
          PVector dist = new PVector();
          dist.x = abs(supers.get(j).position.x - bullets.get(i).position.x);
          dist.y = abs(supers.get(j).position.y - bullets.get(i).position.y);
          
          if (dist.x > (bullets.get(i).width / 2 + supers.get(j).width / 2) || (dist.y > (bullets.get(i).height / 2 + supers.get(j).height / 2))) {
            continue;
          }
          if (dist.x <= bullets.get(i).width / 2 || dist.y <= bullets.get(i).height / 2) {
            bullets.remove(i--);
            if (!bullets.isEmpty() && i < 0) {
              i = 0;
            };
            supers.remove(j);
            incScore(-2);
            continue;
          }
          
          int dist_sq = (int) Math.pow(dist.x - bullets.get(i).width / 2, 2) + (int) Math.pow(dist.y - bullets.get(i).width/ 2, 2);
          if (dist_sq <= (int) Math.pow(supers.get(j).width, 2) || dist_sq <= (int) Math.pow(supers.get(j).height, 2)) {
            bullets.remove(i--);         
            if (!bullets.isEmpty() && i < 0) {
              i = 0;
            };
            supers.remove(j);
            incScore(-2);
          }
        }
      }
      
      for (int j = 0; j < obs.size(); j++) {
        if (!bullets.isEmpty()) {
          int topedge2 = (int) bullets.get(i).position.y - bullets.get(i).height / 2;
          int leftedge2 = (int) bullets.get(i).position.x - bullets.get(i).width / 2;
          int bottomedge2 = (int) bullets.get(i).position.y + bullets.get(i).height / 2;
          int rightedge2 = (int) bullets.get(i).position.x + bullets.get(i).width / 2;
          
          int topedge3 = (int) obs.get(j).position.y - obs.get(j).height / 2;
          int leftedge3 = (int) obs.get(j).position.x - obs.get(j).width / 2;
          int bottomedge3 = (int) obs.get(j).position.y + obs.get(j).height / 2;
          int rightedge3 = (int) obs.get(j).position.x + obs.get(j).width / 2;
          
          if (leftedge3 < rightedge2 && rightedge3 > leftedge2 && bottomedge3 > topedge2 && topedge3 < bottomedge2) {
            bullets.remove(i--);         if (!bullets.isEmpty() && i < 0) {           i = 0;         };
            obs.remove(j);
          }
        }
      }
      
      if (attackers.isEmpty() && famAttackers.isEmpty() && transformers.isEmpty() && supers.isEmpty()) {
        waveStarted = false;
      }
    }
  }
}

// PLAYER-HUMAN-CONTACT
void playHumCont() {
  PVector dist = new PVector();
  for (int i = 0; i < family.size(); i++) {
    dist.x = abs(family.get(i).position.x - player.position.x);
    dist.y = abs(family.get(i).position.y - player.position.y);
    
    if (dist.x > (player.width / 2 + family.get(i).width / 2) || (dist.y > (player.height / 2 + family.get(i).height / 2))) {
      // does not save
      continue;
    }
    if (dist.x <= player.width / 2 || dist.y <= player.height / 2) {
      // saved a human
      incScore(i);
      family.remove(i);
      continue;
    }
    
    int dist_sq = (int) Math.pow(dist.x - player.width / 2, 2) + (int) Math.pow(dist.y - player.width/ 2, 2);
    if (dist_sq <= (int) Math.pow(family.get(i).width, 2) || dist_sq <= (int) Math.pow(family.get(i).height, 2)) {
      // saved human
      incScore(i);
      family.remove(i);
    }
  }
}


// PLAYER-POWERUP-CONTACT
void playPowCont() {
  float px1 = player.position.x - player.width / 2;
  float py1 = player.position.y - player.height / 2;
  float px2 = player.position.x + player.width / 2;
  float py2 = player.position.y - player.height / 2;
  float px3 = player.position.x + player.width / 2;
  float py3 = player.position.y + player.height / 2;
  float px4 = player.position.x - player.width / 2;
  float py4 = player.position.y + player.height / 2;
  float[] playVerts = {px1, py1, px2, py2, px3, py3, px4, py4};
  
  for (int i = 0; i < powers.size(); i++) {
    for (int j = 0; j < playVerts.length; j++) {
      float x = playVerts[j++];
      float y = playVerts[j];
      if (!powers.isEmpty() && powers.get(i).contains(x, y)) {
        int type = powers.get(i).activate();
        if (type == 0) {
          // activate power
          slow();
        }
        else {
          player.invincible();
        }
        powers.remove(i);
      }
    }
  }
}

void playObsCont() {
  int topedge1 = (int) player.position.y - player.height / 2;
  int leftedge1 = (int) player.position.x - player.width / 2;
  int bottomedge1 = (int) player.position.y + player.height / 2;
  int rightedge1 = (int) player.position.x + player.width / 2;
  
  for (int i = 0; i < obs.size(); i++) {
    int topedge2 = (int) obs.get(i).position.y - obs.get(i).height / 2;
    int leftedge2 = (int) obs.get(i).position.x - obs.get(i).width / 2;
    int bottomedge2 = (int) obs.get(i).position.y + obs.get(i).height / 2;
    int rightedge2 = (int) obs.get(i).position.x + obs.get(i).width / 2;
    
    if (leftedge1 < rightedge2 && rightedge1 > leftedge2 && bottomedge1 > topedge2 && topedge1 < bottomedge2) {
        player.hit();
        if (player.lives == 0) {
          surviving = false;
          return;
        }
        player.bumpWall();
      }
  }
}

void slow() {
  for (int i = 0; i < attackers.size(); i++) {
    attackers.get(i).slow();
  }
  for (int i = 0; i < famAttackers.size(); i++) {
    famAttackers.get(i).slow();
  }
  for (int i = 0; i < transformers.size(); i++) {
    transformers.get(i).slow();
  }
}

// ADD TO THE USERS SCORE
void incScore(int i) {
  if (i == -1) {
    score += 50;
  }
  else if (i == -2) {
    score += 75;
  }
  else if (i == -3) {
    // shot super robot/ ex-human
    // deduct points?
    // no points
  }
  else if (family.get(i).member == 0) {
    score += 100;
  }
  else if (family.get(i).member == 1) {
    score += 200;
  }
  else if (family.get(i).member == 2) {
    score += 300;
  }
}

// ROBOT-HUMAN-CONTACT
void robHumCont() {
  // check for human attack robots
  // and for transformers
  // for transformers remove human and add super robot
  for (int i = 0; i < transformers.size(); i++) {
    for (int j = 0; j < family.size(); j++) {
      
      float a = Math.abs(transformers.get(i).position.x - family.get(j).position.x);
      float b = Math.abs(transformers.get(i).position.y - family.get(j).position.y);
      
      a = a * a;
      b = b * b;
      
      float dist = (float) Math.sqrt(a + b);

      if (dist < transformers.get(i).width / 2 + family.get(j).width / 2 && dist < transformers.get(i).height / 2 + family.get(j).height / 2) {
        SuperRob hybrid = new SuperRob(family.get(j).position.x, family.get(j).position.y);
        family.remove(j);
        if (family.isEmpty()) {
          surviving = false;
        }
        supers.add(hybrid);
      }
    }
  }
   
  for (int i = 0; i < attackers.size(); i++) {
    PVector dist = new PVector();
    dist.x = abs(attackers.get(i).position.x - player.position.x);
    dist.y = abs(attackers.get(i).position.y - player.position.y);
    
    if (dist.x > (player.width / 2 + attackers.get(i).width / 2) || (dist.y > (player.height / 2 + attackers.get(i).height / 2))) {
      // miss
      continue;
    }
    if (dist.x <= player.width / 2 || dist.y <= player.height / 2) {
      // contact
      println(player.counter2);
      if (player.counter2 == 0 ) {
        println("contact");
        player.hit();
      }
      if (player.lives == 0) {
        surviving = false;
        return;
      }
    }
    
    int dist_sq = (int) Math.pow(dist.x - player.width / 2, 2) + (int) Math.pow(dist.y - player.width/ 2, 2);
    if (dist_sq <= (int) Math.pow(attackers.get(i).width, 2) || dist_sq <= (int) Math.pow(attackers.get(i).height, 2)) {
      // contact
      println(player.counter2);
      if (player.counter2 == 0 ) {
        println("contact");
        player.hit();
      }
      if (player.lives == 0) {
        surviving = false;
        return;
      }
    }
  }
}

/*
  Contact of objects
  https://www.gamedevelopment.blog/collision-detection-circles-rectangles-and-polygons/
*/
