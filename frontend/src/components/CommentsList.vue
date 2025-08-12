<template>
  <div class="comments-container py-5">
    <h2 class="mb-5 text-primary">Komentarze</h2>

    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">Ładowanie...</span>
      </div>
      <p>Ładowanie komentarzy...</p>
    </div>

    <div v-else-if="comments.length">
      <ul class="list-group">
        <li
          class="list-group-item"
          v-for="comment in comments"
          :key="comment.id"
        >
          <div class="d-flex justify-content-between">
            <div>
              <strong>{{ comment.user.email }}</strong>
              <small class="text-muted">
                dla posta:
                <i>{{ comment.post.title || "Nieznany" }}</i>
              </small>
            </div>
            <small class="text-muted">{{
              formatDate(comment.created_at)
            }}</small>
          </div>
          <p class="mt-2">{{ comment.content }}</p>
        </li>
      </ul>
    </div>

    <div v-else class="text-center py-5 text-muted">
      Brak komentarzy do wyświetlenia.
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/api";

const comments = ref([]);
const loading = ref(true);

const formatDate = (isoString) => {
  if (!isoString) return "";
  return new Date(isoString).toLocaleDateString("pl-PL", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};

onMounted(async () => {
  try {
    const response = await api.get("/api/comments");
    comments.value = response.data;
  } catch (error) {
    console.error("Błąd podczas ładowania komentarzy:", error);
  } finally {
    loading.value = false;
  }
});
</script>
