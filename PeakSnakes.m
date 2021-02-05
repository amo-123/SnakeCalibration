% Non optimisation 


Xpath = 'E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\RsynchFiles\MEW\';
Ypath = 'E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\RsynchFiles\MEW\';
Uxpath = 'E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\RsynchFiles\20190911\U\';
Uypath = 'E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\RsynchFiles\20190909\U\';

XfileNo = 7;
YfileNo = 6;
UxfileNo = 2;
UyfileNo = 1;
NodeN = 17;


addpath(Xpath);
addpath(Ypath);
addpath(Uxpath);
addpath(Uypath);
samp  = 1;

fn = ['.\Transforms\London\Tform\Tform_H', int2str(NodeN),'_1samp_London.mat'];

fnRaw = ['.\Transforms\London\LinData\LinData_H', int2str(NodeN),'_London.mat'];

Xfiles = dir(fullfile(Xpath,'*.mat'));
Xfile = Xfiles(XfileNo).name;
load(Xfile);
%Xdata = output.Statistical_Counts;
Xdata = NodeData;
%load('Rec_bulmaraw_H09_Y_20191127');
%Ydata = output.Statistical_Counts;
Yfiles = dir(fullfile(Ypath,'*.mat'));
Yfile = Yfiles(YfileNo).name;
load(Yfile);
Ydata = NodeData;
direc = 'x';
%DATA = Xdata;

% figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(1,2,1);
% imagesc(Xdata');
% subplot(1,2,2);
% imagesc(Ydata');


Uxfiles = dir(fullfile(Uxpath,'*.mat'));
Uxfile = Uxfiles(UxfileNo).name;
load(Uxfile);
Uxdata = NodeData(:,:,NodeN);

Uyfiles = dir(fullfile(Uypath,'*.mat'));
Uyfile = Uyfiles(UyfileNo).name;
load(Uyfile);
Uydata = NodeData(:,:,NodeN);


%%
XxOrig = 17:15:493;

YxOrig = 7:15:255;
%%
flt = 0.06; %change at bottom too
Xmsk = maskData(Xdata,flt,direc,Uxdata,0);

[Xx,Xspline] = peak19(Xmsk,direc,XxOrig);
%%
[~,~] = ocelot(Xspline,Xx,Xmsk,1,1);

%%

flt = 0.07;
Ymsk = maskData(Ydata,flt,'y',Uydata,0);

[Yx,Yspline] = peak19(Ymsk,'y',YxOrig);
%%
[~,~] = ocelot(Yspline,Yx,Ymsk,1,1);

%%

fn = ['.\Transforms\London\Tform\Tform_H', int2str(NodeN),'_1samp_London.mat'];

fnRaw = ['.\Transforms\London\LinData\LinData_H', int2str(NodeN),'_London.mat'];

save(fnRaw,'Xspline','Xx','Xdata','Yspline','Yx','Ydata');


[tform, moving, fixed] = revolver(Xspline,Xx,Xdata,Yspline,Yx,Ydata,samp);
figure, imagesc(imwarp(Xdata,tform, 'OutputView', imref2d(size(Xdata))))
figure, imagesc(imwarp(Ydata,tform, 'OutputView', imref2d(size(Ydata))))
%%

save(fn,'tform','moving','fixed');
