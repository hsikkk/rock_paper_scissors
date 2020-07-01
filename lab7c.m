% The following needs to be done before running this code.
% It needs to be done only once.
% ee405('servomonitor',servo_id)

servo_id=5; % change this to your servo's id
figure	% create a new figure window (if you don't want the previous figure to be erased)
subplot(2,2,1); % first subplot of 2x2 figures
h1=plot(0,0);   % empty plot (with a point at (0,0))
title('position'); grid on
axis([0 100 0 1023]) % set the ranges of x and y axes
subplot(2,2,2); % second subplot of 2x2 figures
h2=plot(0,0);   % empty plot (with a point at (0,0))
title('speed'); grid on
axis([0 100 -1023 1023]) % set the ranges of x and y axes
subplot(2,2,3); % third subplot of 2x2 figures
h3=plot(0,0);   % empty plot (with a point at (0,0))
title('load'); grid on
axis([0 100 -1023 1023]) % set the ranges of x and y axes
[pos0,speed0,load0]=ee405('getservo',servo_id);
while 1           % infinite loop. You can stop it by typing Ctrl-C
    for k=1:100,
        [pos,speed,load]=ee405('getservo',servo_id);
        if k>1
            subplot(2,2,1); hold on; plot([k-1,k],[pos0, pos],'b');
            subplot(2,2,2); hold on; plot([k-1,k],[speed0, speed],'g');
            subplot(2,2,3); hold on; plot([k-1,k],[load0, load],'r');
            drawnow
        end
        pos0=pos;
        speed0=speed;
        load0=load;
    end
    subplot(2,2,1); hold off; plot(0,0); axis([0 100 0 1023]); title('position'); grid on
    subplot(2,2,2); hold off; plot(0,0); axis([0 100 -1023 1023]); title('speed'); grid on
    subplot(2,2,3); hold off; plot(0,0); axis([0 100 -1023 1023]); title('load'); grid on
    drawnow	% draw immediately without waiting until the end of program
end


