import axios from "axios";

const DEFAULT_TIMEOUT = Number(import.meta.env.VITE_API_TIMEOUT || 120000);
const AI_TIMEOUT = Number(import.meta.env.VITE_AI_API_TIMEOUT || 300000);
const AI_TIMEOUT_PATTERNS = [
  /^\/resumes\/\d+\/parse$/,
  /^\/jd\/analyze$/,
  /^\/questions\/generate$/,
  /^\/hot-questions\/\d+\/practice-score$/,
  /^\/question-banks$/,
  /^\/interviews\/\d+\/answer$/
];

const normalizeUrl = (url = "") => url.replace(/^https?:\/\/[^/]+/i, "").split("?")[0];
const isAiRequest = (url) => AI_TIMEOUT_PATTERNS.some((pattern) => pattern.test(normalizeUrl(url)));

const client = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "/api",
  timeout: DEFAULT_TIMEOUT
});

client.interceptors.request.use((config) => {
  if (isAiRequest(config.url || "") && (!config.timeout || config.timeout < AI_TIMEOUT)) {
    config.timeout = AI_TIMEOUT;
  }
  const token = sessionStorage.getItem("xiaozhi_token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

client.interceptors.response.use(
  (response) => {
    const payload = response.data;
    if (payload && typeof payload.success === "boolean") {
      if (!payload.success) {
        return Promise.reject(new Error(payload.message || "请求失败"));
      }
      return payload.data;
    }
    return payload;
  },
  (error) => {
    const msg = error.response?.data?.message || error.message || "网络异常";
    return Promise.reject(new Error(msg));
  }
);

export default client;
