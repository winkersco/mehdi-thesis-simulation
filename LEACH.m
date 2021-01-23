clc;
clear;
close all;
warning off all;
tic;

%% Create sensor nodes, Set Parameters and Create Energy Model

%%%%% Initial parameters %%%%%

[Area, Model] = setParameters(); % Set sensors and network parameters

%%%%% Sensors configuration %%%%%
createRandomScenario(Model, Area); % Create a random scenario
load Locations; % Load sensors location
Sensors = configureSensors(Model, X, Y);
ploter(Sensors, Model, Area); % Plot network

%%%%% Parameters initialization %%%%%
firstDead = 0; % First dead flag
nCHs = 0; % Counter for CHs
nDeads = 0; % Number of dead nodes

initEnergy = 0; % Initial energy
for iSensor = 1:Model.n
      initEnergy = Sensors(iSensor).e + initEnergy;
end

SRP = zeros(1, Model.nRounds); % Number of sent routing packets
RRP = zeros(1, Model.nRounds); % Number of receive routing packets
SDP = zeros(1, Model.nRounds); % Number of sent data packets 
RDP = zeros(1, Model.nRounds); % Number of receive data packets 

roundDeads = zeros(1, Model.nRounds);
roundCHs = zeros(1, Model.nRounds);

%%%%% Start simulation %%%%%
global srp rrp sdp rdp;
srp = 0; % Counter number of sent routing packets
rrp = 0; % Counter number of receive routing packets
sdp = 0; % Counter number of sent data packets 
rdp = 0; % Counter number of receive data packets 

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

%% Main loop program
for r = 1:1:Model.nRounds

    %%%%% Initialization %%%%%

    % This section operate for each epoch   
    members = []; % Member of each cluster per period
    nCHs = 0; % Number of CHs per period
    
    % Counter for bit transmitted to BS and CHs
    srp = 0; % Counter number of sent routing packets
    rrp = 0; % Counter number of receive routing packets
    sdp = 0; % Counter number of sent data packets to sink
    rdp = 0; % Counter number of receive data packets by sink
    
    % Initialization per round
    SRP(r + 1) = srp;
    RRP(r + 1) = rrp;  
    SDP(r + 1) = sdp;
    RDP(r + 1) = rdp;   
    pause(0.0001); % Pause simulation
    hold off; % Clear figure
    
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
    
    % Sensors join to nearest CH 
    Sensors = joinToNearestCH(Sensors, Model, CHs);

    %%%%% plot network status in end of set-up phase %%%%%
    for iSensor = 1:Model.n
        if (Sensors(iSensor).type == 'N' && Sensors(iSensor).distanceToCH < Sensors(iSensor).distanceToSink && Sensors(iSensor).e > 0)
            XL = [Sensors(iSensor).xd, Sensors(Sensors(iSensor).MCH).xd];
            YL = [Sensors(iSensor).yd, Sensors(Sensors(iSensor).MCH).yd];
            hold on;
            line(XL, YL);
        end  
    end
    
    %%%%% steady-state phase %%%%%
    nPackets = Model.nPackets; % Number of packets
    for i = 1:1:1 
        % Plot network  
        nDeads = ploter(Sensors, Model, Area);
        
        % All sensor send data packet to CH
        for jCH = 1:length(CHs)
            receiver = CHs(jCH).id;
            sender = findSender(Sensors, Model, receiver); 
            Sensors = exchangePackets(Sensors, Model, sender, 'Data', receiver);
        end 
    end
    
    
    %%%%% Send Data packet from CH to sink after data aggregation %%%%%
    for iCH = 1:length(CHs)
        receiver = Model.n + 1; % Sink
        sender = CHs(iCH).id; % CH 
        Sensors = exchangePackets(Sensors, Model, sender, 'Data', receiver);           
    end
    
    %%%%% send data packet directly from SN nodes(that aren't in each cluster) to Sink %%%%%%
    for iSensor = 1:Model.n
        if(Sensors(iSensor).MCH == Sensors(Model.n + 1).id)
            receiver = Model.n + 1; % Sink
            sender = Sensors(iSensor).id; % SN nodes 
            Sensors = exchangePackets(Sensors, Model, sender, 'Data', receiver);
        end
    end
 
%% STATISTICS
   
    roundDeads(r + 1) = nDeads;
    SRP(r + 1) = srp;
    RRP(r + 1) = rrp;  
    SDP(r + 1) = sdp;
    RDP(r + 1) = rdp;
    
    roundCHs(r + 1) = nCHs;
    
    alive = 0;
    energySum = 0;
    for iSensor = 1:Model.n
        if Sensors(iSensor).e > 0
            alive = alive + 1;
            energySum = energySum + Sensors(iSensor).e;
        end
    end
    roundAlive(r) = alive;
    roundEnergySum(r+1) = energySum;
    roundEnergyAvg(r+1) = energySum / alive;
    roundEnergyConsume(r+1)=(initEnergy-roundEnergySum(r+1))/Model.n;
    
    en = 0;
    for iSensor = 1:Model.n
        if Sensors(iSensor).e > 0
            en = en + (Sensors(iSensor).e - roundEnergyAvg(r+1))^2;
        end
    end
    
    enheraf(r+1) = en / alive;
    
    title(sprintf('Round=%d, Dead nodes=%d', r + 1, nDeads)) 
    
   % Check dead condition
   if (Model.n == nDeads) 
       lastPeriod = r;  
       break;
   end
  
end

disp('End of Simulation');
toc;
disp('Create Report...');

filename = sprintf('leach%d.mat', Model.n);

%% Save Report
save(filename);
