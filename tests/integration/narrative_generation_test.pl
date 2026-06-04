% Integration tests for complete narrative generation
:- use_module(library(plunit)).

:- begin_tests(narrative_generation).

% Test story generation produces non-empty output
test(english_story_generates) :-
    generate_narrative(simple_story, en, Story),
    atom(Story),
    atom_length(Story, Len),
    Len > 0.

test(spanish_story_generates) :-
    generate_narrative(simple_story, es, Story),
    atom(Story),
    atom_length(Story, Len),
    Len > 0.

% Test dialogue generation
test(english_dialogue_generates) :-
    generate_narrative(dialogue, en, Dialogue),
    atom(Dialogue),
    atom_length(Dialogue, Len),
    Len > 0.

test(spanish_dialogue_generates) :-
    generate_narrative(dialogue, es, Dialogue),
    atom(Dialogue),
    atom_length(Dialogue, Len),
    Len > 0.

% Test description generation
test(english_description_generates) :-
    generate_narrative(description, en, Desc),
    atom(Desc),
    atom_length(Desc, Len),
    Len > 0.

test(spanish_description_generates) :-
    generate_narrative(description, es, Desc),
    atom(Desc),
    atom_length(Desc, Len),
    Len > 0.

% Test that stories contain expected structure elements
test(story_contains_punctuation) :-
    generate_narrative(simple_story, en, Story),
    atom_codes(Story, Codes),
    member(46, Codes). % ASCII 46 = '.'

test(spanish_story_contains_spanish_words) :-
    generate_narrative(simple_story, es, Story),
    % Check that it's not all English markers
    \+ atom_string(Story, 'once default was in the default . then default default the default . finally default default .').

% Test reproducibility with seed
test(same_seed_produces_same_story) :-
    set_random(seed(42)),
    generate_narrative(simple_story, en, Story1),
    set_random(seed(42)),
    generate_narrative(simple_story, en, Story2),
    Story1 = Story2.

% Test language switching works
test(language_switch_en_vs_es) :-
    generate_narrative(simple_story, en, StoryEn),
    generate_narrative(simple_story, es, StoryEs),
    % Stories should be different (extremely unlikely to be same)
    \+ (StoryEn = StoryEs).

% Test that retract_current_entities clears state
test(entity_tracking_cleared_between_generations) :-
    retractall(mentioned_entity(_, _)),
    generate_narrative(simple_story, en, _),
    (mentioned_entity(_, _) -> true ; true), % May or may not have entities
    retract_current_entities,
    \+ mentioned_entity(_, _).

% Test multiple generations work in sequence
test(multiple_generations_succeed) :-
    generate_narrative(simple_story, en, S1),
    atom(S1),
    generate_narrative(simple_story, es, S2),
    atom(S2),
    generate_narrative(dialogue, en, D),
    atom(D),
    generate_narrative(description, es, Desc),
    atom(Desc).

:- end_tests(narrative_generation).
