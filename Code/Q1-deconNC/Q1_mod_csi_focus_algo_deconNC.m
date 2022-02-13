function [ imageRec, R , iter] = Q1_mod_csi_focus_algo_deconNC(obj, ill, N, noise, P, pAAt)
%%%
% 
% This function generates a noisy compressed signal using a ground truth object
% Then, it reconstruct a super-resolution image using the compressed signal.
% The pseudo-inverse of the illumination must be pre-calculated.
% 
% 
% Inputs:
%     obj: ground truth object
%     ill: straight fibre illumination
%     N: image height/width, image must be square
%     noise: standard deviation to be used in the Gaussian noise model
%     P and pAAT: pseudo-inverse matrices calculated for basis pursuit
%     
% Outputs:
%     imageRec: reconstructedd super-resolution image [N, N]
%     R: correlation coefficient matrix between obj and imageRec
%     iter: number of iterations used during reconstruction
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Determine sub-illumination
ill_update = ill; % The full illumination matrix is used. Non compression

%% Calculate signal from illumination matrix
signal = signal_calc(ill_update, obj, noise, N^2);

%% Reconstruction

% Transform the illumination matric into a vector
vecMH2 = reshape(ill_update, [N^2, N^2]);

% Initial guess
%iR0 = vecMH2*signal;
iR0 = zeros(N^2,1);

% Call reconstruction algorithm
t_start = tic;
[imageRec, iter] = Q1_basis_pursuit_mod_deconNC(vecMH2', signal, 1.0, 1.0, P, pAAt);
toc(t_start);

% Reshape reconstructed image
imageRec = reshape(imageRec, [N, N]);

% Check for negative values
imageRec(imageRec < 0) = 0;

% Apply circular mask
mask = zeros(N);
[xx,yy] = meshgrid((1:N)-N/2-0.5,(1:N)-N/2-0.5);
mask(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06) = 1;
imageRec = mask .* imageRec;

R = corrcoef(obj(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06),imageRec(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06));

%% Display
close all 
figure('Position', [200, 200, 1000, 400]);

subplot(121)
imagesc( obj ); colormap gray; axis image
title('Object');

subplot(122)
imagesc( imageRec ); colormap gray; axis image
title('Reconstruction');
viscircles( [N/2+0.5 N/2+0.5], round(N/2)/1.06 );
drawnow
end

function [ signal ] = signal_calc(ill, obj, noise, N)

% pre-allocation
signal = zeros(N,1);

% calculate the signal
for ii = 1:N
    signal(ii) = sum(sum(ill(:,:,ii) .* obj));
end

% Add noise
nfac = 5*10^18;% fix normalisation factor
signal = nfac*imnoise(signal/nfac,'gaussian',0,noise);

end