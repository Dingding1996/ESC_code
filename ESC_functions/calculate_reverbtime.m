%%  To calculate reverberation time
function [EDT,T20,T30,decayCurve] = calculate_reverbtime(nStart,thisIR, nSamplesSignal,tv)
% Equation to calculate sound pressure level
spl = @(input)(20 * log10(abs(input)))+120;
thisIRSPL = reshape(spl(thisIR),1,[]);
thisIRSPL(thisIRSPL == -Inf) = 0;
% To exclude influence of filters on the end of signals
nEnd=floor(nSamplesSignal*9/10);
thisIRSPL_Part=thisIRSPL(nStart:nEnd);
tv_Part=tv(nStart:nEnd);
% To find the envelope
[peaks, locs] = findpeaks(thisIRSPL_Part,"MinPeakDistance",nSamplesSignal/100);
tv_Peaks = tv_Part(locs);
spl_Peaks = thisIRSPL_Part(locs);
% To fit the envelope
upper_Envelope = interp1(tv_Peaks, spl_Peaks, tv_Part, 'pchip');
p = polyfit(tv_Part,upper_Envelope,3);
decayCurve=p(1)*(tv.^3)+p(2)*(tv.^2)+p(3)*(tv.^1)+p(4);
%% Early decay time
% To find the point with a decay of 10 dB from the start
decayLevel10=10;  
decayCurveLevel10=abs(decayCurve-(decayCurve(nStart)-decayLevel10));
% To find the index
nDecay10=find(decayCurveLevel10==min(decayCurveLevel10));
%  EDT
EDT=(tv(nDecay10)-tv(nStart))*(60/decayLevel10);
%%  Decay 5dB
% To find the point with a decay of 5 dB from the start
decayLevel5=5;  
decayCurveLevel5=abs(decayCurve-(decayCurve(nStart)-decayLevel5));
% To find the index
nDecay5=find(decayCurveLevel5==min(decayCurveLevel5));
%% T20
% To find the point with a decay of 20 dB from the 5 dB decay point 
decayLevel20=20;  
decayCurveLevel20=abs(decayCurve-(decayCurve(nDecay5)-decayLevel20));
% To find the index
nDecay20=find(decayCurveLevel20==min(decayCurveLevel20));
% T20
T20=(tv(nDecay20)-tv(nDecay5))*(60/decayLevel20);
%% T30
% To find the point with a decay of 30 dB from the 5 dB decay point 
decayLevel30=30;  
decayCurveLevel30=abs(decayCurve-(decayCurve(nDecay5)-decayLevel30));
% To find the index
nDecay30=find(decayCurveLevel30==min(decayCurveLevel30));
% T30
T30=(tv(nDecay30)-tv(nDecay5))*(60/decayLevel30);
end

