
// Import the ethers library
import { ethers } from 'ethers'
import { lotteryAbi } from './abi/LotteryAbi'

const addNewTicket = async (pairContract, ticketNumbers, gameId) => {
  try {

    console.log(`HELLLLLLO  ${ethers.toBeArray(ticketNumbers)}`)

    let ticket = ethers.toBeArray(ticketNumbers)
    console.log(ticket, ticketNumbers)

    

    let addedTicket = await pairContract.addPlayerTickets(
      ticket,
      gameId
    )

    console.log(pairContract, ticketNumbers, gameId)

    const receipt = await addedTicket.wait()
    const createdEvent = receipt.events?.filter(x => {
      return x.event == 'NewTicketAdded'
    })
    let ce = createdEvent[0].args
    console.log(
      `New Ticket Created By: ${ce.player}\Numbers: ${ce.numbers}\Game Id: ${ce.gameId}`
    )
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
    const Contract = new ethers.Contract(
      address,
      abi,
      signer
    )
    return Contract

  } catch (error) {
    // Handle errors
    // console.error(error)
    return 0
  }
}

export  {ContractObject, addNewTicket}
