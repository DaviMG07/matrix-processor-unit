# Matrix Processor Unit (MPU)
### Coprocessador Aritmético Especializado em Operações Matriciais

## Sobre o Projeto
Este projeto apresenta o desenvolvimento de um coprocessador aritmético otimizado para operações matriciais, denominado **Matrix Processor Unit (MPU)**. O objetivo é implementar uma arquitetura eficiente para manipulação de matrizes, com foco em desempenho e flexibilidade.

## Equipe
- Davi Macêdo Gomes
- Victor Lopes

## Sumário
- [Recursos Utilizados](#recursos-utilizados)
- [Caminho de Dados](#caminho-de-dados)
- [Arquitetura do Conjunto de Instruções (ISA)](#arquitetura-do-conjunto-de-instruções-isa)
- [Máquina de Estados](#máquina-de-estados)
- [Unidade Lógica e Aritmética](#unidade-lógica-e-aritmética)
- [Memória](#memória)
- [Referências](#referências)

---

## Recursos Utilizados
- **Kit de Desenvolvimento**: De1-SoC
- **IDE**: Quartus
- **Compilador**: Icarus Verilog (utilizado para testes)

---

## Caminho de Dados
O **datapath** é o componente central do processador responsável pela manipulação dos dados durante a execução das instruções. Ele representa o "caminho" percorrido pelos dados dentro da CPU para serem processados. Abaixo, detalhamos seus principais componentes e seu funcionamento:

### Componentes do Datapath
- **Registradores**: Pequenas áreas de memória no processador que armazenam dados temporariamente, como valores em uso ou resultados intermediários.
- **ULA (Unidade Lógica e Aritmética)**: Executa operações matemáticas (soma, subtração) e lógicas (AND, OR, NOT), sendo o núcleo do processamento de dados.
- **Barramentos**: Conexões que permitem a transferência de dados entre registradores, ULA e memória.
- **Multiplexadores e Demultiplexadores**: Controlam o fluxo de dados, selecionando quais registradores serão lidos ou escritos em cada momento.

### Funcionamento
O datapath opera sob comando da **unidade de controle**, que emite sinais para determinar:
- Quais operações a ULA deve executar;
- Quais registradores devem ser acessados;
- Como os dados devem fluir entre os componentes.

Juntos, o datapath e a unidade de controle formam o núcleo do processador, garantindo a execução eficiente das instruções de um programa. Em resumo, o datapath é responsável pela manipulação prática dos dados, enquanto a unidade de controle coordena suas ações em cada etapa do ciclo de instrução.

> **Nota**: Inserir a imagem do datapath desenvolvido pela equipe aqui.  
> **Tarefa**: Explicar o datapath específico do projeto, detalhando sua implementação.

---

## Arquitetura do Conjunto de Instruções (ISA)
A **Instruction Set Architecture (ISA)** define a interface entre o hardware do processador e o software, especificando:

- **Conjunto de Instruções**: Operações aritméticas, lógicas, de controle e movimentação de dados.
- **Modos de Endereçamento**: Formas de acessar dados na memória ou registradores.
- **Formatos das Instruções**: Estrutura das instruções em termos de bits e campos.

### Exemplos de ISAs
- **x86**: Usada em processadores Intel e AMD.
- **ARM**: Comum em dispositivos móveis.
- **RISC-V**: Popular em projetos acadêmicos e industriais.

> **Tarefa**: Inserir tabelas com os formatos de instruções e suas codificações específicas do projeto.

---

## Máquina de Estados
A **máquina de estados** é um modelo que descreve o comportamento do processador ao executar instruções, transitando entre estados finitos com base em entradas ou eventos. No contexto do MPU, ela gerencia o **ciclo de instrução**, composto por cinco etapas: **FETCH**, **DECODE**, **EXECUTE**, **MEMORY** e **WRITE BACK**. A seguir, cada etapa é detalhada:

### 1. FETCH (Busca)
- **Descrição**: O processador recebe e guarda a instrução recebida num buffer.
- **Papel**: Inicia o ciclo, obtendo a instrução a ser processada.

### 2. DECODE (Decodificação)
- **Descrição**: A instrução é interpretada.
- **Detalhes**:
  - O **opcode** (código de operação) define a operação (ex.: soma, multiplicação).
  - Os **operandos** indicam os dados envolvidos.
  - Identifica os recursos necessários (memória).
- **Papel**: Traduz a instrução em comandos executáveis.

### 3. EXECUTE (Execução)
- **Descrição**: A operação especificada é realizada.
- **Detalhes**:
  - Envolve cálculos na ULA.
  - Gera resultados temporários, ainda não armazenados permanentemente.
- **Papel**: Executa a tarefa definida pela instrução.

### 4. MEMORY (Acesso à Memória)
- **Descrição**: Acessa a memória para leituras ou escritas, se necessário.
- **Detalhes**:
  - Usado nas instruções de **load** (carrega dados da memória) ou **store** (escreve dados na memória).
  - Etapa opcional, dependendo do tipo de instrução.
- **Papel**: Gerencia interações com a memória.

### 5. WRITE BACK (Escrita de Volta)
- **Descrição**: Armazena os resultados da execução.
- **Detalhes**:
  - Resultados são gravados na memória.
  - Garante que os dados estejam disponíveis para instruções futuras.
- **Papel**: Conclui o processamento da instrução.

### Funcionamento do Ciclo
A máquina de estados segue um fluxo sequencial:
1. Inicia em **FETCH** para buscar a instrução.
2. Passa para **DECODE** para interpretá-la.
3. Avança para **EXECUTE** para realizar a operação.
4. Executa **MEMORY**, se necessário.
5. Finaliza em **WRITE BACK** para salvar os resultados.

Após completar o ciclo, o processador retorna ao **FETCH** para a próxima instrução. Em arquiteturas avançadas com **pipeline**, essas etapas podem ser executadas simultaneamente para diferentes instruções, aumentando a eficiência.

> **Tarefa**: Explicar a máquina de estados específica do projeto, detalhando sua implementação.

---

## Unidade Lógica e Aritmética
### O que é a ALU?
A **Unidade Lógica e Aritmética (ALU)** é um componente essencial do processador, responsável por realizar operações matemáticas e lógicas. Em um processador tradicional, a ALU executa operações como:
- **Aritméticas**: Adição, subtração, multiplicação, divisão.
- **Lógicas**: AND, OR, NOT, XOR.

No contexto do **MPU**, a ALU é otimizada para operações matriciais, incluindo:
- Soma de matrizes
- Subtração de matrizes
- Multiplicação de matrizes
- Multiplicação por escalar
- Obtenção da matriz oposta
- Cálculo da matriz transposta

Essa especialização permite manipular conjuntos de dados organizados em formato matricial, em vez de apenas números escalares.

> **Tarefa**: Explicar cada operação matricial implementada na ALU do projeto.

---

## Referências
> **Tarefa**: Listar as referências bibliográficas ou recursos utilizados no projeto, seguindo um formato acadêmico (ex.: ABNT, APA).

