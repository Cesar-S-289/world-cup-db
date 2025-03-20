#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE=$($PSQL "TRUNCATE TABLE games, teams")

# Insert into teams table 
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS;  do

  if [[ $YEAR != "year" ]]
  then

    # Chequear si existe o no el equipo (Recuperar ID) ganador
    ID_WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $ID_WINNER_TEAM ]]
    then
      # en caso de que no estuviiera insertar
      INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $WINNER was inserted in table teams
      # Recuperar nueva ID
      ID_WINNER_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi


    ID_OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $ID_OPPONENT_TEAM ]]
    then
      # en caso de que no estuviiera insertar
      INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $OPPONENT was inserted in table teams
      # Recuperar nueva ID
      ID_OPPONENT_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', '$ID_WINNER_TEAM','$ID_OPPONENT_TEAM',$WINNER_GOALS,$OPPONENT_GOALS)")
    if [[ $GAME = "INSERT 0 1" ]]
    then
      echo Game inserted: $WINNER $WINNER_GOALS - $OPPONENT_GOALS $OPPONENT
    fi
  fi  
done
