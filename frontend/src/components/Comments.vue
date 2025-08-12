<template>
  <div>
    <h2>Komentarze</h2>
    <ul v-if="comments.length">
      <li v-for="comment in comments" :key="comment.id">
        <strong>{{ comment.user.name }}</strong
        >: {{ comment.content }}
        <small>(dotyczy posta: {{ comment.post.title }})</small>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  data() {
    return {
      comments: [],
    };
  },
  mounted() {
    fetch("/admin/comments.json")
      .then((res) => res.json())
      .then((data) => {
        this.comments = data;
      });
  },
};
</script>
