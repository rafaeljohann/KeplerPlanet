-module(kepler).
-export([createAtoms/3, createWorld/2, createWaterParticle/4]).

createAtoms(HydrogenInterval, OxygenInterval, WaterPid) when not is_number(HydrogenInterval) and is_number(OxygenInterval) -> {error, not_a_number};
createAtoms(HydrogenInterval, OxygenInterval, WaterPid) ->
  spawn(hidrogenio, keepCreating, [HydrogenInterval, WaterPid]),
  spawn(oxigenio, keepCreating, [OxygenInterval, WaterPid]).

createWaterParticle(OxygenCount, HydrogenCount, ListOxygen, ListHydrogen) ->
	io:format("Qtd Hidrogênio ~p~n", [HydrogenCount]),
	io:format("Qtd Oxigênio ~p~n", [OxygenCount]),
	receive
		{oxygen, OxygenPid} ->
			io:format("Oxigênio ~p energizado!~n", [OxygenPid]),
			CountOneOxygen = 1,
			CountOneHydrogen = 0,
			ListTotalOxygen = [OxygenPid | ListOxygen],
			ListTotalHydrogen = ListHydrogen;
		{hydrogen, HydrogenPid} ->
			io:format("Hidrogênio ~p energizado!~n", [HydrogenPid]),
			CountOneHydrogen = 1,
			CountOneOxygen = 0,
			ListTotalHydrogen = [HydrogenPid | ListHydrogen],
			ListTotalOxygen = ListOxygen
	end,
	
	if
		(OxygenCount + CountOneOxygen) > 1,
		(HydrogenCount + CountOneHydrogen) > 0 -> 
		ListSizeHydrogen = length(ListTotalHydrogen),
		HydrogenElement = lists:nth(ListSizeHydrogen, ListTotalHydrogen),
		io:format("Criei partícula de água formado pelas partículas de oxigênio ~p, ~p e hidrogênio ~p!~n", [lists:nth(1, ListTotalOxygen), lists:nth(2, ListTotalOxygen), HydrogenElement]),
		
		if
			ListSizeHydrogen == 1 -> NewListHydrogen = [];
			true -> NewListHydrogen = ListTotalHydrogen -- [HydrogenElement]
		end,
		
		createWaterParticle(OxygenCount - 1, HydrogenCount - 1, [], NewListHydrogen);
		CountOneHydrogen =:= 1,
		  CountOneOxygen =:= 0 -> createWaterParticle(OxygenCount, HydrogenCount + 1, ListTotalOxygen, ListTotalHydrogen);
		CountOneHydrogen =:= 0,
		  CountOneOxygen =:= 1 -> createWaterParticle(OxygenCount + 1, HydrogenCount, ListTotalOxygen, ListTotalHydrogen);
		true -> createWaterParticle(OxygenCount, HydrogenCount, ListTotalOxygen, ListTotalHydrogen)
	end.

createWorld(HydrogenInterval, OxygenInterval) ->
  ListOxygen = [],
  ListHydrogen = [],
  WaterPid = spawn(kepler, createWaterParticle, [0, 0, ListOxygen, ListHydrogen]),
  AtomsCreatorPid = spawn(fun() -> createAtoms(HydrogenInterval, OxygenInterval, WaterPid) end).