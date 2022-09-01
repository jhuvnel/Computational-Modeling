%compute the noise equivalent plots using brute force methods
%P = power of noise spectrum, F = frequencies of that spectrum
%dataSize = original data size the noise spectrum was computed for
%d = distance between accelerometers (meters)
%offset = db above noise level, 0 for noise equiv

function y = noiseEquivalent(P,F,dataSize,d, offset)
    t = 1:0.01:(dataSize*0.01);
    nEquiv = 0;
    fEquiv = 0;
    %spectrum parameters
    order = 1000;
    FFT_length = 1024*64;
    Fs = 100;
    %define model parameters
    psi = 0.031;    %device sensitivity in volts/m/s^2
  
    limitFlag = 0;
    ampIncr = 10;
    for probe = 34:10:670 %(max(size(F)))
disp(['Calculating for f = ' num2str(F(probe))])
        amp = 0;    %in dps
        power = 0;
        while (db(power,'power') < (db(P(probe),'power')+offset) && limitFlag == 0)
            amp = amp + ampIncr;
            modelOutput = amp*((pi^2)/90)*F(probe)*d*psi*sin((2*pi*F(probe))*t);
            Pm = pyulear(modelOutput, order, FFT_length, Fs);
            power = Pm(probe);
        end
        if (amp<=(ampIncr*15))
            ampIncr = ampIncr/10;
        end
        if (ampIncr < .005)
            limitFlag = 1;
        end
        if (limitFlag == 1)
            amp = 0;
        end
        nEquiv = [nEquiv amp];
        fEquiv = [fEquiv F(probe)];
    end
    answer.n = nEquiv(2:(max(size(nEquiv))));
    answer.f = fEquiv(2:(max(size(fEquiv))));
    y = answer;