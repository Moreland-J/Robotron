public class Digger {
  int id = 0, colour = 255;
  PVector position;
  boolean inRoom;    // summarises Fr and Fc
  int xSection = displayWidth / 16;
  int ySection = displayHeight / 16;
  ArrayList<PVector> placesBeen;
  
  Digger() {
    this.position = new PVector((int) random(displayWidth / 3, (displayWidth / 3) * 2), (int) random(displayHeight / 3, (displayHeight / 3) * 2));
    this.inRoom = false;
    placesBeen = new ArrayList<PVector>();
    placesBeen.add(position);
  }
  
  void draw() {
    text(id, position.x, position.y);
    id++;
    if (inRoom) {
      fill(colour, 0, 0);
    }
    else {
      fill (0, 255, 255);
    }
    rect(position.x, position.y, xSection, ySection);
  }
  
  public void move() {
    // floats are truncated to ints, 2.5 --> 2
    println("in room: " + detect());
    while (detect()) {        // GETTING STUCK IN LOOP, ESCAPE WITH COUNTER AND RETURN FALSE SO THAT DIGGER CAN BE MOVED TO ANOTHER START POINT AT EDGE OF A ROOM
      println("detecting room loop");
      int vertHoriz = (int) random(0, 2);
      if (vertHoriz == 0) {
        vertHoriz = (int) random(0, 2);
        if (vertHoriz == 0 && position.x < displayWidth - xSection) {
          position.x = position.x + xSection;
        }
        else if (vertHoriz == 1 && position.x > 0 + xSection) {
          position.x = position.x - xSection;
        }
      }
      else {
        vertHoriz = (int) random(0, 2);
        if (vertHoriz == 0 && position.y < displayHeight - ySection) {
          position.y = position.y + ySection;
        }
        else if (vertHoriz == 1 && position.y > 0 + ySection) {
          position.y = position.y - ySection;
        }
      }    
    }
    placesBeen.add(position);
  }
  
  boolean checkInRoom() {
    for (int i = 0; i < map.size(); i++) {
      if (position.x > map.get(i).position.x - map.get(i).width / 2 &&
          position.x < map.get(i).position.x + map.get(i).width / 2 &&
          position.y > map.get(i).position.y - map.get(i).height / 2 &&
          position.y > map.get(i).position.y - map.get(i).height / 2) {
            return true;
          }
    }
    return false;
  }
  
  // DRAW CORRIDOR SECTIONS
  public Section drawCorridor() {
    Section corridor = new Section((int) position.x, (int) position.y, xSection, ySection, false);
    while (detectRoomCollision(corridor)) {
      println("corridor");
      corridor = new Section((int) position.x, (int) position.y, xSection, ySection, false);
    }
    return corridor;
  }
  
  // DRAW FULL ROOM
  public Section drawRoom() {
    int roomWidth = (int) random(2, 6);
    int roomHeight = (int) random(2, 6);
        
    if (roomWidth % 2 == 0) {
      roomWidth += 1;
    }
    if (roomHeight % 2 == 0) {
      roomHeight += 1;
    }
    Section room = new Section((int) position.x, (int) position.y, xSection * roomWidth, ySection * roomHeight, true);
    int counter = 0;
    while (detectRoomCollision(room) && counter < 100) {
      room = new Section((int) position.x, (int) position.y, xSection * roomWidth, ySection * roomHeight, true);
      counter++;
      println("draw room loop");
    }
    println(counter + " collisions");
    if (counter < 100) {
      return room;
    }
    else {
      return null;
    }
  }
  
  // CHECKS IF DIGGER IS IN ROOM
  public boolean detect() {
    for (int i = 0; i < map.size(); i++) {
      if (position.x < map.get(i).position.x + map.get(i).width / 2 &&
          position.x > map.get(i).position.x - map.get(i).width / 2 &&
          position.y < map.get(i).position.y + map.get(i).height / 2 &&
          position.y > map.get(i).position.y - map.get(i).height / 2) {
            inRoom = true;
            return inRoom;
          }
    }
    inRoom = false;
    return inRoom;
  }
  
  public boolean detectRoomCollision(Section room) {
    println("detecting");
    //PVector topleft1 = new PVector(room.position.x - room.width / 2, room.position.y - room.height / 2);
    //PVector topright1 = new PVector(room.position.x + room.width / 2, room.position.y - room.height / 2);
    //PVector bottomleft1 = new PVector(room.position.x - room.width / 2, room.position.y + room.height / 2);
    //PVector bottomright1 = new PVector(room.position.x + room.width / 2, room.position.y + room.height / 2);
    
    //if (topleft1.x < 0 || topright1.x > displayWidth || topleft1.y < 0 || bottomright1.y > displayHeight) {
    //  return true;
    //}
    
    //for (int i = 0; i < map.size(); i++) {
    //  if (map.get(i).type) {
    //    //PVector topleft2 = new PVector(map.get(i).position.x - map.get(i).width / 2, map.get(i).position.y - map.get(i).height / 2);
    //    PVector topright2 = new PVector(map.get(i).position.x + map.get(i).width / 2, map.get(i).position.y - map.get(i).height / 2);
    //    PVector bottomleft2 = new PVector(map.get(i).position.x - map.get(i).width / 2, map.get(i).position.y + map.get(i).height / 2);
    //    //PVector bottomright2 = new PVector(map.get(i).position.x + map.get(i).width / 2, map.get(i).position.y + map.get(i).height / 2);
        
    //    if (topright1.y < bottomleft2.y || bottomleft1.y > topright2.y ||
    //        topright1.x < bottomleft2.x || bottomleft1.x > topright2.x) {
    //          return true;
    //    }
    //  }
    //}
    //return false;
    int top1 = (int) room.position.y - room.height / 2;
    int left1 = (int) room.position.x - room.width / 2;
    int bottom1 = (int) room.position.y + room.height / 2;
    int right1 = (int) room.position.x + room.width / 2;
    
    for (int i = 0; i < map.size(); i++) {
      if (map.get(i).type) {
        int top2 = (int) map.get(i).position.y - map.get(i).height / 2;
        int left2 = (int) map.get(i).position.x - map.get(i).width / 2;
        int bottom2 = (int) map.get(i).position.y + map.get(i).height / 2;
        int right2 = (int) map.get(i).position.x + map.get(i).width / 2;
        
        //if ((right2 > left1 && bottom2 > top1) || (left2 < right1 && top2 < bottom1) ||
        //    (right2 > left1 && top2 < bottom1) || (left2 < right1 && bottom2 > top1)) {
        //  return true;
        //}
        
        println(left1 + " " + right1 + " " + top1 + " " + bottom1);
        println(left2 + " " + right2 + " " + top2 + " " + bottom2);

        if( left1 < right2 && right1 > left2 && bottom1 < top2 && top1 > bottom2){
          return true;
        }
      }
    }
    
    return false;
  }
}
