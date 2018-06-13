% add noise on face images
% 2018-4-23 18:33:56

clear,clc,close all;
load sInfo.mat;

load(sprintf('data/%s.mat',FaceDB));
x_org=x;
[height,width,nImg]=size(x);
ix_noise=randperm(nImg);
p=nImg*20/100; % add noise to 20% of all faces locating at a random position
m=randi([20,height],p,1); % noise height >= 20
n=randi([20,width],p,1); % noise width >= 20
for i=1:p
    noise=255*randi([0,1],[m(i),n(i)]);
    posh=randi([1,height-m(i)+1]); % height, positon of noise in y axis
    posw=randi([1,width-n(i)+1]); % width, position of noise in x axis
    % ix_noise(i) is the index of a face which is merged with noise
    x(posh:posh+m(i)-1, posw:posw+n(i)-1, ix_noise(i))=noise;
end
x_noise=x;
save(sprintf('data/%s_noise',FaceDB),'x_noise','ix_noise');

% % display
% figure;
% montage(reshape(x_org,height,width,1,nImg),'DisplayRange',[]);
% 
% figure;
% montage(reshape(x,height,width,1,nImg),'DisplayRange',[]);