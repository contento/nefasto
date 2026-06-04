import React, { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'

function App() {
  const [language, setLanguage] = useState('en')
  const [narrativeType, setNarrativeType] = useState('simple_story')
  const [seed, setSeed] = useState(42)
  const [narrative, setNarrative] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [languages, setLanguages] = useState([])
  const [narrativeTypes, setNarrativeTypes] = useState([])

  // API base URL - adjust for production
  const API_BASE = import.meta.env.VITE_API_URL || 'http://localhost:3001'

  // Fetch available languages and types on mount
  useEffect(() => {
    fetchLanguages()
    fetchNarrativeTypes()
  }, [])

  const fetchLanguages = async () => {
    try {
      const response = await axios.get(`${API_BASE}/api/languages`)
      setLanguages(response.data.languages)
    } catch (err) {
      console.error('Failed to fetch languages:', err)
    }
  }

  const fetchNarrativeTypes = async () => {
    try {
      const response = await axios.get(`${API_BASE}/api/narrative-types`)
      setNarrativeTypes(response.data.types)
    } catch (err) {
      console.error('Failed to fetch narrative types:', err)
    }
  }

  const generateNarrative = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError('')
    setNarrative('')

    try {
      const response = await axios.get(`${API_BASE}/api/generate`, {
        params: {
          lang: language,
          seed: parseInt(seed),
          type: narrativeType,
        },
      })

      if (response.data.success) {
        setNarrative(response.data.narrative)
      } else {
        setError(response.data.error || 'Generation failed')
      }
    } catch (err) {
      setError(
        err.response?.data?.error ||
        err.message ||
        'Failed to connect to server'
      )
    } finally {
      setLoading(false)
    }
  }

  const handleRandomSeed = () => {
    setSeed(Math.floor(Math.random() * 1000000))
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>Prolog Discourse Generator</h1>
        <p className="subtitle">
          Pure logic. No LLMs. Coherent narratives in English & Spanish.
        </p>
      </header>

      <main className="app-main">
        <div className="container">
          {/* Controls Panel */}
          <section className="controls-panel">
            <form onSubmit={generateNarrative}>
              {/* Language Selection */}
              <div className="form-group">
                <label htmlFor="language">Language</label>
                <select
                  id="language"
                  value={language}
                  onChange={(e) => setLanguage(e.target.value)}
                  disabled={loading}
                >
                  {languages.map((lang) => (
                    <option key={lang.code} value={lang.code}>
                      {lang.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Narrative Type */}
              <div className="form-group">
                <label htmlFor="type">Narrative Type</label>
                <select
                  id="type"
                  value={narrativeType}
                  onChange={(e) => setNarrativeType(e.target.value)}
                  disabled={loading}
                >
                  {narrativeTypes.map((type) => (
                    <option key={type.code} value={type.code}>
                      {type.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Seed Input */}
              <div className="form-group">
                <label htmlFor="seed">
                  Random Seed
                  <button
                    type="button"
                    className="btn-small"
                    onClick={handleRandomSeed}
                    disabled={loading}
                    title="Generate random seed"
                  >
                    🎲
                  </button>
                </label>
                <input
                  id="seed"
                  type="number"
                  value={seed}
                  onChange={(e) => setSeed(e.target.value)}
                  min="0"
                  max="1000000"
                  disabled={loading}
                />
              </div>

              {/* Generate Button */}
              <button
                type="submit"
                className="btn-generate"
                disabled={loading}
              >
                {loading ? 'Generating...' : 'Generate Narrative'}
              </button>
            </form>

            {/* Type Description */}
            {narrativeTypes.length > 0 && (
              <div className="type-info">
                {narrativeTypes.find((t) => t.code === narrativeType)?.description}
              </div>
            )}
          </section>

          {/* Output Panel */}
          <section className="output-panel">
            {error && (
              <div className="error-message">
                <strong>Error:</strong> {error}
              </div>
            )}

            {narrative && (
              <div className="narrative-output">
                <div className="output-header">
                  <h3>Generated Narrative</h3>
                  <div className="output-meta">
                    <span className="meta-item">
                      🌍 {language === 'en' ? 'English' : 'Español'}
                    </span>
                    <span className="meta-item">🎲 {seed}</span>
                    <button
                      className="btn-copy"
                      onClick={() => {
                        navigator.clipboard.writeText(narrative)
                        alert('Copied to clipboard!')
                      }}
                      title="Copy to clipboard"
                    >
                      📋
                    </button>
                  </div>
                </div>
                <div className="narrative-text">{narrative}</div>
              </div>
            )}

            {!narrative && !error && (
              <div className="placeholder">
                <p>👈 Select options and click "Generate Narrative" to begin</p>
              </div>
            )}
          </section>
        </div>

        {/* Info Section */}
        <section className="info-section">
          <h2>About This Generator</h2>
          <p>
            This discourse generator uses pure Prolog logic—no machine learning,
            no neural networks. It combines:
          </p>
          <ul>
            <li>
              <strong>DCG Grammars</strong> for syntax rules
            </li>
            <li>
              <strong>Word Banks</strong> for vocabulary
            </li>
            <li>
              <strong>Ontologies</strong> for semantic coherence
            </li>
            <li>
              <strong>State Tracking</strong> to prevent contradictions
            </li>
            <li>
              <strong>Random Selection</strong> for variety
            </li>
          </ul>
          <p>
            Reviving techniques from 1989's Turbo Prolog with modern SWI-Prolog.
            Reproducible. Transparent. Extensible.
          </p>
        </section>
      </main>

      <footer className="app-footer">
        <p>
          Prolog Discourse Generator v0.1 • Pure Logic • No LLMs • Open Source
        </p>
      </footer>
    </div>
  )
}

export default App
