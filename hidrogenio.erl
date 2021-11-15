-module(hidrogenio).
-export([start/1, criaMoleculaHidrogenio/2, verificarCriouHidrogenio/0]).

start(Num) when not is_number(Num)-> {error,not_a_number};
start(Num)->spawn(fun()->criaMoleculaHidrogenio(1, Num) end).

criaMoleculaHidrogenio(Contador, Maximo)->
    
	erlang:start_timer(1000, self(), []),
    receive
          {timeout, Tref, _} ->
            erlang:cancel_timer(Tref),
		
			io:format("Contador: ~p~n", [Contador]),
			io:format("Maximo: ~p~n", [Maximo]),
			
			if
				Contador >= 10 -> CriouHidrogenio = verificarCriouHidrogenio();
				Contador == 30 -> CriouHidrogenio = 5;
				true -> CriouHidrogenio = 0
			end,
			
			io:format("CRIOU~p~n", [CriouHidrogenio]),
			
            if
                (Contador =:=Maximo) or (CriouHidrogenio =:= 5) -> io:format("Criei molécula de hidrogênio!~n");
                true -> criaMoleculaHidrogenio(Contador+1, Maximo)
            end
    end.
	
verificarCriouHidrogenio() ->
	rand:uniform(5).