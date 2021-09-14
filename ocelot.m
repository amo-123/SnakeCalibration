% SPLINE Model Reader
% Function to read matrix of splines 
% and produce a transformation  
function [allsnakes,xx] = ocelot(y,x,data,dfig,samp,line)
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

dim = size(y,1);
yc = zeros(size(y));
%cc = zeros([3,dim]);
% spln= zeros([258,506]);
xx = x(1):samp:x(end);
yy = zeros(length(xx),dim);
allsnakes = zeros(length(xx),dim);
lineX = line(1);
lineY = line(2); 
%%
% Create Snakes 
for i = 1:dim
    % Sigmoid used to confine snake motion by +/- plim number of pixels 
    %yc(i,:) = ((sigmf(y(i,:),[2 0]) -0.5)*2)*plim;
    yc = y;
    % Spline coef defined for initial control points 
    pp = spline(x,[0 yc(i,:) 0]);
    % Complete snake defined 
    yy(:,i) = ppval(pp,xx);
end
% Show figure of snakes in snake space 
if dfig == 1 
    figure('units','normalized','outerposition',[0 0 1 1]); 
    imagesc(data);
    colormap('gray')
    colorbar;
    caxis([0 20]);
    hold on;
    for i = 1:dim
        switch dim
            case lineX
%                 labels = cell(size(x));
                 lab2 = {int2str(i)};
%                 for j = 1:length(x)
%                     labels{j} = int2str(j);
%                 end
                %plot(xx,yy(:,i),'r-','LineWidth',0.8);
                plot(x,yc(i,:),'yo', xx,yy(:,i),'r-','LineWidth',1.5, 'MarkerSize',8);
                %text(x,yc(i,:),labels,'VerticalAlignment','top','HorizontalAlignment','left','Color','g');
                text(x(1),yc(i,1),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g','FontSize',20);
                text(x(end),yc(i,end),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g','FontSize',20);

                hold on;
            case lineY
%                 labels = cell(size(x));
                 lab2 = {int2str(i)};
%                 for j = 1:length(x)
%                     labels{j} = int2str(j);
%                    
%                 end
                plot(yc(i,:),x,'yo', yy(:,i), xx,'r-','LineWidth',1.5, 'MarkerSize',8);
                %plot(yy(:,i), xx,'r-','LineWidth',0.8);
                %text(yc(i,:) ,x,labels,'VerticalAlignment','top','HorizontalAlignment','left','Color','g');
                text(yc(i,1) ,x(1),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g','FontSize',20);
                text(yc(i,end) ,x(end),lab2,'VerticalAlignment','bottom','HorizontalAlignment','right','Color','g','FontSize',20);                
                hold on;
        end
    end
   hold off;
   drawnow;
end

%% 
% Define Snake in Matrix space
for j = 1:dim
    %cc(:,j) = xcorr(yy(:,j),1);
    for i = 1:length(xx)
        % Tranform snakes into the matrix spln
        switch dim
            case lineX
%                 spln(round(yy(i,j)+start(j)),round(xx(i))) = 1;
     %           spln(sub2ind(size(spln),yy(:,j)+start(j),xx(:))) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j);
            case lineY
%                 spln(round(xx(i)), round(yy(i,j)+start(j))) = 1;
        %        spln(sub2ind(size(spln),xx(:),(yy(:,j)+start(j))')) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j);
        end
    end
end

end