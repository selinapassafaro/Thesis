function [Final] =  getpaths(dataset, Info)
% Gets Final struct with cells for each dataset containing the paths for

% Input: dataset(names of all included datasets) and Info(General Info for
% all possible Participants


Final = struct();

% struct with cell for each dataset and in this cells for EEG-path,
% staging-path and TrigerInfo-path


for i = 1:length(dataset)
    m = 1;
    if dataset(i) == "BMSSL memo"
    %if BMSSL memo set included:
    AllBMSSLMemo = Info(ismember(Info.Dataset, 'BMSSL memo'), 1);
    PathMemo = "L:\Somnus-Data\Data01\BMSSL_memo\data\processed_EGI\fieldtrip_downsamp\";
    for n = 1:size(AllBMSSLMemo)
        if AllBMSSLMemo{n,1} == 111
            Paths.BMSSLMemo.EEG(m) = {PathMemo + 'BMSSL_' + num2str(AllBMSSLMemo{n,1}) + '_1.mat'};
            m = m + 1;
            Paths.BMSSLMemo.EEG(m) = {PathMemo + 'BMSSL_' + num2str(AllBMSSLMemo{n,1}) + '_2.mat'};
            m = m + 1;        
        else
            Paths.BMSSLMemo.EEG(m) = {PathMemo + "BMSSL_" + num2str(AllBMSSLMemo{n,1}) + "_1.mat"};
            m = m + 1;
            Paths.BMSSLMemo.EEG(m) = {PathMemo + 'BMSSL_' + num2str(AllBMSSLMemo{n,1}) + '_2.mat'};
            m = m + 1;
        end
    end
    Paths.BMSSLMemo.Staging = repmat({'L:\Somnus-Data\Data01\BMSSL_memo\data\processed_EGI\artcorr_files'}, 1, size(AllBMSSLMemo, 1));
    Paths.BMSSLMemo.TrigerInfo = repmat({'L:\Somnus-Data\Data01\BMSSL_memo\data\processed_EGI\trig_info'}, 1, size(AllBMSSLMemo, 1));
    Final.Paths.BMSSLMemo = Paths.BMSSLMemo;
    
    
    elseif dataset(i) == "BMS_SL"
    %if BMS_SL dataset included
    m = 1;
    AllBMSSL = Info(ismember(Info.Dataset, 'BMS_SL'), 1);
    PathBMSSL = "L:\Somnus-Data\User\Elena_Krugliakova\__analysis_ADHD\processed_data\20sec_contin\";
    for n = 1:size(AllBMSSL)
            PathName = {PathBMSSL + "contin_20sec_BMSSL_0" + num2str(AllBMSSL{n,1}) + "_1.mat"};
            BMSSL.EEG(m) = PathName{1};
            m = m + 1;
            PathName = {PathBMSSL + "contin_20sec_BMSSL_0" + num2str(AllBMSSL{n,1}) + "_2.mat"};
            BMSSL.EEG(m) = PathName{1};
            m = m + 1;
    end
    Final.Paths.BMSSL.EEG = BMSSL.EEG;


    elseif ismember(dataset, 'BMS')
        AllBMS = ismember(Info.Dataset, 'BMS');
        PathMemo = {''};
        Paths.BMS.EEG = repmat(PathMemo, 1, size(AllBMS, 1))';
        Paths.BMS.EEG = {''};
        Paths.BMS.Staging = {''};
        Paths.BMS.TrigerInfo = {''};
    
    end
end