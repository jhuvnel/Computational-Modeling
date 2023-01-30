%this function wraps the AxonSimulate class completely and finds the THRESHOLD result structure
%pass in a parameter cell structure, a solutions cell structure,
%a waveform to test, a trajectory cell and an AxonSimulate class
%the function will automatically initialize the AxonSimulate class
%please read all comments within AxonSimulate.java first
%errorFile = name of a text file to append the error log too


function y = findThresholdWaveform(parameter, solutions, waveform, traj, simClass, errorFile)  
%initialize the sim class
    simClass = initAxonSimulate(parameter, solutions, simClass);
    if (parameter{6} ~= -1)
        simClass.setInitialCondition(parameter{6});
%         javaMethod('setInitialCondition', simClass, parameter{6});
    end
    disp('Beginning to find thresholds for each nerve fiber.')
    result = simClass.findThreshold(waveform, parameter{7}, parameter{8}(1), parameter{9}, parameter{8}(2), errorFile, parameter{1}(2), parameter{1}(3));
%     result = javaMethod('findThreshold', simClass, waveform, parameter{7}, parameter{8}(1), parameter{9}, parameter{8}(2), errorFile, parameter{1}(2), parameter{1}(3));
    disp('Finished finding thresholds.')
    %now return the result cell
    resultCell = cell(5,1);
    resultCell{1} = parameter;
    resultCell{2} = traj;
    resultCell{3} = waveform;
    resultCell{4} = result;
    resultCell{5} = simClass.AP;    %store info on spike initiator zone
    disp('Returning threshold result cell structure.')
    y = resultCell;
