import peasy.*;
PeasyCam cam;
import java.util.Map;
int numSamples=500;
float ang;
PVector[] obsposit=new PVector[9];
PVector[] posit=new PVector[8];
PVector[] end=new PVector[8];
PVector[] colour=new PVector[8];
int agR=40; //agent radius
int obR=50; //obstacle diameter
PVector direction;
float[] dt=new float[8];
ArrayList<Node> graphNode1=new ArrayList<Node>(), graphNode2=new ArrayList<Node>();
ArrayList<Node> graphNode5=new ArrayList<Node>(), graphNode6=new ArrayList<Node>();
ArrayList<Node> result1=new ArrayList<Node>(), result2=new ArrayList<Node>();
ArrayList<Node> result5=new ArrayList<Node>(), result6=new ArrayList<Node>();
Node start1, start2, start5, start6;
Node goal1, goal2, goal5, goal6;
PVector p1, p2;
int[] n=new int[8];
float vecLenS, vecLenUp;
float time=5;
boolean run1=true, run2=true, run5=true, run6=true;

void update(){
  PVector[] pathway1=new PVector[result1.size()+1];
  PVector[] pathway2=new PVector[result2.size()+1];
  PVector[] pathway5=new PVector[result5.size()+1];
  PVector[] pathway6=new PVector[result6.size()+1];
  pathway1[result1.size()]=end[1];
  pathway2[result2.size()]=end[2];
  pathway5[result5.size()]=end[5];
  pathway6[result6.size()]=end[6];
  for (int i=0; i<result1.size(); i++){
    pathway1[i]=result1.get(result1.size()-1-i).pos;
  }
  for (int i=0; i<result2.size(); i++){
    pathway2[i]=result2.get(result2.size()-1-i).pos;
  }
  for (int i=0; i<result5.size(); i++){
    pathway5[i]=result5.get(result5.size()-1-i).pos;
  }
  for (int i=0; i<result6.size(); i++){
    pathway6[i]=result6.get(result6.size()-1-i).pos;
  }
  if(run1==true){
  p1=pathway1[n[1]];//point 1
  p2=pathway1[n[1]+1];//travel to point 2
  direction=PVector.sub(p2,posit[1]);//direction from p1 to p2
  vecLenS=sqrt(PVector.sub(p2,p1).dot(PVector.sub(p2,p1)));//length from p1 to p2
  vecLenUp=sqrt(PVector.sub(posit[1],p1).dot(PVector.sub(posit[1],p1)));//length from p1 to current position
  direction.div(sqrt(PVector.sub(p2,posit[1]).dot(PVector.sub(p2,posit[1]))));
  posit[1].add(direction.mult(dt[1]));
  if(vecLenUp>vecLenS){
    posit[1]=pathway1[n[1]+1];
    n[1]=n[1]+1;
  }
  if(sqrt(sq(posit[1].x-end[1].x)+sq(posit[1].y-end[1].y))<2){
    dt[1]=0;
    run1=false;
  }
  }
  if(run2==true){
  p1=pathway2[n[2]];//point 1
  p2=pathway2[n[2]+1];//travel to point 2
  direction=PVector.sub(p2,posit[2]);//direction from p1 to p2
  vecLenS=sqrt(PVector.sub(p2,p1).dot(PVector.sub(p2,p1)));//length from p1 to p2
  vecLenUp=sqrt(PVector.sub(posit[2],p1).dot(PVector.sub(posit[2],p1)));//length from p1 to current position
  direction.div(sqrt(PVector.sub(p2,posit[2]).dot(PVector.sub(p2,posit[2]))));
  posit[2].add(direction.mult(dt[2]));
  if(vecLenUp>vecLenS){
    posit[2]=pathway2[n[2]+1];
    n[2]=n[2]+1;
  }
  if(sqrt(sq(posit[2].x-end[2].x)+sq(posit[2].y-end[2].y))<2){
    dt[2]=0;
    run2=false;
  }
  }

  if (run5==true){
  p1=pathway5[n[5]];//point 1
  p2=pathway5[n[5]+1];//travel to point 2
  direction=PVector.sub(p2,posit[5]);//direction from p1 to p2
  vecLenS=sqrt(PVector.sub(p2,p1).dot(PVector.sub(p2,p1)));//length from p1 to p2
  vecLenUp=sqrt(PVector.sub(posit[5],p1).dot(PVector.sub(posit[5],p1)));//length from p1 to current position
  direction.div(sqrt(PVector.sub(p2,posit[5]).dot(PVector.sub(p2,posit[5]))));
  posit[5].add(direction.mult(dt[5]));
  if(vecLenUp>vecLenS){
    posit[5]=pathway5[n[5]+1];
    n[5]=n[5]+1;
  }
  if(sqrt(sq(posit[5].x-end[5].x)+sq(posit[5].y-end[5].y))<2){
    dt[5]=0;
    run5=false;
  }
  }  
  if (run6==true){
  p1=pathway6[n[6]];//point 1
  p2=pathway6[n[6]+1];//travel to point 2
  direction=PVector.sub(p2,posit[6]);//direction from p1 to p2
  vecLenS=sqrt(PVector.sub(p2,p1).dot(PVector.sub(p2,p1)));//length from p1 to p2
  vecLenUp=sqrt(PVector.sub(posit[6],p1).dot(PVector.sub(posit[6],p1)));//length from p1 to current position
  direction.div(sqrt(PVector.sub(p2,posit[6]).dot(PVector.sub(p2,posit[6]))));
  posit[6].add(direction.mult(dt[6]));
  if(vecLenUp>vecLenS){
    posit[6]=pathway6[n[6]+1];
    n[6]=n[6]+1;
  }
  if(sqrt(sq(posit[6].x-end[6].x)+sq(posit[6].y-end[6].y))<2){
    dt[6]=0;
    run6=false;
  }
  }

}
void display(){
  for (int i=0; i<8; i++){
    if(i==1 || i==2 || i==5 || i==6){
      pushMatrix();
      translate(posit[i].x,posit[i].y,posit[i].z);
      fill(colour[i].x,colour[i].y,colour[i].z);
      drawCyl(25);
      popMatrix();
    }
  }
}
void displayObs(){
  int k=0;
  stroke(0);
  //display obstacles
  for(int i=1; i<=3; i++){
    for (int j=1; j<=3; j++){
      fill(255,255,255);
      ellipse(obsposit[k].x,obsposit[k].y,obR,obR);
      k++;
    }
  }
  //display goal circles
  for (int i=0; i<8; i++){
    if(i==1 || i==2 || i==5 || i==6){
      pushMatrix();
      translate(end[7-i].x,end[7-i].y,end[7-i].z);
      fill(colour[7-i].x,colour[7-i].y,colour[7-i].z);
      ellipse(0,0,agR+20,agR+20);
      popMatrix();
    }
  }
}
void drawCyl(int numSides){
  ang=360/numSides;
  stroke(0);
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*agR/2;
    float y=sin(radians(i*ang))*agR/2;
    vertex(x,y,1);
  }
  endShape(CLOSE);
  beginShape();
  for (int i=0; i<numSides; i++){
    float x=cos(radians(i*ang))*agR/2;
    float y=sin(radians(i*ang))*agR/2;
    vertex(x,y,60);
  }
  endShape(CLOSE);
  beginShape(TRIANGLE_STRIP);
  for (int i=0; i<numSides+2; i++){
    float x=cos(radians(i*ang))*agR/2;
    float y=sin(radians(i*ang))*agR/2;
    vertex(x,y,60);
    vertex(x,y,1);
  }
  endShape(CLOSE);
}
void setup(){
  size(600,600,P3D);
  cam=new PeasyCam(this, 300, 300, 0, 600);
  for (int i=0; i<8; i++){
    n[i]=1;
    dt[i]=time;
  }
  //colors for agents and goals
  colour[0]=new PVector(255,0,0);
  colour[1]=new PVector(255,127,0);
  colour[2]=new PVector(255,255,0);
  colour[3]=new PVector(191,255,0);
  colour[4]=new PVector(0,255,0);
  colour[5]=new PVector(0,255,255);
  colour[6]=new PVector(0,0,255);
  colour[7]=new PVector(139,0,255);

  //assign positions
  for(int i=0; i<4; i++){
    posit[i]=new PVector(70+460/3*i,70);
  }
  for(int i=4; i<8; i++){
    posit[i]=new PVector(530-460/3*(i-4),530);
  }
  end[0]=new PVector(7*75,3*75);
  end[1]=new PVector(7*75,5*75);
  end[2]=new PVector(5*75,7*75);
  end[3]=new PVector(3*75,7*75);
  end[4]=new PVector(1*75,5*75);
  end[5]=new PVector(1*75,3*75);
  end[6]=new PVector(3*75,1*75);
  end[7]=new PVector(5*75,1*75);
  //make obstacles
  int k=0;
  for (int i=1; i<=3; i++){
    for (int j=1; j<=3; j++){
      obsposit[k]=new PVector(150*i,150*j,0);
      k++;
    }
  }
  
  //generate sample nodes
  start1=new Node(new PVector(posit[1].x,posit[1].y));
  start2=new Node(new PVector(posit[2].x,posit[2].y));
  start5=new Node(new PVector(posit[5].x,posit[5].y));
  start6=new Node(new PVector(posit[6].x,posit[6].y));
  graphNode1.add(start1);
  graphNode2.add(start2);
  graphNode5.add(start5);
  graphNode6.add(start6);
  goal1=new Node(new PVector(end[1].x,end[1].y));
  goal2=new Node(new PVector(end[2].x,end[2].y));
  goal5=new Node(new PVector(end[5].x,end[5].y));
  goal6=new Node(new PVector(end[6].x,end[6].y));
  graphNode1.add(goal1);
  graphNode2.add(goal2);
  graphNode5.add(goal5);
  graphNode6.add(goal6);
  
  int n=0;
  while (n<numSamples){
    float x=random(600);
    float y=random(600);
    boolean in=false;
    //collision detection
    for (int i=0; i<9; i++){
      float dist=getDist(x, y, obsposit[i].x, obsposit[i].y); 
      if(dist<obR+0.5*agR){  
        in=true;
      }
    }
    if (in==false){
    graphNode1.add(new Node(new PVector(x,y)));
    graphNode2.add(new Node(new PVector(x,y)));
    graphNode5.add(new Node(new PVector(x,y)));
    graphNode6.add(new Node(new PVector(x,y)));
    n++;
    }
  }
}

