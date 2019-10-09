% Optimise Snakes 
% Optimise the 'SolidSnake' function to fit linearity calibration data 
%function [Xspline,Yspline,Xstart,Ystart]
tic;
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Linearity\London')
%Data = output.Statistical_Counts;
%Data = Nd4_XLin;
% Determine snake start positions by peaks along the data
%addpath('Data')
fn = 'Nd03SplineData_20190909';
%load('Nd8XLin.mat')
load('Rec_bulmaraw_H03_X_20190909');
Xdata = output.Statistical_Counts;
%Xdata = Data;
%Xdata = Nd4_XLin;
%load('Nd8YLin.mat')
load('Rec_bulmaraw_H03_Y_20190909');
Ydata = output.Statistical_Counts;
%Ydata = Data;
%Ydata = Nd4_YLin;
direc = 'x';
DATA = Xdata;
%%
flt = 0.11; %change at bottom too
sigma = 1.2;

%%
for c = 1:2
    
    msk = maskData(DATA,flt,direc);
    [~,band,~] = peak19(msk,direc);
    band = round(band)-2;
    
    dim = length(band);

    
    switch dim
        case 19
            %x = 22:28:478;
            x = 15:15:500;
            plim = 12;
            Xplim = plim;
            Xx = x;
        case 41
            x = 8:14:250;
            plim = 12;
            Yplim = plim;
            Yx = x;
    end
    
    
    %%
    h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
    %now run the fitting
    resmin = 4e+06;
    
    for i= 1:15
        y = ones(dim, length(x)).*rand;
        [NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk*10,sigma,0,plim);
        if RESNORM <= resmin
            resmin = RESNORM;
            minY = NewY;
            minBand = band;
        end
    end
    SolidSnake(minY,x,minBand,msk,sigma,4,plim);
    
    switch dim
        case 19
            Xspline = minY;
            Xstart = band;
        case 41
            Yspline = minY;
            Ystart = band;
            
    end
    
    direc = 'y';
    DATA = Ydata;
    flt = 0.09;
    sigma = 1.2;
    
end
toc;


%%
save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

%clearvars;

