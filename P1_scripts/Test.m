busInfo = Simulink.Bus.createObject('SenseHatTest1', 'To File');
num_el = eval([busInfo.busName '.getNumLeafBusElements']);
elemList = eval([busInfo.busName '.getLeafBusElements']);

load data.mat % generated in the second step
for i = 1:num_el
    size = elemList(i).Dimensions;
    ts{i} = timeseries(data(i+1:i+size,:)',data(1,:)'); 
end

MYBUS = Simulink.SimulationData.createStructOfTimeseries(busInfo.busName,ts);
