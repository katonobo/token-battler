<template>
  <div class="make">
    <b-container class="inputData">
      <hr />
      <b-row>
      <b-col>
        <b-card>
        <h3>トークンキャラクターを作成する</h3>
              <b-form>
                <p>
                  ①キャラクターネームを記入してください
                  <input type="text" id="battler" v-model="battler" >
                </p>
                <p>②登録したい画像を選択してください:　<input type="file" @change="loadFile"></p>
                  <p>あなたのipfsHashはこちら:{{ ipfsHash }}</p>
                  <b-button variant="primary" @click.prevent="createTokenBattler" v-bind:disabled="!is_network">作成する</b-button>
              </b-form>
        <hr />
      <p>トランザクション:</p>
      <div class="message" v-if="message">{{message}}</div>
      <div class="tx_hash" v-if="tx_hash">Tx Hash: <a v-bind:href="tx_url">{{tx_hash}}</a></div>
      </b-card>
      </b-col>
      <b-col cols="6">
        <hr/>
        <h3>あなたのバトラー情報</h3>
          <div class>
            <div v-for="(tokenBattler, key, index) in tokenBattlers" :key="index" class="tokenBattler list myself">
            <b-card>
                <p>バトラー名: {{ tokenBattler.battler }}</p>
                <p style="white-space: pre;">ipfsHash:{{tokenBattler.ipfsHash}} </p>
                <p style="white-space: pre;">DNA:{{ tokenBattler.dna }}</p>
                <a v-bind:href="tokenBattler.ipfsUrl" target="_blank"><b-button variant="primary">画像をみる</b-button></a>
            </b-card>
        </div>
      </div>
    <div class="networkInfo">
        <hr />
        <h3>ネットワーク情報</h3>
        <p v-if="!is_network">現在Ropstenネットワークではありません</a>
        <p v-if="!is_network">ネットワークを確認してください</a>
        <p v-if="contractAddress && is_network">このDappsのコントラクトは: {{contractAddress}}</p>
        <p v-if="!contractAddress && is_network">コントラクトが見つかりません</p>
        <p v-if="account && is_network">現在のアドレスは: {{account}}</p>
        <p v-if="!account && is_network">アカウントが見つかりません</p>
    </div>
    </b-col>
    </b-row>
  </b-container>
</div>
</template>

<script>
import Web3 from 'web3'
import ipfs from '../ipfs'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/TokenBattlerToken.json'
const TokenBattlerToken = contract(artifacts)
export default {
  name: 'Make',
  data() {
    return {
      tokenBattlers: [],
      is_network: true,
      message: null,
      tx_hash: null,
      tx_url: null,
      network: null,
      contractAddress: null,
      account: null,
      battler: null,
      ipfsHash: null,
      ipfsHashUrl: "https://ipfs.io/ipfs/"
    }
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

  loadFile(e) {
    event.preventDefault()
    const file = e.target.files[0];
    const reader = new FileReader();
    var self = this;
    //reader.readAsArrayBuffer(file);
    reader.onloadend = function(e){
      var buffer = Buffer(reader.result);
      ipfs.files.add(buffer, function(err, result){
      var ipfsHash = result[0].hash;
      var url = "https://ipfs.io/ipfs/" + ipfsHash;
      self.url = url;
      self.ipfsHash = ipfsHash;
      console.log(url);
      })
    },
    reader.readAsArrayBuffer(file);
  },


    createTokenBattler() {
      this.message = "Transaction started";
      return TokenBattlerToken.deployed()
        .then((instance) => instance.mint(this.battler, this.ipfsHash, true, { from: this.account }))
        .then((r) => {
          this.tx_hash = r.tx
          this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
          this.message = "Transaction result"
          var tokenBattler = {
            "id": null,
            "battler": null,
            "ipfsHash": null,
            "mintedBy": null
          }
          tokenBattler.id = this.tokenBattlers.length + 1
          tokenBattler.battler = this.battler
          tokenBattler.ipfsHash = this.ipfsHash
          tokenBattler.mintedBy = this.account
          this.tokenBattlers.push(tokenBattler)
          this.battler = null
          this.ipfsHash = null
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    updateTokenBattler() {
      TokenBattlerToken.deployed().then((instance) => instance.getAllTokenBattlersOfOwner(this.account, { from: this.account })).then((r) => {
        for (var i = 0; i < r.length; i++) {
          this.getTokenBattler(r[i]);
        }
      })
    },
    getTokenBattler(tokenId) {
      TokenBattlerToken.deployed().then((instance) => instance.getTokenBattler(tokenId, { from: this.account })).then((r) => {
        var tokenBattler = {
          "id": null,
          "battler": null,
          "ipfsHash": null,
          "ipfsUrl":null,
          "dna": null,
          "mintedBy": null
        }
        tokenBattler.id = tokenId
        tokenBattler.battler = r[0].toString()
        tokenBattler.ipfsHash = r[1].toString()
        tokenBattler.ipfsUrl="https://ipfs.io/ipfs/" + r[1].toString()
        tokenBattler.dna = r[5].toString()
        this.tokenBattlers.push(tokenBattler)
      })
    },
//    deleteTokenBattler(tokenId){
//      TokenBattlerToken.deployed().then((instance) => instance.burn(tokenId, { from: this.account })).then((r) => {
//        this.tx_hash = r.tx
//        this.tx_url = 'https://ropsten.etherscan.io/tx/' + r.tx
//        this.tokenBattlers = []
//        this.updateTokenBattler();
//      })
//    }
  }
}
</script>
<style>
.networkInfo{
    margin-top: 200px;
}

</style>
