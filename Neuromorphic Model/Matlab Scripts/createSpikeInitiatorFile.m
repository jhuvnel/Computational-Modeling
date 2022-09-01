%this function is used to create a file readable by the Amira module
%"SpikeInitiatorViewer", just specify the file name and a solution cell to
%convert (type = 0 for findThresholdWaveform.m, or type = 1 for simulateWaveform.m)
%USES saveascii.m (available from matlab file exchange)


function y = createSpikeInitiatorFile(fileName, axonSolutionCell, type)
    numAxons = max(size(axonSolutionCell{5}));
    %create the output matrix
    output = cell(1);
    for (i = 1:numAxons)
        if (type == 0)
            if (axonSolutionCell{4}(i) > 0) %rule out problem axons
                location = axonSolutionCell{2}{i,3}(:,axonSolutionCell{5}(i,1)+1);
                output{i,1} = double(location(1));  %x coord
                output{i,2} = double(location(2));  %y coord
                output{i,3} = double(location(3));  %z coord
                output{i,4} = double(axonSolutionCell{4}(i));   %scaling threshold
                output{i,5} = double(axonSolutionCell{5}(i,2)); %time of initiation
            end
        end
        if (type == 1)
            if (axonSolutionCell{5}(i,1) > -1)  %rule out axons not initiated
                location = axonSolutionCell{2}{i,3}(:,axonSolutionCell{5}(i,1)+1);
                output{i,1} = double(location(1));  %x coord
                output{i,2} = double(location(2));  %y coord
                output{i,3} = double(location(3));  %z coord
                output{i,4} = 0.0;            %not defined
                output{i,5} = double(axonSolutionCell{5}(i,2)); %time of initiation
            end
        end
    end
    %convert to a matrix
    output = cell2mat(output);
    
    %now save it to fileName using saveascii.m
    saveascii(output, fileName, 10, ' ');
    
    %return the output matrix
    y = output;