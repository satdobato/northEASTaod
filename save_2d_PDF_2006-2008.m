% This script generates the PDF of the yearly data for all possible
% combinations. To show that the nature of the pdfs are different.
% The present status is that addition of 2008 data decrease the R and
% slope!!!

% Created by: Nabin Malakar
% April 16, 2014

% Once the figures are generated, run the simpleHTMLtable.m accompanied by
% the onetext.txt to generate the webpage


load('/Users/macuser/Copy/tryingBias/database_2006_2008_stPM25_MODIS_CMAQ_GOES_olddata_2006_2007_numsta.mat')
%Columns are
%1 - station latitude
%2 - station longitude

%3 - year
%4 - month
%5 - day
%6 - UTC time

%7 - Station PM2.5

%13 - AQUA Optical_Depth_Land_And_Ocean
%36 - TERRA Optical_Depth_Land_And_Ocean

%54 - CMAQ PM2.5
%55 - WRF PBL
%56 - CMAQ PRESSURE
%57 - CMAQ RH
%58 - CMAQ TEMPERATURE
%59 - CMAQ WIND
%60 - GOES AOD
%61 - Station number
%
% load('/Users/macuser/Dropbox/With-Lina/Database_generation/Variables/CMAQ_PM25_2006_2008_updated.mat')
%has the cmaq pm as all_data

% CMAQpm = all_data(:,7);

% load('/Users/macuser/Dropbox/With-Lina/Database_generation/Variables/database_stPM25_MODIS_CMAQ_updated.mat')
% has the Station PM as database
CMAQpm = database(:,54);

stPM = database(:,7);

Lat = database(:,1);
Lon = database(:,2);
dates = database(:,3:6);

PBL = database(:,55);

PR = database(:,56);
RH = database(:,57);
TE = database(:,58);
WI = database(:,59);

aAOD = database(:,13);
tAOD = database(:,36);

AOD(:,1) = database(:,13);
AOD(:,2) = database(:,36);
% for linear regression I just need the aod and pm
AODmean = nanmean(AOD,2);

CMdatabase = [Lat Lon dates stPM AODmean PBL PR RH TE WI];

mean24hr = 1;

daily_AV = [];
if mean24hr
    kk=1;
    for jj = 1:24:size(CMdatabase,1)
        daily_AV(kk,:) = nanmean(CMdatabase(jj:jj+24-1,:)); % instead of 1:24, take mean of 16:21
        kk = kk+1;
    end
    
else
    % do nothing
    
    %take mean plus/minus 2 hours
    for kk = 1:length(ihour)
        
        daily_AV(kk,:) = nanmean(CMdatabase(ihour(kk)-2:ihour(kk)+2,:));
    end
    
    
end

%%

[row,col]=find(isnan(daily_AV));

% Drop missing rows
daily_AV(row,:)=[];

inowant = daily_AV(:,7)<0; % PM <0
daily_AV(inowant,:)=[];
inowant = daily_AV(:,8)<0; % AOD <0
daily_AV(inowant,:)=[];



clear Lat Lon dates stPM AODmean PBL TE PR RH WI

Lat = daily_AV(:,1);
Lon = daily_AV(:,2);
dates = daily_AV(:,3:6);

stPM = daily_AV(:,7);
mAOD = daily_AV(:,8);

PBL = daily_AV(:,9);

PR = daily_AV(:,10);
RH = daily_AV(:,11);
TE = daily_AV(:,12);
WI = daily_AV(:,13);
%% If wanted to do the Optbins
% moptM = mOPTBINS(stPM', 30); % apply optbins

%%
% Now lets look into the 2D histograms, and compute MI for each.
idatacomb = [stPM mAOD PBL PR RH TE WI];
combinations = combnk([1:7],2);

for yearme = 2006:2008
    
    % now do the 2006 2008 histograms
    iwant = find(dates(:,1)==yearme);
    %     idata = idatacomb(iwant,:);
    
    
    namestr = {'stPM', 'AOD', 'PBL', 'PR', 'RH', 'TE', 'WI'};
    
    for  jj=1:length(combinations)
        
        xlabelname = namestr{combinations(jj,1)};
        ylabelname = namestr{combinations(jj,2)};
        
        dataOPTBINS = squeeze(idatacomb(iwant,combinations(jj,:)));
        % Make a 2D bar graph
        [counts binwidth centers] = histogram(dataOPTBINS', [20,20]);
        imagesc(counts')
        axis xy
        
        iMI = muting(dataOPTBINS);
        MI =sqrt(1-exp(-2*iMI));
        
        [KL, KLD, KLjs ] = kullbackD(dataOPTBINS);
        
        xlabel(xlabelname, 'FontSize', 20);
        ylabel(ylabelname, 'FontSize', 20);
        set(gca,'fontsize',20)
        
        titleme = sprintf(['Joint PDF ', num2str(yearme), ', MI: %.2f,  KLD: %.2f ' ], MI, KLD)
        title(titleme,  'FontSize', 20);
        
        
        saveas(gcf, ['savePDF/', xlabelname, '-', ylabelname, num2str(yearme)], 'png');
        
    end
end



