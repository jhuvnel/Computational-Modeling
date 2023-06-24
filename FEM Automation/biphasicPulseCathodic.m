function [pulse] = biphasicPulseCathodic(delay, PA, PW1, gap, PW2, t)
%UNTITLED2 This function generates a cathodic-first biphasic pulse based on input
%parameters.
%   Specify delay (delay), pulse amplitude (PA), 1st phase width (PW1),
%   interphase gap (gap), 2nd phase width (PW2), and the time vector (t).
%   Time units should match that of the inputted time vector t. Current
%   units are uA.

pulse = zeros(size(t));
pulse((t > delay) & (t <= delay + PW1)) = -1*PA; % first phase
pulse((t > delay + PW1) & t <= (delay + PW1 + gap)) = 0; % interphase gap
pulse((t > delay + PW1 + gap) & (t <= delay + PW1 + gap + PW2)) = PA; % second phase

end