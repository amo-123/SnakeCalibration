function [xy] = MGS(Xcoordy,Xcoordx,Ycoordy,Ycoordx)

ny=length(Ycoordx); 
nx=length(Xcoordx);
% x0=6.9; y0=7.1;
% x1=(0:nx-1)*(4*pi/nx);
% dy=sin(x1);
% ay=y0+dy;
% y1=(0:ny-1)*(6*pi/ny);
% dx=sin(y1);
% ax=x0+dx;
%figure(1)
%plot(Xcoordx,Xcoordy,'-b',Ycoordy,Ycoordx,'-r');

%%
Xmatx=Xcoordx'*ones(1,ny);
Ymatx=ones(nx,1)*Ycoordx;
Xmaty=Xcoordy*ones(1,ny);
Ymaty=ones(nx,1)*Ycoordy';

dd = sqrt( (Xmatx-Ymaty).^2 + (Xmaty-Ymatx).^2 );

[~,i1] = min(dd(:));
ix = mod( (i1-1), nx ) + 1;
iy = fix( (i1-1) / nx ) + 1;

%figure(2)
%imagesc(flipud(Ymaty')),colorbar

xy = mean([Xcoordx(ix),Xcoordy(ix);Ycoordy(iy),Ycoordx(iy)]);
%disp(xy)

%figure(1)
%hold on, plot(xy(1),xy(2),'.k'), hold off



end

