%%%
%
% Script to iterate the analysis done in Q4_mod_csi_speckle_algo.m over 
% all image files in a chosen folder. The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

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

%% Set file for writing results
Results = 'Results_Q4_bent_core_algo1.txt';
ID = fopen(Results,'a+');

%Load normalisation
load('normillum.mat');

%% Iterate over all images
for kk = 300:100:900
    k=3;
    %Parameters for bent fibre
    openname = strcat('Q4_speck_kk_',num2str(kk), '_k', num2str(k), '.mat');
    load(openname);
    value = k;
    output_img_H_bent = output_img_H * csipsf_total / csicore_total;
    
    %Parameters for straight fibre
    load("Q1-120-120-49.mat");
    
    % Normalise illumination accross algorithm (reference CSI_PSF)
    output_img_H = output_img_H * csipsf_total / csicore_total;

    for i = 1:length(fileList)
        Filename = char(fileList(i));
        if contains(Filename, 'tif')
            filenameSaving = fileList2{i};
            fprintf(ID,'Name\tAlgo\tNoise\tArray\tCorrCoef\tIter\tTime\n');
            
            obj = double(imread(Filename));
            
            fprintf([filenameSaving '\n']);
            [ imageRec, R_bent, iter ] = Q4_mod_csi_speckle_algo(obj, output_img_H, output_img_H_bent, N, input_num, 0, 1);
            fprintf('%10.8f\n', R_bent(2,1));
            
%             %Saving the images
%             s = strcat('Output/Q4-foci-algo-',num2str(algo),'/',filenameSaving(1:end-4),'_bent_1000',num2str(value),'_psfcore_algo',num2str(algo),'.tif');
%             image = uint8(255*imageRec/max(max(imageRec)));
%             saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.10f\t%10.10f\t%10.0f\t%10.0f\n'], value, R_bent(2,1), iter,kk);
        end
    end
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');
