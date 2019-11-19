% Fox: self optimisation 


addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\XLin')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\YLin')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\Uniformity')

load('Ldn_20190909_Tc99m_Flood_1p8Mbq_1325time_10min');
Udata = NodeData(:,:,15);
fn = 'Nd01SplineData_Lnd_20190909';
load('Rec_bulmaraw_H15_X_20190909');
Xdata = output.Statistical_Counts;
load('Rec_bulmaraw_H15_Y_20190909');
Ydata = output.Statistical_Counts;
direc = 'y';
DATA = Ydata;
%%
flt = 0.05; %change at bottom too
sigma = 1.9;
msk = maskData(DATA,flt,direc,Udata,0);
[~,band,~] = peak19(msk,direc);

dim = length(band);

switch dim
    case 19
        x = 15:16:500;
    case 41
        x = 8:12:250;
end

plim = 12;

y = zeros(dim, length(x)) + band;

[allsnakes,xx] = ocelot(y,x,band,msk,1,plim,1);

srch = 5; %search pixels range 






