function [data] = maskData(data,mask_threshold)
data_max = max(data(:));
mask = data > (data_max*mask_threshold);

data = data.*mask;
end

