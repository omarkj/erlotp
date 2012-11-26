Erlotp
======

Generate one time passwords, [HOTP](http://en.wikipedia.org/wiki/HOTP)s and
[TOTP](http://en.wikipedia.org/wiki/Time-based_One-time_Password_Algorithm)s for 
your application. Should work with the Google Authenticator.

Erlang API
----------

### Types

``` erlang
-type token() :: integer().
-type interval() :: integer().
-type secret() :: binary().
```

Get the one time token based on interval number

``` erlang
token() = erlotp:get_htop(secret(), interval())
```

Get the time sensitive one time token

``` erlang
token() = erlotp:get_totp(secret())
```