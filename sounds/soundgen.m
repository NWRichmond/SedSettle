% This script is based on Gary Scavone's
% script made for McGill's MUMT 307 course, available at:
% http://www.music.mcgill.ca/~gary/307/week1/matlab.html
%% configure signal settings
 duration = 0.35;                % duration in seconds
 amplitude = 0.3;               % amplitude
 c_hz = 2093;
 d_hz = 2349;
 e_hz = 2637;
 f_hz = 2793;
 g_hz = 3136;
 cc_hz = 4186;
 tones = cell(1,6);
 notes = [c_hz, d_hz, e_hz, f_hz, g_hz, cc_hz];
 for i = 1:size(notes,2)
     f1 = notes(i);                      % frequency in Hertz
     f2 = f1/4;
     f3 = f1/2;
     phi = 2*pi*0.5;                % phase offset, e.g.: 2*pi*0.25 = 1/4 cycle
     %% configure output settings
     fs = 8192;                    % sampling rate
     T = 1/fs;                      % sampling period
     t = 0:T:duration;              % time vector
     %% create the signal
     omega1 = 2*pi*f1;              % angular frequency in radians
     omega2 = 2*pi*f2;
     omega3 = 2*pi*f3;
     partial1 = cos(omega1*t + phi)*amplitude;      % sinusoidal partial 1
     partial2 = cos(omega2*t + phi)*amplitude;      % sinusoidal partial 2
     partial3 = cos(omega3*t + phi)*amplitude;      % sinusoidal partial 3
     signal = (partial1 + partial2 + partial3)/3;
     tones{i} = signal;
 end
 %% play the signal
 c = tones{1};
 d = tones{2};
 e = tones{3};
 f = tones{4};
 g = tones{5};
 cc = tones{6};
 c_major = horzcat(c,e,g,cc);
 c_major_5x = repmat(c_major,1,5);