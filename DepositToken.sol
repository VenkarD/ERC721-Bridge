pragma solidity ^0.4.24;
//Токен 
contract Config {
    function onERC721Received(address,address,uint,bytes) public returns (address adr);
    function lookup(uint id) public returns (address adr);
}
contract depositToken {
    
    struct depositStruct { //создание параметров вклада
        bool demolished; //закрытие вклада
        address owner;//владелец вклада
        uint percent;//процент вклада
        uint startDate;//дата начала вклада
        uint depositTime;//время вклада
        uint depositAmount;//начисленная сумма
        uint percentAmount;//начисленный процент
    }
        uint depositCount=0;//колличество вкладоы
        address dev;//адрес разработчика, для добавления новых банков
        uint[] book;
        
    mapping (uint => depositStruct) public depositList; //создание словаря где ключ id токена, а значение список параметров
    mapping(address=>bool) isBank;// только банки могут открывать и закрывать вклады
    mapping(address =>uint[]) UserVallet;//кошелек пользователя

    event Transfer(address, address, address);//здесь устал писать коментарии
    event CreateDeposit(uint, uint, uint ,address);
    
    function createDeposit(uint _percent,uint _depositTime, uint _money) public //открытие вклада
    {
        depositCount++;
        uint id = depositCount;
        isBank[msg.sender] ==true;
        uint timeNow =0;
        depositList[id] = depositStruct({demolished: false, owner: msg.sender, percent: _percent, startDate:timeNow, depositTime:_depositTime, depositAmount:_money, percentAmount:0});
        UserVallet[msg.sender].push(id);
        emit CreateDeposit(_percent,timeNow,_depositTime,  msg.sender);
    }
    
    function transfer(address _to, uint _tokenId) public{ //передача вклада
        require(depositList[_tokenId].owner == msg.sender||depositList[_tokenId].demolished!=true);
    { //если условие не выполнится будет revert(), т.е откат назад
                depositList[_tokenId].owner = _to;
                emit Transfer(msg.sender, _to, depositList[_tokenId].owner);
            }
    }
    function transfer(address _from, address _to, uint _tokenId) public{
     require(depositList[_tokenId].owner == _from||depositList[_tokenId].demolished!=true);
    { //если условие не выполнится будет revert(), т.е откат назад
                depositList[_tokenId].owner = _to;
                delTokenVallet(_tokenId);
                emit Transfer(msg.sender, _to, depositList[_tokenId].owner);
                //удаление токена из кошелька
            }
    }
        function safeTransferFrom(address _from , address _to, uint _tokenId, bytes data) external payable
        {
            if (isContract(_to))
            {
                Config toContract = Config(_to);
                transfer(_to, _tokenId);

                toContract.onERC721Received(_from,  _to,  _tokenId,  data);
            }
            else{
                transfer(_from,_to, _tokenId);
                
            }
        }
    
    function demolish(uint _tokenId) public{//закрытие вклада
        require(depositList[_tokenId].owner == msg.sender);//проверка на владельца
        //будет ли токен терять владельца
        delTokenVallet(_tokenId);
        depositList[_tokenId].demolished=true;
    }
    function registerVendor(address _bank) public
    {//registering a new vendor
        require(dev==msg.sender);//if sender is dev
        isBank[_bank]=true;//giving permisson to create phones for a new vendor
    }
    function getSumm(uint _summ,uint _percent, uint _startDate) public view returns(uint)
    {
       uint n=(now-_startDate)/2592000; // изменить
       return _summ * (1+(_percent / 12) /100 )**n; // изменить 
    }
    function Time_call() public view returns (uint){
        return now;
    }
    function getTokenId(uint _num)public view returns(uint)
    {
        uint tkId=UserVallet[msg.sender][_num];
        return tkId;
    }
    function balanceOf() public view returns(uint)
    {
        return UserVallet[msg.sender].length;
    }
    function ownerOf(uint _tokenId) public view returns (address){
            return depositList[_tokenId].owner;
    }
    function isContract(address addr) public view returns (bool) {
      uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
    }
    
    function delTokenVallet(uint _tokenId) private
    {
        require(depositList[_tokenId].owner == msg.sender);
        delete UserVallet[msg.sender][getTokenId(_tokenId)];
    }
    function setBank() public //установка пользователя банком 
    {
     if (msg.sender==dev)
     {
         isBank[msg.sender]=true;
     }
    }
    function uintToBytes(uint x) returns (bytes b) {
    b = new bytes(32);
    assembly { mstore(add(b, 32), x) }
}
    function stringToBytes(string memory source) returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
        return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
}
    function getSerializedData(uint _tokenId) public view returns(bytes32[])
    {
        bytes32 myData;
        myData.push(depositStruct.)
            
    }
    
}
