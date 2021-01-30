clc;
clear;
close all;
warning off all;
tic;

%% Create sensor nodes, Set Parameters and Create Energy Model

%%%%% Initial parameters %%%%%

[Area, Model] = setParameters(); % Set sensors and network parameters

%%%%% Sensors configuration %%%%%
createFixScenario(); % Create a fix scenario
load Locations; % Load sensors location
Sensors = configureSensors(Model, X, Y);
ploter(Sensors, Model, Area); % Plot network

%%%%% Parameters initialization %%%%%
firstDead = 0; % First dead flag
nDeads = 0; % Number of dead nodes

initEnergy = 0; % Initial energy
for iSensor = 1:Model.n
      initEnergy = Sensors(iSensor).e + initEnergy;
end

SRP = zeros(1, Model.nRounds); % Number of sent routing packets
RRP = zeros(1, Model.nRounds); % Number of receive routing packets
SDP = zeros(1, Model.nRounds); % Number of sent data packets 
RDP = zeros(1, Model.nRounds); % Number of receive data packets 
roundReachToSink = zeros(1, Model.nRounds); % Number of receive data packets to sink

SRP_SUM = zeros(1, Model.nRounds); % Sum of sent routing packets;
RRP_SUM = zeros(1, Model.nRounds); % Sum of receive routing packets  
SDP_SUM = zeros(1, Model.nRounds); % Sum of sent data packets 
RDP_SUM = zeros(1, Model.nRounds); % Sum of receive data packets 
roundReachToSinkSum = zeros(1, Model.nRounds); % Sum of receive data packets to sink

roundDeads = zeros(1, Model.nRounds);
roundCHs = zeros(1, Model.nRounds);

%%%%% Start simulation %%%%%
global srp rrp sdp rdp reachToSink;
srp = 0; % Counter number of sent routing packets
rrp = 0; % Counter number of receive routing packets
sdp = 0; % Counter number of sent data packets 
rdp = 0; % Counter number of receive data packets 
reachToSink = 0; % Counter number of receive data packets to sink

% Sink broadcast start message to all nodes
sender = Model.n + 1; % Sink
receiver = 1:Model.n; % All nodes
Sensors = exchangePackets(Sensors, Model, sender, 'Hello', receiver);

% All sensor send location information to Sink .
Sensors = distanceToSink(Sensors, Model);
% Sender=1:Model.n; % All nodes
% Receiver=Model.n+1; % Sink
% Sensors=SendReceivePackets(Sensors,Model,Sender,'Hello',Receiver);

% Save metrics
SRP(1) = srp;
RRP(1) = rrp;  
SDP(1) = sdp;
RDP(1) = rdp;
roundReachToSink(1) = reachToSink;

SRP_SUM(1) = srp;
RRP_SUM(1) = rrp;  
SDP_SUM(1) = sdp;
RDP_SUM(1) = rdp;
roundReachToSinkSum(1) = reachToSink;

%% Main loop program
for r = 1:1:Model.nRounds

    %%%%% Initialization %%%%%

    % This section operate for each epoch   
    members = []; % Member of each cluster per period
    
    % Counter for bit transmitted to BS and CHs
    srp = 0; % Counter number of sent routing packets
    rrp = 0; % Counter number of receive routing packets
    sdp = 0; % Counter number of sent data packets
    rdp = 0; % Counter number of receive data packets
    reachToSink = 0; % Counter number of receive data packets by sink
    
    % Initialization per round
    SRP(r + 1) = srp;
    RRP(r + 1) = rrp;  
    SDP(r + 1) = sdp;
    RDP(r + 1) = rdp;   
    roundReachToSink(r + 1) = reachToSink;
    
    SRP_SUM(r + 1) = SRP_SUM(r);
    RRP_SUM(r + 1) = RRP_SUM(r);  
    SDP_SUM(r + 1) = SDP_SUM(r);
    RDP_SUM(r + 1) = RDP_SUM(r);
    roundReachToSinkSum(r + 1) = roundReachToSinkSum(r);
    
%     pause(0.001); % Pause simulation
%     hold off; % Clear figure
    
    %%%%% Reset sensors per round and G management %%%%%
    
    % Reset sensors
    Sensors = resetSensors(Sensors, Model);
    
    % Allow sensor to become CH in LEACH algorithm  
    roundClear = 1 / Model.p;
    if(mod(r, roundClear) == 0) 
        for iSensor = 1:1:Model.n
            Sensors(iSensor).G = 0;
        end
    end
    
    %%%%% Routing parameters config per round %%%%%
    
    Routing = Model.Routing;
    if(strcmp(Routing.protocol, 'PROPOSED'))
        Model.Routing.alpha = 1 - exp(1) ^ ((-Routing.landa) * (r-1));
    end
    
    %%%%% plot sensors %%%%%
    nDeads = ploter(Sensors, Model, Area);
    
    % Save r'th period when the first node dies
    if (nDeads >= 1)      
        if(firstDead == 0)
            firstDeadRound = r;
            firstDead = 1;
        end  
    end
    
    %%%%% Cluster head selection %%%%%
    
    % Selection candidate CH based on LEACH set-up phase
    [CHs, Sensors] = selectCH(Sensors, Model, r); 
    
    % Broadcasting CHs to all Sensor that are in radio rage CH.
    for iCH = 1:length(CHs)
        sender = CHs(iCH).id;
        senderRR = Model.RR;
        receiver = findReceiver(Sensors, Model, sender, senderRR);   
        Sensors = exchangePackets(Sensors, Model, sender, 'Hello', receiver);   
    end 
    
    % Sensors join to CH 
    Sensors = joinToCH(Sensors, Model, CHs);

    %%%%% plot network status in end of set-up phase %%%%%
