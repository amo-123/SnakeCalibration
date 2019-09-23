function [xy] = MGS(Xcoordy,Xcoordx,Ycoordy,Ycoordx)
% Matrix Gets Snakes
% [xy] = MGS(Xcoordy,Xcoordx,Ycoordy,Ycoordx)% 
% Determines the crossing points of a given data set 
% Input: 
% X/Ycoordy : values of data sets X and Y 
% X/Ycoordx : coordinates of data sets X and Y 
% Output: 
% xy : Crossing points of data X and Y 
% Author: Kjell Erlandsson, UCL
ny=length(Ycoordx); 
nx=length(Xcoordx);

%%
Xmatx=Xcoordx'*ones(1,ny);
Ymatx=ones(nx,1)*Ycoordx;
Xmaty=Xcoordy*ones(1,ny);
Ymaty=ones(nx,1)*Ycoordy';

dd = sqrt( (Xmatx-Ymaty).^2 + (Xmaty-Ymatx).^2 );

[~,i1] = min(dd(:));
ix = mod( (i1-1), nx ) + 1;
iy = fix( (i1-1) / nx ) + 1;

xy = mean([Xcoordx(ix),Xcoordy(ix);Ycoordy(iy),Ycoordx(iy)]);


end

