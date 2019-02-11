import peasy.*;
PeasyCam cam;

ArrayList<Fire> embers;
int numEmbers=300;
float posx, posy, posz;
float accx, accy, accMag=-3;
int r=85; //size of spawn area
float r1=3, r2=r1+2; // size of particle variation

float orbitX, orbitY, orbitAngle=0, orbitR=1000, theta;
float jetSpeed=15, ratiox, ratioy;

PImage img, img2;
PShape planet, meteor;
PFont font;
void setup() {
  size(1000, 1000, P3D);
  noStroke();
  embers=new ArrayList<Fire>();
  embers.add(new Fire( posx, posy, posz));
  img = loadImage("planetTexture.jpg"); 
  img2 = loadImage("meteorTexture.jpg");
  cam=new PeasyCam(this, 0, 0, 0, 2000);
  frameRate(60);
  smooth();
  font = createFont("Arial Bold",192);
}

void draw() {
  background(55, 55, 55);
  orbitAngle+=0.005;
  
  beginShape();
  noStroke();
  pushMatrix();
  fill(255, 255, 255);
  translate(orbitX*.995, orbitY*.995, 0);
  meteor=createShape(SPHERE, 75);
  meteor.setTexture(img2);
  shape(meteor);
  popMatrix();
  endShape();

  beginShape();
  noStroke();
  pushMatrix();
  fill(255, 255, 255);
  //translate(width/2,height/2,0);
  rotateY(orbitAngle/2);
  planet=createShape(SPHERE, orbitR-300);
  planet.setTexture(img);
  shape(planet);
  popMatrix();
  endShape();
  addFlame();  
  fill(255,255,255);
  text(frameRate,800,-800);
}

void addFlame() {
    for (int j=0; j<numEmbers; j++) {
      randomPos(r);
      genEmb();
    }
    for (int i=embers.size()-1; i>=0; i--) {
      Fire f=embers.get(i);
      f.run();
      if (f.die()) {
        embers.remove(i);
      }
    }
}

void genEmb() {
  embers.add(new Fire(posx, posy, posz));
}

void randomPos(int r) {
  theta=random(2*PI);
  posz=random(r)*pow(-1,round(random(1)));
  posx=sqrt(pow(r,2)-pow(posz,2))*cos(theta);
  posy=sqrt(pow(r,2)-pow(posz,2))*sin(theta);
}  

class Fire {
  float x, y, z;
  float velx, vely, velz;
  float life=255;

  Fire(float X, float Y, float Z) {
    x=X;
    y=Y;
    z=Z;
  
    velx=random(jetSpeed,jetSpeed+5);
    vely=-random(jetSpeed,jetSpeed+5);
  }

  void run() {
    update();
    display();
  }

  void update() {
    orbitX=orbitR*cos(orbitAngle);
    orbitY=orbitR*sin(orbitAngle);
    accx=accMag*cos(orbitAngle);
    accy=accMag*sin(orbitAngle);    
    velx=jetSpeed*orbitY/orbitR+accx;
    vely=-jetSpeed*orbitX/orbitR+accy;
    x=x+velx+random(-7.5, 7.5);
    y=y+vely+random(-7.5, 7.5);
    z=z+velz+random(-7.5, 7.5);
    life-=random(4, 7);
    //print(velx, "\t", vely, '\n');
  }

  void makeTri(float r) {
    beginShape(TRIANGLES);
    vertex(-r,-r,-r);
    vertex(r,-r,-r);
    vertex(0,0,r);

    vertex(r,-r, -r);
    vertex(r, r, -r);
    vertex(0, 0, r);

    vertex( r, r, -r);
    vertex(-r, r, -r);
    vertex( 0, 0, r);

    vertex(-r, r, -r);
    vertex(-r, -r, -r);
    vertex( 0, 0, r);
    endShape();
  }
  void display() {
    noStroke();
    fill(255, life, 0, life);
    pushMatrix();
    translate(x+orbitX, y+orbitY, z);
    makeTri(random(r1, r2));
    point(0,0,0);
    popMatrix();
  }

  boolean die() {
    if (life<0) {
      return true;
    } else {
      return false;
    }
  }
}
