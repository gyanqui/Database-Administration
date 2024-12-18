-- What is Windows authentication in SQL Server? What is one benefit of Windows Authentication over SQL Authentication?
-- Windows Authentication: Windows Authentication allows users to connect to SQL Server using their Windows credentials (username and password). This means you don’t need to remember a specific password for SQL Server; instead, you use the same one you use to log in to your computer.

-- Benefit: An important benefit of Windows Authentication is security. Since it uses Active Directory (a Microsoft identity management service), you can manage users and their permissions centrally. If a user changes their password in Windows, they do not have to change it in SQL Server, which reduces the risk of errors and improves security.


-- Explain the difference between authentication and authorization. Give an example of authorization in the database.
-- Authentication: Authentication is the process of verifying a user's identity. It’s like showing your ID to prove who you are. In SQL Server, this is done when logging in and checking credentials.

-- Authorization: Authorization occurs after authentication and refers to what resources or actions a user is permitted to access. It’s like having an ID that not only states who you are but also which areas you can access.

-- Example of authorization in the database: If you have a database that contains employee information and decide that only certain users can view that information, you can grant specific permissions. For example, you might give a specific user permission to perform queries (SELECT) on a table called "Employees." This means that, even though the user has been authenticated (identified), they will only be able to access the information they have been permitted to see.


-- What would happen if you grant SELECT permission on a table to the fixed database role called ‘public’? Would this granted permission apply to future users (users that are not created yet)? Why could this be dangerous?
-- Granting SELECT permission to ‘public’: When you grant SELECT permission to a role called ‘public,’ you are granting access to all users of the database, including those who may be created in the future. This means that anyone with a user account in that database will be able to see the data in the table to which you have granted access.

-- Application to future users: Yes, this permission applies to all future users that are created in the database. It does not matter when they are created; they will all automatically have access to that table.

-- Danger: This can be very dangerous because you could be exposing sensitive or confidential information to people who should not have access to it. For example, if your table contains employee data with personal information, any new user could see that data without needing additional authorization. It is crucial to be careful when granting permissions, especially to the ‘public’ role, to avoid data leaks or unauthorized access.



-- 2)You have heard that using ‘schemas’ can give you added flexibility and 
-- control in database security. You decide to test this by doing the following:

-- A) Create two new schemas for the Bowling database and two more for an
-- additional database of your choice. You will be creating four schemas total.

USE [BowlingLeagueExample]
GO
-- Create schema for game-related data
CREATE SCHEMA [GameData]
GO
-- Create schema for player-related data
CREATE SCHEMA [PlayerData]
GO

USE [RecipesExample]
GO
-- Create schema for Recipe-related data
CREATE SCHEMA [RecipeData]
GO
-- Create schema for Ingredient-related data
CREATE SCHEMA [IngredientData]
GO

-- B) Transfer the tables in the bowling database and your chosen database out of 
-- the dbo (database owner) schema and into the four new schemas. How you choose to 
-- separate the tables into these schemas is completely up to you (you will not be 
-- graded on that choice). NOTE: Tables can only belong to one schema.

-- BowlingLeagueExample database
-- Move tables to GameData schema
ALTER SCHEMA GameData TRANSFER Bowler_Scores;
ALTER SCHEMA GameData TRANSFER Match_Games;
ALTER SCHEMA GameData TRANSFER Tourney_Matches;
ALTER SCHEMA GameData TRANSFER Teams;

-- Move tables to PlayerData schema
ALTER SCHEMA PlayerData TRANSFER Bowlers;
ALTER SCHEMA PlayerData TRANSFER ztblBowlerRatings;
GO

-- RecipesExample database
-- Move tables to RecipeData schema
ALTER SCHEMA RecipeData TRANSFER Recipes;
ALTER SCHEMA RecipeData TRANSFER Recipe_Classes;
ALTER SCHEMA RecipeData TRANSFER Recipe_Ingredients;

