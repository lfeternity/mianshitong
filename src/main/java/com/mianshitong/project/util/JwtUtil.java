package com.mianshitong.project.util;

import com.mianshitong.project.entity.bo.AuthUser;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import javax.crypto.SecretKey;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.core.env.Profiles;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtUtil {

    private static final String KNOWN_WEAK_SECRET = "please-change-this-jwt-secret-minimum-32-bytes-long";
    private static final String KNOWN_EXAMPLE_SECRET = "replace-with-a-random-secret-at-least-32-bytes";
    private static final int MIN_SECRET_BYTES = 32;

    private final Environment environment;

    @Value("${app.jwt.secret}")
    private String secret;

    @Value("${app.jwt.expire-minutes}")
    private long expireMinutes;

    private SecretKey signingKey;

    @PostConstruct
    public void init() {
        if (isUnconfiguredSecret(secret)) {
            if (environment.acceptsProfiles(Profiles.of("prod"))) {
                throw new IllegalStateException("JWT 密钥未配置，请设置环境变量 JWT_SECRET");
            }
            secret = generateDevelopmentSecret();
        }
        if (KNOWN_WEAK_SECRET.equals(secret) || KNOWN_EXAMPLE_SECRET.equals(secret)) {
            throw new IllegalStateException("JWT 密钥使用了已知弱默认值，请替换为随机高强度密钥");
        }
        byte[] keyBytes = secret.getBytes(StandardCharsets.UTF_8);
        if (keyBytes.length < MIN_SECRET_BYTES) {
            throw new IllegalStateException("JWT 密钥长度不足，至少需要 " + MIN_SECRET_BYTES + " 字节");
        }
        signingKey = Keys.hmacShaKeyFor(keyBytes);
    }

    private boolean isUnconfiguredSecret(String value) {
        return value == null || value.isBlank() || KNOWN_EXAMPLE_SECRET.equals(value);
    }

    private String generateDevelopmentSecret() {
        byte[] keyBytes = new byte[MIN_SECRET_BYTES];
        new SecureRandom().nextBytes(keyBytes);
        return Base64.getEncoder().encodeToString(keyBytes);
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
