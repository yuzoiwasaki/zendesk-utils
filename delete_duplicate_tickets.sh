#!/bin/sh

#
# Zendesk上にある重複チケットを削除
# @author iwasaki
#

USERNAME=$ZENDESK_USERNAME
PASSWORD=$ZENDESK_PASSWORD
SUBDOMAIN=$ZENDESK_SUBDOMAIN

function delete_ticket() {
  ticket_id=$1
  curl "https://${SUBDOMAIN}.zendesk.com/api/v2/tickets/${ticket_id}.json" \
    -v -u "${USERNAME}:${PASSWORD}" -X DELETE
}

delete_all=false
# --allオプションが指定されていれば全て削除する
if [ "$1" == "--all" ]; then
  delete_all=true
  shift
fi

if [ $# -ne 1 ]; then
  echo 'Invalid arguments: please set keyword to first arg'
  exit 1
fi

keyword=$1
results=`curl "https://${SUBDOMAIN}.zendesk.com/api/v2/search.json" \
  -G --data-urlencode "query=${keyword}" \
  -v -u "${USERNAME}:${PASSWORD}"`
ticket_ids=(`echo $results | sed -e :loop -e 'N; $!b loop' -e 's/\n/\\\n/g' | jq '.results[].id'`)
sorted_ticket_ids=($(for v in "${ticket_ids[@]}"; do echo "$v"; done | sort -n))

count=0
for ticket_id in ${sorted_ticket_ids[@]}
do
  count=`expr $count + 1`
  # 重複要素がなくなったら抜ける
  if [ $count -ge ${#ticket_ids[@]} ] && [ $delete_all == false ]; then
    exit 0
  fi
  delete_ticket $ticket_id
done
