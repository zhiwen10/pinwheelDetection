syncTL = loadAlign(serverRoot, 'tl');
% syncProbe = loadAlign(serverRoot, [probeName '_imec' num2str(imec)]);
syncProbe = loadAlign(serverRoot, probeName);
if size(syncProbe,1)-size(syncTL,1) ~= 0
    % syncProbe = [syncProbe; zeros(size(syncTL,1)-size(syncProbe,1), 1)];
    syncTL = syncTL(1:size(syncProbe,1),1);
end
t1 = interp1(syncTL, syncProbe, t);  
