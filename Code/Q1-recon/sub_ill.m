function ill_update = sub_ill(N, input_num, ill)
%%%
%
% This function subsamples the illumination matrix to generate a compressed illumination.
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

%
mlist = zeros(input_num,1);
indx = 1;
for i = 1:size(ill,3)
    if mask_vec(i) == 1
        mlist(indx) = i;
        indx = indx + 1;
    end
    if indx > input_num
        break
    end
end

ill_update = ill(:,:,mlist);
