class Particle {
  float size;
  float origSize;
  PVector loc; 
  PVector limit; 
  PVector vel;
  PVector acc;
  PVector rot;
  PVector rotShift;
  color c;
  float alpha = 255;
  int id;
  Boolean isDead = false;
  Boolean toFade = false;
  Boolean isFlashing = false;
  float delr, delg, delb, flashStartT = 0, flashDur = 0.5, flashDurFrames;
  Boolean isSpinning = false;
  float spinStartT = 0, spinDur = 0.3, spinDurFrames;


  Particle(float r, float g, float b, float x, float y, float z, float locx, float locy, float locz, float size_, int id_) {
    //size = size_; 
    size = (log(size_ + 0.001/0.001)) / (log(0.157627/0.001)) * (200-50) + 50; 
    origSize = size;
    id = id_;
    loc = new PVector(locx, locy, locz);
    vel = new PVector(x, y, z).mult(0.001);
    limit = new PVector(width * 3, height * 3, width + height * 5);
    acc = new PVector(-0.002, -0.002, -0.002);
    rot = new PVector(0, 0);
    rotShift = PVector.random2D().mult(0.2);
    c = color(r, g, b, alpha);
  }

  void run() {
    update();
    display();
    if(toFade == true){
    fadeOut(3);
    }
  }

  void update() {
    move();
    if (isFlashing) {
      flashing();
    }
    if (isSpinning) {
      spinning();
    }
  }

  void fadeOut(float fadeTime) {
    alpha -= 255/frameRate/fadeTime;
    if (alpha <= 0) {
      isDead = true;
    }
  }

  void display() {
    //pushMatrix();
    //noStroke();
    //fill(c, alpha);
    //translate(loc.x, loc.y, loc.z);
    //sphere(size);
    //popMatrix();
    pushMatrix();
    translate(loc.x,loc.y,loc.z);
    stroke(0,alpha);
    fill(c, alpha);
    rotateX(rot.x);
    rotateY(rot.y);
    rotateZ(rot.z);
    ellipse(0, 0, size, size);
    
    popMatrix();
  }

  void move() {
    vel.add(acc);
    loc.add(vel);
    if(abs(loc.x) >= limit.x) {
      vel.x = vel.x * -1.0;
      acc.x = 0.0;
    }
    if(abs(loc.y) >= limit.y) {
      vel.y = vel.y * -1.0;
      acc.y = 0.0;
    }
    if(abs(loc.z) >= limit.z) {
      vel.z = vel.z * -1.0;
      acc.z = 0.0;
    }
  }

  void flash() {
    isFlashing = true;
    size = size * 1.4;

    flashStartT = frameCount;
    flashDurFrames = flashDur * frameRate;
    delr = (255.0-red(c))/flashDurFrames;
    delg = (255.0-green(c))/flashDurFrames;
    delb = (255.0-blue(c))/flashDurFrames;
  }

  void flashing() {
    float n = frameCount-flashStartT;
    if (n < flashDurFrames) {
      c = color(255-(delr*n), 255-(delg*n), 255-(delb*n)); 
      size = constrain(size * 0.97, origSize, size * 1.4);
    }
    if (n >= flashDurFrames) {
      isFlashing = false;
      size = origSize;
    }
  }
  
  void spin() {
    isSpinning = true;

    spinStartT = frameCount;
    spinDurFrames = flashDur * frameRate;
  }

  void spinning() {
    float n = frameCount-spinStartT;
    if (n < spinDurFrames) {
      //c = color(255-(delr*n), 255-(delg*n), 255-(delb*n));
      rot.x = (rot.x + rotShift.x)%(2 * PI);
      rot.y = (rot.y + rotShift.y)%(2 * PI);
      //rot.z = (rot.z + 0.2)%(2 * PI);
      
    }
    if (n >= spinDurFrames) {
      isSpinning = false;
    }
  }
}