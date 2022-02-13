function [z, k] = Q1_basis_pursuit_mod_deconNC(A, b, rho, alpha, P, pAAt)
% basis_pursuit  Solve basis pursuit via ADMM
%
% [x, history] = basis_pursuit(A, b, rho, alpha)
%
% Solves the following problem via ADMM:
%
%   minimize     ||x||_1
%   subject to   Ax = b
%
% The solution is returned in the vector x.
%
% history is a structure that contains the objective value, the primal and
% dual residual norms, and the tolerances for the primal and dual residual
% norms at each iteration.
%
% rho is the augmented Lagrangian parameter.
%
% alpha is the over-relaxation parameter (typical values for alpha are
% between 1.0 and 1.8).
%
% More information can be found in the paper linked at:
% http://www.stanford.edu/~boyd/papers/distr_opt_stat_learning_admm.html
%
% Modified 2021, Raphael Turcotte - NYU Langone Health

%%Global constants and defaults
QUIET = 0;
MAX_ITER =  3000;
ABSTOL   = 1e-4;
RELTOL   = 1e-2;

%%Data preprocessing
[m n] = size(A);

%%ADMM solver
x = zeros(n,1);
z = zeros(n,1);
u = zeros(n,1);

% if ~QUIET
%     fprintf('%3s\t%10s\t%10s\t%10s\t%10s\t%10s\n', 'iter', ...
%       'r norm', 'eps pri', 's norm', 'eps dual', 'objective');
% end

fprintf('Starting basis pursuit: calculation\n');

% precompute static variables for x-update (projection on to Ax=b)
% AAt = A*A';
% pAAt = pinv(AAt);
%P = eye(n) - A' * (pAAt * A);
q = A' * (pAAt * b);

fprintf('Starting basis pursuit: iteration\n');
for k = 1:MAX_ITER
    % x-update
    x = P*(z - u) + q;

    % z-update with relaxation
    zold = z;
    x_hat = alpha*x + (1 - alpha)*zold;
    z = shrinkage(x_hat + u, 1/rho);

    u = u + (x_hat - z);

    % diagnostics, reporting, termination checks
    history.objval  = objective(A, b, x);

    history.r_norm  = norm(x - z);
    history.s_norm  = norm(-rho*(z - zold));

    history.eps_pri = sqrt(n)*ABSTOL + RELTOL*max(norm(x), norm(-z));
    history.eps_dual = sqrt(n)*ABSTOL + RELTOL*norm(rho*u);

%     if ~QUIET
%         fprintf('%3d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%10.2f\n', k, ...
%             history.r_norm, history.eps_pri, ...
%             history.s_norm, history.eps_dual, history.objval);
%     end

    if (history.r_norm < history.eps_pri && ...
       history.s_norm < history.eps_dual)
         break;
    end
end
fprintf('Ending basis pursuit\n');

end

function obj = objective(A, b, x)
    obj = norm(x,1);
end

function y = shrinkage(a, kappa)
    y = max(0, a-kappa) - max(0, -a-kappa);
end