function senders = findSender(Sensors, Model, receiver)
    
    senders = [];
    n = Model.n; 
    for iSensor = 1:n
        if (Sensors(iSensor).MCH == receiver && Sensors(iSensor).id ~= receiver)
            senders = [senders, Sensors(iSensor).id];
        end
    end
    
end