function [T, S] = EEGStats (Sizes, Info)

data = NaN(3, 5);
columnNames = {'Titel', 'Length_Deepsleep', 'Mean_Diff_Sessions', 'Mean_DS_Sham', 'Mean_DS_Intervention'};
T = array2table(data, 'VariableNames', columnNames);
S = array2table(data, 'VariableNames', columnNames);


% logical isADHD for all Sesssions and all Participants
isADHD = ismember(Info.Group, "ADHD");
IsADHD = [];
IsHC = [];
for i = 1:size(isADHD, 1)
    if isADHD(i) == 0
        IsADHD = [IsADHD, 0, 0];
        IsHC = [IsHC, 0, 0];
    else
        IsADHD = [IsADHD, 1, 1];
        IsHC = [IsHC, 1, 1];
    end
end
IsADHD = logical(IsADHD);
IsHC = logical(IsHC);
% logical with 1 for first and 0 for second session
Sessions = logical(mod(1:size(Sizes, 2), 2));
% logicals for Sham and for Intervention Nights
ShamFirstNight = ismember(Info.ShamSession, 1);
Sham = [];
Int = [];
for i = 1:length(ShamFirstNight)
    if ShamFirstNight(i) == 0
        Sham = [Sham, 0, 1];
        Int = [Int, 1, 0];
    else
        Sham = [Sham, 1, 0];
        Int = [Int, 0, 1];
    end
end

Sham = logical(Sham);
Int = logical(Int);

%%%%%%%%%%%%%%%%%%%%%%
% title
T.Titel = ["General", "HC", "ADHD"]';
S.Titel = ["General", "HC", "ADHD"]';

% durchschnittliche Tiefschlafdauer für jede Gruppe + std
T.Length_Deepsleep(1) = mean(Sizes);
S.Length_Deepsleep(1) = std(Sizes);
T.Length_Deepsleep(2) = mean(Sizes(IsHC));
S.Length_Deepsleep(2) = std(Sizes(IsHC));
T.Length_Deepsleep(3) = mean(Sizes(IsADHD));
S.Length_Deepsleep(3) = std(Sizes(IsADHD));
[h, p, ~, ~] = ttest2(Sizes(IsHC), Sizes(IsADHD));
disp([h, p]);

% mittlerer Unterschied Session1 und Session 2 + std
T.Mean_Diff_Sessions(1) = mean(Sizes(Sessions))-mean(Sizes(~Sessions));
S.Mean_Diff_Sessions(1) = std(Sizes(Sessions))-mean(Sizes(~Sessions));
T.Mean_Diff_Sessions(2) = mean(Sizes(Sessions(IsHC)))-mean(Sizes(~Sessions(IsHC)));
S.Mean_Diff_Sessions(2) = std(Sizes(Sessions(IsHC)))-mean(Sizes(~Sessions(IsHC)));
T.Mean_Diff_Sessions(3) = mean(Sizes(Sessions(IsADHD)))-mean(Sizes(~Sessions(IsADHD)));
S.Mean_Diff_Sessions(3) = std(Sizes(Sessions(IsADHD)))-mean(Sizes(~Sessions(IsADHD)));
[h, p, ~, ~] = ttest2(Sizes(IsHC), Sizes(IsADHD));
disp([h, p]);

% durchschnittliche Tiefschlafdauer für jede Gruppe in Sham Nacht + std
T.Mean_DS_Sham(1) = mean(Sizes(Sham));
S.Mean_DS_Sham(1) = std(Sizes(Sham));
T.Mean_DS_Sham(2) = mean(Sizes(IsHC(Sham)));
S.Mean_DS_Sham(2) = std(Sizes(IsHC(Sham)));
T.Mean_DS_Sham(3) = mean(Sizes(IsADHD(Sham)));
S.Mean_DS_Sham(3) = std(Sizes(IsADHD(Sham)));
[h, p, ~, ~] = ttest2(Sizes(IsHC(Sham)), Sizes(IsADHD(Sham)));
disp([h, p]);

% durchschnittliche Tiefschlafdauer für jede Gruppe in Intervent Nacht 1
% std
T.Mean_DS_Intervention(1) = mean(Sizes(Int));
S.Mean_DS_Intervention(1) = std(Sizes(Int));
T.Mean_DS_Intervention(2) = mean(Sizes(IsHC(Int)));
S.Mean_DS_Intervention(2) = std(Sizes(IsHC(Int)));
T.Mean_DS_Intervention(3) = mean(Sizes(IsADHD(Int)));
S.Mean_DS_Intervention(3) = std(Sizes(IsADHD(Int)));
[h, p, ~, ~] = ttest2(Sizes(IsHC(Int)), Sizes(IsADHD(Int)));
disp([h, p]);