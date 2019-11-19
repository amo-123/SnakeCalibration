% Optimise Snakes 
% Optimise the 'SolidSnake' function to fit linearity calibration data 
%function [Xspline,Yspline,Xstart,Ystart]
tic;
%addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Linearity\London')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\XLin')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\YLin')

%addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Uniformity\UCdata')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\Uniformity')

%Data = output.Statistical_Counts;
%Data = Nd4_XLin;
% Determine snake start positions by peaks along the data
%addpath('Data')

load('Ldn_20190909_Tc99m_Flood_1p8Mbq_1325time_10min');
Udata = NodeData(:,:,15);
fn = 'Nd01SplineData_Lnd_20190909';
%load('Nd8XLin.mat')
load('Rec_bulmaraw_H15_X_20190909');
Xdata = output.Statistical_Counts;
%Xdata = NodeData;
%Xdata = Nd4_XLin;
%load('Nd8YLin.mat')
load('Rec_bulmaraw_H15_Y_20190909');
Ydata = output.Statistical_Counts;
%Ydata = NodeData;
%Ydata = Nd4_YLin;
direc = 'x';
DATA = Xdata;
%%
flt = 0.05; %change at bottom too
sigma = 1.9;
%%


for c = 1:2
    flag = 0;
    msk = maskData(DATA,flt,direc,Udata,1);
    [~,band,~] = peak19(msk,direc);
    
    dim = length(band);

    
    switch dim
        case 19
            %x = 22:28:478;
            x = 15:16:500;
            plim = 12;
            %band = band;
            Xx = x;
            targ = 3;
        case 41
            x = 8:12:250;
            plim = 12;
            %band = band;
            Yx = x;
            targ = 3;
    end
    
    
    %%
    h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
    %now run the fitting
    resmin = 200;
    figure;
    i = 1;
    while resmin > targ
        y = (rand(dim, length(x)) - 0.5)*0.1;
        if flag
            y = minY;
                h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.01);
%             plim = plim - 2;
%             if plim <= 0
%                 plim = 2;
%             end
        end
        [NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim);
        if RESNORM <= resmin
            resmin = RESNORM;
            minY = NewY;
            minBand = band;
            flag = 0;
            hold on;
            plot(i,RESNORM,'o');
            hold off;
        end
        hold on;
        plot(i,RESNORM,'x');
        hold off;
        i = i + 1; 
        if i > 5
            break
        end
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
    flt = 0.05;
    sigma = 1.9;
    
end
toc;


%%
save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

%clearvars;

