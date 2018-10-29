<template>
<b-navbar toggleable="md" type="dark" variant="info">
  <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>
  <b-navbar-brand href="#">TokenBattler</b-navbar-brand>
  <b-collapse is-nav id="nav_collapse">
    <b-navbar-nav>
      <router-link to="/"><b-button class="btn" variant="warning">トップ</b-button></router-link>
      <router-link to="/make"><b-button variant="warning">バトラーの管理・作成</b-button></router-link>
      <router-link to="/allTokenBattler"><b-button variant="warning">みんなのバトラーを見る</b-button></router-link>
    </b-navbar-nav>
  </b-collapse>
</b-navbar>
</template>

<script>
export default {
  name: 'Navbar',
  components: {
  }
}
</script>
<style>
.btn{
    margin-right: 10px;
}

</style>
