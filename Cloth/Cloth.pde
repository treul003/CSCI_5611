import peasy.*;
PeasyCam cam;
PFont font;
int numNodes=31;
float dt=0, numUpdate=100;
PVector g=new PVector(0,15,0);
float m=0.5, r=5, k=75000, kv=100, cd=5;
float tSpace=5, sTopX=500-tSpace*numNodes/2, sTopY=100, sTopZ=0;
float sLen, restLen=6;
float sfvert, dfvert, sfhorz, dfhorz, force;
float v1,v2;
PVector distance=new PVector(0,0,0), dir=new PVector (0,0,0);
Spring[][] cloth=new Spring[numNodes][numNodes];
PVector ball=new PVector(500,200,100), bounce;
float ballR=35, dBall=0.7, ballDist, X, Y, Z, bounceFactor;
PImage img;
PVector vair=new PVector(0,-10,0);
PVector vtri=new PVector(0,0,0);
float area, airDens=100, airCoef;
PVector a=new PVector(0,0,0), b=new PVector(0,0,0);
PVector normal=new PVector(0,0,0),fair = new PVector(0,0,0);
void setup(){
  size(1000,1000,P3D);
  frameRate(60);
  smooth();
  font=createFont("Arial Bold", 192);
  cam= new PeasyCam(this, width/2, height/6, 0, 400);
  img=loadImage("cloth.jpg");
  addNodes();
}

void draw(){
  lights();
  background(255,255,255);
  for (int i=0; i<numUpdate; i++){
    update();
  }
  displayBall();
  displayCloth();
  fill(0,0,0);
  text(frameRate,width/2,height*0.05);
}

void addNodes(){
  for (int i=0; i<numNodes; i++){
    for (int j=0; j<numNodes; j++){
      cloth[i][j]=new Spring(new PVector(sTopX+i*tSpace, sTopY, sTopZ+j*tSpace), new PVector(0,0,0));
    }
  }
}

