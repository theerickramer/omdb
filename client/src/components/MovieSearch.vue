<template>
  <div>
    <input v-model="searchText" placeholder="Search a movie title">
    <button @click="search">Search</button>
    <a @click="getSaved">All Saved</a>
    <ul class="result" v-if="results.length">
      <li v-for="result in results" :key="result.imdbID">
        <img :src="result.Poster">
        <h2>{{ result.Title }}</h2>
        <p>{{ result.Year }}</p>
        <p>{{ result.Plot }}</p>
        <div class="rating">
          <h3>Rating & Comment</h3>
          <select v-model="rating">
            <option value="5 Stars">5 Stars</option>
            <option value="4 Stars">4 Stars</option>
            <option value="3 Stars">3 Stars</option>
            <option value="2 Stars">2 Stars</option>
            <option value="1 Star">1 Star</option>
          </select>
          <textarea v-model="comment" rows="8" cols="40"></textarea>
          <button @click="save">Save</button>
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'MovieSearch',
  data: () => ({
    searchText: '',
    searchResults: [],
    rating: '',
    comment: ''
  }),
  computed: {
    results: function() {
      return this.searchResults;
    },
    rated: {
      get: function() {
        return this.rating;
      },
      set: function(value) {
        this.rating = value;
      }
    },
    commented: {
      get: function() {
        return this.comment;
      },
      set: function(value) {
        this.comment = value;
      }
    }
  },
  methods: {
    search: function() {
      axios.get(`/search?q=${this.searchText}`)
        .then(response => {
          const data = JSON.parse(response.data);
          let { Poster } = data;
          const {
            imdbID,
            Title,
            Year,
            Plot,
            rating,
            comment
          } = data;
          if (!Poster) Poster = 'http://www.citypages.com/img/movie-placeholder.gif';
          this.searchResults = [{ imdbID, Poster, Title, Year, Plot }];
          this.rated = rating;
          this.commented = comment;
          this.searchText = '';
        })
    },
    save: function() {
      const movie = this.searchResults[0];
      axios.post(`/movie`, {
        data: { ...movie, rating: this.rating, comment: this.comment }
      })
    },
    getSaved: function() {
      axios.get('/movies')
        .then(response => {
          this.searchResults = JSON.parse(response.data);
        })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
a {
  margin-left: 25px;
  color: blue;
  cursor: pointer;
}

li {
  list-style-type: none;
}

.result {
  margin-top: 25px;
}

.rating > * {
  display: block;
  margin-bottom: 25px;
}
</style>
