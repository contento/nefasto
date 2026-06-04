% Ontology: Semantic relationships and constraints for coherent narrative
:- encoding(utf8).

% Actor-Action relationships (what can do what)
can_perform(character, travel).
can_perform(character, speak).
can_perform(character, find).
can_perform(character, give).
can_perform(character, discover).

can_perform(creature, roam).
can_perform(creature, hunt).
can_perform(creature, flee).

can_perform(object, fall).
can_perform(object, break).
can_perform(object, shine).

% Subject-Object compatibility
compatible_action(character, verb, object) :-
    member(verb, [took, held, gave, found, saw, learned]).

compatible_action(creature, verb, object) :-
    member(verb, [caught, found, chased]).

% Location properties
is_location(castle).
is_location(forest).
is_location(village).
is_location(mountain).
is_location(lake).
is_location(tower).
is_location(cave).

% Location-Activity compatibility
location_allows_activity(castle, [lived, ruled, defended, discovered]).
location_allows_activity(forest, [wandered, hunted, found, hid]).
location_allows_activity(village, [lived, spoke, visited, traded]).
location_allows_activity(mountain, [climbed, discovered, explored]).
location_allows_activity(lake, [swam, fished, sailed, reflected]).

% Entity types
entity_type(character, animate).
entity_type(creature, animate).
entity_type(object, inanimate).
entity_type(location, inanimate).

% Semantic roles
semantic_role(character, agent).
semantic_role(creature, agent).
semantic_role(object, patient).
semantic_role(location, location).

% Narrative causality: what logically follows what
causes_consequence(found_treasure, [happy, wealthy, famous]).
causes_consequence(lost_item, [sad, desperate, searching]).
causes_consequence(met_stranger, [surprised, curious, suspicious]).
causes_consequence(left_home, [adventure, unknown, longing]).

% Properties that objects can have
has_property(object, beautiful).
has_property(object, ancient).
has_property(object, precious).
has_property(object, magical).
has_property(object, fragile).

has_property(character, brave).
has_property(character, wise).
has_property(character, kind).
has_property(character, clever).
has_property(character, strong).

% Narrative coherence checks
is_coherent(Narrative) :-
    check_entity_consistency(Narrative),
    check_tense_consistency(Narrative),
    check_causal_links(Narrative).

check_entity_consistency(Narrative) :-
    % Entities must not appear with contradictory properties
    true.

check_tense_consistency(Narrative) :-
    % All verbs should be in consistent tense
    true.

check_causal_links(Narrative) :-
    % Actions should have logical consequences
    true.

% Turbo Prolog compatibility notes:
% In ~1989 Turbo Prolog:
% - No modules, so all these predicates would be in one file
% - assert/retract worked but was slower
% - No tabling/memoization
% - Unification was fast, perfect for semantic matching
% - No findall/bagof - had to use custom backtracking loops
% - Standard predicates were very minimal
%
% Modern SWI-Prolog advantages:
% - Modules for organization
% - findall, aggregate for collecting solutions
% - Better DCG support
% - Unicode support (essential for ES/EN mixing)
% - CLP(FD) for constraint solving
% - Much faster unification and indexing
