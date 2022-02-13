function [ imageRec, R, iter, time] = mod_svd_algo(obj, PSF, fCoeffMaps, noise, param)
%%%
% 
% This function generates a noisy image signal using a ground truth object
% Then, it reconstruct a super-resolution image using the modifed LR algorithm.
% 
% Inputs:
%     obj: ground truth object
%     ill: straight fibre illumination
%     N: image height/width, image must be square
%     noise: standard deviation to be used in the Gaussian noise model
%     param: different physical parameters
%     
% Outputs:
%     imageRec: reconstructedd super-resolution image [N, N]
%     R: correlation coefficient matrix between obj and imageRec
%     iter: number of iterations used during reconstruction
%     time: reconstruction processing time
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Calculate signal from illumination matrix
signal = signal_calc(PSF, obj, noise);

%% Reconstruction

% Call reconstruction algorithm
t_start = tic;

[imageRec, iter] = RLTV_SVdeconv(signal, PSF, fCoeffMaps, param.modes, param.lambda, param.iteration, obj); %Call algo here
   
time = toc(t_start);
%toc(t_start);

% Check for negative values
imageRec(imageRec < 0) = 0;

% Apply circular mask
N = param.N;
mask = zeros(N);
[xx,yy] = meshgrid((1:N)-N/2-0.5,(1:N)-N/2-0.5);
mask(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06) = 1;
imageRec = mask .* imageRec;

% Compare the ground truth to processed image
R = corrcoef(obj(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06),imageRec(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06));

%% Display
%close all 
% figure('Position', [200, 200, 1000, 400]);
% 
% subplot(131)
% imagesc( obj ); colormap gray; axis image
% title('Object');
% 
% subplot(132)
% imagesc( imageRec ); colormap gray; axis image
% title('Reconstruction');
% viscircles( [N/2+0.5 N/2+0.5], round(N/2)/1.06 );
% 
% subplot(133)
% imagesc( signal ); colormap gray; axis image
% title('Reconstruction');
% viscircles( [N/2+0.5 N/2+0.5], round(N/2)/1.06 );
% drawnow
end

function [ signal ] = signal_calc(PSF, obj, noise)

% calculate the signal perform convolution.
signal = imfilter(obj,PSF,'conv');

% Add noise
% We will need to renormalise the absolute intensity to ensure that the
% analysis can be compared.
%max_signal = sum(sum(signal)); % I think it should be changed to sum(sum(signal)) and then it's ok.
signal = (4*(10^15))*signal/(10^9);
nfac = 5*10^18;% fix normalisation factor
signal = nfac*imnoise(signal/nfac,'gaussian',0,noise);
           
% signalsave = uint8(255*signal/max(max(signal)));
% saveastiff(signalsave, 'beads_density10_num6_noise2_signal.tif');

end