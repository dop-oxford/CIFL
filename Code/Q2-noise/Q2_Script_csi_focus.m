%%%
%
%	Script to iterate the analysis done in Q2_mod_csi_focus_algo.m over all
%	image files in a chosen folder. The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Load data and set parameters
load("Q1_PSF.mat");
noise = [0, 1e-14, 1e-13, 1e-12, 1e-11, 1e-10, 1e-9, 1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3];
algo = 0;% test 0 or 1
arrayNum = [1,4,8,16,30,60,120,240,480];


% obj = double(imread('beads_density10_num6.tif'));
% [ imageRec, R , optim_info] = Q2_mod_csipsf_algo(obj, output_img_H2, N, input_num, 0, algo, arrayNum);

%% Select image data set
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
Results = 'Results_Q2_algo0_array_R.txt';
ID = fopen(Results,'a+');

%% Iterate over all images
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tAlgo\tNoise\tArray\tCorrCoef\tIter\n');
        for n = 1:length(arrayNum)
            obj = double(imread(Filename));
            for k = 1:length(noise)
                fprintf([filenameSaving '\n']);
                
                output_img_H2 = output_img_H/arrayNum(n);
                [ imageRec, R , iter] = Q2_mod_csi_focus_algo(obj, output_img_H2, N, input_num, noise(k), algo, arrayNum(n));
                fprintf('%10.8f\n', R(2,1));
                
                % % Saving the images
                % s = strcat('Output\CSIPSFnorm\',filenameSaving(1:end-4),'_algo',num2str(algo),'_noise',num2str(k),'_array',num2str(arrayNum),'_CSIPSF.tif');
                % image = uint8(255*imageRec/max(max(imageRec)));
                % saveastiff(image, s);
                
                fprintf(ID,[filenameSaving '\t%10.0f\t%10.10f\t%10.0f\t%10.8f\t%10.0f\n'], algo, noise(k)*10^14, arrayNum(n), R(2,1), iter);
            end
        end
    end
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');