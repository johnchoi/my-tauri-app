import { describe, it, expect } from 'vitest'
import { render, screen } from '@testing-library/react'
import { App } from '@/App'

describe('App', () => {
  it('renders the app title', () => {
    render(<App />)
    expect(screen.getByText(/Tauri App/i)).toBeInTheDocument()
  })

  it('renders the counter component', () => {
    render(<App />)
    expect(screen.getByText(/Counter Example/i)).toBeInTheDocument()
  })

  it('renders the getting started section', () => {
    render(<App />)
    expect(screen.getByText(/Getting Started/i)).toBeInTheDocument()
  })
})
