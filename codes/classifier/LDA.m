% LDA - MATLAB subroutine to perform linear discriminant analysis
% by Will Dwinnell and Deniz Sevis
%
% Use:
% W = LDA(Input,Target,Priors)
%
% W       = discovered linear coefficients (first column is the constants)
% Input   = predictor data (variables in columns, observations in rows)
% Target  = target variable (class labels)
% Priors  = vector of prior probabilities (optional)
%
% Note: discriminant coefficients are stored in W in the order of unique(Target)
%
% Example:
%
% % Generate example data: 2 groups, of 10 and 15, respectively
% Input = [randn(10,2); randn(15,2) + 1.5];  Target = [zeros(10,1); ones(15,1)];
% 
% % Calculate linear discriminant coefficients
% W = LDA(X,Y);
% 
% % Calulcate linear scores for training data
% L = [ones(25,1) X] * W';
% 
% % Calculate class probabilities
% P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
% %
% %
% % Last modified: Dec-11-2010


function [W] = LDA(Input,Target,Priors)

% Determine size of input data
[n, m] = size(Input);

% Discover and count unique class labels
ClassLabel = unique(Target);
k = length(ClassLabel);

% Initialize
nGroup     = NaN(k,1);     % Group counts
GroupMean  = NaN(k,m);     % Group sample means
PooledCov  = zeros(m,m);   % Pooled covariance
W          = NaN(k,m+1);   % model coefficients

% if  (nargin >= 3)  PriorProb = Priors;  end

% Loop over classes to perform intermediate calculations
for i = 1:k,
    % Establish location and size of each class
    Group      = (Target == ClassLabel(i)); %group get 1 if the equality is true. Group is logical (class)
    nGroup(i)  = sum(double(Group)); %To sum up the ones in Group, Group needs to be converted to class double
    
    % Calculate group mean vectors
    GroupMean(i,:) = mean(Input(Group,:));
    
    % Accumulate pooled covariance information
    PooledCov = PooledCov + ((nGroup(i) - 1) / (n - k) ).* cov(Input(Group,:));
end

% Assign prior probabilities
if  (nargin >= 3)
    % Use the user-supplied priors
    PriorProb = Priors;
else
    % Use the sample probabilities
    PriorProb = nGroup / n;
end

% Loop over classes to calculate linear discriminant coefficients
for i = 1:k,
    % Intermediate calculation for efficiency
    % This replaces:  GroupMean(g,:) * inv(PooledCov)
    Temp = GroupMean(i,:) / PooledCov; % Original
%     Temp = GroupMean(i,:) * pinv(PooledCov);

    
    % Constant
    W(i,1) = -0.5 * Temp * GroupMean(i,:)' + log(PriorProb(i));
    
    % Linear
    W(i,2:end) = Temp;
end

% Housekeeping
clear Temp

end


% EOF


