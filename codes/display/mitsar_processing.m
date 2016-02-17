close all;
clear all;

smoothlevel=1;

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','p300_100trials_2.set','filepath','/arquivos/tcc/Results/mitsar/23october2014/cleison/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'nochannel',{'O2'});
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','p3001','overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_eegfilt( EEG, 0.5, 0, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','p3001_filt','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_eegfilt( EEG, 0, 35, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','p3001_filt_avg','gui','off'); 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',3,'study',0); 
EEG = eeg_checkset( EEG );
%epochs extraction
EEG = pop_epoch( EEG, {  'std'  }, [-0.2         0.8], 'newname', 'p3001_filt_avg epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname','p3001_filt_avg_std','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',3,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'odd'  }, [-0.2         0.8], 'newname', 'p3001_filt_avg epochs', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname','p3001_filt_avg_odd','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'retrieve',4,'study',0); 
EEG = eeg_checkset( EEG );
figure; pop_erpimage(EEG,1, [26],[],'epochs average std',smoothlevel,1,{ 'std'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [26] EEG.chanlocs EEG.chaninfo } );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',5,'study',0); 
EEG = eeg_checkset( EEG );
figure; pop_erpimage(EEG,1, [26],[],'epochs average odd',smoothlevel,1,{ 'odd'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [26] EEG.chanlocs EEG.chaninfo } );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'retrieve',3,'study',0); 
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, 16);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','p3001_filt_Fpz','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'std'  }, [-0.2         0.8], 'newname', 'p3001_filt_Fpz_std', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'retrieve',6,'study',0); 
EEG = eeg_checkset( EEG );
EEG = pop_epoch( EEG, {  'odd'  }, [-0.2         0.8], 'newname', 'p3001_filt_Fpz_odd', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-200    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8,'retrieve',7,'study',0); 
EEG = eeg_checkset( EEG );
figure; pop_erpimage(EEG,1, [26],[],'epochs Fpz avg std',smoothlevel,1,{ 'std'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [26] EEG.chanlocs EEG.chaninfo } );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'retrieve',8,'study',0); 
EEG = eeg_checkset( EEG );
figure; pop_erpimage(EEG,1, [26],[],'epochs Fpz avg odd',smoothlevel,1,{ 'odd'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [26] EEG.chanlocs EEG.chaninfo } );
