clear a 
% addpath(genpath('C:\Users\MEN08P\Documents\CSIRO\BCILAB-Program'));

relax = imread('Figures\relax.jpg');
close = imread('Figures\closeeye.jpg');
stop = imread('Figures\stop.jpg');
dots = imread('Figures\pontos.jpg');
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','mystream');
tic

pause(30)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

for j=2:2:30
    imshow(relax);
    pause(2.5);
    a{j,2}=('Rest');
    a{j,1}=num2str(toc);
    pause(2.5);
    
	imshow(dots); 
    pause(0.5);
    
    y=randi(2);
    if y==1
        imshow(close,[]);
        a{j+1,2}=('Close');
        time=toc;
        pause(1)
        pause(6)
        a{j+1,1}=num2str(time);
    end
    
    if y==2
        a{j+1,2}=('Open'); 
        imshow(stop,[]);
        time=toc;
        pause(1)
        a{j+1,1}=num2str(time);
    end
    
end

onl_clear()

data=dataset({a 'latency','type'});

export(data,'file','C:\Users\MEN08P\Documents\CSIRO\Results\16 DEC\Events markers\eyeclose.txt');

EEG=pop_loadset('C:\Users\MEN08P\Documents\CSIRO\BCILAB-Program\bcilab-1.1-beta\userdata\mystream.set');


EEG=pop_importevent(EEG, ...
    'event', 'C:\Users\MEN08P\Documents\CSIRO\Results\16 DEC\Events markers\eyeclose.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
