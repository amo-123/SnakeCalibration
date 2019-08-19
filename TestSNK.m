% SPLINE Test Script

x = 22:35:478;
y = randi([-10,10],1,length(x));
pp = spline(x,[0 y 0]);

SPLN = zeros([258,506]);
yy = 22:478;
Snk = ppval(pp,yy);

figure, plot(x,y,'o',yy,Snk,'-')

band = 130;

for i = 1:length(yy)
SPLN(round(band+Snk(i)),round(yy(i))) = 1;
end

%%

NRM = sum(sum(mskNd4X))/sum(sum(SPLN));

SPLN = NRM*SPLN;
SPLN = imgaussfilt(SPLN,1);
figure, imagesc(SPLN);

%%

splnarray = reshape(SPLN,1,[]);
% 
% figure, plot(msk4XArray,'.r'), hold on, plot(SPLNArray,'x');
% 
% sumRes = sum((msk4XArray - SPLNArray).^2);

%%