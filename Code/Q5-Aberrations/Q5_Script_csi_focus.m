%%%
%
% Script to iterate the analysis done in Q5_mod_csi_focus_algo.m over 
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
Results = 'Results_Q5_focus_algo0.txt';
ID = fopen(Results,'a+');

%% Select compressed sensing algorithm
algo = 0; % 0 or 1

%% Iterate over all images
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tMag\tR\n');
        obj = double(imread(Filename));
        
        Mag = [0, 0.1, 1, 10, 30, 50, 70, 100, 1000, 10000];
        for k = 1:length(Mag)
            k
            openname = strcat('Q5_Focus_Mag_', num2str(Mag(k)), '.mat');
            load(openname);
            
            fprintf([filenameSaving '\n']);
            [ imageRec, R ] = Q5_mod_csi_focus_algo(obj, output_img_H, output_img_H_abn , N, input_num, 0, algo);
            fprintf('%10.8f\n', R);
            
            Mag = [0, 0.1, 1, 10, 30, 50, 70, 100, 1000, 10000];
            fprintf(ID,[filenameSaving '\t%10.12f\t%10.12f\n'], Mag(k), R(2,1));
            
        end
    end
end

fclose(ID);
