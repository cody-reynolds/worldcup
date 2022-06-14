#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# Read all the winning teams into the database
if [[ $WINNER != winner ]]
then

 TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

 #if a team ID doesn't exist...
  if [[ -z $TEAM_ID ]]
  then
   # Create a new entry in the teams table for this team
   # The outcome of this is stored as a variable
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

   # If the new team was created successfully...
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
     echo "Inserted into teams, $WINNER"
    fi
  fi
fi

# Import all the remaining unique opponent teams into the database
if [[ $OPPONENT != opponent ]]
then

 TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

 #if a team ID doesn't exist...
  if [[ -z $TEAM_ID ]]
  then
   # Create a new entry in the teams table for this team
   # The outcome of this is stored as a variable
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

   # If the new team was created successfully...
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
     echo "Inserted into teams, $OPPONENT"
    fi
  fi
fi
done

# Import all the matches into the database

# if the first line isn't a header
# get winner and opponent ids by SELECTing them from the table
# set other variables to the values in the row
# insert the values into the table
# print confirmation to the terminal
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $YEAR != year ]]
  then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  INSERT_MATCH_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")

  if [[ $INSERT_MATCH_RESULT == "INSERT 0 1" ]]
    then
    echo "Inserted into games, $YEAR $ROUND $WINNER $OPPONENT"
  fi
fi
done