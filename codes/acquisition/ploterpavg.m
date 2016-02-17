% Configuration Variables:

close all
ALLEEG = pop_delset( ALLEEG, [5 4 3 2 1] ); % Clears all data set

channel=1; % Selects the channel to plot the ERP average
low_cutoff=1; % band pass filter lower cutoff frequency (Hz)
upper_cutoff=15; % band pass filter upper cutoff frequency (Hz)

epoch_start=-0.2; % latency before the event for epoch extraction
epoch_end=0.5; % latency after the event for epoch extraction

max_amplitude=300; % Defines the maximum amplitude allowed in an epoch

% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_loadset('filename','100PzMPzM_4.set','filepath','/arquivos/tcc/Results/20october2014');
% EEG = pop_loadset('filename','p300_100singletrialPzMC3C4.set','filepath','/arquivos/tcc/Results/03september2014/p300_threebeeps/');

[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG=pop_chanedit(EEG, 'lookup','/arquivos/tcc/software/BCILAB-Program/BCILAB-1.1/dependencies/eeglab_10_0_1_0x/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp','changefield',{1 'labels' 'Pz'});

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG=pop_chanedit(EEG, 'lookup','/arquivos/tcc/software/BCILAB-Program/BCILAB-1.1/dependencies/eeglab_10_0_1_0x/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');

[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG = eeg_checkset( EEG );

% EEG = pop_select( EEG,'nochannel',{'Channel 1'});

EEG = pop_eegfilt( EEG, low_cutoff, 0, [], [0]);

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','filtered','gui','off'); 

EEG = eeg_checkset( EEG );

EEG = pop_eegfilt( EEG, 0, upper_cutoff, [], [0]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'overwrite','on','gui','off'); 

EEG = eeg_checkset( EEG );

EEG = pop_epoch( EEG, {  'std'  }, [epoch_start           epoch_end], 'newname', 'filtered epochs std', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 

EEG = eeg_checkset( EEG );

EEG = pop_rmbase( EEG, [epoch_start*1000    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',2,'study',0); 
EEG = eeg_checkset( EEG );

EEG = pop_epoch( EEG, {  'odd'  }, [epoch_start           epoch_end], 'newname', 'filtered epochs odd', 'epochinfo', 'yes');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off'); 
EEG = eeg_checkset( EEG );

EEG = pop_rmbase( EEG, [epoch_start*1000    0]);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% pop_eegthresh -> reject epochs with extreme values
% pop_eegthresh( data, type rejection (0 ICA, 1 RAW), [electrodes], lower limit, upperlimit, start time, end time,
% display market epochs for rejection, reject marked trials)
EEG = pop_eegthresh(EEG,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);


[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',3,'study',0); 
EEG = eeg_checkset( EEG );

% pop_eegthresh -> reject epochs with extreme values
% pop_eegthresh( data, type rejection (0 ICA, 1 RAW), [electrodes], lowerlimit, upperlimit, starttime, endtime,
% display market epochs for rejection, reject marked trials)
EEG = pop_eegthresh(EEG,1, channel,-max_amplitude, max_amplitude, epoch_start, epoch_end, 0, 1);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

% pop_eegplot( EEG, 1, 1, 1);


figure; pop_erpimage(EEG,1, [channel],[],'Standard ERP average',10,1,{ 'std'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',4,'study',0); 
EEG = eeg_checkset( EEG );

figure; pop_erpimage(EEG,1, [channel],[],'Odd ERP average',10,1,{ 'odd'},[],'latency' ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );