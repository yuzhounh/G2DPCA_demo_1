function reco_G2DPCA(iS,iP)
% Calculate the reconstruction error of G2DPCA. 
% 2018-4-23 18:33:56

tic;

load sInfo.mat;
fprintf('reco_G2DPCA(%s,%d,%d)\n\n',FaceDB,iS,iP);

load(sprintf('data/%s_noise.mat',FaceDB));
x_mean=mean(x_noise,3);
x_centered=x_noise-repmat(x_mean,[1,1,nImg]);

s=sS(iS);
p=sP(iP);

W=G2DPCA(x_centered,s,p,nPV);
t0=toc;

err=zeros(nPV,1);
tic;
for iPV=1:nPV
    w=W(:,1:iPV);
    
    x_reco=zeros(size(x_noise));
    for iImg=1:nImg
        x_reco(:,:,iImg)=x_centered(:,:,iImg)*w*w'+x_mean;
    end
    temp=x_noise-x_reco;
    
    rsd=0;
    for iImg=nImg/5+1:nImg % only count the differences of normal faces, not all. 1:165
        rsd=rsd+norm(temp(:,:,ix_noise(iImg)),'fro');
    end
    err(iPV)=rsd/(nImg/5*4);
    
    perct(toc,iPV,nPV);
end
time=(t0+toc)/60;
save(sprintf('result/reco_G2DPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP),'err','time');