-- Move tables to IngredientData schema
ALTER SCHEMA IngredientData TRANSFER Ingredients;
ALTER SCHEMA IngredientData TRANSFER Ingredients_Classes;
ALTER SCHEMA IngredientData TRANSFER Measurements;
GO


-- C) Create four new logins and map them to each database (two for each database). 
-- Issue a grant command that will give SELECT rights on an entire schema (one for each user). 
-- Do this for each of the four logins. Test this authorization by logging in with these new users.

-- CREATE 4 USERS
USE [master]
GO
CREATE LOGIN [test1] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
GO
CREATE LOGIN [test2] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
GO
CREATE LOGIN [test3] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
GO
CREATE LOGIN [test4] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- CREATE LOGIN USER For BowlingLeagueExample table
USE [BowlingLeagueExample]
GO
CREATE USER [test1] FOR LOGIN [test1]
GO
CREATE USER [test2] FOR LOGIN [test2]
GO

-- CREATE LOGIN USER For RecipesExample table
USE [RecipesExample]
GO
CREATE USER [test3] FOR LOGIN [test3]
GO
CREATE USER [test4] FOR LOGIN [test4]
GO

-- MAPPING USERS TO database (two for each database) and issue a grant command that will 
-- give SELECT rights on an entire schema

-- Grant SELECT permissions for BowlingLeagueExample
USE [BowlingLeagueExample]
GO
GRANT SELECT ON SCHEMA::[GameData] TO [test1]
GO
GRANT SELECT ON SCHEMA::[PlayerData] TO [test2]
GO

-- Grant SELECT permissions for RecipesExample
USE [RecipesExample]
GO
GRANT SELECT ON SCHEMA::[RecipeData] TO [test3]
GO
GRANT SELECT ON SCHEMA::[IngredientData] TO [test4]
GO

-- 3) With “user-defined roles,” determine a common level of authorization privileges new users should 
-- have in one database of your choice. This may be different for each business model (database) 
-- according to your discretion.

-- A) First, you decide to create a list of DCL (Data Control Language or “GRANT commands”)
-- to assign to every future entry-level user of a given database. You can choose 
-- whatever you would like for the users to be authorized to do.HINT: Here is a student 
-- example of practicing DCL for two test users.

-- i: All DCL code (“GRANT” statements) from step ‘a’ above.

GRANT INSERT ON [dbo].[RecipesExample] TO [future entry-level user]
GRANT SELECT ON [dbo].[RecipesExample] TO [future entry-level user]
GRANT DELETE ON [dbo].[RecipesExample] TO [future entry-level user]
GRANT UPDATE ON [dbo].[RecipesExample] TO [future entry-level user]
GRANT ALTER ON [dbo].[RecipesExample] TO [future entry-level user];




-- B) Then, you get smarter and realize you can use a user-defined role, as explained in Chapter 12, 
-- instead of issuing so many separate GRANTS for each individual user. Create a role for new employees 
-- and grant the permissions you listed in ‘3a’ directly to the new role instead. HINT: Here is the 
-- student example from this week’s preparation post on how to use a fixed role for permissions
-- In your case, you will instead add users to the custom role you create.

-- ii: The process you used to create a role with the needed DCL authorization commands instead.

-- Create a new role called NewEmployees
CREATE ROLE NewEmployees;
-- Grant permissions to the NewEmployees role
GRANT INSERT ON [RecipeData].[Recipes] TO NewEmployees;
GRANT SELECT ON [RecipeData].[Recipes] TO NewEmployees;
GRANT DELETE ON [RecipeData].[Recipes] TO NewEmployees;
GRANT UPDATE ON [RecipeData].[Recipes] TO NewEmployees;
GRANT ALTER ON [RecipeData].[Recipes] TO NewEmployees;

-- C) Create two new database logins/users and add them as members to the new role from ‘3b’ instead 
-- of granting the permissions one by one directly to the users. In this manner, you save time and are 
-- less error-prone.

-- iii: Proof that the new role works as it should for your two new logins/users.

