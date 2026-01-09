@echo off
echo Setting terminal encoding to UTF-8...
chcp 65001 > nul

echo Starting Spring Boot Server...
mvn spring-boot:run
pause
