<template>
  <div>
    <input v-model="searchText" placeholder="Search a movie title">
    <button @click="search">Search</button>
    <ul>
      <li v-for="result in results" :key="result.imdbID">
        {{ result.movie }}
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'MovieSearch',
  data: () => ({
    searchText: '',
    searchResults: []
  }),
  computed: {
    results: function() {
      return this.searchResults
    }
  },
  methods: {
    search: function() {
      fetch(`http://localhost:4567/search?q=${this.searchText}`)
        .then(response => response.json())
        .then(json => {
          this.searchText = '';
          this.searchResults.push({ movie: json.result })
        })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
