%kind of like plotEMAData.m, but plots selectivity on a sphere


function y = plotNeuralRecruitmentOnSphere(eyeVector, EMAcurrent, supSum, horSum, posSum, currentStandard, currentRange)
    i = 1;
    while (currentRange(i)*currentStandard < EMAcurrent)
        i = i + 1;
    end

    LHsim = horSum(i);
    LPsim = posSum(i);
    LAsim = supSum(i);

    LHnormal = [-0.799;0.156;0.565];
    LAnormal = [-0.491;0.729;-0.476];
    LPnormal = [-0.322;-0.673;-0.662];
    
    ExpVector = eyeVector(1)*LAnormal+eyeVector(2)*LHnormal+eyeVector(3)*LPnormal;
    ExpVector = ExpVector/norm(ExpVector);
    
    SimTot = LHsim+LPsim+LAsim;
    LHsim=LHsim/SimTot;
    LAsim=LAsim/SimTot;
    LPsim=LPsim/SimTot;
    
    SimVector = LAsim*LAnormal+LHsim*LHnormal+LPsim*LPnormal;
    SimVector = SimVector/norm(SimVector);
    
    %plot the stuff
    plotEyeAxisVectorsOnSphere(ExpVector, SimVector);
    
    error = dot(ExpVector, SimVector);
    error = acos(error);
    error = error*(180/pi);
    y = error;  %return error in degrees
    