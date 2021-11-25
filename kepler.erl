-module(kepler).
-export([createAtoms/3, createWorld/2, createWaterParticle/4]).

createAtoms(HydrogenInterval, OxygenInterval, WaterPid) when not is_number(HydrogenInterval) and is_number(OxygenInterval) -> {error, not_a_number};
createAtoms(HydrogenInterval, OxygenInterval, WaterPid) ->
  spawn(hidrogenio, keepCreating, [HydrogenInterval, WaterPid]),
  spawn(oxigenio, keepCreating, [OxygenInterval, WaterPid]).

createWaterParticle(OxigenioCount, HidrogenioCount, ListOxigenio, ListHidrogenio) ->
	io:format("---ENTROU NO MÉTODO DE CRIAR PARTÍCULA---~n", []),
	io:format("Qtd Hidrogênio ~p~n", [HidrogenioCount]),
	io:format("Qtd Oxigênio ~p~n", [OxigenioCount]),
	receive
		{oxygen, OxygenPid} ->
			io:format("Oxigênio energizado!~n", []),
			CountOxigenio = 1,
			CountHidrogenio = 0,
			ListTotalOxigenio = [OxygenPid | ListOxigenio],
			ListTotalHidrogenio = ListHidrogenio,
			N = length(ListOxigenio),
			io:format("Tamanho lista oxigênio ~p~n", [N]);
		{hydrogen, HydrogenPid} ->
			io:format("Hidrogênio energizado!~n", []),
			CountHidrogenio = 1,
			CountOxigenio = 0,
			ListTotalHidrogenio = [HydrogenPid | ListHidrogenio],
			ListTotalOxigenio = ListOxigenio,
			N = length(ListHidrogenio),
			io:format("Tamanho lista hidrogenio ~p~n", [N])
	end,
	
	if
		(OxigenioCount + CountOxigenio) > 1,
		(HidrogenioCount + CountHidrogenio) > 0 -> io:format("Criei partícula de água formado pelas partículas de oxigênio ~p, ~p e hidrogênio ~p!~n", [lists:nth(1, ListTotalOxigenio), lists:nth(2, ListTotalOxigenio), lists:nth(1, ListTotalHidrogenio)]),
		%%ElementOxygenRemove = lists:nth(1, ListTotalOxigenio),
		%%ListTotalOxigenio = lists:delete(ElementOxygenRemove, ListTotalOxigenio),
		%%ListTotalOxigenio = ListTotalOxigenio -- lists:nth(1, ListTotalOxigenio),
		%%ListTotalHidrogenio = ListTotalOxigenio -- lists:nth(1, ListTotalHidrogenio),
		createWaterParticle(OxigenioCount - 1, HidrogenioCount - 1, ListTotalOxigenio, ListTotalHidrogenio);
		CountHidrogenio =:= 1,
		  CountOxigenio =:= 0 -> createWaterParticle(OxigenioCount, HidrogenioCount + 1, ListTotalOxigenio, ListTotalHidrogenio);
		CountHidrogenio =:= 0,
		  CountOxigenio =:= 1 -> createWaterParticle(OxigenioCount + 1, HidrogenioCount, ListTotalOxigenio, ListTotalHidrogenio);
		true -> createWaterParticle(OxigenioCount, HidrogenioCount, ListTotalOxigenio, ListTotalHidrogenio)
	end.

createWorld(HydrogenInterval, OxygenInterval) ->
  ListOxigenio = [],
  ListHidrogenio = [],
  WaterPid = spawn(kepler, createWaterParticle, [0, 0, ListOxigenio, ListHidrogenio]),
  %%HidrogenioPid = spawn(kepler, verifyHidrogenio, [WaterPid]),
  %%OxygenPid = spawn(kepler, verifyOxygen, [WaterPid, ListOxigenio]),
  AtomsCreatorPid = spawn(fun() -> createAtoms(HydrogenInterval, OxygenInterval, WaterPid) end).