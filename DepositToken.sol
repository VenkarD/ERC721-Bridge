pragma solidity ^0.4.24;
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
        uint deposiAmount;
        uint percentAmount;
    }
        uint depositCount=0;//колличество вкладоы
        address dev;
        uint[] book;
    mapping (uint => depositStruct) public depositList; //создание словаря где ключ id токена, а значение список параметров
    mapping(address=>bool) isBank;// только банки могут открывать и закрывать вклады
    mapping(address =>uint[]) UserWallet;

    event Transfer(address, address, address);//здесь устал писать коментарии
    event CreateDeposit(uint, uint, uint ,address);
    
    function createDeposit(uint _percent,uint _depositTime, uint _money) public //открытие вклада
    {
        depositCount++;
        uint id = depositCount;
        isBank[msg.sender] ==true;
        uint timeNow =0;
        depositList[id] = depositStruct({demolished: false, owner: msg.sender, percent: _percent, startDate:timeNow, depositTime:_depositTime, deposiAmount:_money, percentAmount:0});
        UserWallet[msg.sender].push(id);
        emit CreateDeposit(_percent,timeNow,_depositTime,  msg.sender);
    }
    
    function transfer(address _to, uint _tokenId) public{ //передача вклада
        require(depositList[_tokenId].owner == msg.sender||depositList[_tokenId].demolished!=true);
    { //если условие не выполнится будет revert(), т.е откат назад
                depositList[_tokenId].owner = _to;
                UserWallet[msg.sender].delete()
                emit Transfer(msg.sender, _to, depositList[_tokenId].owner);
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
                transfer(_to, _tokenId);

            }
        }
    
    function demolish(uint _tokenId) public{//закрытие вклада
        require(depositList[_tokenId].owner == msg.sender);//проверка на владельца
        depositList[_tokenId].demolished=true;
    }
    function registerVendor(address _bank) public
    {//registering a new vendor
        require(dev==msg.sender);//if sender is dev
        isBank[_bank]=true;//giving permisson to create phones for a new vendor
    }
    function getSumm(uint _summ,uint _percent, uint _startDate) public view returns(uint)
    {
       uint n=(now-_startDate)/2592000;
       return _summ * (1+(_percent / 12) /100 )**n;
    }
    function Time_call() public view returns (uint){
        return now;
    }
    function getTokenId(uint _num)public view returns(uint)
    {
        uint tkId=UserWallet[msg.sender][_num];
        return tkId;
    }
    function balanceOf() public view returns(uint)
    {
        return UserWallet[msg.sender].length;
    }
    function ownerOf(uint _tokenId) public view returns (address){
            return depositList[_tokenId].owner;
    }
    function isContract(address addr) public view returns (bool) {
      uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
    
    }
    function setPercent(uint _tokenId, uint _percent){
        depositList[_tokenId].percent=_percent;
    }
    function indexOfId(uint _tokenId)
    {
        //for(uint i=0; )
    }
    function setBank() public //установка пользователя банком 
    {
     if (msg.sender==dev)
     {
         isBank[msg.sender]=true;
     }
    }
}
