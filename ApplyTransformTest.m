%% create corrected data 

%% Load
% Mass load 

% addpath('.\Output');

folder = uigetdir;
files = dir(fullfile(folder,'*.data'));
FilterSpec = '*.data';

for i = 1:length(files)

filename = files(i).name;
filepath = [files(i).folder,'\'];