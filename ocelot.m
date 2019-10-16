% SPLINE Model Reader
% Function to read matrix of splines 
% and produce a transformation  
function [allsnakes,xx] = ocelot(y,x,start,data,dfig,plim,samp)
% [spln,allsnakes,xx] = ocelot(y,x,start,data,dfig,plim,samp)
% Reads a given spline model (calculated from optimisation process)
% and produces the data of the model. Use output from OptimiseBigBoss
% Input: 
% y : Optimised pline coordinates. Defined by number of Splines and
% Number of Control points
% x : control points spanning the splines.
% start : Starting poisition of the splines.
% data : Data to fit snake model to
% dfig : display figures with input 1 
% plim : Pixel limit. This defines the range of motion of the optimised
% points 
% samp : sample rate of the splines 
% Output: 
% allsnakes: Values of all splines 
% xx : Coordinates of all splines 
% Author: Ashley Morhana, ashley.morahan.17@ucl.ac.uk, UCL
%%
% Initialise Data 

dim = length(start);
yc = zeros(size(y));
%cc = zeros([3,dim]);
% spln= zeros([258,506]);
xx = x(1):samp:x(end);
yy = zeros(length(xx),dim);
allsnakes = zeros(length(xx),dim);

%%
% Create Snakes 
for i = 1:dim
    % Sigmoid used to confine snake motion by +/- plim number of pixels 
    yc(i,:) = ((sigmf(y(i,:),[2 0]) -0.5)*2)*plim;
    % Spline coef defined for initial control points 
    pp = spline(x,[0 yc(i,:) 0]);
    % Complete snake defined 
    yy(:,i) = ppval(pp,xx);
end
% Show figure of snakes in snake space 
if dfig == 1 
    figure; 
    imagesc(data);
    colormap('gray')
    colorbar;
    caxis([0 20]);
    hold on;
    for i = 1:dim
        switch dim
            case 19
                labels = cell(size(x));
                lab2 = {int2str(i)};
                for j = 1:length(x)
                    labels{j} = int2str(j);
                end
                plot(x,yc(i,:) + start(i),'co', xx,yy(:,i) + start(i),'r-','LineWidth',0.8);
                text(x,yc(i,:) + start(i),labels,'VerticalAlignment','top','HorizontalAlignment','left','Color','g');
                text(x(1),yc(i,1) + start(i),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g');
                hold on;
            case 41
                labels = cell(size(x));
                lab2 = {int2str(i)};
                for j = 1:length(x)
                    labels{j} = int2str(j);
                   
                end
                plot(yc(i,:) + start(i),x,'yo', yy(:,i) + start(i), xx,'r-','LineWidth',0.8);
                text(yc(i,:) + start(i),x,labels,'VerticalAlignment','top','HorizontalAlignment','left','Color','g');
                text(yc(i,1) + start(i),x(1),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g');
                hold on;
        end
    end
    hold off;
end
%% 
% Define Snake in Matrix space
for j = 1:dim
    %cc(:,j) = xcorr(yy(:,j),1);
    for i = 1:length(xx)
        % Tranform snakes into the matrix spln
        switch dim
            case 19
%                 spln(round(yy(i,j)+start(j)),round(xx(i))) = 1;
     %           spln(sub2ind(size(spln),yy(:,j)+start(j),xx(:))) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j) + start(j);
            case 41
%                 spln(round(xx(i)), round(yy(i,j)+start(j))) = 1;
        %        spln(sub2ind(size(spln),xx(:),(yy(:,j)+start(j))')) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j) + start(j);
        end
    end
end

end