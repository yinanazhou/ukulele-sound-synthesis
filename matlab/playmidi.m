function y = playmidi(fs, filename, x, model)
% play midi file using generated ukulele sound

% velo_index = 0;

% read midi file
midiFile = readmidi(filename);

% get parameters
note_pitch = midiFile(:, 4);        % pitch
note_pitch = midi2hz(note_pitch);   % convert pitch to frequency
% note_pitch = note_pitch .*2;        % frequency shift if needed

onset = midiFile(:, 6);             % onset
onset = round(onset*fs)+1;          % onset sample index
Dur = midiFile(:, 7);               % duration
DurN = round(Dur.*fs);              % convert duration into # sample
offset = onset+DurN-1;              % offset sample index
N = max(offset);                    % # last sample -> total duration sample

velo = velocity(midiFile);          % velocity

% initialize output
y = zeros(1, N);

for n = 1:length(note_pitch)
    if model == 1
        % digital waveguide
        note = playDW(fs, note_pitch(n), DurN(n), x, velo(n));
    elseif model == 2
        % ks
        note = playKS(fs, note_pitch(n), DurN(n), x, velo(n));
    end

    y(onset(n):offset(n)) = y(onset(n):offset(n)) + note(1:DurN(n));
end

% playsound(midiFile)

end