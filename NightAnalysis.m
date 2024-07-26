%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Code for my masters thesis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add all the Paths to Matlab
addpath H:\Script\eeglab2023.0\eeglab.m
run H:\Script\eeglab2023.0\eeglab.m
addpath H:\Script\chART
addpath H:\Script\Fooofy\fooof_mat\fooof.m
addpath H:\Script\AllWake\functions\eeg\quickPower.m
addpath H:\Script\AllWake\MyCoding\sleep_power_Sophia.m
addpath H:\Script\AllWake\functions\eeg\fooofFit.m
addpath H:\Script\AllWake\functions\eeg\quickPower.m
addpath H:\Script\chART\getProperties.m
run H:\Script\AllWake\functions\eeg\quickPower.m
run H:\Script\Fooofy\fooof_mat\fooof.m
%%
clear
clc
close all

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the data

% datasets included
Datasets = ["BMSSL memo", "BMS_SL"]; %"BMSSL memo", 


% getInfo and list with AllParticipants
ParticipantInfo = load('ParticipantInfo.mat');
ParticipantInfo = ParticipantInfo.ParticipantInfo;
ParticipantInfo = ParticipantInfo(ismember(ParticipantInfo.Dataset, string(Datasets{1})) | ismember(ParticipantInfo.Dataset, string(Datasets{2})), :);

%get a table with all Information about the Participants
[ParticipantStats] = ParticipantStats(ParticipantInfo);


%get all paths for the data
P = getpaths(Datasets, ParticipantInfo);
% aktuell einzige richtige: P.Paths.BMSSL.Memo.EEG alle richtigen Paths


%get the epochLabels
[V] = getLabels(P, ParticipantInfo);

Freqs = load("Freqs.mat");
Freqs = Freqs.Freqs;

%%
%get the Power

[PowerMatrix, PowerMatrixStages, Freqs, V, StatsSizes] = getEEG(P, V, ParticipantInfo, Freqs);


%[PowerMatrix, PowerMatrixStages, Freqs, V, StatsSizes] = getEEG2(P, V, ParticipantInfo);
%

[Slopes, Intercepts] = getslopes(PowerMatrix, PowerMatrixStages, Freqs, ParticipantInfo);


Fieldnames = fieldnames(V);
SizesAll = [];
for i = 1:size(Fieldnames, 1)
    SizesAll = [SizesAll, V.(string(Fieldnames(i))).Session1];
    SizesAll = [SizesAll, V.(string(Fieldnames(i))).Session2];
end

[egstats, eegstd] = EEGStats (SizesAll, ParticipantInfo);

save('PowerMatrix.mat', 'PowerMatrix')

save('Slopes.mat', 'Slopes')
save('Intercepts.mat', 'Intercepts')
save('PowerMatrixStages.mat', 'PowerMatrixStages')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Option to just load the data if already loaded once

Slopes = load('Slopes.mat');
Slopes = Slopes.Slopes;
Intercepts = load('Intercepts.mat');
Intercepts = Intercepts.Intercepts;
PowerMatrix = load('PowerMatrix');
PowerMatrix = PowerMatrix.PowerMatrix;
PowerMatrixStages = load("PowerMatrixStages.mat");
PowerMatrixStages = PowerMatrixStages.PowerMatrixStages;



%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Daten aufbereiten

% wichtige Variabeln definieren
[StatsP, ~, ~, PlotProps, Labels]  = analysisParametersNew();
Chanlocs = load('Chanlocs108.mat');
Chanlocs = Chanlocs.Chanlocs108;
Groupnames.Intervention = ["Slopes", "Intercepts", "Sham", "Intervention"];
Groupnames.ADHD = ["Slopes", "Intercepts", "ADHD", "HC", "Power", "Freq"];
[DataToPlot, logicalsPlot] = MakeReady(Slopes,Intercepts, ParticipantInfo);


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting

%% Spectrum (Ev. muss Power als Input)

PlotAperiodicParameters(PowerMatrix, PowerMatrixStages, ParticipantInfo, Freqs(1:42), Labels, PlotProps, V, StatsP);



