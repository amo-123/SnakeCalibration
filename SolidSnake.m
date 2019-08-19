% SPLINE Model
% Function to produce a matrix of splines 
% Given a number of splines and matix size 
function [sumRes] = SolidSnake(y,x,start,data,sigma,dfig,plim)

% x: control points 
dataArray = reshape(data, 1, []);

yc = ((sigmf(y,[2 0]) -0.5)*2)*plim;
%yc = y ;
pp = spline(x,[0 yc 0]);

spln= zeros([258,506]);
xx = 22:478;
yy = ppval(pp,xx);

if dfig == 1 || dfig == 4
    figure, plot(x,yc,'o',xx,yy,'-')
end
%start = 130;

for i = 1:length(xx)
spln(round(yy(i))+start,round(xx(i))) = 1;
end

%%

NRM = sum(dataArray)/sum(sum(spln));

spln = NRM.*spln;
spln = imgaussfilt(spln,sigma);

if dfig == 2 || dfig == 4
    figure, imagesc(spln + data);
end

if dfig == 2 || dfig == 4
    figure, imagesc(spln);
end

%%

splnflt = reshape(spln,1,[]);

if dfig == 3 || dfig == 4
    figure, plot(dataArray,'.r'), hold on, plot(splnflt,'x');
end


sumRes = sum((dataArray - splnflt).^2);


end