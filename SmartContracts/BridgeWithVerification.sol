pragma solidity ^0.4.24;

contract ERC721 {
    function getSerializedData(uint _tokenId) public returns (bytes32[6]);
    function recoveryToken(address _owner, uint _tokenId, bytes32[6] _serializedData) public;
}


contract BasicBridge {
    mapping(bytes32 => bool) public AcceptedRrequests;
    mapping (bytes32 => bool) internal transferCompleted;
    mapping(bytes32 => uint) public countTransactions;
    
    address[] authorizedBridge;
    event UserRequestForSignature(address _from, uint _tokenId, bytes32[6] _data);

    event TransferCompleted(uint _tokenId);

    ERC721 ERC721Contract;
    
    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

    function transferApproved(address _owner, uint _tokenId, bytes32[6] _serializedData, bytes32 txhash ) public {
        require(transferCompleted[txhash]==false);
       require(isBridge(msg.sender));
        require(AcceptedRrequests[keccak256(msg.sender,txhash)]==false);

        countTransactions[txhash]++;
        AcceptedRrequests[keccak256(msg.sender,txhash)]=true;

        if (countTransactions[txhash]>3)
        {
         transferCompleted[txhash]=true;
        ERC721Contract.recoveryToken(_owner, _tokenId, _serializedData);
        emit TransferCompleted(_tokenId);
       }
    }
   
     function isBridge(address _authority) internal view returns (bool) {
        for (uint i = 0; i < authorizedBridge.length; i++) {
            if (_authority == authorizedBridge[i]) {
                return true;
            }
        }
        return false;
    }
}


contract ForeignBridge is BasicBridge {
    constructor(address _contract) public {
        ERC721Contract = ERC721(_contract);
    }

    function onERC721Received(
        address _from,
        address _owner,
        uint _tokenId,
        bytes32[6] _data
    ) public returns(bytes4) {
        bytes32[6] memory data = ERC721(msg.sender).getSerializedData(_tokenId);
        emit UserRequestForSignature(_from, _tokenId, data);
        return ERC721_RECEIVED;
    }
}

contract HomeBridge is BasicBridge {
    constructor(address _contract) public {
        ERC721Contract = ERC721(_contract);
    }

    function onERC721Received(
        address _from,
        address _owner,
        uint _tokenId,
        bytes32[6] _data
    ) public returns(bytes4) {
        bytes32[6] memory data = ERC721(msg.sender).getSerializedData(_tokenId);
        emit UserRequestForSignature(_from, _tokenId, data);
        return ERC721_RECEIVED;
    }
}
