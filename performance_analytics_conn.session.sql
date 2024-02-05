
-- Check which DBs already exist in the system
SHOW DATABASES;

-- @block
-- Create the football database
CREATE SCHEMA IF NOT EXISTS football_db;

-- @block
-- Use the football schema/db going forward to create tables in it
USE football_db; 

-- @block
-- Team Table - name of each team
CREATE TABLE IF NOT EXISTS Team (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(125) NOT NULL
    -- These stats are over the course of the season
    season_avg_goals_per_game INT NOT NULL, 
    season_avg_goals_from_inside_the_box INT NOT NULL,
    season_avg_left_foot_goals INT NOT NULL, 
    season_avg_right_foot_goals INT NOT NULL, 
    season_avg_headed_goals INT NOT NULL, 
    season_avg_big_changes_per_game INT NOT NULL, 
    season_avg_big_chances_missed_per_games INT NOT NULL,
    season_avg_total_shots_per_game INT NOT NULL, 
    season_avg_shots_on_target_per_game INT NOT NULL, 
    season_avg_shots_off_target_per_game INT NOT NULL, 
    season_avg_blocked_shots_per_game INT NOT NULL, 
    season_avg_ball_possession INT NOT NULL,
    season_passing_accuracy_in_opp_half INT NOT NULL,
);


-- @block 
INSERT INTO Team (team_name) VALUES
('Brighton'),
('Sheffield');


-- @block
-- Match Details Table - high-level match overview
CREATE TABLE IF NOT EXISTS MatchDetails(
    match_id INT PRIMARY KEY AUTO_INCREMENT, 
    match_date DATE NOT NULL, 

    -- Stats
    home_goals INT NOT NULL, 
    away_goals INT NOT NULL,
    home_possession INT NOT NULL, 
    away_possession INT NOT NULL,
    home_expected_goals DECIMAL(3,2) NOT NULL,
    away_expected_goals DECIMAL(3,2) NOT NULL,
    home_total_shots INT NOT NULL, 
    away_total_shots INT NOT NULL, 
    home_shots_on_target INT NOT NULL, 
    away_shots_on_target INT NOT NULL, 
    home_shots_off_target INT NOT NULL, 
    away_shots_off_target INT NOT NULL, 
    home_big_chances INT NOT NULL, 
    away_big_chances INT NOT NULL, 
    home_big_chances_missed INT NOT NULL, 
    away_big_chances_missed INT NOT NULL, 
    home_shots_inside_box INT NOT NULL, 
    away_shots_inside_box INT NOT NULL, 
    home_shots_outside_box INT NOT NULL, 
    away_shots_outside_box INT NOT NULL, 
    home_accurate_passes INT NOT NULL, 
    away_accurate_passes INT NOT NULL, 
    

    
    -- Foreign Keys
    home_team_fk INT NOT NULL,
    FOREIGN KEY (home_team_fk) REFERENCES Team(team_id),
    away_team_fk INT NOT NULL, 
    FOREIGN KEY (away_team_fk) REFERENCES Team(team_id)
);

-- @block
-- Player Table - Player stats
CREATE TABLE Player(
	player_id INT PRIMARY KEY AUTO_INCREMENT, 

    -- Bio
    player_name VARCHAR(125) NOT NULL, 
    height DECIMAL(5, 2) NOT NULL,
    age INT NOT NULL, 
    preferred_foot CHAR(1) NOT NULL, -- Left, right, neither, stored as L, R and N

    -- Player Stats for the Season 
    total_games_played INT NOT NULL, 
    minutes_per_game INT NOT NULL, 
    games_started INT NOT NULL,
    total_goals INT NOT NULL, 
    expected_goals DECIMAL(3, 2) NOT NULL, 
    goals_per_game DECIMAL(3, 2) NOT NULL, 
    shots_per_game DECIMAL (3, 2) NOT NULL,
    shots_on_target_per_game DECIMAL(3, 2) NOT NULL, 
    big_changes_missed DECIMAL(3, 2) NOT NULL,
    goal_conversion INT NOT NULL, 
    goals_from_inside_the_box DECIMAL(3, 2) NOT NULL, -- The sofascore values will be converted from fractions to decimals
    goals_from_outside_the_box DECIMAL(3, 2) NOT NULL, -- The sofascore values will be converted from fractions to decimals
    headed_goals INT NOT NULL,
    left_foot_goals INT NOT NULL, 
    right_foot_goals INT NOT NULL, 
    total_assists INT NOT NULL, 
    expected_assists DECIMAL(3, 2) NOT NULL, 
    big_chances_created INT NOT NULL,
    avg_passing_accuracy DECIMAL(3,2) NOT NULL, -- accurate_per_game in sofascore
    passing_accuracy_in_opp_half DECIMAL(3,2) NOT NULL, 

    -- Foreign Keys
    team_fk INT NOT NULL, 
    FOREIGN KEY (team_fk) REFERENCES Team(team_id)
);

-- @block
-- Attack Stats Table - A detailed overview of each attempt on goal
CREATE TABLE AttackStats(
	attack_id INT PRIMARY KEY AUTO_INCREMENT, 
    shot_was_on_target TINYINT(1) NOT NULL, -- O for "no", 1 for "yes"
    resulted_in_goal TINYINT(1) NOT NULL, -- 0 for "no", 1 for "yes"
    inside_box TINYINT(1) NOT NULL, -- O for "no", 1 for "yes"
    body_part VARCHAR(20) NOT NULL, -- the part of the player's body the ball hit before going in
    situation VARCHAR(30) NOT NULL,
    expected_goals DECIMAL(3, 2) -- Expected Goal
    expected_goals_on_target DECIMAL(3, 2) -- Expected Goal on Target
    expected_threat DECIMAL(3, 2) -- Expected Threat
    goal_zone VARCHAR(30) NOT NULL,
    player_position VARCHAR(30) NOT NULL,
    preferred_foot_shot TINYINT(1) NOT NULL, -- Preferred Foot Shot, 1 if they shot the ball on their preferred foot and 0 if not.

    -- Foreign Keys
    player_fk INT NOT NULL, -- who scored the goal
    FOREIGN KEY (player_fk) REFERENCES Player(player_id)
);

-- These views will hold the most up to date stats, sourcing data only 
-- from the last 5 games.