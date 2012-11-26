-module(erlotp).
-author('omar@kodi.is').

-export([get_hotp/2,
	 get_totp/1]).

%% @doc
%% Get a one time token based on a secret and a 
%% interval number.
%% @end
-spec get_hotp(binary(), integer()) -> integer().
get_hotp(Secret, Interval) when is_binary(Secret),
				is_integer(Interval) ->
    Key = erlotp_base32:decode(Secret),
    Digest = crypto:sha_mac(Key, <<Interval:64/integer>>),
    <<_:19/bytes,_:4/bits,Offset:4>> = Digest,
    <<_:Offset/bytes,_:1/bits,P:31,_/binary>> = Digest,
    P rem 1000000.

%% @doc
%% Get a one time token based on a secret time.
%% @end
-spec get_totp(binary()) -> integer().
get_totp(Secret) ->
    Timestamp = timestamp(now()) div 30,
    get_hotp(Secret, Timestamp).

timestamp({Mega, Secs, _}) ->
    Mega*1000000 + Secs.
