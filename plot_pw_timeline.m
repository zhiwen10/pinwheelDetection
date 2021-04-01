%%
%identify position of point of interest
% here, PM at right hemisphere is point of interest in pixelCorrelationViewerSVD
%V1
point_v1 = [454,422];
%PM
point_pm = [434,344];
%RSP
point_rsp = [418,278];
%SS
point_ss = [257,454];

%% plot example trace in V1,SS, pupilsize, stim time
% find time points where both V1 and SS have 3-6Hz oscillation
px_v1 = squeeze(U(point_v1(1),point_v1(2),:))'*dV;
px_ss = squeeze(U(point_ss(1),point_ss(2),:))'*dV;
%% rewardValve
sigName = 'rewardValve';
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
%% load lick results from DLC
[tAll, tUp, tDown] = getTLtimesDigital(mn, td, en, 'cameraTrigger');
tFile1 = fullfile(serverRoot, 'lick.raw.npy'); 
lick = readNPY(tFile1); 
lick  = smooth(lick ,50,'sgolay');
tlick = [tUp,lick];

%% pw center
[pwAllm] = pinwheel_filter3(pwAll,5);
pwframe = unique(pwAllm(:,6));
pwbinary = zeros(length(pwAll),1);
pwbinary(pwframe) = 1000;
pwbinary = smooth(pwbinary,1000,'sgolay');
%% plot powerband
temp = zeros(71,size(px_v1,2));
for k = 36:size(px_v1,2)-36
    temp(:,k) = px_v1(1,k-35:k+35);
end
theta = bandpower(temp,35,[3,6]);
theta1 = theta/max(theta);
theta1  = smooth(theta1 ,500,'sgolay');
%%

pupilsize_filter = medfilt1(pupilsize(:,2),100*5,'truncate');
% pupilsize_filter = medfilt1(pupilsize(:,2),100*75,'truncate');
%%
figure
plot(pupilsize(:,1),pupilsize_filter*20,'b')
hold on; plot(tlick(:,1),tlick(:,2)*20,'g')
hold on; plot(pdAll, ones(size(pdAll))*1500, 'go') % reward valve
hold on; plot(t,pwbinary*5,'r') %pinwheel
hold on; plot(t,theta1*80000-1000,'k')
legend('pupil','lick','lick valve','pinwheels','v1 3-6Hz power')
% legend('pupil','pinwheels','v1 3-6Hz power')
ax = gca;
ax.FontSize = 16;
xlabel('Time (s)','FontSize',16)
ylim([-2000 2000])
