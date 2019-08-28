% Optimise Snakes 
tic;
[peaks,band] = peak19(Nd4_XLin);
band = round(band);
%band = [33 40 48 60 74 86 97 109 119 130 140 154 166 175 187 200 212 219 227]; 
%band = [105 120];

dim = length(band);
sigma = 1;
plim = 10;
%
x = 22:28:478;
% 
%y = randi([-3,3],1,length(x));
%y = zeros([dim,length(x)]);

%msk = maskData(mskNd4X,0.1);
msk = maskData(Nd4_XLin,0.1);

%SolidSnake(y,x,band,TstMskArr,sigma,0);
%% 
% h = optimset('MaxFunEvals',20000, 'Algorithm', 'levenberg-marquardt',...
%         'TolX',1e-10,'TolFun',1e-10,'Display','off');
% %now run the fitting
% 
% [NewY, RESNORM,EXITFLAG,OUTPUT] = fminsearch('SolidSnake',y,h,x,band,splnarray,sigma,0);

% 
h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',0.1);
%now run the fitting
resmin = 4e+07;

for i= 1:5
y = ones(dim, length(x)).*rand;
band = round(band + (randi([-150 150],1,19)./100)');
%[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,SPLN,sigma,0,plim);
[NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim);
    if RESNORM <= resmin
        resmin = RESNORM;
        minY = NewY;
        minBand = band;
    end
end 
SolidSnake(minY,x,minBand,msk,sigma,4,plim);

% 
% for i= 1:7
%     
%     band = round(band + (randi([-150 150],1,19)./100)');
%     [NewBand, RESNORM,EXITFLAG,OUTPUT] = fminunc('LiquidSnake',band,h,x,minY,msk,sigma,0,plim);
%     if RESNORM <= resmin
%         resmin = RESNORM;
%         minBand = band;
%     end
% end
% SolidSnake(minY,x,minBand,msk,sigma,4,plim);

% now run the fitting
% resmin = 4e+07;

for i= 1:10
y = ones(dim, length(x)).*rand;

%[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,SPLN,sigma,0,plim);
[NewY, RESNORM,~,~] = fminunc('SolidSnake',y,h,x,minBand,msk,sigma,0,plim);
    if RESNORM <= resmin
        resmin = RESNORM;
        minY = NewY;
    end
end 

%SolidSnake(minY,x,NewBand,msk,sigma,4,plim);
[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',minY,h,x,minBand,msk,sigma,0,plim);

SolidSnake(minY,x,minBand,msk,sigma,4,plim);

SolidSnake(NewY,x,minBand,msk,sigma,4,plim);


%%
%figure, imagesc(SPLN);


%y = randi([-3,3],1,length(x));
% stepp = y;
% stepm = y;
% 
% stepp(1) = stepp(1)+50;
% stepm(1) = stepm(1)-50;
% 
% checkp = SolidSnake(stepp,x,band,splnarray,1,1);
% checkpm = SolidSnake(stepm,x,band,splnarray,1,1);
toc;
