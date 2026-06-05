% Random utilities for discourse generation
:- encoding(utf8).

% Select a random word from a category (profile-aware)
% Profile-specific word banks only, no fallback
random_select_word(Category, Lang, Word) :-
    current_profile(Profile),
    atom_concat(Lang, '_', LangProfilePrefix),
    atom_concat(LangProfilePrefix, Profile, LangProfile),
    word_bank(Category, LangProfile, Words),
    length(Words, Len),
    Len > 0, !,
    random_between(1, Len, Idx),
    nth1(Idx, Words, Word).

random_select_word(Category, Lang, default) :-
    current_profile(Profile),
    format('ERROR: No words for category "~w" in profile "~w" (language: ~w)~n', [Category, Profile, Lang]),
    fail.

% Select from a list with equal probability
random_select([], default) :- !.
random_select(List, Selected) :-
    length(List, Len),
    Len > 0,
    random_between(1, Len, Idx),
    nth1(Idx, List, Selected), !.

% Weighted random selection
weighted_random(Items, Selected) :-
    Items \= [],
    sum_weights(Items, Total),
    Total > 0,
    random_between(1, Total, R),
    select_by_weight(Items, R, Selected), !.

sum_weights([], 0).
sum_weights([W-_ | Rest], Total) :-
    sum_weights(Rest, RestTotal),
    Total is W + RestTotal.

select_by_weight([W-Item | _], R, Item) :-
    R =< W, !.
select_by_weight([W-_ | Rest], R, Selected) :-
    R > W,
    R1 is R - W,
    select_by_weight(Rest, R1, Selected).

% Random sentence length (affects narrative pacing)
random_sentence_length(short, N) :-
    random_between(3, 7, N).

random_sentence_length(medium, N) :-
    random_between(8, 15, N).

random_sentence_length(long, N) :-
    random_between(16, 25, N).

% Narrative pacing: set overall style
set_pacing(fast) :-
    retractall(narrative_pacing(_)),
    assertz(narrative_pacing(short)).

set_pacing(normal) :-
    retractall(narrative_pacing(_)),
    assertz(narrative_pacing(medium)).

set_pacing(slow) :-
    retractall(narrative_pacing(_)),
    assertz(narrative_pacing(long)).

:- dynamic(narrative_pacing/1).
narrative_pacing(medium).
