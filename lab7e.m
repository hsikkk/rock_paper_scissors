% Q-learning for rock paper scissors
% written by Sae-Young Chung on 2017/4/13

max_steps=1000;
alpha=0.05;        % learning rate
gamma=0.95;        % discount factor
rand0=1;           % initial randomness for epsilon-greedy action
rand1=0;           % final randomness for epsilon-greedy action
rand_T=max_steps/2;  % time duration during which epsilon is changed from rand0 to rand1
reward=zeros(max_steps,1);
r=0;

Q=zeros(3,3,3);     % previous action of opponent, previous action of player, current action of player
                    % current state = (previous action of opponent, previous action of player)
opponent_prev=1;    % initial state (opponent's previous action = 1)
player_prev=1;      % initial state (player's previous action = 1)
for j=1:max_steps
    randomness=(rand1-rand0)*min((j-1)/(rand_T-1),1)+rand0;  % epsilon value
    if rand(1)<randomness
        player_action=randi(3);    % random action for the player
    else
        q=Q(opponent_prev,player_prev,:);
        max_a=find(max(q)==q);    % find the actions that maximize Q (there may be more than one)
        player_action=max_a(randi(length(max_a)));      % pick one of them randomly (random tie break)
    end

    % opponent's action: same as before if won, same as opponent if lost, random if tie in the previous game
    if r==1  % player won in the previous game, opponent chooses to play the same hand as the player
        opponent_action=player_prev;
    elseif r==-1  % opponent won in the previous game, opponent chooses to play the same hand
        opponent_action=opponent_prev;
    else  % tie in the previous game, opponent chooses a random action
        opponent_action=randi(3);
    end
    
%     if(randi(10)>8)
%         opponent_action = randi(3);
%     end
    

    % calculate the current reward for the player
    % action: 1: paper, 2: rock, 3: scissors
    if mod(player_action - opponent_action, 3) == 2
        r=1;    % win
    elseif mod(player_action - opponent_action, 3) == 1
        r=-1;   % loss
    else
        r=0;    % tie
    end
    reward(j)=r;
    Q(opponent_prev,player_prev,player_action)=(1-alpha)*Q(opponent_prev,player_prev,player_action)+alpha*(r+gamma*max(Q(opponent_action,player_action,:)));

    % update state
    opponent_prev=opponent_action;
    player_prev=player_action;
end

% average reward for the games when epsilon is equal to rand1
mean(reward(rand_T+1:max_steps))

% calculate greedy action based on Q values
greedy_action=zeros(3,3);
for i=1:3,
    for j=1:3
        [mx,greedy_action(i,j)]=max(Q(i,j,:));
    end
end

% print out greedy action for the player based on the outcome of the previous game
labels='prs';
disp('  prs')
disp(sprintf('p %s', labels(greedy_action(1,:))))
disp(sprintf('r %s', labels(greedy_action(2,:))))
disp(sprintf('s %s', labels(greedy_action(3,:))))
