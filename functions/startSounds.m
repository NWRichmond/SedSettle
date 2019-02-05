function startSounds(firstbeeps, secondbeeps, time_between_beeps)
%STARTSOUNDS plays a series of beeps to cue the settling tube operator
%   as to when the sediment should be poured into the column, and serves as
%   the StartFcn for the timer which drives the settling tube data
%   collection process run by the timer used in runSettlingTube.m.
load beeps.mat c_tone e_tone c_major_5x;

t3 = timer();
t3.ExecutionMode = 'singleShot';
t3.StartDelay = time_between_beeps;
t3.TimerFcn = @(~,~)sound(c_major_5x);

t2 = timer();
t2.ExecutionMode = 'fixedRate';
t2.TasksToExecute = secondbeeps;
t2.Period = time_between_beeps;
t2.StartDelay = time_between_beeps;
t2.TimerFcn = @(~,~)sound(e_tone);
t2.StopFcn = @(~,~)start(t3);

t1 = timer();
t1.ExecutionMode = 'fixedRate';
t1.TasksToExecute = firstbeeps;
t1.Period = time_between_beeps;
t1.TimerFcn = @(~,~)sound(c_tone);
t1.StopFcn = @(~,~)start(t2);

start(t1)

end

