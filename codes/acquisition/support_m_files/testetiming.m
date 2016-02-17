

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','/arquivos/tcc/Results/27october2014/mystream.set');
tic

pause(3)


onl_clear();
% % 
data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/27october2014/eventmarkers/P300_1.txt');
% % 
pause(3);

EEG=pop_loadset('/arquivos/tcc/Results/27october2014/mystream.set');

pop_saveset(EEG);

pop_eegplot(EEG);
