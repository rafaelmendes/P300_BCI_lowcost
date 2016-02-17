clear all;close all;

features=20;

% Generate example data: 2 groups, of 10 and 15, respectively
X = [randn(10,features); randn(15,features) + 1.5];  Y = [zeros(10,1); ones(15,1)];

% Calculate linear discriminant coefficients
W = LDA(X,Y);

W=W/max(max(W))

% Calulcate linear scores for training data
L = [ones(25,1) X] * W';

% Calculate class probabilities
P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
