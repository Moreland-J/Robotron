final class TransformRob {
  PVector position, target, vector, velocity;
  float orientation;
  Section location;
  int width, height;
  int radiusW, radiusH;
  boolean see;  // true for player, false for family
  int start, cooldown;
  float speed, counter;
  
  TransformRob(Section room) {
    this.position = new PVector((int) random(room.position.x - room.width / 2, room.position.x + room.width / 2), (int) random(room.position.y - room.height / 2, room.position.y + room.height / 2));
    this.vector = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    this.orientation = 0f;
    this.location = room;
    this.width = displayWidth / 45;
    this.height = displayHeight / 27;
    this.radiusW = displayWidth / 3;
    this.radiusH = displayHeight / 3;
    this.cooldown = 0;
    this.speed = .5f;
    this.start = second * 2;
  }
  
  void draw() {
    stroke(255, 0, 0);
    strokeWeight(1);
    fill(255, 255, 0);
    ellipse(position.x, position.y, width, height);
    // orange for family attacker
    cooldown--;
    move();
  }
  
  void  move() {    
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
      scan();
      return;
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
      
    scan();
  }
  
  void scan() {
    float shortest = displayWidth;
    int victim = 0;
    for (int i = 0; i < family.size(); i++) {
      // for all, detect shortest dist
      float a = Math.abs(position.x - family.get(i).position.x);
      float b = Math.abs(position.y - family.get(i).position.y);
      
      a = a * a;
      b = b * b;
      
      float dist = (float) Math.sqrt(a + b);
      
      if (dist < shortest) {
        shortest = dist;
        victim = i;
      }
    }
    if (!family.isEmpty()) {
      target = family.get(victim).position;
    }
    
    // perform scan
    see = false;
    // TODO: minus section size from radius measurements
    if (target.x > position.x - radiusW / 2 && target.x < position.x + radiusW / 2 &&
        target.y > position.y - radiusH / 2 && target.y < position.y + radiusH / 2) {
          see = true;
        }
    // see PursueSketch
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
