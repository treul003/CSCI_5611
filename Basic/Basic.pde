int numSamples=75; //num nodes not including corners/start/goal
PVector[] sample=new PVector[numSamples+6];
float[] visitedx=new float[2];
float[] visitedy=new float[2];
int numSides=25;
float ang;
float a=1, b, c, d, t;
PVector dir=new PVector(0,0);
PVector h=new PVector (0,0), cen=new PVector(300, 300);
float mu, del, tpos, tneg;
import peasy.*;
PeasyCam cam;
PImage img;
PShape ground;
float len,tempLen,lenGoal,tempGoal,tempLenSlope,lenSlope, dt=5;
float tempx, tempy;
boolean atGoal=false, visit=false;
int delete, numDel, n=0;
float vecLenS, vecLenUp;
PVector pos,p1,p2;

void update(){
  if (dt!=0){
    p1=new PVector(visitedx[n],visitedy[n]);
    p2=new PVector(visitedx[n+1],visitedy[n+1]);
    PVector direction=PVector.sub(p2,pos);
    vecLenS=sqrt(PVector.sub(p2,p1).dot(PVector.sub(p2,p1)));
    vecLenUp=sqrt(PVector.sub(pos,p1).dot(PVector.sub(pos,p1)));
    direction.div(sqrt(PVector.sub(p2,pos).dot(PVector.sub(p2,pos))));
    pos.add(direction.mult(dt));
    if(vecLenUp>vecLenS){
      pos.x=visitedx[n+1];
      pos.y=visitedy[n+1];
      n++;
    }
    if(pos.x==570){
      dt=0;
    }
  }
}

void display(){
  fill(255,0,0);
  pushMatrix();
  translate(pos.x,pos.y,0);
  drawCyl(numSides);
  popMatrix();
  pushMatrix();
  translate(0,0,-60);
  for (int i=0; i<visitedx.length-1; i++){
    stroke(2);
    fill(255,0,0);
    line(visitedx[i],visitedy[i],visitedx[i+1],visitedy[i+1]);
  }
  popMatrix();
}

void prm(){
  //starting point
  visitedx[0]=sample[0].x;
  visitedy[0]=sample[0].y;
  lenGoal=sqrt(PVector.sub(sample[1],sample[0]).dot(PVector.sub(sample[1],sample[0]))); //length from start to goal
  PVector lenPt=new PVector(0,0);//point of vector p1
  //check if point has been visited before
  //j = point on path
  //i = points to check to possibly be on path
  int j=0;
  while (atGoal==false){
    //check each sample
    len=10000; 
    lenSlope=10000;
    for (int i=0; i<numSamples; i++){
      //has sample been visited already?
      for (int k=0; k<visitedx.length-1; k++){
        if (sample[i].x==visitedx[k]){
          visit=true;
        }
      }
      //if not visited, then conduct calculations
      if (visit==false){
        //p1 assignment
        lenPt.x=visitedx[j];
        lenPt.y=visitedy[j];
        //test if potential point won't result in collision
        colTest(lenPt,sample[i]);
        if(Float.isNaN(tpos) || Float.isNaN(tneg) || (0<tpos && tpos<1) || (0<tneg && tneg<1)){
          //calculate distance from point 1 to point 2
          tempLen=sqrt(PVector.sub(sample[i],lenPt).dot(PVector.sub(sample[i],lenPt)));
          //calculate distance from point 2 to goal
          tempGoal=sqrt(PVector.sub(sample[1],sample[i]).dot(PVector.sub(sample[1],sample[i])));
          //use point only if moving towards goal **
          //calculate distance from point 2 to median
          tempx=(visitedy[j]-visitedx[j])/2+300;
          tempy=-tempx+600;
          tempLenSlope=sqrt(sq(visitedy[j]-tempx)+sq(visitedx[j]-tempy));
          if (tempLenSlope<lenSlope && tempGoal<lenGoal){
            //determine the closest point from point 1
            //make closest point onto chosen path sequence
            if (tempLen<len){
            //if (tempGoal<lenGoal){
              print(visitedx[j],'\t',visitedy[j],'\t');
              print(tempLen,'\t',len,'\t',tempLenSlope,'\t',lenSlope,'\t',j,'\n');
              len=tempLen;
              //lenSlope=tempLenSlope;
              visitedx[j+1]=sample[i].x;
              visitedy[j+1]=sample[i].y;
            }
          //}
          }
        }

      }
      //set lenGoal for new p1 to goal
      lenGoal=sqrt(PVector.sub(sample[1],new PVector(visitedx[j+1],visitedy[j+1])).dot(PVector.sub(sample[1],new PVector(visitedx[j+1],visitedy[j+1]))));
      lenSlope=sqrt(sq(visitedy[j]-(visitedy[j]-visitedx[j])/2+300)+sq(visitedx[j]+(visitedy[j]-visitedx[j])/2+300));
      //reset visit check for new sample
      visit=false;
      //determine if at goal
      if (visitedx[j]==570){
        atGoal=true;
        break;
      }
      else{
        visitedx=expand(visitedx,visitedx.length+1);
        visitedy=expand(visitedy,visitedy.length+1);
      }
    }
    j=j+1;
    if(atGoal==true){
      break;
    }
  }
  for (int i=0; i<visitedx.length-1; i++){
    if (visitedx[i]==0){
      delete=i;
      break;
    }
    fill(0,255,255);
    ellipse(visitedx[i],visitedy[i],30,30);
  }
  numDel=visitedx.length;
  //print(delete,'\t',visitedx.length,'\n');
  for (int i=0; i<(numDel-delete); i++){
    visitedx=shorten(visitedx);
    visitedy=shorten(visitedy);
  }
}

