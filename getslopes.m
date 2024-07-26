function [Slopes, Intercepts] = getslopes(Power, PowerStages, Freqs, Info)

Slopes = struct();
Intercepts = Slopes;
Range = [2 40];


for i = 1:size(Power.Whole, 1)
   
    % Generate Name of Participant
    if Info.Dataset(i) == "BMS_SL"
        Name = {"BMS_SL" + num2str(Info.OldName(i))};
    elseif Info.Dataset(i) == "BMSSL memo"
        Name = {"BMSSL" + num2str(Info.OldName(i))};
    end

    %skips Participant if current session is empty
    if any(isempty(Power))
        disp([Name, " has empty session"]);
        continue; % Skip the current iteration
    end
        
    %creating Slopes and Intercepts for all Participants in Whole, Ev & Mo
    for s = 1:2
        for c = 1:size(Power.Whole, 3)
            data = squeeze(Power.Whole(i, s, c, :));
            [Slopes.All.Whole(c, i, s), Intercepts. Whole(c, i, s)] = fooofFit(Freqs, data, Range, false);
            
            if any(isnan(Power.Evening(i, s, c, :)))
            else
            data = squeeze(Power.Evening(i, s, c, :));
            [Slopes.All.Evening(c, i, s), Intercepts.Evening(c, i, s)] = fooofFit(Freqs, data, Range, false);
            end
    
            if any(isnan(Power.Morning(i, s, c, :)))
            else
            data = squeeze(Power.Morning(i, s, c, :));
            [Slopes.All.Morning(c, i, s), Intercepts.Morning(c, i, s)] = fooofFit(Freqs, data, Range, false);
            end

        % !! Kontrollieren, dass Channels Dimension am richtigen Platz ist

        end
        
        for C = 1:size(PowerStages.N2.Whole, 3)
            Data = squeeze(PowerStages.N2.Whole(i, s, C, :));
            [Slopes.N2.Whole(C, i, s), Intercepts.N2.Whole(C, i, s)] = fooofFit(Freqs, Data, Range, false);
            if any(isnan(PowerStages.N2.Ends.Evening(i, s, C, :)))
            else
                Data = squeeze(PowerStages.N2.Ends.Evening(i, s, C, :));
                [Slopes.N2.Evening(C, i, s), Intercepts.N2.Evening(C, i, s)] = fooofFit(Freqs, Data, Range, false);
            end
            if any(isnan(PowerStages.N2.Ends.Morning(i, s, C, :)))
            else
                Data = squeeze(PowerStages.N2.Ends.Morning(i, s, C, :));
                [Slopes.N2.Morning(C, i, s), Intercepts.N2.Morning(C, i, s)] = fooofFit(Freqs, Data, Range, false);  
            end
        end

        for C = 1:size(PowerStages.N3.Whole, 3)
            Data = squeeze(PowerStages.N3.Whole(i, s, C, :));
            [Slopes.N3.Whole(C, i, s), Intercepts.N3.Whole(C, i, s)] = fooofFit(Freqs, Data, Range, false);
        
            if any(isnan(PowerStages.N3.Ends.Evening(i, s, C, :)))
            else
            Data = squeeze(PowerStages.N3.Ends.Evening(i, s, C, :));
            [Slopes.N3.Evening(C, i, s), Intercepts.N3.Evening(C, i, s)] = fooofFit(Freqs, Data, Range, false);
            end

            if any(isnan(PowerStages.N3.Ends.Morning(i, s, C, :)))
            else
            Data = squeeze(PowerStages.N3.Ends.Morning(i, s, C, :));
            [Slopes.N3.Morning(C, i, s), Intercepts.N3.Morning(C, i, s)] = fooofFit(Freqs, Data, Range, false);  
            end
        end


    end
    disp(['Finished ', Name])
end
