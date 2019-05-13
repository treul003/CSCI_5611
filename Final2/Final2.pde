float posx,posy,posz,vx,vy,vz,g=.6;
float explosionx,explosiony,explosionz;
float r=50, rockLife;

ArrayList<Rocket> rockets;
ArrayList<Explode> explosion;

ArrayList<Ball> balls;
float strength=60;

PShape wall;
PImage img;

int score=0;
float accuracy=0;
float fired=0; float made=0;

int numExplode=2000;
float dtx=0.005;
float dty=0.005;
PFont font;

PVector ballHit=new PVector(0,0,0);
PVector rocketHit=new PVector(0,0,0);

float tarX;
float tarY;
float tarLife=255;
int hit=0; int hit0=0; int hit1=0; int hit2=0; int hit3=0; int hit4=0;
int check=0;
void setup(){
  size(1000,1000,P3D);
  img=loadImage("wall.jpg");
  setPos();
  rockets=new ArrayList<Rocket>();
  rockets.add(new Rocket(posx,posy,posz,-2*width,-2*height,1000));
  balls=new ArrayList<Ball>();
  balls.add(new Ball(posx,posy,posz,-2*width,-2*height,1000,strength));
  explosion=new ArrayList<Explode>();
  explosion.add(new Explode(posx,posy,posz));


  frameRate(60);
  smooth();
  font = createFont("Arial Bold",192);
}
void draw(){
  background(255,255,255);
  lights();  
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);  
  genRocket();
  addRocket();
  explosion();
  genBall();
  addBall();
  ground();
  targetMove();
  fill(255,255,255);
  text(frameRate,width*0.8,height*0.2);
  if(keyPressed && keyCode==UP){
    strength+=5;
    if(strength>=200){
      strength=200;
    }
  }
  if(keyPressed & keyCode==DOWN){
    strength-=5;
    if(strength==0){
      strength=5;
    }
  }
  if(keyPressed & keyCode==ENTER){
    score=0;
    made=0;
    fired=0;
    accuracy=0;
  }
  textSize(32);
  text("SCORE: "+score, width*0.4, height*0.9);
  if(fired>0){
    accuracy=made/fired*100;
  }
  text("ACCURACY:"+accuracy+"%", width*0.4, height*0.95);
  fill(0);
  text("PRESS ENTER TO RESET GAME", width*0.3, height*0.1);
  fill(0,255,0);
  rect(width/20,height/2,50,200);
  fill(255,255,255);
  textSize(16);
  text("BALL STRENGTH",width/30,height*0.49);
  rect(width/20,height/2,50,200-strength);
}
void explosion(){
  for (int j=explosion.size()-1; j>=0; j--){
    Explode f=explosion.get(j);
    f.run();
    if (f.die()){
      explosion.remove(j);
    }
  }
}
void setPos(){
  posx=width/2;
  posy=height/2;
  posz=-200;
}
void genRocket(){
  if (mousePressed && mouseButton==RIGHT){
    hit=0;
    hit0=0;
    hit1=0;
    hit2=0;
    hit3=0;
    hit4=0;
    fired+=1;
    mousePressed=false;
    rockets.add(new Rocket(posx,posy,posz,mouseX,mouseY,-700));
  }
}

void genBall(){
  if (mousePressed && mouseButton==LEFT){
    hit=0;
    hit0=0;
    hit1=0;
    hit2=0;
    hit3=0;
    hit4=0;
    fired+=1;
    mousePressed=false;
    balls.add(new Ball(posx,posy,posz,mouseX,mouseY,-700,strength));
  }
}

void addExplode(){
  for (int i=0; i<numExplode; i++){
    explosion.add(new Explode(explosionx,explosiony,explosionz));
  }
}
void addRocket(){
  for (int i=rockets.size()-1; i>=0; i--){
    Rocket s=rockets.get(i);
    s.run();
    if(s.die()){
      explosionx=s.x+s.inx;
      explosiony=s.y+s.iny;
      explosionz=s.z+s.inz;
      rockets.remove(i);
      addExplode();
    }
  }
}
void addBall(){
  for (int i=balls.size()-1; i>=0; i--){
    Ball s=balls.get(i);
    s.run();
    if(s.die()){
      balls.remove(i);
    }
  }
}
class Explode{
  float explosionlife=255;
  float x,y,z;
  float inx,iny,inz;
  float vx,vy,vz;
  float theta;
  float rand;
  Explode(float x, float y, float z){
    inx=x;
    iny=y;
    inz=z;
    theta=random(2*PI);
    vz=random(10);
    vx=sqrt(pow(random(10),2)-pow(vz,2))*cos(theta);
    vy=sqrt(pow(random(10),2)-pow(vz,2))*sin(theta);
    explosionlife=255;
  }
  void run(){
    update();
    display();
  }
  void update(){
    vy+=0;
    x+=vx+random(-2,2);
    y+=vy+random(-2,2);
    z+=vz+random(-2,2);
    explosionlife-=random(1,8);
  }
  void display(){
    pushMatrix();
    noStroke();
    rand=round(random(1));
    fill(255,explosionlife,0,explosionlife);
    translate(x+inx,y+iny,z+inz);
    box(10);
    popMatrix();
  }
  boolean die(){
    if (explosionlife<0){
      return true;
    }else{
      return false;
    }
  }
}
class Rocket{
  float rockLife=255;
  float x,y,z;
  float vx,vy,vz;
  float inx, iny, inz;
  Rocket(float x, float y, float z, float mousex, float mousey, float mousez){
    inx=x;
    iny=y;
    inz=z;
    vx=(mousex-inx);
    vy=(mousey-iny);
    vz=(mousez-inz);
    float dir=sqrt(sq(vx)+sq(vy)+sq(vz))/80;
    vx=vx/dir+random(-1,1);
    vy=vy/dir+random(-1,1);
    vz=vz/dir+random(-1,1);
    rockLife=255;
  }
  void run(){
    update();
    display();
  }
  void update(){
    vy+=0; 
    x+=vx;
    y+=vy;
    z+=vz;
    rockLife-=random(2,5);
  }
  void display(){
    pushMatrix();    
    fill(255,192,203);
    translate(x+inx,y+iny,z+inz);
    box(r);
    rotateY(PI/4);
    rotateX(PI/4);
    box(r);
    popMatrix();
  }
  boolean die(){
    if (z<(-2950+1.02*r+2*50) && y>-1.5*height){
      rocketHit=new PVector(x,y,z);
      return true;
    }
    else{
      return false;
    }
  }
}

