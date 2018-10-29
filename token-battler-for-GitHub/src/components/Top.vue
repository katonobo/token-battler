<template>
  <div class="top">
    <hr />
    <center>
        <h2>IPFSとDAppを使ったDappsゲームの習作</h2>
        <h3>トークンバトラー</h3>
        <img src="../assets/Usagi.png" width="350" height="350">
        <p>トークンバトラーは、IPFS上に画像を保存します。</p>
        <p>そしてその固有のIPFSの値からDNA番号を生成し、イーサリアムのブロックチェーンにERC721トークンとして刻みます。</p>
        <br/>
        <p>狙い①：独自のキャラクターを作り、そのキャラクターをトークン化できる</p>
        <p>狙い②：IPFSを使うことで、画像を直接ブロックチェーンに載せずに扱うことができる</p>
        <p>狙い③：DNAを作成することで、キャラクターのステータスをランダムで作れる</p>
        <p>注意）このサービスはテストネットです。また、トークンの売買機能は実装していません</p>
    </center>
    <hr />
    <b-container>
        <h2>☆トークンバトラーの使い方説明</h2>
      <b-card>
        <h3>メタマスクで「Ropstenネットワークに設定」</h3>
        <hr />
        <p>①メタマスクをインストールし、「Ropsten」に設定します</p>
        <img src="../assets/metamask.png" width="400" height="150">
        <p></p>
        <p></p>
        <p>②もしETHの残高がない場合は「Buy」をクリックしテスト用のETHを取得してください</p>
        <img src="../assets/metamaskEth.png" width="400" height="150">
      </b-card>
      <b-card>
        <h3>「バトラーの管理・作成」画面で、バトラーを作成</h3>
        <hr />
        <p>ナビゲーションメニューの「バトラーの管理・作成」の画面を開いてください</p>
        <img src="../assets/makeImg.png" width="400" height="400">
        <p>①キャラクター名と②ブロックチェーンに載せたい画像を選択してください</p>
        <p>注意1）画像はIPFSにアップロードするので著作権などに注意してください</p>
        <p>注意2）画像を選択してしばらく反映に時間がかかります</p>
      </b-card>
      <b-card>
        <h3>「みんなのバトラーを見る」で見てみよう</h3>
        <hr />
        <p>「みんなのバトラーを見る」でみんなのバトラーを見て見ましょう。</p>
        <img src="../assets/Usagi.png" width="300" height="300">
        <p>IPFSにアップした画像</p>
      </b-card>
    </b-container>
  </div>
</template>

<script>
export default {
  name: 'Top',
  data() {
    return {

    }
  },
  components: {
  },
}
</script>

<style>

</style>
