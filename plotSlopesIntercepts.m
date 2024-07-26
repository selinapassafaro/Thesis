function [h,psig] = plotSlopesIntercepts (Group1, Group2, Size, Size2, Groupnames, PlotProps, StatsP, XAchse, Titel, Info)
addpath H:\Script\AllWake\functions\general
addpath H:\Script\AllWake\functions\plots
addpath H:\Script\AllWake\functions\stats
addpath H:\Script\AllWake\functions\hhentschke-measures-of-effect-size-toolbox-3d90ae5
addpath H:\Script\AllWake\functions\Mass_univariate_erp_toolbox


% Gruppen von einer Liste in eine Tabelle mit zwei Kolumnen
%Group1 = horzcat(Group1(1:(ceil(length(Group1)/2))), Group1((length(Group1)/2+1):end));
%Group2 = horzcat(Group2(1:(ceil(length(Group2)/2))), Group2((length(Group2)/2+1):end));
% Size halbieren
Size = logical(Size(1:(ceil(length(Size) / 2))));
Size2 = logical(Size2(1:(ceil(length(Size2) / 2))));

if isempty(Size2)
    Colors = repmat(getColors(1, '', 'blue'), (size(Size, 1)), 1);
    Colors(Size, :) = repmat(getColors(1, '', 'red'), nnz(Size), 1);
    group1 = Group1;
    group2 = Group2;
else
    isADHD = ismember(Info.Group, "ADHD");
    isADHD = vertcat(isADHD, isADHD);
    trueSize = Size;
    trueSize(~isADHD) = [];
    Colors = repmat(getColors(1, '', 'blue'), (size(trueSize, 1)), 1);
    Colors(trueSize, :) = repmat(getColors(1, '', 'red'), nnz(trueSize), 1);
    group1 = Group1(isADHD, :);
    group2 = Group2(isADHD, :);
end


figure
subplot(1, 2, 1)
Stats = overnightChange(group1, Colors, StatsP, PlotProps, XAchse);
title(Groupnames(1), Titel)
axis on
legend off

subplot(1, 2, 2)
Stats = overnightChange(group2, Colors, StatsP, PlotProps, XAchse);
title(Groupnames(2), Titel)
legend(Groupnames(3), Groupnames(4))
axis on



if isempty(Size2)
    A = Group1(Size, 1)-Group1(Size, 2);
    B = Group1(~Size, 1)-Group1(~Size, 1);
    if size(A) == size(B)
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Slopes(Evening+Morning) Not Significant");
            psig(1) = p;
        else
            disp("Slopes(Evening+Morning) Significant, with p=" + p);
            psig(1) = p;
        end
        
        A = Group2(Size, 1)-Group2(Size, 2);
        B = Group2(~Size, 1)-Group2(~Size, 2);
        [h, p, ~, ~] = ttest(A, B);
        if h==0
            disp("Intercepts(Evening+Morning) Not Significant");
            psig(2) = p;
        else
            disp("Intercepts(Evening+Morning) Significant, with p=" + p);
            psig(2) = p;
        end
    else
        %disp("Gruppen haben nicht dieselbe Grösse")
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Slopes(Evening+Morning) Not Significant");
            psig(1) = p;
        else
            disp("Slopes(Evening+Morning) Significant, with p=" + p);
            psig(1) = p;
        end
        A = Group2(Size, 1)-Group2(Size, 2);
        B = Group2(~Size, 1)-Group2(~Size, 2);
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Intercepts(Evening+Morning) Not Significant");
            psig(2) = p;
        else
            disp("Intercepts(Evening+Morning) Significant, with p=" + p);
            psig(2) = p;
        end
    end
else
    A = Group1(Size, 1)-Group1(Size, 2);
    B = Group1(Size2, 1)-Group1(Size2, 1);
    if size(A) == size(B)
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Slopes(Evening+Morning) Not Significant");
            psig(1) = p;
        else
            disp("Slopes(Evening+Morning) Significant, with p=" + p);
            psig(1) = p;
        end
        
        A = Group2(Size, 1)-Group2(Size, 2);
        B = Group2(Size2, 2)-Group2(Size2, 2);
        [h, p, ~, ~] = ttest(A, B);
        if h==0
            disp("Intercepts(Evening+Morning) Not Significant");
            psig(2) = p;
        else
            disp("Intercepts(Evening+Morning) Significant, with p=" + p);
            psig(2) = p;
        end
    else
        %disp("Gruppen haben nicht dieselbe Grösse")
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Slopes(Evening+Morning) Not Significant");
            psig(1) = p;
        else
            disp("Slopes(Evening+Morning) Significant, with p=" + p);
            psig(1) = p;
        end
        A = Group2(Size, 1)-Group2(Size, 2);
        B = Group2(Size2, 1)-Group2(Size2, 2);
        [h, p, ~, ~] = ttest2(A, B);
        if h==0
            disp("Intercepts(Evening+Morning) Not Significant");
            psig(2) = p;
        else
            disp("Intercepts(Evening+Morning) Significant, with p=" + p);
            psig(2) = p;
        end
    end
end