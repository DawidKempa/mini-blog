<template>
  <div class="full-width-container py-5">
    <div class="content-wrapper">
      <div class="text-center mb-5">
        <h2 class="display-5 fw-bold text-primary">Nasze posty</h2>
      </div>

      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">Ładowanie...</span>
        </div>
        <p class="mt-3">Ładowanie postów...</p>
      </div>

      <div class="row justify-content-center g-4" v-else-if="posts.length">
        <div
          class="col-md-6 col-lg-4 col-xl-4"
          v-for="post in posts"
          :key="post.id"
        >
          <div class="card h-100 shadow-sm border-0 overflow-hidden">
            <div class="position-relative">
              <div
                v-if="extractFirstImage(post.body?.body)"
                class="card-img-top"
              >
                <img
                  :src="extractFirstImage(post.body?.body)"
                  :alt="post.title || 'Obrazek z posta'"
                  class="img-fluid w-100"
                  style="height: 200px; object-fit: cover"
                  loading="lazy"
                />
              </div>
              <div
                v-else
                class="card-img-top bg-light d-flex align-items-center justify-content-center"
                style="
                  height: 200px;
                  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                "
              >
                <span class="text-muted">
                  <i class="bi bi-image" style="font-size: 2rem"></i>
                </span>
              </div>
              <div
                class="position-absolute top-0 end-0 bg-white px-2 py-1 m-2 rounded-pill small shadow-sm"
              >
                {{ formatDate(post.created_at) }}
              </div>
            </div>

            <div class="card-body d-flex flex-column">
              <h5 class="card-title fw-bold">
                {{ post.title || "Bez tytułu" }}
              </h5>
              <p class="card-text text-muted mb-3">
                {{ truncate(stripHtml(post.body?.body), 120) || "Brak treści" }}
              </p>
              <router-link
                :to="`/posts/${post.id}`"
                class="btn btn-outline-primary mt-auto align-self-start"
              >
                Czytaj więcej <i class="bi bi-arrow-right ms-1"></i>
              </router-link>
            </div>
          </div>
        </div>
      </div>

      <div v-else class="text-center py-5">
        <div class="bg-light p-5 rounded">
          <i
            class="bi bi-newspaper"
            style="font-size: 3rem; color: #6c757d"
          ></i>
          <h3 class="mt-3">Brak postów</h3>
          <p class="text-muted">
            Aktualnie nie ma żadnych postów do wyświetlenia.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "../api";

const posts = ref([]);
const loading = ref(true);

onMounted(async () => {
  try {
    const response = await api.get("/api/posts");
    posts.value = response.data;
  } catch (error) {
    console.error("Błąd ładowania postów:", error);
  } finally {
    loading.value = false;
  }
});

const extractFirstImage = (html) => {
  if (!html) return null;
  const match = html.match(/<action-text-attachment[^>]+url="([^"]+)"/);
  return match ? match[1] : null;
};

const stripHtml = (html) => {
  if (!html) return "";
  const div = document.createElement("div");
  div.innerHTML = html;
  return div.textContent || div.innerText || "";
};

const truncate = (text, length) => {
  if (!text) return "";
  return text.length > length ? text.slice(0, length) + "…" : text;
};

const formatDate = (isoString) => {
  if (!isoString) return "";
  return new Date(isoString).toLocaleDateString("pl-PL", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
};
</script>

<style scoped>
.card {
  transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
  border-radius: 0.75rem;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
}

.card-img-top {
  border-top-left-radius: 0.75rem;
  border-top-right-radius: 0.75rem;
}

.btn-outline-primary {
  border-width: 2px;
  border-radius: 0.5rem;
  transition: all 0.2s;
}

.btn-outline-primary:hover {
  background-color: var(--bs-primary);
  color: white;
}

.text-primary {
  color: var(--bs-primary) !important;
}
</style>
