package Prosperity;

public class Usuario {
	mport javax.persistence.*;
	import java.time.LocalDateTime;
import java.util.List;

	@Entity
	@Table(name = "USUARIO")
	public class Usuario {

	 @Id
	 @GeneratedValue(strategy = GenerationType.IDENTITY)
	 @Column(name = "ID_Usuario")
	 private Long id;

	 @Column(name = "Email", nullable = false, unique = true, length = 100)
	 private String email;

	 @Column(name = "Senha", nullable = false, length = 255)
	 private String senha;

	 @Column(name = "Tipo", nullable = false, length = 20)
	 private String tipo;O

	 @Column(name = "Data_Cadastro")
	 private LocalDateTime dataCadastro;

	 @OneToMany(mappedBy = "usuario")
	 private List<Paciente> pacientes;

	 @OneToMany(mappedBy = "usuario")
	 private List<Dentista> dentistas;

	 // getters e setters
	}

