function [Accuracy, Selectivity, Sensitivity, Specificity] = validate(ALLEEG, EEG, low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, channel_name, resample, W)

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
% max_amplitude=10000;
% [EEG_std, indexes] = pop_eegthresh(EEG_std,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
% EEG_std = pop_rejepoch( EEG_std, indexes, 0);
% 
% [EEG_odd, indexes]  = pop_eegthresh(EEG_odd,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
% EEG_odd = pop_rejepoch( EEG_odd, indexes, 0);

% Reorganizes data to feed the classifier:
trials1=squeeze(EEG_std.data(channel,:,:))';

trials2=squeeze(EEG_odd.data(channel,:,:))';

trials=[trials1;trials2];

targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];

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
        if targets(i)== 1
            TP=TP+1;
        else
            TN=TN+1;
        end
    else
        if targets(i)== 1
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
end

Accuracy=100*(TP+TN)/(TP+TN+FP+FN);

Selectivity = 100*TP/(TP+FP);

Sensitivity = 100*TP/(TP+FN);

Specificity = 100*TN/(TN+FP);



end