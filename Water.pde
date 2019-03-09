import peasy.*;
PeasyCam cam;
PFont font;
int numCells=200, numUpdate=50;
float dx=900/numCells, dt=0.001, g=9.8, damp=1;
float h[]=new float[numCells];
float mh[]=new float[numCells];
float uh[]=new float[numCells];
float muh[]=new float[numCells];

void setup(){
  size(1000,1000,P3D);
  frameRate(60);
  smooth();
  setCells();
  font=createFont("ArialBold",192);
  cam= new PeasyCam(this, width/2, -300, 0, 1000);
}
void setCells(){
  for (int i=0; i<numCells; i++){
    h[i]=200;
    uh[i]=0;
  }
}

void update(){
  for (int i=0; i<numCells-1; i++){
    mh[i]=0.5*(h[i]+h[i+1])-0.5*dt*(uh[i]+uh[i+1])/dx;
    muh[i]=0.5*(uh[i]+uh[i+1])-0.5*dt*(sq(uh[i+1])/h[i+1]+0.5*g*sq(h[i+1])-sq(uh[i])/h[i]-0.5*g*sq(h[i]))/dx;
  }
  for (int i=0; i<numCells-2; i++){
    h[i+1]-=dt*(muh[i+1]-muh[i])/dx;
    uh[i+1]-=dt*(damp*uh[i+1]+sq(muh[i+1])/mh[i+1]+0.5*g*sq(mh[i+1])-sq(muh[i])/mh[i]-0.5*g*sq(mh[i]))/dx;
  }
  h[0]=h[1];
  h[numCells-1]=h[numCells-2];
  uh[0]=-uh[1];
  uh[numCells-1]=-uh[numCells-2];
}
void keyPressed(){
  if (keyCode==LEFT){
    for (int i=1; i<10; i++){
      h[i]+=10*(10-i);
    }
  }
  if(keyCode==RIGHT){
    for (int i=2; i<10; i++){
      h[numCells-i]+=10*(10-i);
    }    
  }
}
void draw(){
  background(155,155,155);
  for (int i=0; i<numUpdate; i++){
    update();
  }
  for (int i=0; i<numCells; i++){
    fill(105,55,255);
    quad(dx*i,0,dx*(i+1),0,dx*(i+1),-h[i],dx*i,-h[i]);
    
    pushMatrix();
    translate(0,0,-400);
    quad(dx*i,0,dx*(i+1),0,dx*(i+1),-h[i],dx*i,-h[i]);
    popMatrix();
    
    pushMatrix();
    rotateY(radians(90));
    quad(0,0,0,-h[0],400,-h[0],400,0);
    popMatrix();
    
    pushMatrix();
    translate(dx*(numCells-1),0,0);
    rotateY(radians(90));
    quad(0,0,0,-h[numCells-1],400,-h[numCells-1],400,0);
    popMatrix();
    
    pushMatrix();
    translate(0,-h[i],-400);
    rotateX(radians(90));
    rotateY(radians(180));
    rotateZ(radians(180));
    quad(dx*i,0,dx*(i+1),0,dx*(i+1),-400,dx*i,-400);
    popMatrix();
  }
  fill(0,0,0);
  text(frameRate,width/2,-500,500);
}
