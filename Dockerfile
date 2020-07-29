FROM node:12-alpine AS dev
WORKDIR /website
COPY . .
RUN npm install -g gatsby-cli && npm ci
EXPOSE 8000
CMD ["npm", "run", "develop", "--host=0.0.0.0", "--port=8000"]

FROM dev AS builder
RUN yarn build

FROM nginx:stable-alpine AS prod
COPY --from=builder /website/public/ /usr/share/nginx/html
RUN apk add --no-cache curl
HEALTHCHECK CMD curl --silent --fail http://localhost/ || exit 1
