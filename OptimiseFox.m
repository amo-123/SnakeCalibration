% Fox: self optimisation 


addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\XLin')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\YLin')
addpath('E:\TestLRF\PERA_PlanarReconstructionAlgorithm\PeraScripts\Database_Reconstructions\Lnd_UXY\Uniformity')

load('Ldn_20190909_Tc99m_Flood_1p8Mbq_1325time_10min');
Udata = NodeData(:,:,15);
fn = 'Nd01SplineData_Lnd_20190909';
load('Rec_bulmaraw_H04_X_20190909');
Xdata = output.Statistical_Counts;
load('Rec_bulmaraw_H04_Y_20190909');
Ydata = output.Statistical_Counts;
direc = 'x';
DATA = Xdata;
%%
flt = 0.05; %change at bottom too
msk = maskData(DATA,flt,direc,Udata,0);

switch direc
    case 'x'
        x = 20:20:490;
    case 'y'
        x = 15:15:240;
end

[x,y] = peak19(msk,direc,x);

yorigin = y;
dim = size(y,1);

%[allsnakes,xx] = ocelot(y,x,DATA,1,1);
srch = 2;
step = 1;
%%
    [~,~] = ocelot(y,x,msk,1,1);
    

for i = 1:size(y,1)
    counter = 0;
    stop = 1;
    itt = 1;
    flag = ones(size(x));
    %figure,
while stop
    for j = 1:length(x)
        %if flag(j)
        [new_y,flag(j)] = hound(srch,yorigin,y,x,msk,0,1,step,i,j);
        y = new_y;
        %end
        if ~flag(j)
            counter = counter + 1;
            
        end
    end
    %hold on, plot(itt, counter,'.r')
    if counter >= length(x)
        stop = 0;
    end
    counter = 0;

    itt = itt + 1;
%     step = step - 1;
%     srch = srch - 1;
end
 %disp('here');
end
    [~,~] = ocelot(y,x,msk,1,1);

%%
% srch = 5; %search pixels range 
% step = zeros(dim, length(x));
% snakeint = zeros(size(xx));
% for i = 1:length(xx)
% snakeint(i) = sum(DATA(xx(i),round(allsnakes(i,1))-srch:round(allsnakes(i,1)+srch)));
% end
% resnorm(1) = sum(snakeint);
% 
% step(1,1) = 1/9;
% y = zeros(dim, length(x))+ step;
% [allsnakes,xx] = ocelot(y,x,band,DATA,1,plim,1);
% 
% for i = 1:length(xx)
% snakeint(i) = sum(DATA(xx(i),round(allsnakes(i,1))-srch:round(allsnakes(i,1)+srch)));
% end
% resnorm(2) = sum(snakeint);
% 
% y = zeros(dim, length(x)) - step;
% [allsnakes,xx] = ocelot(y,x,band,DATA,1,plim,1);
% 
% for i = 1:length(xx)
% snakeint(i) = sum(DATA(xx(i),round(allsnakes(i,1))-srch:round(allsnakes(i,1)+srch)));
% end
% resnorm(3) = sum(snakeint);
% 
