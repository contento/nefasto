#!/usr/bin/env swipl -f
:- encoding(utf8).

% Load all modules
:- consult('src/main.pl').

% Generate and print
test_generate :-
    set_random(seed(42)),
    retractall(current_language(_)),
    assertz(current_language(en)),
    generate_narrative(simple_story, en, Story),
    format('~w~n', [Story]),
    halt.

:- initialization(test_generate, program).