void draw() {
  background(255,255,255);
  displayObs();
  
  //make node connections
  for(int i=0; i<numSamples; i++){
    for(int j=0; j< numSamples; j++){
      Node a1=graphNode1.get(i), a2=graphNode2.get(i); 
      Node a5=graphNode5.get(i), a6=graphNode6.get(i); 
      Node b1=graphNode1.get(j), b2=graphNode2.get(j);
      Node b5=graphNode5.get(j), b6=graphNode6.get(j);
      float dist1=getDist(a1.pos.x, a1.pos.y, b1.pos.x, b1.pos.y);
      float dist2=getDist(a2.pos.x, a2.pos.y, b2.pos.x, b2.pos.y);
      float dist5=getDist(a5.pos.x, a5.pos.y, b5.pos.x, b5.pos.y);
      float dist6=getDist(a6.pos.x, a6.pos.y, b6.pos.x, b6.pos.y);
      if (dist1<obR+agR && i!=j){
        stroke(126);
        a1.addEdge(b1);
      }
      if (dist2<obR+agR && i!=j){
        stroke(126);
        a2.addEdge(b2);
      }
      if (dist5<obR+agR && i!=j){
        stroke(126);
        a5.addEdge(b5);
      }
      if (dist6<obR+agR && i!=j){
        stroke(126);
        a6.addEdge(b6);
      }
    }
  }
  for (int i=0; i<8; i++){
    Path a1=new Path(graphNode1), a2=new Path(graphNode2);
    Path a5=new Path(graphNode5), a6=new Path(graphNode6);
    result1=a1.path(start1, goal1);
    result2=a2.path(start2, goal2);
    result5=a5.path(start5, goal5);
    result6=a6.path(start6, goal6);

    if(result1!=null){
      displayResult(result1,1);
    }
    if(result2!=null){
      displayResult(result2,2);
    }    
    if(result5!=null){
      displayResult(result5,5);
    }    
    if(result6!=null){
      displayResult(result6,6);
    }      
  }
  update();
  display();
}

