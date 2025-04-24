
# 🚀 Matrix Processor Unit (MPU)
### 💻 Coprocessador Aritmético Especializado em Operações Matriciais

## 🎯 Sobre o Projeto
O **Matrix Processor Unit (MPU)** é um coprocessador aritmético projetado para otimizar operações matriciais, oferecendo alta eficiência e flexibilidade. Este projeto descreve a implementação de uma arquitetura dedicada à manipulação de matrizes, com foco em desempenho para aplicações que exigem cálculos intensivos.

## 👥 Equipe
- 👨‍💻 Davi Macêdo Gomes  
- 👨‍💻 Victor Lopes

## 📑 Sumário
- [🔧 Recursos Utilizados](#recursos-utilizados)  
- [🛣️ Caminho de Dados](#caminho-de-dados)  
- [🏛️ Arquitetura do Conjunto de Instruções (ISA)](#arquitetura-do-conjunto-de-instruções-isa)  
- [🧩 Máquina de Estados](#máquina-de-estados)  
- [🔣 Unidade Lógica e Aritmética](#unidade-lógica-e-aritmética)  

---

## 🔧 Recursos Utilizados
- 🧰 **Kit de Desenvolvimento**: De1-SoC (FPGA)  
- 🖥️ **IDE**: Quartus Prime  
- 🛠️ **Compilador/Simulador**: Icarus Verilog (usado para simulação e testes)

---

## 🛣️ Caminho de Dados
O **caminho de dados (datapath)** é o núcleo operacional do MPU, responsável por processar os dados durante a execução de instruções. Ele define o fluxo de dados entre os componentes do processador, sob o comando da unidade de controle.

### 🧩 Componentes do Datapath
1. **Registradores** 🗄️: Armazenam temporariamente dados, como operandos e resultados intermediários.  
2. **Unidade Lógica e Aritmética (ULA)** ➕: Realiza operações matriciais, como soma, subtração e multiplicação.  
3. **Barramentos** 🚌: Conexões que transferem dados entre registradores, ULA e memória.  
4. **Multiplexadores/Demultiplexadores** 🔀: Gerenciam o fluxo de dados, selecionando fontes e destinos.  
5. **Memória** 💾: Armazena dados de forma persistente, diferente dos registradores temporários.  

### 🏗️ Estrutura do Datapath
- **Buffer de Instrução** 📥: Recebe e armazena instruções de 32 bits em um registrador.  
- **Buffers da ULA**:
  - **Entrada** 📤: Carregam dados de 16 bits da memória para a ULA.  
  - **Saída** 📥: Envia resultados de 16 bits da ULA para a memória.  
- **ULA** 🔣: Executa operações matriciais com os dados dos buffers de entrada e transfere resultados aos buffers de saída.  
- **Memória** 💽: Armazena matrizes e resultados de forma estruturada.  
- **Unidade de Controle** ⚙️: Coordena o datapath, decodificando instruções e gerenciando o ciclo de instrução (FETCH, DECODE, EXECUTE, MEMORY, WRITE_BACK).

### ⚙️ Funcionamento
O datapath opera em sincronia com a unidade de controle, que emite sinais para:
- 🎚️ Selecionar operações da ULA;  
- 🔒 Controlar o acesso a registradores e memória;  
- 🔄 Gerenciar o fluxo de dados entre componentes.  

O datapath e a unidade de controle formam o núcleo do MPU, garantindo a execução eficiente das instruções.

![Diagrama do Datapath](images/datapath.png)

---

## 🏛️ Arquitetura do Conjunto de Instruções (ISA)
A **Instruction Set Architecture (ISA)** define a interface entre o hardware do MPU e o software, especificando instruções, modos de endereçamento e formatos de dados.

### 🌟 Características da ISA
- ⚙️ **Instruções**: Operações aritméticas (soma, subtração, multiplicação), lógicas e de movimentação de dados (load, store).  
- 📍 **Modos de Endereçamento**: Acesso direto a registradores e memória, com identificação de linhas e colunas para matrizes.  
- 📝 **Formato das Instruções**: Estruturas de 32 bits divididas em campos (opcode, operandos, etc.).

### 📐 Formatos das Instruções
1. **Instrução STORE** (armazenamento de dados na memória):  
   | OP_CODE | ID | ROW | COL | DATA | Não Usado |  
   |---------|----|-----|-----|------|-----------|  
   | 4 bits  | 2 bits | 3 bits | 3 bits | 16 bits | 4 bits |  

2. **Instrução LOAD** (carregamento de dados da memória):  
   | OP_CODE | ID | ROW | COL | Não Usado |  
   |---------|----|-----|-----|-----------|  
   | 4 bits  | 2 bits | 3 bits | 3 bits | 20 bits |  

3. **Instruções Aritméticas** (operações matriciais):  
   | OP_CODE | Não Usado |  
   |---------|-----------|  
   | 4 bits  | 28 bits   |  

### 🔢 Códigos de Operação (OP_CODE)
| Instrução       | Código |  
|-----------------|--------|  
| ➕ ADD (Soma)      | 0000   |  
| ➖ SUB (Subtração) | 0001   |  
| ✖️ MUL (Multiplicação) | 0010 |  
| ✖️ MULS (Multiplicação Escalar) | 0011 |  
| 🔄 OPP (Oposta)    | 0100   |  
| 🔄 TRS (Transposta) | 0101 |  
| 📥 LOAD            | 0110   |  
| 📤 STORE           | 0111   |  

### 🆔 Identificadores de Matrizes (ID)
| ID | Matriz |  
|----|--------|  
| 0  | A      |  
| 1  | B      |  
| 2  | C      |  
| 3  | -      |  

### 🔍 Comparação com Outras ISAs
- **x86**: Complexa, usada em PCs (Intel/AMD).  
- **ARM**: Eficiente, comum em dispositivos móveis.  
- **RISC-V**: Simples e modular, ideal para projetos acadêmicos e industriais.  
A ISA do MPU é otimizada para operações matriciais, com instruções específicas e formato compacto.

---

## 🧩 Máquina de Estados
A **máquina de estados** gerencia o ciclo de instrução do MPU, transitando entre cinco estados: **FETCH**, **DECODE**, **EXECUTE**, **MEMORY** e **WRITE_BACK**. Cada estado desempenha uma função específica no processamento das instruções.

### 🔄 Etapas do Ciclo de Instrução
1. **FETCH (Busca)** 🚀  
   - A instrução de 32 bits é lida da memória e armazenada no buffer de instrução.  
   - Inicia o ciclo de processamento.  

2. **DECODE (Decodificação)** 📝  
   - A instrução é interpretada, identificando:  
     - **Opcode**: Define a operação (ex.: ADD, MUL).  
     - **Operandos**: Especifica os dados ou registradores envolvidos.  
   - A unidade de controle gera sinais para configurar o datapath.  

3. **EXECUTE (Execução)** ▶️  
   - A ULA realiza a operação especificada (ex.: soma ou multiplicação matricial).  
   - Resultados temporários são gerados e armazenados em buffers.  

4. **MEMORY (Acesso à Memória)** 🗄️  
   - Gerencia operações de leitura (LOAD) ou escrita (STORE) na memória.  
   - Etapa opcional, usada apenas por instruções que acessam memória.  

5. **WRITE_BACK (Escrita de Volta)** ✔️  
   - Os resultados finais são gravados na memória ou em registradores.  
   - Conclui o ciclo, preparando o processador para a próxima instrução.  

### 🔁 Funcionamento
A máquina de estados segue um fluxo sequencial, retornando ao **FETCH** após o **WRITE_BACK**. Em arquiteturas com pipeline, as etapas podem ser executadas simultaneamente para diferentes instruções, aumentando o desempenho.

![Diagrama da Máquina de Estados](images/fsm.png)

---

## 🔣 Unidade Lógica e Aritmética (ULA)
A **Unidade Lógica e Aritmética (ULA)** é o componente central do MPU, otimizado para operações matriciais. Diferentemente de ULAs tradicionais, que processam escalares, a ULA do MPU manipula matrizes diretamente.

### 🧮 Operações Implementadas
1. ➕ **Soma de Matrizes (ADD)**  
   - Soma elemento a elemento de duas matrizes (A + B = C) de forma paralela.  
   - Exemplo: C[i,j] = A[i,j] + B[i,j].  

2. ➖ **Subtração de Matrizes (SUB)**  
   - Subtrai elemento a elemento (A - B = C) de forma paralela.  
   - Exemplo: C[i,j] = A[i,j] - B[i,j].  

3. ✖️ **Multiplicação de Matrizes (MUL)**  
   - Realiza a multiplicação matricial padrão (A × B = C), paralelizando linhas e iterando internamente.  
   - Exemplo: C[i,j] = Σ(A[i,k] × B[k,j]).  

4. 🌐 **Multiplicação por Escalar (MULS)**  
   - Multiplica cada elemento de uma matriz por um valor escalar de forma paralela.  
   - Exemplo: C[i,j] = k × A[i,j].  

5. 🔁 **Matriz Oposta (OPP)**  
   - Calcula a matriz oposta, negando cada elemento de forma paralela.  
   - Exemplo: C[i,j] = -A[i,j].  

6. 🔄 **Matriz Transposta (TRS)**  
   - Inverte linhas e colunas de uma matriz de forma paralela.  
   - Exemplo: C[i,j] = A[j,i].  


