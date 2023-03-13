
// Import the ethers library
import { ethers } from 'ethers'
import { lotteryAbi } from './abi/LotteryAbi'

const getGameResult = async (lotteryContract, gameId, setResult) => {
  try {
    let numbers = await lotteryContract.drawResultNumbers(gameId)

    let hex_str = numbers.toString(16).toUpperCase() // convert BigInt to hex string
    let positions = [];

    for (let i = 3; i < hex_str.length; i++) {
      if (hex_str[i] === "F") {
        positions.push(parseInt(i - 2)); // convert "F" to integer and add to array

      }
    }

    console.log(gameId, positions, numbers)
    setResult(positions)

  } catch (error) {
    // Handle errors
    console.error(error)
    return 0
  }
}


const getAvailableGames = async (lotteryContract, setAvailableGames) => {
  try {
    let games = await lotteryContract.getAllGames()

    let positions = [];

    for (let i = 0; i < games.length; i++) {
      positions.push(i + 1)
    }
    console.log(positions)
    await setAvailableGames(positions)


  } catch (error) {
    // Handle errors
    console.error(error)
    return 0
  }
}

const getGameDrawDate = async (lotteryContract, gameId, setCurrentGameDrawDate) => {
  try {
    let drawDate = await lotteryContract.drawDate(gameId)
    console.log(drawDate)
    await setCurrentGameDrawDate(drawDate.toString(10))

  } catch (error) {
    // Handle errors
    console.error(error)
    return 0
  }
}

const getPlayerNumbers = async (lotteryContract, _gameId, _setticketNumber, _setGamePlayed) => {
  try {
    let _player = await window.ethereum.request({method: 'eth_requestAccounts'})
    console.log(_player)

    let numbers = await lotteryContract.playerNumbers(_player[0], _gameId)


    console.log(_gameId, numbers, _player[0])

    let hex_str = numbers.toString(16).toUpperCase() // convert BigInt to hex string
    let positions = [];

    for (let i = 3; i < hex_str.length; i++) {
      if (hex_str[i] === "F") {
        positions.push(parseInt(i - 2)); // convert "F" to integer and add to array

      }
    }

    if (positions.length !== 0) {
      await _setGamePlayed(true)

    } else _setGamePlayed(false)

    await _setticketNumber(positions)

  } catch (error) {
    // Handle errors
    console.error(error)
    return 0
  }
}

const addNewTicket = async (lotteryContract, ticketNumbers, gameId) => {
  try {

    let ticket = ethers.toBeArray(ticketNumbers)


    let addedTicket = await lotteryContract.addPlayerTickets(
      ticket,
      gameId
    )

    // Begin listening for any Transfer event
    lotteryContract.on("NewTicketAdded", (player, ticket, gameId, event) => {
      console.log('EVENTS!!!')
      // The `event.log` has the entire EventLog
      console.log(player, ticket, gameId, event)

    });

    // const receipt = await addedTicket.wait()

    // console.log(receipt)

    // // console.log(receipt.events[0].value.inputs[0])

    // const receipt = await addedTicket.wait()
    // const createdEvent = receipt.events?.filter(x => {
    //   return x.event == 'NewTicketAdded'
    // })


    // let ce = createdEvent
    // console.log(ce)
    // console.log(
    //   `New Ticket Created By: ${ce.player}\Numbers: ${ce.numbers}\Game Id: ${ce.gameId}`
    // )


  } catch (error) {
    // Handle errors
    console.error(error)
    return 0
  }
}

const ContractObject = async (address) => {
  let signer = null;

  let provider;

  try {
    if (window.ethereum == null) {

      // If MetaMask is not installed, we use the default provider,
      // which is backed by a variety of third-party services (such
      // as INFURA). They do not have private keys installed so are
      // only have read-only access
      console.log("MetaMask not installed; using read-only defaults")
      provider = ethers.getDefaultProvider()

    } else {

      // Connect to the MetaMask EIP-1193 object. This is a standard
      // protocol that allows Ethers access to make all read-only
      // requests through MetaMask.
      provider = new ethers.BrowserProvider(window.ethereum)

      // It also provides an opportunity to request access to write
      // operations, which will be performed by the private key
      // that MetaMask manages for the user.
      signer = await provider.getSigner();
    }

    var abi = lotteryAbi()

    // // The Contract object
    const contract = new ethers.Contract(
      address,
      abi,
      signer
    )

    return contract

  } catch (error) {
    // Handle errors
    // console.error(error)
    return 0
  }


}

export { ContractObject, addNewTicket, getAvailableGames, getPlayerNumbers, getGameResult, getGameDrawDate }
