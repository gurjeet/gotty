# This file extracts environment variables from manifest.yml (or similar) and
# sends the result to stdout, omitting arrays on the right hand side, e.g.:
# 
#   y2j -r -f ~/getenv.jq < manifest.yml > /tmp/del
#   source /tmp/del
# 
  .applications[].env
| to_entries[]
| select(.value | (type!="array"))
| "export \(.key)=\(.value | @sh)"
