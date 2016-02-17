clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));

% environment variables:
n_trials= 10;
n_repetitions= 1;

load('W.mat');

%% instantiate the library
disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1},360,64);

% Receive data chunk
i=1;
disp('Now receiving chunked data...');
% Predict=zeros(1000,1);
ch1=zeros(1,64);

while true
    % get chunk from the inlet
    [chunk,stamps] = inlet.pull_chunk();
    for s=1:length(stamps)
        % and display it
        fprintf('%.2f\t',chunk(:,s));
        fprintf('%.5f\n',stamps(s));
        ch1(s)=chunk(1,s); % channel selection
    end
    pause(0.05)
    
%     ch1=downsample(chunk(1,:), 4);

    % Calculates the linear scores (projections):
    L = [1 ch1] * W';
    P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);
%   
    if P(1)<P(2)
        Predict(i)=1; 
    else
        Predict(i)=0;
    end
    
    i=i+1;

    chunk=[];
end
        

    







%%


