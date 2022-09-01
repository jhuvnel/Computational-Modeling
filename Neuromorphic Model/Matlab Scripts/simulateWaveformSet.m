%this function is very similar to simulateWaveform.m, however is meant to
%simulate a certain waveform with differing stimulus strengths for each
%axon (specified by scaleValues), see simulateWaveform.m for additional
%documentation
%scaleValues must have a length equal to the number of axons, even though
%you may only want to simulate a small subset of the bunch

function y = simulateWaveformSet(parameter, scaleValues, solutions, waveform, traj, simClass, errorFile)
    %initialize the sim class
    simClass = initAxonSimulate(parameter, solutions, simClass);
    if (parameter{6} ~= -1)
        simClass.setInitialCondition(parameter{6}); 
    end
    disp('Beginning to simulate each nerve fiber.')
    %here is where this code deviates from simulateWaveform.m
    resultCell = cell(5,1);
    resultCell{5} = zeros(parameter{1}(1), 2);
    for i = parameter{1}(2):parameter{1}(3)
        simClass.compute(waveform*scaleValues(i), parameter{7},errorFile, i, i);
        resultCell{5}(i,:) = simClass.AP(i,:);
    end
    disp('Finished simulation')
    %now return the result cell
    resultCell{1} = parameter;
    resultCell{2} = traj;
    resultCell{3} = waveform;
    resultCell{4} = scaleValues;    %store for future use, be careful not to mistake this result cell
                                    %for one produced by findThresholdWaveform.m
    y = resultCell;
        