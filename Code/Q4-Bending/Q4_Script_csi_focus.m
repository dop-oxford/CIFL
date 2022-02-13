%%%
%
% Script to iterate the analysis done in Q4_mod_csi_focus_algo.m over 
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
Results = 'Results_Q4_bent_foci_algo1.txt';
ID = fopen(Results,'a+');

%Parameters for straight fibre
load("Q1_PSF.mat");

algo = 1; % 0 or 1

%% Iterate over all images
for i = 1:length(fileList)
    Filename = char(fileList(i));
    if contains(Filename, 'tif')
        filenameSaving = fileList2{i};
        fprintf(ID,'Name\tAlgo\tNoise\tArray\tCorrCoef\tIter\tTime\n');
        obj = double(imread(Filename));
        
        %%
        for k = 0:4
            
            %Parameters for bent fibre
            openname = strcat('Q4_Foci_2500_', num2str(k), '.mat');
            load(openname);
            value = k;
            
            fprintf([filenameSaving '\n']);
            [ imageRec, R_bent, iter ] =   Q4_mod_csi_focus_algo(obj, output_img_H, output_img_H_bent, N, input_num, 0, algo);
            fprintf('%10.8f\n', R_bent(2,1));
            
%             %Saving the images
%             s = strcat('Output/Q4-foci-algo-',num2str(algo),'/',filenameSaving(1:end-4),'_bent_2500',num2str(value),'_foci.tif');
%             image = uint8(255*imageRec/max(max(imageRec)));
%             saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.10f\t%10.10f\t%10.0f\t' '2500\n'], value, R_bent(2,1), iter);
            
        end
        
        %%
        for k = 2:3
            
            %Parameters for bent fibre
            openname = strcat('Q4_Foci_5000_', num2str(k), '.mat');
            load(openname);
            value = k;
            
            fprintf([filenameSaving '\n']);
            [ imageRec, R_bent, iter ] =   Q4_mod_csi_focus_algo(obj, output_img_H, output_img_H_bent, N, input_num, 0, algo);
            fprintf('%10.8f\n', R_bent(2,1));
            
%             %Saving the images
%             s = strcat('Output/Q4-foci-algo-',num2str(algo),'/',filenameSaving(1:end-4),'_bent_5000',num2str(value),'_foci.tif');
%             image = uint8(255*imageRec/max(max(imageRec)));
%             saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.10f\t%10.10f\t%10.0f\t' '5000\n'], value, R_bent(2,1), iter);
        end
        
        %%
        for k = 2:3
            
            %Parameters for bent fibre
            openname = strcat('Q4_Foci2_1000_', num2str(k), '.mat');
            load(openname);
            value = k;
            
            fprintf([filenameSaving '\n']);
            [ imageRec, R_bent, iter ] =   Q4_mod_csi_focus_algo(obj, output_img_H, output_img_H_bent, N, input_num, 0, algo);
            fprintf('%10.8f\n', R_bent(2,1));
            
%             %Saving the images
%             s = strcat('Output/Q4-foci-algo-',num2str(algo),'/',filenameSaving(1:end-4),'_bent_1000',num2str(value),'_foci.tif');
%             image = uint8(255*imageRec/max(max(imageRec)));
%             saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.10f\t%10.10f\t%10.0f\t' '1000\n'], value, R_bent(2,1), iter);
        end
        
        for kk = 300:100:500
            
            %Parameters for bent fibre
            openname = strcat('Q4_Foci2_kk_', num2str(kk), '_k3.mat');
            load(openname);
            k = 3;
            fprintf([filenameSaving '\n']);
            [ imageRec, R_bent, iter ] =   Q4_mod_csi_focus_algo(obj, output_img_H, output_img_H_bent, N, input_num, 0, algo);
            fprintf('%10.8f\n', R_bent(2,1));
            
%             %Saving the images
%             s = strcat('Output/Q4-foci-algo-',num2str(algo),'/',filenameSaving(1:end-4),'_bent_kk',num2str(kk),'_foci.tif');
%             image = uint8(255*imageRec/max(max(imageRec)));
%             saveastiff(image, s);
            
            fprintf(ID,[filenameSaving '\t%10.0f\t%10.10f\t%10.0f\t%10.0f\t' '1000\n'], k, R_bent(2,1), iter, kk);
        end
    end
end

fclose(ID);
