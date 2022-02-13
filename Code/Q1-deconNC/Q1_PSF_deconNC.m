%%%
%
% Script to generate two-dimensional focus illumination.
% Pseudo-inverse calculation of the illumination matrix for basis pursuit 
% is also calculate and save to improve computational speed. It is not 
% calculated in the basis pursuit function.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Define the fiber specification, geometry, and wavelength
lambda = 0.532e-6;                                                          % wavelength [m]
D = 50e-6;                                                                  % fiber core size
NA = 0.22;                                                                  % NA of fiber
Length = 1;                                                                 % total length of MMF
Rho = inf;                                                                  % radius of curvature of the bending (m)
Theta = 0;                                                                  % orientation of the bending projected on x-y plane
N = 120;                                                                 
input_dim = 49;
input_num = input_dim^2;

%% Calculate the transmission matrix and construct the illumination basis
[ T_HH ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
invT_HH = Tikinv( T_HH ); invT_HH = invT_HH/max(invT_HH(:));
output_img_H = reshape( abs(T_HH*invT_HH).^2, [N N N^2] );

clear T_HH T_HV T_VH T_VV mode_to_H mode_to_V H_to_mode V_to_mode ill_E output_img_V invT_HH

%% Normalise illumination accross algorithm (reference CSI_PSF)
load('normillum.mat');
output_img_H = output_img_H * csipsf_total / lr_total;
clear csi_total csicore_total lr_total csipsf_total

%% Caulculate pseudo-inverse of the illumination matrix
A = reshape(output_img_H, [N^2, N^2]);
AAt = A*A';
pAAt = pinv(AAt);
P = eye(N^2) - A' * (pAAt * A);

clear A AAt

save('Q1_PSF_deconNC.mat')