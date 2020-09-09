final class Obstacle {
  PVector position;
  int width, height;
  
  Obstacle(Section room) {
    this.position = new PVector((int) random(room.position.x - room.width / 2, room.position.x + room.width / 2), (int) random(room.position.y - room.height / 2, room.position.y + room.height / 2));
    int longLat = (int) random(0, 2);
    
    if (longLat == 0) { 
      // make horizontal
      this.width = displayWidth / 20;
      this.height = displayHeight / 60;
    }
    else {
      // make vertical
      this.width = displayWidth / 80;
      this.height = displayHeight / 15;
    }
  }
  
  void draw() {
    stroke(0);
    fill(0);
    rect(position.x, position.y, width, height);
  }
}
