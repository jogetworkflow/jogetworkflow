@echo off

if ""%1"" == """" goto usage
if ""%2"" == """" goto usage

:create
mvn archetype:create -DarchetypeGroupId=org.joget -DarchetypeArtifactId=wflow-plugin-archetype -DarchetypeVersion=2.0-SNAPSHOT -DgroupId=%1 -DartifactId=%2
goto end

:usage
echo   Usage: create-plugin (package) (pluginName)

:end


