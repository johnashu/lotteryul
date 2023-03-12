import { useEffect } from 'react'
import { GiClover } from 'react-icons/gi'
import { FiX, FiRefreshCw, FiPlayCircle } from 'react-icons/fi'

import { MetaMaskConnect, useState } from './components/MM/MetaMaskConnect';
import Button from './components/Button'
import NumbersArea from './components/NumbersArea'

import './App.css'

function App() {
  const [nums, setNums] = useState([])
  const [ticketNumber, setticketNumber] = useState([])
  const [mode, setMode] = useState('create-ticket')
  const [result, setResult] = useState([])
  const [matches, setMatches] = useState([])
  const [maxNum, setMaxNum] = useState(0)

  useEffect(() => {
    const createCard = () => {
      let arr = []
      let index = 49

      for (let x = 1; x <= index; x++) {
        arr.push(x)
      }
      setNums(arr)
    }

    setticketNumber([])
    setResult([])
    setMatches([])
    setNums([])

    setMaxNum(6)
    createCard()
  }, [mode])

  const orderAndSet = num => {
    if (ticketNumber.includes(num)) return
    let length = 6
    return (
      ticketNumber.length < length &&
      setticketNumber([...ticketNumber, num].sort((a, b) => a - b))
    )
  }

  const removeFromticketNumber = index => {
    let arr = [...ticketNumber]
    arr.splice(index, 1)
    setticketNumber(arr)
  }

  const playGame = mode => {
    let length = 6
    let index = 49
    let arr = []

    if (ticketNumber.length < length) return

    const shuffle = () => {
      let num = Math.ceil(Math.random() * index)
      return arr.includes(num) ? shuffle() : num
    }
    while (arr.length < length) {
      let num = shuffle()
      arr.push(num)
    }

    setResult(arr.sort((a, b) => a - b))
  }

  useEffect(() => {
    setMatches(ticketNumber.filter(num => result.includes(num)))
  }, [ticketNumber, result])

  const reset = () => {
    setticketNumber([])
    setResult([])
    setMatches([])
  }



  return (
    <div className='App'>

      <section className='mode'>
        <Button
          className='mode-button create-ticket-lotto'
          onClick={() => setMode('create-ticket')}
        >
          <GiClover />
          Create Ticket
        </Button>
        <Button
          className='mode-button View-Results-lotto'
          onClick={() => setMode('View-Results')}
        >
          <GiClover />
          View Results
        </Button>
        <Button
          className='mode-button About-lotto'
          onClick={() => setMode('About')}
        >
          <GiClover />
          About Lotto
        </Button>

        <MetaMaskConnect />


      </section>


      <main>
        <h1 className={mode ? `${mode}-lotto` : ''}> <GiClover /> {mode}</h1>

        <section className='card'>
          {mode == 'create-ticket' || !mode
            ? ((
              <p>
                Select <strong>{maxNum}</strong> numbers from the following
                card:
              </p>
            ),
              (
                <div className={`game-card ${mode}-card`}>
                  {nums.map(num => (
                    <div
                      key={num}
                      className={`card-number${ticketNumber.includes(num)
                        ? ` number-selected ${mode}-lotto`
                        : ''
                        }`}
                      onClick={() => orderAndSet(num)}
                    >
                      <span>{num}</span>
                    </div>
                  ))}
                </div>
              ))
            : "Coming Soon..."}
        </section>

        <section className='results'>
          <div>
            <h2>Your Numbers</h2>
            <NumbersArea id='ticketNumbers'>
              {ticketNumber.map((g, i) => {
                return (
                  <div key={`ticketNumbers_${i}`}>
                    <span>{g}</span>
                    {!result.length && (
                      <div onClick={() => removeFromticketNumber(i)}>
                        <FiX size={12} color='tomato' />
                      </div>
                    )}
                  </div>
                )
              })}
            </NumbersArea>
          </div>

          <div id='buttons-wrapper'>
            <Button
              className={`action-button ${mode}-lotto`}
              onClick={() => playGame(mode)}
              disabled={
                ticketNumber.length !== maxNum ||
                result.length ||
                (!ticketNumber.length && !result.length)
              }
            >
              <FiPlayCircle /> Buy Ticket!
            </Button>

            <Button
              className={`action-button ${mode}-lotto`}
              onClick={reset}
              disabled={!result.length}
            >
              <FiRefreshCw /> Reset
            </Button>
          </div>
          {!result.length ? null : (
            <div>
              <h2>Results</h2>
              <NumbersArea id='results' array={result} />
            </div>
          )}
          {!result.length ? null : (
            <div>
              <h2>Matches</h2>
              {!result.length ? null : matches.length === 0 &&
                result.length > 0 ? (
                <p>You didn't match any number</p>
              ) : (
                <p>You matched the following numbers:</p>
              )}
              <NumbersArea id='matches' array={matches} />
            </div>
          )}

        </section>
      </main>
    </div>
  )
}

export default App
