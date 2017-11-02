// Place student's code here
// Student's names: Dibyendu Mondal
// Date last edited:
/* Functionality provided (say what works):
Created the 4-arcs caplet
*/

vec[] b1(pt A, pt C, pt B, pt D, float a, float c, int num)
{
  vec[] normals = new vec[4];
  beginShape(); 
  stroke(#66A4E2);
  //fill(#CCCCCC);
  vec CB = V(C,B);
  vec T = R(U(A,B));
  float radius = (c*c - n2(CB))/(2 * dot(CB,T));
  vec BQ = T; BQ.scaleBy(radius);
  pt Q = P(B,BQ);
  float w = atan(radius/c);
  vec CM = R(U(C,Q),w).scaleBy(c);
  pt M = P(C,CM);
  vec QB = U(V(Q,B));
  vec QM = U(V(Q,M));
  float angle = angle(QB,QM)/2;
  float x0 = radius*tan(angle);
  pt X = P(B,R(QB).scaleBy(x0));                  // center of arc BM

  normals[0] = U(A,B);                              // normal at B
  normals[1] = U(X,M);                              // normal at M
  
  vec AD = V(A,D);
  T = R(U(C,D));
  radius = (a*a - n2(AD))/(2 * dot(AD,T));
  vec DP = T; DP.scaleBy(radius);
  pt P = P(D,DP);
  w = atan(radius/a);
  vec AO = R(U(A,P),w).scaleBy(a);
  pt O = P(A,AO);
  //drawCircleArcInHat(R,P,O);
  vec PD = U(V(P,D));
  vec PO = U(V(P,O));
  angle = angle(PD,PO)/2;
  float z = radius*tan(angle);
  pt Z = P(D,R(PD).scaleBy(z));                  // center of arc DO
  
  normals[2] = U(C,D);                              // normal at D
  normals[3] = U(Z,O);                              // normal at O
  
  stroke(#4C67E0);
  float a0 = angle(V(A,O),V(A,B)), da=a0/40;
  if (a0<0) {
    a0 = (TWO_PI)+a0;
    da = a0/60;
  }
  for (float x=0; x<=a0; x+=da) v(P(A,R(AO,x)));
  
  stroke(#23A356);
  drawCircleArcInHat(B,Q,M);
  
  stroke(#DB2967);
  float b = angle(V(C,M),V(C,D)), db=b/40;
  if (b<0) {
    b = (TWO_PI)+b;
    db = b/60;
  }
  for (float x=0; x<=b; x+=db) v(P(C,R(CM,x))); 
  
  stroke(#D8A338);
  drawCircleArcInHat(D,P,O);
  v(O);
  endShape();
  stroke(black);
  
  if(num == 0)
  {
    centers0.G[0] = A;
    centers0.G[1] = X;
    centers0.G[2] = C;
    centers0.G[3] = Z;
    
    control0.G[0] = B;
    control0.G[1] = M;
    control0.G[2] = D;
    control0.G[3] = O;
    
    for(int i = 0;i < 4;i++)
    {
      normals[i].showArrowAt(control0.G[i]);
    }
  }
  else
  {
    centers1.G[0] = A;
    centers1.G[1] = X;
    centers1.G[2] = C;
    centers1.G[3] = Z;
    
    control1.G[0] = B;
    control1.G[1] = M;
    control1.G[2] = D;
    control1.G[3] = O;
    
    for(int i = 0;i < 4;i++)
    {
      normals[i].showArrowAt(control1.G[i]);
    }
  }
  return normals;
}

vec[] b2(pt A, pt C, pt B, pt D, pt E, pt F, float a, float c, int num)
{  
  vec[] normals = new vec[6];
  
  beginShape();
  stroke(#66A4E2);
  fill(#EEEEEE);
  
  // BLUE ARC
  vec EB = V(E,B);
  vec T = R(U(A,B));
  float radius = (0 - n2(EB))/(2 * dot(EB,T));
  vec BQ = T; BQ.scaleBy(radius);
  pt Q = P(B,BQ);

  vec QB = U(V(Q,B));
  vec QE = U(V(Q,E));
  float angle = angle(QB,QE)/2;
  float x = radius*tan(angle);
  pt X = P(B,R(QB).scaleBy(x));                  // center of arc BE
  
  normals[0] = U(A,B);                              // normal at B
  normals[1] = U(X,E);                              // normal at E
  
  // GREEN ARC
  vec T2 = U(Q,E);
  vec CE = V(C,E);
  radius = (c*c - n2(CE))/(2 * dot(CE,T2));
  vec EQ = T2; EQ.scaleBy(radius);
  pt Q2 = P(E,EQ);
  float omega = atan(radius/c);
  vec CM = R(U(C,Q2),omega).scaleBy(c);
  pt M = P(C,CM);                                // other end of arc EM

  vec Q2E = U(V(Q2,E));
  vec Q2M = U(V(Q2,M));
  angle = angle(Q2E,Q2M)/2;
  float y = radius*tan(angle);
  pt Y = P(E,R(Q2E).scaleBy(y));                  // center of arc EM
  
  normals[2] = U(Y,M);                              // normal at M
  
  // ORANGE ARC
  vec FD = V(F,D);
  T = R(U(C,D));
  radius = (0 - n2(FD))/(2 * dot(FD,T));
  vec DP = T; DP.scaleBy(radius);
  pt P = P(D,DP);
  
  vec PD = U(V(P,D));
  vec PF = U(V(P,F));
  angle = angle(PD,PF)/2;
  float z = radius*tan(angle);
  pt Z = P(D,R(PD).scaleBy(z));                  // center of arc DF
  
  normals[3] = U(C,D);                              // normal at D
  normals[4] = U(Z,F);                              // normal at F
  
  // PURPLE ARC
  T2 = U(P,F);
  vec AF = V(A,F);
  radius = (a*a - n2(AF))/(2 * dot(AF,T2));
  vec FP = T2; FP.scaleBy(radius);
  pt P2 = P(F,FP);
  omega = atan(radius/a);
  vec AN = R(U(A,P2),omega).scaleBy(a);
  pt N = P(A,AN);                              // other end of arc FN

  vec P2F = U(V(P2,F));
  vec P2N = U(V(P2,N));
  angle = angle(P2F,P2N)/2;
  float w = radius*tan(angle);
  pt W = P(F,R(P2F).scaleBy(w));                // center of arc FN
  
  normals[5] = U(W,N);                              // normal at N
  
  stroke(#4C67E0);
  drawCircleArcInHat(B,Q,E);
  
  stroke(#23A356);
  drawCircleArcInHat(E,Q2,M);
  
  // RED ARC
  stroke(#DB2967);
  float b = angle(V(C,M),V(C,D)), db=b/40;
  if (b<0) {
    b = (TWO_PI)+b;
    db = b/60;
  }
  for (float i=0; i<=b; i+=db)
  {
    v(P(C,R(CM,i))); 
  }
  
  stroke(#D8A338);
  drawCircleArcInHat(D,P,F);
  
  stroke(#DA90F4);
  drawCircleArcInHat(F,P2,N);
  
  // YELLOW ARC
  stroke(#EEF74F);
  float a0 = angle(V(A,N),V(A,B)), da=a0/40;
  if (a0<0) {
    a0 = (TWO_PI)+a0;
    da = a0/60;
  }
  for (float i=0; i<=a0; i+=da)
  {
    v(P(A,R(AN,i)));
  }
  v(B);
  endShape();
  
  stroke(black);
  
  if(num == 0)
  {
    centers0.G[0] = A;
    centers0.G[1] = X;
    centers0.G[2] = Y;
    centers0.G[3] = C;
    centers0.G[4] = Z;
    centers0.G[5] = W;
    
    control0.G[0] = B;
    control0.G[1] = E;
    control0.G[2] = M;
    control0.G[3] = D;
    control0.G[4] = F;
    control0.G[5] = N;
    
    for(int i = 0;i < 6;i++)
    {
      normals[i].showArrowAt(control0.G[i]);
    }
  }
  else
  {
    centers1.G[0] = A;
    centers1.G[1] = X;
    centers1.G[2] = Y;
    centers1.G[3] = C;
    centers1.G[4] = Z;
    centers1.G[5] = W;
    
    control1.G[0] = B;
    control1.G[1] = E;
    control1.G[2] = M;
    control1.G[3] = D;
    control1.G[4] = F;
    control1.G[5] = N;
    
    for(int i = 0;i < 6;i++)
    {
      normals[i].showArrowAt(control1.G[i]);
    }
  }
  return normals;
}