void displayResult(ArrayList<Node> result, int j){
  for(int i=0; i<result1.size(); i++){
      result1.get(i).showPath(colour[1]);
  }
  for(int i=0; i<result2.size(); i++){
      result2.get(i).showPath(colour[2]);
  }
  for(int i=0; i<result5.size(); i++){
      result5.get(i).showPath(colour[5]);
  }
  for(int i=0; i<result6.size(); i++){
      result6.get(i).showPath(colour[6]);
  }
  goal1.showPath(colour[1]);
  goal2.showPath(colour[2]);
  goal5.showPath(colour[5]);
  goal6.showPath(colour[6]);
}

float getDist(float x1, float y1, float x2, float y2){
  float dist=sqrt(sq(x1-x2)+sq(y1-y2));
  return dist;
}

class Path{
  ArrayList<Node> graph;
  ArrayList<Node> open;
  ArrayList<Node> close;
  HashMap<Node,Integer> gscore;
  HashMap<Node,Integer> fscore;
  
  Path(ArrayList<Node> node){
    graph=node;
  }
  
  int getLowestFscore(ArrayList<Node>  openList){
    int minfs=fscore.get(openList.get(0));
    int minIndex=0;
    for(int i=0; i<openList.size(); i++){
      Node temp=openList.get(i);
      int fs=fscore.get(temp);
      if(fs<minfs){
        minfs=fs;
        minIndex=i;
      }
    }
    return minIndex;
  }
  
