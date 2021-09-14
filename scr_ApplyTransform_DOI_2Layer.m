%% create corrected data 


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
    Uniform = load('/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/DOI/Milan/Corr_DOI_Rec_M20190306Uni_5ml1Mbq_Tc99m_flood_Tm10_hv35_gain12_th30_all_long_00.mat');
end

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'/'];
p = 20; 
data = open([filepath,filename]);

    try % Idenetify single or multiple nodes 
    img = reshape(cell2mat(data.NodeData),[258,506,4]);    
    num_nod = 1;
    catch
    num_nod = length(data.NodeData);
    
    end
XYCorrData = zeros(num_nod,256,512);
UCorrData = zeros(num_nod,256,512);

for j = 1:num_nod
    msk = ones(258,506);
    %msk(1:25,:) = 0;
    %msk(:,1:25) = 0;
    %msk(end - 24:end,:) = 0;
    %msk(:,end - 24:end) = 0;
    
    if num_nod == 1
            Tfilename = Tfiles(p).name;
            Tfilepath = [Tfiles(p).folder,'/']; % Order single node data into Node Order! 
            NodeData = (img(:,:,1)+img(:,:,2)+img(:,:,3) + img(:,:,4)).*msk;
    else
        Tfilename = Tfiles(j).name;
        Tfilepath = [Tfiles(j).folder,'/'];
        img = reshape(cell2mat(data.NodeData(j,:)),[258,506,4]);
        NodeData = (img(:,:,1)+img(:,:,2)+img(:,:,3) + img(:,:,4)).*msk; 
    end
    %figure(21);
    %t = tiledlayout(4,5,'TileSpacing','Compact','Padding','Compact'); 
     %   nexttile,
     %   plot((1:4),squeeze(sum(sum(img))));
        
    Tform = open([Tfilepath,Tfilename]);
    
    NodeData(:,1:18) = 0;
    NodeData(1:10,:) = 0;
    NodeData(:,502:end) = 0;
    NodeData(250:end,:) = 0;
    
    NodeData(1,:) = [];
    NodeData(end,:) = [];
    NodeData = [zeros(256,3),NodeData,zeros(256,3)];
       
    NodeData = squeeze(NodeData);
    
    XYCorr =  imwarp(NodeData,Tform.tform, 'OutputView', imref2d(size(NodeData)));
   
    XYCorrData(j,:,:) = XYCorr; 
    if Uflood
        if num_nod == 1
            tstUni = squeeze(Uniform.XYCorrData(p,:,:));
        else
            tstUni = squeeze(Uniform.XYCorrData(j,:,:));
        end
        tstUni(tstUni < (mean(mean(tstUni(15:243,28:495))))*0.5) =  0;
        nUni = tstUni./(mean(mean(tstUni(15:243,28:495))));
        nUni(nUni <0.01) = 1;
        UCorrData(j,:,:) = squeeze(XYCorrData(j,:,:))./nUni;
    end

end
XYCorrData = squeeze(XYCorrData);
UCorrData = squeeze(UCorrData);

fn = ['/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/DOI/Milan/Corr_',filename];
if Uflood
    save(fn,'XYCorrData','UCorrData');
else
    save(fn,'XYCorrData');
end
end