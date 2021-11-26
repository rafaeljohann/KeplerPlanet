-module(kepler).
-export([createAtoms/3, handleKaplerWorld/2, createWorld/2, createWater/3]).

createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) when not is_number(HydrogenInterval) and is_number(OxygenInterval) -> {error, not_a_number};
createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) ->
  spawn(hidrogenio, keepCreating, [HydrogenInterval, HandlerPid]),
  spawn(oxigenio, keepCreating, [OxygenInterval, HandlerPid]).

createWater(OxygenAtom, HydrogenAtomOne, HydrogenAtomTwo) ->
  io:format("Criando água com os atomos: 2 Hidrogenios(~p~p) e 1 Oxigenio(~p)~n", [ HydrogenAtomOne, HydrogenAtomTwo, OxygenAtom]).

handleKaplerWorld(OldOxygenList, OldHydrogenList) ->
  receive
    {oxygen, OxygenPid} ->
      io:format("Oxigenio energizado ~p~n",[OxygenPid]),
      OxygenList = lists:append([OldOxygenList, [OxygenPid]]),
      HydrogenList = OldHydrogenList;
    {hydrogen, HydrogenPid} ->
      io:format("Hidrogenio energizado ~p~n",[HydrogenPid]),
      HydrogenList = lists:append([OldHydrogenList, [HydrogenPid]]),
      OxygenList = OldOxygenList
  end,

  OxygenQuantity = length(OxygenList),
  HydrogenQuantity = length(HydrogenList),

  io:format("Quantidade de Hidrogenio ~p~n",[HydrogenQuantity]),
  io:format("Quantidade de Oxigenio ~p~n",[OxygenQuantity]),

  if 
    OxygenQuantity > 0 andalso HydrogenQuantity > 1 ->
      OxygenAtom = lists:nth(1, OxygenList),
      HydrogenAtomOne = lists:nth(1, HydrogenList),
      HydrogenAtomTwo = lists:nth(2, HydrogenList),
      NewOxygenList = lists:delete(OxygenAtom, OxygenList),
      RemoveHydrogenList = lists:delete(HydrogenAtomOne, HydrogenList),
      NewHydrogenList = lists:delete(HydrogenAtomTwo, RemoveHydrogenList),
      spawn(fun() -> createWater(OxygenAtom, HydrogenAtomOne, HydrogenAtomTwo) end);
    true -> 
      io:format("Não conseguiu criar água~n", []),
      NewOxygenList = OxygenList,
      NewHydrogenList = HydrogenList
  end,
  handleKaplerWorld(NewOxygenList, NewHydrogenList).

createWorld(HydrogenInterval, OxygenInterval) ->
  OxygenList = [],
  HydrogenList = [],
  HandlerPid = spawn(fun() -> handleKaplerWorld(OxygenList, HydrogenList) end),
  AtomsCreatorPid = spawn(fun() -> createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) end).