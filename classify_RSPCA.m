function classify_RSPCA(iRho)
% Calculate the classification accuracy of RSPCA. 
% 2018-4-23 18:33:36

load sInfo.mat;
fprintf('classify_RSPCA(%s,%d)\n\n',FaceDB,iRho);
load(sprintf('data/%s.mat',FaceDB));

% reshape 2D images to vectors
x=reshape(x,[height*width,nImg]);

accuracy=zeros(nPV,nRep);
tic;
for iRep=1:nRep
    load(sprintf('data/%s_r%d.mat',FaceDB,iRep));
    ix_train=1-ix_test;
    
    ix_train=find(ix_train);
    ix_test=find(ix_test);
    
    num_train=length(ix_train);
    num_test=length(ix_test);
    
    x_train=x(:,ix_train);
    x_test=x(:,ix_test);
    
    label_train=label(ix_train);
    label_test=label(ix_test);
    
    % subtract the mean
    x_mean=mean(x_train,2);
    x_train=x_train-repmat(x_mean,[1,num_train]);
    x_test=x_test-repmat(x_mean,[1,num_test]);
    
    Rho=sRho(iRho);
    W=RSPCA(x_train,Rho,nPV); % RSPCA
    
    % reserve the result after projection
    x_train_reserve=W'*x_train;
    x_test_reserve=W'*x_test;
    
    for iPV=1:nPV
        x_train_proj=x_train_reserve(1:iPV,:);
        x_test_proj=x_test_reserve(1:iPV,:);
        
        % nearest neighbor classifier
        dxx=pdist2(x_train_proj',x_test_proj');
        [~,ix]=min(dxx);
        label_predict=label_train(ix);
        
        accuracy(iPV,iRep)=mean(label_predict==label_test);
    end
    perct(toc,iRep,nRep);
end
time=toc/60;
accuracy=mean(accuracy,2);
save(sprintf('result/classify_RSPCA_%s_iRho%d.mat',FaceDB,iRho),'accuracy','time');