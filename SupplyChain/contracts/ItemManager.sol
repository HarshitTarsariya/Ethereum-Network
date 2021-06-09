// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{
    event SupplyChainStep(uint _index,uint _step,address _address);
    enum SupplyChainSteps{CREATED,PAID,DELIVERED}
    
    struct S_Item{
        Item _item;
        SupplyChainSteps _step;
        string _identifier;
        uint _priceInWei;
    }   
    uint index;
    mapping(uint=>S_Item) public items;
    function createItem(string memory _identifier,uint _priceInWei) public onlyOwner{
        Item item=new Item(this,_priceInWei,index);
        items[index]._identifier=_identifier;
        items[index]._priceInWei=_priceInWei;
        items[index]._step=SupplyChainSteps.CREATED;
        items[index]._item = item;
        emit SupplyChainStep(index,uint(items[index]._step),address(item));
        index+=1;   
        
    }
    
    function triggerPayment(uint _index) public payable{
        Item item=items[_index]._item;
        require(items[_index]._priceInWei<=msg.value,"Payment should be full");
        require(items[_index]._step==SupplyChainSteps.CREATED,"Already Paid and is in shipment");
        items[_index]._step=SupplyChainSteps.PAID;
    
        emit SupplyChainStep(index,uint(items[_index]._step),address(item));
    }   
    function triggerDelivery(uint _index) public onlyOwner{
        Item item = items[_index]._item;
        require(items[_index]._step==SupplyChainSteps.PAID,"Customer has not paid!");
        items[_index]._step=SupplyChainSteps.DELIVERED;
        
        emit SupplyChainStep(index,uint(items[_index]._step),address(item));
    }
}