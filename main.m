%% SVD, plot example trace, overlay with pupil and stim time
% specify folder for widefield image data
mn = 'AB_0004';
td = '2021-03-30';
en = 1;
wf_svd;
%% seperate whole file into 5000 frame blocks
% phasemap matrix for the entire recording takes too much memory. 
Fs = 1/median(diff(t));
ftotal = size(t,1);
% ftotal = 1000;
fstep = 5000;
nstep = ceil(ftotal/fstep);
winSamps = 1:fstep;
tStart = tic;
%%
for step = 1:nstep  
% for step = 1
    tic
    winSamps1 = winSamps+fstep*(step-1);
    if step == nstep
        winSamps1 = (fstep*(step-1)+1):ftotal;
    end    
    %% get pinwheel center by blocks of 5000 frames
    % get phasemap first by filter and hilbert transformation
    % then detect pinwheel center in each frame
    if step>1 && step< nstep
        winSamps2 = [winSamps1(1,1)-10:winSamps1(1,1)-1, winSamps1,winSamps1(1,end)+1:winSamps1(1,end)+10];
        tracePhase = PhaseMap(U,dV,t,winSamps2);
        blockPW = spiralAlg(tracePhase);
        blockPW = blockPW(11:end-10);
    elseif step == 1
        winSamps2 = [winSamps1,winSamps1(1,end)+1:winSamps1(1,end)+10];
        tracePhase = PhaseMap(U,dV,t,winSamps2);
        blockPW = spiralAlg(tracePhase);
        blockPW = blockPW(1:end-10);
    else
        winSamps2 = [winSamps1(1,1)-10:winSamps1(1,1)-1, winSamps1];
        tracePhase = PhaseMap(U,dV,t,winSamps2);
        blockPW = spiralAlg(tracePhase);
        blockPW = blockPW(11:end);
    end
    pwAll(winSamps1) = blockPW;
    % count time and display
    T(step) = toc;
    frame = step*fstep;
    fprintf('frame %g/%g; time elapsed %g seconds \n', [frame, ftotal, toc])
end
tEnd = toc(tStart);
fprintf('total time: %g \n',tEnd)
%% plot all pinwheels overlaied in one phasemap image
figure; 
imagesc(squeeze(tracePhase(20,:,:)));
colormap(hsv); 
axis image; axis off;
hold on;
pwAllCell = cat(1,pwAll{:});
scatter(pwAllCell(:,1),pwAllCell(:,2),30,'k','filled');
%% pinwheel filter based on if they are connected in time space
% only keep pinwheels, if there are other pinwheels 
% within euclidean distance (30pixels) in the nearby -3:3 frames.
[pwAllm] = pinwheel_filter(pwAll,4);
pwAllm1 = cat(1,pwAllm{:});
%%
minus1 = pwAllm1(:,4)-pwAllm1(:,3);
index1 = find(minus1>=10);
pwAllm1 = pwAllm1(index1,:);
%%
figure; 
% imagesc(squeeze(tracePhase(50,:,:)));
% colormap(hsv); 
imagesc(mimg);
colormap(colormap_RedWhiteBlue)
axis image; axis off;
hold on;
scatter(pwAllm1(:,1),pwAllm1(:,2),20,'k','filled');
% saveas(gcf,[foldername 'm.tiff']);
% save(foldername,'wheelsAllm','wheelsAllm1');