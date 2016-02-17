% function [W] = myLDA(Input,Target,Priors)
Input = [randn(10,2); randn(15,2) + 1.5];  Target = [zeros(10,1); ones(15,1)];
% Determine size of input data
[n, m] = size(Input);

% Discover and count unique class labels
ClassLabel = unique(Target);
k = length(ClassLabel);

% Initialize
nGroup     = NaN(k,1);     % Group counts
GroupMean  = NaN(k,m);     % Group sample means
Sw         = zeros(m,m);   % Pooled covariance
W          = NaN(k,m+1);   % model coefficients

% if  (nargin >= 3)  PriorProb = Priors;  end

% Loop over classes to perform intermediate calculations
for i = 1:k,
    % Establish location and size of each class
    Group      = (Target == ClassLabel(i)); %group get 1 if the equality is true. Group is logical (class)
    nGroup(i)  = sum(double(Group)); %To sum up the ones in Group, Group needs to be converted to class double
    
    % Calculate group mean vectors
    GroupMean(i,:) = mean(Input(Group,:));
    
    Sw = Sw + nGroup(i)*cov(Input(Group,:));
    
    % Accumulate pooled covariance information
%     PooledCov = PooledCov + ((nGroup(i) - 1) / (n - k) ).* cov(Input(Group,:));
end

W=(GroupMean(1,:)-GroupMean(2,:)) / Sw;

L = [Input] * W';
