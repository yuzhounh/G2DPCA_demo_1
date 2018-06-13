% calculate classfication accuracies for the four algorithms
% 2018-06-12

clear,clc,close all;

load sInfo.mat;

para_worker(nPar);
parfor iRho=1:nRho
    classify_RSPCA(iRho);
    classify_PCA2DL1S(iRho);
end

stat=[];
for iS=1:nS
    for iP=1:nP
        stat=[stat;iS,iP];
    end
end
n=size(stat,1);
fprintf('The number of tasks: %d. \n\n',n);
para_worker(nPar);
parfor i=1:n
    iS=stat(i,1);
    iP=stat(i,2);
    classify_GPCA(iS,iP);
    classify_G2DPCA(iS,iP);
end
