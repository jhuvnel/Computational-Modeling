%this function wraps the AxonSimulate class completely
%pass in a parameter cell structure, a solutions cell structure,
%a waveform to test, a trajectory cell and an AxonSimulate class
%the function will automatically initialize the AxonSimulate class
%errorFile = name of a text file to append the error log too

function y = simulateWaveform(parameter, solutions, waveform, traj, simClass, errorFile)
    %initialize the sim class
    simClass = initAxonSimulate(parameter, solutions, simClass);
    if (parameter{6} ~= -1)
        simClass.setInitialCondition(parameter{6});
    end
    disp('Beginning to simulate each nerve fiber.')
    result = simClass.compute(waveform, parameter{7}, errorFile, parameter{1}(2), parameter{1}(3));
    disp('Finished simulation')
    %now return the result cell
    if (parameter{7} ~= -1)   %full result class (store everything for saving)
        resultCell = cell(5,1);
        resultCell{1} = parameter;
        resultCell{2} = traj;
        resultCell{3} = waveform;
        resultCell{4} = result;
        resultCell{5} = simClass.AP;    %store action potential info
        disp('Returning full result cell structure.')
    else
        %short result
        resultCell = result;
        disp('Returning truncated result cell structure.')
    end
    y = resultCell;
        