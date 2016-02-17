
resample=64;

filter_order = 3;                   
filter_cutoff = [1/resample 12/resample]; % 1 to 12 Hz  

[b, a] = butter(filter_order,filter_cutoff);


disp('Loading the library...');
lib = lsl_loadlib();

% resolve a stream...
disp('Resolving an EEG stream...');
result = {};
while isempty(result)
    result = lsl_resolve_byprop(lib,'type','EEG'); end

% create a new inlet
disp('Opening an inlet...');
inlet = lsl_inlet(result{1},1000,256);


[chunk,stamps] = inlet.pull_chunk();
while true
    
      
    pause(1);  
    [chunk,stamps] = inlet.pull_chunk();
    
    chunk'
    
   
    ch1=chunk(1,:);
    
    ch1=ch1(1:4:end);
    
    
end
