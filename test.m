figure(1);
for i = 1:19
    plot(Xcoordx,Xcoordy(:,i),'r-'), hold on;
end
hold on;
for i = 1:41
    plot(Ycoordy(:,i), Ycoordx,'b-'), hold on;
    
end
hold off;