% English Political Profile Dictionary
:- encoding(utf8).

:- multifile word_bank/3.

% Political profile: argumentative, policy-focused, persuasive
% Nouns: positions, entities, institutions
word_bank(nouns, en_political, [
    senator, advocate, parliament, legislator, policy, amendment, decree,
    proposal, faction, coalition, regime, authority, council, assembly,
    reform, statute, convention, principle, doctrine, ideology,
    constituent, voter, citizen, delegate, representative, minister,
    treaty, alliance, dispute, campaign, election, debate
]).

% Political verbs: persuade, debate, argue, propose, enact, oppose
word_bank(verbs, en_political, [
    persuaded, debated, argued, proposed, enacted, opposed,
    advocated, challenged, reformed, contested, declared, proclaimed,
    convened, negotiated, ratified, objected, affirmed, asserted,
    disputed, campaigned, appealed, convinced, refuted, supported,
    influenced, decided, ruled, decreed, amended, challenged
]).

% Political adjectives: powerful, diplomatic, radical, conservative, neutral
word_bank(adjectives, en_political, [
    radical, conservative, moderate, progressive, traditional,
    diplomatic, pragmatic, idealistic, authoritative, dominant,
    influential, controversial, contentious, divisive, unifying,
    powerful, weak, effective, ineffective, strategic, tactical,
    legitimate, illegitimate, popular, unpopular, stable, volatile
]).

% Political locations: parliament, capital, convention hall
word_bank(locations, en_political, [
    parliament, senate, capital, chamber, courthouse, convention,
    assembly, tribunal, headquarters, ministry, office, capitol,
    district, region, constituency, territory, jurisdiction, state,
    forum, plaza, hall, building, chamber, platform
]).

% Political statements: policy positions, arguments
word_bank(statements_en_political, en_political, [
    'The law must serve all equally',
    'Reform requires bold action',
    'Tradition provides stability',
    'Innovation demands courage',
    'Authority must be questioned',
    'Unity strengthens our position',
    'The people demand representation',
    'Progress comes through debate',
    'Principles guide our decisions',
    'Justice cannot be delayed',
    'Change is inevitable',
    'Leadership requires vision'
]).

% Political characters: leaders, activists
word_bank(characters, en_political, [
    Churchill, Roosevelt, Lincoln, Gandhi, Mandela, Jefferson,
    Cleopatra, Napoleon, Elizabeth, Catherine, Constantine, Augustus,
    Washington, Franklin, Adams, Madison, Hamilton, Jay,
    Thatcher, Kennedy, Eisenhower, Truman, Reagan, Carter
]).
