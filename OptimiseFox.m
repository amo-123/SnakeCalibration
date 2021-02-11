% Fox: self optimisation 


Xpath = '/media/ashley/My Passport/Registration/SolidSnakes/Data/NormRecon/20190307/XSnk/';
Ypath = '/media/ashley/My Passport/Registration/SolidSnakes/Data/NormRecon/20190307/YSnk/';
Upath = '/media/ashley/My Passport/TestLRF/PERA_PlanarReconstructionAlgorithm/PeraScripts/projects/INSERT_recon/Event_recon2/Database_Reconstructions/Normalised/';

%addpath(Xpath);
%addpath(Ypath);
%addpath(Upath);


fn = 'Nd18SplineData_Mil_Norm';
NodeNum = 18;

Xfiles = dir(fullfile(Xpath,'*.mat'));
Xfile = Xfiles(NodeNum-15).name;
load([Xpath Xfile]);
%Xdata = output.Statistical_Counts;
% NodeData = zeros(256,508);
% for i = 1:4
%     NodeData = NodeData + data.NodeData{i};
% end

Xdata = NodeData{1};
%load('Rec_bulmaraw_H09_Y_20191127');
%Ydata = output.Statistical_Counts;
Yfiles = dir(fullfile(Ypath,'*.mat'));
Yfile = Yfiles(NodeNum-2).name;
load([Ypath Yfile]);

% NodeData = zeros(256,508);
% for i = 1:4
%     NodeData = NodeData + data.NodeData{i};
% end

Ydata = NodeData{1};

for i =1:2
    if i == 1
        direc = 'x';
        DATA = Xdata;
    else
        direc = 'y';
        DATA = Ydata;
    end
    
    % figure('units','normalized','outerposition',[0 0 1 1]);
    % subplot(1,2,1);
    % imagesc(Xdata');
    % subplot(1,2,2);
    % imagesc(Ydata');
    
    
    Ufiles = dir(fullfile(Upath,'*.mat'));
    Ufile = Ufiles(NodeNum).name;
    load([Upath Ufile]);
    Udata = output.Statistical_Counts;
    
    flt = 0.1; %change at bottom too
    msk = maskData(DATA,flt,Udata,0);
    
    switch direc
        case 'x'
            x = 17:5:493;
        case 'y'
            x = 12:5:247;
    end
    
    [x,y] = peak19(msk,direc,x);
    
    yorigin = y;
    dim = size(y,1);
    
    %[allsnakes,xx] = ocelot(y,x,DATA,1,1);
    srch = 2;
    step = 1;
    
    [~,~] = ocelot(y,x,msk,1,1);
    if i == 1
        Xspline = y;
        Xx = x;
    else
        Yspline = y;
        Yx = x;
    end
    
end

save(['./Output/',fn],'Xspline','Xx','Xdata','Yspline','Yx','Ydata');


%%
% for i = 1:size(y,1) %i loop each snake 
%     counter = 0;
%     stop = 1;
%     itt = 1;
%     flag = ones(size(x));
%     %figure,
% while stop
%     for j = 1:length(x) % j loop each ctrl point 
%         %if flag(j)
%         [new_y,flag(j)] = hound(srch,yorigin,y,x,msk,0,1,step,i,j);
%         y = new_y;
%         %end
%         if ~flag(j)
%             counter = counter + 1;
%             
%         end
%     end
%     %hold on, plot(itt, counter,'.r')
%     if counter >= length(x)
%         stop = 0;
%     end
%     counter = 0;
% 
%     itt = itt + 1;
% %     step = step - 1;
% %     srch = srch - 1;
% end
%  %disp('here');
% end
%     [~,~] = ocelot(y,x,msk,1,1);

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
%save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