-- CREATE 2 NEW USERS
USE [master]
GO
CREATE LOGIN [NewUser1] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE [master]
GO
CREATE LOGIN [NewUser2] WITH PASSWORD=N'password', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE RecipesExample;
-- Create new users (or logins) for the database
CREATE USER NewUser1 FOR LOGIN NewUser1;
CREATE USER NewUser2 FOR LOGIN NewUser2;

-- Add the users to the NewEmployees role
ALTER ROLE NewEmployees ADD MEMBER NewUser1;
ALTER ROLE NewEmployees ADD MEMBER NewUser2;

-- TEST NewUser1

USE RecipesExample;

-- SELECT STATEMENT TEST
SELECT
	*
from 
	RecipeData.Recipes;

-- INSERT STATEMENT TEST
INSERT INTO RecipeData.Recipes (RecipeID, RecipeTitle, RecipeClassID, Preparation, Notes)
VALUES
	(45, 'Pollo Asado', 1, 'text', NULL);


-- UPDATE STATEMENT TEST
UPDATE RecipeData.Recipes
SET 
    Preparation = 'Wash chicken pieces thoroughly in cold water. Pat dry and set aside.
Mince garlic and then mix it with the salt, pepper, and cayenne. Make sure the mixture is combined as thoroughly as possible.
Coat each chicken piece (to taste) with the mixture. 
Place pieces in the broiler pan and cook for 15 minutes. Turn pieces and cook for another 15 minutes. Turn pieces once more and cook for 35 - 40 minutes.
When the chicken is cooked, remove from stove and let it stand for 10 minutes.'
WHERE 
	RecipeID = 45;

-- DELETE STATEMENT TEST
DELETE FROM
	RecipeData.Recipes
WHERE
	RecipeID = 45;

-- TEST NewUser2 
-- INSERT STATEMENT TEST
INSERT INTO RecipeData.Recipes (RecipeID, RecipeTitle, RecipeClassID, Preparation, Notes)
VALUES
	(45, 'Pollo Asado', 1, 'text', NULL);


-- UPDATE STATEMENT TEST
UPDATE RecipeData.Recipes
SET 
    Preparation = 'Wash chicken pieces thoroughly in cold water. Pat dry and set aside.
Mince garlic and then mix it with the salt, pepper, and cayenne. Make sure the mixture is combined as thoroughly as possible.
Coat each chicken piece (to taste) with the mixture. 
Place pieces in the broiler pan and cook for 15 minutes. Turn pieces and cook for another 15 minutes. Turn pieces once more and cook for 35 - 40 minutes.
When the chicken is cooked, remove from stove and let it stand for 10 minutes.'
WHERE 
	RecipeID = 45;

-- DELETE STATEMENT TEST
DELETE FROM
	RecipeData.Recipes
WHERE
	RecipeID = 45;

-- 4) Investigate these security related data dictionary entries to an external site. 
-- (or others you may find) to see where you can see evidence of the new schemas, logins, 
-- users, or role from this assignment in the data dictionary.
	
-- i: A query and results that include data dictionary information showing evidence of 
-- something you did in this assignment (perhaps a query that shows a new schema, login, 
-- or user-defined role you created in steps 1, 2, or 3).


-- Query to check the schemas created in step 2
SELECT 
	schema_id, name
FROM 
	sys.schemas
WHERE 
	name IN ('RecipeData', 'IngredientData');

-- Query to check the user-defined roles in the database
SELECT 
	name, 
	type, 
	create_date
FROM 
	sys.database_principals
WHERE 
	type = 'R' AND name = 'NewEmployees';

-- ii: One additional data dictionary query regarding anything in database security that 
-- might be useful to the business going forward. Include the query, the results, and your 
-- explanation for why it would be a useful security report.

-- Query to retrieve all permissions granted in the current database
SELECT 
	pr.principal_id, 
	pr.name, 
	pr.type_desc,    
	pe.state_desc, 
	pe.permission_name  
FROM 
	sys.database_principals AS pr  
JOIN 
	sys.database_permissions AS pe ON pe.grantee_principal_id = pr.principal_id
WHERE
	pr.name = 'NewEmployees';
