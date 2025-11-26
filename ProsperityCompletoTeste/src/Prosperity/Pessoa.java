package Prosperity;

public class Pessoa {
    // Encapsulamento: atributos privados
    private String nome;
    private String email;
    private String senha; // Em um sistema real, seria um hash
    private String cpf;

    // Construtor
    public Pessoa(String nome, String email, String senha, String cpf) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.cpf = cpf;
    }

    // Getters e Setters (métodos de acesso público para atributos privados)
    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCpf() {
        return cpf;
    }

    // Método comum a todas as Pessoas
    public void exibirDadosBasicos() {
        System.out.println("Nome: " + this.nome + ", Email: " + this.email);
    }
    
    // Método para simular a autenticação
    public boolean autenticar(String email, String senha) {
        return this.email.equalsIgnoreCase(email) && this.senha.equals(senha);
    }
}