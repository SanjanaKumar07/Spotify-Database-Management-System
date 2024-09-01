CREATE TRIGGER ValidateEmailAfterInsert
ON UserGraph
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Email NOT LIKE '%_@__%.__%'
    )
    BEGIN
        RAISERROR('Invalid email format', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;




CREATE TRIGGER LogNewUserAfterInsert
ON UserGraph
AFTER INSERT
AS
BEGIN
    INSERT INTO UserLogs (UserID, Action, Timestamp)
    SELECT UserID, 'INSERT', GETDATE()
    FROM inserted;
END;



CREATE TRIGGER ValidateGenderAfterUpdate
ON UserGraph
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Gender NOT IN ('Male', 'Female', 'Other')
    )
    BEGIN
        RAISERROR('Invalid gender value', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;



CREATE TRIGGER LogChangesAfterUpdate
ON UserGraph
AFTER UPDATE
AS
BEGIN
    INSERT INTO UserLogs (UserID, Action, Timestamp)
    SELECT UserID, 'UPDATE', GETDATE()
    FROM inserted;
END;






CREATE PROCEDURE AddUser
    @UserName VARCHAR(100),
    @Email VARCHAR(255),
    @Gender VARCHAR(10),
    @ListeningDevice VARCHAR(100),
    @Region VARCHAR(100),
    @Followers INT,
    @SubscriptionID INT,
    @PaymentID INT
AS
BEGIN
    INSERT INTO UserGraph (UserName, Email, Gender, ListeningDevice, Region, Followers, SubscriptionID, PaymentID)
    VALUES (@UserName, @Email, @Gender, @ListeningDevice, @Region, @Followers, @SubscriptionID, @PaymentID);
END;





CREATE PROCEDURE UpdateUserEmail
    @UserID INT,
    @NewEmail VARCHAR(255)
AS
BEGIN
    UPDATE UserGraph
    SET Email = @NewEmail
    WHERE UserID = @UserID;
END;




CREATE PROCEDURE DeleteUser
    @UserID INT
AS
BEGIN
    DELETE FROM UserGraph WHERE UserID = @UserID;
END;





CREATE PROCEDURE GetUserDetails
    @UserID INT
AS
BEGIN
    SELECT * FROM UserGraph WHERE UserID = @UserID;
END;


CREATE PROCEDURE IncrementFollowers
    @UserID INT
AS
BEGIN
    UPDATE UserGraph
    SET Followers = Followers + 1
    WHERE UserID = @UserID;
END;




CREATE TRIGGER ValidatePopularityAfterInsert
ON SongGraph
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Popularity < 0 OR Popularity > 100
    )
    BEGIN
        RAISERROR('Popularity must be between 0 and 100', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;





CREATE TRIGGER LogNewSongAfterInsert
ON SongGraph
AFTER INSERT
AS
BEGIN
    INSERT INTO SongLogs (SongID, Action, Timestamp)
    SELECT SongID, 'INSERT', GETDATE()
    FROM inserted;
END;




CREATE TRIGGER ValidateDurationAfterUpdate
ON SongGraph
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Duration_ms <= 0
    )
    BEGIN
        RAISERROR('Duration must be positive', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;








CREATE PROCEDURE AddSong
    @Track_number INT,
    @Album_name VARCHAR(100),
    @Track_name VARCHAR(100),
    @Popularity INT,
    @Duration_ms INT,
    @Explicit FLOAT
AS
BEGIN
    INSERT INTO SongGraph (Track_number, Album_name, Track_name, Popularity, Duration_ms, Explicit)
    VALUES (@Track_number, @Album_name, @Track_name, @Popularity, @Duration_ms, @Explicit);
END;





CREATE PROCEDURE UpdateSongPopularity
    @SongID INT,
    @NewPopularity INT
AS
BEGIN
    UPDATE SongGraph
    SET Popularity = @NewPopularity
    WHERE SongID = @SongID;
END;





CREATE PROCEDURE DeleteSong
    @SongID INT
AS
BEGIN
    DELETE FROM SongGraph WHERE SongID = @SongID;
END;


CREATE PROCEDURE GetSongDetails
    @SongID INT
AS
BEGIN
    SELECT * FROM SongGraph WHERE SongID = @SongID;
END;



CREATE PROCEDURE UpdateSongDuration
    @SongID INT,
    @NewDuration_ms INT
AS
BEGIN
    UPDATE SongGraph
    SET Duration_ms = @NewDuration_ms
    WHERE SongID = @SongID;
END;





CREATE TRIGGER ValidatePlaylistNameAfterInsert
ON PlaylistGraph
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE PlaylistName = ''
    )
    BEGIN
        RAISERROR('Playlist name cannot be empty', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;




CREATE TRIGGER LogNewPlaylistAfterInsert
ON PlaylistGraph
AFTER INSERT
AS
BEGIN
    INSERT INTO PlaylistLogs (PlaylistID, Action, Timestamp)
    SELECT PlaylistID, 'INSERT', GETDATE()
    FROM inserted;
END;






CREATE PROCEDURE GetPlaylistDetails
    @PlaylistID INT
AS
BEGIN
    SELECT * FROM PlaylistGraph WHERE PlaylistID = @PlaylistID;
END;






CREATE TRIGGER ValidatePlaylistNameAfterUpdate
ON PlaylistGraph
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE PlaylistName = ''
    )
    BEGIN
        RAISERROR('Playlist name cannot be empty', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;






CREATE PROCEDURE AddPlaylist
    @PlaylistName VARCHAR(100)
AS
BEGIN
    INSERT INTO PlaylistGraph (PlaylistName)
    VALUES (@PlaylistName);
END;



CREATE PROCEDURE UpdatePlaylistName
    @PlaylistID INT,
    @NewPlaylistName VARCHAR(100)
AS
BEGIN
    UPDATE PlaylistGraph
    SET PlaylistName = @NewPlaylistName
    WHERE PlaylistID = @PlaylistID;
END;




CREATE PROCEDURE DeletePlaylist
    @PlaylistID INT
AS
BEGIN
    DELETE FROM PlaylistGraph WHERE PlaylistID = @PlaylistID;
END;





CREATE PROCEDURE UpdateUser
    @UserID INT,
    @UserName VARCHAR(100),
    @Email VARCHAR(255),
    @Gender VARCHAR(10),
    @ListeningDevice VARCHAR(100),
    @Region VARCHAR(100),
    @Followers INT,
    @SubscriptionID INT,
    @PaymentID INT
AS
BEGIN
    UPDATE UserGraph
    SET 
        UserName = @UserName,
        Email = @Email,
        Gender = @Gender,
        ListeningDevice = @ListeningDevice,
        Region = @Region,
        Followers = @Followers,
        SubscriptionID = @SubscriptionID,
        PaymentID = @PaymentID
    WHERE UserID = @UserID;
END;







CREATE PROCEDURE UpdateSong
    @SongID INT,
    @Track_number INT,
    @Album_name VARCHAR(100),
    @Track_name VARCHAR(100),
    @Popularity INT,
    @Duration_ms INT,
    @Explicit FLOAT
AS
BEGIN
    UPDATE SongGraph
    SET 
        Track_number = @Track_number,
        Album_name = @Album_name,
        Track_name = @Track_name,
        Popularity = @Popularity,
        Duration_ms = @Duration_ms,
        Explicit = @Explicit
    WHERE SongID = @SongID;
END;







CREATE PROCEDURE UpdatePlaylist
    @PlaylistID INT,
    @PlaylistName VARCHAR(100)
AS
BEGIN
    UPDATE PlaylistGraph
    SET 
        PlaylistName = @PlaylistName
    WHERE PlaylistID = @PlaylistID;
END;



---------------------------





-- Relational Stored Procedures and Triggers

-- insert procedures
-- Procedure to insert a new user
CREATE PROCEDURE InsertUser
    @UserName VARCHAR(max),
    @Email VARCHAR(max),
    @Gender VARCHAR(max),
    @ListeningDevice VARCHAR(max),
    @Region VARCHAR(max),
    @Followers INT,
    @SubscriptionID INT,
    @PaymentID INT
AS
BEGIN
    INSERT INTO tblUser (UserName, Email, Gender, ListeningDevice, Region, Followers, SubscriptionID, PaymentID)
    VALUES (@UserName, @Email, @Gender, @ListeningDevice, @Region, @Followers, @SubscriptionID, @PaymentID);
END;
GO

-- Procedure to insert a new payment method
CREATE PROCEDURE InsertPaymentMethod
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    INSERT INTO tblPaymentMethod (PaymentMethod)
    VALUES ( @PaymentMethod);
END;
GO

-- Procedure to insert a new subscription plan
CREATE PROCEDURE InsertSubscriptionPlan
    @SubscriptionType NVARCHAR(255)
AS
BEGIN
    INSERT INTO tblSubscriptionPlan (SubscriptionType)
    VALUES (@SubscriptionType);
END;
GO

-- update rows
-- Procedure to update an existing user
CREATE PROCEDURE UpdateUser_Relational
    @UserID INT,
    @UserName VARCHAR(MAX),
    @Email VARCHAR(MAX),
    @Gender VARCHAR(MAX),
    @ListeningDevice VARCHAR(MAX),
    @Region VARCHAR(MAX),
    @Followers INT,
    @SubscriptionID INT,
    @PaymentID INT
AS
BEGIN
    UPDATE tblUser
    SET UserName = @UserName,
        Email = @Email,
        Gender = @Gender,
        ListeningDevice = @ListeningDevice,
        Region = @Region,
        Followers = @Followers,
        SubscriptionID = @SubscriptionID,
        PaymentID = @PaymentID
    WHERE UserID = @UserID;
END;
GO

-- Procedure to update an existing payment method
CREATE PROCEDURE UpdatePaymentMethod
    @PaymentTypeID INT,
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    UPDATE tblPaymentMethod
    SET PaymentMethod = @PaymentMethod
    WHERE PaymentTypeID = @PaymentTypeID;
END;
GO

-- Procedure to update an existing subscription plan
CREATE PROCEDURE UpdateSubscriptionPlan
    @SubscriptionID INT,
    @SubscriptionType NVARCHAR(255)
AS
BEGIN
    UPDATE tblSubscriptionPlan
    SET SubscriptionType = @SubscriptionType
    WHERE SubscriptionID = @SubscriptionID;
END;
GO

-- delete rows
-- Procedure to delete an existing user
CREATE PROCEDURE DeleteUser_Relational
    @UserID INT
AS
BEGIN
    DELETE FROM tblUser WHERE UserID = @UserID;
END;
GO

-- Procedure to delete an existing payment method
CREATE PROCEDURE DeletePaymentMethod
    @PaymentTypeID INT
AS
BEGIN
    DELETE FROM tblPaymentMethod WHERE PaymentTypeID = @PaymentTypeID;
END;
GO

-- Procedure to delete an existing subscription plan
CREATE PROCEDURE DeleteSubscriptionPlan
    @SubscriptionID INT
AS
BEGIN
    DELETE FROM tblSubscriptionPlan WHERE SubscriptionID = @SubscriptionID;
END;
GO

-- triggers
-- Ensure the tblUser table has a LastUpdated column
ALTER TABLE tblUser
ADD LastUpdated DATETIME;

-- Trigger to update LastUpdated column on update
CREATE TRIGGER trgUpdateLastUpdated
ON tblUser
AFTER UPDATE
AS
BEGIN
    UPDATE tblUser
    SET LastUpdated = GETDATE()
    FROM tblUser INNER JOIN inserted ON tblUser.UserID = inserted.UserID;
END;
GO

-- Create audit table
CREATE TABLE tblUserAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    OldUserName VARCHAR(MAX),
    NewUserName VARCHAR(MAX),
    OldEmail VARCHAR(MAX),
    NewEmail VARCHAR(MAX),
    OldGender VARCHAR(MAX),
    NewGender VARCHAR(MAX),
    OldListeningDevice VARCHAR(MAX),
    NewListeningDevice VARCHAR(MAX),
    OldFollowers INT,
    NewFollowers INT,
    OldSubscriptionID INT,
    NewSubscriptionID INT,
    OldPaymentID INT,
    NewPaymentID INT,
    ChangeDate DATETIME DEFAULT GETDATE()
);

