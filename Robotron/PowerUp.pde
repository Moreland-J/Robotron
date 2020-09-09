final class PowerUp {
  PVector position;
  int width, height, type;
  int colour1, colour2, colour3;
  float vertices[];
  
  PowerUp(Section room, int type) {
    this.position = new PVector((int) random(room.position.x - room.width / 2, room.position.x + room.width / 2), (int) random(room.position.y - room.height / 2, room.position.y + room.height / 2));
    this.type = type;
    colour1 = 0;
    if (type == 0) {
      // blue
      this.colour2 = 255;
      this.colour3 = 255;
    }
    else {
      // green
      this.colour2 = 235;
      this.colour3 = 22;
    }
    this.vertices = new float[16];
  }
  
  void draw() {
    stroke(0);
    fill(colour1, colour2, colour3);
    polygon(position.x, position.y, 20, 7);
    //rotate(frameCount / -100.0);
  }
  
  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    
    int b = 0;
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
      vertices[b++] = sx;
      vertices[b++] = sy;
    }
    endShape(CLOSE);
  }
  
  boolean contains(float x, float y) {
    int intersects = 0;
    for (int j = 0; j < vertices.length; j += 2) {
      float x1 = vertices[j];
      float y1 = vertices[j + 1];
      float x2 = vertices[(j + 2) % vertices.length];
      float y2 = vertices[(j + 3) % vertices.length];
      
      if (((y1 <= y && y < y2) || (y2 <= y && y < y1)) && x < ((x2 - x1) / (y2 - y1) * (y - y1) + x1)) {
        intersects++;
      }
    }
    return (intersects & 1) == 1;
  }
  
  int activate() {
    return type;
  }
}

// https://processing.org/examples/regularpolygon.html
