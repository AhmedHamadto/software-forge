---
name: security-audit
description: Audit security configurations - CSP, RLS, auth, dependencies, and OWASP vulnerabilities. Use before deployments or after adding integrations.
---


Audit security configurations for your webapp and backend services.

## When to Use
- Before production deployments
- After adding new integrations
- Reviewing authentication/authorization
- Checking for common vulnerabilities

## Project Context

Before starting, identify the security-relevant files in the current project:

```
# Locate security-relevant files
grep -rn "Content-Security-Policy" --include="*.html" --include="*.tsx" --include="*.jsx"
grep -rn "corsHeaders\|Access-Control" --include="*.ts" --include="*.js"
find . -name "*.sql" -path "*/migrations/*" | head -20
grep -rn "sanitize\|DOMPurify\|xss" --include="*.ts" --include="*.js" --include="*.jsx" --include="*.tsx"
grep -rn "AuthContext\|AuthProvider\|useAuth\|getSession" --include="*.ts" --include="*.js" --include="*.jsx" --include="*.tsx"
```

## Security Checklist

### 1. Content Security Policy (CSP)

**Look for:** CSP meta tags in HTML or CSP headers in server/deployment config.

**Reference policy:**
```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data: blob:;
  font-src 'self';
  connect-src 'self';
  object-src 'none';
  base-uri 'self';
  form-action 'self';
">
```

**Audit Points:**
- [ ] `default-src 'self'` - Restrictive default
- [ ] No `unsafe-inline` for scripts (if possible)
- [ ] All external domains explicitly listed
- [ ] `object-src 'none'` - Blocks plugins
- [ ] `frame-src` limited to trusted sources

**When Adding New Services:**
```
Stripe → add https://js.stripe.com to script-src
Analytics → add domain to connect-src
Fonts → add to font-src
Embeds → add to frame-src
```

### 2. Security Headers

**Look for:** Headers in deployment config (e.g., `vercel.json`, `netlify.toml`, nginx config, middleware).

**Required headers:**
```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-XSS-Protection", "value": "1; mode=block" },
        { "key": "Referrer-Policy", "value": "strict-origin-when-cross-origin" },
        { "key": "Permissions-Policy", "value": "camera=(), microphone=(), geolocation=()" },
        {
          "key": "Strict-Transport-Security",
          "value": "max-age=31536000; includeSubDomains"
        }
      ]
    }
  ]
}
```

**Audit Points:**
- [ ] HSTS enabled with long max-age
- [ ] X-Frame-Options DENY or SAMEORIGIN
- [ ] X-Content-Type-Options nosniff
- [ ] Referrer-Policy configured
- [ ] Permissions-Policy restricts unused APIs

### 3. Row Level Security (RLS)

**Applies to:** Projects using Supabase or similar row-level security.

**Required Policies Per Table:**

```sql
-- Enable RLS
ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;

-- SELECT: Users see own data
CREATE POLICY "Users can view own data"
ON table_name FOR SELECT
USING (auth.uid() = owner_id);

-- INSERT: Users create own data
CREATE POLICY "Users can insert own data"
ON table_name FOR INSERT
WITH CHECK (auth.uid() = owner_id);

-- UPDATE: Users modify own data
CREATE POLICY "Users can update own data"
ON table_name FOR UPDATE
USING (auth.uid() = owner_id);

-- DELETE: Users delete own data
CREATE POLICY "Users can delete own data"
ON table_name FOR DELETE
USING (auth.uid() = owner_id);
```

**Audit Points:**
- [ ] RLS enabled on ALL user data tables
- [ ] No tables with public access unintentionally
- [ ] Policies use `auth.uid()` correctly
- [ ] Service role used only in backend / Edge Functions
- [ ] No policies with `USING (true)` on sensitive tables

### 4. Input Sanitization

**Look for:** Sanitization utilities in the project.

**Reference implementation:**
```javascript
import DOMPurify from 'dompurify';

export function sanitizeHtml(dirty) {
  return DOMPurify.sanitize(dirty, {
    ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'p', 'br'],
    ALLOWED_ATTR: [],
  });
}

export function sanitizeText(input) {
  if (typeof input !== 'string') return '';
  return input
    .replace(/[<>]/g, '') // Remove angle brackets
    .trim()
    .slice(0, 10000); // Length limit
}
```

