% Optimise Snakes 
% Optimise the 'SolidSnake' function to fit linearity calibration data 
%function [Xspline,Yspline,Xstart,Ystart]
tic;
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Linearity\Milan')

addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Uniformity\UCdata')

%Data = output.Statistical_Counts;
%Data = Nd4_XLin;
% Determine snake start positions by peaks along the data
%addpath('Data')

load('Full_Rec_5ml1Mbq_Tc99m_flood_Tm10_hv35_gain12_th30_all_long_00');
Udata = NodeData(:,:,1);
fn = 'Nd01SplineData_Milan_UCtst';
%load('Nd8XLin.mat')
load('LinX_det10sep');
%Xdata = output.Statistical_Counts;
Xdata = NodeData;
%Xdata = Nd4_XLin;
%load('Nd8YLin.mat')
load('LinY_det10sep');
%Ydata = output.Statistical_Counts;
Ydata = NodeData;
%Ydata = Nd4_YLin;
direc = 'x';
DATA = Xdata;
%%
flt = 0.1; %change at bottom too
sigma = 1.2;
%%


for c = 1:2
    flag = 0;
    msk = maskData(DATA,flt,direc,Udata,1);
    [~,band,~] = peak19(msk,direc);
    band = band-2;
    
    dim = length(band);

    
    switch dim
        case 19
            %x = 22:28:478;
            x = 15:20:500;
            plim = 12;
            
            Xx = x;
        case 41
            x = 8:17:250;
            plim = 12;
            
            Yx = x;
    end
    
    
    %%
    h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.05);
    %now run the fitting
    resmin = 4e+06;
    figure;
    
    for i= 1:5
        y = ones(dim, length(x)).*rand;
        if flag
            y = minY;
            plim = plim - 1; 
        end
        [NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk*10,sigma,0,plim);
        if RESNORM <= resmin
            resmin = RESNORM;
            minY = NewY;
            minBand = band;
            flag = 1;
        end
        hold on;
        plot(i,RESNORM,'x');
        hold off;
    end
    SolidSnake(minY,x,minBand,msk,sigma,4,plim);
    
    switch dim
        case 19
            Xspline = minY;
            Xstart = band;
            Xplim = plim;
        case 41
            Yspline = minY;
            Ystart = band;
            Yplim = plim;
            
    end
    
    direc = 'y';
    DATA = Ydata;
    flt = 0.1;
    sigma = 1.2;
    
end
toc;


%%
save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

%clearvars;

