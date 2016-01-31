clear
clc

data = csvread('Matlab-Ready-Data/parted.data.csv',1);

data = data(data(:,1)>0,:);
data = data(data(:,2) < Inf & data(:,2)>0,:);

PHI = sum( data(:,3) );
D = data(:,2)./PHI;
g = data(:,1);

A = linprog( -D', [], [],...
    ones(1,length(D)), 1000,...
    zeros(1,length(D)), g');

csvwrite('Maximized-Data/partitioned.csv',[data(:,4) A*1E5])

clear
clc
data = csvread('Matlab-Ready-Data/full.data.csv',1);


data = data(data(:,1)>0,:);
data = data(data(:,2) < Inf & data(:,2)>0,:);

PHI = sum( data(:,3) );
D = data(:,2)./PHI;
g = data(:,1);

A = linprog( -D', [], [],...
    ones(1,length(D)), 1000,...
    zeros(1,length(D)), g');

csvwrite('Maximized-Data/full.csv',[data(:,4) A*1E5])