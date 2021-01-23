function Sensors = distanceToSink(Sensors, Model)
    n = Model.n;
    for iSensor = 1:n
        distance = sqrt((Sensors(iSensor).xd - Sensors(n + 1).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(n + 1).yd) ^ 2);
        Sensors(iSensor).distanceToSink = distance;
    end
end