function W=GPCA(x,s,p,nPV)
% calculate projection vectors for GPCA
% Input: 
%     x,   data
%     s & p, tuning parameters
%     nPV, number of projection vectors
% Output: 
%     W,   the obtained projection vectors
% 
% 2018-4-23 18:33:23

% check
if s<1 || p<=0
    error('Please check s or p.');
end

x=x'; % so that the following lines could be consistent with the G2DPCA
x0=x;
d=size(x,2);

% SVD/PCA as the initialization
[~,~,W0]=svd(x,0); 

% calculate multiple projection vectors
W=zeros(d,nPV);
for iPV=1:nPV
    w=W0(:,iPV);
    w=w/pnorm(w,p);
    
    rsd=1;
    while rsd>1e-4
        fp=pnorm(x*w,s);
        
        v=s*x'*((abs(x*w).^(s-1)).*sign(x*w));
        if 0<p && p<1
            w=diag(abs(w.*w).^(1-p/2))*v;
            w=w/pnorm(w,p);
        elseif p==1
            [~,j]=max(abs(v)); % index of the largest absolute value in v
            w=zeros(d,1);
            w(j)=sign(v(j));
        elseif p<Inf
            q=p/(p-1);
            w=(abs(v).^(q-1)).*sign(v);
            w=w/pnorm(w,p);
        elseif p==Inf
            w=sign(v);
        end
        
        f=pnorm(x*w,s);
        rsd=abs(f-fp)/fp;
    end
    W(:,iPV)=w;
    
    x=x0*(eye(d)-W*W'); % deflating
end