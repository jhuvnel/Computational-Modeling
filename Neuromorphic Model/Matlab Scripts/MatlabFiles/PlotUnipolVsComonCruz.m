
cd 'R:\VNEL Alumni Files\Olds-Kevin';
    
load('Workspace Electrode_Horizontal2_comsol_common_cruz_sim.mat')
subplot(3,2,1)
  cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

  
  cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
   load('Workspace Electrode_Superior2_comsol_common_cruz_sim.mat')
subplot(3,2,3)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

        
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior2_comsol_common_cruz_sim.mat')
subplot(3,2,5)
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

  
        
   
   
   
   
   
   
cd 'R:\VNEL Alumni Files\Olds-Kevin';
    
load('Workspace Electrode_Horizontal2_comsol_unipol_sim.mat')
subplot(3,2,2)
  cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

  
  cd 'R:\VNEL Alumni Files\Olds-Kevin';

    
   load('Workspace Electrode_Superior2_comsol_unipol_sim.mat')
subplot(3,2,4)
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

        
             cd 'R:\VNEL Alumni Files\Olds-Kevin';

   load('Workspace Electrode_Posterior2_comsol_unipol_sim.mat')
subplot(3,2,6)
   cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';run ThresholdPostProcAbder;  ;

  
   for i=1:1:6
       
       suplot(i)
       
      axis([0 0.001 50 100])
   end
        