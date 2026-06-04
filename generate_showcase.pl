:- encoding(utf8).

% Load modules (without tui.pl and ontology.pl which trigger interactive mode)
:- consult('src/generator.pl').
:- consult('src/random_utils.pl').
:- consult('src/state.pl').
:- consult('data/dict_en.pl').
:- consult('data/dict_es.pl').
:- consult('data/narratives.pl').

% Generate stories with different types and seeds
run_showcase :-
    write('=== SHOWCASE: Prolog Discourse Generator ===\n\n'),

    % English Story
    write('## Simple Story (English, seed=42)\n'),
    write('```\n'),
    set_random(seed(42)),
    generate_narrative(simple_story, en, Story1),
    write(Story1), nl,
    write('```\n\n'),

    % Spanish Story
    write('## Simple Story (Spanish, seed=123)\n'),
    write('```\n'),
    set_random(seed(123)),
    generate_narrative(simple_story, es, Story2),
    write(Story2), nl,
    write('```\n\n'),

    % English Dialogue
    write('## Dialogue (English, seed=456)\n'),
    write('```\n'),
    set_random(seed(456)),
    generate_narrative(dialogue, en, Dialogue1),
    write(Dialogue1), nl,
    write('```\n\n'),

    % English Description
    write('## Description (English, seed=789)\n'),
    write('```\n'),
    set_random(seed(789)),
    generate_narrative(description, en, Desc1),
    write(Desc1), nl,
    write('```\n\n'),

    halt.

:- initialization(run_showcase, program).
