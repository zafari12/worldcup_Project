#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $WINNER != "winner" ]]
then
  TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
  #if team name is not found we need to include the new team to the table
      if [[ -z $TEAM1_NAME ]]
        then
         #insert new team
          INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          #echo call to let us know team was inserted
          if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
          then
           echo Inserted team $WINNER
          fi
      fi
fi

if [[ $OPPONENT != "opponent" && $OPPONENT != $WINNER ]]
then
 TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
 if [[ -z $TEAM2_NAME ]]
 then 
  INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
  if [[ INSERT_TEAM2_NAME == "INSERT 0 1" ]]
  then
  echo INSERTED TEAM $OPPONENT
  fi
 fi
fi

if [[ $YEAR != "year" ]]
then
 WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

 echo $WINNER_ID $OPPONENT_ID

 INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
 if [[ $INSERT_GAMES == "INSERT 0 1" ]]
then
 echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
 fi
fi
done
