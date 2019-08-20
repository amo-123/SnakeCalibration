% SPLINE Test Script

band = [107,120];
dim = length(band);
x = 22:48:478;
rng = 5;
y = [randi([-rng,rng],1,length(x));...
    randi([-rng,rng],1,length(x))];
SPLN = zeros([258,506]);
yy = 22:478;
Snk = zeros(size(yy));

for i = 1:dim
    pp = spline(x,[0 y(i,:) 0]);
    
    Snk(i,:) = ppval(pp,yy);
end
%figure, plot(x,y,'o',yy,Snk,'-')
for j = 1:dim
    for i = 1:length(yy)
        SPLN(round(band(j)+Snk(j,i)),round(yy(i))) = 1;
    end
end

%%

NRM = sum(sum(mskNd4X))/sum(sum(SPLN));

SPLN = NRM*SPLN;
SPLN = imgaussfilt(SPLN,1);
figure, imagesc(SPLN);

%%

% splnarray = reshape(SPLN,1,[]);
% 
% figure, plot(msk4XArray,'.r'), hold on, plot(SPLNArray,'x');
% 
% sumRes = sum((msk4XArray - SPLNArray).^2);

%%