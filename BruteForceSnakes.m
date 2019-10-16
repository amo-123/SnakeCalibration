
load('./Output/Milan/Nd20SplineData.mat');
%%
fn = 'Nd20SplineData_Milan_BF';
samp = 0.1;

%%

[Xcoordy,Xcoordx] = ocelot(Xspline,Xx,Xstart,Xdata,1,Xplim,samp);

%%
[Ycoordy,Ycoordx] = ocelot(Yspline,Yx,Ystart,Ydata,1,Yplim,samp);

%%

save(['.\Output\',fn],'Xspline','Xx','Xstart','Xdata','Xplim','Yspline','Yx','Ystart','Ydata','Yplim');

