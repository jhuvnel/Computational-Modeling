%downsample by 10, go from 1KHz to 100Hz

function y = downSample(signalX)
    maximum = max(size(signalX));
    i = 1;
    while (i < maximum)
        if (i==1)
            g = signalX(1);
        else
            g = [g signalX(i)];
        end
        i = i + 10;
    end
    y = g;