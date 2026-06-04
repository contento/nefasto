# Prolog Discourse Generator - Web UI

React-based web frontend for the Prolog Discourse Generator.

## Architecture

```
Client (React, Vite)           Server (SWI-Prolog)
┌──────────────────────────┐   ┌──────────────────────────┐
│  http://localhost:3000   │ ←→ │  http://localhost:3001   │
│  - Web UI (React)        │   │  - REST API              │
│  - Form controls         │   │  - Narrative generation  │
│  - Display narratives    │   │  - DCG & grammars        │
└──────────────────────────┘   └──────────────────────────┘
```

## Requirements

- **Node.js** 14+ ([download](https://nodejs.org/))
- **npm** (comes with Node.js)
- **Prolog server running** on http://localhost:3001

## Setup

### 1. Install Dependencies

```bash
cd web
npm install
```

### 2. Start the Prolog Backend

In a separate terminal:

```bash
cd /path/to/prolog-discourse-gen
swipl -f src/server.pl -t start_server
```

The server will start on `http://localhost:3001`.

### 3. Start the Frontend Development Server

```bash
# From the web/ directory
npm run dev
```

The frontend will open at `http://localhost:3000` (usually auto-opens).

## Features

- **Language Selection**: Switch between English and Spanish
- **Narrative Types**: Choose from Story, Dialogue, or Description
- **Random Seed**: Control reproducibility or generate random narratives
- **Copy to Clipboard**: Quick copy button for generated text
- **Responsive Design**: Works on desktop, tablet, mobile
- **Dark Mode**: Automatic dark mode support

## Development

### Project Structure

```
web/
├── src/
│   ├── App.jsx           # Main React component
│   ├── App.css           # Styling
│   ├── main.jsx          # Entry point
│   └── index.css         # Global styles
├── public/
│   └── index.html        # HTML template (built by Vite)
├── index.html            # Vite template
├── vite.config.js        # Build configuration
├── package.json          # Dependencies
└── .eslintrc.cjs         # Linting rules
```

### Build Commands

```bash
npm run dev       # Start development server
npm run build     # Build for production
npm run preview   # Preview production build
npm run lint      # Check code quality
```

### Environment Variables

Create `.env.local`:

```env
VITE_API_URL=http://localhost:3001
```

Change the URL for production deployment.

## API Endpoints

The frontend calls these Prolog backend endpoints:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/generate` | GET | Generate narrative |
| `/api/languages` | GET | List available languages |
| `/api/narrative-types` | GET | List narrative types |
| `/api/settings` | GET | Get current settings |

### Example Request

```bash
curl "http://localhost:3001/api/generate?lang=es&seed=42&type=simple_story"
```

Response:

```json
{
  "success": true,
  "narrative": "Érase una vez un mago estaba en el bosque...",
  "language": "es",
  "seed": 42,
  "type": "simple_story"
}
```

## Styling

The UI uses CSS Grid and Flexbox for responsive layout:

- **Header**: Gradient background, centered title
- **Main Content**: Two-column layout (controls + output)
- **Controls Panel**: Sticky form with selects and inputs
- **Output Panel**: Displays generated narratives with metadata
- **Info Section**: Educational content about the generator
- **Footer**: Copyright and attribution

### Color Scheme

- Primary: `#0066cc` (blue)
- Secondary: `#cc00cc` (magenta)
- Error: `#cc0000` (red)
- Success: `#00cc00` (green)

### Dark Mode

Automatic dark mode support via `prefers-color-scheme: dark` media query.

## Production Deployment

### Building

```bash
npm run build
```

Creates optimized files in `dist/`.

### Deploying

1. **Backend**: Run Prolog server accessible from frontend URL
2. **Frontend**: Serve `dist/` folder from a web server (nginx, Apache, etc.)
3. **Configuration**: Update `VITE_API_URL` in `.env` to point to Prolog backend

### Example with Nginx

```nginx
server {
    listen 80;
    server_name discourse-gen.example.com;

    # Serve React app
    location / {
        root /path/to/dist;
        try_files $uri /index.html;
    }

    # Proxy API to Prolog backend
    location /api {
        proxy_pass http://localhost:3001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Example with Docker

```dockerfile
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

## Troubleshooting

### "Connection refused" on API calls

**Check**:
1. Is Prolog server running? `swipl -f src/server.pl -t start_server`
2. Is it on port 3001? Check logs.
3. Is `VITE_API_URL` correct? Check `.env` or `vite.config.js`

### Styles not loading

**Fix**:
1. Clear browser cache: `Ctrl+Shift+Delete`
2. Rebuild: `npm run build`
3. Restart dev server: `npm run dev`

### "Module not found"

**Fix**:
1. Install dependencies: `npm install`
2. Check Node version: `node --version` (should be 14+)
3. Clear node_modules: `rm -rf node_modules && npm install`

### CORS errors

**Fix**:
1. Check Prolog server has CORS enabled (`src/server.pl`)
2. Verify `VITE_API_URL` is accessible
3. For development, the proxy in `vite.config.js` should handle it

## Technologies

- **React 18** - UI framework
- **Vite** - Build tool (fast dev server, optimized builds)
- **Axios** - HTTP client
- **CSS3** - Styling (no external frameworks)

## See Also

- [React Docs](https://react.dev/)
- [Vite Docs](https://vitejs.dev/)
- [Axios Docs](https://axios-http.com/)
- [Main README](../README.md)

---

**Happy coding!** 🚀
