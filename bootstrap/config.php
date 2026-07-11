<?php
// Autoload dependencies
require_once __DIR__ . '/../vendor/autoload.php';
use Dotenv\Dotenv;
// Check if the .env file exists and load environment variables
if (file_exists(__DIR__ . '/../.env')) {
    $dotenv = Dotenv::createImmutable(__DIR__ . '/../');
    $dotenv->load();
}
