-module(erlotp).
-author('omar@kodi.is').

-type token() :: integer().
-type secret() :: binary().
-type interval() :: integer().

-export([get_hotp/2,
	 get_totp/1,
	 secret/1]).

-export_type([token/0,
	      secret/0,
	      interval/0]).


%% @doc
%% Random secret, N bytes
%% @end
-spec secret(integer()) -> secret().
secret(N) when N < 16 ->
    throw({error, unsafe_secret});
secret(N) ->
    Key = crypto:strong_rand_bytes(N),
    Secret = erlotp_base32:encode(Key),
    Secret.

%% @doc
%% Get a one time token based on a secret and a 
%% interval number.
%% @end
-spec get_hotp(secret(), interval()) -> token().
get_hotp(Secret, Interval) when is_binary(Secret),
				is_integer(Interval) ->
    Key = erlotp_base32:decode(Secret),
    Digest = crypto:hmac(sha, Key, <<Interval:64/integer>>),
    <<_:19/bytes,_:4/bits,Offset:4>> = Digest,
    <<_:Offset/bytes,_:1/bits,P:31,_/binary>> = Digest,
    P rem 1000000.

%% @doc
%% Get a one time token based on a secret time.
%% @end
-spec get_totp(secret()) -> token().
get_totp(Secret) ->
    Timestamp = timestamp(now()) div 30,
    get_hotp(Secret, Timestamp).

timestamp({Mega, Secs, _}) ->
    Mega*1000000 + Secs.