%     for iSensor = 1:Model.n
%         if (Sensors(iSensor).type == 'N' && Sensors(iSensor).distanceToCH < Sensors(iSensor).distanceToSink && Sensors(iSensor).e > 0)
%             XL = [Sensors(iSensor).xd, Sensors(Sensors(iSensor).MCH).xd];
%             YL = [Sensors(iSensor).yd, Sensors(Sensors(iSensor).MCH).yd];
%             hold on;
%             line(XL, YL);
%         end  
%     end
    
    %%%%% steady-state phase %%%%%
    nPackets = Model.nPackets; % Number of packets
    
    for i = 1:1:1 
        % Plot network  
        nDeads = ploter(Sensors, Model, Area);
        
        if(strcmp(Routing.protocol, 'EEM-LEACH'))
            % Sink and all CHs send hello packet to others because of cu calculation
            sender = Model.n + 1;
            senderRR = Model.RR;
            receiver = findReceiver(Sensors, Model, sender, senderRR);   
            Sensors = exchangePackets(Sensors, Model, sender, 'Hello', receiver);
            
            for iCH = 1:length(CHs)
                sender = CHs(iCH).id;
                senderRR = Model.RR;
                receiver = findReceiver(Sensors, Model, sender, senderRR);   
                Sensors = exchangePackets(Sensors, Model, sender, 'Hello', receiver);   
            end 
        end
        
        % All sensor send data packet to CH
        for jCH = 1:length(CHs)
            receiver = CHs(jCH).id;
            sender = findSender(Sensors, Model, receiver); 
            Sensors = exchangePackets(Sensors, Model, sender, 'Data', receiver);
        end 
    end
    
    %%%%% send data packet directly from CH to and SN nodes(that aren't in each cluster) to Sink %%%%%%
    for iSensor = 1:Model.n
        if(Sensors(iSensor).MCH == Sensors(Model.n + 1).id)
            receiver = Model.n + 1; % Sink
            sender = Sensors(iSensor).id; % SN nodes 
            Sensors = exchangePackets(Sensors, Model, sender, 'Data', receiver);
        end
    end
 
%% STATISTICS
   
    SRP(r + 1) = srp;
    RRP(r + 1) = rrp;  
    SDP(r + 1) = sdp;
    RDP(r + 1) = rdp;
    roundReachToSink(r + 1) = reachToSink;
    
    SRP_SUM(r + 1) = SRP_SUM(r) + srp;
    RRP_SUM(r + 1) = RRP_SUM(r) + rrp;  
    SDP_SUM(r + 1) = SDP_SUM(r) + sdp;
    RDP_SUM(r + 1) = RDP_SUM(r) + rdp;
    roundReachToSinkSum(r + 1) = roundReachToSinkSum(r) + reachToSink;
    
    roundDeads(r + 1) = nDeads;
    roundCHs(r + 1) = length(CHs);
    
    
    alive = 0;
    energySum = 0;
    for iSensor = 1:Model.n
        if Sensors(iSensor).e > 0
            alive = alive + 1;
            energySum = energySum + Sensors(iSensor).e;
            roundDeadsPriorities(iSensor, r+1) = 0;
            roundEnergyPriorities(iSensor, r+1) = Sensors(iSensor).e;
        else
            roundDeadsPriorities(iSensor, r+1) = 1;
            roundEnergyPriorities(iSensor, r+1) = 0;
        end
    end
    
    roundAliveSum(r+1) = alive;
    roundDeadsSum(r+1) = Model.n - alive;
    roundEnergySum(r+1) = energySum;
    roundEnergyAvg(r+1) = energySum / Model.n;
    roundEnergyConsume(r+1)=(initEnergy-roundEnergySum(r+1))/Model.n;
    
    en = 0;
    for iSensor = 1:Model.n
        if Sensors(iSensor).e > 0
            en = en + (Sensors(iSensor).e - roundEnergyAvg(r+1))^2;
        end
    end
    
    enheraf(r+1) = en / alive;
    
%     title(sprintf('Round=%d, Dead nodes=%d', r + 1, nDeads)) 
    
   % Check dead condition
   if (Model.n == nDeads) 
       lastPeriod = r;  
       break;
   end
  
end

disp('End of Simulation');
toc;
disp('Create Report...');

filename = sprintf('leach-%d-%s-%s.mat', Model.n, Model.Routing.protocol, datetime('now'));

%% Save Report
save(filename);
