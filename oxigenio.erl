-module(oxigenio).
-export([start/1, criaMoleculaOxigenio/2, verificarCriouOxigenio/0]).

start(Num) when not is_number(Num)-> {error,not_a_number};
start(Num)->spawn(fun()->criaMoleculaOxigenio(1, Num) end).

criaMoleculaOxigenio(Contador, Maximo)->
    
	erlang:start_timer(1000, self(), []),
    receive
          {timeout, Tref, _} ->
            erlang:cancel_timer(Tref),
		
			io:format("Contador: ~p~n", [Contador]),
			io:format("Maximo: ~p~n", [Maximo]),
			
			if
				Contador >= 10 -> CriouOxigenio = verificarCriouOxigenio();
				Contador == 30 -> CriouOxigenio = 1;
				true -> CriouOxigenio = 0
			end,
			
			io:format("CRIOU~p~n", [CriouOxigenio]),
			
            if
                (Contador =:=Maximo) or (CriouOxigenio =:= 5) -> io:format("Criei molécula de oxigênio!~n");
                true -> criaMoleculaOxigenio(Contador+1, Maximo)
            end
    end.
	
verificarCriouOxigenio() ->
	rand:uniform(5).