package Prosperity;

package com.prosperity.service;

import com.prosperity.dto.FinanceiroDTO;
import com.prosperity.entity.Financeiro;
import com.prosperity.repository.FinanceiroRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FinanceiroService {

    private final FinanceiroRepository repository;

    public Financeiro registrar(FinanceiroDTO dto) {
        Financeiro f = new Financeiro();
        f.setDescricao(dto.getDescricao());
        f.setValor(dto.getValor());
        f.setTipo(dto.getTipo());
        f.setData(dto.getData());
        return repository.save(f);
    }

    public List<Financeiro> listar() {
        return repository.findAll();
    }

    public double saldo() {
        return repository.findAll().stream()
                .mapToDouble(f -> f.getTipo().equals("ENTRADA") ? f.getValor() : -f.getValor())
                .sum();
    }
}
