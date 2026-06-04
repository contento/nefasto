:- encoding(utf8).

% Declare dynamic predicates first
:- dynamic(mentioned_entity/2).
:- dynamic(current_language/1).
:- dynamic(current_seed/1).

% Load modules in correct order
:- consult('data/dict_en.pl').
:- consult('data/dict_es.pl').
:- consult('data/narratives.pl').
:- consult('src/random_utils.pl').
:- consult('src/state.pl').
:- consult('src/generator.pl').

% Generate stories
showcase :-
    write('# Prolog Discourse Generator - Showcase Output\n\n'),

    write('## Configuration Used\n'),
    write('- Language: English & Spanish\n'),
    write('- Seed: Various (for reproducibility)\n'),
    write('- Type: Simple Story, Dialogue, Description\n\n'),

    write('---\n\n'),

    write('## Example 1: Simple Story (English, seed=42)\n\n'),
    write('**Input:**\n'),
    write('```bash\n'),
    write('swipl -l src/main.pl -- --lang en --seed 42\n'),
    write('```\n\n'),
    write('**Output:**\n'),
    write('```\n'),
    set_random(seed(42)),
    (generate_narrative(simple_story, en, Story1) ->
        write(Story1), nl
    ;
        write('[Generation failed]\n')
    ),
    write('```\n\n'),

    write('---\n\n'),

    write('## Example 2: Simple Story (Spanish, seed=100)\n\n'),
    write('**Input:**\n'),
    write('```bash\n'),
    write('swipl -l src/main.pl -- --lang es --seed 100\n'),
    write('```\n\n'),
    write('**Output:**\n'),
    write('```\n'),
    set_random(seed(100)),
    (generate_narrative(simple_story, es, Story2) ->
        write(Story2), nl
    ;
        write('[Generation failed]\n')
    ),
    write('```\n\n'),

    halt.

:- initialization(showcase, program).
