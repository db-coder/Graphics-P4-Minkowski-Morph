// LecturesInGraphics: vector interpolation
// Template for sketches
// Author: Jarek ROSSIGNAC
PImage DBPix; // picture of author's face, should be: data/pic.jpg in sketch folder

//**************************** global variables ****************************
pts P = new pts();
float t=0.0, f=0;
Boolean animate=false, linear=true, circular=true, beautiful=true, showFrames=false;
boolean b2=true, b3=true, b4=true;
float len=200; // length of arrows
int nP=120,nQ=120;
pts P0 = new pts();
pts Q0 = new pts();
float dt = 0.01;
int numArcs = 4;
vec[] Pnormals = new vec[numArcs];
vec[] Qnormals = new vec[numArcs];
pts control0 = new pts();
pts control1 = new pts();
pts centers0 = new pts();
pts centers1 = new pts();
pts QPcontrols = new pts();
pts PQcontrols = new pts();

pts Arc0 = new pts();
pts Arc1 = new pts();
pts newArc = new pts();

pts G0 = new pts();
pts G1 = new pts();
int nC, nR;
int S1=0,S2=0;

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(1600, 800, P2D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  DBPix = loadImage("data/Dibyendu.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare().resetOnCircle(12);
  P.loadPts("data/pts");
  
  P0.declare();
  Q0.declare();
  
  control0.declare().resetOnCircle(numArcs);
  control1.declare().resetOnCircle(numArcs);
  centers0.declare().resetOnCircle(numArcs);
  centers1.declare().resetOnCircle(numArcs);
  QPcontrols.declare().resetOnCircle(numArcs);
  PQcontrols.declare().resetOnCircle(numArcs);
  Arc0.declare().resetOnCircle(24);
  Arc1.declare().resetOnCircle(24);
  newArc.declare().resetOnCircle(24);
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); // start recording for PDF image capture

  
  if(animating) {t+=dt; if(t>=1 || t<=0) {dt=-dt;}}  // shange time during animation to go back & forth

  strokeWeight(2);
  pt S=P.G[0], E=P.G[1], L=P.G[2], R=P.G[3], A=P.G[4], B=P.G[5]; // named points defined for convenience
  pt S0=P.G[6], E0=P.G[7], L0=P.G[8], R0=P.G[9], A0=P.G[10], B0=P.G[11]; // named points defined for convenience
  //stroke(black); edge(S,L); edge(E,R);
  float s=d(S,L), e=d(E,R); // radii of control circles computed from distances
  float s0=d(S0,L0), e0=d(E0,R0); // radii of control circles computed from distances
  //CIRCLE Cs = C(S,s), Ce = C(E,e); // declares circles
  //stroke(dgreen); Cs.drawCirc(); stroke(red); Ce.drawCirc(); // draws both circles in green and red
 

  strokeWeight(5);
  if(b2)
    {
      if(numArcs == 4)
      {
        Pnormals = b1(S,E,L,R,s,e,0);
        Qnormals = b1(S0,E0,L0,R0,s0,e0,1);
      }
      else if(numArcs == 6)
      {
        Pnormals = b2(S,E,L,R,A,B,s,e,0);
        Qnormals = b2(S0,E0,L0,R0,A0,B0,s0,e0,1);
      }
    }
    
    if(animating)
      drawMyMorph(t); // draw morphing curve
    
    findSplit();

   stroke(black);   strokeWeight(1);

   if(b3)
     {
     fill(black); scribeHeader("t="+nf(t,1,2),2); noFill();
     // your code for part 4
      strokeWeight(3); stroke(blue); 
     //    drawCircleInHat(Mr,M,Ml);  
     }
   strokeWeight(1);
  
  //noFill(); stroke(black); P.draw(white); // paint empty disks around each control point
  //fill(black); label(S,V(-1,-2),"A"); label(E,V(-1,-2),"C"); label(L,V(-1,-2),"B"); label(R,V(-1,-2),"D"); label(A,V(-1,-2),"E"); label(B,V(-1,-2),"F"); noFill(); // fill them with labels
  //fill(black); label(S0,V(-1,-2),"A"); label(E0,V(-1,-2),"C"); label(L0,V(-1,-2),"B"); label(R0,V(-1,-2),"D"); label(A0,V(-1,-2),"E"); label(B0,V(-1,-2),"F"); noFill(); // fill them with labels
  
  if (showFrames) // show a series of 9 frames of the animation
  {                  
  float dtt=1.0/8;
  for (float tt=dtt; tt<1; tt+=dtt) drawMyMorph(tt);  // draw each frame using both colors
  }
    
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen

  fill(black); displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw()

void findSplit()
{
  int k =0;
  int[] count = new int[numArcs];
  for(int i = 0;i < numArcs;i++)
    count[i] = 0;
  
  for(int i = 0;i < numArcs;i++)
  {
    for(int j = 0;j < numArcs;j++)
    {
      if(Pnormals[i].angle() >= Qnormals[j].angle() && Pnormals[i].angle() < Qnormals[(j+1)%numArcs].angle())
      {
        QPcontrols.G[i] = P(centers1.G[(j+1)%numArcs],d(control1.G[(j+1)%numArcs],centers1.G[(j+1)%numArcs]),Pnormals[i]);
        // check if a split already exists between these arcs
        boolean flag = false;
        for(int z = 0; z < k;z+=3)
        {
          if((Arc1.G[z] == control1.G[j]) && (Arc1.G[z+5] == control1.G[(j+1)%numArcs]))
          {
            vec nor = U(Arc1.G[z+1],Arc1.G[z+2]);
            if(nor.angle() > Pnormals[i].angle())
            {
              Arc1.G[z] = QPcontrols.G[i];
              Arc1.G[k++] = control1.G[j];
              Arc1.G[k++] = centers1.G[(j+1)%numArcs];
              Arc1.G[k++] = QPcontrols.G[i];
              count[j]++;
            }
            else
            {
              Arc1.G[z+5] = QPcontrols.G[i];
              Arc1.G[k++] = QPcontrols.G[i];
              Arc1.G[k++] = centers1.G[(j+1)%numArcs];
              Arc1.G[k++] = control1.G[(j+1)%numArcs];
              count[j]++;
            }
            flag = true;
            break;
          }
        }
        if(!flag)
        {
          // storing the 2 arcs
          Arc1.G[k++] = control1.G[j];
          Arc1.G[k++] = centers1.G[(j+1)%numArcs];
          Arc1.G[k++] = QPcontrols.G[i];
          Arc1.G[k++] = QPcontrols.G[i];
          Arc1.G[k++] = centers1.G[(j+1)%numArcs];
          Arc1.G[k++] = control1.G[(j+1)%numArcs];
          
          count[j]++;
        }
        break;
      }
      else if(0 <= Qnormals[j].angle() && Qnormals[j].angle() <= PI && Qnormals[(j+1)%numArcs].angle() >= -PI && Qnormals[(j+1)%numArcs].angle() <= 0)
      {
        if((Pnormals[i].angle() >= Qnormals[j].angle() && Pnormals[i].angle() <= PI) || (Pnormals[i].angle() >= -PI && Pnormals[i].angle() <= Qnormals[(j+1)%numArcs].angle()))
        {
          QPcontrols.G[i] = P(centers1.G[(j+1)%numArcs],d(control1.G[(j+1)%numArcs],centers1.G[(j+1)%numArcs]),Pnormals[i]);
          boolean flag = false;
          for(int z = 0; z < k;z+=3)
          {
            if((Arc1.G[z] == control1.G[j]) && (Arc1.G[z+5] == control1.G[(j+1)%numArcs]))
            {
              vec nor = U(Arc1.G[z+1],Arc1.G[z+2]);
              if((nor.angle() > Pnormals[i].angle()) || (nor.angle() >= -PI && nor.angle() <= 0 && 0 <= Pnormals[i].angle() && Pnormals[i].angle() <= PI))
              {
                Arc1.G[z] = QPcontrols.G[i];
                Arc1.G[k++] = control1.G[j];
                Arc1.G[k++] = centers1.G[(j+1)%numArcs];
                Arc1.G[k++] = QPcontrols.G[i];
                count[j]++;
              }
              else
              {
                Arc1.G[z+5] = QPcontrols.G[i];
                Arc1.G[k++] = QPcontrols.G[i];
                Arc1.G[k++] = centers1.G[(j+1)%numArcs];
                Arc1.G[k++] = control1.G[(j+1)%numArcs];
                count[j]++;
              }
              flag = true;
              break;
            }
          }
          if(!flag)
          {
            // storing the 2 arcs
            Arc1.G[k++] = control1.G[j];
            Arc1.G[k++] = centers1.G[(j+1)%numArcs];
            Arc1.G[k++] = QPcontrols.G[i];
            Arc1.G[k++] = QPcontrols.G[i];
            Arc1.G[k++] = centers1.G[(j+1)%numArcs];
            Arc1.G[k++] = control1.G[(j+1)%numArcs];
            
            count[j]++;
          }
          break;
        }
      }
    }
  }
  for(int i = 0;i < numArcs;i++)
  {
    if(count[i] == 0)
    {
      Arc1.G[k++] = control1.G[i];
      Arc1.G[k++] = centers1.G[(i+1)%numArcs];
      Arc1.G[k++] = control1.G[(i+1)%numArcs];
    }
  }
  S2 = k;
  k = 0;
  for(int i = 0;i < numArcs;i++)
    count[i] = 0;
  for(int i = 0;i < numArcs;i++)
  {
    for(int j = 0;j < numArcs;j++)
    {
      if(Qnormals[i].angle() >= Pnormals[j].angle() && Qnormals[i].angle() < Pnormals[(j+1)%numArcs].angle())
      {
        PQcontrols.G[i] = P(centers0.G[(j+1)%numArcs],d(control0.G[j],centers0.G[(j+1)%numArcs]),U(Qnormals[i]));
        
        // check if a split already exists between these arcs
        boolean flag = false;
        for(int z = 0; z < k;z+=3)
        {
          if((Arc0.G[z] == control0.G[j]) && (Arc0.G[z+5] == control0.G[(j+1)%numArcs]))
          {
            vec nor = U(Arc0.G[z+1],Arc0.G[z+2]);
            if(nor.angle() > Qnormals[i].angle())
            {
              Arc0.G[z] = PQcontrols.G[i];
              Arc0.G[k++] = control0.G[j];
              Arc0.G[k++] = centers0.G[(j+1)%numArcs];
              Arc0.G[k++] = PQcontrols.G[i];
              count[j]++;
            }
            else
            {
              Arc0.G[z+5] = PQcontrols.G[i];
              Arc0.G[k++] = PQcontrols.G[i];
              Arc0.G[k++] = centers0.G[(j+1)%numArcs];
              Arc0.G[k++] = control0.G[(j+1)%numArcs];
              count[j]++;
            }
            flag = true;
            break;
          }
        }
        
        if(!flag)
        {
          // storing the 2 arcs
          Arc0.G[k++] = control0.G[j];
          Arc0.G[k++] = centers0.G[(j+1)%numArcs];
          Arc0.G[k++] = PQcontrols.G[i];
          Arc0.G[k++] = PQcontrols.G[i];
          Arc0.G[k++] = centers0.G[(j+1)%numArcs];
          Arc0.G[k++] = control0.G[(j+1)%numArcs];
          count[j]++;
        }
        break;
      }
      else if(0 <= Pnormals[j].angle() && Pnormals[j].angle() <= PI && Pnormals[(j+1)%numArcs].angle() >= -PI && Pnormals[(j+1)%numArcs].angle() <= 0)
      {
        if((Qnormals[i].angle() >= Pnormals[j].angle() && Qnormals[i].angle() <= PI) || (Qnormals[i].angle() >= -PI && Qnormals[i].angle() <= Pnormals[(j+1)%numArcs].angle()))
        {
          PQcontrols.G[i] = P(centers0.G[(j+1)%numArcs],d(control0.G[(j+1)%numArcs],centers0.G[(j+1)%numArcs]),Qnormals[i]);
          
          // check if a split already exists between these arcs
          boolean flag = false;
        for(int z = 0; z < k;z+=3)
        {
          if((Arc0.G[z] == control0.G[j]) && (Arc0.G[z+5] == control0.G[(j+1)%numArcs]))
          {
            vec nor = U(Arc0.G[z+1],Arc0.G[z+2]);
            if((nor.angle() > Qnormals[i].angle())  || (nor.angle() >= -PI && nor.angle() <= 0 && 0 <= Qnormals[i].angle() && Qnormals[i].angle() <= PI))
            {
              Arc0.G[z] = PQcontrols.G[i];
              Arc0.G[k++] = control0.G[j];
              Arc0.G[k++] = centers0.G[(j+1)%numArcs];
              Arc0.G[k++] = PQcontrols.G[i];
              count[j]++;
            }
            else
            {
              Arc0.G[z+5] = PQcontrols.G[i];
              Arc0.G[k++] = PQcontrols.G[i];
              Arc0.G[k++] = centers0.G[(j+1)%numArcs];
              Arc0.G[k++] = control0.G[(j+1)%numArcs];
              count[j]++;
            }
            flag = true;
            break;
          }
        }
        
        if(!flag)
        {
          // storing the 2 arcs
          Arc0.G[k++] = control0.G[j];
          Arc0.G[k++] = centers0.G[(j+1)%numArcs];
          Arc0.G[k++] = PQcontrols.G[i];
          Arc0.G[k++] = PQcontrols.G[i];
          Arc0.G[k++] = centers0.G[(j+1)%numArcs];
          Arc0.G[k++] = control0.G[(j+1)%numArcs];
          count[j]++;
        }
          break;
        }
      }
    }
  }
  for(int i = 0;i < numArcs;i++)
  {
    if(count[i] == 0)
    {
      Arc0.G[k++] = control0.G[i];
      Arc0.G[k++] = centers0.G[(i+1)%numArcs];
      Arc0.G[k++] = control0.G[(i+1)%numArcs];
    }
  }
  S1 = k;
  stroke(white);
  for(int i = 0;i < numArcs;i++)
  {
    Pnormals[i].showArrowAt(QPcontrols.G[i]);
    Qnormals[i].showArrowAt(PQcontrols.G[i]);
  }
}

void drawArc(int k)
{
  beginShape();
  float a0 = angle(V(newArc.G[k+1],newArc.G[k]),V(newArc.G[k+1],newArc.G[k+2])), da=a0/40;
  //if (a0<0) {
  //  a0 = (TWO_PI)+a0;
  //  da = a0/60;
  //}
  for (float x=0; x<=a0; x+=da) v(P(newArc.G[k+1],R(V(newArc.G[k+1],newArc.G[k]),x)));
  endShape();
}

void drawMyMorph(float t)
{
  stroke(blue);
  int k = 0;
  for(int i = 0;i < S1;i+=3)
  {
    vec normal0 = U(Arc0.G[i+1],Arc0.G[i]);
    for(int j = 0;j < S2;j+=3)
    {
      vec normal1 = U(Arc1.G[j+1],Arc1.G[j]); 
      if(abs(angle(normal0,normal1)) < 0.1)  // matching arc found
      {
        newArc.G[k] = L(Arc0.G[i],Arc1.G[j],t);
        newArc.G[k+1] = L(Arc0.G[i+1],Arc1.G[j+1],t);
        newArc.G[k+2] = L(Arc0.G[i+2],Arc1.G[j+2],t);
        drawArc(k);
        k= k+3;
        break;
      }
    }
  }
}

void drawMorph(float t) 
   {       
   int ne=0;
   stroke(green); // show green edges on morph
   for (int i=0; i<nP; i++) 
       for (int j=0; j<nQ; j++)  // for all vertex sequences A, B in P, for all vertices C, D, E in Q
           {  
           pt A = P0.G[i]; pt B = P0.G[in(i)]; pt C = Q0.G[jp(j)]; pt D = Q0.G[j]; pt E = Q0.G[jn(j)];  
           if (dot(A.vecTo(B).left(),D.vecTo(C)) > 0 && dot(A.vecTo(B).left(),D.vecTo(E)) > 0 && dot(C.vecTo(D).left(),D.vecTo(E)) > 0)                 
             {strokeWeight(3); ne++; morph(A,B,D,t);} // morph edge(A,B) of P with vertex D of Q
           if (dot(A.vecTo(B).left(),D.vecTo(C)) < 0 && dot(A.vecTo(B).left(),D.vecTo(E)) < 0 && dot(C.vecTo(D).left(),D.vecTo(E)) < 0)    
             {strokeWeight(1); ne++; morph(A,B,D,t);} 
           }
   stroke(red); 
   for (int i=0; i<nP; i++) 
       for (int j=0; j<nQ; j++) 
           {        // for all vertices A in Q, for all vertices D in P
           pt A = Q0.G[j]; pt B = Q0.G[jn(j)]; pt C = P0.G[ip(i)]; pt D = P0.G[i]; pt E = P0.G[in(i)];  // B=A.n; C=D.p; E=D.n;
           if (dot(A.vecTo(B).left(),D.vecTo(C)) > 0 && dot(A.vecTo(B).left(),D.vecTo(E)) > 0 && dot(C.vecTo(D).left(),D.vecTo(E)) > 0)                 
             {strokeWeight(3); ne++; morph(A,B,D,1-t); } //else  {stroke(orange); strokeWeight(1);}
             if (dot(A.vecTo(B).left(),D.vecTo(C)) < 0 && dot(A.vecTo(B).left(),D.vecTo(E)) < 0 && dot(C.vecTo(D).left(),D.vecTo(E)) < 0)    
             {stroke(red); strokeWeight(1); ne++; morph(A,B,D,1-t); } //else  {stroke(orange); strokeWeight(1);}
           }
    }

void morph(pt pA, pt pB, pt C, float t) // draws edge (A,B) scaled by t towards C
  {
  pt A=pA.make(); A.moveTowards(C,t); 
  pt B=pB.make(); B.moveTowards(C,t); 
  A.showLineTo(B);
  } 
  
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas and saves as .jpg image
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') {filming=!filming; } // filming on/off capture frames into folder FRAMES 
  if(key=='a') {animating=!animating; f=0; t=0;}  
  if(key=='m') {animating=!animating;}  
  if (key=='f') {showFrames=!showFrames; if(!showFrames) t=0.5;};    // reset time
  if(key=='s'){ control0.savePts("data/pts00"); centers0.savePts("data/pts01");}   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='Q') exit();  // quit application
  change=true; // to make sure that we save a movie frame each time something changes
  }

