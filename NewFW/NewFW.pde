float posx,posy,posz,vx,vy,vz,g=0.5;
float fwx,fwy,fwz;
float r=25,seedlife;
ArrayList<Seed> seeds;
ArrayList<FW> fw;
PImage img,img2,img3;
PShape ground;
int numFW=2000;
PFont font;
void setup(){
  size(1000,1000,P3D);
  seeds=new ArrayList<Seed>();
  seeds.add(new Seed(posx,posy,posz));
  fw=new ArrayList<FW>();
  fw.add(new FW(posx,posy,posz));
  img=loadImage("Grass.jpg");
  img2=loadImage("Fall.jpg");
  img3=loadImage("NightSky.jpg");
  frameRate(60);
  smooth();
  font = createFont("Arial Bold",192);  
}
void draw(){
  background(img3);
  makeCursor();  
  makeBG();
  setPos();
  genSeed();
  addSeed();
  explodeFW();
  fill(255,255,255);
  text(frameRate,width*0.8,height*0.2);  
}
void explodeFW(){
  for (int j=fw.size()-1; j>=0; j--){
    FW f=fw.get(j);
    f.run();
    if (f.die()){
      fw.remove(j);
    }
  }
}
void setPos(){
  posx=mouseX;
  posy=height-5;
  posz=2*(mouseY-height);
}
void genSeed(){
  if (keyCode==' '){
    keyCode=DOWN;
    seeds.add(new Seed(posx,posy,posz));
  }
}
void addFW(){
  for (int i=0; i<numFW; i++){
    fw.add(new FW(fwx,fwy,fwz));
  }
}
void addSeed(){
  for (int i=seeds.size()-1; i>=0; i--){
    Seed s=seeds.get(i);
    s.run();
    if(s.die()){
      fwx=s.x+s.inx;
      fwy=s.y+s.iny;
      fwz=s.z+s.inz;
      seeds.remove(i);
      addFW();
    }
  }
}
class FW{
  float fwlife=255;
  float x,y,z;
  float inx,iny,inz;
  float vx,vy,vz;
  float R,G,B;
  float theta;
  FW(float x, float y, float z){
    inx=x;
    iny=y;
    inz=z;
    theta=random(2*PI);
    vz=random(15)*pow(-1,round(random(1)));
    vx=sqrt(pow(random(15),2)-pow(vz,2))*cos(theta);
    vy=sqrt(pow(random(15),2)-pow(vz,2))*sin(theta);
    R=random(155,255);
    G=random(155,255);
    B=random(155,255);
    fwlife=255;
  }
  void run(){
    update();
    display();
  }
  void update(){
    vy+=g;
    x+=vx+random(-2,2);
    y+=vy+random(-2,2);
    z+=vz+random(-2,2);
    fwlife-=random(5,8);
  }
  void display(){
    pushMatrix();
    noStroke();
    fill(R,G,B,fwlife*pow(0,round(random(1))));
    translate(x+inx,y+iny,z+inz);
    box(10);
    popMatrix();
  }
  boolean die(){
    if (fwlife<0){
      return true;
    }else{
      return false;
    }
  }
}
class Seed{
  float seedlife=255;
  float x,y,z;
  float vx,vy,vz;
  float inx, iny, inz;
  Seed(float x, float y, float z){
    inx=x;
    iny=y;
    inz=z;
    vy=random(-40,-35);
    seedlife=255;
  }
  void run(){
    update();
    display();
  }
  void update(){
    vy+=g;
    x+=random(-2,2);
    y+=vy;
    z+=random(-2,2);
    seedlife-=random(2,5);
  }
  void display(){
    pushMatrix();    
    noStroke();
    fill(180,250,220,seedlife);
    translate(x+inx,y+iny,z+inz);
    box(10);
    popMatrix();
  }
  boolean die(){
    if (vy>=0){
      return true;
    }
    else{
      return false;
    }
  }
}
void makeCursor(){
  pushMatrix();
  stroke(2);
  translate(mouseX,height-5,2*(mouseY-height));
  rotateX(PI/2);
  fill(255,0,0);
  ellipse(0,0,r,r);
  popMatrix();
}
void makeBG(){
  pushMatrix();
  translate(-r,height,1000);
  rotateX(-PI/2);
  noStroke();
  fill(255,255,255);
  ground=createShape(RECT,-width/0.75,height,4000,2000);
  ground.setTexture(img2);
  shape(ground);
  beginShape();
  stroke(2);
  fill(255,255,255);
  ground=createShape(RECT,0,height,1000+2*r,2000+2*r);
  ground.setTexture(img);
  shape(ground);
  endShape();
  popMatrix();
}
