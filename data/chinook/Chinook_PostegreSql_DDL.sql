/*******************************************************************************
   Chinook Database - Version 1.4
   Script: Chinook_PostgreSql.sql
   Description: Creates and populates the Chinook database.
   DB Server: PostgreSql
   Author: Luis Rocha
   License: http://www.codeplex.com/ChinookDatabase/license
********************************************************************************/


/*******************************************************************************
   Create Tables
********************************************************************************/
CREATE TABLE album
(
    AlbumId INT NOT NULL,
    Title VARCHAR(160) NOT NULL,
    ArtistId INT NOT NULL,
    CONSTRAINT PK_Album PRIMARY KEY  (AlbumId)
);

CREATE TABLE artist
(
    ArtistId INT NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Artist PRIMARY KEY  (ArtistId)
);

CREATE TABLE customer
(
    CustomerId INT NOT NULL,
    FirstName VARCHAR(40) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Company VARCHAR(80),
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60) NOT NULL,
    SupportRepId INT,
    CONSTRAINT PK_Customer PRIMARY KEY  (CustomerId)
);

CREATE TABLE employee
(
    EmployeeId INT NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    Title VARCHAR(30),
    ReportsTo INT,
    BirthDate TIMESTAMP,
    HireDate TIMESTAMP,
    Address VARCHAR(70),
    City VARCHAR(40),
    State VARCHAR(40),
    Country VARCHAR(40),
    PostalCode VARCHAR(10),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    Email VARCHAR(60),
    CONSTRAINT PK_Employee PRIMARY KEY  (EmployeeId)
);

CREATE TABLE genre
(
    GenreId INT NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Genre PRIMARY KEY  (GenreId)
);

CREATE TABLE invoice
(
    InvoiceId INT NOT NULL,
    CustomerId INT NOT NULL,
    InvoiceDate TIMESTAMP NOT NULL,
    BillingAddress VARCHAR(70),
    BillingCity VARCHAR(40),
    BillingState VARCHAR(40),
    BillingCountry VARCHAR(40),
    BillingPostalCode VARCHAR(10),
    Total NUMERIC(10,2) NOT NULL,
    CONSTRAINT PK_Invoice PRIMARY KEY  (InvoiceId)
);

CREATE TABLE invoiceline
(
    InvoiceLineId INT NOT NULL,
    InvoiceId INT NOT NULL,
    TrackId INT NOT NULL,
    UnitPrice NUMERIC(10,2) NOT NULL,
    Quantity INT NOT NULL,
    CONSTRAINT PK_InvoiceLine PRIMARY KEY  (InvoiceLineId)
);

CREATE TABLE mediatype
(
    MediaTypeId INT NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_MediaType PRIMARY KEY  (MediaTypeId)
);

CREATE TABLE playlist
(
    PlaylistId INT NOT NULL,
    Name VARCHAR(120),
    CONSTRAINT PK_Playlist PRIMARY KEY  (PlaylistId)
);

CREATE TABLE playlisttrack
(
    PlaylistId INT NOT NULL,
    TrackId INT NOT NULL,
    CONSTRAINT PK_PlaylistTrack PRIMARY KEY  (PlaylistId, TrackId)
);

CREATE TABLE track
(
    TrackId INT NOT NULL,
    Name VARCHAR(200) NOT NULL,
    AlbumId INT,
    MediaTypeId INT NOT NULL,
    GenreId INT,
    Composer VARCHAR(220),
    Milliseconds INT NOT NULL,
    Bytes INT,
    UnitPrice NUMERIC(10,2) NOT NULL,
    CONSTRAINT PK_Track PRIMARY KEY  (TrackId)
);



/*******************************************************************************
   Create Primary Key Unique Indexes
********************************************************************************/

/*******************************************************************************
   Create Foreign Keys
********************************************************************************/
ALTER TABLE album ADD CONSTRAINT FK_AlbumArtistId
    FOREIGN KEY (ArtistId) REFERENCES artist (ArtistId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_AlbumArtistId ON album (ArtistId);

ALTER TABLE customer ADD CONSTRAINT FK_CustomerSupportRepId
    FOREIGN KEY (SupportRepId) REFERENCES employee (EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_CustomerSupportRepId ON customer (SupportRepId);

ALTER TABLE employee ADD CONSTRAINT FK_EmployeeReportsTo
    FOREIGN KEY (ReportsTo) REFERENCES employee (EmployeeId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_EmployeeReportsTo ON employee (ReportsTo);

ALTER TABLE invoice ADD CONSTRAINT FK_InvoiceCustomerId
    FOREIGN KEY (CustomerId) REFERENCES customer (CustomerId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_InvoiceCustomerId ON invoice (CustomerId);

ALTER TABLE invoiceline ADD CONSTRAINT FK_InvoiceLineInvoiceId
    FOREIGN KEY (InvoiceId) REFERENCES invoice (InvoiceId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_InvoiceLineInvoiceId ON invoiceline (InvoiceId);

ALTER TABLE invoiceline ADD CONSTRAINT FK_InvoiceLineTrackId
    FOREIGN KEY (TrackId) REFERENCES track (TrackId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_InvoiceLineTrackId ON invoiceline (TrackId);

ALTER TABLE playlisttrack ADD CONSTRAINT FK_PlaylistTrackPlaylistId
    FOREIGN KEY (PlaylistId) REFERENCES playlist (PlaylistId) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE playlisttrack ADD CONSTRAINT FK_PlaylistTrackTrackId
    FOREIGN KEY (TrackId) REFERENCES track (TrackId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_PlaylistTrackTrackId ON playlisttrack (TrackId);

ALTER TABLE track ADD CONSTRAINT FK_TrackAlbumId
    FOREIGN KEY (AlbumId) REFERENCES album (AlbumId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_TrackAlbumId ON track (AlbumId);

ALTER TABLE track ADD CONSTRAINT FK_TrackGenreId
    FOREIGN KEY (GenreId) REFERENCES genre (GenreId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_TrackGenreId ON track (GenreId);

ALTER TABLE track ADD CONSTRAINT FK_TrackMediaTypeId
    FOREIGN KEY (MediaTypeId) REFERENCES mediatype (MediaTypeId) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE INDEX IFK_TrackMediaTypeId ON track (MediaTypeId);
