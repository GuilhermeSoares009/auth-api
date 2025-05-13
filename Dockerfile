FROM eclipse-temurin:17.0.9_9-jdk-jammy

WORKDIR /app

# Copia os arquivos do Maven Wrapper
COPY pom.xml .
COPY mvnw .
COPY .mvn/ .mvn

# Converte quebras de linha (CRLF → LF) e dá permissão de execução
RUN sed -i 's/\r$//' mvnw && \
    chmod +x mvnw

# Baixa dependências (cache eficiente)
RUN ./mvnw dependency:go-offline

# Copia o código fonte
COPY src ./src

# Compila o projeto
RUN ./mvnw clean package -DskipTests

# Configura usuário não-root (segurança)
RUN useradd -m myuser
USER myuser

ENTRYPOINT ["java", "-jar", "target/auth-0.0.1-SNAPSHOT.jar"]