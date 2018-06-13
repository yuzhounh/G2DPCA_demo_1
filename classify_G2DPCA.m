function classify_G2DPCA(iS,iP)
% Calculate the classification accuracy of G2DPCA. 
% 2018-4-23 18:33:50

load sInfo.mat;
fprintf('classify_G2DPCA(%s,%d,%d)\n\n',FaceDB,iS,iP);
load(sprintf('data/%s.mat',FaceDB));

accuracy=zeros(nPV,nRep);
tic;
for iRep=1:nRep
    load(sprintf('data/%s_r%d.mat',FaceDB,iRep));
    ix_train=1-ix_test;
    
    ix_train=find(ix_train);
    ix_test=find(ix_test);
    
    num_train=length(ix_train);
    num_test=length(ix_test);
    
    x_train=x(:,:,ix_train);
    x_test=x(:,:,ix_test);
    
    label_train=label(ix_train);
    label_test=label(ix_test);
    
    % subtract the mean
    x_mean=mean(x_train,3);
    x_train=x_train-repmat(x_mean,[1,1,num_train]);
    x_test=x_test-repmat(x_mean,[1,1,num_test]);
   
    s=sS(iS);
    p=sP(iP);
    
    W=G2DPCA(x_train,s,p,nPV);
    
    % projection
    x_train_reserve=zeros(height,nPV,num_train);
    for iSub=1:num_train
        x_train_reserve(:,:,iSub)=x_train(:,:,iSub)*W;
    end
    
    x_test_reserve=zeros(height,nPV,num_test);
    for iSub=1:num_test
        x_test_reserve(:,:,iSub)=x_test(:,:,iSub)*W;
    end
    
    for iPV=1:nPV
        x_train_proj=x_train_reserve(:,1:iPV,:);
        x_test_proj=x_test_reserve(:,1:iPV,:);
        
        x_train_proj=reshape(x_train_proj,numel(x_train_proj)/num_train,num_train);
        x_test_proj=reshape(x_test_proj,numel(x_test_proj)/num_test,num_test);
        
        % nearest neighbor classifier
        dxx=pdist2(x_train_proj',x_test_proj');
        [~,ix]=min(dxx);
        label_predict=label_train(ix);
        
        accuracy(iPV,iRep)=mean(label_predict==label_test);
    end
    perct(toc,iRep,nRep);
end
accuracy=mean(accuracy,2);
time=toc/60;
save(sprintf('result/classify_G2DPCA_%s_iS%d_iP%d.mat',FaceDB,iS,iP),'accuracy','time');