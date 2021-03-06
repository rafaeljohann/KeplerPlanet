-module(oxigenio).
-export([keepCreating/2, createOxygen/1, sendEnergizedAtom/2]).

sendEnergizedAtom(HandlerPid, OxygenPid) ->
  HandlerPid ! {oxygen, OxygenPid}.

createOxygen(HandlerPid) ->
  OxygenPid = self(),
  RandomTime = (rand:uniform(21) + 9) * 1000,
  io:format("RandomTime ~p para o oxigênio ~p.~n", [RandomTime/1000, OxygenPid]),
  io:format("Criando Oxigênio ~p~n",[OxygenPid]),
  
  timer:apply_after(RandomTime, oxigenio, sendEnergizedAtom, [HandlerPid, OxygenPid]).

keepCreating(Interval, HandlerPid) when not is_number(Interval) -> {error, not_a_number};
keepCreating(Interval, HandlerPid) ->
  IntervalInMilleseconds = Interval * 1000,
  timer:sleep(IntervalInMilleseconds),
  Pid = spawn(fun() -> createOxygen(HandlerPid) end),
  keepCreating(Interval, HandlerPid).