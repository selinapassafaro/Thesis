function [Power, Freqs] = sleep_power_Sophia(EEG, artndxn, fs, nChannels, Freqs)
% calculates power for each scoring epoch.
% Power is ch x epoch x f
% EEG is eeglab structure
% artndxn is ch x epoch matrix of 1s and 0s, where 1 is an artefact
% scoringlen (seconds) is duration of an epoch
% WelchWindow (seconds) is duration of window over which to calculate FFT
% Overlap (0-1) is amount of overlap of welchwindow.


WelchWindow = 4; % in seconds
Overlap = 0.5;
scoringlen = 20;


Starts = round(1:fs*scoringlen:size(EEG, 2));
Ends = round(Starts+fs*scoringlen-1);

if Ends(end) > size(EEG, 2) && Ends(end-1) < size(EEG, 2)
    Ends(end) = [];
    Starts(end) = [];
end

[~, nEpochs] = size(artndxn);


if numel(Starts) ~= size(artndxn, 2)
    warning('mismatch between EEG size and artefact matrix')
    New = ones(nChannels, numel(Starts));
    if size(artndxn, 2) < numel(Starts)
        New(1:nChannels, 1:size(artndxn, 2)) = artndxn;
    else
        New = artndxn(:, 1:numel(Starts));
    end
    artndxn = New;
end

% just to get frequencies
%[~, ~] = quickPower(EEG(1, 1:Ends(1)), fs, WelchWindow, Overlap);
Power = nan(nChannels, nEpochs, numel(Freqs));

% parfor Indx_E = 1:size(artndxn, 2)

    for Indx_E = 1:size(artndxn, 2)
        KeepCh = find(artndxn(:, Indx_E));

        % skip if all nans
        if numel(KeepCh)==0
            continue
        end


        Data = EEG(KeepCh, Starts(Indx_E):Ends(Indx_E));


        % FFT
        Pwr = nan(nChannels, numel(Freqs));
        [Pwr(KeepCh, :), ~] = quickerPower(Data, fs, WelchWindow, Overlap);
        Power(:, Indx_E, :) = Pwr;
    end