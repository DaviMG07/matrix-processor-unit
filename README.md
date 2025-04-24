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

![Datapath](images/datapath.png)

Componentes do nosso datapath:
1. Buffer de Instrução
- recebe uma instrução de 32 bits e guarda em um registrador de 32 bits
2. Buffers da ULA
- possuem dois tipos de buffers da ula, de entrada e de saída; os buffers de entrada carregam dados de 16 bits vindos da memória; o buffer de saída envia dados de 16 bits por vez para a memória.
3. ULA 
- Executa as operações matriciais com os dados do buffer de entrada
- Após a execução, os dados do buffer de saída são enviados para a memória.
4. Memória
- Unidade responsável por armazenar os dados do processador de forma "fixa", ao contrário dos registradores
5. Unidade de controle
- Não necessariamente faz parte do datapath, mas é o componente principal de um processador.
- É onde a instrução é decodificada, e onde ocorre o ciclo FETCH, DECODE, EXECUTE, WRITE_BACK e MEMORY.
- responsável por enviar os sinais de controle do projeto.

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

Nossa ISA do coprocessador matricial:

para instrução de STORE temos este formato:
| OP_CODE | ID     | ROW    | COL    | DATA    | não usado |
| ------- | ------ | ------ | ------ | ------- | --------- |
| 4 bits  | 2 bits | 3 bits | 3 bits | 16 bits | 4 bits    |

para instruçãode LOAD temos este formato:
| OP_CODE | ID     | ROW    | COL    | não usado |
| ------- | ------ | ------ | ------ | --------- |
| 4 bits  | 2 bits | 3 bits | 3 bits | 20 bits   |

para as outras instruções aritméticas, temos este formato:
| OP_CODE | não usado |
| ------- | --------- |
| 4 bits  | 28 bits   |


codificação dos códigos de operação:
| OP_CODE         | CÓDIGO |
| --------------- | ------ |
| ADD             | 0000   |
| SUB             | 0001   |
| MUL             | 0010   |
| MULS(ESCALAR)   | 0011   |
| OPP             | 0100   |
| TRS(TRANSPOSTA) | 0101   |
| LOAD            | 0110   |
| STORE           | 0111   |

correspondência das matrizes e seus Ids:

| ID  | MATRIZ |
| --- | ------ |
| 0   | A      |
| 1   | B      |
| 2   | C      |
| 3   | -      |

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

![Máquina de Estados](images/fsm.png)

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

