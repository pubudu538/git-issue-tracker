@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  eventapp startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options here. You can also use JAVA_OPTS and EVENTAPP_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\eventapp-1.0.jar;%APP_HOME%\lib\synapse-core-2.1.7-wso2v183.jar;%APP_HOME%\lib\synapse-nhttp-transport-2.1.7-wso2v183.jar;%APP_HOME%\lib\httpclient-4.5.2.jar;%APP_HOME%\lib\json-simple-1.1.1.jar;%APP_HOME%\lib\synapse-tasks-2.1.7-wso2v183.jar;%APP_HOME%\lib\synapse-commons-2.1.7-wso2v183.jar;%APP_HOME%\lib\wso2caching-core-4.0.3.jar;%APP_HOME%\lib\axis2-saaj-1.6.1-wso2v54.jar;%APP_HOME%\lib\sandesha2-core-1.6.1-wso2v1.jar;%APP_HOME%\lib\axis2-transport-local-1.6.1-wso2v54.jar;%APP_HOME%\lib\axis2-transport-base-1.6.1-wso2v54.jar;%APP_HOME%\lib\axis2-transport-http-1.6.1-wso2v54.jar;%APP_HOME%\lib\axis2-codegen-1.6.1-wso2v1.jar;%APP_HOME%\lib\addressing-1.6.1-wso2v1.mar;%APP_HOME%\lib\axis2-mtompolicy-1.6.1-wso2v1.jar;%APP_HOME%\lib\axis2-adb-1.6.1-wso2v54.jar;%APP_HOME%\lib\axis2-clustering-1.6.1-wso2v10.jar;%APP_HOME%\lib\axis2-kernel-1.6.1-wso2v54.jar;%APP_HOME%\lib\org.wso2.securevault-1.1.2.jar;%APP_HOME%\lib\jms-1.1.jar;%APP_HOME%\lib\amqp-client-5.8.0.jar;%APP_HOME%\lib\antlr-runtime-3.4.jar;%APP_HOME%\lib\handy-uri-templates-2.1.6.jar;%APP_HOME%\lib\commons-cli-1.0.jar;%APP_HOME%\lib\commons-lang-2.4.jar;%APP_HOME%\lib\commons-text-1.6.wso2v1.jar;%APP_HOME%\lib\commons-text-1.6.jar;%APP_HOME%\lib\jettison-1.1.wso2v1.jar;%APP_HOME%\lib\json-path-2.4.0.wso2v2.jar;%APP_HOME%\lib\wso2eventing-api-2.1.jar;%APP_HOME%\lib\xalan-2.7.2.jar;%APP_HOME%\lib\json-schema-validator-all-2.2.6.wso2v7.jar;%APP_HOME%\lib\jackson-databind-2.10.3.jar;%APP_HOME%\lib\guava-27.0-jre.jar;%APP_HOME%\lib\gson-2.8.5.jar;%APP_HOME%\lib\jackson-core-2.10.3.jar;%APP_HOME%\lib\jackson-annotations-2.10.3.jar;%APP_HOME%\lib\joda-time-2.9.4.wso2v1.jar;%APP_HOME%\lib\libphonenumber-7.4.2.wso2v1.jar;%APP_HOME%\lib\jaeger-client-0.32.0.wso2v4.jar;%APP_HOME%\lib\json-3.0.0.wso2v1.jar;%APP_HOME%\lib\httpcore-nio-4.3.3-wso2v4.jar;%APP_HOME%\lib\httpcore-4.4.4.jar;%APP_HOME%\lib\neethi-2.0.4.jar;%APP_HOME%\lib\axiom-impl-1.2.11.jar;%APP_HOME%\lib\axiom-dom-1.2.11.jar;%APP_HOME%\lib\axiom-api-1.2.11.jar;%APP_HOME%\lib\spring-core-1.2.8.jar;%APP_HOME%\lib\commons-vfs2-2.2-wso2v8.jar;%APP_HOME%\lib\commons-httpclient-3.1.jar;%APP_HOME%\lib\woden-impl-dom-1.0M9.jar;%APP_HOME%\lib\woden-impl-commons-1.0M9.jar;%APP_HOME%\lib\commons-logging-1.2.jar;%APP_HOME%\lib\commons-codec-1.9.jar;%APP_HOME%\lib\jline-0.9.94.jar;%APP_HOME%\lib\junit-4.10.jar;%APP_HOME%\lib\log4j-1.2.14.jar;%APP_HOME%\lib\commons-io-2.0.jar;%APP_HOME%\lib\commons-dbcp-1.2.2.jar;%APP_HOME%\lib\commons-pool-1.3.jar;%APP_HOME%\lib\activation-1.1.1.wso2v3.jar;%APP_HOME%\lib\snmp4j-agent-2.0.5.jar;%APP_HOME%\lib\snmp4j-2.0.3.jar;%APP_HOME%\lib\cache-api-0.5.jar;%APP_HOME%\lib\commons-net-3.4.jar;%APP_HOME%\lib\javax.servlet-api-3.0.1.jar;%APP_HOME%\lib\bcpkix-jdk15on-1.60.0.wso2v1.jar;%APP_HOME%\lib\netty-codec-http-4.1.34.Final.jar;%APP_HOME%\lib\netty-handler-4.1.34.Final.jar;%APP_HOME%\lib\netty-codec-4.1.34.Final.jar;%APP_HOME%\lib\netty-transport-4.1.34.Final.jar;%APP_HOME%\lib\netty-buffer-4.1.34.Final.jar;%APP_HOME%\lib\netty-resolver-4.1.34.Final.jar;%APP_HOME%\lib\netty-common-4.1.34.Final.jar;%APP_HOME%\lib\quartz-2.1.1.jar;%APP_HOME%\lib\geronimo-jta_1.1_spec-1.1.jar;%APP_HOME%\lib\commons-collections-3.2.1.jar;%APP_HOME%\lib\aspectjweaver-1.8.5.jar;%APP_HOME%\lib\slf4j-api-1.7.29.jar;%APP_HOME%\lib\stringtemplate-3.2.1.jar;%APP_HOME%\lib\antlr-2.7.7.jar;%APP_HOME%\lib\geronimo-saaj_1.3_spec-1.0.1.jar;%APP_HOME%\lib\joda-time-2.9.4.jar;%APP_HOME%\lib\commons-lang3-3.8.1.jar;%APP_HOME%\lib\jettison-1.1.jar;%APP_HOME%\lib\json-smart-2.3.jar;%APP_HOME%\lib\asm-1.0.2.jar;%APP_HOME%\lib\rmi-1.0.1.wso2v1.jar;%APP_HOME%\lib\serializer-2.7.2.jar;%APP_HOME%\lib\failureaccess-1.0.jar;%APP_HOME%\lib\listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar;%APP_HOME%\lib\jsr305-3.0.2.jar;%APP_HOME%\lib\checker-qual-2.5.2.jar;%APP_HOME%\lib\error_prone_annotations-2.2.0.jar;%APP_HOME%\lib\j2objc-annotations-1.1.jar;%APP_HOME%\lib\animal-sniffer-annotations-1.17.jar;%APP_HOME%\lib\libphonenumber-7.4.2.jar;%APP_HOME%\lib\json-20140107.jar;%APP_HOME%\lib\hamcrest-core-1.1.jar;%APP_HOME%\lib\geronimo-activation_1.1_spec-1.0.2.jar;%APP_HOME%\lib\geronimo-javamail_1.4_spec-1.6.jar;%APP_HOME%\lib\jaxen-1.1.1.jar;%APP_HOME%\lib\geronimo-stax-api_1.0_spec-1.0.1.jar;%APP_HOME%\lib\wstx-asl-3.2.9.jar;%APP_HOME%\lib\bcpkix-jdk15on-1.60.jar;%APP_HOME%\lib\c3p0-0.9.1.1.jar;%APP_HOME%\lib\xmlunit-1.1.jar;%APP_HOME%\lib\geronimo-ws-metadata_2.0_spec-1.1.2.jar;%APP_HOME%\lib\servlet-api-2.3.jar;%APP_HOME%\lib\commons-fileupload-1.3.1.wso2v1.jar;%APP_HOME%\lib\wsdl4j-1.6.2.jar;%APP_HOME%\lib\XmlSchema-1.4.7.wso2v6.jar;%APP_HOME%\lib\woden-api-1.0M9.jar;%APP_HOME%\lib\jsr311-api-1.0.jar;%APP_HOME%\lib\stax-api-1.0.1.jar;%APP_HOME%\lib\accessors-smart-1.2.jar;%APP_HOME%\lib\asm-3.3.1.jar;%APP_HOME%\lib\xml-apis-1.3.04.jar;%APP_HOME%\lib\bcprov-jdk15on-1.60.jar;%APP_HOME%\lib\tomcat-tribes-7.0.8.jar;%APP_HOME%\lib\tomcat-embed-logging-juli-7.0.8.jar;%APP_HOME%\lib\XmlSchema-1.4.7.jar;%APP_HOME%\lib\asm-5.0.4.jar;%APP_HOME%\lib\tomcat-juli-7.0.8.jar


@rem Execute eventapp
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %EVENTAPP_OPTS%  -classpath "%CLASSPATH%" CalendarQuickstart %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable EVENTAPP_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%EVENTAPP_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
