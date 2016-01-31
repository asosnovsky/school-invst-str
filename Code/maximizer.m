clear
clc

data = csvread('Matlab-Ready-Data/parted.data.csv',1);

data = data(data(:,1)>0,:);
data = data(data(:,2)>0,:);

g = data(:,1);
PHI = length(g);
D = data(:,2)./PHI;

A = linprog( -D', [], [],...
    ones(1,length(D)), 1000,...
    zeros(1,length(D)), g');

csvwrite('Maximized-Data/partitioned.csv',[data(:,4) A*1E5 A*1E5./data(:,3)])
disp(1E5*D'*A);
clear

data = csvread('Matlab-Ready-Data/full.data.csv',1);

data = data(data(:,1)>0,:);
data = data(data(:,2)>0,:);

g = data(:,1);
PHI = length(g);
D = data(:,2)./PHI;

A = linprog( -D', [], [],...
    ones(1,length(D)), 1000,...
    zeros(1,length(D)), g');
disp(1E5*D'*A);
csvwrite('Maximized-Data/full.csv',[data(:,4) A*1E5 A*1E5./data(:,3)])