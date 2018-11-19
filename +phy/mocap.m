load('+phy/private/mocap.mat')

%% 1. Reading, Editing, and Visualizing MoCap Data

p = phy.point('walk.tsv')

phy.pref('DisplayIndex',0)
p

phy.pref('DropFrame',0)
p

phy.pref('Default')

%p = phy.point(p,'Fill')
p = phy.point('walk.tsv','Fill')

sig.signal('ragtime.wav')
s = sig.signal(p,'Point',3,'Dim',3)

sig.signal('ragtime.wav','Extract',1000,1500,'sp')
p = phy.point('walk.tsv','Fill','Extract',160,160,'sp')

p = phy.point('walk.tsv','Fill','Connect',mapar)

%% 2. Transforming MoCap data

% p = phy.point(dance1,'Fill','Extract',50,50,'sp','Connect',mapar)
% ax = gca;
% ax.View = [90,0];

%% 3. Kinematic analysis

d2 = phy.point('dance.tsv','Connect',mapar)
d2v = phy.point('dance.tsv','Velocity')
d2v = phy.point('dance.tsv','Velocity','Connect',mapar)
d2a = phy.point('dance.tsv','Acceleration','Connect',mapar)
s = phy.sync(d2,d2v,d2a)

phy.pref('DropFrame',0)
s
phy.pref('Default')

d2vnf = phy.point('dance.tsv','Velocity','Connect',mapar,'Filter',0)
phy.sync(d2v,d2vnf)

d2anf = phy.point('dance.tsv','Acceleration','Connect',mapar,'Filter',0)
phy.sync(d2a,d2anf)

sv = sig.signal(d2v,'Point',[1;19;25],'Dim',3)
sa = sig.signal(d2a,'Point',[1;19;25],'Dim',3)
s = sig.sync(sv,sa)
s.phaseplane

% d2v = phy.point(dance2,'Velocity','Connect',mapar,'Extract',5,7);
% d2a = phy.point(dance2,'Acceleration','Connect',mapar,'Extract',5,7);
% sv = sig.signal(d2v,'Point',[1;19;25],'Dim',3);
% sa = sig.signal(d2a,'Point',[1;19;25],'Dim',3);
% s = sig.sync(sv,sa);
% s.phaseplane

d2v = phy.point('dance.tsv','Velocity','Connect',mapar,'PerSecond',0,'Filter',0);
sv = sig.signal(d2v,'Point',[1;19;25])
n = sig.norm(sv,'Along','dim')
sig.cumsum(n)

d2m1 = sig.signal(d2,'Point',1)
sig.autocor(d2m1,'Max',2)

d2m1 = sig.signal(d2,'Point',1,'Dim',3)
sig.autocor(d2m1,'Max',2)
sig.autocor(d2m1,'Max',2,'Enhanced')
sig.autocor(d2m1,'Max',2,'Frame','FrameSize',2,'FrameHop',.25,'Enhanced')

[t ac] = mus.tempo(d2m1)
[t ac] = mus.tempo(d2m1,'Frame')

%% 4. Time-series analysis

d = phy.point('dance.tsv');
sd = sig.signal(d,'Point',[1;19;25])
sig.std(sd)

sd = sig.signal(d,'Point',[1;9;19;21;25],'Dim',3)
w = phy.point('walk.tsv');
sw = sig.signal(w,'Point',[1;9;19;21;25],'Dim',3)
sig.skewness(sd,'Distribution')
sig.skewness(sw,'Distribution')

sig.std(sd,'Frame','FrameSize',2,'FrameHop',.25)

%% 5. Kinetic analysis

segmindex = [0 0 8 7 6 0 8 7 6 13 12 10 11 3 2 1 11 3 2 1];
ss = phy.segment('walk.tsv',j2spar,segmindex,'Reduce',m2jpar,'Connect',japar,'Fill')

pe = phy.potenergy(ss)
sig.sum(pe,'Type','segment')