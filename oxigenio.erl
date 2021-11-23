-module(oxigenio).
-export([keepCreating/2, createOxygen/1, sendEnergizedAtom/2]).

sendEnergizedAtom(HandlerPid, OxygenPid) ->
  HandlerPid ! {oxygen, OxygenPid}.
  %%ListTotalOxigenio = [OxygenPid|ListOxigenio],
  %%N = length(ListTotalOxigenio),
  
  %%io:fwrite("List size 22222: ~p\n",[N]).

createOxygen(HandlerPid) ->
  OxygenPid = self(),
  RandomTime = (rand:uniform(21) + 9) * 1000,
  io:format("RandomTime ~p para o oxigenio ~p.~n", [RandomTime/1000, OxygenPid]),
  io:format("Criando Oxigenio ~p~n",[OxygenPid]),
  


  timer:apply_after(RandomTime, oxigenio, sendEnergizedAtom, [HandlerPid, OxygenPid]).

keepCreating(Interval, HandlerPid) when not is_number(Interval) -> {error, not_a_number};
keepCreating(Interval, HandlerPid) ->
  IntervalInMilleseconds = Interval * 1000,
  timer:sleep(IntervalInMilleseconds),
  %%ListOxigenio = [],
  Pid = spawn(fun() -> createOxygen(HandlerPid) end),
  keepCreating(Interval, HandlerPid).