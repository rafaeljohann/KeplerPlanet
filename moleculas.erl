-module(moleculas).
-export([keepCreating/2, createHydrogen/1, sendEnergizeHydrogendAtom/2, sendEnergizedOxygenAtom/2, createOxygen/1]).

sendEnergizeHydrogendAtom(HandlerPid, HydrogenPid) ->
  HandlerPid ! {hydrogen, HydrogenPid}.

sendEnergizedOxygenAtom(HandlerPid, OxygenPid) ->
  HandlerPid ! {oxygen, OxygenPid}.

createHydrogen(HandlerPid) ->
  HydrogenPid = self(),
  RandomTime = (rand:uniform(21) + 9) * 1000,

  io:format("RandomTime ~p para o Hidrogenio ~p.~n", [RandomTime/1000, HydrogenPid]),
  io:format("Criando Hidrogenio ~p~n",[HydrogenPid]),

  timer:apply_after(RandomTime, moleculas, sendEnergizeHydrogendAtom, [HandlerPid, HydrogenPid]).

createOxygen(HandlerPid) ->
  OxygenPid = self(),
  RandomTime = (rand:uniform(21) + 9) * 1000,

  io:format("RandomTime ~p para o Oxigenio ~p.~n", [RandomTime/1000, OxygenPid]),
  io:format("Criando Oxigenio ~p~n",[OxygenPid]),

  timer:apply_after(RandomTime, moleculas, sendEnergizedOxygenAtom, [HandlerPid, OxygenPid]).

keepCreating(Interval, HandlerPid) when not is_number(Interval) -> {error, not_a_number};
keepCreating(Interval, HandlerPid) ->
  IntervalInMilleseconds = Interval * 1000,
  timer:sleep(IntervalInMilleseconds),
  RandomNumber = rand:uniform(10),
  io:format("Valor randomico para decidir qual criar: ~p~n",[RandomNumber]),
  if
    RandomNumber < 6 ->
      spawn(fun() -> createHydrogen(HandlerPid) end);
    RandomNumber > 5 ->
      spawn(fun() -> createOxygen(HandlerPid) end)
  end,
  keepCreating(Interval, HandlerPid).