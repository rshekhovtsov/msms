echo ------------------------------------------------------------------------------------------------
echo To get monitoring alerts, person should /start your monitoring bot in telegram.
echo Then you enable alerts for person by adding telegram chat_id from list below to recipients file.
echo You specify recipients file in parameter MSMS_RECIPIENTS of .ini file for your service.
echo ------------------------------------------------------------------------------------------------
curl -s https://api.telegram.org/bot$(cat telegram-api-key.txt)/getUpdates \
| python recipients-setup.py