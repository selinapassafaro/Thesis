function [N1, N2, N3] = getPartsStages(V, ~, logical)
% logical(1) = -1 od. 1, logical(2) = -2 od 2, logical(3) = -3 od. 3


visnum = V;
deepsleeplogical1 = ismember(visnum, logical(1));
partdeepsleep1 = round(sum(deepsleeplogical1)/6);
deepsleeplogical2 = ismember(visnum, logical(2));
partdeepsleep2 = round(sum(deepsleeplogical2)/6);
deepsleeplogical3 = ismember(visnum, logical(3));
partdeepsleep3 = round(sum(deepsleeplogical3)/6);

Morning1 = false(size(deepsleeplogical1));
Evening1 = Morning1;
Morning2 = false(size(deepsleeplogical2));
Evening2 = Morning2;
Morning3 = false(size(deepsleeplogical3));
Evening3 = Morning3;


for k = 1:numel(deepsleeplogical1)
    if deepsleeplogical1(k) && count < partdeepsleep1
        Evening1(k) = true;
        count = count + 1;
    end
end
count = 1;
for k = 0:(numel(deepsleeplogical1)-1)
    if deepsleeplogical1(end-k) && count < partdeepsleep1
        Morning1(end-k) = true;
        count = count + 1;
    end
end      
N1.Evening = Evening1;
N1.Morning = Morning1;

count = 1;
for k = 1:numel(deepsleeplogical2)
    if deepsleeplogical2(k) && count < partdeepsleep2
        Evening2(k) = true;
        count = count + 1;
    end
end
count = 1;
for k = 0:(numel(deepsleeplogical2)-1)
    if deepsleeplogical2(end-k) && count < partdeepsleep2
        Morning2(end-k) = true;
        count = count + 1;
    end
end      
N2.Evening = Evening2;
N2.Morning = Morning2;

count = 1;
for k = 1:numel(deepsleeplogical3)
    if deepsleeplogical3(k) && count < partdeepsleep3
        Evening3(k) = true;
        count = count + 1;
    end
end
count = 1;
for k = 0:(numel(deepsleeplogical3)-1)
    if deepsleeplogical3(end-k) && count < partdeepsleep3
        Morning3(end-k) = true;
        count = count + 1;
    end
end      
N3.Evening = Evening3;
N3.Morning = Morning3;