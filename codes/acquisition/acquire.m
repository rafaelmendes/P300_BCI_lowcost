% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
clear a;
% Saving names: to be implemented
%folder='20october2014';
%event_names='P300_1.txt';

% environment variables:
n_trials= 50;
n_repetitions= 1;

interval=2;
% View results
% 
run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','/arquivos/tcc/Results/teste/mystream.set');
tic

display('comecou');
pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;
last=0;
for j=1:n_trials
display('new trial')
time_stim=toc;
pause(1);
a{line,1}=num2str(time_stim);
a{line,2}=('trial'); 
line=line+1;

end

onl_clear();
% % 
data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/teste/P300_1.txt');
% % 
pause(3);

EEG=pop_loadset('/arquivos/tcc/Results/teste/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/teste/P300_1.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);

