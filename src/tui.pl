% Terminal User Interface
:- encoding(utf8).

% ANSI color codes
color_reset('\033[0m').
color_bold('\033[1m').
color_cyan('\033[36m').
color_green('\033[32m').
color_yellow('\033[33m').

show_main_menu :-
    current_language(Lang),
    get_menu_text(Lang, menu_main, MenuText),
    format_menu(MenuText, [
        ('1', 'generate_discourse_menu', 'Generate Discourse'),
        ('2', 'settings_menu', 'Settings'),
        ('3', 'about_menu', 'About'),
        ('q', 'quit', 'Quit')
    ]),
    read_choice(Choice),
    handle_choice(Choice).

handle_choice('1') :- !, generate_discourse_menu.
handle_choice('2') :- !, settings_menu.
handle_choice('3') :- !, about_menu.
handle_choice('q') :- !, halt(0).
handle_choice(_) :-
    write_colored(yellow, 'Invalid choice. Please try again.\n'),
    nl,
    show_main_menu.

generate_discourse_menu :-
    current_language(Lang),
    clear_screen,
    write_colored(cyan, '=== Generate Discourse ===\n'),
    nl,

    % Get narrative type
    (Lang = es ->
        write('Selecciona tipo de narrativa:\n')
    ;
        write('Select narrative type:\n')
    ),
    nl,
    format_menu(narrative_menu, [
        ('1', 'simple_story', 'Simple Story'),
        ('2', 'dialogue', 'Dialogue'),
        ('3', 'description', 'Description'),
        ('b', 'back', 'Back')
    ]),
    read_choice(NarrChoice),
    handle_narrative_choice(NarrChoice),
    show_main_menu.

handle_narrative_choice('1') :- !,
    generate_simple_story.
handle_narrative_choice('2') :- !,
    generate_dialogue.
handle_narrative_choice('3') :- !,
    generate_description.
handle_narrative_choice('b') :- !,
    true.
handle_narrative_choice(_) :-
    write_colored(yellow, 'Invalid choice.\n'),
    nl,
    generate_discourse_menu.

generate_simple_story :-
    current_language(Lang),
    nl,
    write_colored(green, '--- Generated Story ---\n\n'),
    generate_narrative(simple_story, Lang, Story),
    write(Story),
    nl, nl,
    prompt_continue.

generate_dialogue :-
    current_language(Lang),
    nl,
    write_colored(green, '--- Generated Dialogue ---\n\n'),
    generate_narrative(dialogue, Lang, Dialogue),
    write(Dialogue),
    nl, nl,
    prompt_continue.

generate_description :-
    current_language(Lang),
    nl,
    write_colored(green, '--- Generated Description ---\n\n'),
    generate_narrative(description, Lang, Desc),
    write(Desc),
    nl, nl,
    prompt_continue.

settings_menu :-
    clear_screen,
    write_colored(cyan, '=== Settings ===\n'),
    nl,
    current_language(Lang),
    format('Current Language: ~w\n\n', [Lang]),
    format_menu(settings_menu, [
        ('1', 'change_language', 'Change Language'),
        ('2', 'set_seed', 'Set Random Seed'),
        ('b', 'back', 'Back')
    ]),
    read_choice(Choice),
    handle_settings_choice(Choice).

handle_settings_choice('1') :- !,
    clear_screen,
    write('Select language:\n\n'),
    write('1. English\n'),
    write('2. Español\n\n'),
    read_choice(LangChoice),
    (LangChoice = '1' ->
        retractall(current_language(_)),
        assertz(current_language(en)),
        write_colored(green, 'Language set to English\n')
    ; LangChoice = '2' ->
        retractall(current_language(_)),
        assertz(current_language(es)),
        write_colored(green, 'Idioma establecido a Español\n')
    ;
        write_colored(yellow, 'Invalid selection\n')
    ),
    nl,
    prompt_continue,
    settings_menu.

handle_settings_choice('2') :- !,
    write('Enter seed (0-1000000): '),
    read_line_to_string(user_input, SeedStr),
    (atom_number(SeedStr, Seed), integer(Seed), Seed >= 0 ->
        retractall(current_seed(_)),
        assertz(current_seed(Seed)),
        set_random(seed(Seed)),
        write_colored(green, 'Seed set successfully\n')
    ;
        write_colored(yellow, 'Invalid seed\n')
    ),
    nl,
    prompt_continue,
    settings_menu.

handle_settings_choice('b') :- !,
    true.

handle_settings_choice(_) :-
    write_colored(yellow, 'Invalid choice\n'),
    nl,
    prompt_continue,
    settings_menu.

about_menu :-
    clear_screen,
    write_colored(cyan, '=== About ===\n\n'),
    write('Prolog Discourse Generator v0.1\n'),
    write('A revival of 1989 Turbo Prolog techniques\n'),
    write('using modern SWI-Prolog.\n\n'),
    write('This generator creates coherent narratives\n'),
    write('using pure Prolog logic, DCG grammars,\n'),
    write('and simple random selection.\n\n'),
    write('No LLMs. No neural networks.\n'),
    write('Just logic.\n\n'),
    write('Languages: English, Español\n'),
    nl,
    prompt_continue.

prompt_continue :-
    write('Press ENTER to continue...'),
    read(_),
    clear_screen.

format_menu(_, []) :- !.
format_menu(Title, Options) :-
    write(Title), nl, nl,
    format_menu_options(Options),
    nl.

format_menu_options([]).
format_menu_options([(Key, Action, Label) | Rest]) :-
    format('[~w] ~w\n', [Key, Label]),
    format_menu_options(Rest).

read_choice(Choice) :-
    write('Enter choice: '),
    read_line_to_string(user_input, Line),
    atom_string(Choice, Line).

write_colored(Color, Text) :-
    get_color_code(Color, Code),
    color_reset(Reset),
    format('~w~w~w', [Code, Text, Reset]).

get_color_code(cyan, '\033[36m').
get_color_code(green, '\033[32m').
get_color_code(yellow, '\033[33m').
get_color_code(bold, '\033[1m').
get_color_code(reset, '\033[0m').

get_menu_text(en, menu_main, 'Main Menu').
get_menu_text(es, menu_main, 'Menú Principal').

% Placeholder for localized menu text - expand as needed
get_menu_text(_, _, 'Menu').
