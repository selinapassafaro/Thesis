function overnightChanges

for Indx_P = 1:numel(Participants)

    % sleep
    Source = fullfile(Paths.Data, 'EEG', 'Unlocked', 'window4s_full', 'Sleep');
    Filename = strjoin({Participants{Indx_P}, 'Sleep', Night, 'Welch.mat'}, '_');

    if ~exist(fullfile(Source, Filename), 'file')
        warning(['Missing ', Filename])
    else
        load(fullfile(Source, Filename), 'Power', 'Freqs', 'Chanlocs', 'visnum')
        KeepChannels = labels2indexes(Keep, Chanlocs);

        % assign bin for each epoch
        NREM = find(ismember(visnum, [-2 -3]));
        Hours = discretize(NREM, linspace(1, max(NREM), TotHours+1));

        % average power for each stage
        for Indx_H = 1:TotHours
            Epochs = NREM(Hours==Indx_H);
            AllPower(Indx_P, Indx_H, :, :) = squeeze(mean(Power(KeepChannels, Epochs, :), 2, 'omitnan'));
        end
    end

    disp(['Finished ', Participants{Indx_P}])
end