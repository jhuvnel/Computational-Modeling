
%########################################
%########################################
%####    PLOT  WITH GAIN #############

% Horizontal

a=1;

cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim10.mat')
%subplot(3,5,1)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
    a1= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim11.mat')
%subplot(3,5,2)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a2= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;

    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
%subplot(3,5,3)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a3= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
 
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Horizontal2_comsol_unipol_sim.mat')
%subplot(3,5,4)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a4= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
            
 
    
    
    
    
    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim14.mat')
%subplot(3,5,5)
  cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a5= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';
% Superior

a=2;
    
  load('Workspace Electrode_Superior1_comsol_common_cruz_sim10.mat')
%subplot(3,5,6)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a6= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior1_comsol_common_cruz_sim11.mat')
%subplot(3,5,7)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a7= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
%subplot(3,5,8)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a8= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
 

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior2_comsol_unipol_sim.mat')
%subplot(3,5,9)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a9= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
            

    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
   load('Workspace Electrode_Superior1_comsol_common_cruz_sim14.mat')
%subplot(3,5,10)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a10= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


        
    % posterior
    
    a=3;
    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Posterior1_comsol_common_cruz_sim10.mat')
%subplot(3,5,11)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a11= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a12= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a13= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior2_comsol_unipol_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a14= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a15= ThresholdPostProcAbderIdeal3(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;

    
    
    figure
    
currentRange = linspace(0,12,500);
current = 200e-6;
currentRange = currentRange*current;

    
    subplot (2,3,1)
    
    plot(currentRange, a1, 'k', currentRange, a2, 'r',currentRange, a3, 'm',currentRange, a4, 'g',currentRange, a5, 'b')
     axis([0 0.001 0 1])
     
    subplot (2,3,2)
    plot(currentRange,a6, 'k', currentRange,a7, 'r', currentRange,a8, 'm',currentRange, a9, 'g',currentRange, a10, 'b')
     axis([0 0.001 0 1])
     
    subplot (2,3,3)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b')

    axis([0 0.001 0 1])
    
    
    %########################################
%########################################
%####    PLOT  WITHOUT  GAIN #############


% Horizontal

a=1;

cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim10.mat')
%subplot(3,5,1)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
    a1= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim11.mat')
%subplot(3,5,2)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a2= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;

    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
%subplot(3,5,3)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a3= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
 
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Horizontal2_comsol_unipol_sim.mat')
%subplot(3,5,4)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a4= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
            
 
    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim14.mat')
%subplot(3,5,5)
  cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a5= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';
% Superior

a=2;
    
  load('Workspace Electrode_Superior1_comsol_common_cruz_sim10.mat')
%subplot(3,5,6)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a6= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior1_comsol_common_cruz_sim11.mat')
%subplot(3,5,7)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a7= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
%subplot(3,5,8)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a8= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
 

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior2_comsol_unipol_sim.mat')
%subplot(3,5,9)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a9= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
            

    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
   load('Workspace Electrode_Superior1_comsol_common_cruz_sim14.mat')
%subplot(3,5,10)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a10= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


        
    % posterior
    
    a=3;
    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Posterior1_comsol_common_cruz_sim10.mat')
%subplot(3,5,11)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a11= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a12= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a13= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior2_comsol_unipol_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a14= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; a15= ThresholdPostProcAbderIdeal(a,horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ;

    
    
    %figure
    
currentRange = linspace(0,12,500);
current = 200e-6;
currentRange = currentRange*current;

    
    subplot (2,3,4)
    
    plot(currentRange, a1, 'k', currentRange, a2, 'r',currentRange, a3, 'm',currentRange, a4, 'g',currentRange, a5, 'b')
     axis([0 0.001 0 1])
     
    subplot (2,3,5)
    plot(currentRange,a6, 'k', currentRange,a7, 'r', currentRange,a8, 'm',currentRange, a9, 'g',currentRange, a10, 'b')
     axis([0 0.001 0 1])
     
    subplot (2,3,6)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b')

    axis([0 0.001 0 1])
    
    