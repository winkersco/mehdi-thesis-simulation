function [packetSize] = getPacketSize(Model, packetType, sensorId)

   if (strcmp(packetType, 'Hello'))
       packetSize = Model.helloPacketLength;
   else
       if(strcmp(Model.Routing.protocol, 'PROPOSED'))
           switch Model.dataRates(sensorId) 
               case 1
                   packetSize = 1000 + randi(300 +1)-1;
               case 2
                   packetSize = 2100 + randi(300 +1)-1;
               case 3
                   packetSize = 3200 + randi(300 +1)-1;
               otherwise
                   packetSize = 0;
                   disp('error');
           end
       elseif (strcmp(Model.Routing.protocol, 'EEM-LEACH'))
           switch Model.dataRates(sensorId) 
               case 1
                   packetSize = 1000 + randi(500 +1)-1;
               case 2
                   packetSize = 2100 + randi(500 +1)-1;
               case 3
                   packetSize = 3200 + randi(500 +1)-1;
               otherwise
                   packetSize = 0;
                   disp('error');
           end
       else
           switch Model.dataRates(sensorId) 
               case 1
                   packetSize = 1000 + randi(800 +1)-1;
               case 2
                   packetSize = 2100 + randi(800 +1)-1;
               case 3
                   packetSize = 3200 + randi(800 +1)-1;
               otherwise
                   packetSize = 0;
                   disp('error');
           end
       end
   end
   
end

