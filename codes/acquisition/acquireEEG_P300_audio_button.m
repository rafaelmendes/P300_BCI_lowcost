% clear all 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
clear a;
% Saving names: to be implemented
%folder='20october2014';
%event_names='P300_1.txt';

standard=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/2000.wav');
odd=audioread('/arquivos/tcc/matlab_implement/acquisition/sounds/1000.wav');


% environment variables:
n_trials= 200;
n_repetitions= 1;

response_delay=0.7;
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','/arquivos/tcc/Results/27october2014/mystream.set');
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
            time_stim=toc; 
            sound(standard, 48000); %delay of 36 ms
            stim_delay=toc;
            
            key=getkeywait(response_delay); % introduces 80ms delay
            time_but=toc;
            
            pause(response_delay-(time_but-stim_delay));
            
            a{line,2}=('std');
            
            last=0;
            

        %if and(y>=0.7, last==0) 
        else
            time_stim=toc; 
            sound(odd, 48000); % delay of 36 ms
            stim_delay=toc;
            
            key=getkeywait(response_delay); % introduces 80ms delay
            time_but=toc;
            
            pause(response_delay-(time_but-stim_delay));
            
            a{line,2}=('odd');       
            
            last=1;
            
        end
        
        a{line,1}=num2str(stim_delay);
        line=line+1;  
        
        if key ~= -1
                
            a{line,2}=('button');
            a{line,1}=num2str(time_but);
            line=line+1;
               
        end 
    end
end

onl_clear();
% 
data=dataset({a 'latency','type'});

export(data,'file','/arquivos/tcc/Results/27october2014/eventmarkers/P300_1.txt');
% 
pause(3);

EEG=pop_loadset('/arquivos/tcc/Results/27october2014/mystream.set');


EEG=pop_importevent(EEG, ...
    'event', '/arquivos/tcc/Results/27october2014/eventmarkers/P300_1.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
