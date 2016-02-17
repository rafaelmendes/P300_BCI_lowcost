% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
clear a;
% Saving names: to be implemented
%folder='20october2014';
%event_names='P300_1.txt';

standard=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/2000.wav');
odd=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/1000.wav');
sound(standard, 48000);
sound(odd, 48000);

% environment variables:
n_trials= 10;
n_repetitions= 1;

interval=0.7;
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','/arquivos/tcc/Results/11november2014/mystream.set');
tic

pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;
last=0;
for j=1:n_trials

    
    for i=1:n_repetitions;


        y=rand(1);
        
        if or(y<0.75, and(y>=0.75, last==1))
            time_stim=toc 
            sound(standard, 48000); %delay of 36 ms
            
            a{line,2}=('std');
            
            last=0;
            

        %if and(y>=0.7, last==0) 
        else
            time_stim=toc
            sound(odd, 48000); % delay of 36 ms
            
            a{line,2}=('odd');       
            
            last=1;
            
        end
        
        a{line,1}=num2str(time_stim);
        line=line+1;  
        
        
    end
    
    pause(interval)
end

onl_clear();
% % 
data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/11november2014/eventmarkers/P300_1.txt');
% % 
pause(3);

EEG=pop_loadset('/arquivos/tcc/Results/11november2014/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/11november2014/eventmarkers/P300_1.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
