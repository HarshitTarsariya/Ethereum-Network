//SPDX-License-Identifier: MIT

pragma solidity 0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance is Ownable{
     mapping(address=>uint) allowance;

    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }
    function addAllowance(address _to,uint _amount) public onlyOwner{
        allowance[_to]=_amount;    
    }
    modifier ownerorAllowance(uint _amount){
        require(isOwner() || allowance[msg.sender] >= _amount,"You donot have access to withdraw this much amount of value");
        _;
    }
    function reduceAllowance(address _of,uint _amount) public{
        allowance[_of]-=_amount;
    }
}

contract SharedWallet is Allowance{
    
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
        
    receive() external payable{
        emit MoneyReceived(msg.sender,msg.value);
    }
    
    function withdrawMoney(address payable _to,uint _amount) public ownerorAllowance(_amount){
        require(_amount<=address(this).balance,"contract doesn't have enough funds");
        if(!isOwner()){
            reduceAllowance(msg.sender,_amount);
        }
        emit MoneySent(_to,_amount);
        _to.transfer(_amount);
    }
    function renounceOwnership() view public override onlyOwner{
        revert("Removing Ownership is not available in this Wallet");
    }
}