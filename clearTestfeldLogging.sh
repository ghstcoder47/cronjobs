#!/bin/sh

NOW=$(date +"%Y-%m-%d")
START=$(date +%s)
echo ======= LOG Bereinigung ========
echo = Job start: $NOW
echo ================================
echo


ARTIFACT_OLDER_THAN=2 #days
CLEARJOB_LOG_OLDER_THAN=10 #days

#loesche veraltete iskv inhalte
echo 'entferne test artefakte aus iskv'
find ~/testfeld/drg -maxdepth 3 -name "iskv"| while IFS= read -r FILE; do 
  echo "$FILE"
	cd "$FILE" 
  find ./ -type d -mtime +"$ARTIFACT_OLDER_THAN" -print0|xargs -0 rm -rfv
done

#loesche veraltete log dateien aus log
echo 'entferne *.log* aus log'
find ~/testfeld/drg -maxdepth 2 -name "log"| while IFS= read -r FILE; do
  echo "$FILE"
	cd "$FILE"
	find . -name "*.log*" -mtime +"$ARTIFACT_OLDER_THAN" -print0|xargs -0 rm -rfv
done

#loesche veraltete log dateien aus logs
echo 'entferne *.log* aus logs'
find ~/testfeld/drg -maxdepth 2 -name "logs"| while IFS= read -r FILE; do
	echo "$FILE"
	cd "$FILE"
  find . -name "*.log*" -mtime +"$ARTIFACT_OLDER_THAN" -print0|xargs -0 rm -rfv
done

echo 'emtpy nohup.out'
#find ~/testfeld/drg -maxdepth 3 -name "nohup.out" -print0|xargs -0 rm -rfv
find ~/testfeld/drg -maxdepth 2 -name "bin"| while IFS= read -r FILE; do
  cd "$FILE"
  if [ ! -f "nohup.out" ]
  then
    echo '' > nohup.out
  fi
done

echo 'suchen und loeschen log/iskv aus appsrv'
find ~/appsrv/jboss/ -maxdepth 4 -name "iskv"| while IFS= read -r FILE; do
   cd "$FILE"
   find ./ -type d -mtime +"$ARTIFACT_OLDER_THAN" -print0 |xargs -0 rm -rfv
done


echo 'entferne alte cron logs'
find ~/bin/cronjobs/logs -name "*log*" -mtime +"$CLEARJOB_LOG_OLDER_THAN" -print0|xargs -0 rm -rfv

END=$(date +%s)
DIFF=$(( $END - $START ))
echo
echo ======== JOB DONE =====================
echo = "Dauer: $DIFF Sekunden"
echo =                                     =
echo =======================================
