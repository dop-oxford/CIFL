%%%
%
% This scripts evaluates the mutual coherence u of the measurement basis A.
% It follows the formalism from Tagouti (Chapter 10, compressed sensing).
% For clarity, this calculation doesn't take into account the sparsity
% basis (psi) which relates exclusively to the signal of interest. The
% space is not transformed our analysis. This approach when minimising L1
% is suitable.
%
% N is the size of the space
% M is the size of the sampled space
% M << N
% A dimensions are [N, M].
%
% sqrt((N-M)/(M*(N-1))) <= u(A) <= 1. The smaller the better.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

clear

%% For u_array and u_foci
% Parameters for U_array and U_foci
load("Q1_PSF.mat");
ill = output_img_H;

%% For u_array
% Parameters for U1 only
arrayNum = [1,4,8,16,30,60,120,240,480];
u_array = zeros(length(arrayNum),1);
pe_array = zeros(length(arrayNum),1);

peak = [6.31454*10^17, 2.27976*10^17, 1.4448*10^17, 9.28304*10^16, 6.74826*10^16, 5.25565*10^16, 4.15042*10^16, 3.50071*10^16, 3.1294*10^16]./(6.31454*10^17);

% Calculate the mutual coherence of the measurement basis
% The function normalise with respect to column.
    for i = 1:length(arrayNum)
        % Determine sub-illumination
        [ill_update, input_num_new]  = Q2_array_gen(N, input_num, ill, arrayNum(i));
        meas_basis = reshape(ill_update, [N^2, input_num_new]);

        [u_array(i),pe_array(i)] = Q2b_mutual_coherence_pe(meas_basis, peak(i));
    end

%% For u_foci
% Determine sub-illumination
[ill_update]  = sub_ill(N, input_num, ill);
meas_basis = reshape(ill_update, [N^2, input_num]);

% Calculate the mutual coherence of the measurement basis
% The function normalise with respect to column.
[u_foci, Pe_w_foci] = Q2b_mutual_coherence_pe(meas_basis, 1);

%% For u_speckle
% Parameters for U_speckle
load("Q1-120-120-49.mat");
% Determine sub-illumination
% Normalise illumination accross algorithm (reference CSI_PSF)
load('normillum.mat');
output_img_H = output_img_H * csipsf_total / csicore_total; 

ill_update = output_img_H;
meas_basis = reshape(ill_update, [N^2, input_num]);
% Calculate the mutual coherence of the measurement basis
% The function normalise with respect to column.

fac = ( (8.80671*10^15) / (6.31454*10^17) );
[u_speckle, Pe_w_speckle] = Q2b_mutual_coherence_pe(meas_basis, fac );

% Calculate the minimal bound of A
min_bound = ((N^2-input_dim^2)/(input_dim^2*(N^2-1)))^0.5;
max_bound = 1;

%% Terminate script
clear A D i ill ill_update input_num input_num_new lambda Length inE
clear N NA output_img_H Rho Theta timeElapsed algo param obj noise
clear ans csi_total csipsf_total lr_total meas_basis

save