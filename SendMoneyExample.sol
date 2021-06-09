// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.1;

contract SendMoneyExample{
    
    function receiveMoney() public payable{
        
    }
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
    function withdrawMoney() public{
        address payable to=payable(msg.sender);
        to.transfer(getBalance());
    }
}