-- Trigger to log changes to tblUser
CREATE TRIGGER trgAuditUserChanges
ON tblUser
AFTER UPDATE
AS
BEGIN
    INSERT INTO tblUserAudit (UserID, OldUserName, NewUserName, OldEmail, NewEmail, OldGender, NewGender, OldListeningDevice, NewListeningDevice, OldFollowers, NewFollowers, OldSubscriptionID, NewSubscriptionID, OldPaymentID, NewPaymentID)
    SELECT 
        d.UserID,
        d.UserName AS OldUserName, i.UserName AS NewUserName,
        d.Email AS OldEmail, i.Email AS NewEmail,
        d.Gender AS OldGender, i.Gender AS NewGender,
        d.ListeningDevice AS OldListeningDevice, i.ListeningDevice AS NewListeningDevice,
        d.Followers AS OldFollowers, i.Followers AS NewFollowers,
        d.SubscriptionID AS OldSubscriptionID, i.SubscriptionID AS NewSubscriptionID,
        d.PaymentID AS OldPaymentID, i.PaymentID AS NewPaymentID
    FROM deleted d
    INNER JOIN inserted i ON d.UserID = i.UserID;
END;
GO






---------------------------------------------------------





----stored proc for Inserting/Updating Artists
CREATE PROCEDURE usp_UpsertArtist
    @ArtistId INT,
    @ArtistName NVARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tblArtist WHERE ArtistId = @ArtistId)
    BEGIN
        UPDATE tblArtist
        SET ArtistNames = @ArtistName
        WHERE ArtistId = @ArtistId;
    END
    ELSE
    BEGIN
        INSERT INTO tblArtist (ArtistId, ArtistNames)
        VALUES (@ArtistId, @ArtistName);
    END
