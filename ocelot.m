% SPLINE Model Reader
% Function to read matrix of splines 
% and produce a transformation  
function [spln,allsnakes] = ocelot(y,x,start,data,dfig,plim)
% SolidSnakes
% [sumRes] = SolidSnake(y,x,start,data,sigma,dfig,plim)
% Determines a series of Splines (Snakes) which fit a given data set of
% Linearity Calibration lines. 
% Input: 
% y : Spline coordinates to be optimised using fminunc. Defined by number of Splines and
% Number of Control points
% x : control points spanning the splines. Size chosen by user 
% start : Starting poisition of the splines, given by 'peak19' or optimised
% using 'LiquidSnakes'
% data : Data to fit snake model to. De-noise data with 'maskData' first
% sigma : Smoothing resolution. Match this with the data for a better snake
% fitting 
% dfig : display figures with input 1-4. 4 for all figures 
% plim : Pixel limit. This defines the range of motion of the optimised
% points 
% raw : Unfiltered data to be used for the correct normalisation of the
% model
% Output: 
% SumRes : Sum of the residuel errors in comparitive measure 
% Author: Ashley Morhana, ashley.morahan.17@ucl.ac.uk, UCL
%%
% Initialise Data 

dim = length(start);
yc = zeros(size(y));
%cc = zeros([3,dim]);
spln= zeros([258,506]);
xx = x(1):x(end);
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
if dfig == 1 || dfig == 4
    figure; 
    for i = 1:dim
    plot(x,yc,'o',xx,yy(:,i),'-'), hold on;
    end
    hold off;
end
%% 
% Define Sanke in Matrix 
for j = 1:dim
    %cc(:,j) = xcorr(yy(:,j),1);
    for i = 1:length(xx)
        % Tranform snakes into the matrix spln
        switch dim
            case 19
                spln(round(yy(i,j))+start(j),round(xx(i))) = 1;
     %           spln(sub2ind(size(spln),yy(:,j)+start(j),xx(:))) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j) + start(j);
            case 41
                spln(round(xx(i)), round(yy(i,j)+start(j))) = 1;
        %        spln(sub2ind(size(spln),xx(:),(yy(:,j)+start(j))')) = ones(size(xx));
                % collect all snake positions
                allsnakes(i,j) = yy(i,j) + start(j);
        end
    end
end
%%
% Display snakes in Matrix space overlay the Data 
if dfig == 2 || dfig == 4
    figure, imagesc(spln*50 + data);
end

end