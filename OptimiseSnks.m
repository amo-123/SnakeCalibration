% Optimise Snakes 
tic;
band = [33 40 48 60 74 88 97 109 122 130 140 154 166 175 187 200 212 219 227]; 
sigma = 0.5;
plim = 30;
% 
x = 22:30:478;
% 
%y = randi([-3,3],1,length(x));
y = zeros([19,length(x)]);
    
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

%[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,SPLN,sigma,0,plim);
%msk = maskData(mskNd4X,0.01);
msk = maskData(Nd4_XLin,0.000001);
%mskArray = reshape(msk, 1, []);
[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,band,msk,sigma,0,plim);



%NY = SolidSnake(NewY,x,band,SPLN,sigma,4,plim);

NY = SolidSnake(NewY,x,band,msk,sigma,4,plim);

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
toc;
