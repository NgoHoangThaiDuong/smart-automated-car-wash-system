@echo off
if not exist build\test\classes mkdir build\test\classes
"C:\Program Files\Java\jdk1.8.0_202\bin\javac.exe" -encoding UTF-8 -cp "lib\sqljdbc4.jar;src\java" -sourcepath src\java -d build\test\classes test\MainTestRunner.java src\java\config\*.java src\java\model\*.java src\java\exception\*.java src\java\repository\*.java src\java\service\*.java src\java\dto\*.java
if %errorlevel% neq 0 (
    echo [ERROR] Buid that bai!
    exit /b %errorlevel%
)
"C:\Program Files\Java\jdk1.8.0_202\bin\java.exe" -cp "build\test\classes;lib\sqljdbc4.jar" MainTestRunner
