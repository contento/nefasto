% HTTP Server for Prolog Discourse Generator
% Provides REST API endpoints for the web frontend
:- encoding(utf8).

:- use_module(library(http/http_server)).
:- use_module(library(http/json)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_files)).

% Load all core modules
:- consult('main.pl').

% ===== CORS CONFIGURATION =====
:- set_setting(http:cors, [
    (methods([get, post, options])),
    (origins(['http://localhost:3000', 'http://localhost:3001', 'http://127.0.0.1:3000', '*'])),
    (credentials(true))
]).

% ===== ROUTE HANDLERS =====
:- http_handler('/api/generate', handle_generate, []).
:- http_handler('/api/languages', handle_languages, []).
:- http_handler('/api/narrative-types', handle_narrative_types, []).
:- http_handler('/api/settings', handle_settings, []).
:- http_handler('/static', http_reply_dirindex(['index.html'], []), [prefix(false)]).
:- http_handler('/', serve_static, []).

% ===== HANDLER: Generate Narrative =====
handle_generate(Request) :-
    cors_headers(Request),
    http_parameters(Request, [
        lang(Lang, [default(en)]),
        seed(Seed, [integer, default(42)]),
        type(Type, [default(simple_story)])
    ]),
    catch(
        (
            % Set seed for reproducibility
            (integer(Seed) -> set_random(seed(Seed)); true),

            % Set language
            retractall(current_language(_)),
            assertz(current_language(Lang)),

            % Validate language
            (member(Lang, [en, es]) -> true; throw(error(invalid_language))),

            % Validate type
            (member(Type, [simple_story, dialogue, description]) ->
                true
            ;
                throw(error(invalid_type))
            ),

            % Generate narrative
            (generate_narrative(Type, Lang, Narrative) ->
                reply_json(_{
                    success: true,
                    narrative: Narrative,
                    language: Lang,
                    seed: Seed,
                    type: Type
                })
            ;
                reply_json(_{
                    success: false,
                    error: 'Generation failed - check DCG rules and word banks'
                }, [status(500)])
            )
        ),
        Error,
        handle_error(Error)
    ).

% ===== HANDLER: Available Languages =====
handle_languages(Request) :-
    cors_headers(Request),
    reply_json(_{
        languages: [
            _{code: en, name: 'English'},
            _{code: es, name: 'Español'}
        ]
    }).

% ===== HANDLER: Narrative Types =====
handle_narrative_types(Request) :-
    cors_headers(Request),
    reply_json(_{
        types: [
            _{code: simple_story, name: 'Simple Story', description: 'A story with setup, complication, and resolution'},
            _{code: dialogue, name: 'Dialogue', description: 'A conversation between two characters'},
            _{code: description, name: 'Description', description: 'An atmospheric description of a place or person'}
        ]
    }).

% ===== HANDLER: Settings =====
handle_settings(Request) :-
    cors_headers(Request),
    current_language(Lang),
    current_seed(Seed),
    reply_json(_{
        language: Lang,
        seed: Seed,
        available_languages: [en, es],
        available_types: [simple_story, dialogue, description]
    }).

% ===== HANDLER: Serve Frontend =====
serve_static(Request) :-
    % For development: serve from web/public
    % In production: serve built React app
    http_reply_file('web/public/index.html', []).

% ===== UTILITY: CORS Headers =====
cors_headers(Request) :-
    (   member(origin(Origin), Request)
    ->  format('Access-Control-Allow-Origin: ~w~n', [Origin])
    ;   format('Access-Control-Allow-Origin: *~n')
    ),
    format('Access-Control-Allow-Methods: GET, POST, OPTIONS~n'),
    format('Access-Control-Allow-Headers: Content-Type~n').

% ===== UTILITY: Error Handler =====
handle_error(error(invalid_language)) :-
    reply_json(_{
        success: false,
        error: 'Invalid language. Use: en, es'
    }, [status(400)]).

handle_error(error(invalid_type)) :-
    reply_json(_{
        success: false,
        error: 'Invalid narrative type. Use: simple_story, dialogue, description'
    }, [status(400)]).

handle_error(Error) :-
    format(atom(Msg), '~w', [Error]),
    reply_json(_{
        success: false,
        error: Msg
    }, [status(500)]).

% ===== SERVER START =====

% Default port
server_port(3000).

start_server :-
    start_server(3000).

start_server(Port) :-
    format('Starting Prolog Discourse Generator Server~n'),
    format('Port: ~w~n', [Port]),
    http_server([port(Port), workers(4)]),
    format('Server running on http://localhost:~w~n', [Port]),
    format('API endpoints:~n'),
    format('  GET /api/generate?lang=en&seed=42&type=simple_story~n'),
    format('  GET /api/languages~n'),
    format('  GET /api/narrative-types~n'),
    format('  GET /api/settings~n'),
    nl,
    thread_get_message(_).

% ===== CLI ENTRY POINT =====
% Start with: swipl -f src/server.pl -t start_server

:- initialization(start_server, program).
