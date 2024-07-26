function [All, OnlyADHD] = Memory(Slopes, Intercepts, ParticipantInfo)
addpath H:\Script\AllWake\functions\Mass_univariate_erp_toolbox\fdr_bh.m

% Define all variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
IsADHD = ismember(ParticipantInfo.Group, 'ADHD');
Sham = ismember(ParticipantInfo.ShamSession, 2);
Intervention = [~Sham', Sham'];
isADHD = [IsADHD', IsADHD']';
TAP = [ParticipantInfo.TAP1', ParticipantInfo.TAP2'];
Aufmerksamkeit = [ParticipantInfo.Aufmerksamkeit1', ParticipantInfo.Aufmerksamkeit2']';



% Test for differences in Groups %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h, p, ~, ~] = ttest2(TAP(isADHD), TAP(~isADHD));
if h==0
    disp("No significant difference in TAP test between ADHD and HC");
else
    disp("Difference in TAP test between ADHD and HC significant, with p=" + p);
    figure;
    boxchart([TAP(isADHD)', TAP(~isADHD)']', 'GroupByColor', [ones(size(TAP(isADHD), 1)), zeros(size(TAP(~isADHD), 1))], 'BoxWidth',0.75, 'JitterOutliers','on', 'Notch','off');
    title('TAP');
    ylabel('Difference Evening/Morning');
    legend(['ADHD', 'HC']);
end
[h, p, ~, ~] = ttest2(Aufmerksamkeit(isADHD), Aufmerksamkeit(~isADHD));
if h==0
    disp("No significant difference in Questionnaire test between ADHD and HC");
else
    disp("Difference in Questionnaire test between ADHD and HC significant, with p=" + p);
    figure;
    boxchart([Aufmerksamkeit(isADHD)', Aufmerksamkeit(~isADHD)']', 'GroupByColor', [ones(size(Aufmerksamkeit(isADHD), 1)), zeros(size(Aufmerksamkeit(~isADHD), 1))], 'BoxWidth',0.75, 'JitterOutliers','on', 'Notch','off');
    title('Aufmerksamkeit');
    ylabel('Difference Evening/Morning');
    legend(['ADHD', 'HC']);
end

[h, p, ~, ~] = ttest2(TAP(Intervention), TAP(~Intervention));
if h==0
    disp("No significant difference in TAP test between Intervention and Sham");
else
    disp("Difference in TAP test between Intervention and Sham significant, with p=" + p);
    figure;
    boxchart([TAP(Intervention)', TAP(~Intervention)']', 'GroupByColor', [ones(size(TAP(Intervention), 1)), zeros(size(TAP(~Intervention), 1))], 'BoxWidth',0.75, 'JitterOutliers','on', 'Notch','off');
    title('TAP');
    ylabel('Difference Evening/Morning');
    legend(['Intervention', 'Sham']);
end
[h, p, ~, ~] = ttest2(Aufmerksamkeit(Intervention), Aufmerksamkeit(~Intervention));
if h==0
    disp("No significant difference in Questionnaire test between Intervention and Sham");
else
    disp("Difference in Questionnaire test between Intervention and Sham significant, with p=" + p);
    figure;
    boxchart([Aufmerksamkeit(Intervention)', Aufmerksamkeit(~Intervention)']', 'GroupByColor', [ones(size(Aufmerksamkeit(Intervention), 1)), zeros(size(Aufmerksamkeit(~Intervention), 1))], 'BoxWidth',0.75, 'JitterOutliers','on', 'Notch','off');
    title('Aufmerksamkeit');
    ylabel('Difference Evening/Morning');
    legend(['Intervention', 'Sham']);
end


% Slopes and TAP / Aufmerksmakeit %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S = mean(Slopes.Whole, 1);
SN2 = mean(Slopes.N2, 1);
SN3 = mean(Slopes.N3, 1);
SDiff = squeeze(mean(Slopes.EndsWhole(:,:,1), 1)- mean(Slopes.EndsWhole(:,:,2), 1));
SDiff2 = squeeze(mean(Slopes.EndsN2(:,:,1), 1)- mean(Slopes.EndsN2(:,:,2), 1));
SDiff3 = squeeze(mean(Slopes.EndsN3(:,:,1), 1)- mean(Slopes.EndsN3(:,:,2), 1));

I = mean(Intercepts.Whole, 1);
IN2 = mean(Intercepts.N2, 1);
IN3 =  mean(Intercepts.N3, 1);
IDiff = squeeze(mean(Intercepts.EndsWhole(:,:,1), 1)- mean(Intercepts.EndsWhole(:,:,2), 1));
IDiff2 = squeeze(mean(Intercepts.EndsN2(:,:,1), 1)- mean(Intercepts.EndsN2(:,:,2), 1));
IDiff3 = squeeze(mean(Intercepts.EndsN3(:,:,1), 1)- mean(Intercepts.EndsN3(:,:,2), 1));

AS = mean(Slopes.Whole(:,IsADHD), 1);
ASN2 = mean(Slopes.N2(:,IsADHD), 1);
ASN3 = mean(Slopes.N3(:,IsADHD), 1);
ASDiff = squeeze(mean(Slopes.EndsWhole(:,IsADHD,1), 1)- mean(Slopes.EndsWhole(:,IsADHD,2), 1));
ASDiff2 = squeeze(mean(Slopes.EndsN2(:,IsADHD,1), 1)- mean(Slopes.EndsN2(:,IsADHD,2), 1));
ASDiff3 = squeeze(mean(Slopes.EndsN3(:,IsADHD,1), 1)- mean(Slopes.EndsN3(:,IsADHD,2), 1));

AI = mean(Intercepts.Whole(:,IsADHD), 1);
AIN2 = mean(Intercepts.N2(:,IsADHD), 1);
AIN3 =  mean(Intercepts.N3(:,IsADHD), 1);
AIDiff = squeeze(mean(Intercepts.EndsWhole(:,IsADHD,1), 1)- mean(Intercepts.EndsWhole(:,IsADHD,2), 1));
AIDiff2 = squeeze(mean(Intercepts.EndsN2(:,IsADHD,1), 1)- mean(Intercepts.EndsN2(:,IsADHD,2), 1));
AIDiff3 = squeeze(mean(Intercepts.EndsN3(:,IsADHD,1), 1)- mean(Intercepts.EndsN3(:,IsADHD,2), 1));

ATAP = TAP(IsADHD);
AAufmerksamkeit = Aufmerksamkeit(IsADHD);

All = cell(4, 6);
OnlyADHD = cell(4, 6);


% Vergleich mit allen Schlafstadien %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(S, TAP);
p1 = abs(Pearson1);
All(1,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(S, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(I, TAP);
p3 = abs(Pearson3);
All(3,1) = num2cell(p(1,2));
if p(1,2)< 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(I, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(SN2, TAP);
p1 = abs(Pearson1);
All(1,3) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(SN2, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,3) = num2cell(p(1,2));
if  p(1,2)< 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(IN2, TAP);
p3 = abs(Pearson3);
All(3,3) = num2cell(p(1,2));
if p(1,2)< 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(IN2, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,3) = num2cell(p(1,2));
if p(1,2)< 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(SN3, TAP);
p1 = abs(Pearson1);
All(1,5) = num2cell(p(1,2));
if p(1,2)< 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(SN3, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,5) = num2cell(p(1,2));
if p(1,2)< 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(IN3, TAP);
p3 = abs(Pearson3);
All(3,5) = num2cell(p(1,2));
if p< 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(IN3, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,5) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit Allen Stadien Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(SDiff, TAP);
p1 = abs(Pearson1);
All(1,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(SDiff, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(IDiff, TAP);
p3 = abs(Pearson3);
All(3,2) = num2cell(p(1,2));
if p< 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(IDiff, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vegleich mit N2 Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(SDiff2, TAP);
p1 = abs(Pearson1);
All(1,4) = num2cell(p(1,2));
if p< 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(SDiff2, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(IDiff2, TAP);
p3 = abs(Pearson3);
All(3,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(IDiff2, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N3 Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(SDiff3, TAP);
p1 = abs(Pearson1);
All(1,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(SDiff3, Aufmerksamkeit);
p2 = abs(Pearson2);
All(2,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(IDiff3, TAP);
p3 = abs(Pearson3);
All(3,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(IDiff3, Aufmerksamkeit);
p4 = abs(Pearson4);
All(4,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Same Same mit nur ADHD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vergleich mit allen Schlafstadien %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(AS, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(AS, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AI, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AI, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,1) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(ASN2, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,3) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(ASN2, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,3) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AIN2, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,3) = num2cell(p(1,2));
if p< 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AIN2, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,3) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(ASN3, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,5) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(ASN3, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,5) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AIN3, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,5) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AIN3, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,5) = num2cell(p(1,2));
if p< 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit Allen Stadien Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(ASDiff, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(ASDiff, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AIDiff, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AIDiff, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,2) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vegleich mit N2 Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(ASDiff2, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(ASDiff2, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AIDiff2, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AIDiff2, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,4) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end


% Vergleich mit N3 Unterschied %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Pearson1, p] = corrcoef(ASDiff3, ATAP);
p1 = abs(Pearson1);
OnlyADHD(1,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p1))
else
    disp('Slopes and TAP correlation not significant')
end

[Pearson2, p] = corrcoef(ASDiff3, AAufmerksamkeit);
p2 = abs(Pearson2);
OnlyADHD(2,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p2))
else
    disp('Slopes and Aufmerksamkeit correlation not significant')
end

[Pearson3, p] = corrcoef(AIDiff3, ATAP);
p3 = abs(Pearson3);
OnlyADHD(3,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p3))
else
    disp('Intercepts and TAP correlation not significant')
end

[Pearson4, p] = corrcoef(AIDiff3, AAufmerksamkeit);
p4 = abs(Pearson4);
OnlyADHD(4,6) = num2cell(p(1,2));
if p(1,2) < 0.05
    disp(min(p4))
else
    disp('Intercepts and Aufmerksamkeit correlation not significant')
end

[rejected, p_corrected] = fdr_bh(cell2mat(All(:)), 0.05, 'bh', 'yes');
[rejected, p_corrected] = fdr_bh(OnlyADHD(:), 0.5, 'bh', 'yes');