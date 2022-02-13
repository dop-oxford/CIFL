%%%
%
% This script calculate the peak signal intensity for the different array
% illumination basis by calling Q2_mod_peak_intensity.m. 
% The results are saved to a text file.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

% Load data and set parameters
load('Q1_PSF.mat');
algo = 0;% test 0, 1 and 2
arrayNum = [1,4,8,16,30,60,120,240,480];

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
Results = 'Results_Q2_algo0_array_peak.txt';
ID = fopen(Results,'a+');

%% Iterate over all images
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tAlgo\tNoise\tArray\tmax\n');
        fprintf([filenameSaving '\n']);
        obj = double(imread(Filename));
        for n = 1:length(arrayNum)
        
                output_img_H2 = output_img_H./arrayNum(n); % normalise total incident illumination power
                [ signal ] = Q2_mod_peak_intensity(obj, output_img_H2, N, input_num, 0, arrayNum(n));
                
                % Write results to file
                fprintf(ID,[filenameSaving '\t%10.0f\t%10.10f\t%10.0f\t%10.8f\n'], algo, 0, arrayNum(n), signal);
        end
    end
end
fclose(ID);
msgbox('Analysis Completed.','Iterative Processing Algorithm');