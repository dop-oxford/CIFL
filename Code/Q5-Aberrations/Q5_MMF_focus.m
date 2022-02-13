%%%
%
% Script to generate aberrated focus illumination.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% Define the fiber specification, geometry, and operating wavelength
lambda = 0.532e-6;                                                          % wavelength 
D = 50e-6;                                                                  % fiber core diameter
NA = 0.22;                                                                  % NA of fiber
Length = 1;                                                                 % total length of MMF
Rho = inf;                                                                  % radius of curvature of the bending (m)
Theta = 0;                                                                  % orientation of the bending projected on x-y plane
N = 120;                                                                 
input_dim = 49;
input_num = input_dim^2;

%% Calculate the transmission matrix
[ T_HH ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
invT_HH = Tikinv( T_HH ); invT_HH = invT_HH/max(invT_HH(:)); % calculate the inverse of the TM
output_img_E = reshape( T_HH*invT_HH, [N N N^2] ); % calculate distal E field and reshape it
output_img_E = sub_ill(N, input_num, output_img_E); % select a subsection of the illumination

clear invT_HH T_HH

%% Distal aberration simulation
Mag = [0, 0.1, 1, 10, 30, 50, 70, 100, 1000, 10000];
for ii = 1:length(Mag)
    ii
    [output_img_E2, output_img_E_abn, w_error] = Q5_add_Abn(output_img_E, Mag(ii));
    output_img_H = abs(output_img_E2).^2;
    output_img_H_abn = abs(output_img_E_abn).^2;
    output_img_H_abn = output_img_H_abn .* sum(sum(sum(output_img_H)))/sum(sum(sum(output_img_H_abn)));
    clear T_HH_new output_img_E2 output_img_E_abn
    savename = strcat('Q5_Focus_Mag_', num2str(Mag(ii)), '.mat');
    save(savename)
    
end
save