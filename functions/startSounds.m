function startSounds(~, ~)
%STARTSOUNDS Summary of this function goes here
%   Detailed explanation goes here
load gong.mat y;
beep on
t = timer();
t.ExecutionMode = 'fixedRate';
t.TasksToExecute = 5;
t.Period = 1;
t.TimerFcn = @(~,thisEvent)sound(2);
t.StopFcn = @(~,thisEvent)sound(y);
start(t)
end

