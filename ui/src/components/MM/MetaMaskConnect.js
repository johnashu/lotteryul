// https://www.npmjs.com/package/metamask-react
import './MetaMask.css'
import { useState } from 'react'
// // Import the ethers library
import { ethers } from 'ethers'
import { useConnectedMetaMask, useMetaMask } from 'metamask-react'


const BASE_DECIMALS = 4
const NATIVE_SYMBOL = 'ONE'
const NATIVE_CHAIN_ID = '0x63564c40' //Harmony
const LOCAL_ID = '0x7a69' // local 31337
const CHAIN_NAME = 'Harmony ONE Mainnet'

function getSetBalance(address, setBalance) {
  window.ethereum
    .request({
      method: 'eth_getBalance',
      params: [address, 'latest']
    })
    .then(balance => {
      // Return string value to convert it into int balance
      const fBalance = ethers.formatEther(balance)
      setBalance(fBalance)
      return fBalance
      // Format the string into main latest balance
    })
}


function ConnectedMM() {
  const [balance, setBalance] = useState(0)
  const {
    // typed as string - can not be null
    account,
    // typed as string - can not be null
    chainId,
    ethereum
  } = useConnectedMetaMask();

  getSetBalance(account, setBalance)

  const truncatedAddress = `${account.substring(0, 6)}...${account.substring(38)}`;

  return (

    <div className="wallet-button" onClick={() => ethereum.enable()}>
      <div className={`connected-dot connected `} /> {truncatedAddress}
      <br />{Math.round(balance * 10 ** BASE_DECIMALS) / 10 ** BASE_DECIMALS}  {NATIVE_SYMBOL}
    </div>
  );


}

// function WrongNetwork(chainId) {
//   const { switchChain } = useMetaMask()
//   // Request a switch to Ethereum Mainnet
//   return (<div className="wallet-button" onClick={() => switchChain(chainId)}>
//     <div className={`connected-dot disconnected `} /> Switch to {CHAIN_NAME}
//   </div>);

// }


const MetaMaskConnect = () => {

  const { status, chainId, connect } = useMetaMask()
  // console.log(status, account, chainId, ethereum )

  // Sends MM wild :P
  // if (chainId !== NATIVE_CHAIN_ID && chainId !== LOCAL_ID) {
  //   return WrongNetwork(NATIVE_CHAIN_ID)
  // }

  if (status === 'initializing')
    return <div className="wallet-button">Synchronising...</div>

  if (status === 'unavailable') return <div className="wallet-button"> <div className={`connected-dot disconnected `} /> MetaMask not available :(</div>

  if (status === 'notConnected')
    return (<div className="wallet-button" onClick={connect}>
      <div className={`connected-dot disconnected `} /> Connect
    </div>);

  if (status === 'connecting') return <div className="wallet-button"> <div className={`connected-dot connecting `} />  Connecting...</div>

  if (status === 'connected') return ConnectedMM()
}


export { MetaMaskConnect, useState }
