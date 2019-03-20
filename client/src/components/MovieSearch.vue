<template>
  <div>
    <input v-model="searchText" placeholder="Search a movie title">
    <button @click="search">Search</button>
    <div class="result" v-if="Object.keys(result).length">
      <img :src="result.poster">
      <h2>{{ result.title }}</h2>
      <p>{{ result.year }}</p>
      <p>{{ result.plot }}</p>
      <div class="rating">
        <h3>Rating & Comment</h3>
        <select v-model="rating" @change="rate">
          <option value="5 Stars">5 Stars</option>
          <option value="4 Stars">4 Stars</option>
          <option value="3 Stars">3 Stars</option>
          <option value="2 Stars">2 Stars</option>
          <option value="1 Star">1 Star</option>
        </select>
        <textarea v-model="comment" rows="8" cols="40"></textarea>
        <button @click="rate">Comment</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'MovieSearch',
  data: () => ({
    searchText: '',
    searchResult: {},
    rating: '',
    comment: ''
  }),
  computed: {
    result: function() {
      return this.searchResult;
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
          let {
            imdbID: id,
            Poster: poster,
            Title: title,
            Year: year,
            Plot: plot,
            rating,
            comment
          } = JSON.parse(response.data);
          if (!poster) poster = 'http://www.citypages.com/img/movie-placeholder.gif';
          this.searchResult = { id, poster, title, year, plot };
          this.rated = rating;
          this.commented = comment;
          this.searchText = '';
        })
    },
    rate: function() {
      axios.post(`/movie`, {
        data: {
          id: this.searchResult.id,
          rating: this.rating,
          comment: this.comment
        }
      })
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>

.result {
  margin-top: 25px;
}

.rating > * {
  display: block;
  margin-bottom: 25px;
}
</style>
