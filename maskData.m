function [data] = maskData(data,mask_threshold,cut,Udata,flag)
% filters out data noise given by a threshold 
% data : count based image data 
% mask_thershold : fraction of data to be removed i.e remove lowest 20% of
%                   counts = 0.2
% cut : used to determine the cut off of the "bright band" seen in 'y' data
% Udata : input uniformity flood data, used for UC 
% flag : turn UC on or off 
if cut == 'y'
    data(:,1:18) = 0;
else
end

data(1,:) = [];
data(end,:) = [];
data = [zeros(256,3),data,zeros(256,3)];

data_max = max(data(:));
mask = data > (data_max*mask_threshold);

data = data.*mask;

if flag
    Udata(:,1:18) = 0;
    Udata(1,:) = [];
    Udata(end,:) = [];
    Udata = [zeros(256,3),Udata,zeros(256,3)];
    
    Udata(Udata < (mean(mean(Udata(:,10:end))))*0.3) =  0;
    nUni = Udata./(mean(mean(Udata(:,10:end))));
    nUni(nUni <0.01) = 1;
    data = data./nUni;
end

end

