%% create Tfrom and save 

%% Load
% Mass load edit 

% addpath('.\Output');

folder = './Output';
files = dir(fullfile(folder,'*.mat'));
Xpath = '/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/DOI/AllEvents/UniEW/Xlinearity/';
Xfiles = dir(fullfile(Xpath,'*.mat'));
Ypath = '/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/DOI/AllEvents/UniEW/Ylinearity/';
Yfiles = dir(fullfile(Ypath,'*.mat'));
samp  = 1;

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'/'];

data = open([filepath,filename]);

Xfilename = Xfiles(i).name;
Xfilepath = [Xfiles(i).folder,'/'];

Xdata = open([Xfilepath,Xfilename]);

Yfilename = Yfiles(i).name;
Yfilepath = [Yfiles(i).folder,'/'];

Ydata = open([Yfilepath,Yfilename]);

imgX = reshape(cell2mat(Xdata.NodeData),[258,506]);
imgY = reshape(cell2mat(Ydata.NodeData),[258,506]);

imgX1 = imgX ;%(:,:,3) + imgX(:,:,4);
imgY1 = imgY ;%(:,:,3) + imgY(:,:,4);

    imgX1(:,1:18) = 0;
    imgX1(1:10,:) = 0;
    imgX1(:,502:end) = 0;
    imgX1(250:end,:) = 0;
    
    imgX1(1,:) = [];
    imgX1(end,:) = [];
    imgX1 = [zeros(256,3),imgX1,zeros(256,3)];

        imgY1(:,1:18) = 0;
    imgY1(1:10,:) = 0;
    imgY1(:,502:end) = 0;
    imgY1(250:end,:) = 0;
    
    imgY1(1,:) = [];
    imgY1(end,:) = [];
    imgY1 = [zeros(256,3),imgY1,zeros(256,3)];
    
figure;
%subplot(1,2,1);
imagesc(imgX1)
%xlim([0,258]);
%ylim([0,506]);
%daspect([1 1 1]);
for j = 1:19
    %lab = {int2str(j)};
    hold on;
    plot(data.Xx,data.Xspline(j,:),'r');
    %text(x(1),yc(i,1),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g');

end

figure;
imagesc(imgY1)
%xlim([0,258]);
%ylim([0,506]);
%daspect([1 1 1]);
for j = 1:41
    hold on;
    plot(data.Yspline(j,:),data.Yx,'r');
end


[tform, moving, fixed] = revolver(data.Xspline,data.Xx,data.Xdata,data.Yspline,data.Yx,data.Ydata,samp);

if i < 10
    fn = ['./Transforms/Tform_H0', int2str(i),'_Milan_DOI.mat'];
else
    fn = ['./Transforms/Tform_H', int2str(i),'_Milan_DOI.mat'];
end

save(fn,'tform','moving','fixed');

end