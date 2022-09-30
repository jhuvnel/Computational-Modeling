
function [rotZ3] =  rotZ3(a)
rotZ3= [cos(a) sin(-a)  0;
       sin(a) cos(a)   0;
       0        0      1];
  return 
   
function [rotY3] =  rotY3(a)
rotY3= [cos(a)  0  sin(a);
         0      1   0;
        -sin(a) 0   cos(a)];
   return
   
function [rotX3] =  rotX3(a)
rotX3= [1       0        0;
       0      cos(a)  -sin(a);
       0      sin(a)  cos(a)];
   return
   
   
function [rotZ4] =  rotZ4(a)
rotZ4= [cos(a) sin(-a)  0     0;
       sin(a)  cos(a)   0      0;
       0        0       1      0;
       0        0       0     1];
  return 
   
function [rotY4] =  rotY4(a)
rotY4= [cos(a)   0  sin(a)    0;
         0      1       0      0;
       -sin(a)   0   cos(a)     0;
 v      0        0       0       1];
   return
   
function [rotX4] =  rotX4(a)
rotX4= [1       0        0      0;
       0      cos(a)  -sin(a)  0;
       0      sin(a)  cos(a)    0;
       0        0       0       1];
   return
   
function [transl] =  transl(x,y,z)
transl= [1   0   0   x;
        0   1   0   y;
        0   0   1   z;
        0   0   0   1];
   return
   
   
function q =  quatquat (q1,q2)
q=xxxxxxxxxxxxxxx; %vvvvvvvvvvvv



function q=  FickToQ (ax, ay, az)
%cvvvvvvvvvvvvvvvv



function RFick=  RFick (ax,ay,az) 
%Spce-fixed Fick matrix from angles
RFick=rotZ3(az)*rotY3(ay)*rotX3(ax);
return

function [ax ay az] =  ExtractFickAngles (RFick)
ay=asin(-RFick(3:1));
[ax az] =asin([RFick(2:1) RFick(3:2)]./cos(ay));
return

function rVector =  rV(RFick)
rVector = [RFick(3,2)-RFick(2,3);  RFick(1,3)-RFick(3,1);  RFick(2,1)-RFick(1,2)]./(1+trace(RFick));
return

function [q0 qx qy qz] =  quat_Fick(R)
q0=sqrt(1+trace(R))/2;
qx=(RFick(3,2)-RFick(2,3))/(4*q0);
qy=(RFick(1,3)-RFick(3,1))/(4*q0);
qz=(RFick(2,1)-RFick(1,2))/(4*q0);
return

function [q0 qx qy qz] =  quat_rV(rV)
q0=cos(atan(rV'*rV));
qx=rV(1)*q0;
qy=rV(2)*q0;
qz=rV(3)*q0;
return

function rVector =  rV_quat(q)
rVector = q(2:4)./q(1);
return




