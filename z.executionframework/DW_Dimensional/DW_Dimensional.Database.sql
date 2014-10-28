USE [master]
GO
CREATE DATABASE [DW_Dimensional]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DW_Dimensional', FILENAME = N'E:\MSSQL12.SQLDEV1\MSSQL\DATA\DW_Dimensional.mdf' , SIZE = 23053312KB , MAXSIZE = UNLIMITED, FILEGROWTH = 524288KB ), 
 FILEGROUP [data]  DEFAULT
( NAME = N'data', FILENAME = N'E:\MSSQL12.SQLDEV1\MSSQL\DATA\DW_Dimensional_data.mdf' , SIZE = 13696000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB ), 
 FILEGROUP [index] 
( NAME = N'index', FILENAME = N'E:\MSSQL12.SQLDEV1\MSSQL\DATA\DW_Dimensional_index.mdf' , SIZE = 18037760KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10240KB )
 LOG ON 
( NAME = N'DW_Dimensional_log', FILENAME = N'E:\MSSQL12.SQLDEV1\MSSQL\DATA\DW_Dimensional_log.ldf' , SIZE = 1072KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DW_Dimensional] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DW_Dimensional].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DW_Dimensional] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DW_Dimensional] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DW_Dimensional] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DW_Dimensional] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DW_Dimensional] SET ARITHABORT OFF 
GO
ALTER DATABASE [DW_Dimensional] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DW_Dimensional] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DW_Dimensional] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DW_Dimensional] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DW_Dimensional] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DW_Dimensional] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DW_Dimensional] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DW_Dimensional] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DW_Dimensional] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DW_Dimensional] SET  ENABLE_BROKER 
GO
ALTER DATABASE [DW_Dimensional] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DW_Dimensional] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DW_Dimensional] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DW_Dimensional] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DW_Dimensional] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DW_Dimensional] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DW_Dimensional] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DW_Dimensional] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DW_Dimensional] SET  MULTI_USER 
GO
ALTER DATABASE [DW_Dimensional] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DW_Dimensional] SET DB_CHAINING ON 
GO
ALTER DATABASE [DW_Dimensional] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DW_Dimensional] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [DW_Dimensional] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'DW_Dimensional', N'ON'
GO
USE [DW_Dimensional]
GO
EXEC [DW_Dimensional].sys.sp_addextendedproperty @name=N'Description', @value=N'Lumo EDW' 
GO
USE [master]
GO
ALTER DATABASE [DW_Dimensional] SET  READ_WRITE 
GO
