function [x,y,sigma] = peak19(data,dim)
rndpm = 0;
switch dim
    case 'x'
        x = zeros(19, size(data,2));
        w = zeros(19, size(data,2));
        
        for i = 100:20:400
            flag = true;
            count = 0;

            while flag
                try
                    [~,x(:,i),w(:,i),~] = findpeaks(imgaussfilt(sum(data(:,i-5:i+5),2),3 + rndpm ));
                    flag = false;
                catch
                    count = count+1;
                    rndpm = (rand()*1.5 - 1);
                    if count == 10
                        flag = false;
                    end
                end
            end
        end
        
        y = x(:,any(x,1));
        y = mean(y,2);
        sigma = w(:,any(w,1));
        sigma = mean(sigma,2);
    case 'y'
        x = zeros(41, size(data,1));
        w = zeros(41, size(data,1));
        for i = 100:20:200
            flag = true;
            count = 0;
            
            while flag
                try
                    [~,x(:,i),w(:,i),~] = findpeaks(imgaussfilt(sum(data(i-5:i+5,:)),3 +rndpm ));
                    
                    flag = false;
                catch
                    count = count+1;
                    rndpm = (rand()*1.5 - 1);
                    if count == 10
                        flag = false;
                    end
                end
            end
        end
        
        y = x(:,any(x,1));
        y = mean(y,2);
        sigma = w(:,any(w,1));
        sigma = mean(sigma,2);
end

end

