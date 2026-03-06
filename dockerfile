FROM node:22-alpine

WORKDIR /app

# Instala ferramentas básicas
RUN apk add --no-cache git bash

# Ativa pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

# Instala PM2 globalmente - CORRIGE O ERRO "pm2 not found"
RUN pnpm add -g pm2

# Copia package.json e lockfile para cache
COPY package.json pnpm-lock.yaml ./

# Instala dependências
RUN pnpm install --frozen-lockfile --prefer-offline

# Copia o resto do código
COPY . .

# Build completo
RUN pnpm build

# Remove dev deps
RUN pnpm prune --prod

# Expõe porta do Nginx interno (template Temporal)
EXPOSE 5000

# Start: roda o teu script "start" que chama pm2-run
CMD ["pnpm", "start"]
