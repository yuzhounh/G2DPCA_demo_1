function reco_PCA2DL1S(iRho)
% Calculate the reconstruction error of 2DPCAL1-S. 
% 2018-4-23 18:33:56

tic;

load sInfo.mat;
fprintf('reco_PCA2DL1S(%s,%d)\n\n',FaceDB,iRho);

load(sprintf('data/%s_noise.mat',FaceDB));
x_mean=mean(x_noise,3);
x_centered=x_noise-repmat(x_mean,[1,1,nImg]);

Rho=sRho(iRho);
W=PCA2DL1S(x_centered,Rho,nPV);
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
    err(iPV,1)=rsd/(nImg/5*4); % there are (80%*n) faces calculated
    
    perct(toc,iPV,nPV);
end
time=(t0+toc)/60;
save(sprintf('result/reco_PCA2DL1S_%s_iRho%d.mat',FaceDB,iRho),'err','time');
