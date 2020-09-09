public class Section {
  PVector position = new PVector();
  int width, height;
  boolean type;  // false = corridor, true = room
  
  Section(int x, int y, int width, int height, boolean type) {
    this.position.x = x;
    this.position.y = y;
    this.width = width;
    this.height = height;
    this.type = type;
  }
  
  void draw() {
    fill(200);
    stroke(0);
    strokeWeight(0);
    rect(position.x, position.y, width, height);
  }
}
