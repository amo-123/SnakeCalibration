function [out,moving,fixed] = revolver(Xspline,Xx,Xstart,Xdata,Yspline,Yx,Ystart,Ydata,plim,samp)

[Xspln,Xcoordy,Xcoordx] = ocelot(Xspline,Xx,Xstart,Xdata,0,plim,samp);
[Yspln,Ycoordy,Ycoordx] = ocelot(Yspline,Yx,Ystart,Ydata,0,plim,samp);


figure(1);
for i = 1:19
    plot(Xcoordx,Xcoordy(:,i),'r-'), hold on;
end
hold on;
for i = 1:41
    plot(Ycoordy(:,i), Ycoordx,'b-'), hold on;
    
end
hold off;
% 
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

% Xint = zeros([41,19]);
% Yint = zeros([41,19]);
xy = zeros([2,19,41]);
Refxy = zeros([2,19,41]);

for i = 1:41
    for j = 1:19
%         [~,aa,~] = intersect(Ycoordx(:),Xcoordy(:,j));
%         
%         [~,ii,~] = intersect(Xcoordx(:),Ycoordy(:,i));
%         
%         Xint(i,j) = intersect(Xcoordy(ii,j),Ycoordx(aa));
%         
%         Yint(i,j) = intersect(Ycoordy(aa,i),Xcoordx(ii));
        xy(:,j,i) = MGS(Xcoordy(:,j),Xcoordx,Ycoordy(:,i),Ycoordx);
        Refxy(:,j,i) = MGS((ones(size(Xcoordx)).*Xstart(j))',Xcoordx,(ones(size(Ycoordx)).*Ystart(i))',Ycoordx);
        figure(1)
        hold on, plot(xy(1,j,i),xy(2,j,i),'xk'), hold off
        hold on, plot(Refxy(1,j,i),Refxy(2,j,i),'og'), hold off
    end
    
end


refimg = refX + refY;
Incorr = Xspln + Yspln;
out = zeros(2,258,506);
out(1,:,:) = refimg;
out(2,:,:) = Incorr;

% 
% %Incorr(Incorr == 1) = 0;
% 
%refimg(refimg == 1) = 0;
% 
% %Incorr(Incorr == 2) = 1;
% 
%refimg(refimg == 2) = 1;

%[a,b] = find(refimg == 1);
%[c,d] = find(Incorr == 1);
moving = reshape(xy,2,[])';
fixed= reshape(Refxy,2,[])';
%fixed = [a,b];
% q = zeros(size(a));
% p = zeros(size(a));
% 
% for i = 1:length(a)
%     [~,q(i)] = min(sqrt((c-a(i).^2)));
% end
% 
% for i = 1:length(a)
%     [~,p(i)] = min(sqrt((d-b(i).^2)));
% end

% c = c(q);
% d = d(p);

% moving = [c,d];
% fixed = [a,b];
end

