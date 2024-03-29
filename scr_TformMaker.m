%% create Tfrom and save 

%% Load
% Mass load edit 

% addpath('.\Output');

folder = './Output/DOI';
files = dir(fullfile(folder,'*.mat'));

samp  = 1;

for i = 13%:20 %length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'/'];

data = open([filepath,filename]);


[tform, moving, fixed] = revolver(data.Xspline,data.Xx,data.Xdata,data.Yspline,data.Yx,data.Ydata,samp);

if i < 10
    fn = ['./Transforms/Tform_H0', int2str(i),'_Milan_DOI_02.mat'];
else
    fn = ['./Transforms/Tform_H', int2str(i),'_Milan_DOI_02.mat'];
end

save(fn,'tform','moving','fixed');

end