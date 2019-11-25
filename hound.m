
function [ny,flag] = hound(srch,yorigin,y,x,DATA,dfig,samp,stepsize,i,j)
    % Author: Ashley Morhana, ashley.morahan.17@ucl.ac.uk, UCL
    % srch : search pixels range
    dim = size(y,1);
    [allsnakes,xx] = ocelot(y,x,DATA,dfig,samp);
    switch dim
        case 19
            snkres(1) = sum(sum(DATA([round(allsnakes(:,i))-srch,round(allsnakes(:,i)+srch)], xx)));
        case 41
            snkres(1) = sum(sum(DATA(xx,[round(allsnakes(:,i))-srch,round(allsnakes(:,i)+srch)])));
    end

    step = zeros(dim, length(x));
    step(i,j) = stepsize;

    yplus = y + step;
    [allsnakesplus,xxplus] = ocelot(yplus,x,DATA,dfig,samp);
    switch dim
        case 19
            snkres(2) = sum(sum(DATA([round(allsnakesplus(:,i))-srch,round(allsnakesplus(:,i)+srch)],xxplus)));
        case 41
            snkres(2) = sum(sum(DATA(xxplus,[round(allsnakesplus(:,i))-srch,round(allsnakesplus(:,i)+srch)])));
    end
    ymin = y - step;
    [allsnakesmin,xxmin] = ocelot(ymin,x,DATA,dfig,samp);
    switch dim
        case 19
            snkres(3) = sum(sum(DATA([round(allsnakesmin(:,i))-srch,round(allsnakesmin(:,i)+srch)],xxmin)));
        case 41
            snkres(3) = sum(sum(DATA(xxmin,[round(allsnakesmin(:,i))-srch,round(allsnakesmin(:,i)+srch)])));
    end

    [~,I] = max(snkres);
    switch I
        case 1
            ny = y;
            flag = 0;
        case 2
            ny = yplus;
            flag = 1;
        case 3
            ny = ymin;
            flag = 1;
    end
diff = abs(ny(i,j)-yorigin(i,j));
if diff >=2
    flag = 0;
end

end