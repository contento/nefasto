% Unit tests for state.pl entity tracking
:- use_module(library(plunit)).

:- begin_tests(state_management).

% Test initialization
test(init_creates_numeric_state) :-
    init_narrative_state,
    narrative_state(N),
    integer(N).

test(init_can_be_called) :-
    init_narrative_state.

% Test entity addition can be called
test(add_entity_callable) :-
    init_narrative_state,
    add_entity(character, wizard, 1).

test(add_multiple_entities_callable) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    add_entity(character, knight, 2),
    add_entity(location, castle, 3).

% Test entity retrieval
test(get_entities_of_type_callable) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    add_entity(character, knight, 2),
    get_entities_of_type(character, Chars),
    is_list(Chars).

test(get_entities_of_type_empty) :-
    init_narrative_state,
    get_entities_of_type(nonexistent, Entities),
    Entities = [].

% Test entity mention checking
test(entity_mentioned_after_add) :-
    init_narrative_state,
    add_entity(character, wizard, 1),
    entity_mentioned(wizard).

test(entity_not_mentioned_before_add, [fail]) :-
    init_narrative_state,
    entity_mentioned(not_added).

% Test action recording can be called
test(record_action_callable) :-
    init_narrative_state,
    record_action(found, wizard, sword).

test(record_action_multiple_callable) :-
    init_narrative_state,
    record_action(found, wizard, sword),
    record_action(lost, knight, shield).

% Test location tracking
test(record_location_callable) :-
    init_narrative_state,
    record_location(castle).

test(record_location_overwrites_callable) :-
    init_narrative_state,
    record_location(forest),
    record_location(mountain).

test(get_current_location_callable) :-
    init_narrative_state,
    record_location(river),
    get_current_location(Loc),
    atom(Loc).

test(get_current_location_default_when_empty) :-
    init_narrative_state,
    get_current_location(Loc),
    Loc = unknown.

% Test action frequency checking
test(action_frequency_check_callable) :-
    init_narrative_state,
    action_frequency_check(found).

test(action_frequency_after_record_callable) :-
    init_narrative_state,
    record_action(found, wizard, sword),
    action_frequency_check(found).

:- end_tests(state_management).
