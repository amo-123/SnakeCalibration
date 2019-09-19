figure;
for i = 1:19
    plot(XcoordY,round(Xcoord(:,i)),'r-','LineWidth',1), hold on;
end
hold on;
for i = 1:41
    plot(round(Ycoord(:,i)), YcoordX,'b-','LineWidth',1), hold on;
    
end
hold off;