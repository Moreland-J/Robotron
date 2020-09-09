final float ORIENT_INC = PI / 32; 
final int second = 60;

final class AttackRob {
  PVector position, target, vector, velocity;
  float orientation;
  Section location;
  int width, height;
  int radiusW, radiusH;
  boolean see;  // true for player, false for family
  int start, cooldown;
  int speed, counter;
  
  AttackRob(Section room) {
    this.position = new PVector((int) random(room.position.x - room.width / 2, room.position.x + room.width / 2), (int) random(room.position.y - room.height / 2, room.position.y + room.height / 2));
    this.vector = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.orientation = 0f;
    this.location = room;
    this.width = displayWidth / 40;
    this.height = displayHeight / 22;
    this.radiusW = displayWidth / 3;
    this.radiusH = displayHeight / 3;
    this.cooldown = 0;
    this.speed = 1;
    this.start = second * 2;
  }
  
  Bullet draw() {
    strokeWeight(1);
    fill(255, 0, 0);
    ellipse(position.x, position.y, width, height);
    // orange for family attacker
    cooldown--;
    return move();
  }
  
  Bullet move() {    
    // chase using target var
    if (see && isInRoom()) {
      this.vector = new PVector(target.x - position.x, target.y - position.y);
      this.velocity = new PVector((float)vector.x, (float)vector.y);      
    }
    else if (!see && isInRoom()) {
      velocity.x = cos(orientation);
      velocity.y = sin(orientation);
    }
    else if (!see && !isInRoom()) {
      // BOUNCE OFF EDGE
      orientation = orientation + PI;
      if ((position.x < location.position.x + location.width / 2) || (position.x > location.position.x - location.width / 2)) velocity.x = -velocity.x ;
      if ((position.y < location.position.y + location.height / 2) || (position.y > location.position.y - location.height / 2)) velocity.y = -velocity.y ;
    }

    
    velocity.normalize().mult(speed);
    position.add(velocity);
    
    float targetOrientation = atan2(velocity.y, velocity.x);
    if (abs(targetOrientation - orientation) <= ORIENT_INC) {
      orientation = targetOrientation;
      if (counter > 0) {
        counter--;
      }
      else if (counter == 0) { 
        speed = 1;
      }
      return scan();
    }
    
    // CORRECT ORIENTATION FROM COMPLETE ROTATIONS
    if (targetOrientation < orientation) {
      if (orientation - targetOrientation < PI) orientation -= ORIENT_INC;
      else orientation += ORIENT_INC;
    }
    else {
      if (targetOrientation - orientation < PI) orientation += ORIENT_INC;
      else orientation -= ORIENT_INC; 
    }
    
    // Keep in bounds
    if (orientation > PI) orientation -= 2 * PI;
    else if (orientation < -PI) orientation += 2 * PI;    
      
    if (counter > 0) {
      counter--;
    }
    else if (counter == 0) { 
      speed = 1;
    }
      
    return scan();
  }
  
  Bullet scan() {
    target = player.position;
    
    // perform scan
    see = false;
    // TODO: minus section size from radius measurements
    if (player.position.x > position.x - radiusW / 2 && player.position.x < position.x + radiusW / 2 &&
        player.position.y > position.y - radiusH / 2 && player.position.y < position.y + radiusH / 2) {
          see = true;
        }
    // see PursueSketch
    if (start > 0) {
      start--;
    }
    if(cooldown <= 0 && start == 0) {
      return fire(target);
    }
    else {
      return null;
    }
  }
  
  Bullet fire(PVector target) {
    Bullet bullet = new Bullet(position, target, 1);
    cooldown = second / 2;
    return bullet;
  }
  
  void slow() {
    counter = second * 3;
    speed = 0;
  }
  
  boolean isInRoom() {
    for (int i = 0; i < map.size(); i++) {
      float l2 = map.get(i).position.x - map.get(i).width / 2;
      float r2 = map.get(i).position.x + map.get(i).width / 2;
      float t2 = map.get(i).position.y - map.get(i).height / 2;
      float b2 = map.get(i).position.y + map.get(i).height / 2;
      
      if (position.x >= l2 && position.x <= r2 && position.y >= t2 && position.y <= b2) {
        return true;
      }
    }
    return false;
  }
}
