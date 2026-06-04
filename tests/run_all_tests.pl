#!/usr/bin/env swipl
% Main test runner for Prolog Discourse Generator
% Runs both unit tests (plunit) and integration tests
%
% Run with: swipl tests/run_all_tests.pl

:- use_module(library(plunit)).

:- initialization(main).

main :-
    write('╔══════════════════════════════════════════════════════════════╗'), nl,
    write('║        Nefasto - Hybrid Test Suite (Unit + Integration)      ║'), nl,
    write('║                                                              ║'), nl,
    write('║  UNIT TESTS: Individual predicates with plunit               ║'), nl,
    write('║  INTEGRATION TESTS: Complete narrative generation            ║'), nl,
    write('╚══════════════════════════════════════════════════════════════╝'), nl, nl,

    % Load main application
    write('Loading application modules...'), nl,
    [src/main], nl,

    % Load unit tests
    write('Loading unit tests...'), nl,
    [tests/unit/random_utils_test],
    [tests/unit/generator_test],
    [tests/unit/state_test], nl,

    % Load integration tests
    write('Loading integration tests...'), nl,
    [tests/integration/narrative_generation_test], nl,

    % Run all tests
    write('Running tests...'), nl, nl,
    run_tests,

    write(nl),
    write('╔══════════════════════════════════════════════════════════════╗'), nl,
    write('║                    Test Run Complete                         ║'), nl,
    write('╚══════════════════════════════════════════════════════════════╝'), nl,
    halt.

main :-
    write('ERROR: Test execution failed!'), nl,
    halt(1).
