function [Power, PowerStages, Freq, VOutput, Sizes] = getEEG(P, V, Info, Freqs)
% Gives out Power and frequencies for all Participants

Sizes = [];
Power = struct();
Freq = struct();
fs = 250;
VOld = V;
sizeBMSSL = 0;
ErhalteneChannels = load("ErhalteneChannels.mat");
ErhalteneChannels = ErhalteneChannels.ErhalteneChannels;

m = 0;

if isfield(P.Paths, 'BMSSL')
    m = 0;
    PathEEG = P.Paths.BMSSL.EEG;
    BMSSLParticipants = Info(ismember(Info.Dataset, 'BMS_SL'), :);
    sizeBMSSL = size(PathEEG, 2);
    for n = 1:size(BMSSLParticipants, 1)
        try
                % Session 1
                m = m + 1;
                Name = {"BMS_SL" + num2str(BMSSLParticipants.OldName(n))};
                disp(PathEEG{m});
                EEG =  load(PathEEG{m}, 'data_reref');
                disp('loaded');
                VNew.(Name{1}).Session1 = EEG.data_reref.stage_good_win_on;
                artndxn = ones(108, size(VNew.(Name{1}).Session1, 2));

                % get the whole data into one matrix
                for i = 1:size(EEG.data_reref.trial, 2)
                    EEG1(:, :, i) = EEG.data_reref.trial{i};
                end

                % get logicals for first and last 1/6 of night
                [Evening, Morning] = getPartBMSSL(VNew.(Name{1}).Session1, Name, [2, 3]);
                [~, N2Ends, N3Ends] = getPartsStagesBMSSL(VNew.(Name{1}).Session1, Name, [1, 2, 3]);
                
                % logicals for whole deepsleep
                deepsleep = ismember(VNew.(Name{1}).Session1, [2, 3]);
                
                % get Power and Frequencies
                [PowerMatrix, Freqs] = sleep_power_Sophia(EEG1(:,:), artndxn, fs, 108, Freqs);
                A = mean(PowerMatrix, 2);
                A = mean(A, 1);
                plot(Freqs, log(squeeze(A)), 'color', 'red')
                title('Data loaded');

                hold on;

                % get all N2 and all N3 of the Night
                N2 = PowerMatrix(:, ismember(VNew.(Name{1}).Session1, 2), :);
                N3 = PowerMatrix(:, ismember(VNew.(Name{1}).Session1, 3), :);
                N2M = N2Ends.Morning;
                N2E = N2Ends.Evening;
                N3E = N3Ends.Evening;
                N3M = N3Ends.Morning;

                % mean the data by epochs and save them into matrixes
                Power.Whole(n, 1, :, :)= squeeze(mean(PowerMatrix(:, deepsleep, :), 2));
                Power.Evening(n, 1, :, :) = squeeze(mean(PowerMatrix(:, Evening, :), 2));
                Power.Morning(n, 1, :, :) = squeeze(mean(PowerMatrix(:, Morning, :), 2));
                PowerStages.N2.Whole(n, 1, :, :) = squeeze(mean(N2, 2));
                PowerStages.N3.Whole(n, 1, :, :) = squeeze(mean(N3, 2));
                PowerStages.N2.Ends.Evening(n, 1, :, :) = squeeze(mean(PowerMatrix(:, N2E, :), 2));
                PowerStages.N2.Ends.Morning(n, 1, :, :) = squeeze(mean(PowerMatrix(:, N2M, :), 2));
                PowerStages.N3.Ends.Evening(n, 1, :, :) = squeeze(mean(PowerMatrix(:, N3E, :), 2));
                PowerStages.N3.Ends.Morning(n, 1, :, :) = squeeze(mean(PowerMatrix(:, N3M, :), 2));

                % list with all deepsleep sizes
                Sizes(m) = size(PowerMatrix(:, deepsleep, :), 2);


                %%%%%%%%%%%%
                % Same for Session 2
                m = m + 1;
                EEG = load(PathEEG{m}, 'data_reref');
                disp('loaded');
                artndxn = ones(108, size(EEG.data_reref.stage_good_win_on, 2));
                VNew.(Name{1}).Session2 = EEG.data_reref.stage_good_win_on;
                for p = 1:size(EEG.data_reref.trial, 2)
                    EEG1(:, :, p) = EEG.data_reref.trial{p};
                end

                % get logicals for first and last 1/6 of night
                [Evening, Morning] = getPartBMSSL(VNew.(Name{1}).Session2, Name, [2, 3]);
                [~, N2Ends, N3Ends] = getPartsStagesBMSSL(VNew.(Name{1}).Session2, Name, [1, 2, 3]);
                
                % logicals for whole deepsleep
                deepsleep = ismember(VNew.(Name{1}).Session1, [2, 3]);

                % get Power and Frequencies
                [PowerMatrix, Freqs] = sleep_power_Sophia(EEG1(:,:), artndxn, fs, 108, Freqs);
                A = mean(PowerMatrix, 2);
                A = mean(A, 1);
                plot(Freqs, log(squeeze(A)), 'color', 'red')

                % get all N2 and all N3 of the Night
                N2 = PowerMatrix(:, ismember(VNew.(Name{1}).Session1, 2), :);
                N3 = PowerMatrix(:, ismember(VNew.(Name{1}).Session1, 3), :);
                N2M = N2Ends.Morning;
                N2E = N2Ends.Evening;
                N3E = N3Ends.Evening;
                N3M = N3Ends.Morning;

                % mean the data by epochs and save them into matrixes
                Power.Whole(n, 2, :, :)= squeeze(mean(PowerMatrix(:, deepsleep, :), 2));
                Power.Evening(n, 2, :, :) = squeeze(mean(PowerMatrix(:, Evening, :), 2));
                Power.Morning(n, 2, :, :) = squeeze(mean(PowerMatrix(:, Morning, :), 2));
                PowerStages.N2.Whole(n, 2, :, :) = squeeze(mean(N2, 2));
                PowerStages.N3.Whole(n, 2, :, :) = squeeze(mean(N3, 2));
                PowerStages.N2.Ends.Evening(n, 2, :, :) = squeeze(mean(PowerMatrix(:, N2E, :), 2));
                PowerStages.N2.Ends.Morning(n, 2, :, :) = squeeze(mean(PowerMatrix(:, N2M, :), 2));
                PowerStages.N3.Ends.Evening(n, 2, :, :) = squeeze(mean(PowerMatrix(:, N3E, :), 2));
                PowerStages.N3.Ends.Morning(n, 2, :, :) = squeeze(mean(PowerMatrix(:, N3M, :), 2));

                % List with lenght of all 
                Sizes(m) = size(PowerMatrix(:, deepsleep, :), 2);
                

        catch
            a =1;
        end
    
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isfield(P.Paths, 'BMSSLMemo')
    try
    l = 0;
    PathEEG = P.Paths.BMSSLMemo.EEG;
    BMSSLMemoParticipants = Info(ismember(Info.Dataset, 'BMSSL memo'), :);
    for n = 1:height(BMSSLMemoParticipants.NewName)
        k = (sizeBMSSL/2) + n;
        % Session 1
        l = l + 1;
        Name = {"BMSSL" + num2str(BMSSLMemoParticipants.OldName(n))};
        disp(PathEEG{l});
        EEG =  load(PathEEG{l}, 'data_filt');
        EEG = EEG.data_filt.trial{1};
        artndxn = ones(110, size(VOld.(Name{1}).Session1, 2));

        if any(EEG == 0)
            disp("There are some zeros in 1)")
        end
        % get logicals for first and last 1/6 of night
        [Evening, Morning] = getPartBMSSL(VOld.(Name{1}).Session1, Name, [-2, -3]);
        [~, N2Ends, N3Ends] = getPartsStagesBMSSL(VOld.(Name{1}).Session1, Name, [-1, -2, -3]);
        
        % logicals for whole deepsleep
        deepsleep = ismember(VOld.(Name{1}).Session1, [-2, -3]);

        % load Power for Epochs
        [PowerMatrix, ~] = sleep_power_Sophia(EEG, artndxn, fs, 110, Freqs);
        A = mean(PowerMatrix, 2);
        A = mean(A, 1);
        plot(Freqs, log(squeeze(A)), 'color', 'blue')

        % get all N2 and all N3 of the Night
        N2 = PowerMatrix(ErhalteneChannels, ismember(VOld.(Name{1}).Session1, -2), :);
        N3 = PowerMatrix(ErhalteneChannels, ismember(VOld.(Name{1}).Session1, -3), :);
        N2M = N2Ends.Morning;
        N2E = N2Ends.Evening;
        N3E = N3Ends.Evening;
        N3M = N3Ends.Morning;

        % mean the data by epochs and save them into matrixes
        Power.Whole(k, 1, :, :)= squeeze(mean(PowerMatrix(ErhalteneChannels, deepsleep, :), 2));
        Power.Evening(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, Evening, :), 2));
        Power.Morning(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, Morning, :), 2));
        PowerStages.N2.Whole(k, 1, :, :) = squeeze(mean(N2, 2));
        PowerStages.N3.Whole(k, 1, :, :) = squeeze(mean(N3, 2));
        PowerStages.N2.Ends.Evening(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N2E, :), 2));
        PowerStages.N2.Ends.Morning(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N2M, :), 2));
        PowerStages.N3.Ends.Evening(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N3E, :), 2));
        PowerStages.N3.Ends.Morning(k, 1, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N3M, :), 2));

        % list with all deepsleep sizes
        Sizes(m + l) = size(PowerMatrix(:, deepsleep, :), 2);

        %%%%%%%%%%%%
        % Session 2
        l = l + 1;
        disp(PathEEG{l});
        EEG = load(PathEEG{l});
        EEG = EEG.data_filt.trial{1};
        artndxn = ones(110, size(VOld.(Name{1}).Session2, 2));
        
        if any(EEG == 0)
            disp("There are some zeros in 1)")
        end
        % get logicals for first and last 1/6 of night
        [Evening, Morning] = getPartBMSSL(VOld.(Name{1}).Session1, Name, [-2, -3]);
        [~, N2Ends, N3Ends] = getPartsStagesBMSSL(VOld.(Name{1}).Session2, Name, [-1, -2, -3]);
        
        % logicals for whole deepsleep
        deepsleep = ismember(VOld.(Name{1}).Session2, [-2, -3]);

        % load Power for Epochs
        [PowerMatrix, ~] = sleep_power_Sophia(EEG, artndxn, fs, 110, Freqs);
        A = mean(PowerMatrix, 2);
        A = mean(A, 1);
        plot(Freqs, log(squeeze(A)), 'color', 'blue')

        % get all N2 and all N3 of the Night
        N2 = PowerMatrix(ErhalteneChannels, ismember(VOld.(Name{1}).Session2, -2), :);
        N3 = PowerMatrix(ErhalteneChannels, ismember(VOld.(Name{1}).Session2, -3), :);
        N2M = N2Ends.Morning;
        N2E = N2Ends.Evening;
        N3E = N3Ends.Evening;
        N3M = N3Ends.Morning;

        % mean the data by epochs and save them into matrixes
        Power.Whole(k, 2, :, :)= squeeze(mean(PowerMatrix(ErhalteneChannels, deepsleep, :), 2));
        Power.Evening(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, Evening, :), 2));
        Power.Morning(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, Morning, :), 2));
        PowerStages.N2.Whole(k, 2, :, :) = squeeze(mean(N2, 2));
        PowerStages.N3.Whole(k, 2, :, :) = squeeze(mean(N3, 2));
        PowerStages.N2.Ends.Evening(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N2E, :), 2));
        PowerStages.N2.Ends.Morning(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N2M, :), 2));
        PowerStages.N3.Ends.Evening(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N3E, :), 2));
        PowerStages.N3.Ends.Morning(k, 2, :, :) = squeeze(mean(PowerMatrix(ErhalteneChannels, N3M, :), 2));

        % list with all deepsleep sizes
        Sizes(m + l) = size(PowerMatrix(:, deepsleep, :), 2);

    end
    Freq = Freqs;
    catch
         b = 1;
    end
end
legend('BMSSL', 'BMSSL Memo');
hold off;
try
    VOutput = struct();

    fields1 = fieldnames(VNew);
    for i = 1:numel(fields1)
        VOutput.(fields1{i}) = VNew.(fields1{i});
    end

    fields2 = fieldnames(VOld);
    for i = 1:numel(fields2)
        VOutput.(fields2{i}) = VOld.(fields2{i});
    end

catch
    u = 1;
end


