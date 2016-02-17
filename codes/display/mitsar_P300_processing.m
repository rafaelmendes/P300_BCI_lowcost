close all

% Local variables:
max_value=100;
smooth=10;
ALLEEG = [];
epoch_start=0;
epoch_end=0.6;

EEG = pop_loadset('filename','200trials_08interv_2.set','filepath','/arquivos/tcc/Results/11november2014/cleison/p300_audio');

% EEG = pop_biosig('/arquivos/tcc/Results/18nov_mitsar/resultados/p300_audio.gdf', 'blockepoch','off');

% Delete unconnected channels
% EEG = pop_select( EEG,'nochannel',{'FT7' 'FC3' 'FCz' 'FC4' 'FT8' 'TP7' 'CP3' 'CPz' 'CP4' 'TP8' 'FPz' 'Oz' 'CH_Event' 'Bio1' 'O2'});
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = pop_select( EEG,'channel',{'Fz' 'P3' });
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 

%Re referencing data
EEG = pop_reref( EEG,1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref','overwrite','on','gui','off');

% EEG = pop_select( EEG,'channel',{'P3'});

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
EEG = pop_epoch( EEG, {  'std'  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt std','gui','off'); 

EEG = pop_rmbase( EEG, [0     0]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,0,0.598,0,1);

EEG=pop_rejepoch(EEG, [INDEXES],0);


[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Move:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 

EEG = pop_epoch( EEG, {  'odd'  }, [epoch_start  epoch_end], 'newname', 'ref filt epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','ref filt odd','gui','off'); 

EEG = pop_rmbase( EEG, [0     0]);

[EEG INDEXES] = pop_eegthresh(EEG,1,1,-max_value,max_value,0,0.598,0,1);

EEG=pop_rejepoch(EEG, [INDEXES],0);

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
% Data plotting
% odd: 
figure; pop_erpimage(EEG,1, [1],[],'odd erp',smooth,1,{ 'odd'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [15] EEG.chanlocs EEG.chaninfo } );

% Std:
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
figure; pop_erpimage(EEG,1, [1],[],'std erp',smooth,1,{ 'std'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [15] EEG.chanlocs EEG.chaninfo } );
