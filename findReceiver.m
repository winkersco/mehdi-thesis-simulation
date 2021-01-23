function receivers = findReceiver(Sensors, Model, sender, senderRR)
 
    receivers = [];
    %% Calculate distance all sensors with sender 
    n = Model.n;
    distances = zeros(1,n);
    
    for iSensor = 1:n 
        distances(iSensor) = sqrt((Sensors(iSensor).xd - Sensors(sender).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(sender).yd) ^ 2);            
    end 
    
    %% 
    for iSensor = 1:n
        if (distances(iSensor) <= senderRR && sender ~= Sensors(iSensor).id)
            receivers = [receivers, Sensors(iSensor).id];
        end              
    end 
    
end
