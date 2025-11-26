package Prosperity;


// Importa todas as classes do modelo
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ClinicaApp {

    public static void main(String[] args) {
        // --- 1. Instanciação e Encapsulamento ---
        Dentista ana = new Dentista("Dra. Ana Costa", "dentista@clinica.com", "123", "999.888.777-66", "CRO/SP 12345", "Clínica Geral");
        Paciente joao = new Paciente("João Silva", "joao@silva.com", "123", "123.456.789-00", "Hipertenso", "Penicilina");
        Usuario admin = new Usuario("Admin Master", "admin@clinica.com", "123", "111.222.333-44", "Administrativo");

        System.out.println("--- 1. Demonstração de Encapsulamento e Herança ---");
        
        // Acessando dados via Getters (Encapsulamento)
        System.out.println("Email do Dentista: " + ana.getEmail());
        
        // Mudando um dado via Setter (Encapsulamento)
        joao.setNome("João S. de Oliveira");
        System.out.println("Novo Nome do Paciente: " + joao.getNome());
        
        // Herança: Todos usam o método da classe pai
        ana.exibirDadosBasicos();
        joao.exibirDadosBasicos();
        admin.exibirDadosBasicos();

        // --- 2. Demonstração de Polimorfismo ---
        // Criação de uma lista de Pessoas usando a classe pai
        List<Pessoa> pessoas = new ArrayList<>();
        pessoas.add(ana);
        pessoas.add(joao);
        pessoas.add(admin);

        System.out.println("\n--- 2. Demonstração de Polimorfismo (chamando exibirDadosBasicos) ---");
        for (Pessoa p : pessoas) {
            // A JVM decide qual método exibirDadosBasicos() chamar em tempo de execução
            p.exibirDadosBasicos(); 
        }

        // --- 3. Demonstração de Relacionamento e Serviço ---
        System.out.println("\n--- 3. Demonstração de Agendamento ---");
        
        LocalDateTime horaConsulta = LocalDateTime.of(2025, 11, 25, 9, 0);
        Agendamento agendamento1 = new Agendamento(horaConsulta, 60, joao, ana);
        
        System.out.println("Agendamento inicial: " + agendamento1.getDataHoraInicio() + " - Status: " + agendamento1.getStatus());
        
        // Uso do método de negócio (reagendar)
        LocalDateTime novaHoraConsulta = LocalDateTime.of(2025, 11, 26, 14, 30);
        agendamento1.reagendar(novaHoraConsulta);
        
        System.out.println("Agendamento final: " + agendamento1.getDataHoraInicio() + " - Status: " + agendamento1.getStatus());

        // --- 4. Simulação de Login ---
        System.out.println("\n--- 4. Simulação de Login ---");
        if (admin.autenticar("admin@clinica.com", "123")) {
            System.out.println("Login do Administrador bem-sucedido.");
        } else {
            System.out.println("Login do Administrador falhou.");
        }
    }
}