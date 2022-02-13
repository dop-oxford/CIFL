function [ Illdef ] = focal_plane_shift(Ill, Z, NA, Px)
%%%
% 
% This function takes an input illumination and apply a fix amount of defocus. 
% It returns the defocus illumination.
%
% Inputs:
%   Ill: input illumination
%   Z: distance from the focal plane [um]
% 	NA: numerical aperture
%   Px: pixel size in pixel/um
% 
% Outputs:
%   Illdef: defocus illumination
%
% By Raphael Turcotte (2021)
% rturcotte861@gmail.com
%
%%%

% Working in the object space

% Calculate the defocus parameter A
A = Z * tan(asin(NA))*Px;

% Calculate the defocus function
[ h ] = defocus(A,Ill);

% Apply the defocus term in the object space using convolution
Illdef = imfilter(Ill,h,'conv');
Illdef = Illdef.*sum(sum(Ill))./sum(sum(Illdef));


function [ h ] = defocus(a,E)
x = (-size(E,1)/2:size(E,1)/2);
y = (-size(E,1)/2:size(E,1)/2);
z = ones(1,size(E,1)+1);

A1 = x' * z ;
A2 = z' * y ;

R = sqrt(A1.^2 + A2 .^ 2);
cond = a ./ (1); epsi = 3e-1;
c =  (.5 .* (1)./(a.^2+epsi)) .*  (R == cond);
d =         (1)./(a.^2+epsi)  .*  (R <  cond);
% note if R < a./(2.*pi)   then its zero

h = c + d;