void update(){
  //calculate/update velocities //<>//
  for (int i=0; i<numNodes; i++){
    for (int j=0; j<numNodes; j++){
      if (i!=numNodes-1){
        PVector.sub(cloth[i+1][j].pos,cloth[i][j].pos,distance);
        sLen=sqrt(distance.dot(distance));
        PVector.div(distance,sLen,dir);//dir=directional vector
        v1=dir.dot(cloth[i][j].vel);
        v2=dir.dot(cloth[i+1][j].vel);
        sfhorz=-k*(restLen-sLen);
        dfhorz=-kv*(v1-v2);        
        force=sfhorz/m+dfhorz/m;
        //drag
        if (j!=numNodes-1){
          a.sub(cloth[i][j].pos,cloth[i+1][j].pos,a);
          b.sub(cloth[i][j].pos,cloth[i][j+1].pos,b);
          normal=b.cross(a).div((b.cross(a).dot(b.cross(a))));
          area=(b.cross(a).dot(b.cross(a)))/2;
          vair.y=random(-50,-10);
          vtri.x=(cloth[i][j].vel.x+cloth[i+1][j].vel.x+cloth[i][j+1].vel.x)/3-vair.x;
          vtri.y=(cloth[i][j].vel.y+cloth[i+1][j].vel.y+cloth[i][j+1].vel.y)/3-vair.y;
          vtri.z=(cloth[i][j].vel.z+cloth[i+1][j].vel.z+cloth[i][j+1].vel.z)/3-vair.z;
          area=area*(vtri.dot(normal))/(vtri.dot(vtri));
          airCoef=-0.5*airDens*cd*area*(vtri.dot(vtri));
          fair=normal.mult(airCoef);
        }
        cloth[i][j].vel.add((PVector.mult(dir,force)).add(fair).mult(dt));
        cloth[i+1][j].vel.sub((PVector.mult(dir,force)).add(fair).mult(dt));
      }
      if (j!=numNodes-1){
        PVector.sub(cloth[i][j+1].pos,cloth[i][j].pos,distance);
        sLen=sqrt(distance.dot(distance));
        PVector.div(distance,sLen,dir);//dir = directional vector
        v1=dir.dot(cloth[i][j].vel);
        v2=dir.dot(cloth[i][j+1].vel);
        sfvert=-k*(restLen-sLen);
        dfvert=-kv*(v1-v2);
        force=sfvert/m+dfvert/m;
        cloth[i][j].vel.add(PVector.mult(dir,force).mult(dt));
        cloth[i][j+1].vel.sub(PVector.mult(dir,force).mult(dt));
      }
    }
  }
  //update positions
  for (int i=0; i<numNodes; i++){
    //cloth[i][0].vel.mult(0);
    for (int j=0; j<numNodes; j++){
      if (j!=0){
        cloth[i][j].vel.add(g);
      }
      //cloth[i][numNodes-1].vel.mult(0);
      
      //floor collision
      if (cloth[i][j].pos.y+cloth[i][j].vel.y*dt>300){
        cloth[i][j].vel.y*=-0.1;
      }  
      
      cloth[i][j].pos.add(cloth[i][j].vel.mult(dt));
    
    }
  }
  //collision detection
  for (int i=0; i < numNodes; i++){
    for (int j =0; j<numNodes; j++){
      X=cloth[i][j].pos.x-ball.x;
      Y=cloth[i][j].pos.y-ball.y;
      Z=cloth[i][j].pos.z-ball.z;      
      ballDist=sqrt(X*X+Y*Y+Z*Z);
      if (ballDist<ballR*1.1){
        bounce=new PVector(X,Y,Z);
        bounce.div(ballDist);
        bounceFactor=bounce.dot(cloth[i][j].vel);
        cloth[i][j].vel.sub(bounce,cloth[i][j].vel).mult(bounceFactor);
        cloth[i][j].pos.x+=(ballR*1.1-ballDist)*bounce.x;
        cloth[i][j].pos.y+=(ballR*1.1-ballDist)*bounce.y;
        cloth[i][j].pos.z+=(ballR*1.1-ballDist)*bounce.z;
      }
    }
  }
  
}
void check(){
  if(keyPressed && keyCode==LEFT){
    ball.x-=dBall;
  }
  if(keyPressed && keyCode==RIGHT){
    ball.x+=dBall;
  }
  if(keyPressed && keyCode==UP){
    ball.y-=dBall;
  }
  if(keyPressed && keyCode==DOWN){
    ball.y+=dBall;
  }  
  if(keyPressed && key=='-'){
    ball.z-=dBall;
  }
  if(keyPressed && key=='+'){
    ball.z+=dBall;
  }
  if(keyCode==' '){
    dt=0.002;
  }
}

void displayBall(){
  check();
  fill(170,204,255);
  noStroke();
  pushMatrix();
  translate(ball.x,ball.y,ball.z);
  sphere(ballR);
  popMatrix();
}

void displayCloth(){
  noStroke(); //<>//
  lights();
  textureMode(NORMAL);
  for (int i=0; i<numNodes-1; i++){
    beginShape(TRIANGLE_STRIP);
    texture(img);
    for (int j=0; j<numNodes; j++){
      float x=map(i, 0, numNodes-1, 0, 1);
      float y=map(j, 0, numNodes-1, 0, 1);
      vertex(cloth[i][j].pos.x,cloth[i][j].pos.y,cloth[i][j].pos.z,x,y);
      x=map(i+1, 0, numNodes-1, 0 ,1);
      vertex(cloth[i+1][j].pos.x,cloth[i+1][j].pos.y,cloth[i+1][j].pos.z,x,y);
    }
    endShape();
  }
}

class Spring{
  PVector pos;
  PVector vel;
  
  Spring(PVector position, PVector velocity){
    pos=position;
    vel=velocity;
  }
}
