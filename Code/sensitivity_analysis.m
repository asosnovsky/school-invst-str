clear
clc

numOfInst = 21000;

data = csvread('Matlab-Ready-Data/sensitivity_analysis/one_std/parted.data.csv',1);
[~,I] = sort(data(:,5),'descend');
data = data(I,:);

data = data(data(:,1)>0,:);
data = data(data(:,2)>0,:);
data = data((data(:,3)'.*data(:,1)'./data(:,4)')>1,:);


%data = data(1:10,:);
noI = min(numOfInst,size(data,1));
g   = data(1:noI,1)';
PHI = length(g);
D   = data(1:noI,2)'./PHI;
phi = data(1:noI,3)';
T   = data(1:noI,4)';

n = linprog( -D, [], [],...
    T, 1E8,...
    ones(1,length(D)), floor(phi.*g./T) );
D*floor(n)

csvwrite('Maximized-Data/sensitivity_analysis/one_std/partitioned.csv',[data(1:noI,6) floor(n) floor(n).*T' D'.*floor(n)])

%disp(1E5*D'*A);
clear
%clc

numOfInst = 21000;

data = csvread('Matlab-Ready-Data/sensitivity_analysis/two_std/parted.data.csv',1);
[~,I] = sort(data(:,5),'descend');
data = data(I,:);

data = data(data(:,1)>0,:);
data = data(data(:,2)>0,:);
data = data((data(:,3)'.*data(:,1)'./data(:,4)')>1,:);


%data = data(1:10,:);
noI = min(numOfInst,size(data,1));
g   = data(1:noI,1)';
PHI = length(g);
D   = data(1:noI,2)'./PHI;
phi = data(1:noI,3)';
T   = data(1:noI,4)';

n = linprog( -D, [], [],...
    T, 1E8,...
    ones(1,length(D)), floor(phi.*g./T) );
D*floor(n)

csvwrite('Maximized-Data/sensitivity_analysis/two_std/partitioned.csv',[data(1:noI,6) floor(n) floor(n).*T' D'.*floor(n)])
%disp(1E5*D'*A);
clear
%clc

numOfInst = 21000;

data = csvread('Matlab-Ready-Data/sensitivity_analysis/three_std/parted.data.csv',1);
[~,I] = sort(data(:,5),'descend');
data = data(I,:);

data = data(data(:,1)>0,:);
data = data(data(:,2)>0,:);
data = data((data(:,3)'.*data(:,1)'./data(:,4)')>1,:);


%data = data(1:10,:);
noI = min(numOfInst,size(data,1));
g   = data(1:noI,1)';
PHI = length(g);
D   = data(1:noI,2)'./PHI;
phi = data(1:noI,3)';
T   = data(1:noI,4)';

n = linprog( -D, [], [],...
    T, 1E8,...
    ones(1,length(D)), floor(phi.*g./T) );
D*floor(n)

csvwrite('Maximized-Data/sensitivity_analysis/three_std/partitioned.csv',[data(1:noI,6) floor(n) floor(n).*T' D'.*floor(n)])
%disp(1E5*D'*A);

%% Results
% 1std
%ans =
%
%    0.0353
% 2std
%ans =
%
%    0.0499
% 3std
%ans =
%
%    0.0474