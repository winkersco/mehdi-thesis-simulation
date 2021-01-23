function Sensors = configureSensors(Model, GX, GY)

n = Model.n;

%% Configuration EmptySensor
emptySensor.xd = 0;
emptySensor.yd = 0;
emptySensor.G = 0;
emptySensor.isDead = 0;
emptySensor.type = 'N';
emptySensor.e = 0; 
emptySensor.id = 0;
emptySensor.distanceToSink = 0;
emptySensor.distanceToCH = 0;
emptySensor.MCH = n + 1; % Member of CH

%% Configuration Sensors
Sensors = repmat(emptySensor, n + 1, 1);

for iSensor = 1:1:n
    % Set x location
    Sensors(iSensor).xd = GX(iSensor); 
    % Set y location
    Sensors(iSensor).yd = GY(iSensor);
    % Determinate whether in previous periods has been CH or not? not=0 and be=n
    Sensors(iSensor).G = 0;
    % dead flag. Whether dead or alive S(i).df=0 alive. S(i).df=1 dead.
    Sensors(iSensor).isDead = 0; 
    % initially there are not each cluster heads 
    Sensors(iSensor).type = 'N';
    % initially all nodes have equal Energy
    Sensors(iSensor).e = Model.E0;
    % id
    Sensors(iSensor).id = iSensor;
    % Sensors(i).RR=Model.RR;
end 

Sensors(n + 1).xd = Model.xSink; 
Sensors(n + 1).yd = Model.ySink;
Sensors(n + 1).e = 100;
Sensors(n + 1).id = n + 1;

end