void mousePressed() {  // executed when the mouse is pressed
  P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') t+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
      if (key=='t') P.dragAll(); // move all vertices
      if (key=='r') P.rotateAllAroundCentroid(Mouse(),Pmouse()); // turn all vertices around their center of mass
      if (key=='z') P.scaleAllAroundCentroid(Mouse(),Pmouse()); // scale all vertices with respect to their center of mass
      }
  change=true;
  }  

//**************************************
//**** next and previous functions for polyloops P and Q
//**************************************
int in(int j) {  if (j==nP-1) {return (0);}  else {return(j+1);}  };  // next vertex in control loop
int ip(int j) {  if (j==0) {return (nP-1);}  else {return(j-1);}  };  // next vertex in control loop
int jn(int j) {  if (j==nQ-1) {return (0);}  else {return(j+1);}  };  // next vertex in control loop
int jp(int j) {  if (j==0) {return (nQ-1);}  else {return(j-1);}  };  // next vertex in control loop

//**************************** text for name, title and help  ****************************
String title ="6491 2017 P4: Minkowski Morph of SPCCs", 
       name ="Student: Dibyendu Mondal",
       menu="?:(show/hide) help, s/l:save/load control points, a: animate, `:snap picture, ~:(start/stop) recording movie frames, Q:quit",
       guide="click and drag to edit"; // help info


  
float timeWarp(float f) {return sq(sin(f*PI/2));}