#!/usr/bin/env swipl
% Test suite for Prolog Discourse Generator
% Run with: swipl tests/run_tests.pl

:- initialization(main).

main :-
    write('╔══════════════════════════════════════════════════════════════╗'), nl,
    write('║     Prolog Discourse Generator - Test Suite                  ║'), nl,
    write('║                                                              ║'), nl,
    write('║  This suite verifies narrative generation works correctly    ║'), nl,
    write('║  after recent bug fixes (Mimo code review + multifile fix)   ║'), nl,
    write('╚══════════════════════════════════════════════════════════════╝'), nl, nl,

    test_suite,
    write(nl), write('All tests complete!'), nl,
    halt.

test_suite :-
    test_dcg_rules,
    test_word_banks,
    test_english_story,
    test_spanish_story,
    test_dialogue,
    test_description,
    test_state_tracking.

% Test 1: DCG rules execute without errors
test_dcg_rules :-
    write('Test 1: DCG Rule Execution'), nl,
    Tests = [
        (phrase(space, [' ']), 'space rule'),
        (phrase(copula(en), [was]), 'copula(en)'),
        (phrase(dialogue_verb(en), [said, ':']), 'dialogue_verb(en)'),
        (phrase(dialogue_verb(es), [dijo, ':']), 'dialogue_verb(es)'),
        (phrase(description_opening(en), ['There', 'is']), 'description_opening(en)'),
        (phrase(description_opening(es), ['Hay']), 'description_opening(es)')
    ],
    run_tests_list(Tests), nl.

% Test 2: Word banks load correctly for both languages
test_word_banks :-
    write('Test 2: Word Bank Loading'), nl,
    write('  '),
    (word_bank(nouns, en, EN), length(EN, L1) ->
        format('✓ English nouns: ~w words~n  ', [L1]) ;
        write('✗ English nouns failed~n  ')),
    (word_bank(nouns, es, ES), length(ES, L2) ->
        format('✓ Spanish nouns: ~w words~n  ', [L2]) ;
        write('✗ Spanish nouns failed~n  ')),
    (word_bank(verbs, en, Verbs), length(Verbs, L3) ->
        format('✓ English verbs: ~w words~n  ', [L3]) ;
        write('✗ English verbs failed~n  ')),
    (word_bank(locations, es, Locs), length(Locs, L4) ->
        format('✓ Spanish locations: ~w words~n', [L4]) ;
        write('✗ Spanish locations failed~n')), nl.

% Test 3: English story generation
test_english_story :-
    write('Test 3: English Story Generation'), nl,
    write('  '),
    catch(
        (generate_narrative(simple_story, en, Story),
         atom_length(Story, Len),
         format('✓ Generated story (~w chars)~n', [Len]),
         write('    '), write(Story), nl),
        Error,
        (write('✗ Error: '), write(Error), nl)), nl.

% Test 4: Spanish story generation
test_spanish_story :-
    write('Test 4: Spanish Story Generation'), nl,
    write('  '),
    catch(
        (generate_narrative(simple_story, es, Story),
         atom_length(Story, Len),
         format('✓ Generated story (~w chars)~n', [Len]),
         write('    '), write(Story), nl),
        Error,
        (write('✗ Error: '), write(Error), nl)), nl.

% Test 5: Dialogue generation
test_dialogue :-
    write('Test 5: Dialogue Generation'), nl,
    write('  '),
    catch(
        (generate_narrative(dialogue, en, Dialogue),
         atom_length(Dialogue, Len),
         format('✓ Generated dialogue (~w chars)~n', [Len]),
         write('    '), write(Dialogue), nl),
        Error,
        (write('✗ Error: '), write(Error), nl)), nl.

% Test 6: Description generation
test_description :-
    write('Test 6: Description Generation'), nl,
    write('  '),
    catch(
        (generate_narrative(description, en, Desc),
         atom_length(Desc, Len),
         format('✓ Generated description (~w chars)~n', [Len]),
         write('    '), write(Desc), nl),
        Error,
        (write('✗ Error: '), write(Error), nl)), nl.

% Test 7: State tracking and advance_line
test_state_tracking :-
    write('Test 7: State Tracking & advance_line'), nl,
    write('  '),
    (init_narrative_state, narrative_state(N), integer(N) ->
        format('✓ State initialized (numeric: ~w)~n  ', [N]) ;
        write('✗ State initialization failed~n  ')),
    (advance_line ->
        write('✓ advance_line executed') ;
        write('✗ advance_line failed')), nl, nl.

% Helper: run a list of test goals
run_tests_list([]).
run_tests_list([(Goal, Label) | Rest]) :-
    write('  '),
    (call(Goal) ->
        format('✓ ~w~n', [Label]) ;
        format('✗ ~w~n', [Label])),
    run_tests_list(Rest).

% Load main module
:- [src/main].
