<?php

return [
    /*
     * Debug Level:
     *
     * Production Mode:
     * false: No error messages, errors, or warnings shown.
     *
     * Development Mode:
     * true: Errors and warnings shown.
     */
    'debug' => filter_var(env('DEBUG', true), FILTER_VALIDATE_BOOLEAN),

    /*
     * Security and encryption configuration
     *
     * - salt - A random string used in security hashing methods.
     *   The salt value is also used as the encryption key.
     *   You should treat it as extremely sensitive data.
     */
    'Security' => [
        'salt' => env('SECURITY_SALT', '27b5e341bdc43662b0a93b5de16a33ca7a7fe85f967b0447c67b4f71787ff186'),
    ],

    /*
     * Connection information used by the ORM to connect
     * to your application's datastores.
     *
     * See app.php for more configuration options.
     *
     * 'url' => env('DATABASE_URL', null),
     */
    'Datasources' => [
        'default' => [
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '3306'),
            'database' => env('DB_DATABASE', 'workers_taskers'),
            'username' => env('DB_USERNAME', 'root'),
            'password' => env('DB_PASSWORD', 'root'),
            'unix_socket' => env('DB_SOCKET', ''),
            'url' => env('DATABASE_URL', null),
            'className' => 'Cake\Database\Connection',
            'driver' => 'Cake\Database\Driver\Mysql',
            'encoding' => 'utf8',
            'timezone' => 'UTC',
            'cacheMetadata' => true,
            'persistent' => false,
            'quoteIdentifiers' => false,
        ],
        /*
         * The test connection is used during the test suite.
         */
        'test' => [
            'host' => 'mysql',
            'username' => 'root',
            'password' => 'root',
            'database' => 'workers_taskers',
        ],
    ],

    /*
     * Email configuration.
     *
     * Host and credential configuration in case you are using SmtpTransport
     *
     * See app.php for more configuration options.
     */
    'EmailTransport' => [
        'default' => [
            'host' => 'localhost',
            'port' => 25,
            'username' => null,
            'password' => null,
            'client' => null,
            'url' => env('EMAIL_TRANSPORT_DEFAULT_URL', null),
        ],
    ],
];
