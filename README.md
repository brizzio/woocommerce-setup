# WOOCOMMERCCE SETUP
setp a woocomerce site for local development

script Bash automatizado que:

Pergunta o nome do site (ex: meusite)

Cria a pasta C:\xampp\htdocs/meusite

Baixa e instala o WordPress

Cria um banco de dados MySQL com o mesmo nome

Baixa e ativa o WooCommerce

Cria e ativa um child theme pronto para desenvolvimento

Tudo de forma automática 💪

🧰 Pré-requisitos

Antes de rodar o script, você precisa garantir que:

XAMPP está instalado em C:\xampp

O PHP e o MySQL estão acessíveis via terminal (C:\xampp\php\php.exe e C:\xampp\mysql\bin\mysql.exe)

Você executa o script no Git Bash (ou WSL / PowerShell com suporte a Bash)

O WP-CLI está disponível (se não, o script baixa automaticamente)

Como rodar

Abra o Git Bash (ou WSL terminal)

Vá até o diretório onde salvou o script:

cd /c/xampp/htdocs


Dê permissão e execute:

chmod +x setup-woo.sh
./setup-woo.sh


Digite o nome do site quando solicitado, por exemplo:

meusite

🧾 O que o script faz

Cria /xampp/htdocs/meusite

Cria banco meusite_db

Baixa WordPress (pt-BR)

Instala WP (user: admin / pass: admin)

Instala e ativa WooCommerce

Instala tema Storefront e cria o child theme

Tudo configurado para http://localhost/meusite



