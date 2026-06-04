:- encoding(utf8).

:- dynamic(mentioned_entity/2).

:- consult('data/dict_en.pl').
:- consult('src/random_utils.pl').
:- consult('src/state.pl').
:- consult('src/generator.pl').

debug :-
    write('Testing phrase/2...'), nl,
    set_random(seed(42)),
    (phrase(story(en), Tokens) ->
        (write('Success! Tokens: '), write(Tokens), nl)
    ;
        write('phrase/2 failed'), nl
    ),
    halt.

:- initialization(debug, program).
