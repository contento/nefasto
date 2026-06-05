# Discourse Profiles - Current & Suggested

## Current Profiles (Implemented)

### Political
- **Tone**: Argumentative, policy-focused, persuasive
- **Vocabulary**: senators, legislation, reform, debate, constitute, etc.
- **Verbs**: argue, debate, propose, ratify, negotiate, etc.
- **Use case**: Political speeches, policy documents, civic discourse
- **File**: `data/dictionaries/en_political.yaml`, `es_political.yaml`

### Sales
- **Tone**: Action-oriented, benefit-focused, pitch-style
- **Vocabulary**: products, growth, innovation, achievement, success, etc.
- **Verbs**: achieved, delivered, transformed, exceeded, maximized, etc.
- **Use case**: Marketing copy, sales pitches, business proposals
- **File**: `data/dictionaries/en_sales.yaml`, `es_sales.yaml`

### Karen
- **Tone**: Entitled, demanding, complaint-focused, aggressive
- **Vocabulary**: manager, complaint, unacceptable, refund, lawsuit, etc.
- **Verbs**: demanded, complained, threatened, reported, sued, etc.
- **Use case**: Satirical narratives, entitled character dialogues
- **File**: `data/dictionaries/en_karen.yaml`, `es_karen.yaml`

## Suggested Profiles (To Implement)

### Academic/Scholarly
- **Tone**: Technical, formal, evidence-based, citations
- **Key terms**: research, methodology, hypothesis, paradigm, peer review, empirical
- **Verbs**: analyzed, demonstrated, established, conducted, examined, proposed
- **Adjectives**: rigorous, systematic, comprehensive, evidence-based, theoretical
- **Use case**: Academic papers, research documents, expert discourse
- **Complexity**: ⭐⭐⭐ (requires specialized vocabulary)

### Casual/Colloquial
- **Tone**: Friendly, informal, contemporary slang
- **Key terms**: dude, awesome, like, basically, totally, crazy, literally
- **Verbs**: hung out, chilled, grabbed, figured out, totally nailed
- **Adjectives**: cool, awesome, chill, hilarious, insane, sketchy
- **Use case**: Dialogue, social media, everyday narratives
- **Complexity**: ⭐ (easy, high word bank variability)

### Legal/Formal
- **Tone**: Precise, technical jargon, adversarial
- **Key terms**: plaintiff, defendant, statute, liability, precedent, clause
- **Verbs**: filed, testified, contested, enforced, stipulated, affirmed
- **Adjectives**: binding, void, liable, negligent, breached, contractual
- **Use case**: Legal documents, court proceedings, formal agreements
- **Complexity**: ⭐⭐⭐ (highly specialized vocabulary)

### Journalistic/Reportorial
- **Tone**: Neutral, informative, fact-based, objective
- **Key terms**: report, source, witness, investigation, allegation, incident
- **Verbs**: reported, investigated, confirmed, alleged, disclosed, revealed
- **Adjectives**: alleged, confirmed, unconfirmed, credible, disputed, verified
- **Use case**: News articles, investigative reporting, factual narratives
- **Complexity**: ⭐⭐ (moderate, emphasis on attribution)

### Poetic/Lyrical
- **Tone**: Metaphorical, artistic, evocative, emotional
- **Key terms**: soul, essence, whisper, dance, symphony, dream, eternity
- **Verbs**: yearned, soared, drifted, echoed, transcended, spiraled
- **Adjectives**: ethereal, luminous, melancholic, transcendent, haunting, sublime
- **Use case**: Poetry, creative writing, romantic narratives
- **Complexity**: ⭐⭐⭐ (requires nuance and metaphor)

### Technical/Engineering
- **Tone**: Precise, systematic, optimization-focused
- **Key terms**: algorithm, optimization, performance, parameter, infrastructure
- **Verbs**: implemented, optimized, deployed, scaled, configured, debugged
- **Adjectives**: efficient, robust, scalable, deterministic, reliable, redundant
- **Use case**: Technical documentation, system design, engineering reports
- **Complexity**: ⭐⭐⭐ (highly specialized, domain-specific)

