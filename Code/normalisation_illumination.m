%%% For the noise analysis to be correct, we must ensure that the same 
% number of photons is incident on each object, regardless of the
% illumination strategy
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%
clear
%% CSI speckle
load("Q1-120-49.mat"); % load the data
csi_total = sum(sum(sum(output_img_H(:,:,:)))); % integrate the illumination

%% CSI speckle
load("Q1-120-120-49.mat"); % load the data
csicore_total = sum(sum(sum(output_img_H(:,:,:)))); % integrate the illumination

%% LR deconvolution
load('Q1_PSF.mat');% load the data
imagePSF = output_img_H(:,:,120*60+60); % select PSF for deconvolution
imagePSF = imagePSF*N*N; % correct for the number of usage
lr_total = sum(sum(imagePSF)); % integrate the illumination

%% CSI PSF
illumination = sub_ill(N, input_num, output_img_H); % select the illumination PSFs
csipsf_total = sum(sum(sum(illumination))); % integrate the illumination

clear D illumination imagePSF inE input_dim input_num lambda ans
clear Length N NA Rho Theta timeElapsed output_img_H param noise obj algo

save