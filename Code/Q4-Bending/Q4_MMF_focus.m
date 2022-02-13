%%%
%
% This script generates focus illumination at the distal MMF facet given
% different beding radius defined by k and kk. Rho = kk * 10^(-k)
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%% define the fiber specification, geometry, and operating wavelength
lambda = 0.532e-6;                                                          % wavelength in air
D = 50e-6;                                                                  % fiber core size
NA = 0.22;                                                                  % NA of fiber
Length = 1;                                                                 % total length of MMF
Rho = inf;                                                                  % radius of curvature of the bending (m)
Theta = 0;                                                                  % orientation of the bending projected on x-y plane
N = 120;
input_dim = 49;
input_num = input_dim^2;

%% Straight fibre inverse
[ T_HH ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
invT_HH = Tikinv( T_HH ); invT_HH = invT_HH/max(invT_HH(:));
clear T_HH

%% Bent fibre simulation
% for k = 0:4
%     Rho = 2500 * 10^(-k);
%     [ T_HH_new ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
%     output_img_H_bent = reshape( abs(T_HH_new*invT_HH).^2, [N N N^2] );
%     
%     clear T_HH_new
%     savename = strcat('Q4_Foci_2500_', num2str(k), '.mat');
%     save(savename)
% end

% for k = 2:3
%     Rho = 5000 * 10^(-k);
%     [ T_HH_new ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
%     output_img_H_bent = reshape( abs(T_HH_new*invT_HH).^2, [N N N^2] );
%     
%     clear T_HH_new
%     savename = strcat('Q4_Foci_5000_', num2str(k), '.mat');
%     save(savename)
% end

for k = 2:3
    Rho = 1000 * 10^(-k);
    [ T_HH_new ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
    output_img_H_bent = reshape( abs(T_HH_new*invT_HH).^2, [N N N^2] );
    
    clear T_HH_new
    savename = strcat('Q4_Foci2_1000_', num2str(k), '.mat');
    save(savename)
end

for k = 3
    for kk = 300:100:500
    Rho = kk * 10^(-k);
    [ T_HH_new ] = MMF_simTM_camera_PSF( lambda, D, NA, Length, Rho, Theta, N, input_num );
    output_img_H_bent = reshape( abs(T_HH_new*invT_HH).^2, [N N N^2] );
    
    clear T_HH_new
    savename = strcat('Q4_Foci2_kk_', num2str(kk), '_k', num2str(k), '.mat');
    save(savename)
    end
end
