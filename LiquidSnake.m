% Do not use this SPLINE Model
% Function to produce a matrix of splines 
% Given a number of splines and matix size 
function [sumRes] = LiquidSnake(start,x,y,data,sigma,dfig,plim)

% x: control points 
dataArray = reshape(data, 1, []);
dim = length(start);
yc = zeros(size(y));

spln= zeros([258,506]);
xx = 22:478;
yy = zeros(length(xx),dim);

for i = 1:dim
    start(i) = ((sigmf(start(i),[2 0]) -0.5)*2)*plim;
    yc(i,:) = ((sigmf(y(i,:),[2 0]) -0.5)*2)*plim;
    pp = spline(x,[0 yc(i,:) 0]);
    yy(:,i) = ppval(pp,xx);
end
if dfig == 1 || dfig == 4
    figure; 
    for i = 1:dim
    plot(x,yc,'o',xx,yy(:,i),'-'), hold on;
    end
    hold off;
end

for j = 1:dim
    for i = 1:length(xx)
        spln(round(yy(i,j)+abs(start(j))),round(xx(i))) = 1;
    end
end
%%
if dfig == 2 || dfig == 4
    figure, imagesc(spln*50 + data);
end

NRM = sum(dataArray)/sum(sum(spln));

spln = NRM.*spln;
spln = imgaussfilt(spln,sigma);

if dfig == 2 || dfig == 4
    figure, imagesc(spln);
end

%%

splnflt = reshape(spln,1,[]);

if dfig == 3 || dfig == 4
    figure, plot(dataArray,'.r'), hold on, plot(splnflt,'x'), hold off;
end

%cc = corrcoef(splnflt);
% for j = 1:dim
%     for k = 1:length(xx)
%         for m = 1: length(xx)
%             cc(j,k) = dataArray(m).*splnflt(m-k)
%         end
%     end
% end

sumRes = sqrt(sum((dataArray - splnflt).^2)./numel(dataArray));
%sumRes = sum(abs(dataArray - splnflt))./numel(dataArray) + cc;

end