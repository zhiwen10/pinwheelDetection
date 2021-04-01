pwframe = find(~cellfun(@isempty,pwAllm));
%%
Fs = 1/median(diff(t));
ftotal = size(t,1);
% ftotal = 1000;
fstep = 5000;
nstep = ceil(ftotal/fstep);
wina = 1:fstep;
tStart = tic;
for step = 1:nstep  
    win1a{step} = wina+fstep*(step-1);
    if step == nstep
        win1a{step} = (fstep*(step-1)+1):ftotal;       
    end    
end
for i = 1:length(pwframe)
    j =1; pwindex = [];
    while j<=length(win1a) && isempty(pwindex)
        pwindex = find(win1a{j}==pwframe(i));
        j = j+1;
    end
    pwstep(i) = j-1;
end

%%
Fs = 1/median(diff(t));
ftotal = size(t,1);
fstep = 5000;
nstep = ceil(ftotal/fstep);
winSamps = 1:fstep;
totalframe = length(pwframe);
foldername = 'ZYE12_20201016_PW_only';
mkdir(foldername)
frameCount = 1;
figure
for step = 1:nstep
    win1 = winSamps+fstep*(step-1);
    if step == nstep
        win1 = (fstep*(step-1)+1):ftotal;
    end    
    if step>1 && step< nstep
        win2 = [win1(1,1)-10:win1(1,1)-1, win1,win1(1,end)+1:win1(1,end)+10];
        tracePhase = PhaseMap(U,dV,t,win2);
        tracePhase = tracePhase(11:end-10,:,:);
    elseif step == 1
        win2 = [win1,win1(1,end)+1:win1(1,end)+10];
        tracePhase = PhaseMap(U,dV,t,win2);
        tracePhase = tracePhase(1:end-10,:,:);
    else
        win2 = [win1(1,1)-10:win1(1,1)-1, win1];
        tracePhase = PhaseMap(U,dV,t,win2);
        tracePhase = tracePhase(11:end,:,:);
    end   
    
    %%
    pwframeTemp = []; pointsAll = [];
    pwframeTemp = pwframe(find(pwstep == step));
    for k = 1:length(pwframeTemp)
        pwframeTemp1 = pwframeTemp(k)-(step-1)*fstep;
        pointsAll = pwAllm{pwframeTemp(k)};
        cdata1 = squeeze(tracePhase(pwframeTemp1,:,:));
        if frameCount ==1
            imH = imagesc(cdata1); 
            colormap(hsv); 
            axis image; axis off;
            hold on;          
            imH2 = scatter(pointsAll(:,1),pointsAll(:,2),30,'k','filled');
        else
            set(imH, 'CData', cdata1);
            set(imH2,'XData',pointsAll(:,1)); set(imH2,'YData',pointsAll(:,2));
        end
        framename = ['frame ' num2str(pwframeTemp(k))];
        title(framename);
        saveas(gcf,[foldername '/' framename '.tiff']);
        frameCount = frameCount+1; 
        if mod(frameCount,50) == 0
            fprintf('frame %g/%g \n', [frameCount, totalframe])
        end
    end  
end

    
        
        