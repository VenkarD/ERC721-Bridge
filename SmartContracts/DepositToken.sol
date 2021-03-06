    pragma solidity ^0.4.24;
//Токен 
contract Bridge {
    function onERC721Received(address,address,uint,bytes) public returns (bytes4);
    function lookup(uint id) public returns (address adr);
}
contract mainContract {
    
    struct depositStruct { //создание параметров вклада
        bool demolished; //закрытие вклада
        address owner;//владелец вклада
        uint percent;//процент вклада
//uint startDate;//дата начала вклада
        uint AmStock;//колличество акций
        uint StockPrice;//начальная стоимость акций
        uint CurentAmount;//стоимость акций сейчас 
        
    }
        uint changepercent = 15;
        uint depositCount=0;//колличество вкладоы
        address dev;//адрес разработчика, для добавления новых банков
        uint[] book;
        
         bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
        
    mapping (uint => depositStruct) public depositList; //создание словаря где ключ id токена, а значение список параметров
    mapping(address=>bool) isBank;// только банки могут открывать и закрывать вклады
    mapping(address =>uint[]) UserVallet;//кошелек пользователя
    mapping(address =>bool) isBridge;
    mapping (uint => uint) countTransaction;

    event Transfer(address, address, address);//здесь устал писать коментарии
    event CreateDeposit(uint, uint, uint ,address);
    event TokenRecovered(uint _tokenId, address _owner);

    //Базовые функции
    function createDeposit(uint _percent,uint _amstock, uint _money) public //открытие вклада
    {
        depositCount++;
        uint id = depositCount;
        //require(isBank[msg.sender] ==true);
        uint timeNow =0;
        depositList[id] = depositStruct({demolished: false, owner: msg.sender, percent: _percent, AmStock:_amstock, StockPrice:_money, CurentAmount:0});
        UserVallet[msg.sender].push(id);
        emit CreateDeposit(_percent,timeNow,_amstock,  msg.sender);
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
                UserVallet[_to].push(_tokenId);
                emit Transfer(msg.sender, _to, depositList[_tokenId].owner);
                //удаление токена из кошелька
            }
    }
        function safeTransferFrom(address _from , address _to, uint _tokenId, bytes data) external payable
        {
            if (isContract(_to))
            {
                Bridge toContract = Bridge(_to);
                transfer(_to, _tokenId);

                bytes4 retval = toContract.onERC721Received(_from,  _to,  _tokenId,  data);
                require (retval == ERC721_RECEIVED);
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
        depositCount-=1;
    }
    function registerVendor(address _bank) public
    {//registering a new vendor
        require(dev==msg.sender);//if sender is dev
        isBank[_bank]=true;//giving permisson to create phones for a new vendor
    }
    //функции для разных расчетов токена
    function getSum(uint _tokenId) public view returns(uint)
    {
        return depositList[_tokenId].AmStock*(depositList[_tokenId].StockPrice*(1+(changepercent / 100)));    
        
    }
    //
    //функции для работы с кошельком токенов
    //Получение ида токена по его номеру в кошельке
    function getTokenId(uint _num)public view returns(uint)
    {
        uint tkId=UserVallet[msg.sender][_num];
        return tkId;
    }
    function getTokenNum(uint _tokenId, address val) private view returns(uint)
    {
        for(uint i=0;i<UserVallet[val].length;i++)
        {
            if (UserVallet[val][i]==_tokenId)
                return i;
        }
    }
    //вывод колличества токенов в кошельке  
    function balanceOf() public view returns(uint)
    {
        return UserVallet[msg.sender].length;
    }
    //Получение владельца токена
    function ownerOf(uint _tokenId) public view returns (address){
            return depositList[_tokenId].owner;
    }
    function delTokenVallet(uint _tokenId) private
    {
        require(depositList[_tokenId].owner == msg.sender);
        remove(getTokenNum(_tokenId,msg.sender));
    }
     function setBank() public //установка пользователя банком 
    {
     if (msg.sender==dev)
     {
         isBank[msg.sender]=true;
     }
    }
  
    function getInformationToken(uint _tokenId)public view returns(uint,uint,uint)
    {
        return (depositList[_tokenId].percent,depositList[_tokenId].AmStock,depositList[_tokenId].CurentAmount);
    }
    function isContract(address addr) public view returns (bool) {
      uint size;
    assembly { size := extcodesize(addr) }
    return size > 0;
    }
    // функции преобразования
   function BytesToUint(bytes32 b) public pure returns(uint)
   {
       return uint(b);
   }
   function BoolToBytes(bool a) public pure returns (bytes32)
   {
       if(a==false) {
           return bytes32(0);
       }
       else
       {
           return bytes32(1);
       }
   }
   function BytesToBool(bytes32 a) public pure returns(bool)
   {
       if (a==bytes32(0))
       {
           return true;
       }
       else 
       {
           return false;
       }
   }
    function getSerializedData(uint _tokenId) public view returns(bytes32[6])
    {
        bytes32[6] memory myData; 
        myData[0]=(BoolToBytes(depositList[_tokenId].demolished)); //закрытие вклада
        myData[1]=bytes32(depositList[_tokenId].owner);
        myData[2]=(bytes32(depositList[_tokenId].percent));
        myData[3]=(bytes32(depositList[_tokenId].AmStock));
        myData[4]=(bytes32(depositList[_tokenId].StockPrice));
        myData[5]=(bytes32(depositList[_tokenId].CurentAmount));
        return myData;
    }
    function deserealizeData(bytes32[6] _data) public pure returns(bool,address,uint,uint, uint,uint)
    {
     return (false, address(_data[1]),uint(_data[2]),uint(_data[3]),uint(_data[4]),uint(_data[5]));
    }
    function recoveryToken( uint _tokenId,bytes32[6] _data) public
    {
        //Вот тут проверки будутит))))
        require(isBridge[msg.sender]);
        //require(verificationTransaction());
        uint percent;
        uint AmStock;
        uint StockPrice;
        uint CurentAmount;
        bool demolished;
        address owner;
        (demolished, owner, percent,AmStock,StockPrice,CurentAmount) = deserealizeData(_data); 
        depositList[_tokenId]= depositStruct({demolished: false, owner: owner, percent: percent, AmStock:AmStock, StockPrice:StockPrice, CurentAmount:CurentAmount});
        emit TokenRecovered(_tokenId, owner);
        
    }
    function setPercent(uint _changepercent) public
    {
        changepercent=_changepercent;
    }
    function SetPermissionsToRecovery(address _address) public
    {
        require(msg.sender==dev);
        
        isBridge[_address]=true;
        
        
    }
    function remove(uint index) public {
        if (index >= UserVallet[msg.sender].length) return;

        for (uint i = index; i<UserVallet[msg.sender].length-1; i++){
            UserVallet[msg.sender][i] = UserVallet[msg.sender][i+1];
        }
        delete UserVallet[msg.sender][UserVallet[msg.sender].length-1];
        UserVallet[msg.sender].length--;
    }

}
