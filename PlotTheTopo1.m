function PlotTheTopo1(Slopes, Slopes2, GroupsTopoplot, Chanlocs, PlotProps, Logical, Logical2)
%CLims and CLabels können noch definiert werden



% Get Significance-Stats
for i = 1:108
        [~, p, ~, ~] = ttest2(squeeze(Slopes(i, Logical, 1)), squeeze(Slopes(i, Logical2, 1)));
        stats1(i) = p;
        [~, p, ~, ~] = ttest2(squeeze(Slopes(i, Logical, 2)), squeeze(Slopes(i, Logical2, 2)));
        stats2(i) = p;
        [~, p, ~, ~] = ttest2(squeeze(Slopes(i, Logical, 1)), squeeze(Slopes(i, Logical, 2)));
        stats3(i) = p;
        [~, p, ~, ~] = ttest2(squeeze(Slopes(i, Logical2, 1)), squeeze(Slopes(i, Logical2, 2)));
        stats4(i) = p;
end

[stats1, ~, ~, ~]=fdr_bh(stats1,0.05,'dep','yes');
[stats2, ~, ~, ~]=fdr_bh(stats2,0.05,'dep','yes');
[stats3, ~, ~, ~]=fdr_bh(stats3,0.05,'dep','yes');
[stats4, ~, ~, ~]=fdr_bh(stats4,0.05,'dep','yes');
%stats1 = first 1/6, Sham vs. Int
%stats2 = last 1/6, Sham vs. Int
%stats3 = Sham, first vs. last 1/6
%stats4 = Int, first vs. last 1/6

% get groups
Group1 = vertcat(mean(Slopes(:, Logical, 1), 2), mean(Slopes(:,Logical,2), 2));
Group2 = vertcat(mean(Slopes(:,Logical2, 1), 2), mean(Slopes(:,Logical2,2), 2));
Group3 = (squeeze(mean(Slopes(:,Logical,1), 2)) - squeeze(mean(Slopes(:,Logical2,1), 2)));
Group4 = (squeeze(mean(Slopes(:,Logical,2), 2)) - squeeze(mean(Slopes(:,Logical2,2), 2)));
Size = vertcat(true(108, 1), false(108, 1));
Size = logical(Size);
MeanGroup1 = (Group1(Size, :) - Group1(~Size, :));
MeanGroup2 = (Group2(Size, :) - Group2(~Size, :));

%Group1 = meanN2
%Group2 = meanN3
%Group3 = meanEv
%Group4 0 meanMo

zerostats = [];
CLims = [];
CLabel = [];




blue_to_white_colormap =  [   
    0.0 0.0 0.4   % Dark Blue
    0.3 0.0 0.5   % Medium Blue (adjust the RGB values as needed)
    0.5 0.0 0.7   % Lilac
    1.0 0.5 0.0   % Orange
    1.0 1.0 0.0 ];  % Yellow

%Topoplot funktion von Sophia
%plotTopoplot(TopoData, Stats, Chanlocs, CLims, CLabel, ColormapName, PlotProps);

figure('Color', 'white', 'Units','normalized', 'Position',[0.25 0.25 .5 .5], 'Resize', 'on')
subplot(3, 3, 1)
plotTopoplot(Group1(Size, :), zerostats, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
title(GroupsTopoplot(1))
axis on
legend off

subplot(3, 3, 2)
plotTopoplot(Group2(Size, :), zerostats, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
title(GroupsTopoplot(2))
axis on

subplot(3, 3, 3)
plotTopoplot(Group3(Size, :), stats1, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
title(GroupsTopoplot(3), GroupsTopoplot(4));
axis on

subplot(3, 3, 4)
plotTopoplot(Group1(~Size, :), zerostats, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
axis on

subplot(3, 3, 5)
plotTopoplot(Group2(~Size, :), zerostats, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
axis on

subplot(3, 3, 6)
plotTopoplot(Group4(:, :), stats2, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
axis on

subplot(3, 3, 7)
plotTopoplot(MeanGroup1(:, :), stats3, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
axis on

subplot(3, 3, 8)
plotTopoplot(MeanGroup2(:, :), stats4, Chanlocs, CLims, CLabel, colormap('jet'), PlotProps);
axis on