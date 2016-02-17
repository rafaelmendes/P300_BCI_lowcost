clear all

SZ=get(0,'ScreenSize');

% dots = imread('/../Figures/pontos.jpg');
% right = imread('/../Figures/right_arrow.jpg');

circle = imread('../Figures/bola.jpeg');
task = imread('../Figures/quadrado.jpeg');
stop = imread('../Figures/stop.jpeg');
hand = imread('../Figures/hand.jpeg');
white = imread('../Figures/branco.jpeg');

circle = imresize(circle, [SZ(4) SZ(3)]);
hand = imresize(hand, [SZ(4) SZ(3)]);
stop = imresize(stop, [SZ(4) SZ(3)]);
task = imresize(task, [SZ(4) SZ(3)]);
white = imresize(white, [SZ(4) SZ(3)]);


j=0;
% figure(1);
while(j<5)

fullscreen(circle,1);

pause(2);

fullscreen(hand,1);
pause(1);

fullscreen(task,1);
pause(3);

fullscreen(white,1);
pause(1);

j=j+1;
end
