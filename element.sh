#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c "
FILTRO=$1

CONSULT_PARAMETERS(){
  if [[ -z $1 ]]
  then
   echo "Please provide an element as an argument.$1"
  else
   CONSULT_PERIODIC_TABLE
  fi
}

CONSULT_PERIODIC_TABLE(){
    DATOS=$($PSQL "select e.atomic_number
                    , e.name
                    , e.symbol
                    , t.type
                    , p.atomic_mass
                    , p.melting_point_celsius
                    , p.boiling_point_celsius
                    from elements e
                    left join properties p on e.atomic_number = p.atomic_number
                    left join types t on p.type_id = t.type_id
                    where e.atomic_number::varchar = '$FILTRO'
                    or e.name = '$FILTRO'
                    or e.symbol = '$FILTRO'")
    if [[ -z $DATOS ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$DATOS" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    fi
}

CONSULT_PARAMETERS $1
