FROM php:8.2-fpm

# Menyalin file composer ke dalam kontainer
COPY composer.* /var/www/laundryy-syifa/

# Mengatur direktori kerja
WORKDIR /var/www/laundryy-syifa

# Memasang dependensi sistem yang diperlukan
RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    zip \
    libicu-dev  # Menambahkan libicu-dev untuk intl

# Menginstal ekstensi PHP yang diperlukan
RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql gd zip intl  # Menambahkan intl di sini

# Membersihkan cache dan file yang tidak perlu
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Membuat grup dan pengguna
RUN groupadd -g 1000 www
RUN useradd -u 1000 -g www -s /bin/bash -m www

# Menyalin semua file aplikasi dan mengubah pemiliknya
COPY . .
COPY --chown=www:www . .

# Mengubah pengguna yang akan menjalankan aplikasi
USER www

# Mengekspos port untuk PHP-FPM
EXPOSE 9000

# Menjalankan PHP-FPM
CMD ["php-fpm"]
