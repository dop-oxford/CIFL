%%%
%
% This script generates intensity speckle at the distal MMF facet given
% different beding radius defined by k and kk. Rho = kk * 10^(-k)
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

%%
for k = 3
    for kk = 300:100:900
        
        lambda = 0.532e-6;                                                          % wavelength in air
        D = 50e-6;                                                                  % fiber core size
        NA = 0.22;                                                                  % NA of fiber
        N = 120;
        input_dim = 120;
        input_num = input_dim^2;
        Length = 1;
        Theta = 0;
        
        Rho = kk * 10^(-k);
        [ T_HH, ill_E ] = MMF_simTM_camera( lambda, D, NA, Length, Rho, Theta, N, input_num );
        
        inE = abs(reshape( ill_E, [N, N, input_num] )).^2;
        output_img_H = reshape(abs(T_HH).^2, [N N input_num]);
        
        clear T_HH ill_E
        input_num = 49^2;
        output_img_H = sub_ill(N, input_num, output_img_H);
        
        savename = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        save(savename)
    end
end

%%
for k = 2:3
    for kk = 1000
        
        lambda = 0.532e-6;                                                          % wavelength in air
        D = 50e-6;                                                                  % fiber core size
        NA = 0.22;                                                                  % NA of fiber
        N = 120;
        input_dim = 120;
        input_num = input_dim^2;
        Length = 1;
        Theta = 0;
        
        Rho = kk * 10^(-k);
        [ T_HH, ill_E ] = MMF_simTM_camera( lambda, D, NA, Length, Rho, Theta, N, input_num );
        
        inE = abs(reshape( ill_E, [N, N, input_num] )).^2;
        output_img_H = reshape(abs(T_HH).^2, [N N input_num]);
        
        clear T_HH ill_E
        input_num = 49^2;
        output_img_H = sub_ill(N, input_num, output_img_H);
        
        savename = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        save(savename)
    end
end

%%
for k = 2:3
    for kk = 5000
        
        lambda = 0.532e-6;                                                          % wavelength in air
        D = 50e-6;                                                                  % fiber core size
        NA = 0.22;                                                                  % NA of fiber
        N = 120;
        input_dim = 120;
        input_num = input_dim^2;
        Length = 1;
        Theta = 0;
        
        Rho = kk * 10^(-k);
        [ T_HH, ill_E ] = MMF_simTM_camera( lambda, D, NA, Length, Rho, Theta, N, input_num );
        
        inE = abs(reshape( ill_E, [N, N, input_num] )).^2;
        output_img_H = reshape(abs(T_HH).^2, [N N input_num]);
        
        clear T_HH ill_E
        input_num = 49^2;
        output_img_H = sub_ill(N, input_num, output_img_H);
        
        savename = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        save(savename)
    end
end

%%
for k = 0:4
    for kk = 2500
        
        lambda = 0.532e-6;                                                          % wavelength in air
        D = 50e-6;                                                                  % fiber core size
        NA = 0.22;                                                                  % NA of fiber
        N = 120;
        input_dim = 120;
        input_num = input_dim^2;
        Length = 1;
        Theta = 0;
        
        Rho = kk * 10^(-k);
        [ T_HH, ill_E ] = MMF_simTM_camera( lambda, D, NA, Length, Rho, Theta, N, input_num );
        
        inE = abs(reshape( ill_E, [N, N, input_num] )).^2;
        output_img_H = reshape(abs(T_HH).^2, [N N input_num]);
        
        clear T_HH ill_E
        input_num = 49^2;
        output_img_H = sub_ill(N, input_num, output_img_H);
        
        savename = strcat('Q4_speck_kk_', num2str(kk), '_k', num2str(k),'.mat');
        save(savename)
    end
end