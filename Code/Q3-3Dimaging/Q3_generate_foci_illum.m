%%%
%
% Script to generate three-dimensional focus illumination.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Define the fiber specification, geometry, and wavelength
lambda = 0.930e-6;                                                          % wavelength [m]
D = 50e-6;                                                                  % fiber core diameter [m]
NA = 0.37;                                                                  % NA of fiber
Length = 1;                                                                 % total length of MMF
Rho = inf;                                                                  % radius of curvature of the bending (m)
Theta = 0;                                                                  % orientation of the bending projected on x-y plane
N = 120;                                                                 
input_dim = 49;
input_num = input_dim^2;

%% Calculate the transmission matrix and construct the illumination basis
[ T_HH ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
invT_HH = Tikinv( T_HH ); invT_HH = invT_HH/max(invT_HH(:));

output_E_ill_facet = reshape(T_HH*invT_HH, [N N N N] );
output_E_ill_facet = output_E_ill_facet(N/3:2*N/3-1,N/3:2*N/3-1,N/3:2*N/3-1,N/3:2*N/3-1);
output_E_ill_facetA = reshape(output_E_ill_facet(:,:,1:2:end, 2:2:end), [(N/3)^2 (N/6)^2] );
output_E_ill_facetB = reshape(output_E_ill_facet(:,:,2:2:end, 1:2:end), [(N/3)^2 (N/6)^2] );
output_E_ill_facet = reshape([output_E_ill_facetA, output_E_ill_facetB],[N/3, N/3, 2*(N/6).^2]);

Nsmall = N/3;

clear T_HH invT_HH output_E_ill_facetB output_E_ill_facetA
save('Q3_foci_illum_120_NA37.mat');