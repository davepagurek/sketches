import java.util.LinkedList;
import java.util.ListIterator;

class Particle {
  PVector velocity;
  PVector acceleration;
  LinkedList<PVector> pastLocations;
  
  Particle() {
    velocity = new PVector(random(-4, 4), random(-4, 4), random(-4, 4));
    acceleration = new PVector(random(-4, 4), random(-4, 4), random(-4, 4));
    pastLocations = new LinkedList<PVector>();
    pastLocations.addFirst(new PVector(random(0, width), random(0, height), random(-width/2, width/2)));
  }
  
  PVector location() {
    return pastLocations.peekFirst();
  }
  
  void update() {
    acceleration = new PVector(width/2, height/2, 0).sub(location()).limit(4);
    velocity.add(acceleration);
    pastLocations.addFirst(location().copy().add(velocity));
    if (pastLocations.size() > 10) {
      pastLocations.removeLast();
    }
  }
  
  void draw() {
    pushMatrix();
    //translate(location.x, location.y, location.z);
    
    if (pastLocations.size() >= 2) {
      ListIterator<PVector> lprev = pastLocations.listIterator(0);
      ListIterator<PVector> lnext = pastLocations.listIterator(1);
      int i = pastLocations.size();
      while (lnext.hasNext()) {
        PVector vprev = lprev.next();
        PVector vnext = lnext.next();
        stroke(lerpColor(#ff784f, #ffe44f, vnext.copy().sub(vprev).mag() / 65));
        strokeWeight((float(i)/float(pastLocations.size())) * 5+1);
        line(
          vprev.x, vprev.y, vprev.z,
          vnext.x, vnext.y, vnext.z
        );
        i--;
      }
    }
    noStroke();
    popMatrix();
  }
}