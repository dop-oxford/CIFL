%%%
%
% This script makes synthetic 2D bead object images by generating points uniformly at 
% random locations (with a given radius from the center). The intensity is
% then randomised following a gaussian distribution. All beads are given
% the same diameter using gaussian filtering.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

N = 120; % Height and width of the image
density = 0.001; % density of beads
for i = 1:21 % number of images created
    
    % Initialising the bead object image
    pt_obj1 = zeros(N);
    
    % Generating points uniformly at random locations 
    pt_obj2 = imnoise(pt_obj1,'salt & pepper',density); %density
    
    % Limit the points to within a given radius from the center
    mask = zeros(N);
    [xx,yy] = meshgrid((1:N)-N/2-0.5,(1:N)-N/2-0.5);
    mask(sqrt(xx.^2 + yy.^2) <= (N/2-0.5)/1.06*0.95) = 1;
    pt_obj2 = mask .* pt_obj2;
    
    % Randomising the intensity
    pt_obj3 = 2*pt_obj2.*imnoise(pt_obj2/2,'gaussian',0,0.5);
    
    % Appling a Gaussian filter
    pt_obj4 = imgaussfilt(pt_obj3,2.2642/1.699); %1/(50*1.06/120)
    
    % Display
    subplot(131)
    imagesc(pt_obj2);colormap gray; axis image
    subplot(132)
    imagesc(pt_obj3);colormap gray; axis image
    subplot(133)
    imagesc(pt_obj4);colormap gray; axis image
    drawnow
    
    % Saving the images
    s = strcat('Beads/beads_density',num2str(density*1000),'_num',num2str(i),'.tif');
    image = uint8(255*pt_obj4/max(max(pt_obj4)));
    saveastiff(image, s);
end

