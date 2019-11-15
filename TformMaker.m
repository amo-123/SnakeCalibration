%% create Tfrom and save 

%% Load
% Mass load edit 

% addpath('.\Output');

folder = '.\Output';
files = dir(fullfile(folder,'*.mat'));

samp  = 1;

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'\'];

data = open([filepath,filename]);


[tform, moving, fixed] = revolver(data.Xspline,data.Xx,data.Xstart,data.Xdata,data.Xplim,data.Yspline,data.Yx,data.Ystart,data.Ydata,data.Yplim,samp);

if i < 10
    fn = ['.\Transforms\Tform_H0', int2str(i),'_0p1samp_Milan_BF.mat'];
else
    fn = ['.\Transforms\Tform_H', int2str(i),'_0p1samp_Milan_BF.mat'];
end

save(fn,'tform','moving','fixed');

end