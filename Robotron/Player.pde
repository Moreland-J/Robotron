final class Player {
  PVector position;
  int width, height, weight;
  int lives, colour1, colour2, colour3, counter;
  int storeLives, border1, border2, border3, counter2;
  boolean hit, invincible;
  Section location;
  
  Player(Section room) {
    this.position = room.position.copy();
    this.width = displayWidth / 64;
    this.height = displayHeight / 24;
    this.weight = 1;
    this.lives = 10;
    this.colour3 = 255;
    this.counter = 0;
    this.hit = false;
    this.location = room;
  }
  
  void draw() {
    strokeWeight(weight);
    stroke(border1, border2, border3);
    fill(colour1, colour2, colour3);
    rect(position.x, position.y, width, height);
    if (counter > 0) {
      counter--;
    }
    else if (counter == 0) {
      colour1 = 0;
      colour2 = 0;
      colour3 = 255;
    }
    
    if (counter2 > 0) {
      counter2--;
      lives = storeLives;
    }
    else if (counter2 == 0) {
      weight = 1;
      border1 = 0;
      border2 = 0;
      border3 = 0;
    }
  }
  
  void move(char dir) {
    int speed = 20;

    // if there is a section higher/lefter/right/lower than current section  
    if (dir == 'w') {
      if (isInRoom(position.x, position.y - speed)) {
        position.y = position.y - speed;
      }
    }
    else if (dir == 'a') {
      if (isInRoom(position.x - speed, position.y)) {
        position.x = position.x - speed;
      }
    }
    else if (dir == 's') {
      if (isInRoom(position.x, position.y + speed)) {
        position.y = position.y + speed;
      }
    }
    else if (dir == 'd') {
      if (isInRoom(position.x + speed, position.y)) {
        position.x = position.x + speed;
      }
    }
  }
  
  Bullet fire(int x, int y) {
    Bullet bullet = new Bullet(position, new PVector(x, y), 0);
    return bullet;
  }
  
  void hit() {
    if (!invincible) {
      colour1 = 255;
      colour2 = 255;
      colour3 = 0;
      counter = second / 10;
      counter2 = second;
      lives--;
      storeLives = lives;
    }
  }
  
  void invincible() {
    // TODO: sound effect of power!
    weight = 5;
    border1 = 255;
    border2 = 255;
    border3 = 0;
    counter2 = second * 5;
    storeLives = lives;
    invincible = true;
  }
  
  void bumpWall() {
    counter2 = second * 2;
    storeLives = lives;
  }
  
  void updateLocation(Section room) {
    location = room;
  }
  
  void getLocation() {
    for (int i = 0; i < map.size(); i++) {
      // check which rooms are higher than current
      float l2 = map.get(i).position.x - map.get(i).width / 2;
      float r2 = map.get(i).position.x + map.get(i).width / 2;
      float t2 = map.get(i).position.y - map.get(i).height / 2;
      float b2 = map.get(i).position.y + map.get(i).height / 2;
      
      if (position.x > l2 && position.x < r2 && position.y > t2 && position.y < b2) {
        location = map.get(i);
        break;
      }
    }
  }
  
  boolean isInRoom(float x, float y) {
    for (int i = 0; i < map.size(); i++) {
      float l2 = map.get(i).position.x - map.get(i).width / 2;
      float r2 = map.get(i).position.x + map.get(i).width / 2;
      float t2 = map.get(i).position.y - map.get(i).height / 2;
      float b2 = map.get(i).position.y + map.get(i).height / 2;
      
      //println("xs " + l2 + " " + r2 + " ys" + t2 + " " + b2);
      //println("x: " + x + ", y: " + y);
      
      if (x >= l2 && x <= r2 && y >= t2 && y <= b2) {
        return true;
      }
    }
    return false;
  }
}
