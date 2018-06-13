function W=RSPCA(x,rho,nPV)
% calculate projection vectors for RSPCA
% Input: 
%     x,   data
%     rho, tuning parameter
%     nPV, number of projection vectors
% Output: 
%     W,   the obtained projection vectors
% 
% 2018-4-23 18:33:56

lam=10^(-rho);
s=1; % set s as 1 since the script is adopted from GPCA
x=x'; % so that the following lines could be consistent with the 2DPCAL1-S
x0=x;
d=size(x,2);

% SVD/PCA as the initialization
[~,~,W0]=svd(x,0); 

% calculate multiple projection vectors
W=zeros(d,nPV);
for iPV=1:nPV
    w=W0(:,iPV);
    rsd=1;
    while rsd>1e-4
        fp=pnorm(x*w,s);
        
        v=s*x'*((abs(x*w).^(s-1)).*sign(x*w));
        
        % update rule
        w=v.*abs(w)./(lam+abs(w));
        w=w/norm(w);
        
        f=pnorm(x*w,s);
        rsd=abs(f-fp)/fp;
    end
    W(:,iPV)=w;
    
    x=x0*(eye(d)-W*W'); % deflating
end