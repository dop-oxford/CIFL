function [] = conv3Dbeads()
%%%
%
% This script iteratively performs a 3D convolution of individual 3D image
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Load illumination parameters
load('Q3_foci_illum_120_NA37.mat');
output_E_ill_facet = reshape(output_E_ill_facet, [Nsmall Nsmall 2*(Nsmall/2).^2] );
Illum2D = abs(output_E_ill_facet).^2;
Px = N/(1.06*D*(10^6)); % [pixel/um]

%% Select image data set
[~, Pathname] = uigetfile('*.tif', 'Pick a tif-file');

dirData = dir(Pathname);      %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
fileList2 = {dirData(~dirIndex).name}';  %'# Get a list of the files
if ~isempty(fileList2)
    fileList = cellfun(@(x) fullfile(Pathname,x),fileList2,'UniformOutput',false);
else
    msgbox('No file in selected folder.','Invalid input','error');
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Iterate and perform over all image file
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        obj = double(loadtiff(filenameSaving));
        Illum3D = zeros(Nsmall,Nsmall,size(obj,3));
        for zz = 0:size( Illum3D,3)/2
            if (size(Illum3D,3)/2+zz) <= size(obj,3)
                Illum3D(:,:,size(Illum3D,3)/2+zz) = focal_plane_shift(Illum2D(:,:,(size(Illum2D,3))/4-10), (zz)/Px, NA, Px);
            end
            if (size(Illum3D,3)/2-zz) >= 1
                Illum3D(:,:,size(Illum3D,3)/2-zz) = focal_plane_shift(Illum2D(:,:,(size(Illum2D,3))/4-10), (zz)/Px, NA, Px);
            end
        end
        
        [maX,LX] = max(Illum2D(:,:,(size(Illum2D,3))/4-10));
        [~,LY] = max(maX);
        Illum2P = Illum3D(LX(LY)-10:LX(LY)+10,LY-10:LY+10,:).^2;
        imageConvn = convn(obj, Illum2P, 'same');
        TTT = uint8(255*Illum2P/max(max(max(Illum2P))));
        saveastiff(TTT, 'PSF3Dconv.tif');
        
        %Saving the images
        s = strcat('Output/Q3-Beads-NA37conv-0p7/',filenameSaving(1:end-4),'_CONVN37v5.tif');
        image = uint8(255*imageConvn/max(max(max(imageConvn))));
        saveastiff(image, s);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
