<template>
  <div>
    <input v-model="searchText" placeholder="Search a movie title">
    <button @click="search">Search</button>
    <ul>
      <li v-for="result in results" :key="result.id">
        <img :src="result.poster">
        <h3>{{ result.title }}</h3>
        <p>{{ result.year }}</p>
        <p>{{ result.plot }}</p>
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
          const {
            imdbID: id,
            Poster: poster,
            Title: title,
            Year: year,
            Plot: plot
          } = JSON.parse(json);
          this.searchText = '';
          this.searchResults = [];
          this.searchResults.push({ poster, title, year, plot });
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
