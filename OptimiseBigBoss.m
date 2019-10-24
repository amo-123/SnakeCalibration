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
fn = 'Nd10SplineData_Milan_UCtst';
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
    
    dim = length(band);

    
    switch dim
        case 19
            %x = 22:28:478;
            x = 15:16:500;
            plim = 12;
            band = band - 1;
            Xx = x;
            targ = 99;
        case 41
            x = 8:12:250;
            plim = 12;
            band = band - 5;
            Yx = x;
            targ = 99;
    end
    
    
    %%
    h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
    %now run the fitting
    resmin = 200;
    figure;
    i = 1;
    while resmin > targ
        y = ones(dim, length(x)).*rand;
        if flag
            y = minY;
                h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.01);
%             plim = plim - 2;
%             if plim <= 0
%                 plim = 2;
%             end
        end
        [NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk*10,sigma,0,plim);
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
        if i > 10
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
    flt = 0.1;
    sigma = 1.2;
    
end
toc;


%%
save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

%clearvars;

