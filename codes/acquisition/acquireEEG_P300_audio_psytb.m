% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
clear a;
% Saving names: to be implemented
%folder='20october2014';
%event_names='P300_1.txt';

FREQUENCY=48000;
CHANNELS=1; % MONO

InitializePsychSound(0);
pahandle = PsychPortAudio('Open', [], 1, [], FREQUENCY, CHANNELS, [], 0.010);

standard=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/2000_100ms.wav');
odd=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/1000_100ms.wav');

% environment variables:
n_trials= 100;
n_repetitions= 1;

interval=2;
% View results
% 
run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','/arquivos/tcc/Results/15dezember2014/mystream.set');
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
 
            
            PsychPortAudio('FillBuffer', pahandle,standard');
            
            PsychPortAudio('Start', pahandle);
            time_stim=toc;
            %PsychPortAudio('Stop', pahandle, 1);
            %sound(standard, 48000); %delay of 36 ms
            
            a{line,2}=('std');
            
            last=0;
            

        %if and(y>=0.7, last==0) 
        else
            
            PsychPortAudio('FillBuffer', pahandle,odd');
            
            PsychPortAudio('Start', pahandle);
            time_stim=toc;
            %PsychPortAudio('Stop', pahandle, 1);
            %sound(odd, 48000); % delay of 36 ms
            
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

export(data,'file','/arquivos/tcc/Results/15dezember2014/P300_4.txt');
% % 
pause(3);

EEG=pop_loadset('/arquivos/tcc/Results/15dezember2014/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/15dezember2014/P300_4.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);

PsychPortAudio('Close', pahandle);
