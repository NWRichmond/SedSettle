function startSounds(~, ~)
%STARTSOUNDS Summary of this function goes here
%   Detailed explanation goes here
load beeps.mat c_tone e_tone c_major_5x;

t3 = timer();
t3.ExecutionMode = 'singleShot';
t3.StartDelay = 2;
t3.TimerFcn = @(~,thisEvent)sound(c_major_5x);

t2 = timer();
t2.ExecutionMode = 'fixedRate';
t2.TasksToExecute = 4;
t2.Period = 2;
t2.StartDelay = 2;
t2.TimerFcn = @(~,thisEvent)sound(e_tone);
t2.StopFcn = @(~,thisEvent)start(t3);

t1 = timer();
t1.ExecutionMode = 'fixedRate';
t1.TasksToExecute = 10;
t1.Period = 2;
t1.TimerFcn = @(~,thisEvent)sound(c_tone);
t1.StopFcn = @(~,thisEvent)start(t2);

start(t1)
end

