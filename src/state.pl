% Narrative State Tracking for Coherence
:- encoding(utf8).

:- dynamic(narrative_state/1).
:- dynamic(entity_history/3).
:- dynamic(last_action/1).
:- dynamic(last_location/1).

% Initialize state
init_narrative_state :-
    retractall(narrative_state(_)),
    retractall(entity_history(_, _, _)),
    retractall(last_action(_)),
    retractall(last_location(_)),
    assertz(narrative_state(started)).

% Track what entities have been mentioned
add_entity(Type, Entity, LineNum) :-
    assertz(entity_history(Type, Entity, LineNum)).

% Get all entities of a type mentioned so far
get_entities_of_type(Type, Entities) :-
    findall(E, entity_history(Type, E, _), Entities).

% Check if an entity has been mentioned before
entity_mentioned(Entity) :-
    entity_history(_, Entity, _).

% Get the most recent entity mention
get_last_mentioned_entity(Entity) :-
    entity_history(_, Entity, LineNum),
    \+ (entity_history(_, E2, L2), L2 > LineNum, E2 \== Entity).

% Track pronoun antecedents for anaphora resolution
get_pronoun_antecedent(he, Subject) :-
    get_last_mentioned_entity(Subject),
    entity_history(character, Subject, _), !.

get_pronoun_antecedent(she, Subject) :-
    get_last_mentioned_entity(Subject),
    entity_history(character, Subject, _), !.

get_pronoun_antecedent(it, Object) :-
    get_last_mentioned_entity(Object),
    entity_history(object, Object, _), !.

get_pronoun_antecedent(they, Subject) :-
    get_last_mentioned_entity(Subject),
    entity_history(character, Subject, _), !.

% Track narrative flow
advance_line :-
    retractall(narrative_state(N)),
    N1 is N + 1,
    assertz(narrative_state(N1)).

% Log actions for consequence checking
record_action(Action, Subject, Object) :-
    assertz(last_action(action(Action, Subject, Object))).

% Get consequences of last action
get_action_consequence(Consequence) :-
    last_action(action(ActionType, Subject, Object)),
    action_consequence(ActionType, Consequence).

action_consequence(found, [happy, rich, famous]).
action_consequence(lost, [sad, desperate]).
action_consequence(met, [surprised, cautious]).
action_consequence(discovered, [wonder, knowledge]).

% Location tracking
record_location(Location) :-
    retractall(last_location(_)),
    assertz(last_location(Location)).

get_current_location(Location) :-
    last_location(Location), !.
get_current_location(unknown).

% Ensure we don't repeat actions too quickly
action_frequency_check(Action) :-
    \+ last_action(action(Action, _, _)), !.
action_frequency_check(_) :-
    % Allow repetition but with different subjects/objects
    true.

% Spanish and English state consistency
state_language(en).
state_language(es).

% Initialize everything on narrative start
reset_narrative :-
    init_narrative_state,
    retractall(last_action(_)),
    retractall(last_location(_)).
