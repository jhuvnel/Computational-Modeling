%this function initializes an AxonSimulate class, its a wrapper
%for the messy process of passing matlab cells to java
%pass it a "simulation parameter" cell and a "sampleModelSolution" cell
%finally, pass it an empty AxonSimulate class

function y = initAxonSimulate(parameter, solutions, simClass)
    disp('Beginning to initialize an AxonSimulate class')
    %since AxonSimulate.initialize() expects only a single step vector to
    %be input (first arg), choose the step vector with the greatest length
    %to avoid any places in the java code trying to iterate through a
    %greater number of nodes than is present in the step vector. If axons
    %have a different number of nodes then it can cause an error. Currently
    %it seems that if an axon has greater than 1 more nodes than the
    %inputted step vector here, it causes an arrayIndexOutOfBounds error
    [~, step_vector_ind] = max(cellfun(@length,solutions(:,2)));
    simClass.initialize(solutions{step_vector_ind,2}, parameter{5}, parameter{3}, parameter{4}, parameter{2}, parameter{1}(1));
    uploadVe(solutions, simClass, parameter{1}(1));
    disp(['AxonSimulate class created successfully. ' num2str(size(solutions,1)) ' Individual nerve fibers accounted for.'])
    y = simClass;