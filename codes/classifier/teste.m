% close all
clear all
% Specifications:

low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

max_amplitude=20; % Defines the maximum amplitude allowed in an epoch

channel=1;

channel_name='Pz';

resample=32; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)

% % 

std= '33025';
odd= '33024';

path='/arquivos/tcc/Results/olimex/17february2015';
data_train='p300_audio_train.set';
data_val='p300_audio_val.set';

ALLEEG=[];
% --- Processing ---

% Loads the EEGDATA to train the model:
EEG = pop_loadset('filepath', path, 'filename', data_val);

% EEG = pop_biosig('/arquivos/tcc/Results/14january2015/train_p300audio.gdf', 'blockepoch','off');

% Selecting relevant channel:
EEG = pop_select( EEG,'channel',{channel_name});
% EEG = pop_select( EEG,'channel',channel);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

channel=1;
%Decimation: (Discard some samples)
EEG = pop_resample( EEG, resample);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% EEGDATA band-pass filtering:
EEG = pop_eegfilt( EEG, low_cutoff, 0, [], [0]);

EEG = pop_eegfilt( EEG, 0, upper_cutoff, [], [0]);

% Epoch Extraction:
EEG_std = pop_epoch( EEG, {std}, [epoch_start epoch_end], 'newname', 'epochs', 'epochinfo', 'yes');
EEG_std = pop_rmbase( EEG_std, [0     epoch_start]);

EEG_odd = pop_epoch( EEG, {odd}, [epoch_start epoch_end], 'newname', 'epochs', 'epochinfo', 'yes');
EEG_odd = pop_rmbase( EEG_odd, [0     epoch_start]);

% Bad Epochs rejection:
[EEG_std indexes] = pop_eegthresh(EEG_std,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
EEG_std = pop_rejepoch( EEG_std, indexes, 0);


[EEG_odd indexes] = pop_eegthresh(EEG_odd,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
EEG_odd = pop_rejepoch( EEG_odd, indexes, 0);

% Reorganizes data to feed the classifier:
trials1=squeeze(EEG_std.data(channel,:,:))';

trials2=squeeze(EEG_odd.data(channel,:,:))';

trials=[trials1;trials2];

targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];

t=logical(targets);

odd_mean=mean(trials(t,:));


std_mean=mean(trials(~t,:));
plot(std_mean);
hold on
plot(odd_mean,'r')


% Data normalization:
trials=normal(trials);

% Prior=[0.7 0.3];

% Feeds data to the classifier:
% W = LDA(trials,targets);

% ------------ LDA ---------------
Input=trials;
Target=targets;

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
    
    A(:,:,i)=cov(Input(Group,:));
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
    Temp = GroupMean(i,:) / (PooledCov);
    
    % Constant
    W(i,1) = -0.5 * Temp * GroupMean(i,:)' + log(PriorProb(i));
    
    % Linear
    W(i,2:end) = Temp;
end

% Applies data to the classifier:
L = [ones(size(trials,1),1) trials] * W';

% Calculates the probability of each class:
P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

% Model accuracy estimation:
Predict=zeros(size(P,1),1);
TP=0;
TN=0;
FN=0;
FP=0;

%Calculate accuracy and sets the probability to -1 or 1
for i=1:size(P,1)
    if P(i,1)<P(i,2)
        Predict(i)=1; 
    else
        Predict(i)=0;
    end
    
    if Predict(i) == targets(i)
        if targets(i)==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    else
        if targets(i)==1
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
end

Accuracy=100*(TP+TN)/(TP+TN+FP+FN)

Selectivity = 100*TP/(TP+FP)

Sensitivity = 100*TP/(TP+FN)

Specificity = 100*TN/(TN+FP)

% ----------------------------------------------------
% Validation

% std= '2';
% odd= '1';

EEG = pop_loadset('filepath', path, 'filename', data_val);
% Selecting relevant channel:
EEG = pop_select( EEG,'channel',{channel_name});
% EEG = pop_select( EEG,'channel',channel);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

channel=1;
%Decimation: (Discard some samples)
EEG = pop_resample( EEG, resample);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% EEGDATA band-pass filtering:
EEG = pop_eegfilt( EEG, low_cutoff, 0, [], [0]);

EEG = pop_eegfilt( EEG, 0, upper_cutoff, [], [0]);

% Epoch Extraction:
EEG_std = pop_epoch( EEG, {std}, [epoch_start epoch_end], 'newname', 'epochs', 'epochinfo', 'yes');
EEG_std = pop_rmbase( EEG_std, [0     epoch_start]);

EEG_odd = pop_epoch( EEG, {odd}, [epoch_start epoch_end], 'newname', 'epochs', 'epochinfo', 'yes');
EEG_odd = pop_rmbase( EEG_odd, [0     epoch_start]);

% Bad Epochs rejection:
% EEG_std = pop_eegthresh(EEG_std,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

% EEG_odd = pop_eegthresh(EEG_odd,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

% Reorganizes data to feed the classifier:
trials1=squeeze(EEG_std.data(channel,:,:))';

trials2=squeeze(EEG_odd.data(channel,:,:))';

trials=[trials1;trials2];

targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];

t=logical(targets);

odd_mean=mean(trials(t,:));

std_mean=mean(trials(~t,:));

% figure;
% plot(std_mean);
% hold on
% plot(odd_mean,'r')


% Data normalization:
trials=normal(trials);

% Applies data to the classifier:
L = [ones(size(trials,1),1) trials] * W';

% Calculates the probability of each class:
P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

% Model accuracy estimation:
Predict=zeros(size(P,1),1);
TP=0;
TN=0;
FN=0;
FP=0;

%Calculate accuracy and sets the probability to -1 or 1
for i=1:size(P,1)
    if P(i,1)<P(i,2)
        Predict(i)=1; 
    else
        Predict(i)=0;
    end
    
    if Predict(i) == targets(i)
        if targets(i)==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    else
        if targets(i)==1
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
end

Accuracy=100*(TP+TN)/(TP+TN+FP+FN)

Selectivity = 100*TP/(TP+FP)

Sensitivity = 100*TP/(TP+FN)

Specificity = 100*TN/(TN+FP)

