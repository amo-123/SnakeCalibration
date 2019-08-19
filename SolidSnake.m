% SPLINE Model
% Function to produce a matrix of splines 
% Given a number of splines and matix size 
function [sumRes] = SolidSnake(y,x,start,data,sigma,dfig)

% x: control points 

yc = round(y) + start;
%yc = y + start;
pp = spline(x,[0 yc 0]);

spln= zeros([258,506]);
xx = 22:478;
yy = ppval(pp,xx);

if dfig == 1 || dfig == 4
    figure, plot(x,yc,'o',xx,yy,'-')
end
%start = 130;

for i = 1:length(xx)
spln(round(yy(i)),round(xx(i))) = 1;
end

%%

NRM = sum(data)/sum(sum(spln));

spln = NRM.*spln;
spln = imgaussfilt(spln,sigma);

if dfig == 2 || dfig == 4
    figure, imagesc(spln);
end

%%

splnflt = reshape(spln,1,[]);

if dfig == 3 || dfig == 4
    figure, plot(data,'.r'), hold on, plot(splnflt,'x');
end

sumRes = sum((data - splnflt).^2);


end