function [AgeInfo, PValues] = CheckAges(Info, Slopes, Intercepts)

[Group1, Group2, Group3, Group4, Group5] = getagegroups(Info);

H = height(Info);
Group1 = logical(Group1(:,1:H));
Group2 = logical(Group2(:, 1:H));
Group3 = logical(Group3(:, 1:H));
Group4 = logical(Group4(:, 1:H));
Group5 = logical(Group5(:, 1:H));
Groups = vertcat(Group1, Group2, Group3, Group4, Group5);

isADHD = (ismember(Info.Group, "ADHD"))';
Group1ADHD = (Group1 & isADHD);
Group2ADHD = (Group2 & isADHD);
Group3ADHD = (Group3 & isADHD);
Group4ADHD = (Group4 & isADHD);
Group5ADHD = (Group5 & isADHD);
Group1HC = (Group1 & ~isADHD);
Group2HC = (Group2 & ~isADHD);
Group3HC = (Group3 & ~isADHD);
Group4HC = (Group4 & ~isADHD);
Group5HC = (Group5 & ~isADHD);


variableNames = {'8/9', '10/11', '12/13', '14/15', '16/17'};
rowNames = {'Number', 'Female', 'Male', 'ADHD'};
AgeInfo =  array2table(cell(4, 5), 'VariableNames', variableNames, 'RowNames', rowNames);
f1 = sum(ismember(Info.Sex(Group1'), 'f'));
m1 = sum(ismember(Info.Sex(Group1), 'm'));
f2 = sum(ismember(Info.Sex(Group2), 'f'));
m2 = sum(ismember(Info.Sex(Group2), 'm'));
f3 = sum(ismember(Info.Sex(Group3), 'f'));
m3 = sum(ismember(Info.Sex(Group3), 'm'));
f4 = sum(ismember(Info.Sex(Group4), 'f'));
m4 = sum(ismember(Info.Sex(Group4), 'm'));
f5 = sum(ismember(Info.Sex(Group5), 'f'));
m5 = sum(ismember(Info.Sex(Group5), 'm'));

A1 = sum(Group1ADHD);
A2 = sum(Group2ADHD);
A3 = sum(Group3ADHD);
A4 = sum(Group4ADHD);
A5 = sum(Group5ADHD);

AgeInfo(1,:) = array2table(num2cell([sum(Group1), sum(Group2), sum(Group3), sum(Group4), sum(Group5)]));
AgeInfo(2, :) = array2table(num2cell([f1, f2, f3, f4, f5]));
AgeInfo(3, :) = array2table(num2cell([m1, m2, m3, m4, m5]));
AgeInfo(4, :) = array2table(num2cell([A1, A2, A3, A4, A5]));

columnNames = AgeInfo.Properties.VariableNames;
PValuesSlopes = zeros(5, 5);
%PValues.Properties.VariableNames = {'8/9', '10/11', '12/13', '14/15', '16/17'};

disp("Slopes, All Stages")
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Slopes.Whole(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Slopes.Whole(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesSlopes(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Slopes.Whole(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesSlopes(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Slopes.Whole(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesSlopes(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Slopes.Whole(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, ["8/9", "14/15"], "vs 14/15 years", "Slopes");
    PValuesSlopes(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Slopes.Whole(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesSlopes(i,5) = p;
    end
end
PValues.Slopes.Whole = PValuesSlopes;

disp("Intercepts, All Stages")
PValuesIntercepts = zeros(5, 5);
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Intercepts.Whole(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Intercepts.Whole(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesIntercepts(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Intercepts.Whole(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesIntercepts(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Intercepts.Whole(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesIntercepts(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Intercepts.Whole(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "14/15"], "vs 14/15 years", "Slopes");
    PValuesIntercepts(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Intercepts.Whole(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesIntercepts(i,5) = p;
    end
end
PValues.Intercepts.Whole = PValuesIntercepts;

disp("Slopes, N2")
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Slopes.N2(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Slopes.N2(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesSlopesN2(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Slopes.N2(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesSlopesN2(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Slopes.N2(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesSlopesN2(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Slopes.N2(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, ["8/9", "14/15"], "vs 14/15 years", "Slopes");
    PValuesSlopesN2(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Slopes.N2(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesSlopesN2(i,5) = p;
    end
end
PValues.Slopes.N2 = PValuesSlopesN2;

disp("Intercepts, N2")
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Intercepts.N2(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Intercepts.N2(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesInterceptsN2(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Intercepts.N2(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesInterceptsN2(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Intercepts.N2(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesInterceptsN2(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Intercepts.N2(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, ["8/9", "14/15"], "vs 14/15 years", "Slopes");
    PValuesInterceptsN2(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Intercepts.N2(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesInterceptsN2(i,5) = p;
    end
end
PValues.Intercepts.N2 = PValuesInterceptsN2;

disp("Slopes, N3")
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Slopes.N3(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Slopes.N3(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesSlopesN3(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Slopes.N3(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesSlopesN3(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Slopes.N3(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesSlopesN3(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Slopes.N3(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, ["8/9", "14/15"], "vs 14/15 years", "Slopes");
    PValuesSlopesN3(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Slopes.N3(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesSlopesN3(i,5) = p;
    end
end

PValues.Slopes.N3 = PValuesSlopesN3;

disp("Intercepts, N3")
for i = 1:size(AgeInfo,2)
    Data1 = squeeze(mean(Intercepts.N3(:,Groups(i, :))));
    disp(columnNames(i))

    % Vergleich: mit 8/9
    Data2 = squeeze(mean(Intercepts.N3(:,Group1)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 8/9 years", "Slopes");
    PValuesInterceptsN3(i,1) = p;

    % Vergleich: mit 10/11
    Data2 = squeeze(mean(Intercepts.N3(:,Group2)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "10/11"], "vs 10/11 years", "Slopes");
    PValuesInterceptsN3(i,2) = p;

    % Vergleich mit 12/13
    Data2 = squeeze(mean(Intercepts.N3(:,Group3)));
    [~, p] = PlotBox(Data1, Data2, [columnNames(i), "12/13"], "vs 12/13 years", "Slopes");
    PValuesInterceptsN3(i,3) = p;

    % Vergleich mit 14/15
    Data2 = squeeze(mean(Intercepts.N3(:,Group4)));
    [~, p] = PlotBox(Data1, Data2, ["8/9", "14/15"], "vs 14/15 years", "Slopes");
    PValuesInterceptsN3(i,4) = p;
    
    if i == 5
    else
        % Vergleich mit 16/17
        Data2 = squeeze(mean(Intercepts.N3(:,Group5)));
        [~, p] = PlotBox(Data1, Data2, ["8/9", "16/17"], "vs 16/17 years", "Slopes");
        PValuesInterceptsN3(i,5) = p;
    end
end
%disp(InfoAge)
PValues.Intercepts.N3 = PValuesInterceptsN3;


% ADHD vs. HC same age %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, Slopes")
Data1 = squeeze(mean(Slopes.Whole(:,Group1ADHD)));
Data2 = squeeze(mean(Slopes.Whole(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Slopes");
PValuesSlopesAD(1,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Slopes.Whole(:,Group2ADHD)));
Data2 = squeeze(mean(Slopes.Whole(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Slopes");
PValuesSlopesAD(1,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Slopes.Whole(:,Group3ADHD)));
Data2 = squeeze(mean(Slopes.Whole(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Slopes");
PValuesSlopesAD(1,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Slopes.Whole(:,Group4ADHD)));
Data2 = squeeze(mean(Slopes.Whole(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Slopes");
PValuesSlopesAD(1,4) = p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, N2, Slopes")
Data1 = squeeze(mean(Slopes.N2(:,Group1ADHD)));
Data2 = squeeze(mean(Slopes.N2(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Slopes");
PValuesSlopesAD(2,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Slopes.N2(:,Group2ADHD)));
Data2 = squeeze(mean(Slopes.N2(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Slopes");
PValuesSlopesAD(2,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Slopes.N2(:,Group3ADHD)));
Data2 = squeeze(mean(Slopes.N2(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Slopes");
PValuesSlopesAD(2,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Slopes.N2(:,Group4ADHD)));
Data2 = squeeze(mean(Slopes.N2(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Slopes");
PValuesSlopesAD(2,4) = p;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, N2, Slopes")
Data1 = squeeze(mean(Slopes.N3(:,Group1ADHD)));
Data2 = squeeze(mean(Slopes.N3(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Slopes");
PValuesSlopesAD(3,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Slopes.N3(:,Group2ADHD)));
Data2 = squeeze(mean(Slopes.N3(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Slopes");
PValuesSlopesAD(3,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Slopes.N3(:,Group3ADHD)));
Data2 = squeeze(mean(Slopes.N3(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Slopes");
PValuesSlopesAD(3,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Slopes.N3(:,Group4ADHD)));
Data2 = squeeze(mean(Slopes.N3(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Slopes");
PValuesSlopesAD(3,4) = p;

PValues.SameAge.Slopes = PValuesSlopesAD;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, Intercepts")
Data1 = squeeze(mean(Intercepts.Whole(:,Group1ADHD)));
Data2 = squeeze(mean(Intercepts.Whole(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Intercepts");
PValuesSlopesADI(1,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Intercepts.Whole(:,Group2ADHD)));
Data2 = squeeze(mean(Intercepts.Whole(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Intercepts");
PValuesSlopesADI(1,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Intercepts.Whole(:,Group3ADHD)));
Data2 = squeeze(mean(Intercepts.Whole(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Intercepts");
PValuesSlopesADI(1,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Intercepts.Whole(:,Group4ADHD)));
Data2 = squeeze(mean(Intercepts.Whole(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Intercepts");
PValuesSlopesADI(1,4) = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, N2, Intercepts")
Data1 = squeeze(mean(Intercepts.N2(:,Group1ADHD)));
Data2 = squeeze(mean(Intercepts.N2(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Intercepts");
PValuesSlopesADI(2,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Intercepts.N2(:,Group2ADHD)));
Data2 = squeeze(mean(Intercepts.N2(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Intercepts");
PValuesSlopesADI(2,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Intercepts.N2(:,Group3ADHD)));
Data2 = squeeze(mean(Intercepts.N2(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Intercepts");
PValuesSlopesADI(2,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Intercepts.N2(:,Group4ADHD)));
Data2 = squeeze(mean(Intercepts.N2(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Intercepts");
PValuesSlopesADI(2,4) = p;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("ADHD vs HC same age group, N2, Slopes")
Data1 = squeeze(mean(Intercepts.N3(:,Group1ADHD)));
Data2 = squeeze(mean(Intercepts.N3(:,Group1HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "8/9 years", "Intercepts");
PValuesSlopesADI(3,1) = p;

% Vergleich: mit 10/11
Data1 = squeeze(mean(Intercepts.N3(:,Group2ADHD)));
Data2 = squeeze(mean(Intercepts.N3(:,Group2HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "10/11 years", "Intercepts");
PValuesSlopesADI(3,2) = p;

% Vergleich mit 12/13
Data1 = squeeze(mean(Intercepts.N3(:,Group3ADHD)));
Data2 = squeeze(mean(Intercepts.N3(:,Group3HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "12/13 years", "Intercepts");
PValuesSlopesADI(3,3) = p;

% Vergleich mit 14/15
Data1 = squeeze(mean(Intercepts.N3(:,Group4ADHD)));
Data2 = squeeze(mean(Intercepts.N3(:,Group4HC)));
[~, p] = PlotBox(Data1, Data2, ["ADHD", "HC"], "14/15 years", "Intercepts");
PValuesSlopesADI(3,4) = p;

PValues.SameAge.Intercepts = PValuesSlopesADI;