END;

----stored proc for Inserting/Updating Songs
CREATE PROCEDURE usp_UpsertSong
    @SongId INT,
    @TrackNumber INT,
    @AlbumName NVARCHAR(255),
    @TrackName NVARCHAR(255),
    @Popularity INT,
    @DurationMs INT,
    @Explicit BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tblSong WHERE SongId = @SongId)
    BEGIN
        UPDATE tblSong
        SET Track_Number = @TrackNumber,
            Album_Name = @AlbumName,
            Track_Name = @TrackName,
            Popularity = @Popularity,
            Duration_Ms = @DurationMs,
            Explicit = @Explicit
        WHERE SongId = @SongId;
    END
    ELSE
    BEGIN
        INSERT INTO tblSong (SongId, Track_Number, Album_Name, Track_Name, Popularity, Duration_Ms, Explicit)
        VALUES (@SongId, @TrackNumber, @AlbumName, @TrackName, @Popularity, @DurationMs, @Explicit);
    END
END;

----stored proc for Inserting/Updating AudioFeatures
CREATE PROCEDURE usp_UpsertAudioFeatures
    @AudioId INT,
    @Danceability FLOAT,
    @Energy FLOAT,
    @Loudness FLOAT,
    @Mode INT,
    @Speechiness FLOAT,
    @Acousticness FLOAT,
    @Instrumentalness FLOAT,
    @Liveness FLOAT,
    @Valence FLOAT,
    @Tempo FLOAT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM tblAudioFeatures WHERE Audio_Id = @AudioId)
    BEGIN
        UPDATE AudioFeatures
        SET Danceability = @Danceability,
            Energy = @Energy,
            Loudness = @Loudness,
            Mode = @Mode,
            Speechiness = @Speechiness,
            Acousticness = @Acousticness,
            Instrumentalness = @Instrumentalness,
            Liveness = @Liveness,
            Valence = @Valence,
            Tempo = @Tempo
        WHERE Audio_Id = @AudioId;
    END
    ELSE
    BEGIN
        INSERT INTO tblAudioFeatures (Audio_Id, Danceability, Energy, Loudness, Mode, Speechiness, Acousticness, Instrumentalness, Liveness, Valence, Tempo)
        VALUES (@AudioId, @Danceability, @Energy, @Loudness, @Mode, @Speechiness, @Acousticness, @Instrumentalness, @Liveness, @Valence, @Tempo);
    END
