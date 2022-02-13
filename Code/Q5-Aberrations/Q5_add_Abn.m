%%
%
% Function to add aberration to a given input field.
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%
function [outField, outFieldAbn, w_error] = Q5_add_Abn(output_img_H_new, Mag)
%%% Applied Aberration Function as a Combination of Zernike Modes
%%% output_img_H_new: output field at the distal end after wavefront
%%% shaping

N= size(output_img_H_new,1); %%% This dimension should match with the required original diemnsion%

nn = N;
[xx, yy] = meshgrid(-1:2/(nn-1):1, -1:2/(nn-1):1);
circ = (sqrt(xx.^2+yy.^2)<1);
i = sqrt(-1);
%-------------------------------------------------------------------------%
z4 = (sqrt(3).*(2.*(xx.^2+yy.^2)-1)); % Defocous
z5 = (sqrt(6).*(xx.^2-yy.^2)); % Astigmatism at +/-45
z6 = (2.*(sqrt(6).*xx.*yy)); % Astigmatism at 0 or 90
z7 = (sqrt(8).*(3.*(xx.^2+yy.^2)-2).*xx); % Primary X Coma
z8 = (sqrt(8).*(3.*(xx.^2+yy.^2)-2).*yy); % Primary Y Coma
z9 = (sqrt(8).*(xx.^3-3.*yy.^2.*xx)); % X-Trefoil
z10 = (sqrt(8).*(3.*xx.^2.*yy-yy.^3)); % Y-Trefoil
z11 = (sqrt(5).*(6.*(xx.^2+yy.^2).^2-6.*(xx.^2+yy.^2)+1)); % Primary Spherical
z12 = sqrt(10)*(4*(xx.^2+yy.^2)-3).*(xx.^2-yy.^2); %II nd Astigmatism at 45 degree
z13 = sqrt(10)*(4*(xx.^2+yy.^2)-3)*2.*xx.*yy; %IInd Astigmatism at 90 degree
z14 = sqrt(10)*(xx.^4+yy.^4-6*xx.^2.*yy.^2); % tetrafoil X
z15 = sqrt(10)*(4*xx.*yy.*(xx.^2-yy.^2));% tetrafoil Y
z16 = sqrt(12)*(10*(xx.^2+yy.^2).^2-12*(xx.^2+yy.^2)+3).*xx; % secondary X coma
z17 = sqrt(12)*(10*(xx.^2+yy.^2).^2-12*(xx.^2+yy.^2)+3).*yy;  % secondary Y coma
%-------------------------------------------------------------------------%


%% Applied Aberration Fuction
coeff = [0.5, -0.8, 0.6];
Phi = Mag.*(circ.*(coeff(1).*z5+coeff(2).*z6+coeff(3).*z9)); %%% We may consider other Zernike combinations %%%
%PhiN = (Mag.*((Phi - min(min(Phi)))./(max(max(Phi)) - min(min(Phi)))));
Ap = exp(1i*Phi/(2*pi));
w_error = sum(abs(coeff))*Mag;

%% Fibre Output Field (at the Distal End)


imgH = []; aPSF = [];

for ii = 1:size(output_img_H_new,3)
    aPSF (:,:,ii) = fftshift(fft2(output_img_H_new(:,:,ii), nn, nn)).*Ap;    
    outFieldAbn(:,:,ii)  = circ.*ifft2(fftshift(aPSF(:,:,ii)), nn, nn);

end

% close all
% figure('Position', [200, 200, 1000, 400]);
% 
% subplot(121)
% imagesc(abs(output_img_H_new(:,:,ii)).^2); colormap gray; axis image; axis off
% viscircles([N/2 N/2], 0.94*round(N/2), 'Color','w', 'LineStyle','-');
% 
% % subplot(132)
% % imagesc(circ.*aPSFN(:,:,ii)); colormap gray; axis image; axis off
% % viscircles([N/2 N/2], 0.94*round(N/2), 'Color','w', 'LineStyle','-');
% 
% subplot(122)
% imagesc(abs(outFieldAbn(:,:,ii)).^2); colormap gray; axis image; axis off
% viscircles([N/2 N/2], 0.94*round(N/2), 'Color','w', 'LineStyle','-');
% drawnow
% 
% %max(max(abs(outFieldAbn(:,:,ii)).^2))/max(max(abs(output_img_H_new(:,:,ii)).^2))
% corrcoef(abs(outFieldAbn(:,:,ii)).^2,abs(output_img_H_new(:,:,ii)).^2)

outField = output_img_H_new;
outFieldAbn = outFieldAbn;