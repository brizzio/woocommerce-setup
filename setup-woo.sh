#!/usr/bin/env bash
set -e

# === CONFIGURAÇÕES INICIAIS ===
XAMPP_PATH="/c/xampp"
HTDOCS_PATH="$XAMPP_PATH/htdocs"
PHP_PATH="$XAMPP_PATH/php/php.exe"
MYSQL_PATH="$XAMPP_PATH/mysql/bin/mysql.exe"
WP_CLI="$HTDOCS_PATH/wp-cli.phar"

# === Pergunta o nome do site ===
read -p "Digite o nome do site (ex: meusite): " SITE
SITE_DIR="$HTDOCS_PATH/$SITE"
DB_NAME="${SITE}_db"
DB_USER="root"
DB_PASS=""

# === Cria pasta do site ===
mkdir -p "$SITE_DIR"
cd "$SITE_DIR"

echo "📁 Pasta criada: $SITE_DIR"

# === Baixa o WP-CLI se necessário ===
if [ ! -f "$WP_CLI" ]; then
  echo "⬇️  Baixando WP-CLI..."
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  mv wp-cli.phar "$WP_CLI"
fi

# === Cria banco de dados ===
echo "🧱 Criando banco de dados $DB_NAME..."
"$MYSQL_PATH" -u$DB_USER -p$DB_PASS -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# === Baixa o WordPress ===
echo "⬇️  Baixando WordPress..."
if [ -z "$DB_PASS" ]; then
  "$MYSQL_PATH" -u"$DB_USER" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
else
  "$MYSQL_PATH" -u"$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
fi
# === Cria arquivo de configuração ===
"$PHP_PATH" "$WP_CLI" config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="localhost" --skip-check

# === Instala WordPress ===
echo "⚙️ Instalando WordPress..."
"$PHP_PATH" "$WP_CLI" core install \
  --url="http://localhost/$SITE" \
  --title="$SITE" \
  --admin_user="admin" \
  --admin_password="admin" \
  --admin_email="admin@$SITE.local"

# === Instala WooCommerce ===
echo "🛒 Instalando WooCommerce..."
"$PHP_PATH" "$WP_CLI" plugin install woocommerce --activate

# === Cria e ativa child theme ===
THEME_NAME="storefront"  # tema base mais usado pelo WooCommerce
CHILD_DIR="wp-content/themes/${THEME_NAME}-child"
mkdir -p "$CHILD_DIR"

cat > "$CHILD_DIR/style.css" <<EOF
/*
Theme Name: ${THEME_NAME^} Child
Template: $THEME_NAME
Version: 1.0
*/
EOF

cat > "$CHILD_DIR/functions.php" <<'EOF'
<?php
add_action( 'wp_enqueue_scripts', function() {
    wp_enqueue_style( 'parent-style', get_template_directory_uri() . '/style.css' );
    wp_enqueue_style( 'child-style', get_stylesheet_uri(), array('parent-style') );
} );
EOF

# Instala o tema pai se não existir
"$PHP_PATH" "$WP_CLI" theme install $THEME_NAME --activate
"$PHP_PATH" "$WP_CLI" theme activate ${THEME_NAME}-child

echo "🎉 Instalação concluída!"
echo "➡️ Acesse: http://localhost/$SITE"
echo "Usuário: admin | Senha: admin"
