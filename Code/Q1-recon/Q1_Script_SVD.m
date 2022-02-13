%%%
%
% This script iterates the analysis done in mod_svd_algo.m over
% all 2D image files in a chosen folder. The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Load illumination and other parameters
load('Q1_PSF.mat');% Load PSF
imagePSF = output_img_H(:,:,120*60+60);
imagePSF = imtranslate(imagePSF,[0, 1],'FillValues',0);

% Normalise illumination accross algorithm (reference CSI_PSF)
load('normillum.mat');
output_img_H = output_img_H * csipsf_total / lr_total;

%% Load PSF model
PSF = double(imread('Q1_PSF.tif'));
fCoeffMaps = ones(120,120);% Load coefficients

%%
%Parameters
noise = [0, 1e-17, 1e-16, 1e-15, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10];
param.modes = 1; % array of the number of eigen-PSFs to use for deconvolution
param.lambda = 0.002;
param.sigma = 1;
param.N = 120;
param.iteration = 9;
%% Testing section
% Comment this section for iterative analysis

% Load test image
% obj = double(imread('beads_density10_num6.tif'));

%Perform analysis
% [ imageRec, R , iter, time] = mod_svd_algo(obj, PSF, fCoeffMaps, noise(2), param);

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
Results = 'Results_deconvolution_norm.txt'; % Give a specific name
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
            [imageRec, R, iter, time] = mod_svd_algo(obj, PSF, fCoeffMaps, noise(k), param);
            %fprintf('%10.8f\n', R(2,1));
            
            %Saving the images
            s = strcat('Output/SVDnorm/',filenameSaving(1:end-4),'_noise',num2str(k),'_SVDnorm.tif');
            image = uint8(255*imageRec/max(max(imageRec)));
            saveastiff(image, s);
            nn = noise(k)*10^14;
            fprintf(ID,[filenameSaving '\tSVD\t%10.10f\t%10.8f\t%10.0f\t%10.4f\n'], nn, R(2,1), iter, time);
        end
    end
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');