**Audit Points:**
- [ ] All user input sanitized before display
- [ ] DOMPurify configured restrictively
- [ ] No `dangerouslySetInnerHTML` without sanitization
- [ ] Length limits on all text inputs
- [ ] SQL injection prevented (parameterized queries or ORM)

### 5. Authentication

**Audit Points:**
- [ ] Session refresh working correctly
- [ ] Logout clears all tokens
- [ ] Protected routes check auth state
- [ ] No tokens stored in localStorage (use cookies)
- [ ] Password reset flow secure

```javascript
// Secure session handling pattern
const { data: { session } } = await supabase.auth.getSession();
if (!session) {
  // Redirect to login
}

// Secure logout
await supabase.auth.signOut();
```

### 6. API Keys & Secrets

**Environment Variables Audit:**

```bash
# PUBLIC (OK to expose in frontend — framework-prefixed)
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...       # Limited permissions via RLS
NEXT_PUBLIC_SENTRY_DSN=https://...

# SECRET (Never expose in frontend)
SUPABASE_SERVICE_ROLE_KEY=eyJ...     # Full database access
STRIPE_SECRET_KEY=sk_...
DATABASE_URL=postgres://...
```

**Audit Points:**
- [ ] No secrets in frontend code
- [ ] `.env` files in `.gitignore`
- [ ] Secrets only in backend / Edge Functions
- [ ] Framework prefix (`VITE_`, `NEXT_PUBLIC_`) only on public variables
- [ ] No hardcoded API keys in source

### 7. Dependency Vulnerabilities

**Commands:**
```bash
# Check for vulnerabilities
npm audit --production

# Auto-fix where possible
npm audit fix --production

# Check for outdated packages
npm outdated
```

**Audit Points:**
- [ ] No critical vulnerabilities
- [ ] High severity issues addressed
- [ ] Dependencies up to date
- [ ] Lock file committed (`package-lock.json`)

### 8. CORS Configuration

**Reference:**
```typescript
const corsHeaders = {
  "Access-Control-Allow-Origin": "https://yourdomain.com", // Not "*" in production
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
```

**Audit Points:**
- [ ] No wildcard `*` origin in production
- [ ] Specific domains whitelisted
- [ ] Credentials mode configured correctly
- [ ] Preflight requests handled

### 9. Webhook Security

**Signature Verification:**
```typescript
// Always verify webhook signatures
const signature = req.headers.get("stripe-signature");
const event = stripe.webhooks.constructEvent(body, signature, webhookSecret);
```

**Idempotency:**
```typescript
// Prevent duplicate processing
const { data: existing } = await db
  .from("webhook_events")
  .select("id")
  .eq("event_id", event.id)
  .single();

if (existing) {
  return new Response("Already processed", { status: 200 });
}
```

**Audit Points:**
- [ ] All webhooks verify signatures
- [ ] Idempotency keys stored
- [ ] Timeout handling for slow processing
- [ ] Error responses don't leak info

### 10. Rate Limiting

**Audit Points:**
- [ ] Auth endpoints rate limited
- [ ] API endpoints rate limited
- [ ] Brute force protection on login
- [ ] Rate limits configured on hosting/database platform

## Security Report Template

```markdown
# Security Audit Report
Date: YYYY-MM-DD
Auditor: [Name]

## Summary
- Critical Issues: X
- High Issues: X
- Medium Issues: X
- Low Issues: X

## Critical Findings
1. [Issue description]
   - Location: [file:line]
   - Risk: [description]
   - Remediation: [steps]

## Recommendations
1. [Recommendation]

## Checklist Results
- [x] CSP configured
- [x] Security headers set
- [ ] RLS audit pending
- [x] Input sanitization in place
...
```

## Automated Checks

Add to `package.json`:
```json
{
  "scripts": {
    "security:check": "npm audit --production --audit-level=high && npm outdated",
    "precommit:security": "npm audit --production --audit-level=critical"
  }
}
```

## Common Vulnerabilities to Check

1. **XSS**: User input displayed without sanitization
2. **CSRF**: Forms without anti-CSRF tokens
3. **SQL Injection**: Raw queries without parameterization
4. **Auth Bypass**: Missing route protection
5. **Data Exposure**: RLS not enabled or misconfigured
6. **Secret Leakage**: API keys in frontend code
7. **Dependency Vulns**: Outdated packages
