:- encoding(utf8).

:- dynamic(mentioned_entity/2).

:- consult('data/dict_en.pl').
:- consult('data/dict_es.pl').
:- consult('src/random_utils.pl').
:- consult('src/state.pl').
:- consult('src/generator.pl').

showcase :-
    write('# Prolog Discourse Generator - Working Example\n\n'),
    write('## Generated Discourse\n\n'),

    write('### English Story (seed=42)\n\n'),
    write('```prolog\n'),
    write('swipl -l src/main.pl -- --lang en --seed 42\n'),
    write('```\n\n'),
    write('**Output:**\n'),
    write('```\n'),
    set_random(seed(42)),
    (generate_narrative(simple_story, en, Story) ->
        write(Story), nl
    ;
        write('[Failed to generate]\n')
    ),
    write('```\n\n'),

    write('---\n\n'),

    write('### Spanish Story (seed=100)\n\n'),
    write('```prolog\n'),
    write('swipl -l src/main.pl -- --lang es --seed 100\n'),
    write('```\n\n'),
    write('**Output:**\n'),
    write('```\n'),
    set_random(seed(100)),
    (generate_narrative(simple_story, es, Story2) ->
        write(Story2), nl
    ;
        write('[Failed to generate]\n')
    ),
    write('```\n\n'),

    halt.

:- initialization(showcase, program).
