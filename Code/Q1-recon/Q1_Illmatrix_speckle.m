%%%
%
% Script to generate two-dimensional speckle illumination.
% The sub-illumination is sampled here to improve computational speed.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Define the fiber specification, geometry, and wavelength 
lambda = 0.532e-6;                                                          % wavelength in air
D = 50e-6;                                                                  % fiber core size
NA = 0.22;                                                                  % NA of fiber
Length = 1;                                                                 % total length of MMF
Rho = inf;                                                                  % radius of curvature of the bending (m)
Theta = 0;                                                                  % orientation of the bending projected on x-y plane
N = 120;                                                                 
input_dim = 120;
input_num = input_dim^2;

%% Calculate the transmission matrix and construct the illumination basis
[ T_HH, ill_E ] = MMF_simTM_camera( lambda, D, NA, Length, Rho, Theta, N, input_num );

inE = abs(reshape( ill_E, [N, N, input_num] )).^2;
output_img_H = reshape(abs(T_HH).^2, [N N input_num]);

clear T_HH ill_E

%% Select subillumination now for speed
input_num = 49^2;
output_img_H = sub_ill(N, input_num, output_img_H);

save('Q1-120-120-49.mat')