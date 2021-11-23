-module(kepler).
-export([createAtoms/4, createWorld/2, verifyHidrogenio/0, verifyOxygen/1]).

createAtoms(HydrogenInterval, OxygenInterval, HidrogenioPid, OxygenPid) when not is_number(HydrogenInterval) and is_number(OxygenInterval) -> {error, not_a_number};
createAtoms(HydrogenInterval, OxygenInterval, HidrogenioPid, OxygenPid) ->
  spawn(hidrogenio, keepCreating, [HydrogenInterval, HidrogenioPid]),
  spawn(oxigenio, keepCreating, [OxygenInterval, OxygenPid]).

verifyHidrogenio() ->
	receive
		{hydrogen, HydrogenPid} ->
		  %%ListTotalOxigenio = [HydrogenPid | ListOxigenio],
		  io:format("Hidrogenio energizado ~p~n",[HydrogenPid])
	end,
	verifyHidrogenio().
  
verifyOxygen(ListOxigenio) ->
	receive
		{oxygen, OxygenPid} ->
		  io:format("Oxigenio energizado ~p~n",[OxygenPid]),
		  ListTotalOxigenio = [OxygenPid | ListOxigenio],
		  N = length(ListTotalOxigenio),
		  io:fwrite("List size TESTE TESTE TESTE: ~p\n",[N])
	end,
	verifyOxygen(ListTotalOxigenio).

createWorld(HydrogenInterval, OxygenInterval) ->
  ListOxigenio = [],
  HidrogenioPid = spawn(kepler, verifyHidrogenio, []),
  OxygenPid = spawn(kepler, verifyOxygen, [ListOxigenio]),
  AtomsCreatorPid = spawn(fun() -> createAtoms(HydrogenInterval, OxygenInterval, HidrogenioPid, OxygenPid) end).