  
vermelho = imread('Figures/vermelho.jpg');
verde = imread('Figures/verde.jpg');

[w, screenRect]=Screen('OpenWindow', 0, 0,[],32,2);

Index=Screen('MakeTexture', w, verde);
Index2=Screen('MakeTexture', w, vermelho);   
pause(5)
try


    Screen('DrawTexture',w, Index); % now visible on screen
    Screen(w, 'Flip');
    while KbCheck; end % clear keyboard queue
    while ~KbCheck; end % wait for a key press 
      
   
    Screen('DrawTexture',w, Index2); % now visible on screen
    Screen(w, 'Flip');
    while KbCheck; end % clear keyboard queue
    while ~KbCheck; end % wait for a key press          
       
    Screen('CloseAll'); 
catch
    Screen('CloseAll');
    rethrow(lasterror);
    
end