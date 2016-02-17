function [W] = onl_calibration_handmov(low_cutoff, upper_cutoff, epoch_start,...
    epoch_end, max_amplitude, channel, std, odd, resample)


% onl_acquireEEG_P300_audio_psytb();

ALLEEG=[];
% Loads the EEGDATA to train the model:
EEG = pop_loadset('filename','handmov_marina.set','filepath','/arquivos/tcc/Results/olimex/17february2015/');

% Selecting relevant channel:
EEG = pop_select( EEG,'channel', channel);
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

EEG_odd = pop_epoch( EEG, {odd}, [epoch_start epoch_end], 'newname', 'epochs', 'epochinfo', 'yes');

% Bad Epochs rejection:
EEG_std = pop_eegthresh(EEG_std,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

EEG_odd = pop_eegthresh(EEG_odd,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);

% Reorganizes data to feed the classifier:
trials1=squeeze(EEG_std.data(channel,:,:))';

trials2=squeeze(EEG_odd.data(channel,:,:))';

trials=[trials1;trials2];

targets=[zeros(EEG_std.trials,1); ones(EEG_odd.trials,1)];

% Data normalization:
trials=normal(trials);

% Prior=[0.7 0.3];

% Feeds data to the classifier:
W = LDA(trials,targets);

% W=W/max(max(abs(W))); % Normalization of the projection matrix

end