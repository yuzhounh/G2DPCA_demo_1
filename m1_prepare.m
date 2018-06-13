% preparation
% save the variables and paramters
% 2018-4-23 10:53:30 

clear,clc;

FaceDB='Feret'; % face database

if strcmp(FaceDB,'ORL')
    nSub=40; % 40 subjects
    nIS=10; % the number of images for each subject
    nImg=nSub*nIS; % the number of images for all subjects
    nTest=5; % choose 5 images from each subject for testing and the remaining images for training
elseif strcmp(FaceDB,'Feret')
    nSub=200;
    nIS=7;
    nImg=nSub*nIS; 
    nTest=4;
end

% repeat the experiment for 10 times
nRep=10;

% index
for iRep=1:nRep
    ix_test=[];
    for iSub=1:nSub
        ix_rand=randperm(nIS);
        tmp=zeros(nIS,1);
        tmp(ix_rand(1:nTest))=1;
        ix_test=[ix_test;tmp];
    end
    save(sprintf('data/%s_r%d.mat',FaceDB,iRep),'ix_test');
end

% size of the images
load(sprintf('data/%s.mat',FaceDB));
[height,width,~]=size(x);

% Rho, for RSPCA and 2DPCAL1-S
sRho=[-3.0:0.1:3.0];
nRho=length(sRho);

% s & p, for GPCA and G2DPCA
sS=[1.0:0.1:3.0];
nS=length(sS);

sP=[0.9:0.1:3.0];
nP=length(sP);

% number of projection vectors
sPV=[1:30];
nPV=length(sPV);

% number of parallel workers
import java.lang.*;
nCPU=Runtime.getRuntime.availableProcessors; % number of CPUs
nPar=floor(nCPU*0.95); % use 95% CPUs

% store the results of classification and reconstruction
mkdir('result');

save('sInfo.mat','FaceDB','nSub','nIS','nImg','nTest','nRep','height',...
    'width','sRho','nRho','sS','nS','sP','nP','sPV','nPV','nPar');
 