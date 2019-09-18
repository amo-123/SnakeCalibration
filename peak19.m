function [x,y,sigma] = peak19(data,dim)
switch dim
    case 'x'
        x = zeros(19, size(data,2));
        w = zeros(19, size(data,2));
        
        for i = 1:length(x)
            flag = true;
            count = 0;
            while flag
                try
                    [~,x(:,i),w(:,i),~] = findpeaks(imgaussfilt(data(:,i),rand*3));
                    flag = false;
                catch
                    count = count+1;
                    if count == 10
                        flag = false;
                    end
                end
            end
        end
        
        y = x(:,any(x,1));
        y = mean(y,2);
        sigma = w(:,any(w,1));
        sigma = mean(w,2);
    case 'y'
        x = zeros(41, size(data,1));
        w = zeros(41, size(data,1));
        for i = 1:length(x)
            flag = true;
            count = 0;
            while flag
                try
                    [~,x(:,i),w(:,i),~] = findpeaks(imgaussfilt(data(i,:),rand*3));
                    
                    flag = false;
                catch
                    count = count+1;
                    if count == 10
                        flag = false;
                    end
                end
            end
        end
        
        y = x(:,any(x,1));
        y = mean(y,2);
        sigma = w(:,any(w,1));
        sigma = mean(w,2);
end

end

