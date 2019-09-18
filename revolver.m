function [Incorr,refimg] = revolver(Xspline,Xx,Xstart,Xdata,Yspline,Yx,Ystart,Ydata,sigma,plim)

[Xspln,~] = ocelot(Xspline,Xx,Xstart,Xdata,sigma,0,plim);
[Yspln,~] = ocelot(Yspline,Yx,Ystart,Ydata,sigma,0,plim);

refX = zeros(258,506);
refY = zeros(258,506);
for i = 1:length(Ystart)
    refY(Yx(1):Yx(end),Ystart(i)) = 1;
end
for i = 1:length(Xstart)
    refX(Xstart(i),Xx(1):Xx(end)) = 1;
end

refX = imgaussfilt(refX,sigma);
refX = ceil(refX);
refY = imgaussfilt(refY,sigma);
refY = ceil(refY);


refimg = refX + refY;
Incorr = Xspln + Yspln;

end

