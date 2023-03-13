function lotteryAbi() { 
  return  [
    {
      "inputs": [],
      "name": "DrawCanOnlyBeInTheFuture",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "DrawDateHasNotPassed",
      "type": "error"
    },
    {
      "inputs": [],
      "name": "StartOrEndValueIncorrect",
      "type": "error"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "internalType": "address",
          "name": "player",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "bytes32",
          "name": "numbers",
          "type": "bytes32"
        },
        {
          "indexed": true,
          "internalType": "uint32",
          "name": "gameId",
          "type": "uint32"
        }
      ],
      "name": "NewTicketAdded",
      "type": "event"
    },
    {
      "inputs": [],
      "name": "TS_OFFSET",
      "outputs": [
        {
          "internalType": "uint40",
          "name": "",
          "type": "uint40"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint40",
          "name": "drawDate",
          "type": "uint40"
        }
      ],
      "name": "addGame",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "ticketBytes",
          "type": "bytes32"
        },
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "addPlayerTickets",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "addwinningTicket",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "player",
          "type": "address"
        },
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "checkWinner",
      "outputs": [
        {
          "internalType": "bool",
          "name": "result",
          "type": "bool"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "drawDate",
      "outputs": [
        {
          "internalType": "uint64",
          "name": "result",
          "type": "uint64"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "drawResultFull",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "result",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "drawResultNumbers",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "result",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "gameId",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getAllGames",
      "outputs": [
        {
          "internalType": "bytes32[]",
          "name": "",
          "type": "bytes32[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_player",
          "type": "address"
        }
      ],
      "name": "getAllGamesOfPlayer",
      "outputs": [
        {
          "internalType": "bytes32[]",
          "name": "",
          "type": "bytes32[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint32",
          "name": "start",
          "type": "uint32"
        },
        {
          "internalType": "uint32",
          "name": "end",
          "type": "uint32"
        }
      ],
      "name": "getGamesPagniate",
      "outputs": [
        {
          "internalType": "bytes32[]",
          "name": "",
          "type": "bytes32[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_player",
          "type": "address"
        },
        {
          "internalType": "uint32",
          "name": "_gameId",
          "type": "uint32"
        }
      ],
      "name": "playerNumbers",
      "outputs": [
        {
          "internalType": "bytes32",
          "name": "numbers",
          "type": "bytes32"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "bytes32",
          "name": "ticket",
          "type": "bytes32"
        }
      ],
      "name": "ticketsInPlay",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "numberOfTickets",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ]
}

export {lotteryAbi}