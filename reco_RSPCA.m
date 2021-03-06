function reco_RSPCA(iRho)
% Calculate the reconstruction error of RSPCA. 
% 2018-4-23 18:33:56

tic;

load sInfo.mat;
fprintf('reco_RSPCA(%s,%d)\n\n',FaceDB,iRho);

load(sprintf('data/%s_noise',FaceDB));
x_noise=reshape(x_noise,[height*width,nImg]);
x_mean=mean(x_noise,2);
x_centered=x_noise-repmat(x_mean,1,nImg);

Rho=sRho(iRho);
W=RSPCA(x_centered,Rho,nPV);
t0=toc;

err=zeros(nPV,1);
tic;
for iPV=1:nPV
    w=W(:,1:iPV);
    
    x_reco=zeros(size(x_noise));
    for iImg=1:nImg
        x_reco(:,iImg)=w*w'*x_centered(:,iImg)+x_mean;
    end
    temp=x_noise-x_reco;
    
    rsd=0;
    for iImg=nImg/5+1:nImg
        rsd=rsd+norm(temp(:,ix_noise(iImg)));
    end
    err(iPV)=rsd/(nImg*4/5);
    
    perct(toc,iPV,nPV);
end
time=(t0+toc)/60;
save(sprintf('result/reco_RSPCA_%s_iRho%d.mat',FaceDB,iRho),'err','time');
