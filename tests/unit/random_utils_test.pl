% Unit tests for random_utils.pl
:- use_module(library(plunit)).

:- begin_tests(random_utils).

% Test random_between produces values in range
test(random_between_in_range) :-
    random_between(1, 10, R),
    R >= 1, R =< 10.

test(random_between_range_1) :-
    random_between(5, 5, R),
    R =:= 5.

% Test random_select works
test(random_select_from_list) :-
    List = [a, b, c, d, e],
    random_select(List, Selected),
    member(Selected, List).

test(random_select_empty_list) :-
    random_select([], default).

test(random_select_single_item) :-
    random_select([only], Selected),
    Selected = only.

% Test weighted_random selection
test(weighted_random_selects_item) :-
    Weighted = [50-apple, 30-banana, 20-cherry],
    weighted_random(Weighted, Item),
    member(Item, [apple, banana, cherry]).

test(weighted_random_respects_weights) :-
    % With high weight, should usually select that item
    Weighted = [99-always, 1-rarely],
    findall(Item, (between(1, 20, _), weighted_random(Weighted, Item)), Items),
    length(Items, 20),
    (member(always, Items) -> true ; fail). % At least one 'always'

test(weighted_random_single_option) :-
    weighted_random([100-only], Item),
    Item = only.

% Test narrative pacing
test(pacing_short_range) :-
    random_sentence_length(short, N),
    N >= 3, N =< 7.

test(pacing_medium_range) :-
    random_sentence_length(medium, N),
    N >= 8, N =< 15.

test(pacing_long_range) :-
    random_sentence_length(long, N),
    N >= 16, N =< 25.

:- end_tests(random_utils).
