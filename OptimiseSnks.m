% Optimise Snakes 
band = 130; 
sigma = 1;
% 
x = 22:48:478;
% 
%y = randi([-3,3],1,length(x));
y = [band ones([1,length(x)])];

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

[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,splnarray,sigma,0);

%[NewY, RESNORM,EXITFLAG,OUTPUT] = fminunc('SolidSnake',y,h,x,130,mskArray,sigma,0);


NY = SolidSnake(NewY,x,mskArray,1,4);

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

