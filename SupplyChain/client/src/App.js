import React, { Component } from "react";
import ItemManagerContract from "./contracts/ItemManager.json";
import getWeb3 from "./getWeb3";
import ItemContract from './contracts/Item.json'
import "./App.css";

class App extends Component {
  state = {loaded:false,identifier:"",price:0};
  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      this.web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      this.accounts = await this.web3.eth.getAccounts();

      // Get the contract instance.
      this.networkId = await this.web3.eth.net.getId();
      
      this.itemManager = new this.web3.eth.Contract(
        ItemManagerContract.abi,
        ItemManagerContract.networks[this.networkId] && ItemManagerContract.networks[this.networkId].address,
      );
      this.item=new this.web3.eth.Contract(
        ItemContract.abi,
        ItemContract.networks[this.networkId] && ItemContract.networks[this.networkId].address,
      );
      this.listenToPayment();
      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({loaded:true});
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };
  listenToPayment=()=>{
    let self=this;
    this.itemManager.events.SupplyChainStep().on("data",async(event)=>{
      let itemo=await this.itemManager.methods.items(event.returnValues._index).call();
      // console.log(event);
      alert("Item "+itemo._identifier+ " was successfully paid and order is Placed");
    })
  };
  handleSubmit=async ()=>{
    const {price,identifier}=this.state;
    let result=await this.itemManager.methods.createItem(identifier,price).send({from:this.accounts[0]});
    console.log(result);
    alert("Send "+price+" Wei to "+result.events.SupplyChainStep.returnValues._address);
  }
  render() {
    if (!this.state.loaded) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Supply Chain!</h1>
        <h2>Add Items</h2>
        <div>
          <div>Add Text:<input type="text" value={this.state.identifier} onChange={(e)=>{this.setState({identifier:e.target.value})}}/></div>
          <div>Price in Wei:<input type="number" value={this.state.price} onChange={(e)=>{this.setState({price:e.target.value})}}/></div>
          <input type="button" onClick={this.handleSubmit} value="Add It"/>
        </div>
      </div>
    );
  }
}

export default App;
