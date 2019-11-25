% SPLINE Model
% Function to produce a matrix of splines 
% Given a number of splines and matix size 
function [sumRes] = SolidSnake(y,x,data,sigma,dfig,plim)
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
% Output: 
% SumRes : Sum of the residuel errors in comparitive measure 
% Author: Ashley Morhana, ashley.morahan.17@ucl.ac.uk, UCL
%%
% Initialise Data 
dataArray = reshape(data, 1, []);
dim = size(y,1);
yc = zeros(size(y));
%cc = zeros([3,dim]);
spln= zeros(size(data));
xx = x(1):x(end);
yy = zeros(length(xx),dim);
allsnakes = zeros(length(xx),dim);
penalty = 0;
%%
% Create Snakes 
for i = 1:dim
    % Sigmoid used to confine snake motion by +/- plim number of pixels 
    yc(i,:) = ((sigmf(y(i,:),[2 0]) -0.5)*2)*plim;
    %yc = y;
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
                spln(round(yy(i,j)),round(xx(i))) = 1;

                % collect all snake positions
                allsnakes(i,j) = round(yy(i,j));
            case 41
                spln(round(xx(i)), round(yy(i,j))) = 1;
                % collect all snake positions
                allsnakes(i,j) = round(yy(i,j));
        end
    end
end
%%
% Display snakes in Matrix space overlay the Data 
if dfig == 2 || dfig == 4
        figure; 
    imagesc(data.*10), hold on;
    for i = 1:dim
        switch dim
            case 19
                plot(x,yc(i,:),'yo', xx,yy(:,i),'r-','LineWidth',0.8), hold on;
            case 41
                plot(yc(i,:),x,'yo', yy(:,i), xx,'r-','LineWidth',0.8), hold on;
        end
    end
    hold off;
end
%% 
% Normalise and Convolve Snake Matrix 

spln = imgaussfilt(spln,sigma);
% 
spln = mean(dataArray)*((spln-min(min(spln)))./(max(max(spln))-min(min(spln))));
%% 
% data(data < (mean(mean(data)))*0.5) =  0;
% ndata = data./(mean(mean(data)));
% ndata(ndata <0.01) = 1;
% spln = spln./ndata;


% Display the normalised data 
if dfig == 2 || dfig == 4
    figure; 
%     subplot(1,2,1);
%     imagesc(spln);
%     subplot(1,2,2);
    imagesc(data);
end

%%
% Comparitive measure
splnflt = reshape(spln,1,[]);

if dfig == 3 || dfig == 4
    figure, plot(dataArray,'.r');
end

%cc = corrcoef(splnflt);
% for j = 1:dim
%     for k = 1:length(xx)
%         for m = 1: length(xx)
%             cc(j,k) = dataArray(m).*splnflt(m-k)
%         end
%     end
% end
% Check snakes overlapping positions 
for i = 1:length(xx)
    if numel(allsnakes(i,:))~=numel(unique(allsnakes(i,:)))
        % Introduce penalty for large residual
        penalty = 1e6;
        break
    end
end
%% Simularity measure 
% %Root Mean Square Error  
% srch = 3;
% Res = zeros([dim,1]);

% for i = 1:dim
% switch dim
%     case 19
%         Res(i) = sum(sum(data([round(allsnakes(:,i))-srch,round(allsnakes(:,i)+srch)], xx)));
%     case 41
%         Res(i) = sum(sum(data(xx,[round(allsnakes(:,i))-srch,round(allsnakes(:,i)+srch)])));
% end
% end
sumRes = (sqrt(sum((dataArray - splnflt).^2)./numel(dataArray))/mean(dataArray)) + penalty;
% sumRes = (1/sum(Res)) + penalty;
%sumRes = sum(abs(dataArray - splnflt))./numel(dataArray) + sum(cc(1,:));

end