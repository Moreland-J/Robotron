        if (t2 > location.position.y - location.height) {
          float diff = location.position.y - location.height - t2;
          // sort into distance order, shortest distance first
          if (higher.isEmpty()) {
            higher.add(map.get(i));
            diffs.add(diff);
          }
          for (int j = 0; j < higher.size(); j++) {
            if (diff < diffs.get(j)) {
              diffs.add(j, diff);
              higher.add(j, map.get(i));
            }
          }

      boolean move = false;
      for (int i = 0; i < map.size(); i++) {
        // check which rooms are higher than current
        float l2 = map.get(i).position.x - map.get(i).width;
        float r2 = map.get(i).position.x + map.get(i).width;
        //float t2 = map.get(i).position.y - map.get(i).height;
        float b2 = map.get(i).position.y + map.get(i).height;
        
        println("move up");
        println("b2: " + b2 + ", t1: " + t1);
        if ((b2 >= t1 && position.x < r2 && position.x > l2) || position.y > t1) {
          move = true;
        }
      }
      
      if (move) {
        position.y = position.y - speed;
      }

  //  if (dir == 'w' && position.y - speed > location.position.y - location.height / 2) {
  //    position.y = position.y - speed;
  //  }
  //  else if (dir == 'a' && position.x - speed > location.position.x - location.width / 2) {
  //    position.x = position.x - speed;
  //  }
  //  else if (dir == 's' && position.y + speed < location.position.y + location.height / 2) {
  //    position.y = position.y + speed;
  //  }
  //  else if (dir == 'd' && position.x + speed < location.position.x + location.width / 2) {
  //    position.x = position.x + speed;
  //  }
  //  else if (dir == 'e' && position.y - speed > location.position.y - location.height / 2 && position.x + speed < location.position.x + location.width / 2) {
  //    position.x = position.x - speed;
  //    position.y = position.y + speed;
  //  }
  //}
    //float l1 = position.x - width;
    //float r1 = position.x + width;
    //float t1 = position.y - height;
    //float b1 = position.y + height;
