#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
INPUT=$1

# PSQL Read Function TABLE COLUMN ROW SELECT
function read_psql(){
  local arg1=$1
  #echo "arg1=$arg1"
  local arg2=$2
  #echo "arg2=$arg2"
  local arg3=$3
  #echo "arg3=$arg3"
  local arg4=$4
  #echo "arg4=$arg4"
  
  TMP=$($PSQL "SELECT $arg4 FROM $arg1 WHERE $arg2='$arg3'");
  #echo "TMP: $TMP"
 
}
#

# Check Argument Empty
if [[ -z $INPUT ]]
    then
      INPUT_NUMBER="empty"
  # Check Argument - Atomic Number
  elif [[ $INPUT =~ ^[0-9]+$ ]]
    then
    #echo "Input Number"
    read_psql "elements" "atomic_number" $INPUT "atomic_number"
    INPUT_NUMBER=$TMP
  # Check Argument - Symbol
  elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]
    then
    #echo "Input Symbol"
    read_psql "elements" "symbol" "$INPUT" "atomic_number"
    INPUT_NUMBER=$TMP
  # Check Argument - Name
  elif [[ $INPUT =~ ^[A-Za-z]{3,20}$ ]]
    then
    #echo "Input Name"
    read_psql "elements" "name" "$INPUT" "atomic_number"
    #echo "read_psql: $0 $1 $2 $3"
    #echo "TMP: $TMP"
    INPUT_NUMBER=$TMP
  else 
    #echo "wrong argument"
    echo $INPUT_NUMBER
fi


#echo "INPUT NUMBER: $INPUT_NUMBER"
if [[ -z $INPUT_NUMBER ]]
  then
  # echo Not Found Output
  echo "I could not find that element in the database."
  
elif [[ $INPUT_NUMBER  == "empty" ]]
  then    
    echo "Please provide an element as an argument."
else
  ATOMIC_NUMBER=$INPUT_NUMBER
  read_psql "elements" "atomic_number" $INPUT_NUMBER "name"
  ATOMIC_NAME=$TMP
  read_psql "elements" "atomic_number" $INPUT_NUMBER "symbol"
  ATOMIC_SYMBOL=$TMP
  
  PROPERTIES_TYPE=$($PSQL "SELECT type FROM types JOIN properties ON types.type_id=properties.type_id WHERE atomic_number=$ATOMIC_NUMBER");
  read_psql "properties" "atomic_number" $INPUT_NUMBER "atomic_mass"
  PROPERTIES_MASS=$TMP
  read_psql "properties" "atomic_number" $INPUT_NUMBER "melting_point_celsius"
  PROPERTIES_MELTING=$TMP
  read_psql "properties" "atomic_number" $INPUT_NUMBER "boiling_point_celsius"
  PROPERTIES_BOILING=$TMP
 
  echo "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $PROPERTIES_TYPE, with a mass of $PROPERTIES_MASS amu. $ATOMIC_NAME has a melting point of $PROPERTIES_MELTING celsius and a boiling point of $PROPERTIES_BOILING celsius."

fi

