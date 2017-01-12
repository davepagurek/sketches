ArrayList<Particle> particles;

void setup() {
  size(800, 450, P3D); 
  pixelDensity(displayDensity());
  mouseClicked();
}

void mouseClicked() {
  particles = new ArrayList<Particle>();
  for (int i=0; i<20; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  for (Particle p : particles) {
    p.update();
  }
  
  PVector locationSum = new PVector(0, 0, 0);
  for (Particle p : particles) {
    locationSum.add(p.location());
  }
  
  background(lerpColor(#441304, #ffa647, 1 - (locationSum.mag() / (particles.size() * width * 0.8) )));
  noStroke();
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(float(mouseX) / float(width) * 2*PI);
  translate(-width/2, -height/2, 0);
  for (Particle p : particles) {
    p.draw();
  }
  popMatrix();
}