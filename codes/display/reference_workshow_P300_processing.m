close all
clear all

% Local variables:
max_value=12;

ALLEEG = [];


EEG = pop_loadset('filename','SimpleOddball.set','filepath','/arquivos/Documents/eeglab_workshop/pendrive/');

%Re referencing data
EEG = pop_reref( EEG, []);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref','overwrite','on','gui','off');

EEG = pop_select( EEG,'channel',{'Pz'});

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% EEG = pop_resample( EEG, 250);
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Filtering
EEG = pop_eegfilt( EEG, 1, 0, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt','overwrite','on','gui','off'); 

EEG = pop_eegfilt( EEG, 0, 12, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

% Epoch extraction
% Stop:
EEG = pop_epoch( EEG, {  '1'  }, [0  0.6], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt std','gui','off'); 

EEG = pop_rmbase( EEG, [0     0]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,0,0.598,0,1);

EEG=pop_rejepoch(EEG, [INDEXES]);


[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Move:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 

EEG = pop_epoch( EEG, {  '2'  }, [0  0.6], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt odd','gui','off'); 

EEG = pop_rmbase( EEG, [0     0]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,0,0.598,0,1);

EEG=pop_rejepoch(EEG, [INDEXES]);

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Data plotting
% odd: 
figure; pop_erpimage(EEG,1, [1],[],'odd erp',5,1,{ '2'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [15] EEG.chanlocs EEG.chaninfo } );

% Std:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
figure; pop_erpimage(EEG,1, [1],[],'std erp',5,1,{ '1'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [15] EEG.chanlocs EEG.chaninfo } );
