#!/usr/bin/env bash

echo -e "##### ##### ##### VERIFICANDO PRE REQUISITOS ##### ##### #####\n\n"

#  Checa se a ferramenta make está disponível no sistema

command -v make 1>- || {
  printf "Comando make não está disponível.
  Este programa possui um job de compilação contido em um Makefile, porém, este depende do comando make para ser executado.
  Consulte o link para maiores detalhes https://www.gnu.org/software/make/\n"
  exit 1
}

#  Checa se o compilador da linguagem GoLang está instalado no sistema

command -v go 1>- && {
  [[ $(go version) =~ ([0-9]\.?){3} ]] && {
  ((${BASH_REMATCH[2]} < 16)) && {
    echo -e "A versão mínima requerida para compilar este programa é go1.16, por favor atualize seu ambiente de desenvolvimento.
    Consulte o link para baixar uma versão atualizada: https://golang.org/dl/
    Versão do compilador Go encontrada: ${BASH_REMATCH[0]}\n"
 }
}
} || {
  echo -e "Compilador GO não encontrado.
  O Makefile utiliza somente instruções de compilação válidas para a distribuição padrão do Go, portanto o GCC GO não é suportado.
  Consulte o link para baixar o compilador Go https://golang.org/dl/\n"
  exit 1
}

#  Checa se o sistema possui o Google Chrome instalado.
#  É necessaŕio pois o chromedp utiliza-o no modo headless para efetuar o scrapping da página de administração do modem.

command -v google-chrome 1>- || {
  echo -e "Navegador Google Chrome não encontrado.
  A ferramenta de scrapping depende de uma instalação desse navegador e sua ausência tornam inúteis os binários compilados
  Consulte o link para baixá-lo https://www.google.com/intl/pt-BR/chrome/\n"
  exit 1
}

echo -e "\n##### ##### ##### PRE REQUISITOS SATISFEITOS ##### ##### #####

##### ##### ##### COMPILANDO OS BINÁRIOS PARA WINDOWS, lINUX E MACOS ##### ##### #####\n\n"

#  Exefuta os jobs de compilação presentes no arquivo Makefile.

make "-j$(grep siblings /proc/cpuinfo | awk 'NR==1 { print $NF }')" || {
  echo -e 'FALHA NA COMPILAÇÃO DO PROGRAMA. REVISE AS MENSAGENS DE ERRO APRESENTADAS NO TERMINAL E TENTE NOVAMENTE.\n' 
  exit 1
}

echo -e "##### ##### ##### BINÁRIOS COMPILADOS ##### ##### #####

##### ##### ##### LISTANDO OS ARQUIVOS COMPILADOS ##### ##### #####\n"

[[ -a /bin ]] && cd /bin
echo -e "Arquivos compilados no diretório: ${PWD}\n\n
##### ##### ##### TRABALHO FINALIZADO ##### ##### #####\n"

exit 0
