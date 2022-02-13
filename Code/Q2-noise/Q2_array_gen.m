function [ill_update, input_num] = Q2_array_gen(N, input_num, ill, arrayNum)
%%%
%
% This function selects a subset of the illumination and then duplicate foci
% at fixed position to generate a structured array.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

% Set a mask to get exactly input_num number of measurements
[xx,yy] = meshgrid((1:N)-N/2-0.5,(1:N)-N/2-0.5);
mask = zeros(N,N);
mask(1:2:end, 2:2:end) = 1;
mask(sqrt(xx.^2 + yy.^2) > (N/2-0.5)/1.076) = 0; % changed from 1.06 to 1.76 to get 2401 frames
sum(sum(mask));

% Transform the illumination matric into a vector
mask_vec = reshape(mask, [N^2, 1]);

% Generate aa list of non-zero indices 
mlist = zeros(input_num,1);
indx = 1;
for i = 1:N^2
    if mask_vec(i) == 1
        mlist(indx) = i;
        indx = indx + 1;
    end
end

% Select non-zero indices
ill_update_temp = ill(:,:,mlist);
ill_update_temp = ill_update_temp(:,:,1:(end-1));

input_num = input_num-1;

incr = input_num/arrayNum;

% pre-allocation
ill_update = zeros(N,N,input_num);

%% for N
for k= 0:(arrayNum-1)
    for i = 1:incr
        for j = 0:(arrayNum-1-k)     
            ill_update(:,:,i+k*incr) = ill_update(:,:,i+k*incr) + ill_update_temp(:,:,i+j*incr);
        end
    end
    if k ~= 0
        for i = 1:incr
            for j = 0:k-1

                ill_update(:,:,i+k*incr) =  ill_update(:,:,i+k*incr)+ill_update_temp(:,:,input_num-i-j*incr+1);
            end
        end
    end
end
