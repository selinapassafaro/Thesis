function PlotAperiodicParameters (Power, PowerStages, Info, Freqs, Labels, PlotProps, V, StatsP)
Fieldnames = fieldnames(Power);
FieldnamesV = fieldnames(V);

Colors = getColors([3 3]);
Colors(2, :, :) = [];
Colors(:, :, 2) = [];

startColor = [1, 1, 0];     % Yellow
endColor1 = [1, 0.5, 0];    % Orange
endColor2 = [1, 0, 0];      % Red
endColor3 = [0.5, 0, 1];    % Violet
endColor4 = [0, 0, 1];      % Blue
endColor5 = [0, 1, 0];      % Green
numSteps = 22;
MyColor = zeros(numSteps * 5, 3);
startIdx = 1;
endIdx = numSteps;
segments = {endColor1, endColor2, endColor3, endColor4, endColor5};
for i = 1:5
    segmentGradient = colorGradient(startColor, segments{i}, numSteps);
    MyColor(startIdx:endIdx, :) = segmentGradient;
    startIdx = endIdx + 1;
    endIdx = startIdx + numSteps - 1;
    startColor = segments{i};
end



% Powermat mit (Participants/Sessions x Frequencies)
% ->Der Reihe nach alle Participants (mit BMSSL beginnend) und immer direkt
% Session1 und dann Session2
p = 0;


for i = 1:height(FieldnamesV)
    ParticipantNames = FieldnamesV{i};

    p = p +1;
    AktuellePower = Power.(Fieldnames{1});
    Powermat(p, :, :) = squeeze(mean(AktuellePower(i, 1, :, :), 3));
    AktuellePower = Power.(Fieldnames{2});
    PowermatEvening(p, :, :) = squeeze(mean(AktuellePower(i, 1, :, :), 3));
    AktuellePower = Power.(Fieldnames{3});
    PowermatMorning(p, :, :) = squeeze(mean(AktuellePower(i, 1, :, :), 3));
    AktuellePower = PowerStages.N2.Whole;
    PowerN2(p, :, :) = squeeze(mean(AktuellePower(i, 1, :, :), 3));
    AktuellePower = PowerStages.N3.Whole;
    PowerN3(p, :, :) = squeeze(mean(AktuellePower(i, 1, :, :), 3));
    

    p = p +1;
    AktuellePower = Power.(Fieldnames{1});
    Powermat(p, :, :) = squeeze(mean(AktuellePower(i, 2, :, :), 3));
    AktuellePower = Power.(Fieldnames{2});
    PowermatEvening(p, :, :) = squeeze(mean(AktuellePower(i, 2, :, :), 3));
    AktuellePower = Power.(Fieldnames{3});
    PowermatMorning(p, :, :) = squeeze(mean(AktuellePower(i, 2, :, :), 3));
    AktuellePower = PowerStages.N2.Whole;
    PowerN2(p, :, :) = squeeze(mean(AktuellePower(i, 2, :, :), 3));
    AktuellePower = PowerStages.N3.Whole;
    PowerN3(p, :, :) = squeeze(mean(AktuellePower(i, 2, :, :), 3));
   

end

Vector = ismember(Info.Group, "ADHD");
    

% logical vector, for is ADHD and doubled for each session

isADHD = [];
for i = 1:length(Vector)
    if Vector(i) == 0
        isADHD = [isADHD, 0, 0];
    else
        isADHD = [isADHD, 1, 1];
    end
end
isADHD = logical(isADHD);
notADHD = ~logical(isADHD);


MeanHC = Powermat(notADHD, :);
MeanADHD = Powermat(isADHD, :);
isADHD = isADHD';



% Logical Int mit 1 für Intervention und 0 für Sham
BeginSham = Info{:, 18} == 1;
Int = [];
for k = 1:numel(BeginSham)
    if Info{k,18} == 1
        Int = [Int, 0, 1];
    else
        Int = [Int, 1, 0];
    end
end
Int = logical(Int);
NoInt = logical(~Int);
    
MeanInt = Powermat(logical(Int), :);
MeanSham = Powermat(~logical(Int), :);
Int = Int';


