% Optimise Snakes 
% Optimise the 'SolidSnake' function to fit linearity calibration data 
tic;
load('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\Database_Reconstructions\Rec_bulmaraw_H08_Y.mat')

Data = output.Statistical_Counts;
% Determine snake start positions by peaks along the data

msk = maskData(Data,0.3);
[~,band] = peak19(msk,'y');
band = round(band);

dim = length(band);
sigma = 2;
plim = 10;
x = 8:20:250; 
%msk = maskData(Data,0.3);

%% 
h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
%now run the fitting
resmin = 4e+07;

for i= 1:5
y = ones(dim, length(x)).*rand;
[NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim,Data);
    if RESNORM <= resmin
        resmin = RESNORM;
        minY = NewY;
        minBand = band;
    end
end 
SolidSnake(minY,x,minBand,msk,sigma,4,plim,Data);

toc;