### Conspiracy Theorist
- **Tone**: Suspicious, connecting dots, paranoid, alternative facts
- **Key terms**: coverup, truth, evidence, questions, patterns, obviously
- **Verbs**: discovered, revealed, suppressed, connected, questioned, warned
- **Adjectives**: obvious, hidden, suspicious, curious, unconventional, controlled
- **Use case**: Satirical narratives, conspiracy-themed fiction
- **Complexity**: ⭐⭐ (moderate, pattern-based vocabulary)

### Motivational Speaker
- **Tone**: Inspirational, action-oriented, energetic, empowering
- **Key terms**: dream, passion, believe, impossible, breakthrough, potential
- **Verbs**: inspired, empowered, transformed, awakened, unleashed, conquered
- **Adjectives**: unstoppable, limitless, powerful, extraordinary, phenomenal, victorious
- **Use case**: Motivational narratives, self-help, inspirational speeches
- **Complexity**: ⭐⭐ (moderate, emphasis on emotion and action)

### Passive-Aggressive
- **Tone**: Subtly hostile, sarcastic, backhanded compliments
- **Key terms**: fine, whatever, sure, clearly, obviously, apparently
- **Verbs**: supposedly, allegedly, supposedly, probably, apparently, certainly
- **Adjectives**: fine, nice, interesting, lovely, wonderful (used sarcastically)
- **Use case**: Sarcastic dialogue, interpersonal conflict narratives
- **Complexity**: ⭐⭐ (moderate, requires tone subtlety)

### Conspiracy Influencer/Grifter
- **Tone**: Vague, leading questions, selling a narrative/product
- **Key terms**: truth, secret, elite, awakening, free energy, hidden
- **Verbs**: revealing, uncovering, exposing, awakening, explaining, selling
- **Adjectives**: suppressed, alternative, exclusive, forbidden, revolutionary, secret
- **Use case**: Satirical social media narratives, fake guru discourse
- **Complexity**: ⭐⭐⭐ (nuanced, requires understanding of manipulation tactics)

## Implementation Guide

### Adding a New Profile

1. **Create YAML files**:
   - `data/dictionaries/en_{profile}.yaml`
   - `data/dictionaries/es_{profile}.yaml`

2. **Structure each file**:
   ```yaml
   # Description
   # Tone and characteristics

   nouns:
     - word1
     - word2
     # ... 30-40 words

   verbs:
     - verb1
     - verb2
     # ... 30-40 verbs

   adjectives:
     - adj1
     - adj2
     # ... 30-40 adjectives

   locations:
     - location1
     # ... 10-20 locations

   characters:
     - name1
     # ... 15-25 character names

   statements:
     - Statement one
     - Statement two
     # ... 10-15 characteristic statements
   ```

3. **Register in profiles.pl**:
   ```prolog
   profile(myprofile, 'Description of tone and use case').
   ```

4. **Load in main.pl**:
   ```prolog
   :- load_dictionaries(en, myprofile).
   :- load_dictionaries(es, myprofile).
   ```

5. **Test**:
   ```bash
   swipl -l src/main.pl -- --profile myprofile
   ```

## Word Bank Expansion Priority

1. **Political** (current: 32 nouns → expand to 60+) ✅ Done
2. **Sales** (current: 32 nouns → expand to 60+) 🔄 In progress
3. **Karen** (new: 40 nouns) ✅ Done
4. **Casual** (new: 50+ words, high variety)
5. **Academic** (new: 60+ specialized terms)

## Future Enhancement: Blending

Once profile blending is implemented, enable narratives like:
- Political + Conspiracy = paranoid policy debate
- Sales + Karen = entitled customer demanding refund
- Academic + Poetic = scholarly but lyrical explanation
- Casual + Motivational = energetic, accessible inspiration
