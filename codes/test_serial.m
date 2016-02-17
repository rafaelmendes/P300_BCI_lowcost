n_trials= 100;
n_repetitions= 1;
n=0;
m=0;
x=1;
b=0;
terminator='CR';
timeout=20;
line=2;

% Open serial port monitor:
ser=serial('/dev/ttyS101');
set(ser,'terminator', terminator, 'timeout', timeout, 'inputbuffersize', 50, 'BaudRate', 9600,'DataBits',8, 'StopBits',1);
fopen(ser);

pause(2)

tic;
try
while(1)    
    y=fscanf(ser, '%d',4)
    
        time_stim=toc;
        if (y<=50)
            a{line,2}=('std');
            
        else 
            if (y<=75);
                a{line,2}=('left'); 
            else
                a{line,2}=('right'); 
            end
        end
        
        a{line,1}=num2str(time_stim);
        line=line+1;  
    

end
catch exception

    fclose(ser);
    delete(ser);
    clear ser;
    
    data=dataset({a 'latency','type'});
	
    export(data,'file','/arquivos/tcc/Results/20october2014/eventmarkers/tactile.txt');
    %freeserial;
end