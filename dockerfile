FROM node:22-alpine

WORKDIR /app

# Instala pnpm via Corepack
RUN corepack enable && corepack prepare pnpm@10.6.1 --activate

# Instala PM2 globalmente - ESSENCIAL para o start do Postiz
RUN pnpm add -g pm2

# Copia package.json e lockfile primeiro para cache de dependências
COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

# Copia o resto do código
COPY . .

# Build o projeto
RUN pnpm build

# Expõe a porta (Nginx interno usa 5000 no template Temporal)
EXPOSE 5000

# Comando de start: roda o pm2-run do teu package.json
CMD ["pnpm", "start"]
