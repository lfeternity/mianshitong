package com.mianshitong.project.util;

import com.mianshitong.project.entity.bo.AuthUser;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;
import javax.crypto.SecretKey;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class JwtUtil {

    private static final String KNOWN_WEAK_SECRET = "please-change-this-jwt-secret-minimum-32-bytes-long";

    @Value("${app.jwt.secret}")
    private String secret;

    @Value("${app.jwt.expire-minutes}")
    private long expireMinutes;

    private SecretKey signingKey;

    @PostConstruct
    public void init() {
        if (secret == null || secret.isBlank()) {
            throw new IllegalStateException("JWT 密钥未配置，请设置环境变量 JWT_SECRET");
        }
        if (KNOWN_WEAK_SECRET.equals(secret)) {
            throw new IllegalStateException("JWT 密钥使用了已知弱默认值，请替换为随机高强度密钥");
        }
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < 32) {
            throw new IllegalStateException("JWT 密钥长度不足，至少需要 32 字节");
        }
        signingKey = Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(AuthUser user) {
        Instant now = Instant.now();
        Instant expireAt = now.plusSeconds(expireMinutes * 60);
        return Jwts.builder()
            .subject(String.valueOf(user.userId()))
            .claim("role", user.role())
            .claim("email", user.email())
            .issuedAt(Date.from(now))
            .expiration(Date.from(expireAt))
            .signWith(signingKey)
            .compact();
    }

    public AuthUser parseToken(String token) {
        Claims claims = parseClaims(token);
        Long userId = Long.valueOf(claims.getSubject());
        String role = claims.get("role", String.class);
        String email = claims.get("email", String.class);
        return new AuthUser(userId, role, email);
    }

    public Long parseUserId(String token) {
        Claims claims = parseClaims(token);
        return Long.valueOf(claims.getSubject());
    }

    public Instant parseExpiration(String token) {
        Date expiration = parseClaims(token).getExpiration();
        return expiration == null ? Instant.now() : expiration.toInstant();
    }

    private Claims parseClaims(String token) {
        return Jwts.parser().verifyWith(signingKey).build()
            .parseSignedClaims(token).getPayload();
    }
}