%% Slopes & Intercepts Changes Evening to Night plotten
clc
% ADHD vs. HC Whole
XAchse = {'First 1/6', 'Last 1/6'};
disp("ADHD vs HC")
[~, Pwert(1,1:2)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsWhole, 1)), squeeze(mean(DataToPlot.Intercepts.EndsWhole, 1)), vertcat(logicalsPlot.ADHD, logicalsPlot.ADHD), [], Groupnames.ADHD, PlotProps, [], XAchse, "All stages", ParticipantInfo);
disp("N2")
[~, Pwert(2,1:2)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsN2, 1)), squeeze(mean(DataToPlot.Intercepts.EndsN2, 1)), vertcat(logicalsPlot.ADHD, logicalsPlot.ADHD), [], Groupnames.ADHD, PlotProps, [], XAchse, "N2", ParticipantInfo);
% ADHD vs. HC Whole
disp("N3")
[~, Pwert(3,1:2)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsN3, 1)), squeeze(mean(DataToPlot.Intercepts.EndsN3, 1)), vertcat(logicalsPlot.ADHD, logicalsPlot.ADHD), [], Groupnames.ADHD, PlotProps, [], XAchse, "N3",ParticipantInfo);

disp("SHam vs Intervention")
% ADHD Sham vs. Intercepts plotten
[~, Pwert(1,3:4)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsWhole, 1)), squeeze(mean(DataToPlot.Intercepts.EndsWhole, 1)), vertcat(logicalsPlot.ShamADHD, logicalsPlot.ShamADHD), vertcat(logicalsPlot.InterventionADHD, logicalsPlot.InterventionADHD), Groupnames.Intervention, PlotProps, [], XAchse, "All stages",ParticipantInfo);
% ADHD Sham vs. Intercepts plotten
disp("N2")
[~, Pwert(2,3:4)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsN2, 1)), squeeze(mean(DataToPlot.Intercepts.EndsN2, 1)), vertcat(logicalsPlot.ShamADHD, logicalsPlot.ShamADHD), vertcat(logicalsPlot.InterventionADHD, logicalsPlot.InterventionADHD), Groupnames.Intervention, PlotProps, [], XAchse, "N2",ParticipantInfo);
% ADHD Sham vs. Intercepts plotten
disp("N3")
[~, Pwert(3,3:4)] = plotSlopesIntercepts (squeeze(mean(DataToPlot.Slopes.EndsN3, 1)), squeeze(mean(DataToPlot.Intercepts.EndsN3, 1)), vertcat(logicalsPlot.ShamADHD, logicalsPlot.ShamADHD), vertcat(logicalsPlot.InterventionADHD, logicalsPlot.InterventionADHD), Groupnames.Intervention, PlotProps, [], XAchse, "N3",ParticipantInfo);

[rejected, p_corrected] = fdr_bh(Pwert(:), 0.05, 'pdep', 'yes');


%% Check Significance of Slope and Intercepts difference in age groups

[AgeInfo, PValues] = CheckAges(ParticipantInfo, DataToPlot.Slopes, DataToPlot.Intercepts);


%% Plot Slopes AllNight, N2 and N3

