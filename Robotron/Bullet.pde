public class Bullet {
  PVector position, target, vector, velocity;
  int width, height;
  int owner;  // 0 for player, 1 for robot, 2 for famrobot, 3 for super
  int colour1, colour2, colour3;
  
  Bullet(PVector position, PVector target, int owner) {
    this.position = position.copy();
    this.target = target.copy();
    this.width = displayWidth / 250;
    this.height = displayHeight/ 150;
    this.owner = owner;
    this.vector = new PVector(target.x - position.x, target.y - position.y);
    this.velocity = new PVector((float)vector.x * 100, (float)vector.y * 100);
    velocity = velocity.normalize().mult(10);
    
    if (owner == 0) {
      this.colour1 = 0;
      this.colour2 = 0;
      this.colour3 = 255;
    }
    else if (owner == 1) {
      this.colour1 = 255;
      this.colour2 = 0;
      this.colour3 = 0;
    }
    else if (owner == 2) {
      this.colour1 = 255;
      this.colour2 = 138;
      this.colour3 = 79;
    }
    else if (owner == 3) {
      this.colour1 = 78;
      this.colour2 = 98;
      this.colour3 = 195;
    }
  }
  
  void draw() {
    move();
    strokeWeight(1);
    fill(colour1, 0, colour3);
    rect(position.x, position.y, width, height);
  }
  
  void move() {
    position.add(velocity);
  }
  
  boolean isInRoom() {
    for (int i = 0; i < map.size(); i++) {
      float l2 = map.get(i).position.x - map.get(i).width / 2;
      float r2 = map.get(i).position.x + map.get(i).width / 2;
      float t2 = map.get(i).position.y - map.get(i).height / 2;
      float b2 = map.get(i).position.y + map.get(i).height / 2;
      
      //println("xs " + l2 + " " + r2 + " ys" + t2 + " " + b2);
      //println("x: " + x + ", y: " + y);
      
      if (position.x >= l2 && position.x <= r2 && position.y >= t2 && position.y <= b2) {
        return true;
      }
    }
    return false;
  }
}
