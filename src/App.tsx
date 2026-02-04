import { useState, useEffect } from 'react'
import { invoke } from '@tauri-apps/api/core'
import { Moon, Sun } from 'lucide-react'
import { useTranslation } from 'react-i18next'
import { Counter } from '@/components/Counter'

export function App() {
  const { t, i18n } = useTranslation()
  const [greeting, setGreeting] = useState('')
  const [name, setName] = useState('Developer')

  const [theme, setTheme] = useState<'light' | 'dark'>(() => {
    if (typeof window !== 'undefined' && window.localStorage) {
      const stored = localStorage.getItem('theme')
      if (stored === 'light' || stored === 'dark') return stored
      return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
    }
    return 'dark'
  })

  useEffect(() => {
    const root = window.document.documentElement
    if (theme === 'dark') {
      root.classList.add('dark')
    } else {
      root.classList.remove('dark')
    }
    localStorage.setItem('theme', theme)
  }, [theme])

  const toggleTheme = () => {
    setTheme((prev) => (prev === 'dark' ? 'light' : 'dark'))
  }

  const handleGreet = async () => {
    try {
      const result = await invoke<string>('greet', { name })
      setGreeting(result)
    } catch (error) {
      setGreeting(`Error: ${error}`)
    }
  }

  const toggleLanguage = () => {
    const newLang = i18n.language === 'en' ? 'zh' : 'en'
    i18n.changeLanguage(newLang)
  }

  return (
    <div className="min-h-screen bg-background text-text transition-colors duration-300">
      <div className="container mx-auto p-6 max-w-4xl">
        {/* Header */}
        <div className="flex justify-between items-center mb-8 p-4 bg-surface rounded-lg border border-surfaceHighlight">
          <div>
            <h1 className="text-2xl font-bold">{t('app.title')}</h1>
            <p className="text-sm text-textMuted">{t('app.subtitle')}</p>
          </div>
          <div className="flex gap-2">
            <button
              onClick={toggleLanguage}
              className="px-3 py-2 bg-surfaceHighlight hover:bg-surfaceHighlight/80 text-text rounded-lg transition-colors text-sm"
            >
              {i18n.language === 'en' ? '中文' : 'English'}
            </button>
            <button
              onClick={toggleTheme}
              className="p-2 text-textMuted hover:text-text rounded-lg hover:bg-surfaceHighlight transition-colors"
              title={`Switch to ${theme === 'dark' ? 'light' : 'dark'} mode`}
            >
              {theme === 'dark' ? <Sun size={20} /> : <Moon size={20} />}
            </button>
          </div>
        </div>

        {/* Content */}
        <div className="space-y-6">
          {/* Tauri Command Example */}
          <div className="p-6 bg-surface rounded-lg border border-surfaceHighlight">
            <h2 className="text-xl font-semibold mb-4">Tauri Command Example</h2>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-2 text-textMuted">
                  {t('example.enterName')}
                </label>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Enter your name"
                  className="w-full px-4 py-2 bg-background border border-surfaceHighlight rounded-lg focus:border-primary focus:ring-1 focus:ring-primary outline-none transition-all"
                />
              </div>
              <button
                onClick={handleGreet}
                className="w-full px-4 py-2 bg-primary hover:bg-primaryHover text-white rounded-lg transition-colors font-medium"
              >
                {t('example.greet')}
              </button>
              {greeting && (
                <div className="p-4 bg-primary/10 border border-primary/20 rounded-lg text-primary">
                  {greeting}
                </div>
              )}
            </div>
          </div>

          {/* React Component Example */}
          <Counter initialValue={0} />

          {/* Info Card */}
          <div className="p-6 bg-surface rounded-lg border border-surfaceHighlight">
            <h2 className="text-xl font-semibold mb-4">Getting Started</h2>
            <div className="space-y-2 text-sm text-textMuted">
              <p>✨ This is a Tauri + React + TypeScript template</p>
              <p>🚀 Edit <code className="px-2 py-1 bg-surfaceHighlight rounded">src/App.tsx</code> to get started</p>
              <p>🦀 Add Rust commands in <code className="px-2 py-1 bg-surfaceHighlight rounded">src-tauri/src/lib.rs</code></p>
              <p>🎨 Customize styles in <code className="px-2 py-1 bg-surfaceHighlight rounded">src/styles/globals.css</code></p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
