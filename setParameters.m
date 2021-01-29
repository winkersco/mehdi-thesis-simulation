function [Area,Model]=setParameters()

%% Set Initial PARAMETERS

%%%%% Number of nodes in the field %%%%%
n = 14;

%%%%% Field dimensions (in meters) %%%%%
Area.x = 1; 
Area.y = 2;

%%%%% Sink motion pattern %%%%%
xSink = 0.5 * Area.x;
ySink = 0.5 * Area.y;

%%%%% Optimal selection probability of a node to become cluster head %%%%%
p = 0.1;

%%%%% energy model (all values in joules) %%%%% 

% Initial energy
E0 = 0.05; 

% EELEC
EELEC = 50 * 0.000000001;

% Transmit amplifier types
EMP = 1.97 * 0.000000001;

%%%%% Routing parameters %%%%%

% Routing protocol (PROPOSED, LEACH, M-LEACH)
Routing.protocol = 'PROPOSED';

% Proposed protocol parameters
Routing.alpha = 0.5; % 0 < alpha < 1
Routing.c1 = 0.5; % c1 + c2 = 1
Routing.c2 = 0.5; % c1 + c2 = 1

Routing.u = 0.5; % u + w = 1
Routing.w = 0.5; % u + w = 1

Routing.landa = 1 / 300; % Simulated landa

%%%%% Run Time Parameters %%%%%

% Maximum number of rounds
nRounds = 6;

% Data packet size
dataPacketLength = 4000;

% Hello packet size
helloPacketLength = 100;

% Number of packets sended in steady-state phase
nPackets = 10;

% Redio range
RR = 0.5 * Area.x * sqrt(2);

% Diameter distance
DD = sqrt(Area.x ^ 2 + Area.y ^ 2);

% Sensors color in ploter
colors = ["#58e460","#9f5b55","#3314a9","#f896d1","#b9a230","#516d76","#7584ed","#543164","#068ef4","#950de3","#1cddb7","#d3e606","#da1b32","#f09f7e"];

% Sensors with High priority
highPriorities = [1];

%% Save in model
Model.n = n;
Model.xSink = xSink;
Model.ySink = ySink;
Model.p = p;
Model.E0 = E0;
Model.EELEC = EELEC;
Model.EMP = EMP;
Model.Routing = Routing;
Model.nRounds = nRounds;
Model.dataPacketLength = dataPacketLength;
Model.helloPacketLength = helloPacketLength;
Model.nPackets = nPackets;
Model.RR = RR;
Model.DD = DD;
Model.colors = colors;
Model.highPriorities = highPriorities;

end