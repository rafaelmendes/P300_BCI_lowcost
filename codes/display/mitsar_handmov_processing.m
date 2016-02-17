% close all

% Local variables:
max_value=100;
epoch_start=2;
epoch_end=3;
lower_cutoff_freq=1;
upper_cutoff_freq=15;

channel=1;
% eeglab;
channel_name='C3';

ALLEEG = [];

path='/arquivos/tcc/Results/olimex/04february2015';
data_train='handmov_train.set';
data_val='handmov_val.set';
% data_val='esquerda_30_imag.set';

EEG = pop_loadset('filename', data_val ,'filepath',path);

% Delete unconnected channels
% EEG = pop_select( EEG,'nochannel',{'FT7' 'FC3' 'FCz' 'FC4' 'FT8' 'TP7' 'CP3' 'CPz' 'CP4' 'TP8' 'FPz' 'Oz' 'CH_Event' 'Bio1' 'O2'});
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

%Re referencing data
% EEG = pop_reref( EEG, []);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref','overwrite','on','gui','off');

EEG = pop_select( EEG,'channel',{channel_name});
% EEG = pop_select( EEG,'channel',channel);

% [ALLEEG] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% EEG = pop_resample( EEG, 250);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Filtering
EEG = pop_eegfilt( EEG, lower_cutoff_freq, 0, [], [0]);
% [ALLEEG] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt','overwrite','on','gui','off'); 

EEG = pop_eegfilt( EEG, 0, upper_cutoff_freq, [], [0]);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Epoch extraction
% Stop:
EEG_rest = pop_epoch( EEG, {  'Rest'  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt stop','gui','off'); 

EEG_rest = pop_rmbase( EEG_rest, []);

[EEG_rest, INDEXES] = pop_eegthresh(EEG_rest,1,1,-max_value,max_value, epoch_start, epoch_end,0,1);
EEG_rest=pop_rejepoch(EEG_rest, [INDEXES],0);

% Move:
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 

EEG_move = pop_epoch( EEG, {  'Move'  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt move','gui','off'); 

EEG_move = pop_rmbase( EEG_move, []);

[EEG_move, INDEXES] = pop_eegthresh(EEG_move,1,1,-max_value,max_value, epoch_start, epoch_end, 0,1);
EEG_move=pop_rejepoch(EEG_move, INDEXES,0);

% [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% Data plotting
% Move: 
pop_prop( EEG_move, 1, 1, NaN, {'freqrange' [lower_cutoff_freq upper_cutoff_freq] });
title('Move')
% Stop:
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
pop_prop( EEG_rest, 1, 1, NaN, {'freqrange' [lower_cutoff_freq upper_cutoff_freq] });
title('Rest')