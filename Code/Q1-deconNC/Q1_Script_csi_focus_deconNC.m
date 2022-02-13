%%%
%
% This script iterates the analysis done in Q1_mod_csipsf_algo_deconNC.m over
% all 2D image files in a chosen folder. The results are saved to a text file.
% This analysis is conducted using the basis pursuit algorithm (algo = 0).
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Load illumination and other parameters
load("Q1_PSF_deconNC.mat");
noise = [0, 1e-17, 1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10];

%%  Select image data set
[~, Pathname] = uigetfile('*.tif', 'Pick a mat-file');

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
Results = 'Results_Q1_csi_focus_deconNC.txt';
ID = fopen(Results,'a+');

%% Iterate and perform over all image file
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tAlgo\tNoise\tCorrCoef\tIter\n');
        
        obj = double(imread(Filename));
        for k = 1:length(noise)
            fprintf([filenameSaving '\n']);
            
            [ imageRec, R , iter] = Q1_mod_csi_focus_algo_deconNC(obj, output_img_H, N, noise(k), P, pAAt);
            fprintf('%10.8f\n', R(2,1));
            
            % Saving the images
            s = strcat('Output/Q1_csi_focus_deconNC/',filenameSaving(1:end-4),'_noise',num2str(noise(k)*10^17),'_csifocus_deconNC.tif');
            image = uint8(255*imageRec/max(max(imageRec)));
            saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.0f\t%10.10f\t%10.8f\t%10.0f\n'], 0, noise(k)*10^17, R(2,1), iter);
        end
    end
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');