% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

ALLEEG = [];

EEG = pop_biosig('/arquivos/tcc/Results/12dezember2014/ade.EDF');

[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = eeg_checkset( EEG );

EEG = pop_importevent( EEG, 'append','no','timeunit',1,'align',0);
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

EEG = pop_importevent( EEG, 'event','/arquivos/tcc/Results/12dezember2014/adee.TXT','fields',{'type' 'latency'},'skipline',1,'timeunit',1,'optimalign','off');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );


EEG = pop_saveset( EEG, 'filename','ade.set','filepath','/arquivos/tcc/Results/12dezember2014/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);