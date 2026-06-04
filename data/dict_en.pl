% English Dictionary and Lexicon
:- encoding(utf8).

% Word bank for random selection
word_bank(nouns, en, [
    wizard, knight, merchant, traveler, sage, child, elder,
    dragon, wolf, eagle, deer, horse, fox,
    castle, forest, village, mountain, river, tower, cave,
    sword, shield, book, coin, crown, ring, staff,
    stone, fire, water, wind, light, shadow, dream
]).

word_bank(verbs, en, [
    walked, ran, flew, swam, climbed, discovered,
    spoke, listened, learned, taught, shared, whispered,
    found, lost, gave, took, built, destroyed,
    searched, wandered, explored, ventured, dared, fled,
    laughed, cried, sang, danced, rested, awoke
]).

word_bank(adjectives, en, [
    ancient, beautiful, dark, bright, deep, high, vast,
    mysterious, quiet, loud, cold, warm, soft, hard,
    brave, wise, foolish, kind, cruel, strong, weak,
    magical, ordinary, rare, precious, humble, proud,
    golden, silver, blood-red, crystal-clear, endless, timeless
]).

word_bank(locations, en, [
    mountain, forest, valley, desert, island, coast,
    castle, tower, village, market, temple, ruins,
    cave, cavern, canyon, gorge, cliff, plain,
    river, lake, ocean, stream, waterfall, pool
]).

word_bank(characters, en, [
    Arthur, Merlin, Eleanor, Thomas, Isabella, Marcus,
    Sophia, Alexander, Catherine, William, Margaret, Edward,
    Legolas, Arwen, Gandalf, Frodo, Thorin, Galadriel
]).

word_bank(statements_en, en, [
    'I have journeyed far',
    'The world holds many secrets',
    'All must come to an end',
    'Hope is the greatest treasure',
    'Power corrupts the soul',
    'Truth is often hidden',
    'Time flows like a river',
    'Destiny cannot be escaped',
    'Nature is both cruel and kind',
    'Knowledge brings burden',
    'Courage lives in the heart',
    'Loneliness is the hardest burden'
]).

word_bank(features, en, [
    color, shape, size, texture, age, origin,
    weight, brightness, warmth, melody, pattern,
    strength, fragrance, taste, legacy, history
]).

% Turbo Prolog (~1989) note:
% In Turbo Prolog, you would define these as clauses:
%   noun([wizard, knight, merchant, ...]).
%   verb([walked, ran, flew, ...]).
%   adjective([ancient, beautiful, ...]).
%
% Random selection would be done with:
%   random(Seed, Seed1, Num),
%   R is (Num mod length(List)) + 1,
%   nth(R, List, Word).
%
% Modern SWI-Prolog (2024+) advantages:
% - Cleaner list syntax
% - Built-in random_member/2 and random_between/3
% - Better list operations (length/2, nth1/3, member/2)
% - Strings and atoms are better integrated
% - File I/O is standard
% - Module system for organization
