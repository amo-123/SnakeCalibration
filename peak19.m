function [x,y] = peak19(data,dim,xx)
rndpm = 0;
switch dim
    case 'x'
        x = zeros(19, length(xx));
        %w = zeros(19, length(xx));
        j = 1;
        for i = xx
            count = 0;
            
            while count < 10
                try
                    [~,x(:,j),w(:,j),~] = findpeaks(imgaussfilt(sum(data(:,i-5:i+5),2),3 + rndpm ));
%                     for k = 2:size(data,1)-1
%                         if  imgaussfilt(sum(data(k-1,i-5:i+5),2),3 + rndpm ) < imgaussfilt(sum(data(k,i-5:i+5),2),3 + rndpm ) ...
%                                 && imgaussfilt(sum(data(k,i-5:i+5),2),3 + rndpm ) > imgaussfilt(sum(data(k+1,i-5:i+5),2),3 + rndpm )
%                             x(k,j) = data(k,i);
%                         end
%                     end
                    count = 10;
                catch
                    count = count+1;
                    rndpm = (rand()*1.5 - 1);
                end
            end
            j = j+1;
        end
        

        y = x(:,any(x,1));
        x = xx(any(x,1));
        
        for j = 1:19
            outy = isoutlier(y(j,:));
            M = movmean(y(j,:),8);
            y(j,outy) = M(outy);

        end

        %y = mean(y,2);
        %sigma = w(:,any(w,1));
        %sigma = mean(sigma,2);
    case 'y'
        x = zeros(41, length(xx));
        %w = zeros(41, length(xx));
        j = 1;
        for i = xx
            count = 0;
            
            while count < 10
                try
%                 for k = 2:size(data,2)-1
%                     if  imgaussfilt(sum(data(i-5:i+5,k-1)),3 + rndpm ) < imgaussfilt(sum(data(i-5:i+5,k)),3 + rndpm ) && imgaussfilt(sum(data(i-5:i+5,k)),3 + rndpm ) > imgaussfilt(sum(data(i-5:i+5,k+1)),3 + rndpm )
%                         %x(k,j) = data(i,k);
%                         max(k) = data(i,k);
%                     end
%                 end
                    [~,x(:,j),w(:,j),~] = findpeaks(imgaussfilt(sum(data(i-5:i+5,:)),3 +rndpm ));
                    count = 10;
                catch
                    count = count+1;
                    rndpm = (rand()*1.5 - 1);

                end
            end
            j = j+1;
        end
        
        y = x(:,any(x,1));
        x = xx(any(x,1));
        %y = mean(y,2);
        %sigma = w(:,any(w,1));
        %sigma = mean(sigma,2);
end

end

