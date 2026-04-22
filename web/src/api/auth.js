import client from "@/api/client";

export const loginApi = (payload) => client.post("/auth/login", payload);
export const registerApi = (payload) => client.post("/auth/register", payload);
export const logoutApi = (token) =>
  client.post(
    "/auth/logout",
    null,
    token
      ? {
          headers: {
            Authorization: `Bearer ${token}`
          }
        }
      : undefined
  );
export const getProfileApi = () => client.get("/auth/profile");
export const updateProfileApi = (payload) => client.put("/auth/profile", payload);
