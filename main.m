% the main script
% 2018-4-23 11:38:53

clear,clc;

m1_prepare;       % preparation
m1_add_noise;     % add noise to the face images
m2_reco;          % reconstruction
m2_classify;      % classification
m3_reco_plot;     % plot the reconstruction results
m3_classify_plot; % plot the classification results