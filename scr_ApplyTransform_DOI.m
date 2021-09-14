%% create corrected data 
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
Cal.slt_msk = [zeros(16,240);Cal.slt_msk;zeros(16,240)];
Cal.slt_msk = [zeros(512,8),Cal.slt_msk,zeros(512,8)];
%Cal.slt_msk(466:end,:) = [];
%Cal.slt_msk = [zeros(26,240);Cal.slt_msk;zeros(15,240)];
%Cal.slt_msk = [zeros(506,9),Cal.slt_msk,zeros(506,9)];

comdat('set','Cal',Cal);

%% Load
% Mass load edit 

% addpath('.\Output');
Uflood = 1; % change to 1 to include U correction 
%folder = uigetdir('/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/DOI/AllEvents/UniEW/');
folder = uigetdir('/media/ashley/My Passport/DOI_Image_Proj/Milan/EventFilter/DOI/');
files = dir(fullfile(folder,'*.mat'));

Tfolder = './Transforms';
Tfiles = dir(fullfile(Tfolder,'*.mat'));
%%
if Uflood
    Uniform = load('/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/Corrected/DOI_2Layer/Milan/20190306/Flood/Correct_DOI_Rec_M20190306Uni_EW10_5ml1Mbq_Tc99m_flood_Tm10_hv35_gain12_th30_all_long_00.mat');
end

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'/'];
p = 20; 
%data = open([filepath,filename]);
prj = load_DOI_mat(filepath,filename);

%     try % Idenetify single or multiple nodes 
%     img = reshape(cell2mat(data.NodeData),[258,506,4]);    
%     num_nod = 1;
%     catch
%     num_nod = length(data.NodeData);
%     
%     end
XYCorrData = zeros(512,256, 4, 20);
UCorrData = zeros(512, 256, 4, 20);
%XYCorrData = zeros(506,258,4 ,20);
%UCorrData = zeros(506, 258,4 ,20);


for j = 1:prj.dim(end)
    %msk = ones(258,506);
    %msk(1:25,:) = 0;
    %msk(:,1:25) = 0;
    %msk(end - 24:end,:) = 0;
    %msk(:,end - 24:end) = 0;
    
    if prj.dim(end) == 1
            Tfilename = Tfiles(p).name;
            Tfilepath = [Tfiles(p).folder,'/']; % Order single node data into Node Order! 
            NodeData = prj.dat ; %img(:,:,3) + img(:,:,4)).*msk;
    else
        Tfilename = Tfiles(j).name;
        Tfilepath = [Tfiles(j).folder,'/'];
        %img = reshape(cell2mat(data.NodeData(j,:)),[258,506,4]);
        NodeData = prj.dat(:,:,:,j) ; %(img(:,:,3) + img(:,:,4)).*msk; 
    end
    %figure(21);
    %t = tiledlayout(4,5,'TileSpacing','Compact','Padding','Compact'); 
     %   nexttile,
     %   plot((1:4),squeeze(sum(sum(img))));
        
    
    Tform = open([Tfilepath,Tfilename]);
    translate_tform = affine2d([1 0 0; 0 1 0; 0 2 1]);

    
    for k = 1:4
    LayData = squeeze(NodeData(:,:,k)'); % Data must be shaped to 256x512 for Tform! 
    LayData(:,1:18) = 0;
    LayData(1:10,:) = 0;
    LayData(:,502:end) = 0;
    LayData(250:end,:) = 0;
    
    LayData(1,:) = [];
    LayData(end,:) = [];
    LayData = [zeros(256,3),LayData,zeros(256,3)];
    XYCorrData(:,:,k,j) =  imwarp(LayData(:,:),Tform.tform, 'OutputView', imref2d(size(LayData)))';
    
%    XYCorrData(:,:,j) = XYCorr'; 
    
    
%     XYCorrData(:,1:18,j) = 0;
%     XYCorrData(1:10,:,j) = 0;
%     XYCorrData(:,502:end,j) = 0;
%     XYCorrData(250:end,:,j) = 0;
%     
%     XYCorrData(1,:,:) = [];
%     XYCorrData(end,:,:) = [];
%     XYCorrData(:,:,j) = [zeros(256,3),XYCorrData(:,:,j),zeros(256,3)];
%     
%         tmp = prj;
%         tmp.dat = XYCorr';
%         tmp.dim = size(XYCorr');
%         DOICorrData(:,:,j) = DOI_corr(tmp,4);

    if Uflood
        if prj.dim(end) == 1
            tstUni = squeeze(Uniform.XYCorrData(p,:,:));
        else
            tstUni = squeeze(Uniform.XYCorrData(j,:,:));
        end
        tstUni(tstUni < (mean(mean(tstUni(15:243,28:495))))*0.5) =  0;
        nUni = tstUni./(mean(mean(tstUni(15:243,28:495))));
        nUni(nUni <0.01) = 1;
        UCorrData(:,:,k,j) = squeeze(XYCorrData(:,:,k,j))./nUni';

    end
    [mv,fx] = imwarp(UCorrData(:,:,k,j),translate_tform,'nearest','OutputView',imref2d(size(UCorrData(:,:,k,j))));
    UCorrData(:,:,k,j) = mv; 
    end

    
end

tmp = prj;
tmp.dat = flip(UCorrData,3);         
tmp.dim = size(UCorrData);
DOICorrData = DOI_corr(tmp,2);

XYCorrData = squeeze(XYCorrData);
UCorrData = squeeze(UCorrData);
DOICorrData = squeeze(DOICorrData);

Ucorr = prj;
Ucorr.xydat = XYCorrData;
Ucorr.udat = UCorrData;
Ucorr.dat = DOICorrData.dat;
Ucorr.dim = size(DOICorrData.dat);
fn = ['/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/Corrected/DOITransform/Corr_',filename];
if Uflood
    save(fn,'Ucorr');
else
    save(fn,'XYCorrData');
end
end