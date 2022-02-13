%%%
%
% Script to generate two-dimensional focus illumination.
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
input_dim = 49;
input_num = input_dim^2;

%% Calculate the transmission matrix and construct the illumination basis
[ T_HH ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
invT_HH = Tikinv( T_HH ); invT_HH = invT_HH/max(invT_HH(:));
output_img_H = reshape( abs(T_HH*invT_HH).^2, [N N N^2] );


clear T_HH T_HV T_VH T_VV mode_to_H mode_to_V H_to_mode V_to_mode ill_E output_img_V invT_HH

save('Q1_PSF.mat')