% check all Groups ADHD vs HC for significance and plot if h=1
[~, pwert(1,1)] = PlotBox(squeeze(mean(DataToPlot.Slopes.Whole(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Slopes.Whole(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Slopes ADHD/HC All Stages", "Slopes");
[~, pwert(2,1)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N2(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Slopes.N2(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Slopes ADHD/HC N2", "Slopes");
[~, pwert(3,1)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N3(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Slopes.N3(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Slopes ADHD/HC N3", "Slopes");
[~, pwert(4,1)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.Whole(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Intercepts.Whole(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Intercepts ADHD/HC All Stages", "Intercepts");
[~, pwert(5,1)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N2(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Intercepts.N2(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Intercepts ADHD/HC N2", "Intercepts");
[~, pwert(6,1)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N3(:,logicalsPlot.ADHD), 1)), squeeze(mean(DataToPlot.Intercepts.N3(:,~logicalsPlot.ADHD), 1)), ["ADHD", "HC"], "Intercepts ADHD/HC N3", "Intercepts");

% check all Groups Sham vs. Intervention ADHD for significance (plot if h=1)
[~, pwert(1,2)] = PlotBox(squeeze(mean(DataToPlot.Slopes.Whole(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Slopes.Whole(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Slopes Intervention ADHD All Stages", "Slopes");
[~, pwert(2,2)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N2(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Slopes.N2(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Slopes Intervention ADHD N2", "Slopes");
[~, pwert(3,2)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N3(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Slopes.N3(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Slopes Intervention ADHDC N3", "Slopes");
[~, pwert(4,2)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.Whole(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Intercepts.Whole(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Intercepts Intervention ADHD All Stages", "Intercepts");
[~, pwert(5,2)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N2(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Intercepts.N2(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Intercepts Intervention ADHD N2", "Intercepts");
[~, pwert(6,2)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N3(:,logicalsPlot.ShamADHD), 1)), squeeze(mean(DataToPlot.Intercepts.N3(:,~logicalsPlot.ShamADHD), 1)), ["Sham" "Intervention"], "Intercepts Intervention ADHD N3", "Intercepts");

% check all Groups Sham vs. Intervention ADHD&HC for significance
[~, pwert(1,3)] = PlotBox(squeeze(mean(DataToPlot.Slopes.Whole(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Slopes.Whole(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Slopes Intervention All Stages", "Slopes");
[~, pwert(2,3)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N2(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Slopes.N2(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Slopes Intervention N2", "Slopes");
[~, pwert(3,3)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N3(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Slopes.N3(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Slopes Intervention N3", "Slopes");
[~, pwert(4,3)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.Whole(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Intercepts.Whole(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Intercepts Intervention All Stages", "Intercepts");
[~, pwert(5,3)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N2(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Intercepts.N2(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Intercepts Intervention N2", "Intercepts");
[~, pwert(6,3)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N3(:,logicalsPlot.Sham), 1)), squeeze(mean(DataToPlot.Intercepts.N3(:,~logicalsPlot.Sham), 1)), ["Sham" "Intervention"], "Intercepts Intervention N3", "Intercepts");

% check all Groups Sham vs. Intervention HC for significance
[~, pwert(1,4)] = PlotBox(squeeze(mean(DataToPlot.Slopes.Whole(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Slopes.Whole(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Slopes Intervention All Stages", "Slopes");
[~, pwert(2,4)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N2(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Slopes.N2(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Slopes Intervention N2", "Slopes");
[~, pwert(3,4)] = PlotBox(squeeze(mean(DataToPlot.Slopes.N3(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Slopes.N3(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Slopes Intervention N3", "Slopes");
[~, pwert(4,4)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.Whole(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Intercepts.Whole(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Intercepts Intervention All Stages", "Intercepts");
[~, pwert(5,4)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N2(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Intercepts.N2(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Intercepts Intervention N2", "Intercepts");
[~, pwert(6,4)] = PlotBox(squeeze(mean(DataToPlot.Intercepts.N3(:,logicalsPlot.ShamHC), 1)), squeeze(mean(DataToPlot.Intercepts.N3(:,~logicalsPlot.ShamHC), 1)), ["Sham" "Intervention"], "Intercepts Intervention N3", "Intercepts");

[rejected, p_corrected] = fdr_bh(pwert(:), 0.05, 'pdep', 'yes');



%% Anova

% Slopes: Morning vs. Evening, Sham vs. Intervention
Anova1 = horzcat(SlopesEnds, Info.Time, Info.Int);
Anova1((Anova1(:, 2) == 0), 2) = 2;
Anova1((Anova1(:, 3) == 0), 3) = 2;
Anova1 = sortrows(Anova1, 2);
Anova1 = sortrows(Anova1, 3);
Stats=mes2way(Anova1(:,1),[Anova1(:,2), Anova1(:,3)],'eta2','fName',{'Eve/Mo','Sham /Int'},'isDep',[0 1]);


% Slopes: ADHD vs HC, Sham vs. Intervention
Anova2 = horzcat(SlopesEnds, Info.ADHD, Info.Int);
Anova2((Anova1(:, 2) == 0), 2) = 2;
Anova2((Anova1(:, 3) == 0), 3) = 2;
Anova2 = sortrows(Anova1, 2);
Anova2 = sortrows(Anova1, 3);
Stats=mes2way(Anova2(:,1),[Anova2(:,2), Anova2(:,3)],'eta2','fName',{'ADHD / HC','Sham /Int'},'isDep',[0 0]);


% Intercepts: Morning vs. Evening, Sham vs. Intervention
Anova3 = horzcat(InterceptsEnds, Info.Time, Info.Int);
Anova3((Anova1(:, 2) == 0), 2) = 2;
Anova3((Anova1(:, 3) == 0), 3) = 2;
Anova3 = sortrows(Anova1, 2);
Anova3 = sortrows(Anova1, 3);
Stats=mes2way(Anova3(:,1),[Anova3(:,2), Anova3(:,3)],'eta2','fName',{'Eve/Mo','Sham /Int'},'isDep',[0 1]);


% Intercepts: ADHD vs HC, Sham vs. Intervention
Anova4 = horzcat(InterceptsEnds, Info.ADHD, Info.Int);
Anova4((Anova1(:, 2) == 0), 2) = 2;
Anova4((Anova1(:, 3) == 0), 3) = 2;
Anova4 = sortrows(Anova1, 2);
Anova4 = sortrows(Anova1, 3);
Stats=mes2way(Anova4(:,1),[Anova4(:,2), Anova4(:,3)],'eta2','fName',{'ADHD / HC','Sham /Int'},'isDep',[0 0]);


%% Topoplott

GroupsTopoplot = ["Sham", "Intervention", "first 1/6", "last 1/6"];
PlotTheTopo1(DataToPlot.Slopes.EndsWhole, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ShamADHD, logicalsPlot.InterventionADHD)
PlotTheTopo1(DataToPlot.Slopes.EndsN2, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ShamADHD, logicalsPlot.InterventionADHD)
PlotTheTopo1(DataToPlot.Slopes.EndsN3, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ShamADHD, logicalsPlot.InterventionADHD)


GroupsTopoplot = ["ADHD", "HC", "first 1/6", "last 1/6"];
PlotTheTopo1(DataToPlot.Slopes.EndsWhole, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD)
PlotTheTopo1(DataToPlot.Slopes.EndsN2, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD)
PlotTheTopo1(DataToPlot.Slopes.EndsN3, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD)


GroupsTopoplot = ["ADHD", "HC", "Sham", "Intervention"];
PlotTheTopo2(DataToPlot.Slopes.Whole, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD, logicalsPlot.Sham, logicalsPlot.Intervention, [])
PlotTheTopo2(DataToPlot.Slopes.Whole, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD, logicalsPlot.ages.zehn', logicalsPlot.ages.zwoelf', "nein")
PlotTheTopo2(DataToPlot.Slopes.Whole, [],GroupsTopoplot, Chanlocs, PlotProps, logicalsPlot.ADHD, logicalsPlot.NoADHD, logicalsPlot.ages.zehn', logicalsPlot.ages.vierzehn', "nein")



%% Zusammenhang mit Memory-Test

[All, OnlyADHD] = Memory(DataToPlot.Slopes, DataToPlot.Intercepts, ParticipantInfo);

%% Tap 

%BMSSL: L:\Somnus-Data\Data01\BMS_SL\data\Behav_Data\TAP_alertness
%L:\Somnus-Data\Data01\BMSSL_memo\data\Behavioural_data\TAP_Alertness

Colours = vertcat([216, 0, 39]/255, [161, 1, 141] / 255, [99, 0, 158] / 255, [42, 0, 213]/255, [3, 2, 252] / 255);


%% GoNoGo

%L:\Somnus-Data\Data01\BMS_SL\data\Behav_Data\Pres_gonogo

