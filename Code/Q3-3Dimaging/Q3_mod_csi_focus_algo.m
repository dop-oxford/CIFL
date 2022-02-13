function [ imageRec ] = Q3_mod_csi_focus_algo(obj, Illum2D, N, NA, Px, Z, algo)
%%%
% 
% This function generates a compressed signal using a 3D ground truth object
% and 2D illumination extended to 3D with defocus. Then, it reconstruct a 
% super-resolution image using the compressed signal and 2D illumination.
% 
% Inputs:
%     obj: ground truth object
%     ill: unaberrated illumination
%     ill_abn: aberrated illumination
%     N: image height/width, image must be square
%     NA: numerical aperture
%     Z: axial plane of interest [um]
%     Px: pixel size in pixel/um
%     algo: index of the compressed sensing algorithm used for recosntruction
%     
% Outputs:
%     imageRec: reconstructedd super-resolution image [N, N]
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Calculate signal from illumination matrix
[signal, Illum2D_Z] = signal_calc(Illum2D, obj, NA, Px, Z);

%% Reconstruction
vecMH2 = reshape(Illum2D_Z, [N^2, 2*(N/2)^2]);
vecMH2 = (vecMH2).^2; % Two-photon excitation

% Call reconstruction algorithm

% Initial guess
iR0 = zeros(N^2,1);

% Call reconstruction algorithm
switch algo
    case 0
        [imageRec, ~] = basis_pursuit_mod(vecMH2', signal, 1.0, 1.0);
    case 1
        [imageRec, ~] = l1dantzig_pd(iR0, vecMH2', [], signal, 3e-3, 5e-2, 500);
    otherwise
        imageRec = iR0;
        disp('No valid algorithm selected.')
end

% Reshape reconstructed image
imageRec = reshape(imageRec, [N, N]);

% Check for negative values
imageRec(imageRec < 0) = 0;

obj2 = obj(:,:,Z);

%% Display
close all
figure('Position', [200, 200, 1000, 400]);

subplot(121)
imagesc( obj2 ); colormap gray; axis image
title('Object');

subplot(122)
imagesc( imageRec ); colormap gray; axis image
title('Reconstruction');
drawnow
end

function [ signal, Illum2D_Z ] = signal_calc(ill, obj, NA, Px, Z)

% pre-allocation
signal = zeros(size(ill,3),1);
illum3D = zeros(size(obj,1), size(obj,2), size(obj,3));
Illum2D_Z = zeros(size(ill,1), size(ill,2), size(ill,3));

% calculate the signal
for ii = 1:size(ill,3)
    for zz = 0:1:size(obj,3)-1
        if abs(Z+zz) <= size(obj,3)
            illum3D(:,:,Z+zz) = focal_plane_shift(ill(:,:,ii), (zz)/Px, NA, Px);
        end
        if (Z-zz) >= 1
            illum3D(:,:,Z-zz) = focal_plane_shift(ill(:,:,ii), (zz)/Px, NA, Px);
        end
        if zz == 0
            Illum2D_Z(:,:,ii) = illum3D(:,:,Z-zz);
        end
    end
    signal(ii) = sum(sum(sum((illum3D.^2) .* obj)));
end

end