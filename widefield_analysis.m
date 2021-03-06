% add path for dependencies 
githubDir = 'C:\Users\Steinmetz lab\Documents\git';

addpath(genpath(fullfile(githubDir, 'widefield'))) % cortex-lab/widefield
addpath(genpath(fullfile(githubDir, 'Pipelines')))
addpath(genpath(fullfile(githubDir, 'wheelAnalysis'))) % cortex-lab/wheelAnalysis
%%
% specify folder for widefield image data
mn = 'ZYE_0012';
td = '2020-10-16';
en = 5;
enexp = 8;

serverRoot = expPath(mn, td, en);
% serverRoot2 = expPath(mn, td, enexp);
%%
%plot PCA components and traces for blue and purple channels
corrPath = fullfile(serverRoot, 'corr', 'svdTemporalComponents_corr.npy');
if ~exist(corrPath, 'file')
    colors = {'blue', 'violet'};
    computeWidefieldTimestamps(serverRoot, colors); % preprocess video
    nSV = 200;
    [U, V, t, mimg] = hemoCorrect(serverRoot, nSV); % process hemodynamic correction
else
    nSV = 200;
    [U, V, t, mimg] = loadUVt(serverRoot, nSV);
%     movieSuffix = 'blue';
%     U = readUfromNPY(fullfile(serverRoot, movieSuffix, ['svdSpatialComponents.npy']), nSV);
%     mimg = readNPY(fullfile(serverRoot, movieSuffix, ['meanImage.npy']));
%     fprintf(1, 'corrected file not found; loading uncorrected temporal components\n');
%     V = readVfromNPY(fullfile(serverRoot, movieSuffix, ['svdTemporalComponents.npy']), nSV);
%     t = readNPY(fullfile(serverRoot, movieSuffix, ['svdTemporalComponents.timestamps.npy']));
%     Fs = 1/mean(diff(t));
%     V = detrendAndFilt(V, Fs);
end
if length(t) > size(V,2)
  %t = t(1:end-1);
  t = t(1:size(V,2));
end
%%
pixelCorrelationViewerSVD(U,V)
dV = [zeros(size(V,1),1) diff(V,[],2)];
ddV = [zeros(size(dV,1),1) diff(dV,[],2)];
%%
%identify position of point of interest
% here, PM at right hemisphere is point of interest in pixelCorrelationViewerSVD
%V1
point_v1 = [450,430];
%PM
point_pm = [430,363];
%RSP
point_rsp = [393,303];
%SS
point_ss = [240,415];


hold on
scatter(point_v1(1,2),point_v1(1,1),12,'k');
hold on
scatter(point_pm(1,2),point_pm(1,1),12,'c');
hold on
scatter(point_rsp(1,2),point_rsp(1,1),12,'m');
hold on
scatter(point_ss(1,2),point_ss(1,1),12,'g');

% files = dir(fullfile(serverRoot2, '*Block*.mat' ));
% load(fullfile(files.folder, files.name))
%% 
matchBlocks2Timeline(mn,td,[],[]);
%% time information from photodiode in image data folder
sigName = 'photodiode';
tlFile = fullfile(serverRoot, [sigName '.raw.npy']); 
pd = readNPY(tlFile);

tlFile = fullfile(serverRoot, [sigName '.timestamps_Timeline.npy']);
tlTimes = readNPY(tlFile);
tt = tsToT(tlTimes, numel(pd)); 

%set threshold for photodiode detection, based on the tt~pd plot above
pdThresh = [1 1.1];
[pdAll,pdOn1, pdOff1] = schmittTimes(tt, pd, pdThresh);

%% load pupilsize results from DLC
[tAll, tUp, tDown] = getTLtimesDigital(mn, td, en, 'cameraTrigger');

tFile1 = fullfile(serverRoot, 'pupilsize.raw.npy'); 
pupil_mean = readNPY(tFile1); 
pupilsize = [tUp,pupil_mean];
%% load rotary encoder 
[t1,locomotion] = getTLanalog(mn, td, en, 'rotaryEncoder');
speed = [0; diff(locomotion)];
speed(abs(speed)>=1000) = 0;
speed1 = smooth(speed,1000,'sgolay');
%% plot example trace in V1,SS, pupilsize, stim time
% find time points where both V1 and SS have 3-6Hz oscillation
px_v1 = squeeze(U(point_v1(1),point_v1(2),:))'*dV;
px_ss = squeeze(U(point_ss(1),point_ss(2),:))'*dV;
figure; 
plot(t, px_v1,'r'); 
hold on;
plot(t, px_ss,'c'); 
hold on;
plot(pupilsize(:,1),pupilsize(:,2)*10,'k')
% hold on; plot(pdAll, ones(size(pdAll))*10+1000, 'go')
hold on; plot(t1,speed1*100+1000,'b');
legend('V1','SS','pupil','rotary')

%%
pwframe = find(~cellfun(@isempty,pwAllm));
pwbinary = zeros(length(pwAllm),1);
pwbinary(pwframe) = 200;
hold on 
plot(t,pwbinary,'g','LineWidth',3)
%% plot powerband
temp = zeros(71,size(px_v1,2));
for k = 36:size(px_v1,2)-36
    temp(:,k) = px_v1(1,k-35:k+35);
end
%%
theta = bandpower(temp,35,[3,8]);
delta = bandpower(temp,35,[0.5,2]);
%%
theta1 = theta/max(theta);
delta1 = delta/max(delta);
ratio1 = theta'./delta';
ratio2 = medfilt1(ratio1,350);
hold on; plot(t,theta1*500+1500,'k')
hold on;plot(t,delta1*500+1500,'r')
% % hold on; 
% % plot(t,ratio2*1000+3000,'g')