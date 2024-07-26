function [DataToPlot, logicalsPlot] = MakeReady(Slopes,Intercepts, ParticipantInfo)
%Data Zuerst alle Session1, dann alle Session2 
%Data(Channels,Participants/Sessions)

%%% Slopes in DataToPlot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataToPlot.Slopes.Whole = [Slopes.All.Whole(:,:,1), Slopes.All.Whole(:,:,2)];
DataToPlot.Slopes.N2 = [Slopes.N2.Whole(:,:,1), Slopes.N2.Whole(:,:,2)];
DataToPlot.Slopes.N3 = [Slopes.N3.Whole(:,:,1), Slopes.N3.Whole(:,:,2)];
DataToPlot.Slopes.EndsWhole = cat(3, [Slopes.All.Evening(:,:,1), Slopes.All.Evening(:,:,2)], [Slopes.All.Morning(:,:,1), Slopes.All.Morning(:,:,2)]);
DataToPlot.Slopes.EndsN2 = cat(3, [Slopes.N2.Evening(:,:,1), Slopes.N2.Evening(:,:,2)], [Slopes.N2.Morning(:,:,1), Slopes.N2.Morning(:,:,2)]);
DataToPlot.Slopes.EndsN3 = cat(3, [Slopes.N3.Evening(:,:,1), Slopes.N3.Evening(:,:,2)], [Slopes.N3.Morning(:,:,1), Slopes.N3.Morning(:,:,2)]);

%%% Intercepts in DataToPlot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DataToPlot.Intercepts.Whole = [Intercepts.Whole(:,:,1), Intercepts.Whole(:,:,2)];
DataToPlot.Intercepts.N2 = [Intercepts.N2.Whole(:,:,1), Intercepts.N2.Whole(:,:,2)];
DataToPlot.Intercepts.N3 = [Intercepts.N3.Whole(:,:,1), Intercepts.N3.Whole(:,:,2)];
DataToPlot.Intercepts.EndsWhole = cat(3, [Intercepts.Evening(:,:,1), Intercepts.Evening(:,:,2)], [Intercepts.Morning(:,:,1), Intercepts.Morning(:,:,2)]);
DataToPlot.Intercepts.EndsN2 = cat(3, [Intercepts.N2.Evening(:,:,1), Intercepts.N2.Evening(:,:,2)], [Intercepts.N2.Morning(:,:,1), Intercepts.N2.Morning(:,:,2)]);
DataToPlot.Intercepts.EndsN3 = cat(3, [Intercepts.N3.Evening(:,:,1), Intercepts.N3.Evening(:,:,2)], [Intercepts.N3.Morning(:,:,1), Intercepts.N3.Morning(:,:,2)]);

%%% logicals %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logicalADHD = ismember(ParticipantInfo.Group(:), 'ADHD');
logicalsPlot.ADHD = logical(vertcat(logicalADHD, logicalADHD));
logicalsPlot.NoADHD = logical(vertcat(~logicalADHD, ~logicalADHD));
logicalSham1 = ismember(ParticipantInfo.ShamSession, 1);
logicalSham2 = ismember(ParticipantInfo.ShamSession, 2);
logicalsPlot.Sham = logical(vertcat(logicalSham1, logicalSham2));
logicalsPlot.Intervention = logical(vertcat(~logicalSham1, ~logicalSham2));
logicalsPlot.ShamADHD = logical(vertcat((logicalSham1 & logicalADHD), (logicalSham2 & logicalADHD)));
logicalsPlot.InterventionADHD = logical(vertcat((~logicalSham1 & logicalADHD), (~logicalSham2 & logicalADHD)));
logicalsPlot.ShamHC = logical(vertcat((logicalSham1 & ~logicalADHD), (logicalSham2 & ~logicalADHD)));
logicalsPlot.InterventionHC = logical(vertcat((~logicalSham1 & ~logicalADHD), (~logicalSham2 & ~logicalADHD)));

[Group1, Group2, Group3, Group4, Group5] = getagegroups(ParticipantInfo);
logicalsPlot.ages.acht = Group1;
logicalsPlot.ages.zehn = Group2;
logicalsPlot.ages.zwoelf = Group3;
logicalsPlot.ages.vierzehn = Group4;
logicalsPlot.ages.sechzehn = Group5;