nx=25; ny=50;
x0=6.9; y0=7.1;
x1=(0:nx-1)*(4*pi/nx);
dy=sin(x1);
ay=y0+dy;
y1=(0:ny-1)*(6*pi/ny);
dx=sin(y1);
ax=x0+dx;
figure(1)
plot(x1,ones(1,nx)*y0,'b--',ones(1,ny)*x0,y1,'r--')
hold on, plot(x1,ay,'+b',ax,y1,'+r'), hold off

%%
x2=x1'*ones(1,ny);
y2=ones(nx,1)*y1;
ay2=ay'*ones(1,ny);
ax2=ones(nx,1)*ax;

dd = sqrt( (x2-ax2).^2 + (ay2-y2).^2 );

[~,i1] = min(dd(:));
ix = mod( (i1-1), nx ) + 1;
iy = fix( (i1-1) / nx ) + 1;

figure(2)
imagesc(flipud(ax2')),colorbar

xy = mean([x1(ix),ay(ix);ax(iy),y1(iy)]);
disp(xy)

figure(1)
hold on, plot(xy(1),xy(2),'.k'), hold off
