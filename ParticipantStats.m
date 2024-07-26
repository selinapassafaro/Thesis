function [T, t] = ParticipantStats(Info)

data = NaN(3, 4);
columnNames = {'Titel', 'Number', 'AgeMean', 'AgeStd'};
T = array2table(data, 'VariableNames', columnNames);

T.Titel = ["General", "HC", "ADHD"]';
IsADHD = ismember(Info.Group, "ADHD");
IsHC = ismember(Info.Group, "HC");


%Kolumne mit Anzahl Teilnehmer 
T.Number(1) = height(Info.Group);
T.Number(2) = sum(IsHC);
T.Number(3) = sum(IsADHD);


%Kolumne mit Durchschnittlichem Alter
T.AgeMean(1) = mean(table2array(Info(:,15)));
T.AgeMean(2) = mean(table2array(Info(IsHC,15)));
T.AgeMean(3) = mean(table2array(Info(IsADHD,15)));


[h, p, ~, ~] = ttest2(table2array(Info(IsHC, 15)), table2array(Info(IsADHD, 15)));
disp("Is there a sgnificant difference in ages between the subroups ADHD and HC?");
if h == 0
    disp(["No, with p-value = ", p]);
else
    disp(["Yes, with p-value = ", p]);
end

%Kolumne mit Durchschnittlicher Standardabweichung des Alters
T.AgeStd(1) = std(table2array(Info(:,15)));
T.AgeStd(2) = std(table2array(Info(IsHC,15)));
T.AgeStd(3) = std(table2array(Info(IsADHD,15)));

%Kolumne mit Anzahl Männliche Teilnehmer vs. Weibliche
Sex = Info.Sex;
T.MvsF(1) = (sum(ismember(Sex, 'm')) + "/" + sum(ismember(Sex, 'f')));
T.MvsF(2) = string(sum(ismember(Sex(IsHC, :), 'm')) + "/" + sum(ismember(Info.Sex(IsHC, :), 'f')));
T.MvsF(3) = string(sum(ismember(Sex(IsADHD, :), 'm')) + "/" + sum(ismember(Info.Sex(IsADHD, :), 'f')));
