function [data] = maskData(data,mask_threshold)
% filters out data noise given by a threshold 
% data : count based image data 
% mask_thershold : fraction of data to be removed i.e remove lowest 20% of
% counts = 0.2
data_max = max(data(:));
mask = data > (data_max*mask_threshold);

data = data.*mask;
end

