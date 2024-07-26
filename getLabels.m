function [Vis] = getLabels(P, Info)

fieldNames = fieldnames(P.Paths); 
Vis = struct();
BMSSLParticipants = Info(ismember(Info.Dataset, 'BMSSL memo'), :);


if isfield(P.Paths, 'BMSSLMemo')
    PathAll = P.Paths.BMSSLMemo.Staging{1};
    for n = 1:size(BMSSLParticipants.OldName, 1)
            Name = {"BMSSL_" + squeeze(BMSSLParticipants.OldName(n)) + "_1_rh_artndxn.mat"};
            Name1 = {"BMSSL" + squeeze(BMSSLParticipants.OldName(n))};
            addpath(string(PathAll));
            data = importdata(Name{1});
            
            LogicalArray = 1:length(data.visnum);
            LogicalArray = ~ismember(LogicalArray, data.visgood);
            visnumgood = data.visnum;
            visnumgood(LogicalArray) = [];
            Vis.(Name1{1}).Session1 = visnumgood;

            Name = {"BMSSL_" + squeeze(BMSSLParticipants.OldName(n)) + "_2_rh_artndxn.mat"};
            addpath(string(PathAll));
            data = importdata(Name{1});
            LogicalArray = 1:length(data.visnum);
            LogicalArray = ~ismember(LogicalArray, data.visgood);
            visnumgood = data.visnum;
            visnumgood(LogicalArray) = [];
            Vis.(Name1{1}).Session2 = visnumgood;

    end
end

        

