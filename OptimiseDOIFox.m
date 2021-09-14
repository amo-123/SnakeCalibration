% FoxDOI: DOI self optimisation 

clear all; 
close all;
Xpath = '/media/ashley/My Passport/DOI_Image_Proj/Milan/Calib/XCal/Det13/';
Ypath = '/media/ashley/My Passport/DOI_Image_Proj/Milan/Calib/YCal/Det13/';
%% 
addpath('/home/ashley/Documents/UCL/PhD_Year_3/DOI_Recon/DOI/');
addpath('/home/ashley/Documents/UCL/PhD_Year_3/DOI_Recon/Recon_2D/');

load('Geo','Geo')
Geo.objFoV(2) = 220;
%Geo.nPix = [480, 240];
comdat('set','Geo',Geo);

load('Cal','Cal')  
Cal.doi.n_lay = 4;
Cal.doi.lay_tkn = [1.5,1.5,1.5,3.5];
comdat('set','Cal',Cal);

% load('rec_par.mat','rec_par')
% rec_par.dim(1:2) = 220;
% rec_par.vox(1:2) = 1;
% rec_par.nIter = 90;
% comdat('set','rec_par',rec_par);
% 
% sys_mat('SM');

%%
fn = 'Nd13SplineData_MDOI';
NodeNum = 13;

Xfiles = dir(fullfile(Xpath,'*.mat'));
Xfile = Xfiles(2).name;
load([Xpath Xfile]);

NodeData = NodeData(~cellfun('isempty',NodeData));
Xdata = reshape(cell2mat(NodeData),258,506,4);

Yfiles = dir(fullfile(Ypath,'*.mat'));
Yfile = Yfiles(NodeNum).name;
load([Ypath Yfile]);

NodeData = NodeData(~cellfun('isempty',NodeData));
Ydata = reshape(cell2mat(NodeData),258,506,4);

for i =1:2
    if i == 1
        direc = 'x';
        DATA.dat = permute(Xdata, [2,1,3]);
    else
        direc = 'y';
        DATA.dat = permute(Ydata, [2,1,3]);
    end
    
    % figure('units','normalized','outerposition',[0 0 1 1]);
    % subplot(1,2,1);
    % imagesc(Xdata');
    % subplot(1,2,2);
    % imagesc(Ydata');
    %% DOI Correction 
    n_lay = 4;
    
    %prj = load_mat(fp,fn{j});
    %load([fp fn{j}]);
    %DATA.pix = Geo.pixSize;
    %prj.dat = squeeze(sum(reshape(prj.dat,480,240,8,2,20),3));
    %prj.dat = squeeze(sum(prj.dat,3));
    %prj.dat = cat(3,(sum(img.dat(:,:,1:5,:),3)), (sum(img.dat(:,:,6:10,:),3)), ...
     %    (sum(img.dat(:,:,11:16,:),3)));
    DATA.dim = [506,258,n_lay,1];
    DATA.vox = [0.2,0.2,0.5,1];
    
    [DATA,prj0] = DOI_corr( DATA, n_lay );
    
    %%

    
    flt = 0.1; %change at bottom too
    msk = maskData(DATA.dat,flt,[],0);
    
    switch direc
        case 'x'
            x = 17:5:493;
        case 'y'
            x = 12:5:247;
    end
    
    [x,y] = peak19(msk,direc,x);
    
    yorigin = y;
    dim = size(y,1);
    
    %[allsnakes,xx] = ocelot(y,x,DATA,1,1);
    srch = 2;
    step = 1;
    
    [~,~] = ocelot(y,x,msk,1,1);
    if i == 1
        Xspline = y;
        Xx = x;
    else
        Yspline = y;
        Yx = x;
    end
    
end

save(['./Output/',fn],'Xspline','Xx','Xdata','Yspline','Yx','Ydata');
