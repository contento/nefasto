% Unit tests for state.pl entity tracking
:- use_module(library(plunit)).

:- begin_tests(state_management).

% Test initialization
test(init_creates_numeric_state) :-
    init_narrative_state,
    narrative_state(N),
    integer(N),
    N = 0.

test(init_clears_entities) :-
    assertz(entity_history(test, entity1, 1)),
    init_narrative_state,
    \+ entity_history(test, entity1, 1).

test(init_clears_actions) :-
    assertz(last_action(action(test, subj, obj))),
    init_narrative_state,
    \+ last_action(action(test, subj, obj)).

% Test entity addition
test(add_entity_records_it) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    entity_history(character, wizard, 1).

test(add_multiple_entities) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    add_entity(character, knight, 2),
    add_entity(location, castle, 3),
    entity_history(character, wizard, 1),
    entity_history(character, knight, 2),
    entity_history(location, castle, 3).

% Test entity retrieval
test(get_entities_of_type_finds_all) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    add_entity(character, knight, 2),
    add_entity(location, castle, 3),
    get_entities_of_type(character, Chars),
    length(Chars, 2),
    member(wizard, Chars),
    member(knight, Chars).

test(get_entities_of_type_empty) :-
    init_narrative_state,
    get_entities_of_type(nonexistent, Entities),
    Entities = [].

% Test entity mention checking
test(entity_mentioned_yes) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    entity_mentioned(wizard).

test(entity_mentioned_no, [fail]) :-
    init_narrative_state,
    entity_mentioned(not_added).

% Test advance_line
test(advance_line_increments) :-
    init_narrative_state,
    narrative_state(N1),
    advance_line,
    narrative_state(N2),
    N2 is N1 + 1.

test(advance_line_multiple_times) :-
    init_narrative_state,
    narrative_state(0),
    advance_line,
    narrative_state(1),
    advance_line,
    narrative_state(2),
    advance_line,
    narrative_state(3).

% Test action recording
test(record_action_stores_it) :-
    init_narrative_state,
    record_action(found, wizard, sword),
    last_action(action(found, wizard, sword)).

test(record_action_overwrites) :-
    init_narrative_state,
    record_action(found, wizard, sword),
    record_action(lost, knight, shield),
    % Most recent is available
    last_action(action(lost, knight, shield)).

% Test location tracking
test(record_location_sets_it) :-
    init_narrative_state,
    record_location(castle),
    last_location(castle).

test(record_location_overwrites) :-
    init_narrative_state,
    record_location(forest),
    record_location(mountain),
    last_location(mountain),
    \+ last_location(forest).

test(get_current_location_found) :-
    init_narrative_state,
    record_location(river),
    get_current_location(Loc),
    Loc = river.

test(get_current_location_default) :-
    init_narrative_state,
    get_current_location(Loc),
    Loc = unknown.

% Test action frequency checking
test(action_frequency_allows_new) :-
    init_narrative_state,
    action_frequency_check(found).

test(action_frequency_allows_after_record) :-
    init_narrative_state,
    record_action(found, wizard, sword),
    action_frequency_check(found).

:- end_tests(state_management).
