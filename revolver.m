function [tform, moving, fixed] = revolver(Xspline,Xx,Xstart,Xdata,Xplim,Yspline,Yx,Ystart,Ydata,Yplim,samp)
% [moving,fixed] = revolver(Xspline,Xx,Xstart,Xdata,Yspline,Yx,Ystart,Ydata,plim,samp)
% Calls Ocelot and MGS to determine the control points for linearity
% correction
% Input: Get data from OptimiseBigBoss output 
% Xspline: Optimised XLin Spline coordinates. Defined by number of Splines and
% Number of Control points
% Xx : XLin control points spanning the splines.
% Xstart : Starting poisition of the XLin splines.
% Xdata : XLin Data to fit to the snake model.
% Yspline: Optimised YLin Spline coordinates. Defined by number of Splines and
% Number of Control points
% Yx : YLin control points spanning the splines.
% Ystart : Starting poisition of the YLin splines.
% Ydata : YLin Data to fit to the snake model. 
% plim : Pixel limit. This defines the range of motion of the optimised
% points 
% samp : sample rate of the splines 
% Output: 
% moving : moving control points 
% fixed : fixed control points 
% Author: Ashley Morhana, ashley.morahan.17@ucl.ac.uk, UCL

Xdata(1,:) = [];
Xdata(end,:) = [];
Xdata = [zeros(256,3),Xdata,zeros(256,3)];

Ydata(1,:) = [];
Ydata(end,:) = [];
Ydata = [zeros(256,3),Ydata,zeros(256,3)];


[Xcoordy,Xcoordx] = ocelot(Xspline,Xx,Xstart,Xdata,0,Xplim,samp);
[Ycoordy,Ycoordx] = ocelot(Yspline,Yx,Ystart,Ydata,0,Yplim,samp);

midX = 512/2;

midY = 256/2;

Xlinspace = 2.2222/0.2;

Xgeo = (-20:20)*Xlinspace + midX;

Ygeo = (-9:9)*Xlinspace + midY;

figure(1);
for i = 1:19                                                                                                                                                                                                    
    plot(Xcoordx,Xcoordy(:,i),'r-'), hold on;
end
hold on;
for i = 1:41
    plot(Ycoordy(:,i), Ycoordx,'b-'), hold on;
    
end
hold off;
%% 
xy = zeros([2,19,41]);
Refxy = zeros([2,19,41]);


for i = 1:41
    for j = 1:19
        xy(:,j,i) = MGS(Xcoordy(:,j),Xcoordx,Ycoordy(:,i),Ycoordx);
        Refxy(:,j,i) = [Xgeo(i),Ygeo(j)];
        %vec = Refxy(:,j,i) - xy(:,j,i); 
        figure(1)
        hold on, plot(xy(1,j,i),xy(2,j,i),'xk'), hold off
        hold on, plot(Refxy(1,j,i),Refxy(2,j,i),'om'), hold off
        %hold on, quiver(xy(1,j,i),xy(2,j,i),vec(1),vec(2),'Color','c'),hold off
    end
    
end


moving = reshape(xy,2,[])';
fixed= reshape(Refxy,2,[])';

tform = fitgeotrans(moving,fixed,'pwl');

end

