clear a 
% addpath(genpath('/arquivos/tcc/software/BCILAB-Program'));
% environment variables:
n_trials= 10;
monitor=1;
probabilidade_verde=0.2;
ps_inter_est=2;
% set(0,'DefaultFigurePosition', [-1000 378 560 420]);
 

vermelho = imread('Figures/vermelho.jpg');
verde = imread('Figures/verde.jpg');
fundo = imread('Figures/fundo.jpg');


[w, screenRect]=Screen('OpenWindow', 0, 0,[],32,2);

Index_verde=Screen('MakeTexture', w, verde);
Index_vermelho=Screen('MakeTexture', w, vermelho);   
Index_fundo=Screen('MakeTexture', w, fundo);   

% Screen('DrawTexture',w, Index_verde); % now visible on screen
% Screen(w, 'Flip');
% Screen('DrawTexture',w, Index_vermelho); % now visible on screen
% Screen(w, 'Flip');
% Screen('DrawTexture',w, Index_fundo); % now visible on screen
% Screen(w, 'Flip');
 

% run_readlsl('property', 'name', 'value', 'Mitsar EEG 202 - A', 'update_freq', 20);
% 
% run_writedataset('out_filename','mystream.set');
tic

try

pause(3)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

line=2;



for j=1:n_trials

    Screen('DrawTexture',w, Index_fundo); % now visible on screen
    Screen(w, 'Flip');
    pause(ps_inter_est);
    
    y=rand(1);
    
    if y<probabilidade_verde
        Screen('DrawTexture',w, Index_verde); % now visible on screen
        a{line,1}=num2str(toc);
        Screen(w, 'Flip');
        a{line,2}=('verde');
    else
        Screen('DrawTexture',w, Index_vermelho); % now visible on screen
        a{line,1}=num2str(toc);
        Screen(w, 'Flip');
        a{line,2}=('vermelho');
    end
    
    line=line+1;
    
    % Detecta se o usuario apertou o espaco no teclado
    key=getkeywait(0.5);
    time_but=toc;
    
    if key == 32
                
        a{line,2}=('botao');
        a{line,1}=num2str(time_but);
        line=line+1;
               
    end       
end

Screen('Closeall') 
% 
% onl_clear()
% 
% fim=toc;
% 
% closescreen();
% 
% data=dataset({a 'latency','type'});
% 
% export(data,'file','C:\Users\LEC\Documents\experimento_hiago\gonogo.txt');
% 
% pause(3)
% 
% EEG=pop_loadset('mystream.set');
% 
% EEG=pop_importevent(EEG, ...
%     'event', 'C:\Users\LEC\Documents\experimento_hiago\gonogo.txt',...
%     'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);
% 
% pop_saveset(EEG);
% 
% pop_eegplot(EEG);

catch
    
Screen('Closeall')    
    
end
