%take the output of AxialCUrrentFlowAndStandardDev and shuttle it into
%RussCirclePlot3, taking as input what node should the axial
%current be taken from, the means of the LH,LP,and LA current densities
%and a vector describing the actual eye movement

function y = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeNum, LH_currDen, LP_currDen, LA_currDen, color, lineSize, eyeVector)
    LHnormal = [-0.799;0.156;0.565];
    LAnormal = [-0.491;0.729;-0.476];
    LPnormal = [-0.322;-0.673;-0.662];
    
    ExpVector = eyeVector(1)*LAnormal+eyeVector(2)*LHnormal+eyeVector(3)*LPnormal;
    ExpVector = ExpVector/norm(ExpVector);
    
    LHsim = LH_currDen(nodeNum);
    LPsim = LP_currDen(nodeNum);
    LAsim = LA_currDen(nodeNum);
    SimTot = LHsim+LPsim+LAsim;
    LHsim=LHsim/SimTot;
    LAsim=LAsim/SimTot;
    LPsim=LPsim/SimTot;
    
    SimVector = LAsim*LAnormal+LHsim*LHnormal+LPsim*LPnormal;
    SimVector = SimVector/norm(SimVector);
    
    %plot the stuff
    h = russCirclePlot3(lineSize, [-0.799;0.156;0.565], 'r', [-0.491;0.729;-0.476], 'g', [-0.322;-0.673;-0.662], 'b', ExpVector, 'y', SimVector, color);
    axis vis3d;
    
    error = dot(ExpVector, SimVector);
    error = acos(error);
    error = error*(180/pi);
    y = error;  %return error in degrees
    