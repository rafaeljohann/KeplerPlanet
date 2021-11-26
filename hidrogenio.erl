-module(hidrogenio).
-export([keepCreating/2, createHydrogen/1, sendEnergizedAtom/2]).

sendEnergizedAtom(HandlerPid, HydrogenPid) ->
  HandlerPid ! {hydrogen, HydrogenPid}.

createHydrogen(HandlerPid) ->
  HydrogenPid = self(),
  RandomTime = (rand:uniform(21) + 9) * 1000,

  io:format("RandomTime ~p para o Hidrogenio ~p.~n", [RandomTime/1000, HydrogenPid]),
  io:format("Criando Hidrogenio ~p~n",[HydrogenPid]),

  timer:apply_after(RandomTime, hidrogenio, sendEnergizedAtom, [HandlerPid, HydrogenPid]).

keepCreating(Interval, HandlerPid) when not is_number(Interval) -> {error, not_a_number};
keepCreating(Interval, HandlerPid) ->
  IntervalInMilleseconds = Interval * 1000,
  timer:sleep(IntervalInMilleseconds),
  spawn(fun() -> createHydrogen(HandlerPid) end),
  keepCreating(Interval, HandlerPid).