class Ball{
  float ballLife=255;
  float x,y,z;
  float vx,vy,vz;
  float inx, iny, inz;
  Ball(float x, float y, float z, float mousex, float mousey, float mousez, float strength){
    inx=x;
    iny=y;
    inz=z;
    vx=(mousex-inx);
    vy=(mousey-iny);
    vz=(mousez-inz);
    float dir=sqrt(sq(vx)+sq(vy)+sq(vz))/strength;
    vx=vx/dir+random(-1,1);
    vy=vy/dir+random(-1,1);
    vz=vz/dir;
    ballLife=255;
  }
  void run(){
    update();
    display();
  }
  void update(){
    vy+=g; 
    x+=vx;
    y+=vy;
    z+=vz;
    if(vz<0){
      ballLife-=random(2,5);
    }
    if(y>(height-1.02*r)){
      vy*=-0.95;
    }
    if(z<(-2950+1.02*r+2*50) && y>-1.5*height){
      vz*=-0.95;
      ballHit=new PVector(x,y,z);
      tarLife=255;
    }
  }
  void display(){
    pushMatrix();    
    noStroke();
    fill(255,155,0);
    translate(x+inx,y+iny,z+inz);
    sphere(r);
    popMatrix();
  }
  boolean die(){
    if (ballLife<=0){
      return true;
    }
    else{
      return false;
    }
  }
}

void ground(){
  pushMatrix();
  stroke(0);
  translate(0,2*height,-700);
  rotateX(radians(270));
  fill(255,255,255);
  rect(-5*width,0,11*width,7*height);
  popMatrix();

  pushMatrix();
  translate(0,0,-3000);
  fill(210,105,30);
  wall=createShape(RECT,-5*width,-height,11*width,3*height);
  wall.setTexture(img);
  shape(wall);
  popMatrix();
}
void targetMove(){
  for (int i=4; i>=0; i--){
    pushMatrix();
    tarX=width/2+1000*cos(dtx);
    tarY=height/2+400*sin(dty);
    translate(tarX,tarY,-2975);
    float distB=sqrt(pow(ballHit.x-tarX,2)+pow(ballHit.y-tarY,2));
    float distR=sqrt(pow(rocketHit.x-tarX,2)+pow(rocketHit.y-tarY,2));

    //even red (255,0,0); odd white (255,255,255)
    //green (0,255,0)
    if(i==4){
      fill(255*(1-hit4),255*hit4,0);
      ellipse(0,0,200*5,200*5);
    }
    if(i==3){
      fill(255*(1-hit3),255,255*(1-hit3));
      ellipse(0,0,200*4,200*4);
    }
    if (i==2){
      fill(255*(1-hit2),255*hit2,0);
      ellipse(0,0,200*3,200*3);
    }
    if(i==1){
      fill(255*(1-hit1),255,255*(1-hit1));
      ellipse(0,0,200*2,200*2);
    }
    if(i==0){
      fill(255*(1-hit0),255*hit0,0);
      ellipse(0,0,200,200);
    }
    if(distB<700 && abs(ballHit.z+2975)<200 ){
      hit0=1;
      check=1;
    }
    if(distB>=700 && distB<800 && abs(ballHit.z+2975)<200){ 
      hit1=1;
      check=1;
    }
    if(distB>=800 && distB<900 && abs(ballHit.z+2975)<200){ 
      hit2=1;
      check=1;
    }
    if(distB>=900 && distB<1000 && abs(ballHit.z+2975)<200){ 
      hit3=1;
      check=1;
    }
    if(distB>=1000 && distB<1100 && abs(ballHit.z+2975)<200){ 
      hit4=1;
      check=1;
    }
    
    if(distR<700 && abs(rocketHit.z+2975)<200 ){
      hit0=1;
      check=1;
    }
    if(distR>=700 && distR<800 && abs(rocketHit.z+2975)<200){ 
      hit1=1;
      check=1;
    }
    if(distR>=800 && distR<900 && abs(rocketHit.z+2975)<200){ 
      hit2=1;
      check=1;
    }
    if(distR>=900 && distR<1000 && abs(rocketHit.z+2975)<200){ 
      hit3=1;
      check=1;
    }
    if(distR>=1000 && distR<1100 && abs(rocketHit.z+2975)<200){ 
      hit4=1;
      check=1;
    }
    popMatrix();
  }
  if(hit4==1 && check==1){
    score+=50;
    made+=1;
    check=0;
  }
  if(hit3==1 && check==1){
    score+=100;
    made+=1;
    check=0;
  }
  if(hit2==1 && check==1){
    score+=250;
    made+=1;
    check=0;
  }
  if(hit1==1 && check==1){
    score+=500;
    made+=1;
    check=0;
  }
  if(hit0==1 && check==1){
    score+=1000;
    made+=1;
    check=0;
  }
  ballHit=new PVector(0,0,0);
  rocketHit=new PVector(0,0,0);
  dtx+=0.05;
  dty+=0.01;
}
