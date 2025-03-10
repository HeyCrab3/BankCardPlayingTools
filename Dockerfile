
FROM node:20.16.0-alpine AS builder
WORKDIR /app


COPY package.json yarn.lock* package-lock.json* ./

RUN npm install


COPY . .


RUN npm run build


FROM node:20.16.0-alpine
WORKDIR /app


COPY --from=builder /app ./


ENV NODE_ENV=production

ENV HOST=0.0.0.0


EXPOSE 3000


CMD ["npm", "run", "preview"]
