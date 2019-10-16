%% create corrected data 


%% Load
% Mass load edit 

% addpath('.\Output');
Uflood = 1; % change to 1 to include U correction 
folder = uigetdir;
files = dir(fullfile(folder,'*.mat'));

Tfolder = '.\Transforms\Samp0p1\';
Tfiles = dir(fullfile(Tfolder,'*.mat'));

if Uflood
    Uniform = load('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Corrected\Uniform\Correct_samp0p1_Full_Rec_5ml1Mbq_Tc99m_flood_Tm10_hv35_gain12_th30_all_long_00.mat');
end

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'\'];

data = open([filepath,filename]);

    try 
    num_nod = size(data.NodeData,3);
    catch
    num_nod =1;
    end
    
XYCorrData = zeros(256,512,num_nod);
UCorrData = zeros(256,512,num_nod);

for j = 1:num_nod
    Tfilename = Tfiles(j).name;
    Tfilepath = [Tfiles(j).folder,'\'];
    
    Tform = open([Tfilepath,Tfilename]);
    try
        NodeData = data.NodeData(:,:,j);
    catch
        NodeData = data.output.Statistical_Counts;
    end
    NodeData(1,:) = [];
    NodeData(end,:) = [];
    NodeData = [zeros(256,3),NodeData,zeros(256,3)];
    XYCorrData(:,:,j) =  imwarp(NodeData,Tform.tform, 'OutputView', imref2d(size(NodeData)));
    if Uflood
        tstUni = Uniform.XYCorrData(:,:,j);
        tstUni(tstUni < (mean(mean(tstUni(15:243,28:495))))*0.5) =  0;
        nUni = tstUni./(mean(mean(tstUni(15:243,28:495))));
        nUni(nUni <0.01) = 1;
        UCorrData(:,:,j) = XYCorrData(:,:,j)./nUni;
    end
end

fn = ['E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Corrected\Correct_samp0p1_',filename];
if Uflood
    save(fn,'XYCorrData','UCorrData');
else
    save(fn,'XYCorrData');
end
end