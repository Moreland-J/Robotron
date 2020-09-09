final class Human {
  PVector position, playerPos, robPos, vector, velocity;
  float orientation;
  Section section;
  int width, height;
  boolean seePlayer, seeRob, attOrTrans;
  int radiusW, radiusH;
  int member, speed, who;
  
  Human(Section room) {
    this.position = new PVector((int) random(room.position.x - room.width / 2, room.position.x + room.width / 2), (int) random(room.position.y - room.height / 2, room.position.y + room.height / 2));
    this.orientation = 0f;
    this.section = room;
    this.vector = new PVector(0, 0);
    this.velocity = new PVector(0, 0);
    
    this.member = (int) random(0, 3);
    if (member == 0) {
      this.width = displayWidth / 60;
      this.height = displayHeight / 22;
      speed = 3;
    }
    else if (member == 1) {
      this.width = displayWidth / 65;
      this.height = displayHeight / 30;
      speed = 2;
    }
    else if (member == 2) {
      this.width = displayWidth / 70;
      this.height = displayHeight / 40;
      speed = 1;
    }
    this.radiusW = displayWidth / 3;
    this.radiusH = displayHeight / 3;
    
    this.seePlayer = false;
    this.seeRob = false;
  }
  
  void draw() {
    strokeWeight(1);
    if (member == 0) {
      fill(255, 255, 90);
    }
    else if (member == 1) {
      fill(255, 150, 255);
    }
    else if (member == 2) {
      fill(0, 255, 85);
    }
    ellipse(position.x, position.y, width, height);
    
    move();
    scan();
  }
  
  void move() {
    if (seeRob) {
      if (attOrTrans) {
        this.vector = new PVector(position.x - transformers.get(who).position.x, position.y - transformers.get(who).position.y);
        this.velocity = new PVector((float)vector.x, (float)vector.y);
        velocity.normalize().mult(speed);
      }
      else if (!famAttackers.isEmpty()) {
        this.vector = new PVector(position.x - famAttackers.get(who).position.x, position.y - famAttackers.get(who).position.y);
        this.velocity = new PVector((float)vector.x, (float)vector.y);
        velocity.normalize().mult(speed);
      }
    }
    else if (seePlayer) {
      this.vector = new PVector(player.position.x - position.x, player.position.y - position.y);
      this.velocity = new PVector((float)vector.x, (float)vector.y);
      velocity.normalize().mult(speed);
    }
    else {
      // patrol velocity
      velocity.x = cos(orientation);
      velocity.y = sin(orientation);
      velocity.mult(speed);
      
      orientation += random(0, PI/64) - random(0, PI/64);
      keepInBounds();
    }
      
    if (!isInRoom()) {
      orientation = orientation + PI;
      
      // BOUNCE OFF EDGES
      if ((position.x < section.position.x - section.width / 2) || (position.x > section.position.x + section.width / 2)) velocity.x = -velocity.x;
      if ((position.y < section.position.y - section.height / 2) || (position.y > section.position.y + section.height / 2)) velocity.y = -velocity.y;
    }  
      
    velocity.normalize();
    position.add(velocity);
 
    float targetOrientation = atan2(velocity.y, velocity.x);
    if (abs(targetOrientation - orientation) <= ORIENT_INC) {
      orientation = targetOrientation;
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
    keepInBounds();
  }
  
  void keepInBounds() {
    // Keep in bounds
    if (orientation > PI) orientation -= 2 * PI;
    else if (orientation < -PI) orientation += 2 * PI;
  }
  
  void scan() {
    seePlayer = false;
    seeRob = false;
    // see if any of the coordinates are in the rectangle
    // TODO: minus section size from radius measurements
    if (player.position.x > position.x - radiusW / 2 && player.position.x < position.x + radiusW / 2 &&
        player.position.y > position.y - radiusH / 2 && player.position.y < position.y + radiusH / 2) {
          seePlayer = true;
        }
    float shortestDist = radiusW;
    
    for (int i = 0; i < transformers.size(); i++) {
      if (transformers.get(i).position.x > position.x - radiusW / 2 && transformers.get(i).position.x < position.x + radiusW / 2 &&
          transformers.get(i).position.y > position.y - radiusH / 2 && transformers.get(i).position.y < position.y + radiusH / 2) {
            float a = Math.abs(position.x - transformers.get(i).position.x);
            float b = Math.abs(position.y - transformers.get(i).position.y);
            a = a * a;
            b = b * b;
            float dist = (float) Math.sqrt(a + b);
            if(dist < shortestDist) {
              shortestDist = dist; 
              seeRob = true;
              attOrTrans = true;
              who = i;
            }
        }
    }
    
    for (int i = 0; i < famAttackers.size(); i++) {
      if (famAttackers.get(i).position.x > position.x - radiusW / 2 && famAttackers.get(i).position.x < position.x + radiusW / 2 &&
          famAttackers.get(i).position.y > position.y - radiusH / 2 && famAttackers.get(i).position.y < position.y + radiusH / 2) {
            float a = Math.abs(position.x - famAttackers.get(i).position.x);
            float b = Math.abs(position.y - famAttackers.get(i).position.y);
            a = a * a;
            b = b * b;
            float dist = (float) Math.sqrt(a + b);
            if(dist < shortestDist) {
              shortestDist = dist; 
              seeRob = true;
              attOrTrans = false;
              who = i;
            }
        }
    }
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
