function Sensors = exchangePackets(Sensors, Model, sender, PacketType, receiver)

   global srp rrp sdp rdp;
   sap = 0; % Send a packet
   rap = 0; % Receive a packet
   if (strcmp(PacketType, 'Hello'))
       packetSize = Model.helloPacketLength;
   else
       packetSize = Model.dataPacketLength;
   end
   
   % Energy dissipated from sensors to send a packet 
   for iSensor = 1:length(sender)
       for jSensor = 1:length(receiver)
           distance = sqrt((Sensors(sender(iSensor)).xd - Sensors(receiver(jSensor)).xd) ^ 2 + (Sensors(sender(iSensor)).yd - Sensors(receiver(jSensor)).yd) ^ 2);
           if (distance > Model.d0)
               Sensors(sender(iSensor)).e = Sensors(sender(iSensor)).e - (Model.ETX * packetSize + Model.EMP * packetSize * (distance ^ 4));
               % Sent a packet
               if(Sensors(sender(iSensor)).e > 0)
                   sap = sap + 1;                 
               end
           else
               Sensors(sender(iSensor)).e = Sensors(sender(iSensor)).e - (Model.ETX * packetSize + Model.EFS * packetSize * (distance ^ 2));
               % Sent a packet
               if(Sensors(sender(iSensor)).e > 0)
                   sap = sap + 1;                 
               end
           end
       end
   end
   
   % Energy dissipated from sensors for receive a packet
   for jSensor = 1:length(receiver)
       Sensors(receiver(jSensor)).e = Sensors(receiver(jSensor)).e - ((Model.ERX + Model.EDA) * packetSize);
   end
   
   for iSensor=1:length(sender)
       for jSensor=1:length(receiver)
           % Received a packet
           if(Sensors(sender(iSensor)).e > 0 && Sensors(receiver(jSensor)).e > 0)
               rap = rap + 1;
           end
       end 
   end
   
   if (strcmp(PacketType, 'Hello'))
       srp = srp + sap;
       rrp = rrp + rap;
   else       
       sdp = sdp + sap;
       rdp = rdp + rap;
   end
   
end

%     else %To Cluster Head
%         
%         for iSensor=1:length( sender)
%        
%            distance=sqrt((Sensors(sender(iSensor)).xd-Sensors(sender(iSensor).MCH).xd)^2 + ...
%                (Sensors(sender(iSensor)).yd-Sensors(sender(iSensor).MCH).yd)^2 );   
%        
%            send a packet
%            sap=sap+1;
%            
%            Energy dissipated from Normal sensor
%            if (distance>Model.do)
%            
%                 Sensors(sender(iSensor)).E=Sensors(sender(iSensor)).E- ...
%                     (Model.ETX*packetSize + Model.Emp*packetSize*(distance^4));
% 
%                 if(Sensors(sender(iSensor)).E>0)
%                     rap=rap+1;                 
%                 end
%             
%            else
%                 Sensors(sender(iSensor)).E=Sensors(sender(iSensor)).E- ...
%                     (Model.ETX*packetSize + Model.Emp*packetSize*(distance^2));
% 
%                 if(Sensors(sender(iSensor)).E>0)
%                     rap=rap+1;                 
%                 end
%             
%            end 
%        end
  