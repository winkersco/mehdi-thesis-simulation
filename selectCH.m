function [CHs, Sensors]= selectCH(Sensors, Model, r)

    CHs = [];
    nCHs = 0;
    n = Model.n;
    Routing = Model.Routing;
    
    if(strcmp(Routing.protocol, 'PROPOSED'))
        for iSensor = 1:1:n
            if(Sensors(iSensor).e > 0 && ~any(Model.highPriorities == iSensor))   
                mu = rand; 
                leachT = (Model.p / (1 - Model.p * mod(r, round(1 / Model.p))));
                performance = Routing.c1 * (Sensors(iSensor).e / Model.E0) + Routing.c2 * ((Model.DD - Sensors(iSensor).distanceToSink) / Model.DD);
                threshold = Routing.alpha * leachT + (1 - Routing.alpha) * leachT * performance;    
                if (Sensors(iSensor).G <= 0)            
                    % Selection of CHs
                    if(mu <= threshold)                    
                        nCHs = nCHs + 1; 
                        CHs(nCHs).id = iSensor;               
                        Sensors(iSensor).type = 'C';
                        Sensors(iSensor).G = round(1 / Model.p) - 1;        
                    end    
                end   
            end 
        end 
    elseif(strcmp(Routing.protocol, 'EEM-LEACH'))
        for iSensor = 1:1:n
            if(Sensors(iSensor).e > 0)   
                mu = rand; 
                leachT = (Model.p / (1 - Model.p * mod(r, round(1 / Model.p))));
                eres = Sensors(iSensor).e / Model.E0;
                eavg = (Model.E0 - Sensors(iSensor).e) / Model.E0;
                if eres > eavg
                    performance = (eres - eavg) / eres;
                else
                    performance = 1 - eavg;
                end
                threshold = leachT * performance;    
                if (Sensors(iSensor).G <= 0)            
                    % Selection of CHs
                    if(mu <= threshold)                    
                        nCHs = nCHs + 1; 
                        CHs(nCHs).id = iSensor;               
                        Sensors(iSensor).type = 'C';
                        Sensors(iSensor).G = round(1 / Model.p) - 1;        
                    end    
                end   
            end 
        end 
    else
        for iSensor = 1:1:n
            if(Sensors(iSensor).e > 0)          
                mu = rand;     
                if (Sensors(iSensor).G <= 0)            
                    % Selection of CHs
                    if(mu <= (Model.p / (1 - Model.p * mod(r, round(1 / Model.p)))))                    
                        nCHs = nCHs + 1; 
                        CHs(nCHs).id = iSensor;               
                        Sensors(iSensor).type = 'C';
                        Sensors(iSensor).G = round(1 / Model.p) - 1;        
                    end    
                end   
            end 
        end 
    end
    
end