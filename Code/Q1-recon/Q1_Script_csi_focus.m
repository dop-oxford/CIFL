%%%
%
% This script iterates the analysis done in mod_csi_focus_algo.m over
% all 2D image files in a chosen folder. The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Load illumination and other parameters
load("Q1_PSF.mat");
%noise = [0, 1e-17, 1e-15, 1e-13, 1e-11, 1e-9, 1e-7, 1e-5, 1e-3];
%algo = 1;
noise = [0, 1e-17, 1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3];
algo = 0;

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
Results = 'Results_Q1_algo0_csi_focus.txt';
ID = fopen(Results,'a+');

%% Iterate and perform over all image file
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tAlgo\tNoise\tCorrCoef\tIter\tTime\n');

        obj = double(imread(Filename));
            for k = 1:length(noise)
                fprintf([filenameSaving '\n']);
                
                [ imageRec, R , iter, time] = mod_csi_focus_algo(obj, output_img_H, N, input_num, noise(k), algo);
                fprintf('%10.8f\n', R(2,1));
                
                %Saving the images
                s = strcat('Output/Q1-csi-focus-algo0/',filenameSaving(1:end-4),'_algo',num2str(algo),'_noise',num2str(k),'_CSIPSF.tif');
                image = uint8(255*imageRec/max(max(imageRec)));
                saveastiff(image, s);

                fprintf(ID,[filenameSaving '\t%10.0f\t%10.10f\t%10.8f\t%10.0f\t%10.4f\n'], algo, noise(k)*10^14, R(2,1), iter, time);
            end
    end    
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');