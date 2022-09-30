

function y = getPower(dataSize, d, F, amp)
    t = 1:0.01:(dataSize*0.01);
    %spectrum parameters
    order = 1000;
    FFT_length = 1024*64;
    Fs = 100;
    %define model parameters
    psi = 0.031;    %device sensitivity in volts/m/s^2
    modelOutput = amp*((pi^2)/90)*F*d*psi*sin((2*pi*F)*t);
    Pm = pyulear(modelOutput, order, FFT_length, Fs);
    y = [max(db(Pm,'power')) max(Pm)]; 
