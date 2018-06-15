% plot the reconstruction results
% 2018-4-23 11:10:30

clear,clc;

figure;

load sInfo.mat;

err_RSPCA=zeros(nPV,nRho);
err_PCA2DL1S=zeros(nPV,nRho);
for iRho=1:nRho
    load(sprintf('result/reco_RSPCA_%s_iRho%d.mat',FaceDB,iRho));
    err_RSPCA(:,iRho)=err;
    
    load(sprintf('result/reco_PCA2DL1S_%s_iRho%d.mat',FaceDB,iRho));
    err_PCA2DL1S(:,iRho)=err;
end

subplot(2,2,4);
plot([-3:0.1:3],mean(err_RSPCA,1),'-o');
title('RSPCA');
xlabel('\rho');
ylabel('Reconstruction error');

subplot(2,2,2);
plot([-3:0.1:3],mean(err_PCA2DL1S,1),'-o');
title('PCA2DL1S');
xlabel('\rho');
ylabel('Reconstruction error');

err_GPCA=zeros(nPV,nS,nP);
err_G2DPCA=zeros(nPV,nS,nP);
for iS=1:nS
    for iP=1:nP
        load(sprintf('result/reco_GPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP));
        err_GPCA(:,iS,iP)=err;
        
        load(sprintf('result/reco_G2DPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP));
        err_G2DPCA(:,iS,iP)=err;
    end
end

err_GPCA=reshape(mean(err_GPCA,1),[nS,nP]);
err_G2DPCA=reshape(mean(err_G2DPCA,1),[nS,nP]);

subplot(2,2,3);
imagesc(err_GPCA');
title('GPCA');
xlabel('iS');
ylabel('iP'); 
colorbar;
colormap(jet);

subplot(2,2,1);
imagesc(err_G2DPCA');
title('G2DPCA');
xlabel('iS');
ylabel('iP'); 
colorbar;
colormap(jet);

% resize
pos=get(gcf,'Position'); 
scale=0.8; 
set(gcf,'Position',[pos(1),pos(2),pos(3)*scale*2,pos(4)*scale*2]);