END;




--------------------------------------------




---1. Trigger for After Insert/Update on Song to Maintain SongAudioFeature Relationship
CREATE TRIGGER trg_AfterInsertUpdateSong
ON tblSong
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @SongId INT;

    SELECT @SongId = inserted.SongId
    FROM inserted;

    -- Insert/Update logic for SongAudioFeature
    IF EXISTS (SELECT 1 FROM tblSongAudioFeature WHERE SongId = @SongId)
    BEGIN
        UPDATE tblSongAudioFeature
        SET AudioId = (SELECT Audio_Id FROM tblAudioFeatures WHERE AudioId = @SongId)
        WHERE SongId = @SongId;
    END
    ELSE
    BEGIN
        INSERT INTO tblSongAudioFeature (SongId, AudioId)
        VALUES (@SongId, (SELECT Audio_Id FROM tblAudioFeatures WHERE Audio_Id = @SongId));
    END
END;



---Trigger for After Insert/Update on Artist to Maintain ArtistSong Relationship
CREATE TRIGGER trg_AfterInsertUpdateArtist
ON tblArtist
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @ArtistId INT;
    SELECT @ArtistId = inserted.ArtistId
    FROM inserted;
    -- Insert/Update logic for ArtistSong
    IF EXISTS (SELECT 1 FROM tblArtistSong WHERE ArtistId = @ArtistId)
    BEGIN
        UPDATE tblArtistSong
        SET SongId = (SELECT SongId FROM Song WHERE SongId = @ArtistId)
        WHERE ArtistId = @ArtistId;
    END
    ELSE
    BEGIN
        INSERT INTO tblArtistSong (ArtistId, SongId)
        VALUES (@ArtistId, (SELECT SongId FROM Song WHERE SongId = @ArtistId));
    END
END;









