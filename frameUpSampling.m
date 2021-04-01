[pwAllm] = pinwheel_filter3(pwAll,3);
[~,~,clustersXY1] = clusterXYpoints(pwAllm(:,6),3,[],'point','merge');
for kk = 1:length(clustersXY1)
    pTemp = clustersXY1{kk};
    if size(pTemp,1)<3
        clustersXY1{kk} = [];
    end
end
%%
clustersXY1 = clustersXY1(find(~cellfun(@isempty,clustersXY1)));
for kk2 = 1:length(clustersXY1)
    cTemp = clustersXY1{kk2};
    cLength(kk2) = max(cTemp)-min(cTemp);
end
clustersXY2 = clustersXY1(cLength>=20);
%%
figure
h2 = histogram(cLength)
h2.FaceColor = 'k';
xlabel('Temporal length')
ylabel('Counts');
%% frame upsampling
for j = 1:length(clustersXY2)
    frameA = clustersXY2{j};
    frameA = sort(frameA);
    frameA1 = frameA(1):frameA(end);
    periEventV = dV(:,frameA1);
    pwa = pwAll(frameA1);
    pwa1 = cat(1,pwa{:});
    %%
    Ur = reshape(U, size(U,1)*size(U,2), size(U,3));
    meanTrace = Ur*periEventV;
    meanTraceA = reshape(meanTrace,size(U,1), size(U,2),size(meanTrace,2));
    %%
    rate = 0.1;
    tq = frameA(1):rate:frameA(end);
    meanTrace1 = interp1(frameA1,meanTrace',tq);
    meanTrace1 = meanTrace1';
    %% filter 2-8Hz
    Fs = 35*(1/rate);
    traceTemp = meanTrace1-repmat(mean(meanTrace1,2),1,size(meanTrace1,2));
    % filter and hilbert transform work on each column
    traceTemp = traceTemp';
    [f1,f2] = butter(2, [2 8]/(Fs/2), 'bandpass');
    traceTemp = filter(f1,f2,traceTemp);
    traceHilbert =hilbert(traceTemp);
    tracePhase = angle(traceHilbert);
    tracePhase = reshape(tracePhase,size(tracePhase,1),size(U,1), size(U,2));
    %%
    pwAllUp = spiralAlg(tracePhase);
    [pwAllUp] = pinwheel_filter3(pwAllUp,2);
    %%
    % figure;
    % sizeN = size(tracePhase,1);
    % for i = 1:sizeN
    %     imagesc(squeeze(tracePhase(i,:,:)))
    %     colormap(hsv)
    %     cell1 = pwAllUp(find(pwAllUp(:,6)==i),:);
    %     if not(isempty(cell1))
    %         hold on
    %         plot(cell1(:,1),cell1(:,2),'.','MarkerSize', 20,'color','k')
    %     end
    %     text(50,50,['\bf\fontsize{20} frame' num2str(i)],'Interpreter','Tex');
    %     pause(0.1)
    % end
    %%
    sizeN = size(tracePhase,1);

    figure;
    immax = max(max(max(tracePhase)));
    immin = min(min(min(tracePhase)));
    imH = [];
    v = VideoWriter(['video/phasemap_' num2str(frameA1(1)) '_' num2str(frameA1(end)) '.avi']);
    v.FrameRate = 10;
    open(v);
    for i = 1:sizeN 
        A = squeeze(tracePhase(i,:,:));
        if not(isempty(pwAllUp))
            cell1 = pwAllUp(find(pwAllUp(:,6)==i),:);
        else
            cell1 = [];
        end
        if isempty(cell1)
            cell1 = [0 0];
        end
        if i == 1
            imH = imagesc(A);
            colorbar
            caxis([immin, immax])
            colormap(hsv);
            hold on
            ax1 = plot(cell1(:,1),cell1(:,2),'.','MarkerSize', 20,'color','k');
            h1 = text(50,50,['\bf\fontsize{20} frame' num2str(i)],'Interpreter','Tex');
        else
            set(imH, 'CData', A);
            h1.String = ['\bf\fontsize{20} frame' num2str(i)];
            ax1.XData = cell1(:,1);
            ax1.YData = cell1(:,2);
        end 
        thisFrame = getframe(gca);
        writeVideo(v, thisFrame);
    end
    close(v);       
end