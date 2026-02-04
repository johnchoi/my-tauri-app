import { useState } from 'react'

interface CounterProps {
  initialValue?: number
}

export function Counter({ initialValue = 0 }: CounterProps) {
  const [count, setCount] = useState(initialValue)

  return (
    <div className="flex flex-col items-center gap-4 p-6 bg-surface rounded-lg border border-surfaceHighlight">
      <h2 className="text-xl font-semibold text-text">Counter Example</h2>
      <div className="text-4xl font-bold text-primary">{count}</div>
      <div className="flex gap-2">
        <button
          onClick={() => setCount(count - 1)}
          className="px-4 py-2 bg-surfaceHighlight hover:bg-surfaceHighlight/80 text-text rounded-lg transition-colors"
        >
          -
        </button>
        <button
          onClick={() => setCount(initialValue)}
          className="px-4 py-2 bg-surfaceHighlight hover:bg-surfaceHighlight/80 text-text rounded-lg transition-colors"
        >
          Reset
        </button>
        <button
          onClick={() => setCount(count + 1)}
          className="px-4 py-2 bg-primary hover:bg-primaryHover text-white rounded-lg transition-colors"
        >
          +
        </button>
      </div>
    </div>
  )
}