  float heuristic_cost_estimate(Node start, Node goal){
    float a=start.pos.x-goal.pos.x;
    float b=start.pos.y-goal.pos.y;
    return sqrt(a*a+b*b);
  }
  
  boolean equals(Node a, Node b){
    int aIndex=graph.indexOf(a);
    int bIndex=graph.indexOf(b);
    return( aIndex==bIndex);
  }
  
  ArrayList<Node> reconstructPath(ArrayList<Node>  camefrom, Node current){
    ArrayList<Node> totalPath=new ArrayList<Node>();
    while(current.parent!=null){
      //Node previous=current;
      int currentIndex=camefrom.indexOf(current);
      current=camefrom.get(currentIndex).parent;
      totalPath.add(current);
    }
    return totalPath;
  }
  float distBetween(Node start, Node next){
    float a=start.pos.x-next.pos.x;
    float b=start.pos.y-next.pos.y;
    float dist=sqrt(a*a+b*b);
    return dist;
  }
  ArrayList<Node> path(Node start, Node goal){
    close=new ArrayList<Node> ();
    open=new ArrayList<Node> ();
    open.add(start);
    ArrayList<Node>  cameFrom=new ArrayList<Node> ();
    gscore=new HashMap<Node,Integer>();
    for(int i=0; i< graph.size(); i++){
      Node v=graph.get(i);
      gscore.put(v, Integer.MAX_VALUE);
    }
    gscore.put(start, 0);
    fscore=new HashMap<Node,Integer>();
    for(int i=0; i< graph.size(); i++){
      Node v=graph.get(i);
      fscore.put(v, Integer.MAX_VALUE);
    }
    fscore.put(start,(int)heuristic_cost_estimate(start,goal));
    while (open.size()>0){
      int lowestFscoreIndex=getLowestFscore(open);
      Node current=open.get(lowestFscoreIndex);
      if(equals(current, goal)){
        return reconstructPath(cameFrom, goal);
      }
      open.remove(lowestFscoreIndex);
      close.add(current);
      for(int i=0; i< current.edge.size(); i++){
        Node neighbor=current.edge.get(i);
        if(close.contains(neighbor)){
          continue;
        }
        int tenetiveGScore=gscore.get(current)+(int)distBetween(current, neighbor);
        if(!(open.contains(neighbor))){
          open.add(neighbor);
        }else if (tenetiveGScore>=gscore.get(neighbor)){
          continue;
        }
         neighbor.parent=current;
         cameFrom.add(neighbor);
        gscore.put(neighbor, tenetiveGScore);
        int estimatedFScore=gscore.get(neighbor) +(int) heuristic_cost_estimate(neighbor, goal);
        fscore.put(neighbor, estimatedFScore);
      }
    }
    return null;
  }
}

class Node{
 PVector pos;
 Node parent=null;
 ArrayList<Node> edge=new ArrayList<Node>();
 Node(PVector loc){
   pos=loc;
 }
  void addEdge(Node e){
    for (Node temp: edge) {
      if (temp==e) {
        return;
      }
    }
    edge.add(e);
  }
  void changeColor(PVector c){
    fill(c.x,c.y,c.z);
    //ellipse(pos.x, pos.y, 20, 20);
  }
  void showPath(PVector c){
    fill(c.x,c.y,c.z);
    //ellipse(pos.x, pos.y, 15, 15);
  }
}
