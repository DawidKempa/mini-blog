<template>
  <div>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container-fluid">
        <span class="navbar-brand">Panel Administracyjny</span>
        <button class="btn btn-sm btn-danger">Wyloguj</button>
      </div>
    </nav>

    <div class="d-flex flex-grow-1" style="min-height: calc(100vh - 56px)">
      <nav class="bg-light p-3" style="width: 220px">
        <ul class="nav flex-column">
          <li class="nav-item mb-2">
            <router-link
              to="/admin/posts"
              class="nav-link sidebar-link"
              active-class="active"
              exact
            >
              Posty
            </router-link>
          </li>
          <li class="nav-item mb-2">
            <router-link
              to="/admin/comments"
              class="nav-link sidebar-link"
              active-class="active"
              exact
            >
              Komentarze
            </router-link>
          </li>
          <li class="nav-item mb-2">
            <a href="#" class="nav-link sidebar-link">Strony</a>
          </li>
          <li class="nav-item mb-2">
            <a href="#" class="nav-link sidebar-link">Użytkownicy</a>
          </li>
          <li class="nav-item mb-2">
            <a href="#" class="nav-link sidebar-link">Generuj PDF</a>
          </li>
        </ul>
      </nav>

      <div class="flex-grow-1 p-3">
        <router-view />
      </div>
    </div>
  </div>
</template>

<style scoped>
.sidebar-link {
  display: block;
  padding: 10px 15px;
  color: #333;
  font-weight: 500;
  border-radius: 6px;
  transition: background-color 0.3s, color 0.3s;
  text-decoration: none;
}

.sidebar-link:hover {
  background-color: #250dfd;
  color: white;
}

.sidebar-link.active {
  background-color: #250dfd;
  color: white;
}
</style>
