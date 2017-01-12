import processing.video.*;
import blobDetection.*;

Capture cam;
BlobDetection theBlobDetection;
PImage img;
boolean newFrame = false;

void setup() {
  size(640, 480);
  cam = new Capture(this, 40*4, 30*4, 15);
  cam.start();
        
  // BlobDetection
  // img which will be sent to detection (a smaller copy of the cam frame);
  img = new PImage(80,60); 
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(true);
  theBlobDetection.setThreshold(0.4f); // will detect bright areas whose luminosity > 0.2f;
}

void captureEvent(Capture cam) {
  cam.read();
  newFrame = true;
}

void draw() {
  if (newFrame)
  {
    newFrame=false;
    image(cam,0,0,width,height);
    img.copy(mirror(cam), 0, 0, cam.width, cam.height, 
        0, 0, img.width, img.height);
    fastblur(img, 2);
    theBlobDetection.computeBlobs(img.pixels);
    drawBlobs();
  }
}

void drawBlobs() {
  background(#000000);
  
  PGraphics pg = createGraphics(width, height);
  pg.beginDraw();
  
  Blob largestBlob = null;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++) {
    Blob b = theBlobDetection.getBlob(n);
    if (largestBlob == null || b.w * b.h > largestBlob.w * largestBlob.h) {
      largestBlob = b;
    }
  }
  
  if (largestBlob != null) {
    color bgColor = img.pixels[
       int(largestBlob.x) + int(largestBlob.y*img.width)
    ];
    pg.background(complementaryColor(saturateColor(bgColor)));
  } else {
    pg.background(#000000);
  }
  
  pg.noStroke();
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++) {
    Blob b=theBlobDetection.getBlob(n);
    if (b == null) {
      continue;
    }
    
    color centerColor = img.pixels[
      int(b.x) + int(b.y*img.width)
    ];
    
    pg.fill(saturateColor(centerColor));
    pg.beginShape();
    for (int m = 0; m < b.getEdgeNb(); m++) {
      EdgeVertex v = b.getEdgeVertexA(m);
      if (v !=null)
        pg.vertex(
          v.x*width, v.y*height 
        );
    }
    pg.endShape(CLOSE);
  }
  
  pg.endDraw();
  
  PImage img = pg.get();
  fastblur(img, 50);
  
  background(#000000);
  blendMode(ADD);
  image(img, 0, 0);
  image(pg, 0, 0);
}