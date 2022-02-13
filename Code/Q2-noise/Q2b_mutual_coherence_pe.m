function [u, Pe] = Q2b_mutual_coherence_pe(A,fac)
%%%
%
% This functionscomputes the mutual coherence a matrix and worst error probability
% Input:  a real or complex matrix with more than one column
% Ouput:  the mutual coherence and worst error probability
%
% Written by Dr. Yoash Levron, Technion, Israel, 2015
%
% largest magnitude of the normalized dot product between two columns of A
%
% Modified by Raphael Turcotte, 2021
% rturcotte861@gmail.com
%
%%%

[M N] = size(A);
if (N<2)
    disp('error - input contains only one column');
    u=NaN;   beep;    return    
end

% normalize the columns
nn = sqrt(sum(A.*conj(A),1));
if ~all(nn)
    disp('error - input contains a zero column');
    u=NaN;   beep;    return
end
nA = bsxfun(@rdivide,A,nn);  % nA is a matrix with normalized columns

uu = triu(abs((nA')*nA),1);

u = max(max(uu));
[row,col] = find(uu == u);

Ai = nA(:,col(1));
Aj = nA(:,row(1));

num1 = norm(Ai);
num2 = abs(Aj'*Ai);
den = norm( Ai*(Aj-Ai)'*Ai );
ARG = (num1^2-num2^2)/den;

nu = 10; % to be defined
M = size(A,2); % number of measurements
N = size(A,1); % number of elements (N > M)
C = sqrt(nu*M/N);

Pe = 1 - normcdf(ARG*C*fac);
end

