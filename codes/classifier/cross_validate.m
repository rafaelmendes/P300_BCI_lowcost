% function [Accuracy, Selectivity, Sensitivity, Specificity, W] = cross_validate(ALLEEG, EEG, low_cutoff, upper_cutoff, epoch_start,...
%     epoch_end, max_amplitude, channel, std, odd, channel_name, resample)
clear all
close all

% Specifications:

low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

epoch_start=0; % latency before the event for epoch extraction
epoch_end=1; % latency after the event for epoch extraction

max_amplitude=50; % Defines the maximum amplitude allowed in an epoch

% channel=1;

channel_name='Pz';

resample=32; % Downsampling the signal to guarantee that the number of training
% samples is greater than the number of samples (avoid singular matrices)

std= '1';
odd= '2';


ALLEEG=[];

EEG = pop_loadset('filepath','/arquivos/tcc/Results/02dezember2014/p300_audio_1sec.set');
% EEG = pop_biosig('/arquivos/tcc/Results/05january2015/rafael/p300_audio/train_p300audio.gdf', 'blockepoch','off');

% Selecting relevant channel:
EEG = pop_select( EEG,'channel',{channel_name });
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
EEG_std = pop_eegthresh(EEG_std,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

EEG_odd = pop_eegthresh(EEG_odd,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

% Reorganizes data to feed the classifier:
trials1=squeeze(EEG_std.data(channel,:,:))';

trials2=squeeze(EEG_odd.data(channel,:,:))';

targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];

trials=[trials1;trials2];

% Accuracy= zeros(size(trials,1),1);
% Selectivity = zeros(size(trials,1),1);
% Sensitivity = zeros(size(trials,1),1);
% Specificity = zeros(size(trials,1),1);

TP=0;
TN=0;
FN=0;
FP=0;
for j=1:size(targets)
% j=80;        
    trial_val = trials(j,:);
    target_val = targets(j);
    
    trials(j,:)=[];
    targets(j)=[];
    
    % Data normalization:
%     trials=normal(trials);

    % Prior=[0.7 0.3];

    % Feeds data to the classifier:
    [W] = LDA(trials,targets);

%     W=W/max(max(abs(W))); % Normalization of the projection matrix

    % Applies data to the classifier:
    L = [1 trial_val] * W';

    % Calculates the probability of each class:
    P = exp(L) ./ repmat(sum(exp(L),2),[1 2]);

    % Model accuracy estimation:


    %Calculate accuracy and sets the probability to -1 or 1
    if P(1,1)<P(1,2)
        Predict=1; 
    else
        Predict=0;
    end

    if Predict == target_val
        if target_val==1
            TP=TP+1;
        else
            TN=TN+1;
        end
    else
        if target_val==1
            FN=FN+1;
        else
            FP=FP+1;
        end
    end
    
    trials=[trials1;trials2];
    targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];
end

Accuracy=100*(TP+TN)/(TP+TN+FP+FN)

Selectivity = 100*TP/(TP+FP)

Sensitivity = 100*TP/(TP+FN)

Specificity = 100*TN/(TN+FN)



