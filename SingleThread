int numNodes=5;
float m=50, r=10;
float k=100, kv=10, g=9.8;
float dt=0.01;
float threadAnchorX, threadAnchorY, threadSpace=100;
float restLen=50;
float ball1=150,ball2=200,ball3=250,ball4=300;
float ball1x=500,ball2x=500,ball3x=500,ball4x=500;
float vel1=0,vel2=0,vel3=0,vel4=0;
float vel1x=0,vel2x=0,vel3x=0,vel4x=0;

void setup(){
  size(1000,1000);
  threadAnchorY=height*0.1;
  threadAnchorX=width/2;
}
void update(){
  float sx1=ball1x-threadAnchorX;
  float sx2=ball2x-ball1x;
  float sx3=ball3x-ball2x;
  float sx4=ball4x-ball3x;
  
  float sy1=ball1-threadAnchorY;
  float sy2=ball2-ball1;
  float sy3=ball3-ball2;
  float sy4=ball4-ball3;
  
  float sl1=sqrt(sx1*sx1+sy1*sy1);
  float sl2=sqrt(sx2*sx2+sy2*sy2);
  float sl3=sqrt(sx3*sx3+sy3*sy3);
  float sl4=sqrt(sx4*sx4+sy4*sy4);
  
  float sf1=-k*(sl1-restLen);
  float sf2=-k*(sl2-restLen);
  float sf3=-k*(sl3-restLen);
  float sf4=-k*(sl4-restLen);
  
  float dx1=sx1/sl1;
  float dx2=sx2/sl2;
  float dx3=sx3/sl3;
  float dx4=sx4/sl4;
  
  float dy1=sy1/sl1;
  float dy2=sy2/sl2;
  float dy3=sy3/sl3;
  float dy4=sy4/sl4;
  
  float dampx1=-kv*(vel1x);
  float dampy1=-kv*(vel1);
  float dampx2=-kv*(vel2x-vel1x);
  float dampy2=-kv*(vel2-vel1);
  float dampx3=-kv*(vel3x-vel2x);
  float dampy3=-kv*(vel3-vel2);
  float dampx4=-kv*(vel4x-vel3x);
  float dampy4=-kv*(vel4-vel3);
  
  vel1+=(0.5*(sf1*dy1/m+dampy1/m-sf2*dy2/m-dampy2/m)+g)*dt;
  vel2+=(0.5*(sf2*dy2/m+dampy2/m-sf3*dy3/m-dampy3/m)+g)*dt;
  vel3+=(0.5*(sf3*dy3/m+dampy3/m-sf4*dy4/m-dampy4/m)+g)*dt;
  vel4+=(0.5*(sf4*dy4/m+dampy4/m)+g)*dt;
  
  ball1+=vel1*dt;
  ball2+=vel2*dt;
  ball3+=vel3*dt;
  ball4+=vel4*dt;
    
  vel1x+=0.5*(sf1*dx1+dampx1-sf2*dx2/m-dampx2/m)*dt;
  vel2x+=0.5*(sf2*dx2+dampx2-sf3*dx2/m-dampx3/m)*dt;
  vel3x+=0.5*(sf3*dx3+dampx3-sf4*dx2/m-dampx4/m)*dt;
  vel4x+=0.5*(sf4*dx4+dampx4)*dt;
  
  ball1x+=vel1x*dt;
  ball2x+=vel2x*dt;
  ball3x+=vel3x*dt;
  ball4x+=vel4x*dt;
  
  //print(ball1x,'\t',ball2x,'\t',ball3x,'\t',ball4x,'\n');
  //print(vel1x,'\t',vel2x,'\t',vel3x,'\t',vel4x,'\n');
  //print(sx1,'\t',sx2,'\t',sx3,'\t',sx4,'\n');

  if (keyPressed&&keyCode==RIGHT){
    vel1x+=10;
  }
  if (keyPressed&&keyCode==LEFT){
    vel1x-=10;
  }
}
void draw(){
  for (int i=0;i<3;i++){
    background(55,55);
    fill(255,255,255);
    ellipse(width/2,threadAnchorY,r,r);
    update();
    pushMatrix();
    line(width/2,threadAnchorY,ball1x,ball1);
    translate(ball1x,ball1);
    ellipse(0,0,r,r);
    popMatrix();
    
    pushMatrix();
    line(ball1x,ball1,ball2x,ball2);
    translate(ball2x,ball2);
    ellipse(0,0,r,r);
    popMatrix();
    
    pushMatrix();
    line(ball2x,ball2,ball3x,ball3);
    translate(ball3x,ball3);
    ellipse(0,0,r,r);
    popMatrix();  
    
    pushMatrix();
    line(ball3x,ball3,ball4x,ball4);
    translate(ball4x,ball4);
    ellipse(0,0,r,r);
    popMatrix();  
  }
}
