@ECHO OFF

IF NOT EXIST %2 (git clone %1/%2%3 -c core.autocrlf=true
) ELSE (
ECHO UPDATING %2
cd %2
	git rebase
	cd ..
)

