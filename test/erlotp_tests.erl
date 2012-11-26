-module(erlotp_tests).
-include_lib("eunit/include/eunit.hrl").

erlotp_test_() ->
    {setup,
     fun() ->
	     erlotp_app:start()
     end,
     fun(_Pid) ->
	     ok
     end,
     [
      {"HTOP", ?_test(t_test_htop())}
     ]
    }.

t_test_htop() ->
    ?assertEqual(765705, erlotp:get_hotp(<<"MFRGGZDFMZTWQ2LK">>, 1)),
    ?assertEqual(816065, erlotp:get_hotp(<<"MFRGGZDFMZTWQ2LK">>, 2)).
