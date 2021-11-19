-module(kepler).
-export([createAtoms/3, handleKaplerWorld/0, createWorld/2]).

createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) when not is_number(HydrogenInterval) and is_number(OxygenInterval) -> {error, not_a_number};
createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) ->
  spawn(hidrogenio, keepCreating, [HydrogenInterval, HandlerPid]),
  spawn(oxigenio, keepCreating, [OxygenInterval, HandlerPid]).

handleKaplerWorld() ->
  receive
    {oxygen, OxygenPid} ->
      io:format("Oxigenio energizado ~p~n",[OxygenPid]);
    {hydrogen, HydrogenPid} ->
      io:format("Hidrogenio energizado ~p~n",[HydrogenPid])
  end,
  handleKaplerWorld().

createWorld(HydrogenInterval, OxygenInterval) ->
  HandlerPid = spawn(fun() -> handleKaplerWorld() end),
  AtomsCreatorPid = spawn(fun() -> createAtoms(HydrogenInterval, OxygenInterval, HandlerPid) end).