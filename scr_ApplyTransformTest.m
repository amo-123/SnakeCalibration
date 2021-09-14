%% create corrected data 

clear all;
close all;
%% Load
% Mass load edit 

% addpath('.\Output');
Uflood = 0; % change to 1 to include U correction 
folder = uigetdir('/media/ashley/My Passport/DOI_Image_Proj/nonDOI/London/');

files = dir(fullfile(folder,'*.mat'));

%Tfolder = '/media/ashley/My Passport/Registration/SolidSnakes/Transforms/London/Tform/';
Tfolder = './Transforms/';
Tfiles = dir(fullfile(Tfolder,'*.mat'));
%%
if Uflood
%    Uniform = load('/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/XY/London/U/20191216/EventFilt/Corr_L20191216_Tc99m_Flood_0p75MBq_1350hrs_2min_01.mat');
%    Uniform = load('/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/XY/London/U/20191001/EventFilt/Corr_L20191001_Tc99m_ps_Flood_1p3Mbq_1135time_AllNode_10mins_01.mat');
    Uniform = load('/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/XY/London/U/20191015/EventFilt/Corr_L20191015_PS_Flood_Tc99m_noColl_1p88Mbq_1155time_5min_01.mat');

end

for i = 1:length(files)
% [filename,filepath] = uigetfile([pwd,'\',FilterSpec], 'Select .data file', 'MultiSelect', 'off');

filename = files(i).name;
filepath = [files(i).folder,'/'];

data = open([filepath,filename]);
    try 
    num_nod = size(data.NodeData,1);
    catch
    num_nod =1;
    end
    
XYCorrData = zeros(256,512,num_nod);
UCorrData = zeros(256,512,num_nod);

for j = 1:num_nod
    if num_nod <= 1
        if i <= 20
            Tfilename = Tfiles(i).name;
            Tfilepath = [Tfiles(i).folder,'/'];
        else
            Tfilename = Tfiles(i-20).name;
            Tfilepath = [Tfiles(i-20).folder,'/'];
        end
    else
        Tfilename = Tfiles(j).name;
        Tfilepath = [Tfiles(j).folder,'/'];
    end
    
    Tform = open([Tfilepath,Tfilename]);
    if ~isempty(data.NodeData{j})
       NodeData = data.NodeData{j};    
    else
        continue
    end 
    NodeData = squeeze(NodeData);
    
    NodeData(:,1:18) = 0;
    NodeData(1:10,:) = 0;
    NodeData(:,502:end) = 0;
    NodeData(250:end,:) = 0;
    
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

figure, for i = 1:num_nod, subplot(4,5,i), imagesc(squeeze(XYCorrData(:,:,i))'), daspect([1 1 1]), title(['Det ',int2str(i)]),end


fn = ['/media/ashley/My Passport/DOI_Image_Proj/UXYCorrected/XY/London/Corr_',filename(10:end)];
if Uflood
    save(fn,'XYCorrData','UCorrData');
else
    save(fn,'XYCorrData');
end
end