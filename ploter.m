function nDeads = ploter(Sensors, Model, Area)

    nDeads = 0;
    n = Model.n;
    for iSensor = 1:n
        % Check dead node
        if (Sensors(iSensor).e > 0)
%             if(Sensors(iSensor).type == 'N')      
%                 plot(Sensors(iSensor).xd, Sensors(iSensor).yd, 'o', 'color', Model.colors(iSensor));     
%             else % Sensors.type=='C'       
%                 plot(Sensors(iSensor).xd, Sensors(iSensor).yd, 'kx', 'MarkerSize', 10);
%             end
        else
            nDeads = nDeads + 1;
%             plot(Sensors(iSensor).xd, Sensors(iSensor).yd, 'red .');
        end
        
%         hold on;
        
    end 
    
%     plot(Sensors(n + 1).xd, Sensors(n + 1).yd, 'g*', 'MarkerSize', 15); 
    
%     xlim([0 Area.x]);
%     ylim([0 Area.y]);
%     grid on;
%     axis square;
%     legend('Location','NorthEastOutside');
end