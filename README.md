# URL Compressor

Este é um projeto Rails para encurtamento de URLs com histórico de acessos e autenticação para gerenciamento.

## 📝 Documentação
![DB Schema](https://github.com/luiz-ouroboros/url_compressor/blob/main/public/db.png)
Disclaimer: Com o objetivo de demonstração uma bazuca foi usada para acertar uma mosca

O start do projeto foi feito usando o GPT e o prompt pode ser verificado [aqui](https://chatgpt.com/share/67cceed6-e6d8-8013-8b27-3c1891d89f52)
Com o objetivo de demonstrar uma arquitetura exagonal optei por usar a gem [U-Case](https://github.com/serradura/u-case) que me permite estruturar os casos de uso de forma mais simples e descritiva, bem como extrair a logica de negócio facilitando assim a manutenção, escalabilidade e testabilidade do projeto. Para a validação e tipagem optei por usar a gem [dry-validation](https://github.com/dry-rb/dry-validation)

### Requisitos de negócio
- [x] [No cadastro, receber uma URL longa como parâmetro obrigatório.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/models/redirections/create.rb#L6)
- [x] [O encurtamento deve ser composto por no mínimo 5 e no máximo 10 caracteres.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/models/redirection.rb#L5)
- [x] [Apenas letras e números devem ser utilizados na composição da URL curta.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/models/redirection.rb#L13)
- [x] [Contar e armazenar a quantidade de acessos da URL curta.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/)
- [x] [Ter histórico de acesso da URL curta com a data de acesso.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/controllers/redirections_controller.rb#L27)
- [x] [A URL encurtada poderá ter data de expiração, neste caso, considere receber e validar esse parâmetro opcional.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/models/redirections/create.rb#L7)
- [x] [Ao acessar uma URL curta com data de expiração passada, devolver resposta como registro não encontrado.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/models/redirections/show.rb#L22)
- [x] Não é necessário frontend, apenas API.

### Requisitos técnicos
- [x] Deve ser uma API em json.
- [x] [Considere a melhor escolha dos verbos HTTP para cada cenário.](https://github.com/luiz-ouroboros/url_compressor/blob/92a1a965f4fdd6af088d918101ccf6e8a9470b56/config/routes.rb#L1)
- [x] [Não é necessário se preocupar com autenticação, mas se quiser implementar, nos mostre como você faria.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/app/controllers/redirections_controller.rb#L2)
- [x] Utilize o banco de dados e outras tecnologias de sua escolha para compor a solução proposta.
- [x] [É necessário que a sua solução execute em Docker.](https://github.com/luiz-ouroboros/url_compressor/blob/312579f2092437e238a57acbbb119b6fef980e30/docker-compose.yml)

## 📥 Clonando o repositório
```sh
git clone git@github.com:luiz-ouroboros/url_compressor.git
cd url_compressor
```

## ⚙️ Configuração
Edite as variáveis de ambiente no arquivo `.env` se necessário.

## 🚀 Subindo a aplicação
```sh
docker compose up -d
docker compose exec web rails db:create db:migrate
```

## ✅ Verificando se está tudo OK
```sh
docker compose exec web rspec
```

## 🔥 Experimentando
### Criando um redirecionamento
```sh
curl -X POST -H "Content-Type: application/json" \
     -d '{"target_url":"https://google.com"}' \
     http://localhost:3000/redirections > teste.json
```

### Acessando a URL encurtada
```sh
curl -L $(cat teste.json | jq -r .short_url)
```

### Consultando o histórico de requisições
```sh
curl http://localhost:3000/$(cat teste.json | jq -r .secret_key)/history
```

### Listando todos os redirecionamentos (requer autenticação)
```sh
curl -H "Authorization: Bearer your_secret_key_here" \
     http://localhost:3000/redirections
```

### Excluindo um redirecionamento
```sh
curl -X DELETE http://localhost:3000/$(cat teste.json | jq -r .secret_key)
```

---
## 🛑 Possíveis erros e correções
1. **Erro:** `jq: command not found`
   - **Solução:** Instale o `jq` para processar JSON:
     ```sh
     sudo apt install jq  # Ubuntu/Debian
     brew install jq  # macOS
     ```

2. **Erro:** `curl: (6) Could not resolve host`
   - **Solução:** Verifique se o Docker está rodando corretamente e se o servidor Rails está ativo.

3. **Erro:** `Authorization: Bearer your_secret_key_here` não funcionando
   - **Solução:** Certifique-se de que a `your_secret_key_here` corresponde a uma chave válida no sistema.

4. **Erro:** `docker compose exec web rails db:create db:migrate` falhando
   - **Solução:** Certifique-se de que o banco de dados está acessível e corretamente configurado no `.env`.

Acertei na mosca?
