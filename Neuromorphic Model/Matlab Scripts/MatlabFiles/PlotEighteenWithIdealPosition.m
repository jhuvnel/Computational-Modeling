gain = 0 ;

% Horizontal

a=1;

cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim10.mat')
%subplot(3,5,1)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
    a1= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim11.mat')
%subplot(3,5,2)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
    a2= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 

    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
%subplot(3,5,3)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a3= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
 
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim.mat')
%subplot(3,5,4)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a4= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
            
 
    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim14.mat')
%subplot(3,5,5)
  cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
  a5= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';
% Superior


        cd 'R:\VNEL Alumni Files\Olds-Kevin';

 load('Workspace Electrode_Horizontal2_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b1= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


a=2;
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';

  load('Workspace Electrode_Superior2_comsol_common_cruz_sim10.mat')
%subplot(3,5,6)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a6= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior2_comsol_common_cruz_sim11.mat')
%subplot(3,5,7)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a7= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


    
    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
%subplot(3,5,8)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a8= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
 

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior2_comsol_common_cruz_sim.mat')
%subplot(3,5,9)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a9= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
            

    
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
   load('Workspace Electrode_Superior2_comsol_common_cruz_sim14.mat')
%subplot(3,5,10)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a10= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 

        cd 'R:\VNEL Alumni Files\Olds-Kevin';

 load('Workspace Electrode_Superior2_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b2= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 

    
        
    % posterior
    
    a=3;
    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Posterior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior2_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior2_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior2_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior2_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVectorAll(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell, a, gain) ; 

    
    
    figure
    
currentRange = linspace(0,12,500);
current = 200e-6;
currentRange = currentRange*current;

    subplot (3,1,1)
    
    plot(currentRange, a1, 'k', currentRange, a2, 'r',currentRange, a3, 'm',currentRange, a4, 'g',currentRange, a5, 'b',currentRange, b1, 'c' )
    axis([0 0.001 0 60])
     
    subplot (3,1,2)
    plot(currentRange,a6, 'k', currentRange,a7, 'r', currentRange,a8, 'm',currentRange, a9, 'g',currentRange, a10, 'b', currentRange, b2' , 'c')
    axis([0 0.001 0 60])
     
    subplot (3,1,3)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 60])
    