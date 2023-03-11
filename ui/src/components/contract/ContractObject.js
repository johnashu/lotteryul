// Pull in the shims (BEFORE importing ethers)
import '@ethersproject/shims'
// Import the ethers library
import { ethers } from 'ethers'
import { lotteryAbi } from '../abi/LotteryAbi'

const ContractObject = async (address) => {
  try {
    // Get the provider and signer from the browser window
    var provider = new ethers.providers.Web3Provider(window.ethereum)
    // MetaMask requires requesting permission to connect users accounts
    const signer = provider.getSigner()

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

export default ContractObject
