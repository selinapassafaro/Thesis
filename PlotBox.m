function [h, p] = PlotBox(Data1, Data2, labels, Title, Ylabel)
% datas need to be one matrix 





if size(Data1) == size(Data2)
    [h, p, ~, ~] = ttest2(Data1, Data2);
    if h==0
        disp(strcat(Title, ' not significant'));
    else
        disp(strcat(Title, " Significant, with p=" + p));
        figure;
        boxplot({Data1, Data2}, 'Labels', labels);
        title(Title);
        ylabel(ylabel);
    end
else
    %disp("Gruppen haben nicht dieselbe Grösse")
    [h, p, ~, ~] = ttest2(Data1, Data2);
    if h==0
        disp(strcat(Title, ' not significant'));
    else
        disp(strcat(Title, " Significant, with p=" + p));
        maxGroupSize = max([length(Data1), length(Data2)]);
        Data(1,1:length(Data1)) = Data1;
        Data(1,(length(Data1)+1):(length(Data1)+length(Data2))) = Data2;
        Title = str2num(Title);
        Ylabel = str2num(Ylabel);
        Group = logical([zeros(1,size(Data1,2)), ones(1,size(Data2,2))]);


        figure;
        boxchart(Data', 'GroupByColor', Group, 'BoxWidth',0.75, 'JitterOutliers','on', 'Notch','off');
        title(Title);
        ylabel(Ylabel);
        legend(labels)
        
    end
end
