package Prosperity;

import java.time.LocalDateTime;

public class Agendamento {
    private LocalDateTime dataHoraInicio;
    private int duracaoMinutos;
    private Paciente paciente; // Relacionamento com Paciente
    private Dentista dentista; // Relacionamento com Dentista
    private String status; // Ex: Agendado, Confirmado, Cancelado

    public Agendamento(LocalDateTime dataHoraInicio, int duracaoMinutos, Paciente paciente, Dentista dentista) {
        this.dataHoraInicio = dataHoraInicio;
        this.duracaoMinutos = duracaoMinutos;
        this.paciente = paciente;
        this.dentista = dentista;
        this.status = "Agendado"; // Status inicial
    }

    // Métodos Getters e Setters (Encapsulamento)

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatus() {
        return status;
    }

    public LocalDateTime getDataHoraInicio() {
        return dataHoraInicio;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public Dentista getDentista() {
        return dentista;
    }

    // Método de Negócio/Serviço
    public void reagendar(LocalDateTime novaDataHora) {
        this.dataHoraInicio = novaDataHora;
        this.status = "Reagendado";
        System.out.println("Agendamento reagendado para: " + novaDataHora);
    }
}