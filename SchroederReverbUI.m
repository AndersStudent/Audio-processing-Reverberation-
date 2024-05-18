function SchroederReverbUI
    % Create a UI figure
    fig = uifigure('Name', 'Schroeder Reverb Control Panel', 'Position', [100, 100, 400, 500]);

    % Load Button
    loadButton = uibutton(fig, 'push', 'Text', 'Load Audio', 'Position', [50, 460, 100, 30]);
    loadButton.ButtonPushedFcn = @(btn, event) loadAudioFile();

    % Display file name
    filenameLabel = uilabel(fig, 'Position', [160, 460, 220, 30], 'Text', 'No file loaded');

    % High-pass filter Controls
    uilabel(fig, 'Text', 'High-pass Frequency (Hz)', 'Position', [50, 420, 150, 22]);
    hpSlider = uislider(fig, 'Position', [200, 420, 150, 3], 'Limits', [50, 1000], 'Value', 200);

    % Comb Filter Controls
    uilabel(fig, 'Text', 'Comb Delay (ms)', 'Position', [50, 360, 150, 22]);
    combDelaySlider = uislider(fig, 'Position', [200, 370, 150, 3], 'Limits', [20, 100], 'Value', 50);
    uilabel(fig, 'Text', 'Comb Gain', 'Position', [50, 310, 150, 22]);
    combGainSlider = uislider(fig, 'Position', [200, 320, 150, 3], 'Limits', [0.5, 0.9], 'Value', 0.7);

    % All-Pass Filter Controls
    uilabel(fig, 'Text', 'AP Delay (ms)', 'Position', [50, 260, 150, 22]);
    apDelaySlider = uislider(fig, 'Position', [200, 270, 150, 3], 'Limits', [1, 10], 'Value', 5);
    uilabel(fig, 'Text', 'AP Gain', 'Position', [50, 210, 150, 22]);
    apGainSlider = uislider(fig, 'Position', [200, 220, 150, 3], 'Limits', [0.1, 0.9], 'Value', 0.7);

    % Apply Button
    applyButton = uibutton(fig, 'push', 'Text', 'Apply Reverb', 'Position', [125, 100, 150, 30]);
    applyButton.ButtonPushedFcn = @(btn, event) applyReverb();

    % Stop Button
    stopButton = uibutton(fig, 'push', 'Text', 'Stop Playback', 'Position', [125, 60, 150, 30]);
    stopButton.ButtonPushedFcn = @(btn, event) stopPlayback();


    filename = '';

    % Internal function to load audio
    function loadAudioFile
        [file, path] = uigetfile({'*.wav;*.mp3', 'Audio Files (*.wav, *.mp3)'});
        if isequal(file, 0)
            disp('User selected Cancel');
        else
            filename = fullfile(path, file);
            filenameLabel.Text = file;
            [inputSignal, Fs] = audioread(filename);
            disp(['User selected ', filename]);
        end
    end

    % Function to apply reverb
    function applyReverb

        clear sound;
        [inputSignal, Fs] = audioread(filename);

        if exist('inputSignal', 'var')
            % Apply reverb with current settings
            outputSignal = applySchroederReverb(inputSignal, Fs, hpSlider.Value, ...
                                                [combDelaySlider.Value], [combGainSlider.Value], ...
                                                [apDelaySlider.Value], [apGainSlider.Value]);
            % Play the sound
            sound(outputSignal, Fs);
        else
            uialert(fig, 'Load an audio file first!', 'File Not Loaded');
        end
    end

    % Function to stop playback
    function stopPlayback
       clear sound;  
    end


end
