(( $(docker ps -a  | grep meusite 2>/dev/null | wc -l) >= 1 )) && echo \"done\"
