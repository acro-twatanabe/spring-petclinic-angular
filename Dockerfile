FROM node:12-slim AS angular-build

RUN export NG_CLI_ANALYTICS=false
RUN npm -g config set noproxy localhost
RUN npm install -g @angular/cli@8.0.1
COPY . /work/spring-petclinic-angular/
WORKDIR /work/spring-petclinic-angular
RUN npm link; ng build --prod --base-href=/petclinic/ --deploy-url=/petclinic/

FROM docker.io/nginxinc/nginx-unprivileged:latest
COPY --from=angular-build /work/spring-petclinic-angular/nginx/conf/nginx.conf /etc/nginx/nginx.conf
COPY --from=angular-build /work/spring-petclinic-angular/dist /usr/share/nginx/html/petclinic/dist
