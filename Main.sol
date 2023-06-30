// The ERC-20 Token contract that is being bought and sold
contract MyToken {
  mapping(address => uint) balances;
  uint public totalSupply;
  
  constructor(uint _initialSupply) {
    balances[msg.sender] = _initialSupply;
    totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] >= _value);
    require(_to != address(0));
    
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    
    return true;
  }
  
  function balanceOf(address _owner) public view returns (uint) {
    return balances[_owner];
  }
}

// The smart contract for buying and selling MyToken
contract MyTokenMarketplace {
  MyToken public tokenContract;
  uint public tokenPrice;
  address public owner;

  constructor(MyToken _tokenContract, uint _tokenPrice) {
    tokenContract = _tokenContract;
    tokenPrice = _tokenPrice;
    owner = msg.sender;
  }

  function buyTokens(uint _numberOfTokens) public payable {
    uint totalCost = _numberOfTokens * tokenPrice;
    require(msg.value == totalCost);

    uint currentBalance = tokenContract.balanceOf(address(this));
    require(_numberOfTokens <= currentBalance);

    tokenContract.transfer(msg.sender, _numberOfTokens);

    owner.transfer(msg.value);
  }

  function sellTokens(uint _numberOfTokens) public {
    uint totalValue = _numberOfTokens * tokenPrice;

    require(tokenContract.balanceOf(msg.sender) >= _numberOfTokens);

    tokenContract.transferFrom(msg.sender, address(this), _numberOfTokens);

    msg.sender.transfer(totalValue);
  }
}

