function [N1, N2, N3] = getPartsStagesBMSSL(visnum, ~, number)
% Ouput: N1 & n3 (with .Morning & .Evening) with the logicals for 1/6th of
% the corresponding time of the night of the N2 orr N3 stages


% deepsleeplogical für N2 (deepsleeplogical2) and N3 (--"---3)
deepsleeplogical1 = ismember(visnum, number(1));
partdeepsleep1 = round(sum(deepsleeplogical1)/6);
deepsleeplogical2 = ismember(visnum, number(2));
partdeepsleep2 = round(sum(deepsleeplogical2)/6);
deepsleeplogical3 = ismember(visnum, number(3));
partdeepsleep3 = round(sum(deepsleeplogical3)/6);


% Logicals für first and last 1/6th of the Night for different N stages
Morning1 = false(size(deepsleeplogical1));
Evening1 = Morning1;
Morning2 = false(size(deepsleeplogical2));
Evening2 = Morning2;
Morning3 = false(size(deepsleeplogical3));
Evening3 = Morning3;


% get Logical for first and last 1/6th of the night for N1
count = 0;
for k = 1:numel(deepsleeplogical1)
    if deepsleeplogical1(k) && count < partdeepsleep1
        Evening1(k) = true;
        count = count + 1;
    end
end
count = 0;
for k = 0:(numel(deepsleeplogical1)-1)
    if deepsleeplogical1(end-k) && count < partdeepsleep1
        Morning1(end-k) = true;
        count = count + 1;
    end
end      
N1.Evening = Evening1;
N1.Morning = Morning1;



% get Logical for first and last 1/6th of the night for N2
count = 0;
for k = 1:numel(deepsleeplogical2)
    if deepsleeplogical2(k) && count < partdeepsleep2
        Evening2(k) = true;
        count = count + 1;
    end
end
count = 0;
for k = 0:(numel(deepsleeplogical2)-1)
    if deepsleeplogical2(end-k) && count < partdeepsleep2
        Morning2(end-k) = true;
        count = count + 1;
    end
end      
N2.Evening = Evening2;
N2.Morning = Morning2;



% get Logical for first and last 1/6th of the night for N3
count = 0;
for k = 1:numel(deepsleeplogical3)
    if deepsleeplogical3(k) && count < partdeepsleep3
        Evening3(k) = true;
        count = count + 1;
    end
end
count = 0;
for k = 0:(numel(deepsleeplogical3)-1)
    if deepsleeplogical3(end-k) && count < partdeepsleep3
        Morning3(end-k) = true;
        count = count + 1;
    end
end      
N3.Evening = Evening3;
N3.Morning = Morning3;


