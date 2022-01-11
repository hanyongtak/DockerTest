# Debian GNU/Linux 10, openJDK 8, tomcat 8.5.61 버전의 컨테이너를
# docker hub에서 pulling 함 (베이스 이미지)
FROM tomcat:8.5.61-jdk8-openjdk-slim

# 초기 이미지의 webapps/ROOT 디렉토리 삭제 (별도의 설정없이 localhost:8080/ 접속하기위해)
RUN rm -Rf /usr/local/tomcat/webapps/ROOT

# 미리 설정해둔 server.xml의 Context 설정을 세팅하기 위해 server.xml 복사
COPY /src/main/resources/assets/server.xml /usr/local/tomcat/conf

# mvn package 명령어를 통해 war로 말린 프로젝트를 tomcat에 배포
COPY /target/easyCompany2.war /usr/local/tomcat/webapps/ROOT.war

# 로컬 포트와 가상 컨테이너의 포트를 바인딩(IDE의 Docker Bind ports로 세팅할 시, 생략 가능)
# * 가상 컨테이너의 포트는 미설정시 바인딩이 안되기때문에 필수
EXPOSE 8080

# 톰캣 구동
CMD ["catalina.sh", "run"]

# Issue List
# war 파일명과 같은 디렉토리가 webapps 이하에 존재할 때 catalina.sh 실행시 war 압축 해제 안됨
# ssh tunneling을 위해 catalina.sh가 실행되기 전에 pem파일을 webapps/ROOT/src/main/resources 경로에 COPY 하여 생긴 문제
# 기존 소스 ApplicationClosedListener.java의 jsch.addIdentity()메소드에 classpath로 리소스를 가져올 수 없기 때문에
# springframework.util의 ResourcesUtils 클래스를 사용하여 classpath로 접근가능하게 변경함

# Docker 커맨드 정리
# docker build --tag [설정할 컨테이너명]:[설정할 버전, * 생략 가능] -> dockerfile을 빌드할 때 사용

# docker images -> 빌드된 도커 이미지 목록

# docker run -d --name [설정할 컨테이너명] [docker hub 이미지]:[버전] -p [로컬포트]:[컨테이너가상포트] -v /root/centos/data:/data
# -> 도커 이미지 실행 명령어, -d 백그라운드로 실행, --name 컨테이너ID설정, -p 포트 바인딩, -v 로컬 /root/centos/data와 컨테이너 /data를 서로 마운트 함

# docker exec -it [컨테이너명] /bin/bash -> 터미널 접근 가능 (도커 컨테이너가 켜져있을 때 사용가능)

# docker ps -> 실행중인 도커 컨테이너 목록
