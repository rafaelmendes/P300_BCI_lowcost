% close all
clear all
% Local variables:
max_value=400;
smooth=10;
ALLEEG = [];
epoch_start=0;
epoch_end=1;

std= 'std';
odd= 'right';
% 
path='/arquivos/tcc/Results/olimex/04february2015';
data_train='p300_tactile_rafael.set';
% data_val='p300_audio_val.set';

% eeglab;
resamp_freq=32;

low_cutoff=0.5; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=10; % band pass filter upper cutoff frequency (Hz)

channel_name='Pz';

channel=1;
% 
EEG = pop_loadset('filename', data_train ,'filepath',path);

% EEG = pop_biosig('/arquivos/tcc/Results/olimex/14january2015/train_p300audio.gdf', 'blockepoch','off');

% Delete unconnected channels
EEG = pop_select( EEG,'channel',{channel_name});
% EEG = pop_select( EEG,'channel',channel);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

%Re referencing data
% EEG = pop_reref( EEG,1);
% % EEG = pop_reref( EEG,[]);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref','overwrite','on','gui','off');

% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
% 
% EEG = pop_resample( EEG, resamp_freq);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Filtering
EEG = pop_eegfilt( EEG, low_cutoff, 0, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt','overwrite','on','gui','off'); 

EEG = pop_eegfilt( EEG, 0, upper_cutoff, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% EEG = pop_editset(EEG, 'srate', [500]); % alter sampling rate
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off');


% Epoch extraction
% Stop:
EEG = pop_epoch( EEG, {  std  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt std','gui','off'); 

EEG = pop_rmbase( EEG, [0     epoch_start]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,epoch_start, epoch_end,0,1);

EEG=pop_rejepoch(EEG, [INDEXES],0);


[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Move:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 

EEG = pop_epoch( EEG, {  odd  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt odd','gui','off'); 

EEG = pop_rmbase( EEG, [0     epoch_start]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,epoch_start, epoch_end,0,1);

EEG=pop_rejepoch(EEG, [INDEXES],0);

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Data plotting
% odd: 
figure; pop_erpimage(EEG,1, 1,[],'odd erp',smooth,1,{ odd},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { 15 EEG.chanlocs EEG.chaninfo } );

% Std:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
figure; pop_erpimage(EEG,1, 1,[],'std erp',smooth,1,{ std },[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { 15 EEG.chanlocs EEG.chaninfo } );
