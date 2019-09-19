% Optimise Snakes 
% Optimise the 'SolidSnake' function to fit linearity calibration data 
%function [Xspline,Yspline,Xstart,Ystart]
tic;
%load('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\Database_Reconstructions\Rec_bulmaraw_H08_X.mat')
%Data = output.Statistical_Counts;
%Data = Nd4_XLin;
% Determine snake start positions by peaks along the data
addpath('Data')
load('Nd8XLin.mat')
Xdata = Data;
load('Nd8YLin.mat')
Ydata = Data;

direc = 'x';
DATA = Xdata;


for c = 1:2
    
    msk = maskData(DATA,0.15,direc);
    [~,band,wsigma] = peak19(msk,direc);
    band = round(band);
    
    dim = length(band);
    sigma = 2;
    plim = 15;
    
    switch dim
        case 19
            %x = 22:28:478;
            x = 15:20:500;
        case 41
            x = 8:20:250;
            
    end
    
    %msk = maskData(Data,0.3);
    
    %%
    h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
    %now run the fitting
    resmin = 4e+07;
    
    for i= 1:10
        y = ones(dim, length(x)).*rand;
        [NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim);
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
end
toc;
