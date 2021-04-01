function tracePhase = PhaseMap(U,dV,t,winSamps)
% blockt = 1860;
% duration = [0 100];
%%
nSV = size(U,3);
Fs = 1/median(diff(t));
periEventV = dV(:,winSamps);
Ur = reshape(U, size(U,1)*size(U,2), size(U,3));
%% trace re-construction
meanTrace = Ur*periEventV;
% meanTrace = reshape(meanTrace, size(U,1), size(U,2), size(meanTrace,2));
%% filter 2-8Hz
traceTemp = meanTrace-repmat(mean(meanTrace,2),1,size(meanTrace,2));
% filter and hilbert transform work on each column
traceTemp = traceTemp';
[f1,f2] = butter(2, [2 8]/(Fs/2), 'bandpass');
traceTemp = filter(f1,f2,traceTemp);
traceHilbert =hilbert(traceTemp);
tracePhase = angle(traceHilbert);
tracePhase = reshape(tracePhase,size(tracePhase,1),size(U,1), size(U,2));
end