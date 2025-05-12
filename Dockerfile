# Use uma versão específica do JDK 17 que sabemos ser compatível
FROM eclipse-temurin:17.0.9_9-jdk-jammy

WORKDIR /app

# Copia apenas os arquivos necessários para otimizar o cache de camadas
COPY pom.xml .
COPY mvnw .
COPY .mvn/ .mvn

# Baixa as dependências primeiro (cache eficiente)
RUN ./mvnw dependency:go-offline

# Copia o restante do código fonte
COPY src ./src

# Compila o projeto
RUN ./mvnw clean package -DskipTests

# Configuração de segurança - usuário não-root
RUN useradd -m myuser
USER myuser

# Comando de execução
ENTRYPOINT ["java", "-jar", "target/auth-0.0.1-SNAPSHOT.jar"]