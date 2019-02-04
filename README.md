# README

O seguinte proposto no teste prático será implementado:
	- Deploy (será executado na web)

## Para executar essa aplicação você precisa de:

	* Ruby na versão 2.5.1

	* Framework Rails, na versão 5.2.2

	* Ruby Bundler, em versão 2.0.1

## Como executar o código.

	* Preparações iniciais (instruções para GNU/Linux - Debian based):
		* Instale o sqlite3, e sqlite3-dev (debian-based-distros): ` sudo apt install sqlite3 sqlite3-dev `

		* Instale as gems necessárias para desenvolvimento `bundle install --whithouth-production`

		* Realize o "migration" com `rails db:migrate`

		* Obtenha "SPOTIFY_KEY" e "SPOTIFY_SECRET", do website para desenvolvedores do Spotify

		* Insira os dados obtidos no arquivo './config/initializers/omniauth.rb' em suas respectivas posições

		* Execute os testes, para verificar se tudo está funcionando como deveria com `rails test`

		* Caso não haja erros, execute o servidor (development, local), com `rails server`

		* Acesse a aplicação através de um Browser (versão de demonstração), inserindo na barra de endereços: `localhost:8000`.

		* Para testes de API, realize as chamadas desejadas utilizando como URL base: `localhost:8000/api/v1`

## Algumas funcionalidades disponíveis

	* Ping (para confirmar que o servidor está sendo executado)

		* Efetue uma requisição GET, em `localhost:8000/api/v1/ping`

			* Se preferir pode utilizar o comando: `curl -X "GET" http://localhost:8000/api/v1/ping`

			* Caso tudo dê certo, verá algo como isso: {"status":200,"response":"API WORKING"}

	* Obter Autorização do Spotify

		* GET→'http://localhost:8000/api/v1/authorize-spotify'

	* Callback (utilizada pelo Spotify)

		* GET→'http://localhost:8000/api/v1/callback'
	
	* Lista de Artistas Seguidos

		* GET→'http://localhost:8000/api/v1/get-user-artists'