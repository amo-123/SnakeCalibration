function [Incorr,refimg] = revolver(Xspline,Xx,Xstart,Xdata,Yspline,Yx,Ystart,Ydata,plim)

[Xspln,Xcoord] = ocelot(Xspline,Xx,Xstart,Xdata,0,plim);
[Yspln,Ycoord] = ocelot(Yspline,Yx,Ystart,Ydata,0,plim);

refX = zeros(258,506);
refY = zeros(258,506);
for i = 1:length(Ystart)
    if Ycoord(:,i) == Xcoord(:,i)
        
    refY(Yx(1):Yx(end),Ystart(i)) = 1;
end
for i = 1:length(Xstart)
    refX(Xstart(i),Xx(1):Xx(end)) = 1;
end

% refX = imgaussfilt(refX,sigma);
% refX = ceil(refX);
% refY = imgaussfilt(refY,sigma);
% refY = ceil(refY);


refimg = refX + refY;
Incorr = Xspln + Yspln;

% Incorr(Incorr == 1) = 0;
% 
% refimg(refimg == 1) = 0;
% 
% Incorr(Incorr == 2) = 1;
% 
% refimg(refimg == 2) = 1;

end

