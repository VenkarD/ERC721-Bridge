pragma solidity ^0.4.24;

contract ERC721 {
    function getSerializedData(uint _tokenId) public returns (bytes32[6]);
    function recoveryToken(address _owner, uint _tokenId, bytes32[6] _serializedData) public;
}


contract BasicBridge {
    event UserRequestForSignature(address _from, uint _tokenId, bytes32[6] _data);

    event TransferCompleted(uint _tokenId);

    ERC721 ERC721Contract;
    
    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

    function transferApproved(address _owner, uint _tokenId, bytes32[6] _serializedData) public {
        ERC721Contract.recoveryToken(_owner, _tokenId, _serializedData);
        emit TransferCompleted(_tokenId);
    }
}

contract ForeignBridge is BasicBridge {
    constructor(address _contract) public {
        ERC721Contract = ERC721(_contract);
    }

    function onERC721Received(address _from,address _owner,uint _tokenId,bytes32[6] _data) public returns(bytes4) {
        bytes32[6] memory data = ERC721(msg.sender).getSerializedData(_tokenId);
        emit UserRequestForSignature(_from, _tokenId, data);
        return ERC721_RECEIVED;
    }
}

contract HomeBridge is BasicBridge {
    constructor(address _contract) public {
        ERC721Contract = ERC721(_contract);
    }

    function onERC721Received(address _from,address _owner,uint _tokenId,bytes32[6] _data) public returns(bytes4) {
        bytes memory data = ERC721(msg.sender).getSerializedData(_tokenId);
        emit UserRequestForSignature(_from, _tokenId, data);
        return ERC721_RECEIVED;
    }
}
