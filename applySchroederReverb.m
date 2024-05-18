function outputSignal = applySchroederReverb(inputSignal, Fs, hpFreq, combDelays, combGains, apDelays, apGains)
    
    % Apply a high-pass filter
    hpFilt = designfilt('highpassiir', 'FilterOrder', 2, 'HalfPowerFrequency', hpFreq, 'SampleRate', Fs);
    filteredSignal = filter(hpFilt, inputSignal);

    % Process all-pass filters sequentially
    apOutput = filteredSignal;
    for i = 1:numel(apDelays)
        D = round(Fs * apDelays(i) / 1000);  % Convert ms to samples
        apOutput = allpassFilter(apOutput, apGains(i), D, length(apOutput));
    end

    % Initialize comb filter outputs
    combOutputs = zeros(length(apOutput), numel(combDelays));

    % Process each comb filter
    for i = 1:numel(combDelays)
        D = round(Fs * combDelays(i) / 1000);  % Convert ms to samples
        combOutputs(:, i) = feedbackCombFilter(apOutput, combGains(i), D, length(apOutput));
    end

    % Sum outputs from all comb filters
    combinedSignal = sum(combOutputs, 2);

    outputSignal = combinedSignal;
end

function output = feedbackCombFilter(input, gain, delay, N)
    output = zeros(N, 1);
    for n = 1:N
        if n > delay
            output(n) = input(n) + gain * output(n - delay);
        else
            output(n) = input(n);
        end
    end
end

function output = allpassFilter(input, gain, delay, N)
    output = zeros(N, 1);
    for n = 1:N
        if n > delay
            output(n) = gain * input(n) + input(n - delay) - gain * output(n - delay);
        else
            output(n) = input(n);
        end
    end
end
