% Random utilities for discourse generation
:- encoding(utf8).

% Select a random word from a category
random_select_word(Category, Lang, Word) :-
    word_bank(Category, Lang, Words),
    length(Words, Len),
    Len > 0,
    random_between(0, Len, Idx0),
    Idx is Idx0 + 1,
    nth1(Idx, Words, Word), !.

random_select_word(Category, Lang, default) :-
    write('Warning: No words for category '),
    write(Category), write(' and language '),
    write(Lang), nl.

% Select from a list with equal probability
random_select([], default) :- !.
random_select(List, Selected) :-
    length(List, Len),
    Len > 0,
    random_between(1, Len, Idx),
    nth1(Idx, List, Selected), !.

% Random between (inclusive)
random_between(Low, High, Result) :-
    Range is High - Low + 1,
    random(R),
    Result is Low + floor(R * Range).

% Weighted random selection
weighted_random([Weight-Item | Rest], Selected) :-
    random_between(1, 100, R),
    (R =< Weight ->
        Selected = Item
    ;
        subtract_weight(Rest, Weight, Remaining),
        weighted_random(Remaining, Selected)
    ).

subtract_weight([], _, []) :- !.
subtract_weight([W-I | Rest], MinW, [W2-I | Rest2]) :-
    W2 is W - MinW,
    subtract_weight(Rest, MinW, Rest2).

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
