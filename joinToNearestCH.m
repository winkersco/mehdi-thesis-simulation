function Sensors = joinToNearestCH(Sensors, Model, CHs)

n = Model.n;
m = length(CHs);
if(m > 1)
    distances = zeros(m, n);  
    for iSensor = 1:n     
        for jSensor = 1:m
            distances(jSensor, iSensor) = sqrt((Sensors(iSensor).xd - Sensors(CHs(jSensor).id).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(CHs(jSensor).id).yd) ^ 2);        
        end   
    end 
    
    [minDistance, index] = min(distances);
    
    for iSensor = 1:n       
        if (Sensors(iSensor).e > 0)
            % If node is in RR CH and is nearer to CH rather than sink
            if (minDistance(iSensor) <= Model.RR && minDistance(iSensor) < Sensors(iSensor).distanceToSink)
                Sensors(iSensor).MCH = CHs(index(iSensor)).id;
                Sensors(iSensor).distanceToCH = minDistance(iSensor);
            else
                Sensors(iSensor).MCH = n + 1;
                Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
            end
        end
    end
end

end

