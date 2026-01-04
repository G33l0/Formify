# Formify Website - FREE Hosting Guide

This folder contains the static website for Formify (privacy policy, terms, contact page).

## 🌐 FREE Hosting Options

### Option 1: GitHub Pages (RECOMMENDED - 100% FREE)

**Advantages:**
- ✅ Completely FREE forever
- ✅ FREE SSL certificate (HTTPS)
- ✅ Custom domain support
- ✅ Fast CDN
- ✅ Easy to update (just commit changes)

**Setup Steps:**

1. **Create a new GitHub repository**
   ```bash
   # Create a new repo named "formify-website" on GitHub
   # Then:
   git init
   git add .
   git commit -m "Initial website"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/formify-website.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings
   - Scroll to "Pages"
   - Source: Deploy from branch
   - Branch: `main` / `root`
   - Click Save

3. **Your site will be live at:**
   ```
   https://YOUR_USERNAME.github.io/formify-website/
   ```

4. **Add custom domain (optional):**
   - Buy domain (e.g., formify.com)
   - Add CNAME file with your domain:
     ```
     www.formify.com
     ```
   - In domain registrar, add DNS records:
     ```
     Type: CNAME
     Name: www
     Value: YOUR_USERNAME.github.io
     ```

---

### Option 2: Netlify (Also FREE)

**Setup:**

1. Go to https://netlify.com
2. Sign up (free account)
3. Drag and drop this `website` folder
4. Done! Live in 30 seconds

**Custom domain:**
- Go to Domain settings
- Add your domain
- Follow DNS instructions

---

### Option 3: Vercel (Also FREE)

Similar to Netlify:
1. Go to https://vercel.com
2. Sign up
3. Import this folder
4. Deploy

---

## 📧 FREE Email Solutions

### Option 1: Zoho Mail (FREE for 5 users)

**Setup:**
1. Go to https://www.zoho.com/mail/
2. Sign up for FREE plan
3. Add your domain
4. Create email addresses:
   - support@formify.com
   - privacy@formify.com
   - hello@formify.com

**Cost:** FREE forever (5 mailboxes)

---

### Option 2: Gmail with Custom Domain

**Using Gmail Alias (100% FREE):**
1. Use your existing Gmail
2. In contact form, use your Gmail
3. Reply using "Send as" with custom domain name

**Cost:** FREE

---

### Option 3: Forwarder Email (FREE)

**If you just bought a domain:**
1. Most domain registrars offer FREE email forwarding
2. Forward support@formify.com → your.gmail@gmail.com
3. You receive at Gmail, reply from Gmail

**Cost:** FREE

---

## 📝 Contact Form Backend (FREE)

The contact form uses **Formspree** (FREE tier):

**Setup:**
1. Go to https://formspree.io
2. Sign up (FREE - 50 submissions/month)
3. Create a new form
4. Copy your form endpoint: `https://formspree.io/f/YOUR_FORM_ID`
5. Replace in `contact.html`:
   ```html
   <form action="https://formspree.io/f/YOUR_FORM_ID" method="POST">
   ```

**When someone submits:**
- You get email notification
- Can reply directly from email
- See all submissions in Formspree dashboard

**FREE tier includes:**
- 50 submissions/month
- Email notifications
- No Formspree branding

**Alternative:** ImprovMX, FormSubmit, or Basin

---

## 🎨 Customization

### Update Email Addresses

Replace in all HTML files:
```
support@formify.app → your-email@yourdomain.com
privacy@formify.app → your-email@yourdomain.com
```

### Update Colors

Edit CSS in each file. Current primary color:
```css
#246BFD  /* Royal Blue */
```

Change to your brand color.

---

## 🚀 Deployment Checklist

- [ ] Update email addresses in all pages
- [ ] Update Formspree form ID in contact.html
- [ ] Add your domain name in privacy.html and terms.html
- [ ] Test all links
- [ ] Deploy to GitHub Pages / Netlify / Vercel
- [ ] Set up custom domain (if purchased)
- [ ] Set up email forwarding or Zoho Mail
- [ ] Test contact form
- [ ] Update URLs in Flutter app constants

---

## 📱 Update App with Website URLs

Once deployed, update in your Flutter app:

**File:** `lib/core/constants/app_constants.dart`
```dart
static const String privacyPolicyUrl = 'https://yourdomain.com/privacy.html';
static const String termsOfServiceUrl = 'https://yourdomain.com/terms.html';
static const String supportEmail = 'support@yourdomain.com';
```

---

## 💰 Total Cost

| Service | Cost |
|---------|------|
| GitHub Pages | FREE ✅ |
| Netlify/Vercel | FREE ✅ |
| Zoho Mail (5 emails) | FREE ✅ |
| Formspree (50 forms/mo) | FREE ✅ |
| **Total** | **$0.00/month** |

**Only cost:** Domain name (~$10-15/year)

---

## 🆘 Support Ticket System (Upgraded Options)

### If You Need More Than Email

**FREE/Cheap Options:**

1. **Zoho Desk** (FREE up to 3 agents)
   - https://www.zoho.com/desk/
   - Ticket system, knowledge base
   - Email to ticket conversion

2. **Freshdesk** (FREE plan available)
   - https://freshdesk.com
   - Ticketing system
   - Team collaboration

3. **HelpScout** (From $20/month)
   - Professional looking
   - Shared inbox
   - Good for small teams

---

## Files in This Folder

- `index.html` - Home page
- `privacy.html` - Privacy policy (GDPR-compliant)
- `terms.html` - Terms of service
- `contact.html` - Contact form + FAQ
- `README.md` - This file

---

## Next Steps

1. Choose hosting (GitHub Pages recommended)
2. Deploy website
3. Set up email (Zoho Mail or Gmail forwarding)
4. Configure Formspree for contact form
5. Buy domain (optional but professional)
6. Update Flutter app constants with URLs
7. Test everything

**Questions?** This is a standard static website. Any web hosting works!
