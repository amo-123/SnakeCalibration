function [Incorr,refimg,moving,fixed] = revolver(Xspline,Xx,Xstart,Xdata,Yspline,Yx,Ystart,Ydata,plim)

[Xspln,Xcoordy,Xcoordx] = ocelot(Xspline,Xx,Xstart,Xdata,0,plim);
[Yspln,Ycoordy,Ycoordx] = ocelot(Yspline,Yx,Ystart,Ydata,0,plim);


% figure;
% for i = 1:19
%     plot(Xcoordx,Xcoordy(:,i),'r-','LineWidth',1), hold on;
% end
% hold on;
% for i = 1:41
%     plot(Ycoordy(:,i), Ycoordx,'b-','LineWidth',1), hold on;
%     
% end
% hold off;

refX = zeros(258,506);
refY = zeros(258,506);
for i = 1:length(Ystart)
%     if Ycoord(:,i) == Xcoord(:,i)
        
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

Incorr(Incorr == 1) = 0;

refimg(refimg == 1) = 0;

Incorr(Incorr == 2) = 1;

refimg(refimg == 2) = 1;

[a,b] = find(refimg == 1);
[c,d] = find(Incorr == 1);

q = zeros(size(a));
p = zeros(size(a));

for i = 1:length(a)
    [~,q(i)] = min(sqrt((c-a(i)).^2));
end

for i = 1:length(a)
    [~,p(i)] = min(sqrt((d-b(i)).^2));
end

c = c(q);
d = d(p);

moving = [c,d];
fixed = [a,b];
end