void colTest(PVector p1, PVector p2){
  PVector AC=new PVector(p1.x-cen.x,p1.y-cen.y);
  PVector BC=new PVector(p2.x-cen.x,p2.y-cen.y);
  a=sq(AC.x)+sq(AC.y)-sq(76);
  b=2*(AC.x*(BC.x-AC.x)+AC.y*(BC.y-AC.y));
  c=sq(BC.x-AC.x)+sq(BC.y-AC.y);
  d=sq(b)-4*a*c;
  tpos=(-b+sqrt(d))/(2*a);
  tneg=(-b-sqrt(d))/(2*a);
}

void drawLine(int i){
  pushMatrix();
  translate(0,0,-60);
  for (int j=0; j<numSamples+6; j++){
    colTest(sample[i],sample[j]);
    if(Float.isNaN(tpos) || Float.isNaN(tneg) || (0<tpos && tpos<1) || (0<tneg && tneg<1)){
      if(dt==0 && mousePressed==true){
        line(sample[i].x,sample[i].y,sample[j].x,sample[j].y);
      }
    }
  }
  popMatrix();
}

void genSamples(){
  //start
  sample[0]=new PVector(30,30*19);
  //goal
  sample[1]=new PVector(30*19,30);
  //corners
  sample[2]=new PVector(0,0);
  sample[3]=new PVector(0,600);
  sample[4]=new PVector(600,600);
  sample[5]=new PVector(600,0);
  //sample points
  for (int i=6; i<numSamples+6; i++){
    sample[i]=new PVector(random(16,574), random(16,574));
    if (sqrt(sq(sample[i].x-300)+sq(sample[i].y-300))<76){
      i--;
    }
  }
}

void setup(){
  size(600,600,P3D);
  genSamples();
  cam=new PeasyCam(this, 300, 300, 0, 600);  
  img=loadImage("ground.jpg");
  prm();
  pos=new PVector(visitedx[n],visitedy[n]);  
}

void draw(){
  background(255,255);
  drawStationary();
  pushMatrix();
  translate(0,0,-60);
  for (int i=0; i<numSamples; i++){
      fill(255,255,0);
      ellipse(sample[i].x,sample[i].y,8,8  );
  }
  popMatrix();
  for (int i=0; i<numSamples; i++){
    drawLine(i);
  }
  update();
  display();
  for (int i=0; i<visitedx.length; i++){
    tempx=(visitedy[i]-visitedx[i])/2+300;
    tempy=-tempx+600;
    //print(tempx,'\t',tempy,'\t',visitedx[i],'\t',visitedy[i],'\n');
    pushMatrix();
    translate(0,0,-60);
    //line(tempy,tempx,visitedx[i],visitedy[i]);
    popMatrix();
  }  
}
void drawStationary(){
  fill(255,255,255);
  pushMatrix();
  translate(0,0,-61);
  ground=createShape(RECT,0,0,600,600);
  ground.setTexture(img);
  shape(ground);
  popMatrix();  
  pushMatrix();
  translate(300,300,-60);
  sphere(60);
  popMatrix();
  fill(0,255,0);
  pushMatrix();
  translate(0,0,-60);
  ellipse(570,30,30,30);
  fill(255,0,0);
  ellipse(30,570,30,30);
  popMatrix();
}
void drawCyl(int numSides){
  ang=360/numSides;
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*15;
    float y=sin(radians(i*ang))*15;
    vertex(x,y,-60);
  }
  endShape(CLOSE);
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*15;
    float y=sin(radians(i*ang))*15;
    vertex(x,y,-1);
  }
  endShape(CLOSE);
  beginShape(TRIANGLE_STRIP);
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*15;
    float y=sin(radians(i*ang))*15;
    vertex(x,y,0);
    vertex(x,y,-60);
  }
  endShape(CLOSE);
}
