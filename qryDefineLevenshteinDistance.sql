SET NOCOUNT ON
GO 

DROP TABLE IF EXISTS ZAL_2Dim
GO

CREATE TABLE ZAL_2Dim (d1 INT, d2 INT, val INT)
GO

DROP PROCEDURE ZAL_2Dim_Set
GO

DROP FUNCTION ZAL_2Dim_Get
GO

-- DROP TYPE ZAL_2Dim
-- GO

-- CREATE TYPE ZAL_2Dim AS TABLE  (d1 INT, d2 INT, val INT)
-- GO

CREATE PROCEDURE ZAL_2Dim_Set (@ix1 INT, @ix2 INT, @val INT) AS
BEGIN
    UPDATE ZAL_2Dim SET val = @val WHERE d1 = @ix1 AND d2 = @ix2
END
GO

CREATE FUNCTION ZAL_2Dim_Get (@ix1 INT, @ix2 INT) RETURNS INT AS
BEGIN
    RETURN (SELECT val FROM ZAL_2Dim WHERE d1 = @ix1 AND d2 = @ix2)
END
GO

DROP PROCEDURE IF EXISTS ZAL_2Dim_Log
GO

CREATE PROCEDURE ZAL_2Dim_Log (@Msg VARCHAR(MAX)) AS
BEGIN
    INSERT INTO ZAL_Log(txt) SELECT '[' + CAST(d1 AS VARCHAR(MAX)) + ',' + CAST(d2 AS VARCHAR(MAX)) + '] = ' + CAST(val AS VARCHAR(MAX))FROM ZAL_2Dim
END

DROP PROCEDURE dbo.ZAL_CalcLevenshteinDistance
GO

CREATE OR ALTER PROCEDURE dbo.ZAL_CalcLevenshteinDistance(@s VARCHAR(MAX), @t VARCHAR(MAX), @diff INT OUTPUT) AS --RETURNS INT AS
BEGIN
    -- https://en.wikipedia.org/wiki/Levenshtein_distance
    -- https://www.dotnetperls.com/levenshtein


-- public static int Compute(string s, string t)
--     {
--         int n = s.Length;
    DECLARE @n INT = LEN(@s)
--         int m = t.Length;
    DECLARE @m INT = LEN(@t)

--         int[,] d = new int[n + 1, m + 1];
    DECLARE @ix1 INT
    DECLARE @ix2 INT
    -- DECLARE @d ZAL_2Dim

    SET @ix1 = 0
    WHILE @ix1 <= @n
    BEGIN

        SET @ix2 = 0
        WHILE @ix2 <= @m
        BEGIN
            INSERT ZAL_2Dim VALUES (@ix1, @ix2, 0)
            SET @ix2 = @ix2 + 1
        END

        SET @ix1 = @ix1 + 1
    END

    EXEC ZAL_2Dim_Log 'INIT'

--         // Step 1
--         if (n == 0)
--         {
--             return m;
--         }

--         if (m == 0)
--         {
--             return n;
--         }

--         // Step 2
--         for (int i = 0; i <= n; d[i, 0] = i++)
--         {
--         }

--         for (int j = 0; j <= m; d[0, j] = j++)
--         {
--         }

--         // Step 3
--         for (int i = 1; i <= n; i++)
--         {
--             //Step 4
--             for (int j = 1; j <= m; j++)
--             {
--                 // Step 5
--                 int cost = (t[j - 1] == s[i - 1]) ? 0 : 1;

--                 // Step 6
--                 d[i, j] = Math.Min(
--                     Math.Min(d[i - 1, j] + 1, d[i, j - 1] + 1),
--                     d[i - 1, j - 1] + cost);
--             }
--         }
--         // Step 7
--         return d[n, m];
--     }
-- }

END
GO

--DROP PROCEDURE #ZAL_Do

CREATE OR ALTER PROCEDURE #ZAL_Do (@s1 VARCHAR(MAX), @s2 VARCHAR(MAX)) AS
BEGIN
    print 'running'
    DECLARE @os1 VARCHAR(MAX) = @s1
    DECLARE @os2 VARCHAR(MAX) = @s2
    --DECLARE @d INT = (SELECT dbo.ZAL_CalcLevenshteinDistance(@s1, @s2))
    DECLARE @ret INT
    EXECUTE dbo.ZAL_CalcLevenshteinDistance @s1, @s2, @diff = @ret  OUTPUT
    --SELECT @ret, @os1, @os2
    INSERT INTO ZAL_Log (txt) VALUES (CAST(ISNULL(@ret,'') AS VARCHAR(MAX)) + ',' + CAST(@os1 AS VARCHAR(MAX)) + ',' +  + CAST(@os2 AS VARCHAR(MAX)))
END
GO 

DROP TABLE IF EXISTS ZAL_Log
GO

CREATE TABLE ZAL_Log (Seq INT IDENTITY (1,1), txt VARCHAR(MAX))
GO

EXEC  #ZAL_Do 'ALBERTargsrto', 'ALBERT'
GO

SELECT TOP 1000 * FROM ZAL_Log ORDER BY Seq

---

/*

public static int Compute(string s, string t)
    {
        int n = s.Length;
        int m = t.Length;
        int[,] d = new int[n + 1, m + 1];

        // Step 1
        if (n == 0)
        {
            return m;
        }

        if (m == 0)
        {
            return n;
        }

        // Step 2
        for (int i = 0; i <= n; d[i, 0] = i++)
        {
        }

        for (int j = 0; j <= m; d[0, j] = j++)
        {
        }

        // Step 3
        for (int i = 1; i <= n; i++)
        {
            //Step 4
            for (int j = 1; j <= m; j++)
            {
                // Step 5
                int cost = (t[j - 1] == s[i - 1]) ? 0 : 1;

                // Step 6
                d[i, j] = Math.Min(
                    Math.Min(d[i - 1, j] + 1, d[i, j - 1] + 1),
                    d[i - 1, j - 1] + cost);
            }
        }
        // Step 7
        return d[n, m];
    }
}

*/