% Q-learning example
% written by Sae-Young Chung on 2016/08/08

% state action  next  reward  terminal 
%   1      A      2      0      Yes
%   1      B      3      0      No
%   3      A      4      1      Yes
%   3      B      5      0      Yes

n_states=5;       % number of states
n_actions=2;      % number of actions
n_episodes=10;   % number of episodes to run
max_steps=1e9;
alpha=0.2;        % learning rate
gamma=0.9;        % discount factor
reward=[0 0;0 0;1 0;0 0;0 0];      % reward for each (state,action)
terminal=[0;1;0;1;1];              % 1 if terminal state, 0 otherwise
next_state=[2 3;0 0;4 5;0 0;0 0];   % new_state
rand0=1;
rand1=0;
rand_T=n_episodes;

init_state=1;     % initial state

% Q learning
[Q,n_trials,rewards]=learn_Q(init_state, n_states, n_actions, n_episodes, rand0, rand1, rand_T, max_steps, alpha, gamma, reward, terminal, next_state);

sum(n_trials)
Q
