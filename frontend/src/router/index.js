import { createRouter, createWebHistory } from "vue-router";

import AdminLayout from "@/components/AdminLayout.vue";
import PostList from "@/components/PostList.vue";
import CommentsList from "@/components/CommentsList.vue";

const routes = [
  {
    path: "/",
    redirect: "/admin/posts",
  },
  {
    path: "/admin",
    component: AdminLayout,
    children: [
      {
        path: "posts",
        component: PostList,
      },
      {
        path: "comments",
        component: CommentsList,
      },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
