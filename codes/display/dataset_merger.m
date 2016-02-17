clear all;

ALLEEG = [];

path='/arquivos/tcc/Results/olimex/05february2015';
data_train='p300_audio_val.set';


EEG = pop_biosig('/arquivos/tcc/Results/olimex/05february2015/p300_audio_lays.gdf', 'blockepoch','off');



% EEG = pop_loadset('filename',file1,'filepath', path);
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

end_time=EEG.xmax;
half_time=EEG.xmax*2/4;

% EEG = pop_biosig('/arquivos/tcc/Results/olimex/05february2015/p300_audio_lays.gdf', 'blockepoch','off');

% EEG = pop_loadset('filename',file1,'filepath', path);

% EEG = pop_mergeset( ALLEEG, [1  2], 0);

EEG1 = pop_select( EEG,'time',[0 half_time] );

EEG1 = pop_saveset( EEG1, 'filename','p300_audio_train.set','filepath',path);

EEG2 = pop_select( EEG,'time',[half_time end_time] );

EEG2 = pop_saveset( EEG2, 'filename','p300_audio_val.set','filepath',path);