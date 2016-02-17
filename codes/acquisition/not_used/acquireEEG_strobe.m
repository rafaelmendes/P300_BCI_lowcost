clear a 
% addpath(genpath('C:\Users\MEN08P\Documents\CSIRO\BCILAB-Program'));

relax = imread('Figures\relax.jpg');
strobe = imread('Figures\strobe.jpg');
dots = imread('Figures\pontos.jpg');
% View results

run_readlsl('property', 'name', 'value', 'OpenEEG Modular EEG P2', 'update_freq', 20);

run_writedataset('out_filename','mystream');
tic

pause(30)
a{1,2}=('Instruc_begin');
a{1,1}=num2str(toc);

for j=2:2:100
    imshow(relax);
    pause(2.5);
    a{j,2}=('Rest');
    a{j,1}=num2str(toc);
    pause(2.5);
    
	imshow(dots); 
    pause(0.5);
    
    
    a{j+1,2}=('Strobe'); 
    imshow(strobe,[]);
    time=toc;
	pause(1)
    a{j+1,1}=num2str(time);
    pause(9)
end

onl_clear()

data=dataset({a 'latency','type'});

export(data,'file','C:\Users\MEN08P\Documents\CSIRO\Results\16 DEC\Events markers\strobe.txt');

EEG=pop_loadset('C:\Users\MEN08P\Documents\CSIRO\BCILAB-Program\bcilab-1.1-beta\userdata\mystream.set');


EEG=pop_importevent(EEG, ...
    'event', 'C:\Users\MEN08P\Documents\CSIRO\Results\16 DEC\Events markers\strobe.txt',...
    'fields', {'latency','type'}, 'append', 'no','skipline',1,'timeunit', 1);

pop_saveset(EEG);

pop_eegplot(EEG);
