<template>
  <div class="container py-5">
    <h2 class="mb-4">Formularz kontaktowy</h2>

    <div v-if="successMessage" class="alert alert-success">
      {{ successMessage }}
    </div>
    <div v-if="errorMessage" class="alert alert-danger">{{ errorMessage }}</div>

    <form @submit.prevent="submitForm">
      <div class="mb-3">
        <label for="name" class="form-label">Imię i nazwisko</label>
        <input
          v-model="form.name"
          type="text"
          class="form-control"
          id="name"
          required
        />
      </div>

      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input
          v-model="form.email"
          type="email"
          class="form-control"
          id="email"
          required
        />
      </div>

      <div class="mb-3">
        <label for="message" class="form-label">Wiadomość</label>
        <textarea
          v-model="form.message"
          class="form-control"
          id="message"
          rows="4"
          required
        ></textarea>
      </div>

      <button type="submit" class="btn btn-primary">Wyślij</button>
    </form>
  </div>
</template>

<script setup>
import { ref } from "vue";

import api from "../api";

const form = ref({
  name: "",
  email: "",
  message: "",
});

const successMessage = ref("");
const errorMessage = ref("");

const submitForm = async () => {
  successMessage.value = "";
  errorMessage.value = "";

  try {
    const response = await api.post("/api/contact", form.value);
    successMessage.value = response.data.message;
    form.value = { name: "", email: "", message: "" };
  } catch (error) {
    errorMessage.value =
      error.response?.data?.error || "Błąd podczas wysyłania.";
  }
};
</script>
