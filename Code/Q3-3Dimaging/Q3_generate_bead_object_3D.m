%%%
%
% This script makes synthetic 3D bead object images by generating points uniformly at
% random locations (with a given radius from the center). The intensity is
% then randomised following a gaussian distribution. All beads are given
% the same diameter using gaussian filtering.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

% Image parameters
N = 40; % Height and width of the image
Z = 60; % Number of axial plane
density = 0.0015; % density of beads

% Iterate over each image
for i = 1:5 % number of images created
    
    % Initialising the bead object image
    pt_obj1 = zeros(N,N,Z);
    
    % Generating points uniformly at random locations
    rng(i); % set seed
    pt_obj2 = imnoise(pt_obj1,'salt & pepper',density); %density
    
    % Limit the points to within a given radius from the center
    mask = zeros(N);
    [xx,yy] = meshgrid((1:N)-N/2-0.5,(1:N)-N/2-0.5);
    mask(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06*0.90) = 1;
    
    for j = 1:Z
        if j > (Z*0.12) && j < (Z*0.88)
            pt_obj2(:,:,j) = mask .* pt_obj2(:,:,j);
        else
            pt_obj2(:,:,j) = 0;
        end
    end
    
    % Randomising the intensity
    %pt_obj3 = 2*pt_obj2.*imnoise(pt_obj2/2,'gaussian',0,0.5);
    pt_obj3 = pt_obj2;
    
    % Appling a Gaussian filter
    pt_obj4 = imgaussfilt3(pt_obj3,2.2642/1.699*0.7); %1/(50*1.06/120)
    
%     for j = 1:Z
%         % Display
%         subplot(131)
%         imagesc(pt_obj2(:,:,j));colormap gray; axis image
%         subplot(132)
%         imagesc(pt_obj3(:,:,j));colormap gray; axis image
%         subplot(133)
%         imagesc(pt_obj4(:,:,j));colormap gray; axis image
%         drawnow
%         pause(0.1)
%     end
    
    % Saving the images
    s = strcat('Beads/beads_3D_num',num2str(i),'.tif');
    image = uint8(255*pt_obj4./max(max(max(pt_obj4))));
    saveastiff(image, s);
end


