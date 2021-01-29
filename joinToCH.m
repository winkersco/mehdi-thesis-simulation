function Sensors = joinToCH(Sensors, Model, CHs)

n = Model.n;
m = length(CHs);
if(m > 1)
    Routing = Model.Routing;
    if(strcmp(Routing.protocol, 'PROPOSED'))
        for iCH = 1:m    
            for jSensor = 1:n
                idCH = CHs(iCH).id;
                distancesToCH(iCH, jSensor) = sqrt((Sensors(jSensor).xd - Sensors(idCH).xd) ^ 2 + (Sensors(jSensor).yd - Sensors(idCH).yd) ^ 2);        
                distances(iCH, jSensor) = distancesToCH(iCH, jSensor) + Sensors(idCH).distanceToSink;
                energies(iCH, jSensor) = Sensors(idCH).e;
            end
        end
        
        minDistancesToCH = min(distancesToCH);
        maxDistances = max(distances);
        maxEnergies = max(energies);
        
        for iSensor = 1:n       
            if (Sensors(iSensor).e > 0)
                % If node is in RR CH and is nearer to CH rather than sink
                if (minDistancesToCH(iSensor) <= Model.RR && minDistancesToCH(iSensor) < Sensors(iSensor).distanceToSink)
                    dmax = maxDistances(iSensor);
                    emax = maxEnergies(iSensor);
                    for iCH = 1:m
                        idCH = CHs(iCH).id;
                        eFactor = (emax - Sensors(idCH).e) / emax;
                        dFactor = distances(iCH, iSensor) / dmax;
                        chsel(iCH) = Routing.u * eFactor + Routing.w * dFactor;
                    end
                    [~, indexMinChsel] = min(chsel);
                    if Sensors(iSensor).type == 'C'
                        Sensors(iSensor).MCH = Model.n + 1;
                        Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                    else
                        Sensors(iSensor).MCH = CHs(indexMinChsel).id;
                        Sensors(iSensor).distanceToCH = distancesToCH(indexMinChsel, iSensor);
                    end
                else
                    Sensors(iSensor).MCH = n + 1;
                    Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                end
            end
        end
    elseif(strcmp(Routing.protocol, 'EEM-LEACH'))
        distances = zeros(m, n);  
        for iSensor = 1:n     
            for jSensor = 1:m
                distances(jSensor, iSensor) = sqrt((Sensors(iSensor).xd - Sensors(CHs(jSensor).id).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(CHs(jSensor).id).yd) ^ 2);        
            end
        end 

        distances(distances==0) = nan;
        [minDistance, index] = min(distances,[],'omitnan');

        cycleFlag = 1;
        for iSensor = 1:n       
            if (Sensors(iSensor).e > 0)
                % If node is in RR CH and is nearer to CH rather than sink
                if (minDistance(iSensor) <= Model.RR && minDistance(iSensor) < Sensors(iSensor).distanceToSink)
                    Sensors(iSensor).MCH = CHs(index(iSensor)).id;
                    Sensors(iSensor).distanceToCH = minDistance(iSensor);
                else
                    if Sensors(iSensor).type == 'C'
                        cycleFlag = 0;
                    end
                    Sensors(iSensor).MCH = n + 1;
                    Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                end
            end
        end
        
        if cycleFlag == 1
            minDistanceToSinkIndex = CHs(1).id;
            for iCH = 1:length(CHs)
                idCH = CHs(iCH).id;
                if Sensors(idCH).distanceToSink < Sensors(minDistanceToSinkIndex).distanceToSink
                    minDistanceToSinkIndex = idCH;
                end
            end
            Sensors(minDistanceToSinkIndex).MCH = n + 1;
            Sensors(minDistanceToSinkIndex).distanceToCH = Sensors(minDistanceToSinkIndex).distanceToSink;
        end
    elseif(strcmp(Routing.protocol, 'LEACH-IMPROVE'))
        distances = zeros(m, n);  
        for iSensor = 1:n     
            for jSensor = 1:m
                distances(jSensor, iSensor) = sqrt((Sensors(iSensor).xd - Sensors(CHs(jSensor).id).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(CHs(jSensor).id).yd) ^ 2);        
            end
        end 

        distances(distances==0) = nan;
        [minDistance, index] = min(distances,[],'omitnan');

        for iSensor = 1:n       
            if (Sensors(iSensor).e > 0)
                % If node is in RR CH and is nearer to CH rather than sink
                if (minDistance(iSensor) <= Model.RR && minDistance(iSensor) < Sensors(iSensor).distanceToSink)
                    if Sensors(iSensor).type == 'C'
                        Sensors(iSensor).MCH = Model.n + 1;
                        Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                    else
                        Sensors(iSensor).MCH = CHs(index(iSensor)).id;
                        Sensors(iSensor).distanceToCH = minDistance(iSensor);
                    end
                else
                    Sensors(iSensor).MCH = n + 1;
                    Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                end
            end
        end
    else
        distances = zeros(m, n);  
        for iSensor = 1:n     
            for jSensor = 1:m
                distances(jSensor, iSensor) = sqrt((Sensors(iSensor).xd - Sensors(CHs(jSensor).id).xd) ^ 2 + (Sensors(iSensor).yd - Sensors(CHs(jSensor).id).yd) ^ 2);        
            end
        end 

        distances(distances==0) = nan;
        [minDistance, index] = min(distances,[],'omitnan');

        for iSensor = 1:n       
            if (Sensors(iSensor).e > 0)
                % If node is in RR CH and is nearer to CH rather than sink
                if (minDistance(iSensor) <= Model.RR)
                    if Sensors(iSensor).type == 'C'
                        Sensors(iSensor).MCH = Model.n + 1;
                        Sensors(iSensor).distanceToCH = Sensors(iSensor).distanceToSink;
                    else
                        Sensors(iSensor).MCH = CHs(index(iSensor)).id;
                        Sensors(iSensor).distanceToCH = minDistance(iSensor);
                    end
                end
            end
        end
    end
       
end

end

