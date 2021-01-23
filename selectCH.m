function [CHs, Sensors]= selectCH(Sensors, Model, r)

    CHs = [];
    nCHs = 0;
    n = Model.n;
    
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