% Plot ADHD vs. HC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlotProps.Line.Width = 0.2;
PlotProps.Line.Alpha = 0.3;
figure
for i = 1:height(Powermat)
    if isADHD(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('ADHD ')', squeeze(Colors(:, :, 1)), true, PlotProps, [], Labels, []);
    elseif ~isADHD(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('HC ')', squeeze(Colors(:, :, 2)), true, PlotProps, [], Labels, []);
    end
end

PlotProps.Line.Width = 4;
PlotProps.Line.Alpha = 1;
spectrumDiff(mean(MeanADHD, 1), Freqs, 1, append('ADHD ')', squeeze(Colors(:, :, 1)), true, PlotProps, [], Labels, 'ADHD');
spectrumDiff(mean(MeanHC, 1), Freqs, 1, append('HC')', squeeze(Colors(:, :, 2)), true, PlotProps, [], Labels, 'HC');
ax = gca;
ax.FontSize = 20;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([10^-1, 700]);

legend('ADHD', 'HC')



%Plot Intervention vs. Sham %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlotProps.Line.Width = 0.2;
PlotProps.Line.Alpha = 0.3;
figure
legend('AutoUpdate', 'off')
for i = 1:height(Powermat)
    if Int(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('Int')', squeeze(Colors(:, :, 1)), true, PlotProps, [], Labels, []);
    elseif ~Int(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('Sham')', squeeze(Colors(:, :, 2)), true, PlotProps, [], Labels, []);
    end
end


PlotProps.Line.Width = 4;
PlotProps.Line.Alpha = 1;
legend('AutoUpdate', 'off')
spectrumDiff(mean(MeanInt, 1), Freqs, 1, append('Intervention')', squeeze(Colors(:, :, 1)), true, PlotProps, [], Labels, 'Intervention');
spectrumDiff(mean(MeanSham, 1), Freqs, 1, append('Sham')', squeeze(Colors(:, :, 2)), true, PlotProps, [], Labels, 'Sham');
ax = gca;
ax.FontSize = 20;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([10^-1, 700]);

legend('Intervention', 'Sham');

% Categories with Age %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Group1, Group2, Group3, Group4, Group5] = getagegroups(Info);
MeanYoung = Powermat(Group1 | Group2, :);
MeanOld = Powermat(Group3 | Group4 | Group5, :);


%Plot Age %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PlotProps.Line.Width = 4;
PlotProps.Line.Alpha = 1;
figure

PlotProps.Line.Width = 0.2;
PlotProps.Line.Alpha = 0.3;
cmap5 = parula(5);

for i = 1:height(Powermat)
    if Group1(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('8,9')', cmap5(1,:), true, PlotProps, [], Labels, []); %gelb
    elseif Group2(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('10,11')', cmap5(2,:), true, PlotProps, [], Labels, []);
    elseif Group3(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('12,13')', cmap5(3,:), true, PlotProps, [], Labels, []);
    elseif Group4(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('14,15')', cmap5(4,:), true, PlotProps, [], Labels, []);
    elseif Group5(i) == 1
        spectrumDiff(Powermat(i, :), Freqs, 1, append('16, 17')', cmap5(5,:), true, PlotProps, [], Labels, []); %blau
    end
end

PlotProps.Line.Width = 4;
PlotProps.Line.Alpha = 1;
legend('AutoUpdate', 'off')
spectrumDiff(mean(MeanYoung, 1), Freqs, 1, append('<11')', [0 0.4470 0.7410], true, PlotProps, [], Labels, '<11'); %blau
spectrumDiff(mean(MeanOld, 1), Freqs, 1, append('>11'), [0.4660 0.6740 0.1880], true, PlotProps, [], Labels, '>11'); %grün
ax = gca;
ax.FontSize = 20;
ax.XAxis.FontSize = 20;
ax.YAxis.FontSize = 20;
ylim([10^-1, 700]);

legend('<11', '>11');

legend('off')

[h,p]= ttest(mean(MeanYoung, 1), mean(MeanOld, 1))
