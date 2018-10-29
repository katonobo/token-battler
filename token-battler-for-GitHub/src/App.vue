<template>
  <div id="app">
    <Navbar />
    <router-view/>
  </div>
</template>

<script>
import Navbar from './Navbar'
export default {
  name: 'App',
  components: {
    Navbar,
  }
}
</script>

<style>

</style>
