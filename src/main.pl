% Main entry point for Prolog Discourse Generator
:- encoding(utf8).

:- dynamic(current_language/1).
:- dynamic(current_seed/1).

current_language(en).
current_seed(42).

% Load all modules
:- consult('src/profiles.pl').
:- consult('src/dict_loader.pl').
:- consult('src/tui.pl').
:- consult('src/generator.pl').
:- consult('src/ontology.pl').
:- consult('src/config.pl').
:- consult('src/random_utils.pl').
:- consult('src/state.pl').
:- consult('data/dict_en.pl').
:- consult('data/dict_es.pl').
:- consult('data/narratives.pl').

% Load profile-specific dictionaries on startup
:- load_dictionaries(en, political).
:- load_dictionaries(en, sales).
:- load_dictionaries(en, karen).
:- load_dictionaries(es, political).
:- load_dictionaries(es, sales).
:- load_dictionaries(es, karen).

main :-
    cli_args(Args),
    process_args(Args),
    run_tui.

main :-
    run_tui.

run_tui :-
    clear_screen,
    show_banner,
    show_main_menu.

% Simple argument processing
cli_args(Args) :-
    current_prolog_flag(argv, Args).

process_args([]).
process_args(['--lang', Lang | Rest]) :-
    atom_string(LangAtom, Lang),
    retractall(current_language(_)),
    assertz(current_language(LangAtom)),
    process_args(Rest).
process_args(['--profile', Profile | Rest]) :-
    atom_string(ProfileAtom, Profile),
    set_profile(ProfileAtom),
    process_args(Rest).
process_args(['--seed', Seed | Rest]) :-
    atom_number(Seed, SeedNum),
    retractall(current_seed(_)),
    assertz(current_seed(SeedNum)),
    set_random(seed(SeedNum)),
    process_args(Rest).
process_args(['--config', ConfigFile | Rest]) :-
    load_config(ConfigFile),
    process_args(Rest).
process_args([_ | Rest]) :-
    process_args(Rest).

show_banner :-
    write('╔════════════════════════════════════════════╗\n'),
    write('║   Prolog Discourse Generator v0.1         ║\n'),
    write('║   ~1989 Turbo Prolog Revival               ║\n'),
    write('║   Simple. Pure Logic. Coherent Narratives. ║\n'),
    write('╚════════════════════════════════════════════╝\n'),
    nl.

clear_screen :-
    write('\033[H\033[J').

% Entry point when used as main
:- initialization(main, program).
