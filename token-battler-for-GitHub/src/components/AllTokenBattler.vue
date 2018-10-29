<template>
  <div class="allTokenBattler">
    <b-container class="allToken">
      <center>
        <h3>みんなのトークンバトラー</h3>
      </center>
        <div class>
            <div v-for="(battler, key, index) in battlers" :key="index" class="battler list">
              <b-card>
                <p>バトラー名: {{ battler.name }}</p>
                <p style="white-space: pre;">ipfsHash: {{ battler.ipfsHash }}</p>
                <p>所有者アドレス: {{ battler.mintedBy }}</p>
                <p style="white-space: pre;">DNA:{{ battler.dna }}</p>
                <a v-bind:href="battler.ipfsUrl" target="_blank"><b-button variant="primary">画像をみる</b-button></a>
              </b-card>
            </div>
        </div>
      </b-container>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/TokenBattlerToken.json'
import ipfs from '../ipfs'
const TokenBattlerToken = contract(artifacts)
export default {
  name: 'AllTokenBattler',
  data() {
    return {
      battlers: [],
      message: null,
      title: null,
      content: null,
      buffer: null,
      ipfsHash: null,
      url: null,

    }
  },
  components: {
  },
  created() {
    if (typeof web3 !== 'undefined') {
      console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Fluyd, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
      // Use Mist/MetaMask's provider
      web3 = new Web3(web3.currentProvider)
    } else {
      console.warn("No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"))
    }
    TokenBattlerToken.setProvider(web3.currentProvider)
    web3.eth.getAccounts((err, accs) => {
      if (web3.currentProvider.publicConfigStore._state.networkVersion !== '3') {
        this.is_network = false
      } else {
        this.is_network = true
      }
      if (err != null) {
        console.log(err)
        this.message = "There was an error fetching your accounts. Do you have Metamask, Mist installed or an Ethereum node running? If not, you might want to look into that"
        return
      }
      if (accs.length == 0) {
        this.message = "Couldn't get any accounts! Make sure your Ethereum client is configured correctly."
        return
      }
      this.account = accs[0];
      TokenBattlerToken.deployed()
        .then((instance) => instance.address)
        .then((address) => {
          this.contractAddress = address
          this.updateTokenBattler();
        })
    })
  },
  methods: {
    updateTokenBattler() {
      TokenBattlerToken.deployed().then((instance) => instance.getAllTokenBattlers()).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getTokenBattler(r[i]);
        }
      })
    },
    getTokenBattler(tokenId) {
      TokenBattlerToken.deployed().then((instance) => instance.getTokenBattler(tokenId, { from: this.account })).then((r) => {
        var battler = {
          "name": null,
          "ipfsHash": null,
          "ipfsUrl" : null,
          "dna": null,
          "mintedBy": null
        }
        battler.name = r[0].toString()
        battler.ipfsHash = r[1].toString()
        battler.ipfsUrl="https://ipfs.io/ipfs/" + r[1].toString()
        battler.dna = r[5].toString()
        battler.mintedBy = r[4].toString()
        console.log(r)
        this.battlers.push(battler)
      })
    },
  }
}
</script>

<style>
.allToken{
  width: 700px;
}

</style>
