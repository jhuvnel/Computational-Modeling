 currentRange = linspace(0,12,500);
current = 200e-6;
currentRange = currentRange*current;




figure

   cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Posterior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';


        subplot (3,1,1)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
      
      
    load('Workspace Electrode_Posterior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';

        subplot (3,1,2)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 60])
      
      
    
    load('Workspace Electrode_Posterior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Posterior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Posterior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Posterior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

     subplot (3,1,3)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
   

figure


   cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Superior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';


        subplot (3,1,1)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
      
      
    load('Workspace Electrode_Superior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';

        subplot (3,1,2)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 60])
      
      
    
    load('Workspace Electrode_Superior2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Superior1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Superior1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Superior1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Superior1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

     subplot (3,1,3)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
   

figure


cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
    load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector1(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';


        subplot (3,1,1)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
      
      
    load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector2(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
   
      cd 'R:\VNEL Alumni Files\Olds-Kevin';

        subplot (3,1,2)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 60])
      
      
    
    load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim10.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a11= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
    
        cd 'R:\VNEL Alumni Files\Olds-Kevin';
            
load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim11.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a12= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 


    
         cd 'R:\VNEL Alumni Files\Olds-Kevin';

load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim12.mat')
 cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
 a13= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
       
 
 
 cd 'R:\VNEL Alumni Files\Olds-Kevin';

    load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim.mat')
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
    a14= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 
    

    
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_common_cruz_sim14.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   a15= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Horizontal1_comsol_unipol_sim.mat')
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts'; 
   b3= getAngleFromIdealVector3(horSCC_SimCell,supSCC_SimCell,posSCC_SimCell,utricle_SimCell,saccule_SimCell) ; 

     subplot (3,1,3)
    plot(currentRange,a11, 'k',currentRange, a12, 'r',currentRange, a13, 'm',currentRange, a14, 'g',currentRange, a15, 'b', currentRange, b3, 'c')

    axis([0 0.001 0 50])
   