function [ imageRec, R , iter, time] = mod_csi_speckle_algo(obj, ill, N, input_num, noise, algo)
%%%
% 
% This function generates a noisy compressed signal using a ground truth object
% Then, it reconstruct a super-resolution image using the compressed signal.
% Used for speckle illumination only.
% 
% Inputs:
%     obj: ground truth object
%     ill: straight fibre illumination
%     N: image height/width, image must be square
%     noise: standard deviation to be used in the Gaussian noise model
%     algo: index of the compressed sensing algorithm used for recosntruction
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
signal = signal_calc(ill, obj, noise, input_num);

%% Reconstruction

% Transform the illumination matric into a vector
vecMH2 = reshape(ill, [N^2, input_num]);

% Initial guess
%iR0 = vecMH2*signal;
iR0 = zeros(N^2,1);

% Call reconstruction algorithm
t_start = tic;

switch algo
    case 0
        [imageRec, iter] = basis_pursuit_mod(vecMH2', signal, 1.0, 1.0);
    case 1
        [imageRec, iter] = l1dantzig_pd(iR0, vecMH2', [], signal, 3e-3, 5e-2, 500);
    otherwise
        imageRec = iR0;
        disp('No valid algorithm selected.')
end
time = toc(t_start);
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
% close all 
% figure('Position', [200, 200, 1000, 400]);
% 
% subplot(121)
% imagesc( obj ); colormap gray; axis image
% title('Object');
% 
% subplot(122)
% imagesc( imageRec ); colormap gray; axis image
% title('Reconstruction');
% viscircles( [N/2+0.5 N/2+0.5], round(N/2)/1.06 );
% drawnow
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

end