#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

  echo $($PSQL "TRUNCATE teams, games")

  cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
  do
     if [[ $YEAR != "year" ]]
     then
        TEAM_W=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        if  [[ -z $TEAM_W ]]
        then
          INSERT_WTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
          if [[ $INSERT_WTEAM == "INSERT 0 1" ]]
          then
            echo Inserted into teams from winners, $WINNER
          fi
        fi

        TEAM_O=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        if  [[ -z $TEAM_O ]]
        then
          INSERT_OTEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_OTEAM == "INSERT 0 1" ]]
          then
            echo Inserted into teams from opponents, $OPPONENT
          fi
        fi

        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_G, $OPPONENT_G)")
        if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
          echo Inserted into games
        fi
     fi
  done

