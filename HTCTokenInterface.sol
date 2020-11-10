pragma solidity >=0.5.0 <0.6.0;

contract ERC20Interface
{
    uint256 public totalSupply;
    string  public name;
    uint8   public decimals;
    string  public symbol;
    
    //ERC20接口
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    
    //事件
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    /// 只有合约可以调用的内部API
    function ZhuanZhang(address _from, address _to, uint256 _value) external;
    
    function JiHuo() external;
    function HadJihuo( address ownerAddr ) external view returns (bool);
}

 