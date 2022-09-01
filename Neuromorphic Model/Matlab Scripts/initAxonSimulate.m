%this function initializes an AxonSimulate class, its a wrapper
%for the messy process of passing matlab cells to java
%pass it a "simulation parameter" cell and a "sampleModelSolution" cell
%finally, pass it an empty AxonSimulate class

function y = initAxonSimulate(parameter, solutions, simClass)
    disp('Beginning to initialize an AxonSimulate class')
    simClass.initialize(solutions{1,2}, parameter{5}, parameter{3}, parameter{4}, parameter{2}, parameter{1}(1));
    uploadVe(solutions, simClass, parameter{1}(1));
    disp(['AxonSimulate class created successfully. ' num2str(size(solutions,1)) ' Individual nerve fibers accounted for.'])
    y = simClass;