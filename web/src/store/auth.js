import { computed, ref } from "vue";
import { defineStore } from "pinia";
import { getProfileApi, loginApi, logoutApi, registerApi, updateProfileApi } from "@/api/auth";

const TOKEN_KEY = "xiaozhi_token";
const USER_KEY = "xiaozhi_user";

export const useAuthStore = defineStore("auth", () => {
  const token = ref(sessionStorage.getItem(TOKEN_KEY) || "");
  const user = ref(loadUser());
  const loading = ref(false);

  const isAuthenticated = computed(() => Boolean(token.value));
  const isAdmin = computed(() => user.value?.role === "ADMIN");

  function setAuth(authToken, profile) {
    token.value = authToken;
    user.value = profile;
    sessionStorage.setItem(TOKEN_KEY, authToken);
    sessionStorage.setItem(USER_KEY, JSON.stringify(profile));
  }

  function clearAuth() {
    token.value = "";
    user.value = null;
    sessionStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(USER_KEY);
  }

  async function login(payload) {
    loading.value = true;
    try {
      const data = await loginApi(payload);
      setAuth(data.token, data.user);
      return data;
    } finally {
      loading.value = false;
    }
  }

  async function register(payload) {
    loading.value = true;
    try {
      const data = await registerApi(payload);
      setAuth(data.token, data.user);
      return data;
    } finally {
      loading.value = false;
    }
  }

  async function fetchProfile() {
    if (!token.value) {
      return null;
    }
    const profile = await getProfileApi();
    user.value = profile;
    sessionStorage.setItem(USER_KEY, JSON.stringify(profile));
    return profile;
  }

  async function updateProfile(payload) {
    const profile = await updateProfileApi(payload);
    user.value = profile;
    sessionStorage.setItem(USER_KEY, JSON.stringify(profile));
    return profile;
  }

  async function logout() {
    const tokenSnapshot = token.value;
    clearAuth();
    if (!tokenSnapshot) {
      return;
    }
    try {
      await logoutApi(tokenSnapshot);
    } catch {
      // ignore logout network errors
    }
  }

  return {
    token,
    user,
    loading,
    isAuthenticated,
    isAdmin,
    login,
    register,
    fetchProfile,
    updateProfile,
    logout
  };
});

function loadUser() {
  const raw = sessionStorage.getItem(USER_KEY);
  if (!raw) {
    return null;
  }
  try {
    return JSON.parse(raw);
  } catch {
    sessionStorage.removeItem(USER_KEY);
    return null;
  }
}
