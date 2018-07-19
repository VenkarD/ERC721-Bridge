sokol = "https://sokol.poa.network"
kovan = "https://kovan.infura.io/mew"
privateKey=123

abi_bridge = """[
	{
		"constant": false,
		"inputs": [
			{
				"name": "_owner",
				"type": "address"
			},
			{
				"name": "_tokenVIN",
				"type": "string"
			},
			{
				"name": "_serializedData",
				"type": "bytes"
			},
			{
				"name": "_txHash",
				"type": "bytes32"
			}
		],
		"name": "transferApproved",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": false,
				"name": "_tokenVIN",
				"type": "string"
			},
			{
				"indexed": false,
				"name": "_data",
				"type": "bytes"
			}
		],
		"name": "UserRequestForSignature",
		"type": "event"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_tokenVIN",
				"type": "string"
			}
		],
		"name": "TransferCompleted",
		"type": "event"
	}
]"""