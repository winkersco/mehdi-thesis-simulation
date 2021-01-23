function [Area,Model]=setParameters()

%% Set Initial PARAMETERS

%%%%% Number of nodes in the field %%%%%
n = 100;

%%%%% Field dimensions (in meters) %%%%%
Area.x = 100; 
Area.y = 100;

%%%%% Sink motion pattern %%%%%
xSink = 0.5 * Area.x;
ySink = 0.5 * Area.y;

%%%%% Optimal selection probability of a node to become cluster head %%%%%
p = 0.1;

%%%%% energy model (all values in joules) %%%%% 

% Initial energy
E0 = 0.5; 

% EELEC = ETX = ERX
ETX = 50 * 0.000000001;
ERX = 50 * 0.000000001;

% Transmit amplifier types
EFS = 10 * 0.000000000001;
EMP = 0.0013 * 0.000000000001;

% Data Aggregation energy
EDA = 5 * 0.000000001;

% Computation of do
d0 = sqrt(EFS / EMP);

%%%%% Run Time Parameters %%%%%

% Maximum number of rounds
nRounds = 50;

% Data packet size
dataPacketLength = 4000;

% Hello packet size
helloPacketLength = 100;

% Number of packets sended in steady-state phase
nPackets = 10;

% Redio range
RR = 0.5 * Area.x * sqrt(2);

%% Save in model
Model.n = n;
Model.xSink = xSink;
Model.ySink = ySink;
Model.p = p;
Model.E0 = E0;
Model.ETX = ETX;
Model.ERX = ERX;
Model.EFS = EFS;
Model.EMP = EMP;
Model.EDA = EDA;
Model.d0 = d0;
Model.nRounds = nRounds;
Model.dataPacketLength = dataPacketLength;
Model.helloPacketLength = helloPacketLength;
Model.nPackets = nPackets;
Model.RR = RR;

end