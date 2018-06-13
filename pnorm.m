function y=pnorm(x,p)
% Lp-norm
% x, a vector
% p, a scalar
% 
% 2018-4-23 18:33:56

if p==0
    y=sum(x~=0);
elseif p==Inf
    y=max(abs(x));
else
    y=sum(abs(x).^p)^(1/p);
end