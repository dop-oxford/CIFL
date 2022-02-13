%%%
%
% Script to iterate the analysis done in Q3_mod_csi_focus_algo.m over 
% all 3D image files in a chosen folder. The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load illumination and other parameters
load('Q3_foci_illum_120_NA37.mat');
output_E_ill_facet = reshape(output_E_ill_facet, [Nsmall Nsmall 2*(Nsmall/2).^2] );
Illum2D = abs(output_E_ill_facet).^2;
Px = N/(1.06*D*(10^6)); % [pixel/um]

algo = 1; %0 or 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Select image data set
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
        obj = double(loadtiff(filenameSaving)); % Files must be in search path
        
        imageRec = zeros(Nsmall,Nsmall,size(obj,3));

        for zz=1:1:size(obj,3)
            zz
            [ imageRec(:,:,zz)  ] = Q3_mod_csi_focus_algo(obj, Illum2D, Nsmall, NA, Px, zz, algo);
        end
        
        %Saving the images
        s = strcat('Output/Q3-Beads-NA37-0p7/',filenameSaving(1:end-4),'_foci_NA37_120_3000_algo',num2str(algo),'.tif');
        image = uint8(255*imageRec/max(max(max(imageRec))));
        saveastiff(image, s);

    end
end
