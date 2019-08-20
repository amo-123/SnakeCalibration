% Optimise Snakes 
band = [107,120]; 
sigma = 0.8;
plim = 20;
% 
x = 22:28:478;
% 
%y = randi([-3,3],1,length(x));
y = [zeros([1,length(x)]);...
    zeros([1,length(x)])];

%SolidSnake(y,x,band,TstMskArr,sigma,0);
% % 
% h = optimset('MaxFunEvals',20000, 'Algorithm', 'levenberg-marquardt',...
%         'TolX',1e-10,'TolFun',1e-10,'Display','off');
% %now run the fitting
% 
% [NewY, RESNORM,EXITFLAG,OUTPUT] = fminsearch('SolidSnake',y,h,x,band,splnarray,sigma,0);

% 
h = optimset('MaxFunEvals',1000, 'Algorithm', 'levenberg-marquardt',...
        'TolX',1e-10,'TolFun',1e-10,'Display','off','FinDiffRelStep',1);
%now run the fitting

[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,SPLN,sigma,0,plim);
msk = maskData(mskNd4X,0.01);
%mskArray = reshape(msk, 1, []);
%[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim);

NY = SolidSnake(NewY,x,band,SPLN,sigma,4,plim);

%NY = SolidSnake(NewY,x,band,msk,sigma,4,plim);

%%
%figure, imagesc(SPLN);

%%

%y = randi([-3,3],1,length(x));
% stepp = y;
% stepm = y;
% 
% stepp(1) = stepp(1)+50;
% stepm(1) = stepm(1)-50;
% 
% checkp = SolidSnake(stepp,x,band,splnarray,1,1);
% checkpm = SolidSnake(stepm,x,band,splnarray,1,1);

