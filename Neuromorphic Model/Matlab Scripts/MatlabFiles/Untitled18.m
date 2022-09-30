   

a=[0 0 1
    1 0 0
    0 1 0];

b=[1 -1 0
    1 1 0
    0 0 sqrt(2)];

c=[0.5 0 0
    0 0.9 0
    0 0 1.0];

d=[1 1 0
    -1 1 0
    0 0 sqrt(2)] ;
e=[0 1 0
    0 0 1
    1 0 0];
m =a*b*c*d*e*2/4 ;
%m=1





for i=1:10000
    
    LHsim = i ;
    LAsim = 500;
    LPsim = 500;
   

    LHnormal = [1;0;0];
    LAnormal = [0;1;0];
    LPnormal = [0;0;1];

   %LHnormal = [0;0;1];
  % LAnormal = [0.707; 0.707  ; 0];
   %LPnormal = [0.707 ;-0.707 ; 0];
    
  % ExpVector = eyeVector(1,i)*LHnormal+eyeVector(2,i)*LAnormal+eyeVector(3,i)*LPnormal;
%    ExpVector = ExpVector/norm(ExpVector);
    
   SimTot = LHsim+LPsim+LAsim;
    LHsim=LHsim/SimTot;
    LAsim=LAsim/SimTot;
    LPsim=LPsim/SimTot;
    
   SimVector = LAsim*LAnormal+LHsim*LHnormal+LPsim*LPnormal;
   SimVectorM=m*SimVector;
    SimVector = SimVector/norm(SimVector);
       SimVectorM = SimVectorM/norm(SimVectorM);

    error = dot(SimVector, LHnormal); error = acos(error); tableerror(i) =  error*(180/pi);
    error2 = dot(SimVectorM, LHnormal); error2 = acos(error2); tableerror2(i) =  error2*(180/pi);
    error3 = dot(SimVectorM, SimVector);error3 = acos(error3);tableerror3(i) =  error3*(180/pi);
    %error = acos(error);
    %error =  error*(180/pi)
    
end 
    figure
    plot(x,tableerror, 'r', x,tableerror2,'b',x, tableerror3,'k')

    
    
