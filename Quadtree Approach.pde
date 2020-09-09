void createBoard() {
  // add base node
  Tree tree = new Tree(null, 1, new PVector(0, 0), new PVector(displayWidth, displayHeight));
  
  // split section recursively
  boolean loop = true;
  while (loop) {
    loop = makeSection(tree, 1, tree.root.top, tree.root.bottom);
  }
}

boolean makeSection(Tree tree, int parent, PVector top, PVector bottom) {
  int startDivW = (int) (bottom.x - top.x) / 4;
  int endDivW = startDivW * 3;
  int startDivH = (int) (bottom.y - top.y) / 4;
  int endDivH = startDivH * 3;
  
  PVector top1 = top.copy();
  PVector bottom1 = bottom.copy();
  PVector top2 = top.copy();
  PVector bottom2 = bottom.copy();
  
  int which = (int) random(0, 10);
  if (which < 5) {
    x = (int) random(startDivW, endDivW);
  }
  else {
    y = (int) random(startDivH, endDivH);
  }
  Node left = new Node(tree.traverse(tree.root, parent), parent + 1, top1, bottom1);
  return true;
}