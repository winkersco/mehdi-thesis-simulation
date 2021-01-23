function Sensors = resetSensors(Sensors, Model)
 
    n = Model.n;
    for iSensor = 1:n
        Sensors(iSensor).MCH = n + 1;
        Sensors(iSensor).type = 'N';
        Sensors(iSensor).distanceToCH = inf;
    end
    
end