% plot the classification results
% 2018-4-23 11:10:30

clear,clc;

figure;

load sInfo.mat;

acc_RSPCA=zeros(nPV,nRho);
acc_PCA2DL1S=zeros(nPV,nRho);
for iRho=1:nRho
    load(sprintf('result/classify_RSPCA_%s_iRho%d.mat',FaceDB,iRho));
    acc_RSPCA(:,iRho)=accuracy;
    
    load(sprintf('result/classify_PCA2DL1S_%s_iRho%d.mat',FaceDB,iRho));
    acc_PCA2DL1S(:,iRho)=accuracy;
end

subplot(2,2,4);
plot([-3:0.1:3],mean(acc_RSPCA,1),'-o');
title('RSPCA');
xlabel('\rho');
ylabel('Accuracy');

subplot(2,2,2);
plot([-3:0.1:3],mean(acc_PCA2DL1S,1),'-o');
title('PCA2DL1S');
xlabel('\rho');
ylabel('Accuracy');

acc_GPCA=zeros(nPV,nS,nP);
acc_G2DPCA=zeros(nPV,nS,nP);
for iS=1:nS
    for iP=1:nP
        load(sprintf('result/classify_GPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP));
        acc_GPCA(:,iS,iP)=accuracy;
        
        load(sprintf('result/classify_G2DPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP));
        acc_G2DPCA(:,iS,iP)=accuracy;
    end
end

acc_GPCA=reshape(mean(acc_GPCA,1),[nS,nP]);
acc_G2DPCA=reshape(mean(acc_G2DPCA,1),[nS,nP]);

subplot(2,2,3);
imagesc(acc_GPCA');
title('GPCA');
xlabel('iS');
ylabel('iP'); 
colorbar;
colormap(jet);

subplot(2,2,1);
imagesc(acc_G2DPCA');
title('G2DPCA');
xlabel('iS');
ylabel('iP'); 
colorbar;
colormap(jet);

% resize
pos=get(gcf,'Position'); 
scale=0.8; 
set(gcf,'Position',[pos(1),pos(2),pos(3)*scale*2,pos(4)*scale*2]);
