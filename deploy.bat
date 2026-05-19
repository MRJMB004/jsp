@echo off
echo =====================================
echo   BUILD MAVEN PROJECT
echo =====================================

cd /d C:\Users\asus\IdeaProjects\Reservation

call mvn clean package

echo =====================================
echo   COPY WAR TO TOMCAT
echo =====================================

set TOMCAT=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps

copy /Y target\ProjetCooperative.war "%TOMCAT%\ProjetCooperative.war"

echo =====================================
echo   DEPLOY DONE
echo =====================================

pause