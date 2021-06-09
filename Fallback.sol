// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

//using receive() to send ether and fallback() to interact without sending ether
//fallbback functions are generally external as they are accessed from outside of contract

contract Fallback{
    mapping(address => uint) public balanceReceived;

    function receiveMoney() public payable {
        assert(balanceReceived[msg.sender] + msg.value >= balanceReceived[msg.sender]);
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "not enough funds.");
        assert(balanceReceived[msg.sender] >= balanceReceived[msg.sender] - _amount);
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    } 

    // receive() external payable {
    //     receiveMoney();
    // }    
}