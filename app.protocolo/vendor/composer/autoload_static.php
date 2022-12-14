<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit5470b3d9c1802370f7b5691fc7e170d5
{
    public static $files = array (
        '0e6d7bf4a5811bfa5cf40c5ccd6fae6a' => __DIR__ . '/..' . '/symfony/polyfill-mbstring/bootstrap.php',
    );

    public static $prefixLengthsPsr4 = array (
        'h' => 
        array (
            'h4cc\\WKHTMLToPDF\\' => 17,
        ),
        'S' => 
        array (
            'Symfony\\Polyfill\\Mbstring\\' => 26,
            'Symfony\\Component\\Process\\' => 26,
        ),
        'R' => 
        array (
            'Respect\\Validation\\' => 19,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'h4cc\\WKHTMLToPDF\\' => 
        array (
            0 => __DIR__ . '/..' . '/h4cc/wkhtmltopdf-amd64',
        ),
        'Symfony\\Polyfill\\Mbstring\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/polyfill-mbstring',
        ),
        'Symfony\\Component\\Process\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/process',
        ),
        'Respect\\Validation\\' => 
        array (
            0 => __DIR__ . '/..' . '/respect/validation/library',
        ),
    );

    public static $prefixesPsr0 = array (
        'K' => 
        array (
            'Knp\\Snappy' => 
            array (
                0 => __DIR__ . '/..' . '/knplabs/knp-snappy/src',
            ),
        ),
        'H' => 
        array (
            'HTR' => 
            array (
                0 => __DIR__ . '/../..' . '/vendor',
            ),
        ),
        'A' => 
        array (
            'App' => 
            array (
                0 => __DIR__ . '/../..' . '/',
            ),
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit5470b3d9c1802370f7b5691fc7e170d5::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit5470b3d9c1802370f7b5691fc7e170d5::$prefixDirsPsr4;
            $loader->prefixesPsr0 = ComposerStaticInit5470b3d9c1802370f7b5691fc7e170d5::$prefixesPsr0;

        }, null, ClassLoader::class);
    }
}
