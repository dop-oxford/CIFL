function [ signal] = Q2_mod_peak_intensity(obj, ill, N, input_num, noise, arrayNum)
%%%
% 
% This functions calculates the peak signal intensity for a given
% illumination basis.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Determine sub-illumination
[ill_update, input_num]  = Q2_array_gen(N, input_num, ill, arrayNum);

%% Calculate signal from illumination matrix
signal = signal_calc(ill_update, obj, noise, input_num);

end

function [ signal ] = signal_calc(ill, obj, noise, input_num)

% pre-allocation
signal = zeros(input_num,1);

% calculate the signal
for ii = 1:input_num
    signal(ii) = sum(sum(ill(:,:,ii) .* obj));
end

% Add noise
nfac = 5*10^18;% fix normalisation factor
signal = nfac*imnoise(signal/nfac,'gaussian',0,noise);
signal = max(signal);

end