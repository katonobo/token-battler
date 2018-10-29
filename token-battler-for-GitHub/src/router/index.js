import Vue from 'vue'
import Router from 'vue-router'
import Top from '@/components/Top'
import Make from '@/components/Make'
import AllTokenBattler from '@/components/AllTokenBattler'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Top',
      component: Top
    },
    {
        path: '/make',
        name: 'Make',
        component: Make
    },
    {
        path: '/allTokenBattler',
        name: 'AllTokenBattler',
        component: AllTokenBattler
    }
  ]
})
