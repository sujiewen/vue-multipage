import LoadingComponents from './loading.vue'

const loading = {
  install: function (Vue) {
    Vue.component('Loading', LoadingComponents)
  }
}

export default loading
