FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN GCP_BUILDPACKS=1 npm run build

FROM node:20-alpine

WORKDIR /app

COPY --from=builder /app/build ./build

ENV HOST=0.0.0.0
ENV PORT=3000
EXPOSE 3000

CMD ["node", "build/index.js"]
