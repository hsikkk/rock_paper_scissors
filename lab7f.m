% Q-learning for rock paper scissors
% Human opponent's hand is classified using deep learning.
% This assumes ee405 function is already initialized and the following variables are already defined
%   greedy_action, cam, servo_ids.
% greedy_action: greedy action determined by lab7e.m
% cam: webcam variable, e.g., 'cam=webcam', 'cam=webcam(1)', 'cam=webcam(2)', etc.
% servo_ids: 1x2 vector of servo id's of your servo motors
% You may need to change values of paper_servo_pos, rock_servo_pos, scissors_servo_pos.
% written by Sae-Young Chung on 2017/4/13

%servo_ids=[5 6];  % change this to servo id's of your servo motors
paper_servo_pos=[210 210];
rock_servo_pos=[650 650];
scissors_servo_pos=[210 650];
servo_pos=paper_servo_pos;
ee405('servo',servo_ids, servo_pos);

names={'', 'paper','rock','scissors'};

tic
img_var_avg=0;
scores=zeros(4,1);
player_prev=1;    % assume previous action of player was paper
opponent_prev=1;  % assume previous action of human player was paper
while 1
    im=snapshot(cam);

    % Pre-process the images as required for the CNN
    img = imresize(im, [227 227]);
    img_var=std(double(reshape(img,227*227*3,1))/255);  % this will be used to detect presence of hand
    [img_var, img_var_avg]
    
    if img_var > 1.5 * img_var_avg && toc > 2   % if presence of hand is detected and more than 2 seconds passed from the last play
        disp('Opponent''s hand present. Starting a new play')
        player_action=greedy_action(opponent_prev, player_prev);
        if player_action==1   % paper
            servo_pos=paper_servo_pos;
        elseif player_action==2    % rock
            servo_pos=rock_servo_pos;
        else    % scissors
            servo_pos=scissors_servo_pos;
        end
        ee405('servo',servo_ids, servo_pos);

        tic
        while toc < 1   % timeout is 1 second
            im=snapshot(cam);

            % Pre-process the images as required for the CNN
            img = imresize(im, [227 227]);
            img_var=std(double(reshape(img,227*227*3,1))/255);

            % Extract image features using the CNN
            imageFeatures = activations(net, img, featureLayer);
            % Make a prediction using the classifier
            [label,scores] = predict(classifier, imageFeatures);
            sorted_scores=sort(scores,'descend');

            opponent_action=0;  % blank
            if sorted_scores(1) > -0.2 && sorted_scores(2) < -0.4   % if the score for the best label is high enough and the score for the second best label is low enough
                if label=='paper'
                    opponent_action=1;
                elseif label=='rock'
                    opponent_action=2;
                elseif label=='scissors'
                    opponent_action=3;
                end
            end

            imshow(im)
            text(30,30,sprintf('human opponent: %s,  me: %s', names{opponent_action+1}, names{player_action+1}));
            text(30,60,sprintf('%f ',scores));  % scores for blank, paper, rock, scissors
            drawnow
            ee405('servo',servo_ids, servo_pos);
            if opponent_action>0
                opponent_prev=opponent_action;
                player_prev=player_action;
                break;
            end
        end
        tic   % to reset timeout
    else
        imshow(im)
        text(30,30,sprintf('human opponent: %s,  me: %s', names{opponent_prev+1}, names{player_prev+1}));
        text(30,60,sprintf('%f ',scores));  % scores for blank, paper, rock, scissors
        drawnow
        ee405('servo',servo_ids, servo_pos);
    end

    img_var_avg=0.9*img_var_avg + 0.1*img_var;    % averaging with time constant of 10 frames
end
