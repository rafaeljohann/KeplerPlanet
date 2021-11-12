-module(main).
-export([main/0]).

main()->
    spawn(oxigenio, oxigenio, []).