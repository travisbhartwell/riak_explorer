%% @doc Test the API in various ways.
-module(re_wm_explore_test).

-compile(export_all).
-ifdef(integration_test).
-include_lib("eunit/include/eunit.hrl").

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TEST DESCRIPTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
re_wm_explore_test_() ->
    {setup,
        fun () -> ok end,
        fun (_) -> ok end,
        {timeout, 60, [
            assert_ping(),
            assert_list_types()
        ]}
    }.

%%%%%%%%%%%%%%%%%%%%
%%% ACTUAL TESTS %%%
%%%%%%%%%%%%%%%%%%%%

assert_ping() ->
    {Ok, Code, Payload} = ret:http(get, ret:url("ping")),
    Pong = get_result_json_field(Payload, <<"ping">>, <<"message">>),
    Expected = <<"pong">>,
    [
     ?_assertEqual(ok, Ok),
     ?_assertEqual("200", Code),
     ?_assertEqual(Expected, Pong)
    ].

assert_list_types() ->
    {Ok, Code, Payload} = ret:http(get, ret:url("clusters/default/bucket_types")),
    {_,ResultsList} = mochijson2:decode(Payload),
    [{_,DefaultType}|_] = proplists:get_value(<<"bucket_types">>, ResultsList),
    [DefaultName, {<<"props">>, _}] = DefaultType,
    Expected = {<<"id">>,<<"default">>},
  [
   ?_assertEqual(ok, Ok),
   ?_assertEqual("200", Code),
   ?_assertEqual(Expected, DefaultName)
  ].

%%%%%%%%%%%%%%%%%%%%%%%%
%%% HELPER FUNCTIONS %%%
%%%%%%%%%%%%%%%%%%%%%%%%
get_result_json_field(JsonString, Call, Field) ->
    {_, Json} = mochijson2:decode(JsonString),
    {_, CallPropList} = proplists:get_value(Call, Json),
    proplists:get_value(Field, CallPropList).

render_json(Data) ->
    Body = binary_to_list(list_to_binary(mochijson2:encode(Data))),
    Body.

-endif.
