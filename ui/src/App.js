import { useEffect } from 'react'
import { GiClover } from 'react-icons/gi'
import { FiX, FiRefreshCw, FiPlayCircle } from 'react-icons/fi'

import { MetaMaskConnect, useState } from './components/MM/MetaMaskConnect';
import Button from './components/Button'
import NumbersArea from './components/NumbersArea'
import { ContractObject, addNewTicket, getAvailableGames, getPlayerNumbers, getGameResult, getGameDrawDate } from './components/contract/ContractObject'

import './App.css'

const lotteryAddress = "0xeD54542F6CEbfaE00549541fB05E9a8adb388372"

function App() {
  const [nums, setNums] = useState([])
  const [ticketNumber, setticketNumber] = useState([])
  const [mode, setMode] = useState('ticket')
  const [result, setResult] = useState([])
  const [matches, setMatches] = useState([])
  const [maxNum, setMaxNum] = useState(0)
  const [currentGameId, setCurrentGameId] = useState(0)
  const [currentGameDrawDate, setCurrentGameDrawDate] = useState(0)
  const [availableGames, setAvailableGames] = useState([])
  const [gamePlayed, setGamePlayed] = useState(false)

  // Dropdown Item
  const [isOpen, setIsOpen] = useState(false);

  async function getGames() {
    // Set the DropDown for Games:
    ContractObject(lotteryAddress).then(lotteryContract => {
      getAvailableGames(lotteryContract, setAvailableGames)
    })
  }

  async function getResult() {
    // Set the DropDown for Games:
    ContractObject(lotteryAddress).then(lotteryContract => {
      getGameResult(lotteryContract, currentGameId, setResult)
    })
  }

  useEffect(() => {
    if (isOpen) {
      getGames()
      setIsOpen(false)
    }
  }, [isOpen]);




  // Function to handle the selection of a game to change the game id
  const handleGameIdChange = async event => {
    let gameId = event.target.value
    setCurrentGameId(gameId)

    // Set the Player Game:
    ContractObject(lotteryAddress).then(lotteryContract => {

      getGameDrawDate(lotteryContract, gameId, setCurrentGameDrawDate)
      getPlayerNumbers(lotteryContract, gameId, setticketNumber, setGamePlayed)

    })
    getResult()
  }

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

  const randomTicket = mode => {
    let length = 6
    let index = 49
    let arr = []

    const shuffle = () => {
      let num = Math.ceil(Math.random() * index)
      return arr.includes(num) ? shuffle() : num
    }
    while (arr.length < length) {
      let num = shuffle()
      arr.push(num)
    }

    setticketNumber(arr.sort((a, b) => a - b))
  }



  const playGame = mode => {
    let length = 6
    let index = 49
    let arr = []

    if (ticketNumber.length < length) return

    let hex_arr = BigInt("0xF000000000000000000000000000000000000000000000000000000000000000");
    let base = BigInt("0xF000000000000000000000000000000000000000000000000000000000000000");

    for (let i = 0; i < length; i++) {
      let bit_pos = ticketNumber[i] * 4
      let shifted = base >> BigInt(bit_pos);
      hex_arr = hex_arr | shifted;
      console.log(hex_arr.toString(16), ticketNumber, bit_pos, shifted.toString(16));
    }


    ContractObject(lotteryAddress).then(lotteryContract => {
      addNewTicket(lotteryContract, hex_arr, currentGameId)
    })

  }

  useEffect(() => {
    setMatches(ticketNumber.filter(num => result.includes(num)))
  }, [ticketNumber, result])

  const reset = () => {
    setticketNumber([])
    setResult([])
    setMatches([])
  }

  const ColoredLine = ({ color }) => (
    <hr
      style={{
        color: color,
        backgroundColor: color,
        height: 5
      }}
    />
  );

  return (
    <div className='App'>

      <section className='buttons-wrapper-top'>
        <Button
          className='mode-button ticket-lotto game-button-mode'
          onClick={() => setMode('ticket')}
        >
          <GiClover />
          Ticket
        </Button>

        <Button
          className='mode-button Results-lotto game-button-mode'
          onClick={() => setMode('Results')}
        >
          <GiClover />
          Results
        </Button>

        <Button
          className='mode-button About-lotto game-button-mode'
          onClick={() => setMode('About')}
        >
          <GiClover />
          About
        </Button>

        <MetaMaskConnect />


      </section>


      <main>
        <section className={mode ? `${mode}-lotto ticket-bar` : 'ticket-bar'}>

          <h1 className={mode ? `${mode}-lotto ticket-title` : ''}> <GiClover /> {mode} </h1>
          <ul className={mode ? `${mode}-lotto game-ids` : ''}>
            <li style={{
              listStyle: 'none'
            }}
            >
              {/* Dropdown to select the Game Id */}
              <select
                onChange={handleGameIdChange}
                onClick={() => setIsOpen(true)}
                className={'game-ids-select'}
              >
                <option disabled defaultValue value=''>Select a Game</option>
                {availableGames.map(i => (
                  <option key={i} value={i}>
                    {i}
                  </option>
                ))
                }
              </select>
            </li>
          </ul>

        </section>

        <section className='card'>
          {mode == 'ticket' || !mode
            ? ((
              <p>
                Some Error has Occurred...
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
          <div id='buttons-wrapper'>
            <Button
              className={`action-button game-button-random-result`}
              onClick={() => randomTicket(mode)}
              disabled={
                ticketNumber.length === maxNum ||
                gamePlayed
              }
            >
              <FiPlayCircle /> Random
            </Button>

            <Button
              className={`action-button game-button-random-result`}
              onClick={() => getResult()}

            >
              <FiPlayCircle /> Result
            </Button>
          </div>


          <div id='buttons-wrapper'>


            <Button
              className={`action-button game-button-buy-reset`}
              onClick={() => playGame(mode)}
              disabled={
                ticketNumber.length !== maxNum ||
                result.length === 6 || gamePlayed ||
                (!ticketNumber.length && !result.length)
              }
            >
              <FiPlayCircle /> Buy
            </Button>

            <Button
              className={`action-button game-button-buy-reset`}
              onClick={reset}
              disabled={
                gamePlayed
              }
            >
              <FiRefreshCw /> Reset
            </Button>

          </div>

          <div className="draw-block-div">
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

          <ColoredLine color="black" />

          <div className="draw-block-div">

            <h2>Draw Block</h2>
            <p className="draw-block-paragraph">
              {currentGameDrawDate}
            </p>
          </div>
          <ColoredLine color="black" />

          <div className="draw-block-div">
            <h2>Result</h2>

            {!result.length ? "Game Has Not Been Drawn" : (
              <NumbersArea id='results' array={result} />
            )}
          </div>
          <ColoredLine color="black" />

          {!result.length ? null : (
            <div className="draw-block-div">
              <h2 >Matches</h2>
              {!result.length ? null : matches.length === 0 &&
                result.length > 0 ? (
                <p>You didn't match any number</p>
              ) : (
                "")}
              <NumbersArea id='matches' array={matches} />
            </div>
          )}

        </section>
      </main>
    </div>
  )
}

export default App
