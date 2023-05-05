#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert unique teams into the "name" column of the "teams" table
  if [[ $YEAR != "year" ]]
  then
    $PSQL "INSERT INTO teams (name) SELECT '$WINNER' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$WINNER')"
    $PSQL "INSERT INTO teams (name) SELECT '$OPPONENT' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$OPPONENT')"
  # Insert game data into the "games" table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done